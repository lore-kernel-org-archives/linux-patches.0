Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7AC4F4CEB;
	Thu, 17 Sep 2026 17:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665003; cv=none; b=uNYL1qbjq5l8Hu743S8karRHw8uSh8lIznLNwpCUrWBqneZJKPYRorzTKJJQFN7UQ9KiAZ/GQElHWGoIKutMACeX4tCSNf9RXMyTin+IwlhYT/tj8bhTKctjo9cGCjI1UPADXp9726wyTXKrMnQjQ4GOfFrP811KINI1XCQz7NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665003; c=relaxed/simple;
	bh=8CWxtQmXj92WxXIW1qNRpoGKhF/GYp5mxBM6A8EQ+UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKOEk2nmvFPYwnpvqlAqfinjsiIe+S784FC16N9RH38/cmwcSmxoIBGlQRFpucoBrQv3VvQxkX5Y7ZKdA2RurHn85PYq2U6wGLF2MJxr2BUmQcluDhegHRRVPHVjy/pVWpI8+G954bCW/TYJzGG+CG0UuVUvrte+vVy79Q87590=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1BrCHt9C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1BrCHt9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB02F1F000FF;
	Thu, 17 Sep 2026 17:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665002;
	bh=VqDIAIDAsu+pcylJZwh69nKJgGK7RalzQBC9MJj4glA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1BrCHt9CODHnjiGwbE/T5NPmWXnoxirV+pxRhG3dmC/0URZ89EtG8uGsVfHPc4Mvv
	 CM0wk9gGk0xmp+RE9n2WHyDLM5dfsazFpi05gKS+TNfp1eWdZvjgkT8siMxLB5reic
	 49154qS8dFpvU1CzJX2M89KvzS1ON9UqsvHE2M+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0520/1250] wifi: iwlwifi: mvm: parse beacon notif per layout
Date: Thu, 17 Sep 2026 16:05:15 +0100
Message-ID: <20260917151606.042823076@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 44380ebfe09d0..cee6bde6ec822 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1504,49 +1504,54 @@ void iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
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
index 92471bc7b505b..83fb3f9af4745 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3100,7 +3100,6 @@ void iwl_mvm_stop_ap_ibss_common(struct iwl_mvm *mvm,
 	}
 
 	mvmvif->ap_ibss_active = false;
-	mvm->ap_last_beacon_gp2 = 0;
 
 	if (vif->type == NL80211_IFTYPE_AP && !vif->p2p) {
 		iwl_mvm_vif_set_low_latency(mvmvif, false,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 2628361332895..319301504b7eb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1180,9 +1180,6 @@ struct iwl_mvm {
 	struct ieee80211_vif __rcu *csa_tx_blocked_vif;
 	u8 csa_tx_block_bcn_timeout;
 
-	/* system time of last beacon (for AP/GO interface) */
-	u32 ap_last_beacon_gp2;
-
 	/* indicates that we transmitted the last beacon */
 	bool ibss_manager;
 
-- 
2.53.0



