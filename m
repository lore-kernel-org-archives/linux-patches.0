Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3772D1586F5;
	Tue, 23 Jul 2024 18:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759849; cv=none; b=tvaUKiVkMe0DtiA1V6dPLZGD2niJ0e+AAhCqG7qgJQm89LkAoBH5gVMdFdnaHvk3vBZzSOLDvgKvlOMVayBfpmRhQcpEHgBCAr2XZdL+lq1clIddhrf+6Kfuk5xM0UXcC7v7Q/UCRt8+IKquE9fJHkVThSKDqCBoW0S+tCsTCvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759849; c=relaxed/simple;
	bh=1gd/WBiZKCCZhSUV6BdVZ6Xx1gZy+Q4HEE+uquU5Sxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBt7k4oPW93c6WgQ18YlL0n6+HN1gnyaTbBH7QCTFBXoZhEVPRalK+u08FT0qqly9fqe5Byq5avM8Z+4cOVS63Zn8WLbJf3rKK4YR+WFEtoXPl+XZRXuPTEmSEPCs0iO3bXMUw+rMk0W9rYe4nv/aMLhFt4ToR+2GAx/wWq9A9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4afQcDj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4afQcDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB31FC4AF09;
	Tue, 23 Jul 2024 18:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759849;
	bh=1gd/WBiZKCCZhSUV6BdVZ6Xx1gZy+Q4HEE+uquU5Sxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y4afQcDjI+OxzjYYobsXu6hH784velzVYVMqOxZeMAkyzKAjLRGH+pgy3J/b5GHZP
	 +z4VL6rHNvyH9HXeEkunea1whAzWJopUGQbOuF1T20dMTHSdGPecwTgJgpF7MYpuf2
	 8+ojp6yuYdj0jEcgOg7dfWrYzrFlU13g7FfX2xKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 019/163] wifi: iwlwifi: mvm: remove stale STA link data during restart
Date: Tue, 23 Jul 2024 20:22:28 +0200
Message-ID: <20240723180144.212490234@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit cc3ba78f202de9752aceb16342ab62bdfbffac7e ]

If pre-recovery mac80211 tried to disable a link but this disablement
failed, then there might be a mismatch between mac80211 assuming the
link has been disabled and the driver still having the data around.
During recover itself, that is not a problem, but should the link be
activated again at a later point, iwlwifi will refuse the activation as
it detects the inconsistent state.

Solve this corner-case by iterating the station in the restart cleanup
handler.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240513132416.d2fd60338055.I840d4fdce5fd49fe69896d928b071067e3730259@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 37 +++++++++++++++++++
 .../net/wireless/intel/iwlwifi/mvm/mld-sta.c  | 10 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h  |  5 +++
 3 files changed, 47 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 5f6b16d3fc8a3..3b61fe8ca47fa 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1115,6 +1115,39 @@ static void iwl_mvm_cleanup_iterator(void *data, u8 *mac,
 	RCU_INIT_POINTER(mvmvif->deflink.probe_resp_data, NULL);
 }
 
+static void iwl_mvm_cleanup_sta_iterator(void *data, struct ieee80211_sta *sta)
+{
+	struct iwl_mvm *mvm = data;
+	struct iwl_mvm_sta *mvm_sta;
+	struct ieee80211_vif *vif;
+	int link_id;
+
+	mvm_sta = iwl_mvm_sta_from_mac80211(sta);
+	vif = mvm_sta->vif;
+
+	if (!sta->valid_links)
+		return;
+
+	for (link_id = 0; link_id < ARRAY_SIZE((sta)->link); link_id++) {
+		struct iwl_mvm_link_sta *mvm_link_sta;
+
+		mvm_link_sta =
+			rcu_dereference_check(mvm_sta->link[link_id],
+					      lockdep_is_held(&mvm->mutex));
+		if (mvm_link_sta && !(vif->active_links & BIT(link_id))) {
+			/*
+			 * We have a link STA but the link is inactive in
+			 * mac80211. This will happen if we failed to
+			 * deactivate the link but mac80211 roll back the
+			 * deactivation of the link.
+			 * Delete the stale data to avoid issues later on.
+			 */
+			iwl_mvm_mld_free_sta_link(mvm, mvm_sta, mvm_link_sta,
+						  link_id, false);
+		}
+	}
+}
+
 static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 {
 	iwl_mvm_stop_device(mvm);
@@ -1137,6 +1170,10 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 	 */
 	ieee80211_iterate_interfaces(mvm->hw, 0, iwl_mvm_cleanup_iterator, mvm);
 
+	/* cleanup stations as links may be gone after restart */
+	ieee80211_iterate_stations_atomic(mvm->hw,
+					  iwl_mvm_cleanup_sta_iterator, mvm);
+
 	mvm->p2p_device_vif = NULL;
 
 	iwl_mvm_reset_phy_ctxts(mvm);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
index 36dc291d98dd6..a21e29947475f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
@@ -515,11 +515,11 @@ static int iwl_mvm_mld_cfg_sta(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	return iwl_mvm_mld_send_sta_cmd(mvm, &cmd);
 }
 
-static void iwl_mvm_mld_free_sta_link(struct iwl_mvm *mvm,
-				      struct iwl_mvm_sta *mvm_sta,
-				      struct iwl_mvm_link_sta *mvm_sta_link,
-				      unsigned int link_id,
-				      bool is_in_fw)
+void iwl_mvm_mld_free_sta_link(struct iwl_mvm *mvm,
+			       struct iwl_mvm_sta *mvm_sta,
+			       struct iwl_mvm_link_sta *mvm_sta_link,
+			       unsigned int link_id,
+			       bool is_in_fw)
 {
 	RCU_INIT_POINTER(mvm->fw_id_to_mac_id[mvm_sta_link->sta_id],
 			 is_in_fw ? ERR_PTR(-EINVAL) : NULL);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index b3450569864eb..7dd8f7f4b4492 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -638,6 +638,11 @@ int iwl_mvm_mld_update_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			   struct ieee80211_sta *sta);
 int iwl_mvm_mld_rm_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta);
+void iwl_mvm_mld_free_sta_link(struct iwl_mvm *mvm,
+			       struct iwl_mvm_sta *mvm_sta,
+			       struct iwl_mvm_link_sta *mvm_sta_link,
+			       unsigned int link_id,
+			       bool is_in_fw);
 int iwl_mvm_mld_rm_sta_id(struct iwl_mvm *mvm, u8 sta_id);
 int iwl_mvm_mld_update_sta_links(struct iwl_mvm *mvm,
 				 struct ieee80211_vif *vif,
-- 
2.43.0



