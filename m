Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCD22F0C52;
	Mon, 22 Sep 2025 19:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570168; cv=none; b=gUQbgbHvhQiENqIqMrKC+UHt2nlrIuyML4uLeK56kkIryAtmLF71DI/OsovIKaE7AFWsBEVesvxmDpDee1B74nPs0HXV+76jxDAiD1rWCQMdWn5A8Ju6BORnCNbyWjJshByKE+XVqNz40TJuE7kjyfOkRx0TSRWbEu0ypiJ6I9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570168; c=relaxed/simple;
	bh=bqzdgY/LvEsVVDZR7bp9JtVvNcUw7yUb+6FIjujVaHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjMrbL+KaACQ6TtfxC9fhxWwKjmfGXEprle873iEXfYiuXSFWO1c2pxHhFqzWyk11JgxiXGXDnVOfwbTLOxRl00rgaZ7Y4LmTGtd+Te61QuV0X8VLFOWgAVroCcj46LQuAI4iEFAC9dM2X/l59/REgvwKBJCU4f+4WSdowxHdjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JbE57hnr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JbE57hnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D82C4CEF0;
	Mon, 22 Sep 2025 19:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570168;
	bh=bqzdgY/LvEsVVDZR7bp9JtVvNcUw7yUb+6FIjujVaHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JbE57hnrLfbeMUsNdweXjDAUtrIYol5IGWfimOXxsgTMOW+tY5lPvtLQy5mh1RmNf
	 2L/LbDPUtTKZwMuApoezdj29SEJfg0ayTJ0sNI3URrazP8XIzQVTo0YdokkRKDKAtH
	 vqXMJZ6RgMVhy2at9GwizSpltVNCxuAo3mO63A5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Simon Horman <horms@kernel.org>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.16 032/149] ixgbe: initialize aci.lock before its used
Date: Mon, 22 Sep 2025 21:28:52 +0200
Message-ID: <20250922192413.676333639@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

[ Upstream commit b85936e95a4bd2a07e134af71e2c0750a69d2b8b ]

Currently aci.lock is initialized too late. A bunch of ACI callbacks
using the lock are called prior it's initialized.

Commit 337369f8ce9e ("locking/mutex: Add MUTEX_WARN_ON() into fast path")
highlights that issue what results in call trace.

[    4.092899] DEBUG_LOCKS_WARN_ON(lock->magic != lock)
[    4.092910] WARNING: CPU: 0 PID: 578 at kernel/locking/mutex.c:154 mutex_lock+0x6d/0x80
[    4.098757] Call Trace:
[    4.098847]  <TASK>
[    4.098922]  ixgbe_aci_send_cmd+0x8c/0x1e0 [ixgbe]
[    4.099108]  ? hrtimer_try_to_cancel+0x18/0x110
[    4.099277]  ixgbe_aci_get_fw_ver+0x52/0xa0 [ixgbe]
[    4.099460]  ixgbe_check_fw_error+0x1fc/0x2f0 [ixgbe]
[    4.099650]  ? usleep_range_state+0x69/0xd0
[    4.099811]  ? usleep_range_state+0x8c/0xd0
[    4.099964]  ixgbe_probe+0x3b0/0x12d0 [ixgbe]
[    4.100132]  local_pci_probe+0x43/0xa0
[    4.100267]  work_for_cpu_fn+0x13/0x20
[    4.101647]  </TASK>

Move aci.lock mutex initialization to ixgbe_sw_init() before any ACI
command is sent. Along with that move also related SWFW semaphore in
order to reduce size of ixgbe_probe() and that way all locks are
initialized in ixgbe_sw_init().

Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Fixes: 4600cdf9f5ac ("ixgbe: Enable link management in E610 device")
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index cba860f0e1f15..2a857037dd102 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6801,6 +6801,13 @@ static int ixgbe_sw_init(struct ixgbe_adapter *adapter,
 		break;
 	}
 
+	/* Make sure the SWFW semaphore is in a valid state */
+	if (hw->mac.ops.init_swfw_sync)
+		hw->mac.ops.init_swfw_sync(hw);
+
+	if (hw->mac.type == ixgbe_mac_e610)
+		mutex_init(&hw->aci.lock);
+
 #ifdef IXGBE_FCOE
 	/* FCoE support exists, always init the FCoE lock */
 	spin_lock_init(&adapter->fcoe.lock);
@@ -11474,10 +11481,6 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_sw_init;
 
-	/* Make sure the SWFW semaphore is in a valid state */
-	if (hw->mac.ops.init_swfw_sync)
-		hw->mac.ops.init_swfw_sync(hw);
-
 	if (ixgbe_check_fw_error(adapter))
 		return ixgbe_recovery_probe(adapter);
 
@@ -11681,8 +11684,6 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ether_addr_copy(hw->mac.addr, hw->mac.perm_addr);
 	ixgbe_mac_set_default_filter(adapter);
 
-	if (hw->mac.type == ixgbe_mac_e610)
-		mutex_init(&hw->aci.lock);
 	timer_setup(&adapter->service_timer, ixgbe_service_timer, 0);
 
 	if (ixgbe_removed(hw->hw_addr)) {
@@ -11838,9 +11839,9 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	devl_unlock(adapter->devlink);
 	ixgbe_release_hw_control(adapter);
 	ixgbe_clear_interrupt_scheme(adapter);
+err_sw_init:
 	if (hw->mac.type == ixgbe_mac_e610)
 		mutex_destroy(&adapter->hw.aci.lock);
-err_sw_init:
 	ixgbe_disable_sriov(adapter);
 	adapter->flags2 &= ~IXGBE_FLAG2_SEARCH_FOR_SFP;
 	iounmap(adapter->io_addr);
-- 
2.51.0



