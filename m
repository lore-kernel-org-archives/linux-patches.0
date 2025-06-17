Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BC82ED17E;
	Tue, 17 Jun 2025 16:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176567; cv=none; b=ukBxNJP+o/sIG+snc9iMVNCP98uPQokgkJrVl54tbnpSxBSooRloo6dfJGeDF72nmgbvdmDp7v7oAcnZgbz7ghFAJp2yUEDLrDXR5GTUj72vwZFjUrmqUPw0H+PdX27XK0xFMux31RwNgGcm9NfmkAc1BtjwQ6jk8oRjoQT12C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176567; c=relaxed/simple;
	bh=MMRm9uv6PaiIqj1rNX/kJ5XaPsFp8R6EY1LT7zHug1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/rQSyN//1nDVSIrowYXqbI1dxgQ2Bz0CvFXsdmO6FZ+Npgf482r5sJ1RfJn6GxP1tJWMXB3hDeGf9XWBmz8l2vNhf3qaC7F8K3ad2DbW3gMdmUGMBoJyWRDVYUWWeBM+kyrzNK4sFR/QLPYBO8aeZbBSEg+Ctcy9kov/MitbBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eisL50cy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eisL50cy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD956C4CEE7;
	Tue, 17 Jun 2025 16:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176567;
	bh=MMRm9uv6PaiIqj1rNX/kJ5XaPsFp8R6EY1LT7zHug1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eisL50cyntYXQQhBstRQbHsqYY9TjbK0R5y4joNGm8bSMd59/Ele/rktNaENzVpe7
	 8HBfflpItjgdxcdKpMSEd/7STLTzLC/5ThJXW/b0f9rrUtJFCAhHiaGg/i6lVdomeO
	 SBbz69ntaUUPzZ6Oy+uo8VzGPKoGpz6Cwe4J0QSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	P Praneesh <praneesh.p@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 202/780] wifi: ath12k: Handle error cases during extended skb allocation
Date: Tue, 17 Jun 2025 17:18:30 +0200
Message-ID: <20250617152459.689064693@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: P Praneesh <praneesh.p@oss.qualcomm.com>

[ Upstream commit 37a068fc9dc4feb8d76e8896bb33883d06c11a6b ]

Currently, in the case of extended skb allocation, the buffer is freed
before the DMA unmap operation. This premature deletion can result in
skb->data corruption, as the memory region could be re-allocated for other
purposes. Fix this issue by reordering the failure cases by calling
dma_unmap_single() first, then followed by the corresponding kfree_skb().
This helps avoid data corruption in case of failures in dp_tx().

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: P Praneesh <praneesh.p@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250411060154.1388159-2-praneesh.p@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_tx.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_tx.c b/drivers/net/wireless/ath/ath12k/dp_tx.c
index 1e2788df476c2..f82d2c58eff3f 100644
--- a/drivers/net/wireless/ath/ath12k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_tx.c
@@ -229,7 +229,7 @@ int ath12k_dp_tx(struct ath12k *ar, struct ath12k_link_vif *arvif,
 	struct ath12k_skb_cb *skb_cb = ATH12K_SKB_CB(skb);
 	struct hal_tcl_data_cmd *hal_tcl_desc;
 	struct hal_tx_msdu_ext_desc *msg;
-	struct sk_buff *skb_ext_desc;
+	struct sk_buff *skb_ext_desc = NULL;
 	struct hal_srng *tcl_ring;
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	struct ath12k_vif *ahvif = arvif->ahvif;
@@ -415,18 +415,15 @@ int ath12k_dp_tx(struct ath12k *ar, struct ath12k_link_vif *arvif,
 			if (ret < 0) {
 				ath12k_dbg(ab, ATH12K_DBG_DP_TX,
 					   "Failed to add HTT meta data, dropping packet\n");
-				kfree_skb(skb_ext_desc);
-				goto fail_unmap_dma;
+				goto fail_free_ext_skb;
 			}
 		}
 
 		ti.paddr = dma_map_single(ab->dev, skb_ext_desc->data,
 					  skb_ext_desc->len, DMA_TO_DEVICE);
 		ret = dma_mapping_error(ab->dev, ti.paddr);
-		if (ret) {
-			kfree_skb(skb_ext_desc);
-			goto fail_unmap_dma;
-		}
+		if (ret)
+			goto fail_free_ext_skb;
 
 		ti.data_len = skb_ext_desc->len;
 		ti.type = HAL_TCL_DESC_TYPE_EXT_DESC;
@@ -462,7 +459,7 @@ int ath12k_dp_tx(struct ath12k *ar, struct ath12k_link_vif *arvif,
 			ring_selector++;
 		}
 
-		goto fail_unmap_dma;
+		goto fail_unmap_dma_ext;
 	}
 
 	ath12k_hal_tx_cmd_desc_setup(ab, hal_tcl_desc, &ti);
@@ -478,13 +475,16 @@ int ath12k_dp_tx(struct ath12k *ar, struct ath12k_link_vif *arvif,
 
 	return 0;
 
-fail_unmap_dma:
-	dma_unmap_single(ab->dev, ti.paddr, ti.data_len, DMA_TO_DEVICE);
-
+fail_unmap_dma_ext:
 	if (skb_cb->paddr_ext_desc)
 		dma_unmap_single(ab->dev, skb_cb->paddr_ext_desc,
 				 sizeof(struct hal_tx_msdu_ext_desc),
 				 DMA_TO_DEVICE);
+fail_free_ext_skb:
+	kfree_skb(skb_ext_desc);
+
+fail_unmap_dma:
+	dma_unmap_single(ab->dev, ti.paddr, ti.data_len, DMA_TO_DEVICE);
 
 fail_remove_tx_buf:
 	ath12k_dp_tx_release_txbuf(dp, tx_desc, pool_id);
-- 
2.39.5



