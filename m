Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44A0C142
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 18:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0DDC433C9;
	Mon,  4 Sep 2023 18:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693852359;
	bh=BSTnDk34sV4jwTX5gvvAlX7ieRnjlashWPnClAVIFP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJ53HN4txUe/g+llGqhKDcPs12WheVgPZ8qv6ROPNVxkkzQ0yI5RsTCiygmFLZfcx
	 8eQ2x01gpn67WVxUFkYEViZytFAWy3DhPFTfFddzKMeaK7gSCmkohQn7phhggLORQ3
	 nxs7hpYco3Sraz9gWbjzxIWX1t5rc8lMUFMj8qY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Kalle Valo <quic_kvalo@quicinc.com>
Subject: [PATCH 6.5 23/34] wifi: ath11k: Cleanup mac80211 references on failure during tx_complete
Date: Mon,  4 Sep 2023 19:30:10 +0100
Message-ID: <20230904182949.678191131@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230904182948.594404081@linuxfoundation.org>
References: <20230904182948.594404081@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 29d15589f084d71a4ea8c544039c5839db0236e2 upstream.

When a function is using functions from mac80211 to free an skb then it
should do it consistently and not switch to the generic dev_kfree_skb_any
(or similar functions). Otherwise (like in the error handlers), mac80211
will will not be aware of the freed skb and thus not clean up related
information in its internal data structures.

Not doing so lead in the past to filled up structure which then prevented
new clients to connect.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Fixes: 6257c702264c ("wifi: ath11k: fix tx status reporting in encap offload mode")
Cc: stable@vger.kernel.org
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230802-ath11k-ack_status_leak-v2-2-c0af729d6229@narfation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/dp_tx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath/ath11k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_tx.c
@@ -344,7 +344,7 @@ ath11k_dp_tx_htt_tx_complete_buf(struct
 	dma_unmap_single(ab->dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 
 	if (!skb_cb->vif) {
-		dev_kfree_skb_any(msdu);
+		ieee80211_free_txskb(ar->hw, msdu);
 		return;
 	}
 
@@ -566,12 +566,12 @@ static void ath11k_dp_tx_complete_msdu(s
 	dma_unmap_single(ab->dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 
 	if (unlikely(!rcu_access_pointer(ab->pdevs_active[ar->pdev_idx]))) {
-		dev_kfree_skb_any(msdu);
+		ieee80211_free_txskb(ar->hw, msdu);
 		return;
 	}
 
 	if (unlikely(!skb_cb->vif)) {
-		dev_kfree_skb_any(msdu);
+		ieee80211_free_txskb(ar->hw, msdu);
 		return;
 	}
 


