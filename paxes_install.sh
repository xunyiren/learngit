## use current shell run script
# Save trace setting
XTRACE=$(set +o | grep xtrace)
set +o xtrace
# Keep track of the devstack directory
TOP_DIR=$(cd $(dirname "$0") && pwd)
echo "##INFO: Current run directory: $TOP_DIR"

CURRENT_SHELL=$(ps -ef | awk '{print $2$8}' |grep `echo $$`| tr -d [0-9-])
echo "##INFO: Current shell is $CURRENT_SHELL"
echo ""

CURRENT_VENDOR=$(uname -s)
if [[ "$CURRENT_VENDOR" == "AIX" ]]; then
    # Install package requirements
    # Source it so the entire environment is available
    echo "Installing package prerequisites"
    chmod +x $TOP_DIR/tools/install_aix_prereqs.sh
    $TOP_DIR/tools/install_aix_prereqs.sh
fi

#判断bash 是否安装 利用rpm 查询
rpm -q bash &>/dev/null
if [[ $? -eq 0 ]]; then
    echo "##INFO: Current system installed bash"
else
    echo "##ERR: install bash error"
    exit 1
fi

if [[ "$CURRENT_VENDOR" == "AIX" ]]; then
    echo "##INFO: In aix running install..."
    chmod +x $TOP_DIR/aix_install_nova.sh
    $TOP_DIR/aix_install_nova.sh
elif [[ "$CURRENT_VENDOR" == "Linux" ]]; then
    echo "##INFO: In linux running install..."
    chmod +x $TOP_DIR/linux_install.sh
    $TOP_DIR/linux_install.sh
else
    echo "##ERR: Unable to identify current system"
    exit 1
fi

# Restore xtrace
$XTRACE
## end shell script
