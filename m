Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67EE2DF73;
	Mon,  8 Apr 2024 13:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581697; cv=none; b=LXpMy/JCjTW/SNJqEB4At/VYB8OktCSmUBRb1wkbox5C+cPyHToW6nuGJ1NGToIaguFyV+HKOd7uG35jNQ8VbGr/lvtyOFQPpQxYVl/nafNA5kLzWlbUyJLsLpo6hc1CXDGeTGGU9sSgZUtJ9SOnjUTAlC5uDRUx/Y2kVyCUHwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581697; c=relaxed/simple;
	bh=i7/ey5LouSwJ9NtlaksfL/crOslbTIrxN9uhw9vv7Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzFKMo4LcUMqWcUxAGBHA5pz3Flwq17q1ZIaXv0D2DIF1HRfhYmPTnRjBNDs5m83lM4TVXc4WN3MPTHov0x4cT7AIwfINfo2MIwc4KReEhgJ5ZQdtuQaF/j1DUnsNnJsOhra+kC9XtlBASZLubtF71sHhjnZD+CX3zc5aenvPio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9sd/8Gf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9sd/8Gf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484BAC433C7;
	Mon,  8 Apr 2024 13:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581697;
	bh=i7/ey5LouSwJ9NtlaksfL/crOslbTIrxN9uhw9vv7Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9sd/8GfDBlpeUVTgHBC4FfMsp1V632BpEnU91w2fwnNqq39ef7HWWhoWRAhoggfa
	 wpnpwjGMiReVXVBhY/hJBA573TEQUXqMrUNtAyprJbhK9Qcigrs6SgmawPqy2lPkds
	 U7dj4AX0Pqt8rG4BpK6NzF+IJABpJ3/O1Pmn7Cjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 013/273] wifi: iwlwifi: mvm: include link ID when releasing frames
Date: Mon,  8 Apr 2024 14:54:48 +0200
Message-ID: <20240408125309.698212556@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 7bf2a5947e5e9..481dfbbe46162 100644
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
 
@@ -587,7 +579,7 @@ static void iwl_mvm_release_frames(struct iwl_mvm *mvm,
 		while ((skb = __skb_dequeue(skb_list))) {
 			iwl_mvm_pass_packet_to_mac80211(mvm, napi, skb,
 							reorder_buf->queue,
-							sta, NULL /* FIXME */);
+							sta);
 			reorder_buf->num_stored--;
 		}
 	}
@@ -2214,6 +2206,11 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
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
@@ -2357,8 +2354,7 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
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



