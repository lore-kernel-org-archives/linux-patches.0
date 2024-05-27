Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F0C61FCD;
	Mon, 27 May 2024 19:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836709; cv=none; b=FAUZBpEloCPfmTzwO2i51RKU7BRr8R/nBcxa3OPuC52AFoVzoC0dj5raV1mYy0vi8Q99K+oQsB3/dEDeTtH+jDTjPA8SBA9SZm2/I4z+FLhcIKrS79nVNpItyt0QZhXgH88DPdCyb3ZVSB6r51k2cz11evTRrZtD23eE4eF2yDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836709; c=relaxed/simple;
	bh=KW9biSadL0cwxh+uY7xiXWhWL8yKGpHpp7r7cTqO3yA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADOBGxqgomj1dm+i76YnapuRgxjDVJcptegWorrw/bqnZTo+k6K9EcsZJYFfOXjZJyEjg76RMIdUPa8Wwlnx9nZVunaTGz0/BAvGyeBuRhDTJwVHPU5k3Lpke9b1WHXwA1Q1E0EVMfFxbTnZebe/ofgNqEIwcGRcEEBtlczs7nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=amdma+3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="amdma+3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0FBC2BBFC;
	Mon, 27 May 2024 19:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836708;
	bh=KW9biSadL0cwxh+uY7xiXWhWL8yKGpHpp7r7cTqO3yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=amdma+3smp3+I+5aYD1LI/r0sG3ViTwT+9D/KR8TnLS0KY6nIAuIPPVJR8zXOVpEt
	 16ByjBDmQyRpvnEXpkj2UC7YEr1PI4iy9f2E9WvewopdyGXMUjCuqfvIHqm9wXGWs/
	 +HIudFavYSkoxAMIHbc4dLGikBYhKB6wj3xpSO9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 157/427] wifi: iwlwifi: mvm: dont always disable EMLSR due to BT coex
Date: Mon, 27 May 2024 20:53:24 +0200
Message-ID: <20240527185617.144044091@linuxfoundation.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 585ba158233f97da05d9bcc59d13ddf45135c8c9 ]

2.4 GHz/LB (low band) link can't be used in an EMLSR links pair when
BT is on. But EMLSR is still allowed for a pair of links which none of
them operates in LB.
In the existing code, EMLSR will always be disabled if one of the
usable links is in LB (and BT is on).
Move this check to the code that verifies a specific pair of links,
and only if one of these links operates on LB - disable EMLSR.

Fixes: 10159a45666b ("wifi: iwlwifi: disable eSR when BT is active")
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240416134215.2841006b5cc4.I45ffd583f593daa950322852ceb9454cbf497e24@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/intel/iwlwifi/mvm/mld-mac80211.c | 89 +++++++++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  9 +-
 2 files changed, 56 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
index 6ae8406ceb889..ffbcc5a2d0ae7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -602,10 +602,49 @@ struct iwl_mvm_link_sel_data {
 	bool active;
 };
 
