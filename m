Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7D3C142
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 18:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B10C433C7;
	Mon,  4 Sep 2023 18:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693852409;
	bh=Skflz2U0gV/+k9HlhJdAUaeBIJs7+IjUBDG8+UJCRBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azO5pMZhL5C2kLKjON1d73xMIHrTX37LleC/4TwI2nmnQpg2esMsYTHk/XTo6sjr1
	 MSMW4dHEQPp5JpIJw9/oEKAKxUhl5nYcKyJN6nw4Hcm7wc5ONumESl6CgMl525AQZu
	 SD2/VvycQ0Pb4/ALJ/gkD3e620hckZrzYJLx4EPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Kalle Valo <quic_kvalo@quicinc.com>
Subject: [PATCH 6.4 21/32] wifi: ath11k: Dont drop tx_status when peer cannot be found
Date: Mon,  4 Sep 2023 19:30:19 +0100
Message-ID: <20230904182948.878923493@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230904182947.899158313@linuxfoundation.org>
References: <20230904182947.899158313@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 400ece6c7f346b0a30867bd00b03b5b2563d4357 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/dp_tx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath11k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_tx.c
@@ -369,7 +369,7 @@ ath11k_dp_tx_htt_tx_complete_buf(struct
 			   "dp_tx: failed to find the peer with peer_id %d\n",
 			    ts->peer_id);
 		spin_unlock_bh(&ab->base_lock);
-		dev_kfree_skb_any(msdu);
+		ieee80211_free_txskb(ar->hw, msdu);
 		return;
 	}
 	spin_unlock_bh(&ab->base_lock);
@@ -624,7 +624,7 @@ static void ath11k_dp_tx_complete_msdu(s
 			   "dp_tx: failed to find the peer with peer_id %d\n",
 			    ts->peer_id);
 		spin_unlock_bh(&ab->base_lock);
-		dev_kfree_skb_any(msdu);
+		ieee80211_free_txskb(ar->hw, msdu);
 		return;
 	}
 	arsta = (struct ath11k_sta *)peer->sta->drv_priv;


