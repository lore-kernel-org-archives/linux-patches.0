Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1727C274B43;
	Thu, 15 Jan 2026 16:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496237; cv=none; b=dsTg3MIBeWVeC+LQ6PDm3c3mk0XA10CZt1KFqALWav1t+NcYa4kJ+SMaP4IoVANe2JAARGXh0eWGfubCHTDeGCS3mdB00U6JcT3L9SpYu66DSbWrUMqg6pBT0fTWQMEyWykQUEQurKaARNvcYKVGx+6Ttb+aFfpnpRbcYgApUhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496237; c=relaxed/simple;
	bh=y7x1OaW2XvCKnh69jNXD9garA4G96UiBktTzMVkPGvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgRdgSwXzf99xNrYXH2rFqA8r4uKjmCqwsLN/f9tk2RJBHa+nSLpXl+NiaiuuRSVy7ozK4p3USiHhYw2mwEJP3bQSEN8gC2CEkXzIlQ9ghi93OR0JYQACEIM3uLhQZkWCM/gMKkBvTG4m1XAAtwDVz+i1v+9Ck4JeHzw/5qRaHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5XSAxeA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5XSAxeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A4CC16AAE;
	Thu, 15 Jan 2026 16:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496237;
	bh=y7x1OaW2XvCKnh69jNXD9garA4G96UiBktTzMVkPGvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5XSAxeAv3R2YslgqqZKpyXB7Tf1htoHNDDedZ9yMBZT32iw4bSfh+So77Hi+Hc9E
	 s/o0cfroVI5CdFgotuN04XQEQG7C8azAS2Ff7iJ6KwQCjIxBRjDjSUie8+3egJzLwa
	 JqqD0g9Q2xjZi0HemLvNQ8BOK4/o8QbSAGn2hd3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 125/181] idpf: detach and close netdevs while handling a reset
Date: Thu, 15 Jan 2026 17:47:42 +0100
Message-ID: <20260115164206.828717913@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Tantilov <emil.s.tantilov@intel.com>

[ Upstream commit 2e281e1155fc476c571c0bd2ffbfe28ab829a5c3 ]

Protect the reset path from callbacks by setting the netdevs to detached
state and close any netdevs in UP state until the reset handling has
completed. During a reset, the driver will de-allocate resources for the
vport, and there is no guarantee that those will recover, which is why the
existing vport_ctrl_lock does not provide sufficient protection.

idpf_detach_and_close() is called right before reset handling. If the
reset handling succeeds, the netdevs state is recovered via call to
idpf_attach_and_open(). If the reset handling fails the netdevs remain
down. The detach/down calls are protected with RTNL lock to avoid racing
with callbacks. On the recovery side the attach can be done without
holding the RTNL lock as there are no callbacks expected at that point,
due to detach/close always being done first in that flow.

The previous logic restoring the netdevs state based on the
IDPF_VPORT_UP_REQUESTED flag in the init task is not needed anymore, hence
the removal of idpf_set_vport_state(). The IDPF_VPORT_UP_REQUESTED is
still being used to restore the state of the netdevs following the reset,
but has no use outside of the reset handling flow.

idpf_init_hard_reset() is converted to void, since it was used as such and
there is no error handling being done based on its return value.

Before this change, invoking hard and soft resets simultaneously will
cause the driver to lose the vport state:
ip -br a
<inf>	UP
echo 1 > /sys/class/net/ens801f0/device/reset& \
ethtool -L ens801f0 combined 8
ip -br a
<inf>	DOWN
ip link set <inf> up
ip -br a
<inf>	DOWN

