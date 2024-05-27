Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2BD17E90E;
	Mon, 27 May 2024 19:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836706; cv=none; b=GzjiikCmXjro81U/DwuMqo+oicgTsgvZMwC2q+eC2KBQ0593fhWrla6kOXgJxGPrMOks+stY27Et3yCeK7E3xODFs++50YUNngBW0KLdT2Lz7K1nz0oKxJJJtggzHLVrtGfOHP43BTvbYCTtQxShNAYjYB034qRddgvwjycJa1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836706; c=relaxed/simple;
	bh=r/1qOnrFNgNjRdHHhOWYWZJlosquBT9PguyamenhGdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETzxI68XzMxZkMPCwqhhRart8zyQhX/YYN2yqifXrvNj0q5NT2a95I8IM3ziCd317VQOhr8v1gvOuB8iAoVaBopCj1ee7LnnJhQoYxH7WGFV6+sRsGJx4hnHjY/hNTB+EIlO0nm3uWm+ADiN6QFdnl3Mwf+Evir1jbV2wmRC7iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ktJQPwQe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ktJQPwQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE01CC2BBFC;
	Mon, 27 May 2024 19:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836706;
	bh=r/1qOnrFNgNjRdHHhOWYWZJlosquBT9PguyamenhGdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ktJQPwQe2M7BjGlJ/esKALpIXo000O71t6nkLPv4PBp/oL1oXRyMEhcjvi8THrBKv
	 1f6rHsOTvEtI9vby7p/6IF6K8t0WIxPLiiUCsxxbyhg70c5wv35UndpHgNz2NEBPur
	 s1ELv4W7Rfwliyy7Jrov9sozxCQqL61Fox1GmlSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 156/427] wifi: iwlwifi: mvm: calculate EMLSR mode after connection
Date: Mon, 27 May 2024 20:53:23 +0200
Message-ID: <20240527185617.068357564@linuxfoundation.org>
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

[ Upstream commit 9c6921121961cc0cecccb95652be6d98116f854b ]

The function iwl_mvm_can_enter_esr() is (among others) calculating
if EMLSR mode is disabled due to BT coex by calling
iwl_mvm_bt_coex_calculate_esr_mode(), then stores the decision in
mvmvif::esr_disable_reason.
But there is no need to calculate this every time iwl_mvm_can_enter_esr
is called. Fix this by calculating it once after authorization,
and in iwl_mvm_can_enter_esr only check mvmvif::esr_disable_reason.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240416134215.a767e243366e.I3b32d36cda23f67dc103a28a9bdccb0039d22574@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 585ba158233f ("wifi: iwlwifi: mvm: don't always disable EMLSR due to BT coex")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c | 10 ++++-----
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 21 +++++++++++++++++++
 .../wireless/intel/iwlwifi/mvm/mld-mac80211.c | 13 ++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  9 +++-----
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c   |  4 ++--
 5 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
