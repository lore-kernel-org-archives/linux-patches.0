Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D132C4E1C76;
	Thu, 17 Sep 2026 18:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668412; cv=none; b=Kf7Q716jCCXX3ZWQ5ntTr8dBNOW7F4E4bXUkbMTfs4kXk47Pc7CYcEZKMQKHbyyMIf0SOp4GHNWHSyzGgImdGoob798SZIUvTIEEXEbASvRc/i6bl5k4QToxOpZtXiaguOfrIw/nFwjw3T6EVXGe04hefRUDtOPEi7FyTyEnXp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668412; c=relaxed/simple;
	bh=naxh5Dmli0Dg4M2X529aYaMZzXkkO3IPmboFajJtMK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kT8QhrM6sNwDbTJc8MWFBAue5uRdjc2c0xFu996pQ21YfP0QH8Ommn7obGsskuH8S+tVRBKDl3Qj/7l4JLlc4Re8bOmpsp7O5MYPm+6JSfbI4roGaZgJWzy7evMzjizU+G6a4SWbJhpY2a6kvM1SN2Kq1wATMyf8qFmcn0+ENgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jqQnPyw5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jqQnPyw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151A21F000FF;
	Thu, 17 Sep 2026 18:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668410;
	bh=7Ye77yaXn+1Mc0JODOI2z1vlMSXlbqcXRGFbxVOJ8V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jqQnPyw5x+mcQrmSAdlyltsA5j7La7H10b2i/cPbX/R39w4+n2+dblex37IGhToTT
	 xE9hfwc/mb1I1ES+UNU07GLQsMxnQMeaoU4peBO7M9ReOK05wmMpYYciYrKF6vCVML
	 ueFl8SQ3ud4cycbA0Bhf/DLlhDs1eE31zNJxSn8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0417/1102] wifi: iwlwifi: mvm: parse beacon notif per layout
Date: Thu, 17 Sep 2026 16:06:00 +0100
Message-ID: <20260917151550.134588178@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit b77c6f50b1f80414cb3f542ae72e532ed90fc7f7 ]

The beacon TX notification can arrive in different layouts, and fields
must be read only after selecting the expected format.

Parse gp2 and TSF from the matching notification structure in each
branch, and keep using the parsed gp2 for CSA countdown and debug output.
Drop the obsolete cached gp2 field.

Assisted-by: GitHub Copilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714141909.cc8aa937f8e5.I921f8dadcb20cb73e8283e1b8546e1778205411f@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 25 +++++++++++--------
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  1 -
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  3 ---
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 28d329ec31b82..a201ac1089d26 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1515,49 +1515,54 @@ void iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	unsigned int pkt_len = iwl_rx_packet_payload_len(pkt);
-	struct iwl_extended_beacon_notif *beacon = (void *)pkt->data;
-	struct iwl_extended_beacon_notif_v5 *beacon_v5 = (void *)pkt->data;
 	struct ieee80211_vif *csa_vif;
 	struct ieee80211_vif *tx_blocked_vif;
 	struct agg_tx_status *agg_status;
+	u32 beacon_gp2;
 	u16 status;
 
 	lockdep_assert_held(&mvm->mutex);
 
-	mvm->ap_last_beacon_gp2 = le32_to_cpu(beacon->gp2);
-
 	if (!iwl_mvm_is_short_beacon_notif_supported(mvm)) {
+		struct iwl_extended_beacon_notif_v5 *beacon = (void *)pkt->data;
 		struct iwl_tx_resp *beacon_notify_hdr =
-			&beacon_v5->beacon_notify_hdr;
+			&beacon->beacon_notify_hdr;
 
-		if (unlikely(pkt_len < sizeof(*beacon_v5)))
+		if (unlikely(pkt_len < sizeof(*beacon)))
 			return;
 
-		mvm->ibss_manager = beacon_v5->ibss_mgr_status != 0;
+		beacon_gp2 = le32_to_cpu(beacon->gp2);
+
+		mvm->ibss_manager = beacon->ibss_mgr_status != 0;
 		agg_status = iwl_mvm_get_agg_status(mvm, beacon_notify_hdr);
 		status = le16_to_cpu(agg_status->status) & TX_STATUS_MSK;
 		IWL_DEBUG_RX(mvm,
 			     "beacon status %#x retries:%d tsf:0x%016llX gp2:0x%X rate:%d\n",
 			     status, beacon_notify_hdr->failure_frame,
 			     le64_to_cpu(beacon->tsf),
-			     mvm->ap_last_beacon_gp2,
+			     beacon_gp2,
 			     le32_to_cpu(beacon_notify_hdr->initial_rate));
 	} else {
+		const struct iwl_extended_beacon_notif *beacon =
+			(void *)pkt->data;
+
 		if (unlikely(pkt_len < sizeof(*beacon)))
 			return;
 
+		beacon_gp2 = le32_to_cpu(beacon->gp2);
+
 		mvm->ibss_manager = beacon->ibss_mgr_status != 0;
 		status = le32_to_cpu(beacon->status) & TX_STATUS_MSK;
 		IWL_DEBUG_RX(mvm,
 			     "beacon status %#x tsf:0x%016llX gp2:0x%X\n",
 			     status, le64_to_cpu(beacon->tsf),
-			     mvm->ap_last_beacon_gp2);
+			     beacon_gp2);
 	}
 
 	csa_vif = rcu_dereference_protected(mvm->csa_vif,
 					    lockdep_is_held(&mvm->mutex));
 	if (unlikely(csa_vif && csa_vif->bss_conf.csa_active))
-		iwl_mvm_csa_count_down(mvm, csa_vif, mvm->ap_last_beacon_gp2,
+		iwl_mvm_csa_count_down(mvm, csa_vif, beacon_gp2,
 				       (status == TX_STATUS_SUCCESS));
 
 	tx_blocked_vif = rcu_dereference_protected(mvm->csa_tx_blocked_vif,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 0a1ba7a8f4562..9256bf81d1287 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3189,7 +3189,6 @@ void iwl_mvm_stop_ap_ibss_common(struct iwl_mvm *mvm,
 	}
 
 	mvmvif->ap_ibss_active = false;
-	mvm->ap_last_beacon_gp2 = 0;
 
 	if (vif->type == NL80211_IFTYPE_AP && !vif->p2p) {
 		iwl_mvm_vif_set_low_latency(mvmvif, false,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 7d86d273092ac..67d188409ca31 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1263,9 +1263,6 @@ struct iwl_mvm {
 	struct ieee80211_vif __rcu *csa_tx_blocked_vif;
 	u8 csa_tx_block_bcn_timeout;
 
-	/* system time of last beacon (for AP/GO interface) */
-	u32 ap_last_beacon_gp2;
-
 	/* indicates that we transmitted the last beacon */
 	bool ibss_manager;
 
-- 
2.53.0



