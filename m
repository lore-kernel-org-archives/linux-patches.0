Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE65B17E90E;
	Mon, 27 May 2024 19:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836703; cv=none; b=eeTDzrYR4S7ZdHoAMk1e5CSpSnyoioozorOUdC7BCaURKebk2fQNlrse66t7NIei/H7rTYWZv9PSchOl1moHLHrJDdaTMNJYAA8dDrBnYqd7LLtJjS8bQ6AMZ7vnbjHZ5quNCRpj9p5SnXAQtkXPQsBlzleCinOUclO0Ys8kIWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836703; c=relaxed/simple;
	bh=eClTcLNur4ulEfgw7ZD2k/qhsTUrjrYMo+kW3tt70M4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMyyeTLGqxFA2XUZBoc3mgNqYWDxrN25Nlif/CrkdWUUyUmyTRA57/urcjzYsCuRKzNNqQjQsSO5LNjEV7GkACYrBefJLmuIrmkIKjY9n2no66jTdlp0WeWTUly29ZeToo0d1rIaVI64fsJZHGviKtzwu11FPGV891Ocv6w90q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rcOSmwfZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rcOSmwfZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00530C2BBFC;
	Mon, 27 May 2024 19:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836703;
	bh=eClTcLNur4ulEfgw7ZD2k/qhsTUrjrYMo+kW3tt70M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rcOSmwfZvflVr6W0Bv8pDTuYAag/NohWrIPCq1gMSOhoej4tEzPEutrHLyACa+1Qo
	 IPnsWjy5CcvWF0nV9GAuoP8QjL6Tatcgxn71WAIWOALfR9M3MUSjMJyw59a7NhhXc3
	 V7+LEzvGdadLY9F2zIMOeCXI6aFrdZgJlZRzAj7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 155/427] wifi: iwlwifi: mvm: introduce esr_disable_reason
Date: Mon, 27 May 2024 20:53:22 +0200
Message-ID: <20240527185616.973213589@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 76f9864d7ac6d04036ba85a8616e2361f2d2d06c ]

This will maintain a bitmap of reasons for which we want to avoid
enabling EMLSR.
For now, we have a single reason: BT coexistence, but we will add soon
more reasons. Make it a bitmap to make it easier to manage.

Since we'll impact the parameters that impact the enablement /
disablement of EMLSR from several places, introduce a generic function
that takes into account the current state and execute the decision that
must be taken.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240416134215.94c3590c6f27.I6a190da5025d0523ef483ffac0c64e26675041e6@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 585ba158233f ("wifi: iwlwifi: mvm: don't always disable EMLSR due to BT coex")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c | 32 +++++--------------
 .../wireless/intel/iwlwifi/mvm/mld-mac80211.c | 29 ++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  | 18 +++++++++--
 3 files changed, 51 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
index 535edb51d1c09..2a28e611088d6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2013-2014, 2018-2020, 2022-2023 Intel Corporation
+ * Copyright (C) 2013-2014, 2018-2020, 2022-2024 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  */
 #include <linux/ieee80211.h>
@@ -259,7 +259,6 @@ static void iwl_mvm_bt_coex_enable_esr(struct iwl_mvm *mvm,
 				       struct ieee80211_vif *vif, bool enable)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	int link_id;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -267,30 +266,15 @@ static void iwl_mvm_bt_coex_enable_esr(struct iwl_mvm *mvm,
 		return;
 
 	/* Done already */
-	if (mvmvif->bt_coex_esr_disabled == !enable)
+	if ((mvmvif->esr_disable_reason & IWL_MVM_ESR_DISABLE_COEX) == !enable)
 		return;
 
-	mvmvif->bt_coex_esr_disabled = !enable;
-
-	/* Nothing to do */
-	if (mvmvif->esr_active == enable)
-		return;
-
-	if (enable) {
-		/* Try to re-enable eSR*/
-		iwl_mvm_mld_select_links(mvm, vif, false);
-		return;
-	}
-
-	/*
-	 * Find the primary link, as we want to switch to it and drop the
-	 * secondary one.
-	 */
-	link_id = iwl_mvm_mld_get_primary_link(mvm, vif, vif->active_links);
-	WARN_ON(link_id < 0);
+	if (enable)
+		mvmvif->esr_disable_reason &= ~IWL_MVM_ESR_DISABLE_COEX;
+	else
+		mvmvif->esr_disable_reason |= IWL_MVM_ESR_DISABLE_COEX;
 
-	ieee80211_set_active_links_async(vif,
-					 vif->active_links & BIT(link_id));
+	iwl_mvm_recalc_esr(mvm, vif);
 }
 
 /*
@@ -338,7 +322,7 @@ iwl_mvm_bt_coex_calculate_esr_mode(struct iwl_mvm *mvm,
 	if (!link_rssi)
 		wifi_loss_rate = mvm->last_bt_notif.wifi_loss_mid_high_rssi;
 
-	else if (!mvmvif->bt_coex_esr_disabled)
+	else if (!(mvmvif->esr_disable_reason & IWL_MVM_ESR_DISABLE_COEX))
 		 /* RSSI needs to get really low to disable eSR... */
 		wifi_loss_rate =
 			link_rssi <= -IWL_MVM_BT_COEX_DISABLE_ESR_THRESH ?
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
index 32ccc3b883b2c..7a2a18f8b86e2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -1258,6 +1258,33 @@ int iwl_mvm_mld_get_primary_link(struct iwl_mvm *mvm,
 	return data[1].link_id;
 }
 
