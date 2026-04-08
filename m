Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E249B3537EF;
	Wed,  8 Apr 2026 18:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672897; cv=none; b=Ypm4bQmBCpoFazhdOI68EcANO4u4Eq8CiTwdnfu8d4MiK8btRt8w+lLkIkSaD+nyD5W6AFTs9bbUS2agnRIIPOiITN3NWaT7cFZptbKQqRjLf4I48wmqh1hy7iaycTdz6K7rzjHxrBR3GLMT5Ant+tJijg+FBOwwUWDfhgg5JzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672897; c=relaxed/simple;
	bh=ccAkQgDMhm8OzdNY4tz6hA3XJZxnNDO1jOfm76E/d3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FllnCADmJLzO3ZUrDs2v642X54KiAH6+rDv0UnmgFA7op2iNoXtBtij6nGxoUyU0qa8u3krErqlFiJTYBCCkPz9A7vAq6hFbRm4+NwNV4GdzLAYU7onYG/9f9Elrz/7u5MYf4+DeMMTVgscqFJV/7eWPRrDCHN8JMrJ1VuaCRNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UMrxZIC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UMrxZIC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F06C19421;
	Wed,  8 Apr 2026 18:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672896;
	bh=ccAkQgDMhm8OzdNY4tz6hA3XJZxnNDO1jOfm76E/d3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UMrxZIC84BOHE7eGNuo8LsU5WYrWNzQ59pV53ZuFwCvrjAYrmLcQE/vh2Af2WArbP
	 3rCCafdu9RrFkSG9kMGb1aOB80GTXm2zP9Jm8wSCRb8GAfvVY/RUNOarZCs3+QwyzO
	 f1CqaL6nFWUDAQNxHhCmEr6opBolx8xl2fY3XZNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 023/277] wifi: iwlwifi: mld: correctly set wifi generation data
Date: Wed,  8 Apr 2026 20:00:08 +0200
Message-ID: <20260408175934.719303511@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 687a95d204e72e52f2e6bc7a994cc82f76b2678f ]

In each MAC context, the firmware expects the wifi generation
data, i.e. whether or not HE/EHT (and in the future UHR) is
enabled on that MAC.

However, this is currently handled wrong in two ways:
 - EHT is only enabled when the interface is also an MLD, but
   we currently allow (despite the spec) connecting with EHT
   but without MLO.
 - when HE or EHT are used by TDLS peers, the firmware needs
   to have them enabled regardless of the AP

Fix this by iterating setting up the data depending on the
interface type:
 - for AP, just set it according to the BSS configuration
 - for monitor, set it according to HW capabilities
 - otherwise, particularly for client, iterate all stations
   and then their links on the interface in question and set
   according to their capabilities, this handles the AP and
   TDLS peers. Re-calculate this whenever a TDLS station is
   marked associated or removed so that it's kept updated,
   for the AP it's already updated on assoc/disassoc.

Fixes: d1e879ec600f ("wifi: iwlwifi: add iwlmld sub-driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260319110722.404713b22177.Ic972b5e557d011a5438f8f97c1e793cc829e2ea9@changeid
Link: https://patch.msgid.link/20260324093333.2953495-1-miriam.rachel.korenblit@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/mld/iface.c    | 101 ++++++++++++------
 .../net/wireless/intel/iwlwifi/mld/mac80211.c |  19 ++++
 2 files changed, 88 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/iface.c b/drivers/net/wireless/intel/iwlwifi/mld/iface.c
index 240ce19996b34..80bcd18930c57 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/iface.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/iface.c
@@ -111,14 +111,75 @@ static bool iwl_mld_is_nic_ack_enabled(struct iwl_mld *mld,
 			       IEEE80211_HE_MAC_CAP2_ACK_EN);
 }
 
