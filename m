Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089341A6186;
	Tue, 30 Jul 2024 16:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356418; cv=none; b=sbrvddQRAUvww89OaAfTfdDfGRYD2NdrPuYoWp7NzGzPYDyeL42ueGb+gZmo/3sxVyZp/v3rQTK12sRDWDz+kJUu/rlHTozrEYwUjtFELC3Pl7JYodCtsqWkg9NkyqNF5Rwkt/cOEC7xP3/NO1UKCA6av88A3ebqNfHXGsT8Qv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356418; c=relaxed/simple;
	bh=H93dK2W4TfxucWro0nvazbhUDdTuOdJieg1R8mrZ2XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMZQKsx0nSA45TsV40GET34TWuDLtW3YWyHv7ml63spZzyBN4isRJCWSc4ha+ZEzJbXwzimBugQjb8LIkRVnGPuhlE+gEvIdTXruHXsoF8ldsaZgH0nn2R/5swrP/PNDsWgz8kshxytUF8Z71V3CbIOyJt/HJdgkyP8GhdKv7j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uTohWyzy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uTohWyzy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7957EC32782;
	Tue, 30 Jul 2024 16:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356417;
	bh=H93dK2W4TfxucWro0nvazbhUDdTuOdJieg1R8mrZ2XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTohWyzyr2U8ydxWoATmtblOMdMwJ3NJgM3z8/YEindd1jXO7vve8bnBOoUi/wXsd
	 zkW1nq9RBHoEBC3nWqjvbgMsv7TfdOtTQAvwEskkm8rR3b37yQ+viV48VOwhUCxkOk
	 7V7BtwMZKdTHdS4LKtkyZUiKJl1718OvVOouEO8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sarika Sharma <quic_sarishar@quicinc.com>,
	Karthikeyan Kathirvel <quic_kathirve@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 148/809] wifi: ath12k: Dont drop tx_status in failure case
Date: Tue, 30 Jul 2024 17:40:24 +0200
Message-ID: <20240730151730.450833223@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 5453bbd6fef4ca2fea3b4b338fc715d7135afc6f ]

When a station idles for a long time, hostapd will try to send
a QoS Null frame to the station as "poll". NL80211_CMD_PROBE_CLIENT
is used for this purpose.
And the skb will be added to ack_status_frame - waiting for a
completion via ieee80211_report_ack_skb().

But when the peer was already removed before the tx_complete arrives,
the peer will be missing. And when using dev_kfree_skb_any (instead
of going through mac80211), the entry will stay inside
ack_status_frames thus not clean up related information in its
internal data structures. This IDR will therefore run full after
8K request were generated for such clients.
At this point, the access point will then just stall and not allow
any new clients because idr_alloc() for ack_status_frame will fail.

ieee80211_free_txskb() on the other hand will (when required) call
ieee80211_report_ack_skb() and make sure that (when required) remove
the entry from the ack_status_frame and clean up related
information in its internal data structures.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sarika Sharma <quic_sarishar@quicinc.com>
Signed-off-by: Karthikeyan Kathirvel <quic_kathirve@quicinc.com>
Link: https://lore.kernel.org/r/20230802-ath11k-ack_status_leak-v2-1-c0af729d6229@narfation.org
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240430074313.885807-2-quic_kathirve@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_tx.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_tx.c b/drivers/net/wireless/ath/ath12k/dp_tx.c
index 9b6d7d72f57c4..81a85d5946f5a 100644
--- a/drivers/net/wireless/ath/ath12k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_tx.c
@@ -352,15 +352,15 @@ static void ath12k_dp_tx_free_txbuf(struct ath12k_base *ab,
 	u8 pdev_id = ath12k_hw_mac_id_to_pdev_id(ab->hw_params, mac_id);
 
 	skb_cb = ATH12K_SKB_CB(msdu);
+	ar = ab->pdevs[pdev_id].ar;
 
 	dma_unmap_single(ab->dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 	if (skb_cb->paddr_ext_desc)
 		dma_unmap_single(ab->dev, skb_cb->paddr_ext_desc,
 				 sizeof(struct hal_tx_msdu_ext_desc), DMA_TO_DEVICE);
 
-	dev_kfree_skb_any(msdu);
+	ieee80211_free_txskb(ar->ah->hw, msdu);
 
-	ar = ab->pdevs[pdev_id].ar;
 	if (atomic_dec_and_test(&ar->dp.num_tx_pending))
 		wake_up(&ar->dp.tx_empty_waitq);
 }
@@ -448,6 +448,7 @@ static void ath12k_dp_tx_complete_msdu(struct ath12k *ar,
 				       struct hal_tx_status *ts)
 {
 	struct ath12k_base *ab = ar->ab;
+	struct ath12k_hw *ah = ar->ah;
 	struct ieee80211_tx_info *info;
 	struct ath12k_skb_cb *skb_cb;
 
@@ -466,12 +467,12 @@ static void ath12k_dp_tx_complete_msdu(struct ath12k *ar,
 	rcu_read_lock();
 
 	if (!rcu_dereference(ab->pdevs_active[ar->pdev_idx])) {
-		dev_kfree_skb_any(msdu);
+		ieee80211_free_txskb(ah->hw, msdu);
 		goto exit;
 	}
 
 	if (!skb_cb->vif) {
-		dev_kfree_skb_any(msdu);
+		ieee80211_free_txskb(ah->hw, msdu);
 		goto exit;
 	}
 
-- 
2.43.0



