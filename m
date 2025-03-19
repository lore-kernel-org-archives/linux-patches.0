Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9931DF986;
	Wed, 19 Mar 2025 14:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395021; cv=none; b=uH7VVFnnsGO+DjT0twhY7JNttdZq5DvC/wBl1O/C9GJcMYRxitSVufZOID/RiJNAvHkHZrGecmZ4VJP1qg8Z5SJfHd9Le4KreZtYcy+YqeBSyPE0a5GPU1vkYvOSa6A3sSegPHd0pSurj30CL6ha9kkoFZfB71nFZj8tKWFXYS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395021; c=relaxed/simple;
	bh=1YzsugiqYM2Ltd+d+IIML9rEaS51YMLRIiphjyhVRLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWvmMH/8RElAZ4rdEymLkrdwbSuhcF06j7kdmuUsSPchvYFd/fKXleCZ3jUfX52zK0Pnt2BSVIHlysRwcQ+fUNjXK+0cHfkUrYGe1ttc9mG2X+PtqRdoSVivF6wH7rMzYYUQKb3ZusULeSdYMtg9TrwetlsKxQ7b4tN07H2M7G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iSQyG5uS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iSQyG5uS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B03C4CEE4;
	Wed, 19 Mar 2025 14:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395021;
	bh=1YzsugiqYM2Ltd+d+IIML9rEaS51YMLRIiphjyhVRLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iSQyG5uSCdvrMx2eAGqJR0y5Z5VdRGPM+3yckZ2LjsQVFuy1QCiZLDqvRzjBXBe2N
	 usKHX8IqEvQOVolW+oM1UVxLmpvmWKO3+qWHCLt6YVXpClrbbiMeD4inFO3/ZGsKZ6
	 wkOjnGtvS+Abk4Atz390sW/D9idhGM/IWtm4fVLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/231] eth: bnxt: use page pool for head frags
Date: Wed, 19 Mar 2025 07:28:48 -0700
Message-ID: <20250319143027.679641867@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 7ed816be35abc3d5bed39d3edc5f2efed2ca5216 ]

Testing small size RPCs (300B-400B) on a large AMD system suggests
that page pool recycling is very useful even for just the head frags.
With this patch (and copy break disabled) I see a 30% performance
improvement (82Gbps -> 106Gbps).

Convert bnxt from normal page frags to page pool frags for head buffers.

On systems with small page size we can use the same pool as for TPA
pages. On systems with large pages the frag allocation logic of the
page pool is already used to split a large page into TPA chunks.
TPA chunks are much larger than heads (8k or 64k, AFAICT vs 1kB)
and we always allocate the same sized chunks. Mixing allocation
of TPA and head pages would lead to sub-optimal memory use.
Plus Taehee's work on zero-copy / devmem will need to differentiate
between TPA and non-TPA page pool, anyway. Conditionally allocate
a new page pool for heads.

Link: https://patch.msgid.link/20241109035119.3391864-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 87dd2850835d ("eth: bnxt: fix memory leak in queue reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 98 ++++++++++++-----------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 51 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index eba0f9991476c..b97bced5c002c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -864,6 +864,11 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int budget)
 		bnapi->events &= ~BNXT_TX_CMP_EVENT;
 }
 
+static bool bnxt_separate_head_pool(void)
+{
+	return PAGE_SIZE > BNXT_RX_PAGE_SIZE;
+}
+
 static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *mapping,
 					 struct bnxt_rx_ring_info *rxr,
 					 unsigned int *offset,