-static bool iwl_mvm_mld_valid_link_pair(struct iwl_mvm_link_sel_data *a,
+static bool iwl_mvm_mld_valid_link_pair(struct ieee80211_vif *vif,
+					struct iwl_mvm_link_sel_data *a,
 					struct iwl_mvm_link_sel_data *b)
 {
-	return a->band != b->band;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	if (a->band == b->band)
+		return false;
+
+	/* BT Coex effects eSR mode only if one of the link is on LB */
+	if (a->band == NL80211_BAND_2GHZ || b->band == NL80211_BAND_2GHZ)
+		return !(mvmvif->esr_disable_reason & IWL_MVM_ESR_DISABLE_COEX);
+
+	return true;
+}
+
+static u8
+iwl_mvm_set_link_selection_data(struct ieee80211_vif *vif,
+				struct iwl_mvm_link_sel_data *data,
+				unsigned long usable_links)
+{
+	u8 n_data = 0;
+	unsigned long link_id;
+
+	rcu_read_lock();
+
+	for_each_set_bit(link_id, &usable_links, IEEE80211_MLD_MAX_NUM_LINKS) {
+		struct ieee80211_bss_conf *link_conf =
+			rcu_dereference(vif->link_conf[link_id]);
+
+		if (WARN_ON_ONCE(!link_conf))
+			continue;
+
+		data[n_data].link_id = link_id;
+		data[n_data].band = link_conf->chanreq.oper.chan->band;
+		data[n_data].width = link_conf->chanreq.oper.width;
+		data[n_data].active = vif->active_links & BIT(link_id);
+		n_data++;
+	}
+
+	rcu_read_unlock();
+
+	return n_data;
 }
 
 void iwl_mvm_mld_select_links(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
@@ -615,7 +654,7 @@ void iwl_mvm_mld_select_links(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	unsigned long usable_links = ieee80211_vif_usable_links(vif);
 	u32 max_active_links = iwl_mvm_max_active_links(mvm, vif);
 	u16 new_active_links;
-	u8 link_id, n_data = 0, i, j;
+	u8 n_data, i, j;
 
 	if (!IWL_MVM_AUTO_EML_ENABLE)
 		return;
@@ -640,23 +679,7 @@ void iwl_mvm_mld_select_links(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (hweight16(vif->active_links) == max_active_links)
 		return;
 
-	rcu_read_lock();
-
-	for_each_set_bit(link_id, &usable_links, IEEE80211_MLD_MAX_NUM_LINKS) {
-		struct ieee80211_bss_conf *link_conf =
-			rcu_dereference(vif->link_conf[link_id]);
-
-		if (WARN_ON_ONCE(!link_conf))
-			continue;
-
-		data[n_data].link_id = link_id;
-		data[n_data].band = link_conf->chanreq.oper.chan->band;
-		data[n_data].width = link_conf->chanreq.oper.width;
-		data[n_data].active = vif->active_links & BIT(link_id);
-		n_data++;
-	}
-
-	rcu_read_unlock();
+	n_data = iwl_mvm_set_link_selection_data(vif, data, usable_links);
 
 	/* this is expected to be the current active link */
 	if (n_data == 1)
@@ -680,7 +703,8 @@ void iwl_mvm_mld_select_links(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			if (i == j)
 				continue;
 
-			if (iwl_mvm_mld_valid_link_pair(&data[i], &data[j]))
+			if (iwl_mvm_mld_valid_link_pair(vif, &data[i],
+							&data[j]))
 				break;
 		}
 
@@ -696,7 +720,7 @@ void iwl_mvm_mld_select_links(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				if (i == j)
 					continue;
 
-				if (iwl_mvm_mld_valid_link_pair(&data[i],
+				if (iwl_mvm_mld_valid_link_pair(vif, &data[i],
 								&data[j]))
 					break;
 			}
@@ -1293,11 +1317,10 @@ static bool iwl_mvm_can_enter_esr(struct iwl_mvm *mvm,
 				  struct ieee80211_vif *vif,
 				  unsigned long desired_links)
 {
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	u16 usable_links = ieee80211_vif_usable_links(vif);
+	struct iwl_mvm_link_sel_data data[IEEE80211_MLD_MAX_NUM_LINKS];
 	const struct wiphy_iftype_ext_capab *ext_capa;
-	bool ret = true;
-	int link_id;
+	u8 n_data;
 
 	if (!ieee80211_vif_is_mld(vif) || !vif->cfg.assoc ||
 	    hweight16(usable_links) <= 1)
@@ -1312,21 +1335,13 @@ static bool iwl_mvm_can_enter_esr(struct iwl_mvm *mvm,
 	    !(ext_capa->eml_capabilities & IEEE80211_EML_CAP_EMLSR_SUPP))
 		return false;
 
-	for_each_set_bit(link_id, &desired_links, IEEE80211_MLD_MAX_NUM_LINKS) {
-		struct ieee80211_bss_conf *link_conf =
-			link_conf_dereference_protected(vif, link_id);
-
-		if (WARN_ON_ONCE(!link_conf))
-			continue;
+	n_data = iwl_mvm_set_link_selection_data(vif, data, desired_links);
 
-		/* BT Coex effects eSR mode only if one of the link is on LB */
-		if (link_conf->chanreq.oper.chan->band != NL80211_BAND_2GHZ)
-			continue;
+	if (n_data != 2)
+		return false;
 
-		return !(mvmvif->esr_disable_reason & IWL_MVM_ESR_DISABLE_COEX);
-	}
 
-	return ret;
+	return iwl_mvm_mld_valid_link_pair(vif, &data[0], &data[1]);
 }
 
 static bool iwl_mvm_mld_can_activate_links(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 7bf838b5bd98d..c45039d2ad2fa 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1580,15 +1580,14 @@ static inline int iwl_mvm_max_active_links(struct iwl_mvm *mvm,
 	struct iwl_trans *trans = mvm->fwrt.trans;
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
-	lockdep_assert_held(&mvm->mutex);
-
 	if (vif->type == NL80211_IFTYPE_AP)
 		return mvm->fw->ucode_capa.num_beacons;
 
+	/* Check if HW supports eSR or STR */
 	if ((iwl_mvm_is_esr_supported(trans) &&
-	     !mvmvif->esr_disable_reason) ||
-	    ((CSR_HW_RFID_TYPE(trans->hw_rf_id) == IWL_CFG_RF_TYPE_FM &&
-	     CSR_HW_RFID_IS_CDB(trans->hw_rf_id))))
+	     !(mvmvif->esr_disable_reason & ~IWL_MVM_ESR_DISABLE_COEX)) ||
+	    (CSR_HW_RFID_TYPE(trans->hw_rf_id) == IWL_CFG_RF_TYPE_FM &&
+	     CSR_HW_RFID_IS_CDB(trans->hw_rf_id)))
 		return IWL_MVM_FW_MAX_ACTIVE_LINKS_NUM;
 
 	return 1;
-- 
2.43.0



