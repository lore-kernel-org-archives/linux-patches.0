Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7432F27BF8D;
	Tue, 27 May 2025 17:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368244; cv=none; b=AT/19mpTqd+80bnXUD/H9slJMY8AO7l17mihLDUHABVezkDr3FDKWZ1OdbAAV/7DVWqh70hWBQzLvAu9jZjcoMzy8l8XE+m5srH/7F3PHdjNvTChyeyNRLRGJvLZ1pQ0O0yVY1Da60c3yidQQAKBkokoMesmSqXinLQ10bhhpfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368244; c=relaxed/simple;
	bh=Dg56Wn2AecG93jMnSwodOP6F4moxeTqu8GTQ/5zSfds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DApplyNo9WTMPmYn4CPzSKkj2ACruPMcKjDShSa6RIno78cBNJrnbxDPv0oKagwtcPbtFZdWe0vR5gJtKQpM/EnsQZTe2byJ/vB8YkADcUrJ1ZgD2xa033BH3Mx/wu9uCQxmxLg5ljBP3xZzyTZgFmZz0ocmXLbuTxwpV/qbB/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PCBo2+KQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PCBo2+KQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B458DC4CEE9;
	Tue, 27 May 2025 17:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368244;
	bh=Dg56Wn2AecG93jMnSwodOP6F4moxeTqu8GTQ/5zSfds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PCBo2+KQ7O4S/jIYIiN8U+OJj8Tql9CKPyWYi+GNimSlqFXD5pyG6eZuRMpDf59eL
	 3grIaZjauFLr5dpMq35w2bBBt67s8SvR1bSwvt2jVbUO0LaVp8u3Yacn9Bs0EiQhDU
	 8H1y28J00Dg7tQkc3T5QVdCkcHolRvC6SKgPVZ6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Tim Harvey <tharvey@gateworks.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 614/783] wifi: ath11k: Use dma_alloc_noncoherent for rx_tid buffer allocation
Date: Tue, 27 May 2025 18:26:51 +0200
Message-ID: <20250527162538.149255952@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: P Praneesh <quic_ppranees@quicinc.com>

[ Upstream commit eeadc6baf8b3dcd32787cc84f0473dc2a2850370 ]

Currently, the driver allocates cacheable DMA buffers for the rx_tid
structure using kzalloc() and dma_map_single(). These buffers are
long-lived and can persist for the lifetime of the peer, which is not
advisable. Instead of using kzalloc() and dma_map_single() for allocating
cacheable DMA buffers, utilize the dma_alloc_noncoherent() helper for the
allocation of long-lived cacheable DMA buffers, such as the peer's rx_tid.
Since dma_alloc_noncoherent() returns unaligned physical and virtual
addresses, align them internally before use within the driver. This
ensures proper allocation of non-coherent memory through the kernel
helper.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1
Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3

Signed-off-by: P Praneesh <quic_ppranees@quicinc.com>
Tested-by: Tim Harvey <tharvey@gateworks.com>
Link: https://patch.msgid.link/20250119164219.647059-3-quic_ppranees@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp.h    |   6 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c | 117 +++++++++++-------------
 2 files changed, 58 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp.h b/drivers/net/wireless/ath/ath11k/dp.h
index f777314db8b36..7a55afd33be82 100644
--- a/drivers/net/wireless/ath/ath11k/dp.h
+++ b/drivers/net/wireless/ath/ath11k/dp.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: BSD-3-Clause-Clear */
 /*
  * Copyright (c) 2018-2019 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2023 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2021-2023, 2025 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #ifndef ATH11K_DP_H
@@ -20,7 +20,6 @@ struct ath11k_ext_irq_grp;
 
 struct dp_rx_tid {
 	u8 tid;
-	u32 *vaddr;
 	dma_addr_t paddr;
 	u32 size;
 	u32 ba_win_sz;
@@ -37,6 +36,9 @@ struct dp_rx_tid {
 	/* Timer info related to fragments */
 	struct timer_list frag_timer;
 	struct ath11k_base *ab;
+	u32 *vaddr_unaligned;
+	dma_addr_t paddr_unaligned;
+	u32 unaligned_size;
 };
 
 #define DP_REO_DESC_FREE_THRESHOLD  64
diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index b8b3dce9cdb53..a7a484a9ba7fb 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2018-2019 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2024 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2021-2025 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #include <linux/ieee80211.h>
@@ -675,11 +675,11 @@ void ath11k_dp_reo_cmd_list_cleanup(struct ath11k_base *ab)
 	list_for_each_entry_safe(cmd, tmp, &dp->reo_cmd_list, list) {
 		list_del(&cmd->list);
 		rx_tid = &cmd->data;
-		if (rx_tid->vaddr) {
-			dma_unmap_single(ab->dev, rx_tid->paddr,
-					 rx_tid->size, DMA_BIDIRECTIONAL);
-			kfree(rx_tid->vaddr);
-			rx_tid->vaddr = NULL;
+		if (rx_tid->vaddr_unaligned) {
+			dma_free_noncoherent(ab->dev, rx_tid->unaligned_size,
+					     rx_tid->vaddr_unaligned,
+					     rx_tid->paddr_unaligned, DMA_BIDIRECTIONAL);
+			rx_tid->vaddr_unaligned = NULL;
 		}
 		kfree(cmd);
 	}
@@ -689,11 +689,11 @@ void ath11k_dp_reo_cmd_list_cleanup(struct ath11k_base *ab)
 		list_del(&cmd_cache->list);
 		dp->reo_cmd_cache_flush_count--;
 		rx_tid = &cmd_cache->data;
-		if (rx_tid->vaddr) {
-			dma_unmap_single(ab->dev, rx_tid->paddr,
-					 rx_tid->size, DMA_BIDIRECTIONAL);
-			kfree(rx_tid->vaddr);
-			rx_tid->vaddr = NULL;
+		if (rx_tid->vaddr_unaligned) {
+			dma_free_noncoherent(ab->dev, rx_tid->unaligned_size,
+					     rx_tid->vaddr_unaligned,
+					     rx_tid->paddr_unaligned, DMA_BIDIRECTIONAL);
+			rx_tid->vaddr_unaligned = NULL;
 		}
 		kfree(cmd_cache);
 	}
@@ -708,11 +708,11 @@ static void ath11k_dp_reo_cmd_free(struct ath11k_dp *dp, void *ctx,
 	if (status != HAL_REO_CMD_SUCCESS)
 		ath11k_warn(dp->ab, "failed to flush rx tid hw desc, tid %d status %d\n",
 			    rx_tid->tid, status);
-	if (rx_tid->vaddr) {
-		dma_unmap_single(dp->ab->dev, rx_tid->paddr, rx_tid->size,
-				 DMA_BIDIRECTIONAL);
-		kfree(rx_tid->vaddr);
-		rx_tid->vaddr = NULL;
+	if (rx_tid->vaddr_unaligned) {
+		dma_free_noncoherent(dp->ab->dev, rx_tid->unaligned_size,
+				     rx_tid->vaddr_unaligned,
+				     rx_tid->paddr_unaligned, DMA_BIDIRECTIONAL);
+		rx_tid->vaddr_unaligned = NULL;
 	}
 }
 
@@ -749,10 +749,10 @@ static void ath11k_dp_reo_cache_flush(struct ath11k_base *ab,
 	if (ret) {
 		ath11k_err(ab, "failed to send HAL_REO_CMD_FLUSH_CACHE cmd, tid %d (%d)\n",
 			   rx_tid->tid, ret);
-		dma_unmap_single(ab->dev, rx_tid->paddr, rx_tid->size,
-				 DMA_BIDIRECTIONAL);
-		kfree(rx_tid->vaddr);
-		rx_tid->vaddr = NULL;
+		dma_free_noncoherent(ab->dev, rx_tid->unaligned_size,
+				     rx_tid->vaddr_unaligned,
+				     rx_tid->paddr_unaligned, DMA_BIDIRECTIONAL);
+		rx_tid->vaddr_unaligned = NULL;
 	}
 }
 
@@ -802,10 +802,10 @@ static void ath11k_dp_rx_tid_del_func(struct ath11k_dp *dp, void *ctx,
 
 	return;
 free_desc:
-	dma_unmap_single(ab->dev, rx_tid->paddr, rx_tid->size,
-			 DMA_BIDIRECTIONAL);
-	kfree(rx_tid->vaddr);
-	rx_tid->vaddr = NULL;
+	dma_free_noncoherent(ab->dev, rx_tid->unaligned_size,
+			     rx_tid->vaddr_unaligned,
+			     rx_tid->paddr_unaligned, DMA_BIDIRECTIONAL);
+	rx_tid->vaddr_unaligned = NULL;
 }
 
 void ath11k_peer_rx_tid_delete(struct ath11k *ar,
@@ -831,14 +831,16 @@ void ath11k_peer_rx_tid_delete(struct ath11k *ar,
 		if (ret != -ESHUTDOWN)
 			ath11k_err(ar->ab, "failed to send HAL_REO_CMD_UPDATE_RX_QUEUE cmd, tid %d (%d)\n",
 				   tid, ret);
-		dma_unmap_single(ar->ab->dev, rx_tid->paddr, rx_tid->size,
-				 DMA_BIDIRECTIONAL);
-		kfree(rx_tid->vaddr);
-		rx_tid->vaddr = NULL;
+		dma_free_noncoherent(ar->ab->dev, rx_tid->unaligned_size,
+				     rx_tid->vaddr_unaligned,
+				     rx_tid->paddr_unaligned, DMA_BIDIRECTIONAL);
+		rx_tid->vaddr_unaligned = NULL;
 	}
 
 	rx_tid->paddr = 0;
+	rx_tid->paddr_unaligned = 0;
 	rx_tid->size = 0;
+	rx_tid->unaligned_size = 0;
 }
 
 static int ath11k_dp_rx_link_desc_return(struct ath11k_base *ab,
@@ -982,10 +984,9 @@ static void ath11k_dp_rx_tid_mem_free(struct ath11k_base *ab,
 	if (!rx_tid->active)
 		goto unlock_exit;
 
-	dma_unmap_single(ab->dev, rx_tid->paddr, rx_tid->size,
-			 DMA_BIDIRECTIONAL);
-	kfree(rx_tid->vaddr);
-	rx_tid->vaddr = NULL;
+	dma_free_noncoherent(ab->dev, rx_tid->unaligned_size, rx_tid->vaddr_unaligned,
+			     rx_tid->paddr_unaligned, DMA_BIDIRECTIONAL);
+	rx_tid->vaddr_unaligned = NULL;
 
 	rx_tid->active = false;
 
@@ -1000,9 +1001,8 @@ int ath11k_peer_rx_tid_setup(struct ath11k *ar, const u8 *peer_mac, int vdev_id,
 	struct ath11k_base *ab = ar->ab;
 	struct ath11k_peer *peer;
 	struct dp_rx_tid *rx_tid;
-	u32 hw_desc_sz;
-	u32 *addr_aligned;
-	void *vaddr;
+	u32 hw_desc_sz, *vaddr;
+	void *vaddr_unaligned;
 	dma_addr_t paddr;
 	int ret;
 
@@ -1050,49 +1050,40 @@ int ath11k_peer_rx_tid_setup(struct ath11k *ar, const u8 *peer_mac, int vdev_id,
 	else
 		hw_desc_sz = ath11k_hal_reo_qdesc_size(DP_BA_WIN_SZ_MAX, tid);
 
-	vaddr = kzalloc(hw_desc_sz + HAL_LINK_DESC_ALIGN - 1, GFP_ATOMIC);
-	if (!vaddr) {
+	rx_tid->unaligned_size = hw_desc_sz + HAL_LINK_DESC_ALIGN - 1;
+	vaddr_unaligned = dma_alloc_noncoherent(ab->dev, rx_tid->unaligned_size, &paddr,
+						DMA_BIDIRECTIONAL, GFP_ATOMIC);
+	if (!vaddr_unaligned) {
 		spin_unlock_bh(&ab->base_lock);
 		return -ENOMEM;
 	}
 
-	addr_aligned = PTR_ALIGN(vaddr, HAL_LINK_DESC_ALIGN);
-
-	ath11k_hal_reo_qdesc_setup(addr_aligned, tid, ba_win_sz,
-				   ssn, pn_type);
-
-	paddr = dma_map_single(ab->dev, addr_aligned, hw_desc_sz,
-			       DMA_BIDIRECTIONAL);
-
-	ret = dma_mapping_error(ab->dev, paddr);
-	if (ret) {
-		spin_unlock_bh(&ab->base_lock);
-		ath11k_warn(ab, "failed to setup dma map for peer %pM rx tid %d: %d\n",
-			    peer_mac, tid, ret);
-		goto err_mem_free;
-	}
-
-	rx_tid->vaddr = vaddr;
-	rx_tid->paddr = paddr;
+	rx_tid->vaddr_unaligned = vaddr_unaligned;
+	vaddr = PTR_ALIGN(vaddr_unaligned, HAL_LINK_DESC_ALIGN);
+	rx_tid->paddr_unaligned = paddr;
+	rx_tid->paddr = rx_tid->paddr_unaligned + ((unsigned long)vaddr -
+			(unsigned long)rx_tid->vaddr_unaligned);
+	ath11k_hal_reo_qdesc_setup(vaddr, tid, ba_win_sz, ssn, pn_type);
 	rx_tid->size = hw_desc_sz;
 	rx_tid->active = true;
 
+	/* After dma_alloc_noncoherent, vaddr is being modified for reo qdesc setup.
+	 * Since these changes are not reflected in the device, driver now needs to
+	 * explicitly call dma_sync_single_for_device.
+	 */
+	dma_sync_single_for_device(ab->dev, rx_tid->paddr,
+				   rx_tid->size,
+				   DMA_TO_DEVICE);
 	spin_unlock_bh(&ab->base_lock);
 
-	ret = ath11k_wmi_peer_rx_reorder_queue_setup(ar, vdev_id, peer_mac,
-						     paddr, tid, 1, ba_win_sz);
+	ret = ath11k_wmi_peer_rx_reorder_queue_setup(ar, vdev_id, peer_mac, rx_tid->paddr,
+						     tid, 1, ba_win_sz);
 	if (ret) {
 		ath11k_warn(ar->ab, "failed to setup rx reorder queue for peer %pM tid %d: %d\n",
 			    peer_mac, tid, ret);
 		ath11k_dp_rx_tid_mem_free(ab, peer_mac, vdev_id, tid);
 	}
 
-	return ret;
-
-err_mem_free:
-	kfree(rx_tid->vaddr);
-	rx_tid->vaddr = NULL;
-
 	return ret;
 }
 
-- 
2.39.5



