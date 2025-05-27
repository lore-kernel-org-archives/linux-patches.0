Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D01280037;
	Tue, 27 May 2025 16:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364942; cv=none; b=pG6IMyyiTTTkRcYaT9yekB1BCBOFrGnb1WHh5pziIzl4JpbNuddUplBQ1evy3+FSFw5h60xQBhBdyz1n5GCde8BJieoBJvn87ZDMFHVq2c7Z/4d9xjYOkZPvihrL7wyVaDifyDtEmgCaIO+/6v/5q8AK0YHViV/Sey0kNrg/tjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364942; c=relaxed/simple;
	bh=IWb225kG/pzEpmQnaH3w4NF/JV4SYAjE9HLC2fhrL0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RzKuKKKvCB5K4mlkT/gzsuxEb8TS2oBqDSJTFJGSDRJxISg3HNQn8RoIuo/4L45tKXMj1oVkhFTSPdIk2mISDPrvw7t8u6MYCUESIe3Ji76CTNTTNZ7h2H1oWHKLl2b+ock/1oOFqr5LRUGCZX1ajdO6jCcsujO7NFYgCe2+4EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDQ6pETo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDQ6pETo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC64FC4CEE9;
	Tue, 27 May 2025 16:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364941;
	bh=IWb225kG/pzEpmQnaH3w4NF/JV4SYAjE9HLC2fhrL0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDQ6pEToz5/VZ7IUxOnQ1ns9pGIXSjrELX6xyokP9MJ8xlkCd+mIcQc1qFgK/Hklg
	 nlsxRj35F5OcjPqg5ny+p5rDq4wo1UaIwcVSz7vVQx0qutpeJflT/7iuHQSq9+VwLH
	 TIFKor34Fc4TySYEfE9dJPPbD8nbtc+s2gx7jjX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gabay <daniel.gabay@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 185/626] wifi: iwlwifi: w/a FW SMPS mode selection
Date: Tue, 27 May 2025 18:21:18 +0200
Message-ID: <20250527162452.525832033@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Gabay <daniel.gabay@intel.com>

[ Upstream commit b2e709805ce955f80803b7cab3421813c79e1df4 ]

The FW is now responsible of determining the SMPS mode.
If the user disabled power save in a certain vif, we send the vif-level
power command to clear out the POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK bit
for that vif.
But erroneously, the FW checks DEVICE_POWER_FLAGS_POWER_SAVE_ENA_MSK in
the device-level command to determine the SMPS mode.

To W/A this, send also the device-level command when the power save of a
vif changes, and disable power save if there is any vif that has power
save disabled.

Signed-off-by: Daniel Gabay <daniel.gabay@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250308231427.7bf205efa027.I2c793ff1fc2a6779a95faaee1ded348100fd97f1@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 15 +++++++++++++++
 .../net/wireless/intel/iwlwifi/mvm/mld-mac80211.c |  3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |  3 +++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index d37d83d246354..3fd257f770baa 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4096,6 +4096,20 @@ iwl_mvm_sta_state_authorized_to_assoc(struct iwl_mvm *mvm,
 	return 0;
 }
 
+void iwl_mvm_smps_workaround(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			     bool update)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	if (!iwl_mvm_has_rlc_offload(mvm))
+		return;
+
+	mvmvif->ps_disabled = !vif->cfg.ps;
+
+	if (update)
+		iwl_mvm_power_update_mac(mvm);
+}
+
 /* Common part for MLD and non-MLD modes */
 int iwl_mvm_mac_sta_state_common(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif,
@@ -4188,6 +4202,7 @@ int iwl_mvm_mac_sta_state_common(struct ieee80211_hw *hw,
 		   new_state == IEEE80211_STA_AUTHORIZED) {
 		ret = iwl_mvm_sta_state_assoc_to_authorized(mvm, vif, sta,
 							    callbacks);
+		iwl_mvm_smps_workaround(mvm, vif, true);
 	} else if (old_state == IEEE80211_STA_AUTHORIZED &&
 		   new_state == IEEE80211_STA_ASSOC) {
 		ret = iwl_mvm_sta_state_authorized_to_assoc(mvm, vif, sta,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
index e252f0dcea205..04da02bdd9536 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2022-2024 Intel Corporation
+ * Copyright (C) 2022-2025 Intel Corporation
  */
 #include "mvm.h"
 
@@ -961,6 +961,7 @@ static void iwl_mvm_mld_vif_cfg_changed_station(struct iwl_mvm *mvm,
 	}
 
 	if (changes & BSS_CHANGED_PS) {
+		iwl_mvm_smps_workaround(mvm, vif, false);
 		ret = iwl_mvm_power_update_mac(mvm);
 		if (ret)
 			IWL_ERR(mvm, "failed to update power mode\n");
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index ef07cff203b0d..7d86d273092ac 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -3042,4 +3042,7 @@ iwl_mvm_send_ap_tx_power_constraint_cmd(struct iwl_mvm *mvm,
 					struct ieee80211_vif *vif,
 					struct ieee80211_bss_conf *bss_conf,
 					bool is_ap);
+
+void iwl_mvm_smps_workaround(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			     bool update);
 #endif /* __IWL_MVM_H__ */
-- 
2.39.5