@@ -886,27 +891,19 @@ static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *mapping,
 }
 
 static inline u8 *__bnxt_alloc_rx_frag(struct bnxt *bp, dma_addr_t *mapping,
+				       struct bnxt_rx_ring_info *rxr,
 				       gfp_t gfp)
 {
-	u8 *data;
-	struct pci_dev *pdev = bp->pdev;
+	unsigned int offset;
+	struct page *page;
 
-	if (gfp == GFP_ATOMIC)
-		data = napi_alloc_frag(bp->rx_buf_size);
-	else
-		data = netdev_alloc_frag(bp->rx_buf_size);
-	if (!data)
+	page = page_pool_alloc_frag(rxr->head_pool, &offset,
+				    bp->rx_buf_size, gfp);
+	if (!page)
 		return NULL;
 
-	*mapping = dma_map_single_attrs(&pdev->dev, data + bp->rx_dma_offset,
-					bp->rx_buf_use_size, bp->rx_dir,
-					DMA_ATTR_WEAK_ORDERING);
-
-	if (dma_mapping_error(&pdev->dev, *mapping)) {
-		skb_free_frag(data);
-		data = NULL;
-	}
-	return data;
+	*mapping = page_pool_get_dma_addr(page) + bp->rx_dma_offset + offset;
+	return page_address(page) + offset;
 }
 
 int bnxt_alloc_rx_data(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
@@ -928,7 +925,7 @@ int bnxt_alloc_rx_data(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 		rx_buf->data = page;
 		rx_buf->data_ptr = page_address(page) + offset + bp->rx_offset;
 	} else {
-		u8 *data = __bnxt_alloc_rx_frag(bp, &mapping, gfp);
+		u8 *data = __bnxt_alloc_rx_frag(bp, &mapping, rxr, gfp);
 
 		if (!data)
 			return -ENOMEM;
@@ -1179,13 +1176,14 @@ static struct sk_buff *bnxt_rx_skb(struct bnxt *bp,
 	}
 
 	skb = napi_build_skb(data, bp->rx_buf_size);
-	dma_unmap_single_attrs(&bp->pdev->dev, dma_addr, bp->rx_buf_use_size,
-			       bp->rx_dir, DMA_ATTR_WEAK_ORDERING);
+	dma_sync_single_for_cpu(&bp->pdev->dev, dma_addr, bp->rx_buf_use_size,
+				bp->rx_dir);
 	if (!skb) {
-		skb_free_frag(data);
+		page_pool_free_va(rxr->head_pool, data, true);
 		return NULL;
 	}
 
+	skb_mark_for_recycle(skb);
 	skb_reserve(skb, bp->rx_offset);
 	skb_put(skb, offset_and_len & 0xffff);
 	return skb;
@@ -1840,7 +1838,8 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 		u8 *new_data;
 		dma_addr_t new_mapping;
 
-		new_data = __bnxt_alloc_rx_frag(bp, &new_mapping, GFP_ATOMIC);
+		new_data = __bnxt_alloc_rx_frag(bp, &new_mapping, rxr,
+						GFP_ATOMIC);
 		if (!new_data) {
 			bnxt_abort_tpa(cpr, idx, agg_bufs);
 			cpr->sw_stats->rx.rx_oom_discards += 1;
@@ -1852,16 +1851,16 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 		tpa_info->mapping = new_mapping;
 
 		skb = napi_build_skb(data, bp->rx_buf_size);
-		dma_unmap_single_attrs(&bp->pdev->dev, mapping,
-				       bp->rx_buf_use_size, bp->rx_dir,
-				       DMA_ATTR_WEAK_ORDERING);
+		dma_sync_single_for_cpu(&bp->pdev->dev, mapping,
+					bp->rx_buf_use_size, bp->rx_dir);
 
 		if (!skb) {
-			skb_free_frag(data);
+			page_pool_free_va(rxr->head_pool, data, true);
 			bnxt_abort_tpa(cpr, idx, agg_bufs);
 			cpr->sw_stats->rx.rx_oom_discards += 1;
 			return NULL;
 		}
+		skb_mark_for_recycle(skb);
 		skb_reserve(skb, bp->rx_offset);
 		skb_put(skb, len);
 	}
@@ -3325,28 +3324,22 @@ static void bnxt_free_tx_skbs(struct bnxt *bp)
 
 static void bnxt_free_one_rx_ring(struct bnxt *bp, struct bnxt_rx_ring_info *rxr)
 {
-	struct pci_dev *pdev = bp->pdev;
 	int i, max_idx;
 
 	max_idx = bp->rx_nr_pages * RX_DESC_CNT;
 
 	for (i = 0; i < max_idx; i++) {
 		struct bnxt_sw_rx_bd *rx_buf = &rxr->rx_buf_ring[i];
-		dma_addr_t mapping = rx_buf->mapping;
 		void *data = rx_buf->data;
 
 		if (!data)
 			continue;
 
 		rx_buf->data = NULL;
-		if (BNXT_RX_PAGE_MODE(bp)) {
+		if (BNXT_RX_PAGE_MODE(bp))
 			page_pool_recycle_direct(rxr->page_pool, data);
-		} else {
-			dma_unmap_single_attrs(&pdev->dev, mapping,
-					       bp->rx_buf_use_size, bp->rx_dir,
-					       DMA_ATTR_WEAK_ORDERING);
-			skb_free_frag(data);
-		}
+		else
+			page_pool_free_va(rxr->head_pool, data, true);
 	}
 }
 
@@ -3373,7 +3366,6 @@ static void bnxt_free_one_rx_agg_ring(struct bnxt *bp, struct bnxt_rx_ring_info
 static void bnxt_free_one_rx_ring_skbs(struct bnxt *bp, int ring_nr)
 {
 	struct bnxt_rx_ring_info *rxr = &bp->rx_ring[ring_nr];
-	struct pci_dev *pdev = bp->pdev;
 	struct bnxt_tpa_idx_map *map;
 	int i;
 
@@ -3387,13 +3379,8 @@ static void bnxt_free_one_rx_ring_skbs(struct bnxt *bp, int ring_nr)
 		if (!data)
 			continue;
 
-		dma_unmap_single_attrs(&pdev->dev, tpa_info->mapping,
-				       bp->rx_buf_use_size, bp->rx_dir,
-				       DMA_ATTR_WEAK_ORDERING);
-
 		tpa_info->data = NULL;
-
-		skb_free_frag(data);
+		page_pool_free_va(rxr->head_pool, data, false);
 	}
 
 skip_rx_tpa_free:
@@ -3609,7 +3596,9 @@ static void bnxt_free_rx_rings(struct bnxt *bp)
 			xdp_rxq_info_unreg(&rxr->xdp_rxq);
 
 		page_pool_destroy(rxr->page_pool);
-		rxr->page_pool = NULL;
+		if (rxr->page_pool != rxr->head_pool)
+			page_pool_destroy(rxr->head_pool);
+		rxr->page_pool = rxr->head_pool = NULL;
 
 		kfree(rxr->rx_agg_bmap);
 		rxr->rx_agg_bmap = NULL;
@@ -3627,6 +3616,7 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
 				   int numa_node)
 {
 	struct page_pool_params pp = { 0 };
+	struct page_pool *pool;
 
 	pp.pool_size = bp->rx_agg_ring_size;
 	if (BNXT_RX_PAGE_MODE(bp))
@@ -3639,14 +3629,25 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
 	pp.max_len = PAGE_SIZE;
 	pp.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
 
-	rxr->page_pool = page_pool_create(&pp);
-	if (IS_ERR(rxr->page_pool)) {
-		int err = PTR_ERR(rxr->page_pool);
+	pool = page_pool_create(&pp);
+	if (IS_ERR(pool))
+		return PTR_ERR(pool);
+	rxr->page_pool = pool;
 
-		rxr->page_pool = NULL;
-		return err;
+	if (bnxt_separate_head_pool()) {
+		pp.pool_size = max(bp->rx_ring_size, 1024);
+		pool = page_pool_create(&pp);
+		if (IS_ERR(pool))
+			goto err_destroy_pp;
 	}
+	rxr->head_pool = pool;
+
 	return 0;
+
+err_destroy_pp:
+	page_pool_destroy(rxr->page_pool);
+	rxr->page_pool = NULL;
+	return PTR_ERR(pool);
 }
 
 static int bnxt_alloc_rx_rings(struct bnxt *bp)
@@ -4197,7 +4198,8 @@ static int bnxt_alloc_one_rx_ring(struct bnxt *bp, int ring_nr)
 		u8 *data;
 
 		for (i = 0; i < bp->max_tpa; i++) {
-			data = __bnxt_alloc_rx_frag(bp, &mapping, GFP_KERNEL);
+			data = __bnxt_alloc_rx_frag(bp, &mapping, rxr,
+						    GFP_KERNEL);
 			if (!data)
 				return -ENOMEM;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index bee645f58d0bd..1758edcd1db42 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1108,6 +1108,7 @@ struct bnxt_rx_ring_info {
 	struct bnxt_ring_struct	rx_agg_ring_struct;
 	struct xdp_rxq_info	xdp_rxq;
 	struct page_pool	*page_pool;
+	struct page_pool	*head_pool;
 };
 
 struct bnxt_rx_sw_stats {
-- 
2.39.5



