Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8AA313547;
	Mon, 20 Apr 2026 15:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700253; cv=none; b=BARgOv6x/krAaVvWdJpv8ASOWjsr1n+QZrCLpzdIgMhQ6zYa+H1ZlfgrTX41w6vdkvQTesronQTLPPsgqW4m+ohl+1X3kYQ7DpMR5N5mh/TiQBrW+z0ShxDUvpDttJBTHhv5RfMHGb38KB3jGnUQIV+14lAw18P2CbOYbgBpJDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700253; c=relaxed/simple;
	bh=J336XRSS17MqIiT8u4BSrPV2FxsznXb4QsxZpIKbDNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6OToaZp43MVRUUQCXo10OsAnZQBZamsk2xh0E63fSs65bwntrx7hX4+uV3WFX8MrUpHd8wRaaOiJ2och7BqcwkcgnMD6FmSHLBB4q0qzCbD6lnXRPZsUi9mCVUNOR6ibI3PWBFQqlgv3d+5unCyu7GJkGObgYP1rKt+RZMN7Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FgCeEhMd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FgCeEhMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417EAC19425;
	Mon, 20 Apr 2026 15:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700253;
	bh=J336XRSS17MqIiT8u4BSrPV2FxsznXb4QsxZpIKbDNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FgCeEhMdbqb6uuyi7BLFACN0iOUJzcO3SGL3WWgizzR5PMbqceh1Sr6lFjRFFS79L
	 iGoS+hMCpHEvlY2KgVI8CSeIsIoRO2JWqBTnCIvcJDmz94MUDB/y0ktK0L6s2WTvsI
	 GHqjTIqmrvhwFM8r315A+DALgm0qXbcRKepNULVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.19 099/220] ixgbe: stop re-reading flash on every get_drvinfo for e610
Date: Mon, 20 Apr 2026 17:40:40 +0200
Message-ID: <20260420153937.599276847@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

[ Upstream commit d8ae40dc20cbd7bb6e6b36a928e2db2296060ad2 ]

ixgbe_get_drvinfo() calls ixgbe_refresh_fw_version() on every ethtool
query for e610 adapters.  That ends up in ixgbe_discover_flash_size(),
which bisects the full 16 MB NVM space issuing one ACI command per
step (~20 ms each, ~24 steps total = ~500 ms).

Profiling on an idle E610-XAT2 system with telegraf scraping ethtool
stats every 10 seconds:

  kretprobe:ixgbe_get_drvinfo took 527603 us
  kretprobe:ixgbe_get_drvinfo took 523978 us
  kretprobe:ixgbe_get_drvinfo took 552975 us
  kretprobe:ice_get_drvinfo   took       3 us
  kretprobe:igb_get_drvinfo   took       2 us
  kretprobe:i40e_get_drvinfo  took       5 us

The half-second stall happens under the RTNL lock, causing visible
latency on ip-link and friends.

The FW version can only change after an EMPR reset.  All flash data is
already populated at probe time and the cached adapter->eeprom_id is
what get_drvinfo should be returning.  The only place that needs to
trigger a re-read is ixgbe_devlink_reload_empr_finish(), right after
the EMPR completes and new firmware is running.  Additionally, refresh
the FW version in ixgbe_reinit_locked() so that any PF that undergoes a
reinit after an EMPR (e.g. triggered by another PF's devlink reload)
also picks up the new version in adapter->eeprom_id.

ixgbe_devlink_info_get() keeps its refresh call for explicit
"devlink dev info" queries, which is fine given those are user-initiated.

Fixes: c9e563cae19e ("ixgbe: add support for devlink reload")
Co-developed-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/devlink/devlink.c |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   | 13 +++++++------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      | 10 ++++++++++
 4 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/devlink/devlink.c b/drivers/net/ethernet/intel/ixgbe/devlink/devlink.c
index d227f4d2a2d17..f32e640ef4ac0 100644
--- a/drivers/net/ethernet/intel/ixgbe/devlink/devlink.c
+++ b/drivers/net/ethernet/intel/ixgbe/devlink/devlink.c
@@ -474,7 +474,7 @@ static int ixgbe_devlink_reload_empr_finish(struct devlink *devlink,
 	adapter->flags2 &= ~(IXGBE_FLAG2_API_MISMATCH |
 			     IXGBE_FLAG2_FW_ROLLBACK);
 
-	return 0;
+	return ixgbe_refresh_fw_version(adapter);
 }
 
 static const struct devlink_ops ixgbe_devlink_ops = {
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index dce4936708eb4..047f04045585a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -973,7 +973,7 @@ int ixgbe_init_interrupt_scheme(struct ixgbe_adapter *adapter);
 bool ixgbe_wol_supported(struct ixgbe_adapter *adapter, u16 device_id,
 			 u16 subdevice_id);
 void ixgbe_set_fw_version_e610(struct ixgbe_adapter *adapter);
-void ixgbe_refresh_fw_version(struct ixgbe_adapter *adapter);
+int ixgbe_refresh_fw_version(struct ixgbe_adapter *adapter);
 #ifdef CONFIG_PCI_IOV
 void ixgbe_full_sync_mac_table(struct ixgbe_adapter *adapter);
 #endif
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 2ad81f687a844..d82c51f673ec8 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -1153,12 +1153,17 @@ static int ixgbe_set_eeprom(struct net_device *netdev,
 	return ret_val;
 }
 
-void ixgbe_refresh_fw_version(struct ixgbe_adapter *adapter)
+int ixgbe_refresh_fw_version(struct ixgbe_adapter *adapter)
 {
 	struct ixgbe_hw *hw = &adapter->hw;
+	int err;
+
+	err = ixgbe_get_flash_data(hw);
+	if (err)
+		return err;
 
-	ixgbe_get_flash_data(hw);
 	ixgbe_set_fw_version_e610(adapter);
+	return 0;
 }
 
 static void ixgbe_get_drvinfo(struct net_device *netdev,
@@ -1166,10 +1171,6 @@ static void ixgbe_get_drvinfo(struct net_device *netdev,
 {
 	struct ixgbe_adapter *adapter = ixgbe_from_netdev(netdev);
 
-	/* need to refresh info for e610 in case fw reloads in runtime */
-	if (adapter->hw.mac.type == ixgbe_mac_e610)
-		ixgbe_refresh_fw_version(adapter);
-
 	strscpy(drvinfo->driver, ixgbe_driver_name, sizeof(drvinfo->driver));
 
 	strscpy(drvinfo->fw_version, adapter->eeprom_id,
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index c58051e4350be..60eadef423ca7 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6289,6 +6289,16 @@ void ixgbe_reinit_locked(struct ixgbe_adapter *adapter)
 	if (adapter->flags & IXGBE_FLAG_SRIOV_ENABLED)
 		msleep(2000);
 	ixgbe_up(adapter);
+
+	/* E610 has no FW event to notify all PFs of an EMPR reset, so
+	 * refresh the FW version here to pick up any new FW version after
+	 * a hardware reset (e.g. EMPR triggered by another PF's devlink
+	 * reload).  ixgbe_refresh_fw_version() updates both hw->flash and
+	 * adapter->eeprom_id so ethtool -i reports the correct string.
+	 */
+	if (adapter->hw.mac.type == ixgbe_mac_e610)
+		(void)ixgbe_refresh_fw_version(adapter);
+
 	clear_bit(__IXGBE_RESETTING, &adapter->state);
 }
 
-- 
2.53.0