Also in case of a failure in the reset path, the netdev is left
exposed to external callbacks, while vport resources are not
initialized, leading to a crash on subsequent ifup/down:
[408471.398966] idpf 0000:83:00.0: HW reset detected
[408471.411744] idpf 0000:83:00.0: Device HW Reset initiated
[408472.277901] idpf 0000:83:00.0: The driver was unable to contact the device's firmware. Check that the FW is running. Driver state= 0x2
[408508.125551] BUG: kernel NULL pointer dereference, address: 0000000000000078
[408508.126112] #PF: supervisor read access in kernel mode
[408508.126687] #PF: error_code(0x0000) - not-present page
[408508.127256] PGD 2aae2f067 P4D 0
[408508.127824] Oops: Oops: 0000 [#1] SMP NOPTI
...
[408508.130871] RIP: 0010:idpf_stop+0x39/0x70 [idpf]
...
[408508.139193] Call Trace:
[408508.139637]  <TASK>
[408508.140077]  __dev_close_many+0xbb/0x260
[408508.140533]  __dev_change_flags+0x1cf/0x280
[408508.140987]  netif_change_flags+0x26/0x70
[408508.141434]  dev_change_flags+0x3d/0xb0
[408508.141878]  devinet_ioctl+0x460/0x890
[408508.142321]  inet_ioctl+0x18e/0x1d0
[408508.142762]  ? _copy_to_user+0x22/0x70
[408508.143207]  sock_do_ioctl+0x3d/0xe0
[408508.143652]  sock_ioctl+0x10e/0x330
[408508.144091]  ? find_held_lock+0x2b/0x80
[408508.144537]  __x64_sys_ioctl+0x96/0xe0
[408508.144979]  do_syscall_64+0x79/0x3d0
[408508.145415]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[408508.145860] RIP: 0033:0x7f3e0bb4caff

Fixes: 0fe45467a104 ("idpf: add create vport and netdev configuration")
Signed-off-by: Emil Tantilov <emil.s.tantilov@intel.com>
Reviewed-by: Madhu Chittim <madhu.chittim@intel.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_lib.c | 121 ++++++++++++---------
 1 file changed, 72 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index 313803c088478..a964e0f5891eb 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -729,6 +729,65 @@ static int idpf_init_mac_addr(struct idpf_vport *vport,
 	return 0;
 }
 
+static void idpf_detach_and_close(struct idpf_adapter *adapter)
+{
+	int max_vports = adapter->max_vports;
+
+	for (int i = 0; i < max_vports; i++) {
+		struct net_device *netdev = adapter->netdevs[i];
+
+		/* If the interface is in detached state, that means the
+		 * previous reset was not handled successfully for this
+		 * vport.
+		 */
+		if (!netif_device_present(netdev))
+			continue;
+
+		/* Hold RTNL to protect racing with callbacks */
+		rtnl_lock();
+		netif_device_detach(netdev);
+		if (netif_running(netdev)) {
+			set_bit(IDPF_VPORT_UP_REQUESTED,
+				adapter->vport_config[i]->flags);
+			dev_close(netdev);
+		}
+		rtnl_unlock();
+	}
+}
+
+static void idpf_attach_and_open(struct idpf_adapter *adapter)
+{
+	int max_vports = adapter->max_vports;
+
+	for (int i = 0; i < max_vports; i++) {
+		struct idpf_vport *vport = adapter->vports[i];
+		struct idpf_vport_config *vport_config;
+		struct net_device *netdev;
+
+		/* In case of a critical error in the init task, the vport
+		 * will be freed. Only continue to restore the netdevs
+		 * if the vport is allocated.
+		 */
+		if (!vport)
+			continue;
+
+		/* No need for RTNL on attach as this function is called
+		 * following detach and dev_close(). We do take RTNL for
+		 * dev_open() below as it can race with external callbacks
+		 * following the call to netif_device_attach().
+		 */
+		netdev = adapter->netdevs[i];
+		netif_device_attach(netdev);
+		vport_config = adapter->vport_config[vport->idx];
+		if (test_and_clear_bit(IDPF_VPORT_UP_REQUESTED,
+				       vport_config->flags)) {
+			rtnl_lock();
+			dev_open(netdev, NULL);
+			rtnl_unlock();
+		}
+	}
+}
+
 /**
  * idpf_cfg_netdev - Allocate, configure and register a netdev
  * @vport: main vport structure
@@ -1041,10 +1100,11 @@ static void idpf_vport_dealloc(struct idpf_vport *vport)
 	idpf_idc_deinit_vport_aux_device(vport->vdev_info);
 
 	idpf_deinit_mac_addr(vport);
-	idpf_vport_stop(vport, true);
 
-	if (!test_bit(IDPF_HR_RESET_IN_PROG, adapter->flags))
+	if (!test_bit(IDPF_HR_RESET_IN_PROG, adapter->flags)) {
+		idpf_vport_stop(vport, true);
 		idpf_decfg_netdev(vport);
+	}
 	if (test_bit(IDPF_REMOVE_IN_PROG, adapter->flags))
 		idpf_del_all_mac_filters(vport);
 
@@ -1544,7 +1604,6 @@ void idpf_init_task(struct work_struct *work)
 	struct idpf_vport_config *vport_config;
 	struct idpf_vport_max_q max_q;
 	struct idpf_adapter *adapter;
-	struct idpf_netdev_priv *np;
 	struct idpf_vport *vport;
 	u16 num_default_vports;
 	struct pci_dev *pdev;
@@ -1600,12 +1659,6 @@ void idpf_init_task(struct work_struct *work)
 	if (idpf_cfg_netdev(vport))
 		goto unwind_vports;
 
-	/* Once state is put into DOWN, driver is ready for dev_open */
-	np = netdev_priv(vport->netdev);
-	clear_bit(IDPF_VPORT_UP, np->state);
-	if (test_and_clear_bit(IDPF_VPORT_UP_REQUESTED, vport_config->flags))
-		idpf_vport_open(vport, true);
-
 	/* Spawn and return 'idpf_init_task' work queue until all the
 	 * default vports are created
 	 */
@@ -1781,27 +1834,6 @@ static int idpf_check_reset_complete(struct idpf_hw *hw,
 	return -EBUSY;
 }
 
-/**
- * idpf_set_vport_state - Set the vport state to be after the reset
- * @adapter: Driver specific private structure
- */
-static void idpf_set_vport_state(struct idpf_adapter *adapter)
-{
-	u16 i;
-
-	for (i = 0; i < adapter->max_vports; i++) {
-		struct idpf_netdev_priv *np;
-
-		if (!adapter->netdevs[i])
-			continue;
-
-		np = netdev_priv(adapter->netdevs[i]);
-		if (test_bit(IDPF_VPORT_UP, np->state))
-			set_bit(IDPF_VPORT_UP_REQUESTED,
-				adapter->vport_config[i]->flags);
-	}
-}
-
 /**
  * idpf_init_hard_reset - Initiate a hardware reset
  * @adapter: Driver specific private structure
@@ -1810,28 +1842,17 @@ static void idpf_set_vport_state(struct idpf_adapter *adapter)
  * reallocate. Also reinitialize the mailbox. Return 0 on success,
  * negative on failure.
  */
-static int idpf_init_hard_reset(struct idpf_adapter *adapter)
+static void idpf_init_hard_reset(struct idpf_adapter *adapter)
 {
 	struct idpf_reg_ops *reg_ops = &adapter->dev_ops.reg_ops;
 	struct device *dev = &adapter->pdev->dev;
-	struct net_device *netdev;
 	int err;
-	u16 i;
 
+	idpf_detach_and_close(adapter);
 	mutex_lock(&adapter->vport_ctrl_lock);
 
 	dev_info(dev, "Device HW Reset initiated\n");
 
-	/* Avoid TX hangs on reset */
-	for (i = 0; i < adapter->max_vports; i++) {
-		netdev = adapter->netdevs[i];
-		if (!netdev)
-			continue;
-
-		netif_carrier_off(netdev);
-		netif_tx_disable(netdev);
-	}
-
 	/* Prepare for reset */
 	if (test_and_clear_bit(IDPF_HR_DRV_LOAD, adapter->flags)) {
 		reg_ops->trigger_reset(adapter, IDPF_HR_DRV_LOAD);
@@ -1840,7 +1861,6 @@ static int idpf_init_hard_reset(struct idpf_adapter *adapter)
 
 		idpf_idc_issue_reset_event(adapter->cdev_info);
 
-		idpf_set_vport_state(adapter);
 		idpf_vc_core_deinit(adapter);
 		if (!is_reset)
 			reg_ops->trigger_reset(adapter, IDPF_HR_FUNC_RESET);
@@ -1887,11 +1907,14 @@ static int idpf_init_hard_reset(struct idpf_adapter *adapter)
 unlock_mutex:
 	mutex_unlock(&adapter->vport_ctrl_lock);
 
-	/* Wait until all vports are created to init RDMA CORE AUX */
-	if (!err)
-		err = idpf_idc_init(adapter);
-
-	return err;
+	/* Attempt to restore netdevs and initialize RDMA CORE AUX device,
+	 * provided vc_core_init succeeded. It is still possible that
+	 * vports are not allocated at this point if the init task failed.
+	 */
+	if (!err) {
+		idpf_attach_and_open(adapter);
+		idpf_idc_init(adapter);
+	}
 }
 
 /**
-- 
2.51.0



