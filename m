Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7913ACF13;
	Wed,  8 Apr 2026 18:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672886; cv=none; b=isYuA8OXaSmrTgRsFmjlVLd55HaMspUKNXotD+MUlHNE3vhxWH5Nrc5Zl+AB6ci/iLWAvsfaLM56z8BWeKgCRCZw2h69neSZ1VDFMYE29yYelljJoB8MzOTqTFEx4vk50xGlsfAjEApzuawZW7IYUSK5Nwx0q2UXpPAlKdl7Ibw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672886; c=relaxed/simple;
	bh=GWfL1YQadqIKVi3pkr4wYkpx6mFu7mZskQeEKUWn0rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGq9FpmmBCXIdWVP26VD4rLUGqRIfHsfzRvDahd49wx2/8ex/Qtda2HVxhLgNC9b4bgQKJFzYpcajK1DEN3Z5b4kcRbSEmzBFeJ2Zfoz0ppWfx1209LjWlpRI8oms+JS7NKNHQJaDguQVgHoQGQHlqiYwyBLRVN9WOWpwmsr11Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fzwKiIhy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fzwKiIhy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D92C19421;
	Wed,  8 Apr 2026 18:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672886;
	bh=GWfL1YQadqIKVi3pkr4wYkpx6mFu7mZskQeEKUWn0rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fzwKiIhyDqm1VHvyFp2v+g4agjEwxydKEENQg+kZ7L8SPas82WIwOMWPOMU//rqQ0
	 u4LuHfOquCG7EREndbykqIC19Dz1VZLg9czc987kKzyX49iPc0HmnRIejfxrqFzTxC
	 IK4J96s5Fg5R0/ZSnNWowkXogfShPf8lFnT83wy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 019/277] wifi: iwlwifi: mld: Fix MLO scan timing
Date: Wed,  8 Apr 2026 20:00:04 +0200
Message-ID: <20260408175934.570992705@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

[ Upstream commit ec66ec6a5a8f53e7c70085749e8d68f4431c630f ]

Calculate MLO scan start time based on actual
scan start notification from firmware instead of recording
time when scan command is sent.

Currently, MLO scan start time was captured immediately
after sending the scan command to firmware. However, the
actual scan start time may differ due to the FW being busy
with a previous scan.

In that case, the link selection code will think that the MLO
scan is too old, and will warn.

To fix it, Implement start scan notification handling to
capture the precise moment when firmware begins the scan
operation.

Fixes: 9324731b9985 ("wifi: iwlwifi: mld: avoid selecting bad links")
Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260324113316.4c56b8bac533.I6e656d8cc30bb82c96aabadedd62bd67f4c46bf9@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/intel/iwlwifi/fw/api/commands.h  |  5 ++++
 .../net/wireless/intel/iwlwifi/fw/api/scan.h  | 10 +++++++
 drivers/net/wireless/intel/iwlwifi/mld/mld.c  |  1 +
 drivers/net/wireless/intel/iwlwifi/mld/mlo.c  |  4 +--
 .../net/wireless/intel/iwlwifi/mld/notif.c    |  5 ++++
 drivers/net/wireless/intel/iwlwifi/mld/scan.c | 30 +++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mld/scan.h |  9 ++++--
 7 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h b/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