index 2a28e611088d6..5416e41189657 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
@@ -281,7 +281,7 @@ static void iwl_mvm_bt_coex_enable_esr(struct iwl_mvm *mvm,
  * This function receives the LB link id and checks if eSR should be
  * enabled or disabled (due to BT coex)
  */
-bool
+static bool
 iwl_mvm_bt_coex_calculate_esr_mode(struct iwl_mvm *mvm,
 				   struct ieee80211_vif *vif,
 				   int link_id, int primary_link)
@@ -338,9 +338,9 @@ iwl_mvm_bt_coex_calculate_esr_mode(struct iwl_mvm *mvm,
 	return wifi_loss_rate <= IWL_MVM_BT_COEX_WIFI_LOSS_THRESH;
 }
 
-void iwl_mvm_bt_coex_update_vif_esr(struct iwl_mvm *mvm,
-				    struct ieee80211_vif *vif,
-				    int link_id)
+void iwl_mvm_bt_coex_update_link_esr(struct iwl_mvm *mvm,
+				     struct ieee80211_vif *vif,
+				     int link_id)
 {
 	unsigned long usable_links = ieee80211_vif_usable_links(vif);
 	int primary_link = iwl_mvm_mld_get_primary_link(mvm, vif,
@@ -402,7 +402,7 @@ static void iwl_mvm_bt_notif_per_link(struct iwl_mvm *mvm,
 		return;
 	}
 
-	iwl_mvm_bt_coex_update_vif_esr(mvm, vif, link_id);
+	iwl_mvm_bt_coex_update_link_esr(mvm, vif, link_id);
 
 	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_COEX_SCHEMA_2))
 		min_ag_for_static_smps = BT_VERY_HIGH_TRAFFIC;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 5d937d647d98d..2425c22e83f4a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3789,6 +3789,24 @@ iwl_mvm_sta_state_auth_to_assoc(struct ieee80211_hw *hw,
 	return callbacks->update_sta(mvm, vif, sta);
 }
 
+static void iwl_mvm_bt_coex_update_vif_esr(struct iwl_mvm *mvm,
+					   struct ieee80211_vif *vif)
+{
+	unsigned long usable_links = ieee80211_vif_usable_links(vif);
+	u8 link_id;
+
+	for_each_set_bit(link_id, &usable_links, IEEE80211_MLD_MAX_NUM_LINKS) {
+		struct ieee80211_bss_conf *link_conf =
+			link_conf_dereference_protected(vif, link_id);
+
+		if (WARN_ON_ONCE(!link_conf))
+			return;
+
+		if (link_conf->chanreq.oper.chan->band == NL80211_BAND_2GHZ)
+			iwl_mvm_bt_coex_update_link_esr(mvm, vif, link_id);
+	}
+}
+
 static int
 iwl_mvm_sta_state_assoc_to_authorized(struct iwl_mvm *mvm,
 				      struct ieee80211_vif *vif,
@@ -3816,6 +3834,9 @@ iwl_mvm_sta_state_assoc_to_authorized(struct iwl_mvm *mvm,
 		callbacks->mac_ctxt_changed(mvm, vif, false);
 		iwl_mvm_mei_host_associated(mvm, vif, mvm_sta);
 
+		/* Calculate eSR mode due to BT coex */
+		iwl_mvm_bt_coex_update_vif_esr(mvm, vif);
+
 		/* when client is authorized (AP station marked as such),
 		 * try to enable more links
 		 */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
index 7a2a18f8b86e2..6ae8406ceb889 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -1294,13 +1294,13 @@ static bool iwl_mvm_can_enter_esr(struct iwl_mvm *mvm,
 				  unsigned long desired_links)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	int primary_link = iwl_mvm_mld_get_primary_link(mvm, vif,
-							desired_links);
+	u16 usable_links = ieee80211_vif_usable_links(vif);
 	const struct wiphy_iftype_ext_capab *ext_capa;
 	bool ret = true;
 	int link_id;
 
-	if (primary_link < 0)
+	if (!ieee80211_vif_is_mld(vif) || !vif->cfg.assoc ||
+	    hweight16(usable_links) <= 1)
 		return false;
 
 	if (!(vif->cfg.eml_cap & IEEE80211_EML_CAP_EMLSR_SUPP))
@@ -1323,12 +1323,7 @@ static bool iwl_mvm_can_enter_esr(struct iwl_mvm *mvm,
 		if (link_conf->chanreq.oper.chan->band != NL80211_BAND_2GHZ)
 			continue;
 
-		ret = iwl_mvm_bt_coex_calculate_esr_mode(mvm, vif, link_id,
-							 primary_link);
-		// Mark eSR as disabled for the next time
-		if (!ret)
-			mvmvif->esr_disable_reason |= IWL_MVM_ESR_DISABLE_COEX;
-		break;
+		return !(mvmvif->esr_disable_reason & IWL_MVM_ESR_DISABLE_COEX);
 	}
 
 	return ret;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 609565fadfefe..7bf838b5bd98d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -2141,12 +2141,9 @@ bool iwl_mvm_bt_coex_is_tpc_allowed(struct iwl_mvm *mvm,
 u8 iwl_mvm_bt_coex_get_single_ant_msk(struct iwl_mvm *mvm, u8 enabled_ants);
 u8 iwl_mvm_bt_coex_tx_prio(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 			   struct ieee80211_tx_info *info, u8 ac);
-bool iwl_mvm_bt_coex_calculate_esr_mode(struct iwl_mvm *mvm,
-					struct ieee80211_vif *vif,
-					int link_id, int primary_link);
-void iwl_mvm_bt_coex_update_vif_esr(struct iwl_mvm *mvm,
-				    struct ieee80211_vif *vif,
-				    int link_id);
+void iwl_mvm_bt_coex_update_link_esr(struct iwl_mvm *mvm,
+				     struct ieee80211_vif *vif,
+				     int link_id);
 
 /* beacon filtering */
 #ifdef CONFIG_IWLWIFI_DEBUGFS
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index b1add7942c5bf..395aef04f691f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -889,8 +889,8 @@ iwl_mvm_stat_iterator_all_links(struct iwl_mvm *mvm,
 
 		if (link_info->phy_ctxt &&
 		    link_info->phy_ctxt->channel->band == NL80211_BAND_2GHZ)
-			iwl_mvm_bt_coex_update_vif_esr(mvm, bss_conf->vif,
-						       link_id);
+			iwl_mvm_bt_coex_update_link_esr(mvm, bss_conf->vif,
+							link_id);
 
 		/* make sure that beacon statistics don't go backwards with TCM
 		 * request to clear statistics
-- 
2.43.0



