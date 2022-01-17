#!/bin/zsh

# How to install:
# 1. Download this script into your home folder
# 2. Add this line to your .zshrc: [[ -s "$HOME/.auto-nvm-use.sh" ]] && source "$HOME/.auto-nvm-use.sh"

autoload -U add-zsh-hook

use-node-version() {
    AVN_NODE_VERSION_FILE=.node-version
    NVM_NODE_VERSION_FILE=.nvmrc
    CURRENT_NODE_VERSION=$(nvm version)
    NODE_VERSION_TO_USE="default"

    if test -f "$AVN_NODE_VERSION_FILE"; then
        read -r NODE_VERSION_TO_USE < $AVN_NODE_VERSION_FILE
    elif test -f "$NVM_NODE_VERSION_FILE"; then
        # if no .node-version file is found try .nvmrc
        read -r NODE_VERSION_TO_USE < $NVM_NODE_VERSION_FILE
    else
        return # Quit silently if no node version config found
    fi

    # Transforms the string inside the .node-version or .nvmrc file into one that's comparable to the output of "nvm version"
    # The nvm_match_version function is provided by nvm
    NORMALISED_NODE_VERSION=$(nvm_match_version "$NODE_VERSION_TO_USE")

    # Only call "nvm use" if we're not on the configured node version already
    if [[ $CURRENT_NODE_VERSION != $NORMALISED_NODE_VERSION ]]; then
        nvm use "$NODE_VERSION_TO_USE"
    fi
}

# execute use-node-version on every "cd" command
add-zsh-hook chpwd use-node-version

# Helpful stackoverflow answer about the chpwd zsh hook: https://stackoverflow.com/a/45444758
# Other powerful script on github: https://gist.github.com/callumlocke/30990e247e52ab6ac1aa98e5f0e5bbf5
# Interesting gist about lazy loading nvm: https://gist.github.com/fl0w/07ce79bd44788f647deab307c94d6922
# Checked with https://www.shellcheck.net/