index 997b0c9ce9840..6b3e7c614e54c 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
@@ -296,6 +296,11 @@ enum iwl_legacy_cmds {
 	 */
 	SCAN_OFFLOAD_UPDATE_PROFILES_CMD = 0x6E,
 
+	/**
+	 * @SCAN_START_NOTIFICATION_UMAC: uses &struct iwl_umac_scan_start
+	 */
+	SCAN_START_NOTIFICATION_UMAC = 0xb2,
+
 	/**
 	 * @MATCH_FOUND_NOTIFICATION: scan match found
 	 */
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
index 60f0a4924ddfb..46fcc32608e34 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
@@ -1156,6 +1156,16 @@ enum iwl_umac_scan_abort_status {
 	IWL_UMAC_SCAN_ABORT_STATUS_NOT_FOUND,
 };
 
+/**
+ * struct iwl_umac_scan_start - scan start notification
+ * @uid: scan id, &enum iwl_umac_scan_uid_offsets
+ * @reserved: for future use
+ */
+struct iwl_umac_scan_start {
+	__le32 uid;
+	__le32 reserved;
+} __packed; /* SCAN_START_UMAC_API_S_VER_1 */
+
 /**
  * struct iwl_umac_scan_complete - scan complete notification
  * @uid: scan id, &enum iwl_umac_scan_uid_offsets
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mld.c b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
index a6962256bdd12..3cfe1bcb7d4e5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mld.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
@@ -171,6 +171,7 @@ static const struct iwl_hcmd_names iwl_mld_legacy_names[] = {
 	HCMD_NAME(MISSED_BEACONS_NOTIFICATION),
 	HCMD_NAME(MAC_PM_POWER_TABLE),
 	HCMD_NAME(MFUART_LOAD_NOTIFICATION),
+	HCMD_NAME(SCAN_START_NOTIFICATION_UMAC),
 	HCMD_NAME(RSS_CONFIG_CMD),
 	HCMD_NAME(SCAN_ITERATION_COMPLETE_UMAC),
 	HCMD_NAME(REPLY_RX_MPDU_CMD),
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mlo.c b/drivers/net/wireless/intel/iwlwifi/mld/mlo.c
index bf70e71aa5143..836f15dc54b52 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mlo.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mlo.c
@@ -732,7 +732,7 @@ iwl_mld_set_link_sel_data(struct iwl_mld *mld,
 
 		/* Ignore any BSS that was not seen in the last MLO scan */
 		if (ktime_before(link_conf->bss->ts_boottime,
-				 mld->scan.last_mlo_scan_time))
+				 mld->scan.last_mlo_scan_start_time))
 			continue;
 
 		data[n_data].link_id = link_id;
