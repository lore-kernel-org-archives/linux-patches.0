Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457EB1D157;
	Mon, 18 Dec 2023 14:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kv/2qpvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFE4C433C8;
	Mon, 18 Dec 2023 14:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908068;
	bh=RINQCXj8CXbNxQea73LnSpkCSYTBPb/VpdqmPxo/stk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kv/2qpvFb6uf11fz7r9xLh9Jsu/Qqja8pHuoBKMisdOWSL+AeOLqmjOS9Yj8hA3yy
	 wiVZtFsvBYlwYoCB0zQnVOBaXadEi8jVwWEMVEha6DXD2mWqYH36/uEvPmrAyEXnlD
	 8phd2cTFNFZu0vyW7WFm3oy/SFhv0vgN87VUqMzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slawomir Laba <slawomirx.laba@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Ranganatha Rao <ranganatha.rao@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/166] iavf: Fix iavf_shutdown to call iavf_remove instead iavf_close
Date: Mon, 18 Dec 2023 14:50:07 +0100
Message-ID: <20231218135106.832986169@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Slawomir Laba <slawomirx.laba@intel.com>

[ Upstream commit 7ae42ef308ed0f6250b36f43e4eeb182ebbe6215 ]

Make the flow for pci shutdown be the same to the pci remove.

iavf_shutdown was implementing an incomplete version
of iavf_remove. It misses several calls to the kernel like
iavf_free_misc_irq, iavf_reset_interrupt_capability, iounmap
that might break the system on reboot or hibernation.

Implement the call of iavf_remove directly in iavf_shutdown to
close this gap.

Fixes below error messages (dmesg) during shutdown stress tests -
[685814.900917] ice 0000:88:00.0: MAC 02:d0:5f:82:43:5d does not exist for
 VF 0
[685814.900928] ice 0000:88:00.0: MAC 33:33:00:00:00:01 does not exist for
VF 0

Reproduction:

1. Create one VF interface:
echo 1 > /sys/class/net/<interface_name>/device/sriov_numvfs

2. Run live dmesg on the host:
dmesg -wH

3. On SUT, script below steps into vf_namespace_assignment.sh

<#!/bin/sh> // Remove <>. Git removes # line
if=<VF name> (edit this per VF name)
loop=0

while true; do

echo test round $loop
let loop++

ip netns add ns$loop
ip link set dev $if up
ip link set dev $if netns ns$loop
ip netns exec ns$loop ip link set dev $if up
ip netns exec ns$loop ip link set dev $if netns 1
ip netns delete ns$loop

done

4. Run the script for at least 1000 iterations on SUT:
./vf_namespace_assignment.sh

Expected result:
No errors in dmesg.

Fixes: 129cf89e5856 ("iavf: rename functions and structs to new name")
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Ahmed Zaki <ahmed.zaki@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Co-developed-by: Ranganatha Rao <ranganatha.rao@intel.com>
Signed-off-by: Ranganatha Rao <ranganatha.rao@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 72 ++++++---------------
 1 file changed, 21 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index af8eb27a3615c..257865647c865 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -277,27 +277,6 @@ void iavf_free_virt_mem(struct iavf_hw *hw, struct iavf_virt_mem *mem)
 	kfree(mem->va);
 }
 
-/**
- * iavf_lock_timeout - try to lock mutex but give up after timeout
- * @lock: mutex that should be locked
- * @msecs: timeout in msecs
- *
- * Returns 0 on success, negative on failure
- **/
-static int iavf_lock_timeout(struct mutex *lock, unsigned int msecs)
-{
-	unsigned int wait, delay = 10;
-
-	for (wait = 0; wait < msecs; wait += delay) {
-		if (mutex_trylock(lock))
-			return 0;
-
-		msleep(delay);
-	}
-
-	return -1;
-}
-
 /**
  * iavf_schedule_reset - Set the flags and schedule a reset event
  * @adapter: board private structure
@@ -4925,34 +4904,6 @@ int iavf_process_config(struct iavf_adapter *adapter)
 	return 0;
 }
 
-/**
- * iavf_shutdown - Shutdown the device in preparation for a reboot
- * @pdev: pci device structure
- **/
-static void iavf_shutdown(struct pci_dev *pdev)
-{
-	struct iavf_adapter *adapter = iavf_pdev_to_adapter(pdev);
-	struct net_device *netdev = adapter->netdev;
-
-	netif_device_detach(netdev);
-
-	if (netif_running(netdev))
-		iavf_close(netdev);
-
-	if (iavf_lock_timeout(&adapter->crit_lock, 5000))
-		dev_warn(&adapter->pdev->dev, "%s: failed to acquire crit_lock\n", __func__);
-	/* Prevent the watchdog from running. */
-	iavf_change_state(adapter, __IAVF_REMOVE);
-	adapter->aq_required = 0;
-	mutex_unlock(&adapter->crit_lock);
-
-#ifdef CONFIG_PM
-	pci_save_state(pdev);
-
-#endif
-	pci_disable_device(pdev);
-}
-
 /**
  * iavf_probe - Device Initialization Routine
  * @pdev: PCI device information struct
@@ -5166,17 +5117,22 @@ static int __maybe_unused iavf_resume(struct device *dev_d)
  **/
 static void iavf_remove(struct pci_dev *pdev)
 {
-	struct iavf_adapter *adapter = iavf_pdev_to_adapter(pdev);
 	struct iavf_fdir_fltr *fdir, *fdirtmp;
 	struct iavf_vlan_filter *vlf, *vlftmp;
 	struct iavf_cloud_filter *cf, *cftmp;
 	struct iavf_adv_rss *rss, *rsstmp;
 	struct iavf_mac_filter *f, *ftmp;
+	struct iavf_adapter *adapter;
 	struct net_device *netdev;
 	struct iavf_hw *hw;
 	int err;
 
-	netdev = adapter->netdev;
+	/* Don't proceed with remove if netdev is already freed */
+	netdev = pci_get_drvdata(pdev);
+	if (!netdev)
+		return;
+
+	adapter = iavf_pdev_to_adapter(pdev);
 	hw = &adapter->hw;
 
 	if (test_and_set_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section))
@@ -5304,11 +5260,25 @@ static void iavf_remove(struct pci_dev *pdev)
 
 	destroy_workqueue(adapter->wq);
 
+	pci_set_drvdata(pdev, NULL);
+
 	free_netdev(netdev);
 
 	pci_disable_device(pdev);
 }
 
+/**
+ * iavf_shutdown - Shutdown the device in preparation for a reboot
+ * @pdev: pci device structure
+ **/
+static void iavf_shutdown(struct pci_dev *pdev)
+{
+	iavf_remove(pdev);
+
+	if (system_state == SYSTEM_POWER_OFF)
+		pci_set_power_state(pdev, PCI_D3hot);
+}
+
 static SIMPLE_DEV_PM_OPS(iavf_pm_ops, iavf_suspend, iavf_resume);
 
 static struct pci_driver iavf_driver = {
-- 
2.43.0



