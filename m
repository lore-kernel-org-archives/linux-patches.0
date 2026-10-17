Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9EF3AEF36;
	Sat, 17 Oct 2026 16:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255297; cv=none; b=fc/M2trcCvo9zOsC4qcqSUrL1rGba4c+ZZmdcGBO6eCIg5qu7Y1qXGs0d7937rc4ljPzay6q5sTNU9cnfDOlKilZEcMASnSfghrqYQ5X7PsufdoKVx6VL5k9YtslMbW6I6SPn2NuBSn2GICqd1dHGS4+Y95YHdrbfDwhgUQFosY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255297; c=relaxed/simple;
	bh=D/JGBY2rnfEB5xpRlzBGhxYp2bDILPZEEpk0TbvDt1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjMDqefWppMJ/aWqV51Tz19JXhMkFYPJ6Y7ow9ZX4PdF4v9ASmO4OnKwKiqQ2pDpZ/ipK2fb6gYNXAD/kIkjCbyJ2FQ6kUuT7zFNUXun6TeEsvNtb9nyTI3XopId0WqvlF55ayVCAsYMEk9hvYJOVA2rjoIJC85IBItnzwsaFnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ostyw9UI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ostyw9UI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDA61F000C4;
	Sat, 17 Oct 2026 16:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255296;
	bh=cGVJKAGiD6EvwkNNJuKwLOHmzdaN7kVay6LbeeiCUdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ostyw9UIc8vsF8Cro2xOvGjSAQ6XF7xMixQrnDFgaOby7zDJsyyvLrZKSraT0bL6M
	 CTDgrFaN4wo4ddWwTz+3csentYuHAYvNhDqcUPRPPBUAyoaiF63dzYYGGPMF231AA7
	 qE7ZWlFDQUDg9bMhSBOEZ7hJOjxitMKD/alv5cB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 729/869] wifi: iwlwifi: mvm: fix P2P-Device binding handling
Date: Sat, 17 Oct 2026 17:59:30 +0200
Message-ID: <20261017160055.639711993@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit b74e377cad9271950c57472867c469e4b5b2ff0c ]

Our binding handling for P2P-Device can run into the following
scenario, as observed by our testing:

 - a station interface is connected on some channel
 - the P2P-Device does a remain-on-channel (ROC) on that channel
 - the ROC ends, and the P2P-Device is removed from the binding,
   but the phy_ctxt pointer is left around as a PHY cache so we
   don't need to recalibrate to the channel again and again in
   case it's not shared
 - a binding update by the station interface, even a removal,
   will re-add the P2P-Device to the binding
 - the P2P-Device is removed, which removes the PHY context, but
   it's still in the binding so the firmware crashes

Since the P2P device is removed from the binding and only re-
added by unrelated code, but we want to keep the phy_ctxt around
as a cache for future ROC usage, fix it by adding a boolean that
indicates whether or not the P2P-Device should be added to the
binding, and handle that in the binding iterator. That way, the
station interface cannot re-add the P2P-Device to the binding
when that isn't active.

Assisted-by: Github Copilot:claude-opus-4-6
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20260527230313.07f94335ae06.I384238b0859343c4a9a9dda20682be1aad89cc9d@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/binding.c    |  5 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c   | 12 +++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h        |  3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c |  3 ++-
 4 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/binding.c b/drivers/net/wireless/intel/iwlwifi/mvm/binding.c
index 58e9a940024db..0812522edea0d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/binding.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/binding.c
@@ -2,7 +2,7 @@
 /*
  * Copyright (C) 2012-2014, 2020 Intel Corporation
  * Copyright (C) 2016 Intel Deutschland GmbH
- * Copyright (C) 2022, 2024 Intel Corporation
+ * Copyright (C) 2022, 2024, 2026 Intel Corporation
  */
 #include <net/mac80211.h>
 #include "fw-api.h"
@@ -76,6 +76,9 @@ static void iwl_mvm_iface_iterator(void *_data, u8 *mac,
 	if (vif == data->ignore_vif)
 		return;
 
+	if (vif->type == NL80211_IFTYPE_P2P_DEVICE && !mvmvif->p2p_in_binding)
+		return;
+
 	if (mvmvif->deflink.phy_ctxt != data->phyctxt)
 		return;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 6ac4215677057..91d0d2dfef893 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1098,6 +1098,7 @@ static void iwl_mvm_cleanup_iterator(void *data, u8 *mac,
 	spin_unlock_bh(&mvm->time_event_lock);
 
 	mvmvif->roc_activity = ROC_NUM_ACTIVITIES;
+	mvmvif->p2p_in_binding = false;
 
 	mvmvif->bf_enabled = false;
 	mvmvif->ba_enabled = false;
@@ -4786,6 +4787,7 @@ static int iwl_mvm_add_aux_sta_for_hs20(struct iwl_mvm *mvm, u32 lmac_id)
 
 static int iwl_mvm_roc_link(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -4794,10 +4796,18 @@ static int iwl_mvm_roc_link(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	if (WARN(ret, "Failed binding P2P_DEVICE\n"))
 		return ret;
 
+	mvmvif->p2p_in_binding = true;
+
 	/* The station and queue allocation must be done only after the binding
 	 * is done, as otherwise the FW might incorrectly configure its state.
 	 */
-	return iwl_mvm_add_p2p_bcast_sta(mvm, vif);
+	ret = iwl_mvm_add_p2p_bcast_sta(mvm, vif);
+	if (ret) {
+		iwl_mvm_binding_remove_vif(mvm, vif);
+		mvmvif->p2p_in_binding = false;
+	}
+
+	return ret;
 }
 
 static int iwl_mvm_roc(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 67d188409ca31..4e1dbfb3705e3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -454,6 +454,8 @@ struct iwl_mvm_esr_exit {
  * @unblock_esr_tpt_wk: work for unblocking EMLSR when tpt is high enough.
  * @roc_activity: currently running ROC activity for this vif (or
  *	ROC_NUM_ACTIVITIES if no activity is running).
+ * @p2p_in_binding: indicates that this P2P-Device interface should be
+ *	added to the binding, i.e. is running ROC right now
  * @session_prot_connection_loss: the connection was lost due to session
  *	protection ending without receiving a beacon, so we need to now
  *	protect the deauth separately
@@ -565,6 +567,7 @@ struct iwl_mvm_vif {
 	struct iwl_mvm_time_event_data time_event_data;
 	struct iwl_mvm_time_event_data hs_time_event_data;
 	enum iwl_roc_activity roc_activity;
+	bool p2p_in_binding;
 
 	/* TCP Checksum Offload */
 	netdev_features_t features;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index c0b58e4a4cc1c..bdd05062824d6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2024 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2024, 2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2017 Intel Deutschland GmbH
  */
@@ -90,6 +90,7 @@ static void iwl_mvm_cleanup_roc(struct iwl_mvm *mvm)
 			} else {
 				iwl_mvm_rm_p2p_bcast_sta(mvm, vif);
 				iwl_mvm_binding_remove_vif(mvm, vif);
+				mvmvif->p2p_in_binding = false;
 			}
 
 			/* Do not remove the PHY context as removing and adding
-- 
2.53.0