@@ -939,7 +939,7 @@ static void _iwl_mld_select_links(struct iwl_mld *mld,
 	if (!mld_vif->authorized || hweight16(usable_links) <= 1)
 		return;
 
-	if (WARN(ktime_before(mld->scan.last_mlo_scan_time,
+	if (WARN(ktime_before(mld->scan.last_mlo_scan_start_time,
 			      ktime_sub_ns(ktime_get_boottime_ns(),
 					   5ULL * NSEC_PER_SEC)),
 		"Last MLO scan was too long ago, can't select links\n"))
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/notif.c b/drivers/net/wireless/intel/iwlwifi/mld/notif.c
index 884973d0b3440..a3fd0b7387d69 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/notif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/notif.c
@@ -284,6 +284,8 @@ static void iwl_mld_handle_beacon_notification(struct iwl_mld *mld,
  * at least enough bytes to cover the structure listed in the CMD_VER_ENTRY.
  */
 
+CMD_VERSIONS(scan_start_notif,
+	     CMD_VER_ENTRY(1, iwl_umac_scan_start))
 CMD_VERSIONS(scan_complete_notif,
 	     CMD_VER_ENTRY(1, iwl_umac_scan_complete))
 CMD_VERSIONS(scan_iter_complete_notif,
@@ -355,6 +357,7 @@ DEFINE_SIMPLE_CANCELLATION(datapath_monitor, iwl_datapath_monitor_notif,
 			   link_id)
 DEFINE_SIMPLE_CANCELLATION(roc, iwl_roc_notif, activity)
 DEFINE_SIMPLE_CANCELLATION(scan_complete, iwl_umac_scan_complete, uid)
+DEFINE_SIMPLE_CANCELLATION(scan_start, iwl_umac_scan_start, uid)
 DEFINE_SIMPLE_CANCELLATION(probe_resp_data, iwl_probe_resp_data_notif,
 			   mac_id)
 DEFINE_SIMPLE_CANCELLATION(uapsd_misbehaving_ap, iwl_uapsd_misbehaving_ap_notif,
@@ -397,6 +400,8 @@ const struct iwl_rx_handler iwl_mld_rx_handlers[] = {
 			     RX_HANDLER_SYNC)
 	RX_HANDLER_NO_OBJECT(LEGACY_GROUP, BA_NOTIF, compressed_ba_notif,
 			     RX_HANDLER_SYNC)
+	RX_HANDLER_OF_SCAN(LEGACY_GROUP, SCAN_START_NOTIFICATION_UMAC,
+			   scan_start_notif)
 	RX_HANDLER_OF_SCAN(LEGACY_GROUP, SCAN_COMPLETE_UMAC,
 			   scan_complete_notif)
 	RX_HANDLER_NO_OBJECT(LEGACY_GROUP, SCAN_ITERATION_COMPLETE_UMAC,
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/scan.c b/drivers/net/wireless/intel/iwlwifi/mld/scan.c
index fd1022ddc9122..76ac6fd5f9ff3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/scan.c
@@ -473,6 +473,9 @@ iwl_mld_scan_get_cmd_gen_flags(struct iwl_mld *mld,
 	    params->flags & NL80211_SCAN_FLAG_COLOCATED_6GHZ)
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_V2_TRIGGER_UHB_SCAN;
 
+	if (scan_status == IWL_MLD_SCAN_INT_MLO)
+		flags |= IWL_UMAC_SCAN_GEN_FLAGS_V2_NTF_START;
+
 	if (params->enable_6ghz_passive)
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_V2_6GHZ_PASSIVE_SCAN;
 
@@ -1817,9 +1820,6 @@ static void iwl_mld_int_mlo_scan_start(struct iwl_mld *mld,
 	ret = _iwl_mld_single_scan_start(mld, vif, req, &ies,
 					 IWL_MLD_SCAN_INT_MLO);
 
-	if (!ret)
-		mld->scan.last_mlo_scan_time = ktime_get_boottime_ns();
-
 	IWL_DEBUG_SCAN(mld, "Internal MLO scan: ret=%d\n", ret);
 }
 
@@ -1904,6 +1904,30 @@ void iwl_mld_handle_match_found_notif(struct iwl_mld *mld,
 	ieee80211_sched_scan_results(mld->hw);
 }
 
+void iwl_mld_handle_scan_start_notif(struct iwl_mld *mld,
+				     struct iwl_rx_packet *pkt)
+{
+	struct iwl_umac_scan_complete *notif = (void *)pkt->data;
+	u32 uid = le32_to_cpu(notif->uid);
+
+	if (IWL_FW_CHECK(mld, uid >= ARRAY_SIZE(mld->scan.uid_status),
+			 "FW reports out-of-range scan UID %d\n", uid))
+		return;
+
+	if (IWL_FW_CHECK(mld, !(mld->scan.uid_status[uid] & mld->scan.status),
+			 "FW reports scan UID %d we didn't trigger\n", uid))
+		return;
+
+	IWL_DEBUG_SCAN(mld, "Scan started: uid=%u type=%u\n", uid,
+		       mld->scan.uid_status[uid]);
+	if (IWL_FW_CHECK(mld, mld->scan.uid_status[uid] != IWL_MLD_SCAN_INT_MLO,
+			 "FW reports scan start notification %d we didn't trigger\n",
+			 mld->scan.uid_status[uid]))
+		return;
+
+	mld->scan.last_mlo_scan_start_time = ktime_get_boottime_ns();
+}
+
 void iwl_mld_handle_scan_complete_notif(struct iwl_mld *mld,
 					struct iwl_rx_packet *pkt)
 {
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/scan.h b/drivers/net/wireless/intel/iwlwifi/mld/scan.h
index 69110f0cfc8e2..de5620e7f463b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/scan.h
@@ -27,6 +27,9 @@ int iwl_mld_sched_scan_start(struct iwl_mld *mld,
 void iwl_mld_handle_match_found_notif(struct iwl_mld *mld,
 				      struct iwl_rx_packet *pkt);
 
+void iwl_mld_handle_scan_start_notif(struct iwl_mld *mld,
+				     struct iwl_rx_packet *pkt);
+
 void iwl_mld_handle_scan_complete_notif(struct iwl_mld *mld,
 					struct iwl_rx_packet *pkt);
 
@@ -114,8 +117,8 @@ enum iwl_mld_traffic_load {
  *	in jiffies.
  * @last_start_time_jiffies: stores the last start time in jiffies
  *	(interface up/reset/resume).
- * @last_mlo_scan_time: start time of the last MLO scan in nanoseconds since
- *	boot.
+ * @last_mlo_scan_start_time: start time of the last MLO scan in nanoseconds
+ * since boot.
  */
 struct iwl_mld_scan {
 	/* Add here fields that need clean up on restart */
@@ -136,7 +139,7 @@ struct iwl_mld_scan {
 	void *cmd;
 	unsigned long last_6ghz_passive_jiffies;
 	unsigned long last_start_time_jiffies;
-	u64 last_mlo_scan_time;
+	u64 last_mlo_scan_start_time;
 };
 
 /**
-- 
2.53.0



