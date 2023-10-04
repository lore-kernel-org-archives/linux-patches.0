Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4B41D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKmgEH+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4247C433C8;
	Wed,  4 Oct 2023 18:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443568;
	bh=T2tDmQZMdSB+xCM2yXpP2WATsyQgM8XCxXBFOEfNwvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKmgEH+8Zi2Tv3bm2U7DCKdXKrDzq6BhmfJAjdPuEVbwmL1tLFJ6MbGiBAUX7ZSaI
	 eHKHsKZBvGmnFdH8F0gYIsE8ccdvRBgr5QRRHPI60R+GrVp0UflDcBKcN5U3uPoWer
	 3oKWLPiIrEnGyHUBXh0Ue0VjzcC+cnVQxtc2EMjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 203/259] wifi: ath11k: Dont drop tx_status when peer cannot be found
Date: Wed,  4 Oct 2023 19:56:16 +0200
Message-ID: <20231004175226.592376938@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 400ece6c7f346b0a30867bd00b03b5b2563d4357 ]

When a station idles for a long time, hostapd will try to send a QoS Null
frame to the station as "poll". NL80211_CMD_PROBE_CLIENT is used for this
purpose. And the skb will be added to ack_status_frame - waiting for a
completion via ieee80211_report_ack_skb().

But when the peer was already removed before the tx_complete arrives, the
peer will be missing. And when using dev_kfree_skb_any (instead of going
through mac80211), the entry will stay inside ack_status_frames. This IDR
will therefore run full after 8K request were generated for such clients.
At this point, the access point will then just stall and not allow any new
clients because idr_alloc() for ack_status_frame will fail.

ieee80211_free_txskb() on the other hand will (when required) call
ieee80211_report_ack_skb() and make sure that (when required) remove the
entry from the ack_status_frame.

Tested-on: IPQ6018 hw1.0 WLAN.HK.2.5.0.1-01100-QCAHKSWPL_SILICONZ-1

Fixes: 6257c702264c ("wifi: ath11k: fix tx status reporting in encap offload mode")
Fixes: 94739d45c388 ("ath11k: switch to using ieee80211_tx_status_ext()")
Cc: stable@vger.kernel.org
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230802-ath11k-ack_status_leak-v2-1-c0af729d6229@narfation.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_tx.c b/drivers/net/wireless/ath/ath11k/dp_tx.c
index 64c8ccac22d27..cd24488612454 100644
--- a/drivers/net/wireless/ath/ath11k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_tx.c
@@ -369,7 +369,7 @@ ath11k_dp_tx_htt_tx_complete_buf(struct ath11k_base *ab,
 			   "dp_tx: failed to find the peer with peer_id %d\n",
 			    ts->peer_id);
 		spin_unlock_bh(&ab->base_lock);
-		dev_kfree_skb_any(msdu);
+		ieee80211_free_txskb(ar->hw, msdu);
 		return;
 	}
 	spin_unlock_bh(&ab->base_lock);
@@ -624,7 +624,7 @@ static void ath11k_dp_tx_complete_msdu(struct ath11k *ar,
 			   "dp_tx: failed to find the peer with peer_id %d\n",
 			    ts->peer_id);
 		spin_unlock_bh(&ab->base_lock);
-		dev_kfree_skb_any(msdu);
+		ieee80211_free_txskb(ar->hw, msdu);
 		return;
 	}
 	arsta = (struct ath11k_sta *)peer->sta->drv_priv;
-- 
2.40.1