-static void iwl_mld_set_he_support(struct iwl_mld *mld,
-				   struct ieee80211_vif *vif,
-				   struct iwl_mac_config_cmd *cmd)
+struct iwl_mld_mac_wifi_gen_sta_iter_data {
+	struct ieee80211_vif *vif;
+	struct iwl_mac_wifi_gen_support *support;
+};
+
+static void iwl_mld_mac_wifi_gen_sta_iter(void *_data,
+					  struct ieee80211_sta *sta)
 {
-	if (vif->type == NL80211_IFTYPE_AP)
-		cmd->wifi_gen.he_ap_support = 1;
-	else
-		cmd->wifi_gen.he_support = 1;
+	struct iwl_mld_sta *mld_sta = iwl_mld_sta_from_mac80211(sta);
+	struct iwl_mld_mac_wifi_gen_sta_iter_data *data = _data;
+	struct ieee80211_link_sta *link_sta;
+	unsigned int link_id;
+
+	if (mld_sta->vif != data->vif)
+		return;
+
+	for_each_sta_active_link(data->vif, sta, link_sta, link_id) {
+		if (link_sta->he_cap.has_he)
+			data->support->he_support = 1;
+		if (link_sta->eht_cap.has_eht)
+			data->support->eht_support = 1;
+	}
+}
+
+static void iwl_mld_set_wifi_gen(struct iwl_mld *mld,
+				 struct ieee80211_vif *vif,
+				 struct iwl_mac_wifi_gen_support *support)
+{
+	struct iwl_mld_mac_wifi_gen_sta_iter_data sta_iter_data = {
+		.vif = vif,
+		.support = support,
+	};
+	struct ieee80211_bss_conf *link_conf;
+	unsigned int link_id;
+
+	switch (vif->type) {
+	case NL80211_IFTYPE_MONITOR:
+		/* for sniffer, set to HW capabilities */
+		support->he_support = 1;
+		support->eht_support = mld->trans->cfg->eht_supported;
+		break;
+	case NL80211_IFTYPE_AP:
+		/* for AP set according to the link configs */
+		for_each_vif_active_link(vif, link_conf, link_id) {
+			support->he_ap_support |= link_conf->he_support;
+			support->eht_support |= link_conf->eht_support;
+		}
+		break;
+	default:
+		/*
+		 * If we have MLO enabled, then the firmware needs to enable
+		 * address translation for the station(s) we add. That depends
+		 * on having EHT enabled in firmware, which in turn depends on
+		 * mac80211 in the iteration below.
+		 * However, mac80211 doesn't enable capabilities on the AP STA
+		 * until it has parsed the association response successfully,
+		 * so set EHT (and HE as a pre-requisite for EHT) when the vif
+		 * is an MLD.
+		 */
+		if (ieee80211_vif_is_mld(vif)) {
+			support->he_support = 1;
+			support->eht_support = 1;
+		}
+
+		ieee80211_iterate_stations_mtx(mld->hw,
+					       iwl_mld_mac_wifi_gen_sta_iter,
+					       &sta_iter_data);
+		break;
+	}
 }
 
 /* fill the common part for all interface types */
@@ -128,8 +189,6 @@ static void iwl_mld_mac_cmd_fill_common(struct iwl_mld *mld,
 					u32 action)
 {
 	struct iwl_mld_vif *mld_vif = iwl_mld_vif_from_mac80211(vif);
-	struct ieee80211_bss_conf *link_conf;
-	unsigned int link_id;
 
 	lockdep_assert_wiphy(mld->wiphy);
 
@@ -147,29 +206,7 @@ static void iwl_mld_mac_cmd_fill_common(struct iwl_mld *mld,
 	cmd->nic_not_ack_enabled =
 		cpu_to_le32(!iwl_mld_is_nic_ack_enabled(mld, vif));
 
-	/* If we have MLO enabled, then the firmware needs to enable
-	 * address translation for the station(s) we add. That depends
-	 * on having EHT enabled in firmware, which in turn depends on
-	 * mac80211 in the code below.
-	 * However, mac80211 doesn't enable HE/EHT until it has parsed
-	 * the association response successfully, so just skip all that
-	 * and enable both when we have MLO.
-	 */
-	if (ieee80211_vif_is_mld(vif)) {
-		iwl_mld_set_he_support(mld, vif, cmd);
-		cmd->wifi_gen.eht_support = 1;
-		return;
-	}
-
-	for_each_vif_active_link(vif, link_conf, link_id) {
-		if (!link_conf->he_support)
-			continue;
-
-		iwl_mld_set_he_support(mld, vif, cmd);
-
-		/* EHT, if supported, was already set above */
-		break;
-	}
+	iwl_mld_set_wifi_gen(mld, vif, &cmd->wifi_gen);
 }
 
 static void iwl_mld_fill_mac_cmd_sta(struct iwl_mld *mld,
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 0f2db3ed58530..67b61765adf39 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -1686,6 +1686,16 @@ static int iwl_mld_move_sta_state_up(struct iwl_mld *mld,
 
 		if (vif->type == NL80211_IFTYPE_STATION)
 			iwl_mld_link_set_2mhz_block(mld, vif, sta);
+
+		if (sta->tdls) {
+			/*
+			 * update MAC since wifi generation flags may change,
+			 * we also update MAC on association to the AP via the
+			 * vif assoc change
+			 */
+			iwl_mld_mac_fw_action(mld, vif, FW_CTXT_ACTION_MODIFY);
+		}
+
 		/* Now the link_sta's capabilities are set, update the FW */
 		iwl_mld_config_tlc(mld, vif, sta);
 
@@ -1795,6 +1805,15 @@ static int iwl_mld_move_sta_state_down(struct iwl_mld *mld,
 			/* just removed last TDLS STA, so enable PM */
 			iwl_mld_update_mac_power(mld, vif, false);
 		}
+
+		if (sta->tdls) {
+			/*
+			 * update MAC since wifi generation flags may change,
+			 * we also update MAC on disassociation to the AP via
+			 * the vif assoc change
+			 */
+			iwl_mld_mac_fw_action(mld, vif, FW_CTXT_ACTION_MODIFY);
+		}
 	} else {
 		return -EINVAL;
 	}
-- 
2.53.0



