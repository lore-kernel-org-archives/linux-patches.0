Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB531D6DB5;
	Tue, 11 Nov 2025 00:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822203; cv=none; b=fn50r5+C05MpmGAw3cOSZ8u5Hsq4TOCcM6fJNCD9YwnH0t4+Wfa4rCAlsWHpV9SL/Fk2wandxmSLFBaWdFx65UXsRrNeb3OEsjjGLYwal5M+ibhxv52abNRLPPq6N9p+VDOltIz9jsHamNORXoI2X6C28jBasNZ8JEKXlkD+21A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822203; c=relaxed/simple;
	bh=DBwN3BIiPETQQzXbPX9AeamphGHbIq8lKwZCpIWCRs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rofrfHq8rB1G//ki8fcZaszaN/FZXX5L3xChOuiFsdZyc/2hjY5NYgjjnMkb9H/yKzNHtnI/JC0Kl3HvqmDcWgyHCaPYX+MuEvOxS6H62R6uwdGrHqyluJnhIQ9izkRHUA7lp6JsorgLvzlBT5Rd82m933sCyoTwTs4TVtiEqXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFp6OuKX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFp6OuKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80BDAC4CEFB;
	Tue, 11 Nov 2025 00:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822202;
	bh=DBwN3BIiPETQQzXbPX9AeamphGHbIq8lKwZCpIWCRs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFp6OuKX6rxPkrvHntU55ON11IcJJW4GpwBexgviFbwkBX5ePWESSdThTLPnBPUYl
	 DP+YTZy9EgEPiDYChqvnxoUTS9AH1LHcpnCHTCH8AAkavOIxbu9cb4lkPW72Po/QcY
	 deZJ4cXL5AIuMZfdFGZu2IxfMEglM/eoXPF6wEYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthik M <quic_karm@quicinc.com>,
	Muna Sinada <muna.sinada@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 031/849] wifi: ath12k: free skb during idr cleanup callback
Date: Tue, 11 Nov 2025 09:33:21 +0900
Message-ID: <20251111004537.200213550@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karthik M <quic_karm@quicinc.com>

[ Upstream commit 92282074e1d2e7b6da5c05fe38a7cc974187fe14 ]

ath12k just like ath11k [1] did not handle skb cleanup during idr
cleanup callback. Both ath12k_mac_vif_txmgmt_idr_remove() and
ath12k_mac_tx_mgmt_pending_free() performed idr cleanup and DMA
unmapping for skb but only ath12k_mac_tx_mgmt_pending_free() freed
skb. As a result, during vdev deletion a memory leak occurs.

Refactor all clean up steps into a new function. New function
ath12k_mac_tx_mgmt_free() creates a centralized area where idr
cleanup, DMA unmapping for skb and freeing skb is performed. Utilize
skb pointer given by idr_remove(), instead of passed as a function
argument because IDR will be protected by locking. This will prevent
concurrent modification of the same IDR.

Now ath12k_mac_tx_mgmt_pending_free() and
ath12k_mac_vif_txmgmt_idr_remove() call ath12k_mac_tx_mgmt_free().

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1

Link: https://lore.kernel.org/r/1637832614-13831-1-git-send-email-quic_srirrama@quicinc.com > # [1]
Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Karthik M <quic_karm@quicinc.com>
Signed-off-by: Muna Sinada <muna.sinada@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20250923220316.1595758-1-muna.sinada@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 34 ++++++++++++++-------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 2644b5d4b0bc8..d717e74b01c89 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -8304,23 +8304,32 @@ static void ath12k_mgmt_over_wmi_tx_drop(struct ath12k *ar, struct sk_buff *skb)
 		wake_up(&ar->txmgmt_empty_waitq);
 }
 
-int ath12k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx)
+static void ath12k_mac_tx_mgmt_free(struct ath12k *ar, int buf_id)
 {
-	struct sk_buff *msdu = skb;
+	struct sk_buff *msdu;
 	struct ieee80211_tx_info *info;
-	struct ath12k *ar = ctx;
-	struct ath12k_base *ab = ar->ab;
 
 	spin_lock_bh(&ar->txmgmt_idr_lock);
-	idr_remove(&ar->txmgmt_idr, buf_id);
+	msdu = idr_remove(&ar->txmgmt_idr, buf_id);
 	spin_unlock_bh(&ar->txmgmt_idr_lock);
-	dma_unmap_single(ab->dev, ATH12K_SKB_CB(msdu)->paddr, msdu->len,
+
+	if (!msdu)
+		return;
+
+	dma_unmap_single(ar->ab->dev, ATH12K_SKB_CB(msdu)->paddr, msdu->len,
 			 DMA_TO_DEVICE);
 
 	info = IEEE80211_SKB_CB(msdu);
 	memset(&info->status, 0, sizeof(info->status));
 
-	ath12k_mgmt_over_wmi_tx_drop(ar, skb);
+	ath12k_mgmt_over_wmi_tx_drop(ar, msdu);
+}
+
+int ath12k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx)
+{
+	struct ath12k *ar = ctx;
+
+	ath12k_mac_tx_mgmt_free(ar, buf_id);
 
 	return 0;
 }
@@ -8329,17 +8338,10 @@ static int ath12k_mac_vif_txmgmt_idr_remove(int buf_id, void *skb, void *ctx)
 {
 	struct ieee80211_vif *vif = ctx;
 	struct ath12k_skb_cb *skb_cb = ATH12K_SKB_CB(skb);
-	struct sk_buff *msdu = skb;
 	struct ath12k *ar = skb_cb->ar;
-	struct ath12k_base *ab = ar->ab;
 
-	if (skb_cb->vif == vif) {
-		spin_lock_bh(&ar->txmgmt_idr_lock);
-		idr_remove(&ar->txmgmt_idr, buf_id);
-		spin_unlock_bh(&ar->txmgmt_idr_lock);
-		dma_unmap_single(ab->dev, skb_cb->paddr, msdu->len,
-				 DMA_TO_DEVICE);
-	}
+	if (skb_cb->vif == vif)
+		ath12k_mac_tx_mgmt_free(ar, buf_id);
 
 	return 0;
 }
-- 
2.51.0