+void iwl_mvm_recalc_esr(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	bool enable = !mvmvif->esr_disable_reason;
+	int link_id;
+
+	/* Nothing to do */
+	if (mvmvif->esr_active == enable)
+		return;
+
+	if (enable) {
+		/* Try to re-enable eSR */
+		iwl_mvm_mld_select_links(mvm, vif, false);
+		return;
+	}
+
+	/*
+	 * Find the primary link, as we want to switch to it and drop the
+	 * secondary one.
+	 */
+	link_id = iwl_mvm_mld_get_primary_link(mvm, vif, vif->active_links);
+	WARN_ON(link_id < 0);
+
+	ieee80211_set_active_links_async(vif,
+					 vif->active_links & BIT(link_id));
+}
+
 /*
  * This function receives a bitmap of usable links and check if we can enter
  * eSR on those links.
@@ -1300,7 +1327,7 @@ static bool iwl_mvm_can_enter_esr(struct iwl_mvm *mvm,
 							 primary_link);
 		// Mark eSR as disabled for the next time
 		if (!ret)
-			mvmvif->bt_coex_esr_disabled = true;
+			mvmvif->esr_disable_reason |= IWL_MVM_ESR_DISABLE_COEX;
 		break;
 	}
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index f0b24f00938bd..609565fadfefe 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -346,6 +346,14 @@ struct iwl_mvm_vif_link_info {
 	u16 mgmt_queue;
 };
 
+/**
+ * enum iwl_mvm_esr_disable_reason - reasons for which we can't enable EMLSR
+ * @IWL_MVM_ESR_DISABLE_COEX: COEX is preventing the enablement of EMLSR
+ */
+enum iwl_mvm_esr_disable_reason {
+	IWL_MVM_ESR_DISABLE_COEX	= BIT(0),
+};
+
 /**
  * struct iwl_mvm_vif - data per Virtual Interface, it is a MAC context
  * @mvm: pointer back to the mvm struct
@@ -361,7 +369,6 @@ struct iwl_mvm_vif_link_info {
  * @pm_enabled - indicate if MAC power management is allowed
  * @monitor_active: indicates that monitor context is configured, and that the
  *	interface should get quota etc.
- * @bt_coex_esr_disabled: indicates if esr is disabled due to bt coex
  * @low_latency: bit flags for low latency
  *	see enum &iwl_mvm_low_latency_cause for causes.
  * @low_latency_actual: boolean, indicates low latency is set,
@@ -378,6 +385,7 @@ struct iwl_mvm_vif_link_info {
  * @deflink: default link data for use in non-MLO
  * @link: link data for each link in MLO
  * @esr_active: indicates eSR mode is active
+ * @esr_disable_reason: a bitmap of enum iwl_mvm_esr_disable_reason
  * @pm_enabled: indicates powersave is enabled
  */
 struct iwl_mvm_vif {
@@ -392,7 +400,6 @@ struct iwl_mvm_vif {
 	bool pm_enabled;
 	bool monitor_active;
 	bool esr_active;
-	bool bt_coex_esr_disabled;
 
 	u8 low_latency: 6;
 	u8 low_latency_actual: 1;
@@ -400,6 +407,7 @@ struct iwl_mvm_vif {
 	u8 authorized:1;
 	bool ps_disabled;
 
+	u32 esr_disable_reason;
 	u32 ap_beacon_time;
 	struct iwl_mvm_vif_bf_data bf_data;
 
@@ -1578,7 +1586,7 @@ static inline int iwl_mvm_max_active_links(struct iwl_mvm *mvm,
 		return mvm->fw->ucode_capa.num_beacons;
 
 	if ((iwl_mvm_is_esr_supported(trans) &&
-	     !mvmvif->bt_coex_esr_disabled) ||
+	     !mvmvif->esr_disable_reason) ||
 	    ((CSR_HW_RFID_TYPE(trans->hw_rf_id) == IWL_CFG_RF_TYPE_FM &&
 	     CSR_HW_RFID_IS_CDB(trans->hw_rf_id))))
 		return IWL_MVM_FW_MAX_ACTIVE_LINKS_NUM;
@@ -2779,4 +2787,8 @@ int iwl_mvm_roc_add_cmd(struct iwl_mvm *mvm,
 			struct ieee80211_channel *channel,
 			struct ieee80211_vif *vif,
 			int duration, u32 activity);
+
+/* EMLSR */
+void iwl_mvm_recalc_esr(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+
 #endif /* __IWL_MVM_H__ */
-- 
2.43.0



