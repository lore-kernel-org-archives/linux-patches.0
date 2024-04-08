Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDE36CDA8;
	Mon,  8 Apr 2024 13:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581511; cv=none; b=Quq51YjF9+Q4704/xor53pm+boGJqIPjcfC+EqpE41RKl7mDVfq0AEPv/Wl41rzliMzgQiX5OUNdgYZqNVnlVIbTSVCMI3PdmFHFE3wG7chtN1a6w+2+lf/092Dv02jRcY9SjTrDGRU/Xq8xqLaW7M9f97RLCMsjD39bnF8FMMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581511; c=relaxed/simple;
	bh=LlXfEVjmhFFIhkdx4SwhPUh2FMLIX1eVqdMlZ0Xaijk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8qR50drjQ8fLOfrTFqC04asXDUqA5BkzFNugNFr6iu8r5CC3GbE+PRnSOyimddy+cRR28joLQ1yc7ZA0SfR+MZP3PoU2lkdx+J1Fn0b0/y89zHCPIYWIV2/xXF5sr98b6EUcZ8ktaWfKnUAgjaIa174TX1sDY4xkxzh9UjpJ0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=16gUVCOj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="16gUVCOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AD6C433F1;
	Mon,  8 Apr 2024 13:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581509;
	bh=LlXfEVjmhFFIhkdx4SwhPUh2FMLIX1eVqdMlZ0Xaijk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=16gUVCOj2dOgAwQoogpeD6RJnFAJmkZC5K7YNhsiIRgN1m23cDQBtt8lw0PaA/FXL
	 MaHNI1WoA7FnGrI+aoi5CuxqHaabbhHhvsNeAMphlHV91+Fdx2g1ZtU0GCvdCk2Eah
	 LEjqXTjUvTdqSDPmXvane9m7iEbQq5B1JPaa2Tkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/252] wifi: iwlwifi: mvm: include link ID when releasing frames
Date: Mon,  8 Apr 2024 14:55:12 +0200
Message-ID: <20240408125307.060488046@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit e78d7877308989ef91b64a3c746ae31324c07caa ]

When releasing frames from the reorder buffer, the link ID was not
included in the RX status information. This subsequently led mac80211 to
drop the frame. Change it so that the link information is set
immediately when possible so that it doesn't not need to be filled in
anymore when submitting the frame to mac80211.

Fixes: b8a85a1d42d7 ("wifi: iwlwifi: mvm: rxmq: report link ID to mac80211")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Tested-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240320232419.bbbd5e9bfe80.Iec1bf5c884e371f7bc5ea2534ed9ea8d3f2c0bf6@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 20 ++++++++-----------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 92b3e18dbe877..e9360b555ac93 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -236,21 +236,13 @@ static void iwl_mvm_add_rtap_sniffer_config(struct iwl_mvm *mvm,
 static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 					    struct napi_struct *napi,
 					    struct sk_buff *skb, int queue,
-					    struct ieee80211_sta *sta,
-					    struct ieee80211_link_sta *link_sta)
+					    struct ieee80211_sta *sta)
 {
 	if (unlikely(iwl_mvm_check_pn(mvm, skb, queue, sta))) {
 		kfree_skb(skb);
 		return;
 	}
 
-	if (sta && sta->valid_links && link_sta) {
-		struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
-
-		rx_status->link_valid = 1;
-		rx_status->link_id = link_sta->link_id;
-	}
-
 	ieee80211_rx_napi(mvm->hw, sta, skb, napi);
 }
 
@@ -636,7 +628,7 @@ static void iwl_mvm_release_frames(struct iwl_mvm *mvm,
 		while ((skb = __skb_dequeue(skb_list))) {
 			iwl_mvm_pass_packet_to_mac80211(mvm, napi, skb,
 							reorder_buf->queue,
-							sta, NULL /* FIXME */);
+							sta);
 			reorder_buf->num_stored--;
 		}
 	}
@@ -2489,6 +2481,11 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			if (IS_ERR(sta))
 				sta = NULL;
 			link_sta = rcu_dereference(mvm->fw_id_to_link_sta[id]);
+
+			if (sta && sta->valid_links && link_sta) {
+				rx_status->link_valid = 1;
+				rx_status->link_id = link_sta->link_id;
+			}
 		}
 	} else if (!is_multicast_ether_addr(hdr->addr2)) {
 		/*
@@ -2630,8 +2627,7 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 		    !(desc->amsdu_info & IWL_RX_MPDU_AMSDU_LAST_SUBFRAME))
 			rx_status->flag |= RX_FLAG_AMSDU_MORE;
 
-		iwl_mvm_pass_packet_to_mac80211(mvm, napi, skb, queue, sta,
-						link_sta);
+		iwl_mvm_pass_packet_to_mac80211(mvm, napi, skb, queue, sta);
 	}
 out:
 	rcu_read_unlock();
-- 
2.43.0



