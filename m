Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9362B27FB3D;
	Tue, 27 May 2025 17:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368558; cv=none; b=QzBSVlimX7naODzWrwByGc9h4i9zEUc+OH5SEnTMWgg7O4eLz6WjoFe0e4rsbod6TKcxhv0a6Xd/fFXj2n3q6NXcdA4M31vs++2eBsGVVJSj8b6x9uq26mXUZG6nimBHKwFIl5h/cTNyyMmeG3tnZeGEVOIgbcO7R2Rgqa0+R5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368558; c=relaxed/simple;
	bh=5WINQAUARGIOjj3J5kzaYHo+gE7NXUhBe1eUjew1oS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRyTReTC7K/yQJxoH4mkNu2heNL1ryonkTEHM7GBK9UcRU7bPE6o8zmKpRV/grR0n6xkAjdc2L58SFIrBulLPipsgoOeebmKT/QDLRpHL4VyCxLFRtWKv4u6m6DW0VR3xoBEB0hujHX+6PTUGCqbxZ5YRHp+aTOJhpbGrdcYWpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2ueKbQK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2ueKbQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F422C4CEE9;
	Tue, 27 May 2025 17:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368558;
	bh=5WINQAUARGIOjj3J5kzaYHo+gE7NXUhBe1eUjew1oS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2ueKbQK7ymFfAKo9gAhJURZRewqP+VmDpWf4UdJnsg2FzTP8b7rjGKKsKhLq+U/l
	 DEgKrcaOLd2zgapKkNYc12B+6zLoHflXYTSnPURJAWhBRsMJ8Mq9sq93HEeIsUj7Yd
	 2ew5xOK5JQiXcOMcK4aptQG0hA+rOVxm1Apn8X1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Suman Ghosh <sumang@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 714/783] octeontx2-pf: use xdp_return_frame() to free xdp buffers
Date: Tue, 27 May 2025 18:28:31 +0200
Message-ID: <20250527162542.191913924@linuxfoundation.org>
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

From: Suman Ghosh <sumang@marvell.com>

[ Upstream commit 94c80f748873514af27b9fac3f72acafcde3bcd6 ]

xdp_return_frames() will help to free the xdp frames and their
associated pages back to page pool.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Suman Ghosh <sumang@marvell.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 184fb40f731b ("octeontx2-pf: Avoid adding dcbnl_ops for LBK and SDP vf")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeontx2/nic/otx2_common.h       |  4 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  7 ++-
 .../marvell/octeontx2/nic/otx2_txrx.c         | 53 +++++++++++--------
 .../marvell/octeontx2/nic/otx2_txrx.h         |  1 +
 4 files changed, 38 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 7cc12f10e8a15..0bec3a6af26a0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -21,6 +21,7 @@
 #include <linux/time64.h>
 #include <linux/dim.h>
 #include <uapi/linux/if_macsec.h>
+#include <net/page_pool/helpers.h>
 
 #include <mbox.h>
 #include <npc.h>
@@ -1095,7 +1096,8 @@ int otx2_del_macfilter(struct net_device *netdev, const u8 *mac);
 int otx2_add_macfilter(struct net_device *netdev, const u8 *mac);
 int otx2_enable_rxvlan(struct otx2_nic *pf, bool enable);
 int otx2_install_rxvlan_offload_flow(struct otx2_nic *pfvf);
-bool otx2_xdp_sq_append_pkt(struct otx2_nic *pfvf, u64 iova, int len, u16 qidx);
+bool otx2_xdp_sq_append_pkt(struct otx2_nic *pfvf, struct xdp_frame *xdpf,
+			    u64 iova, int len, u16 qidx, u16 flags);
 u16 otx2_get_max_mtu(struct otx2_nic *pfvf);
 int otx2_handle_ntuple_tc_features(struct net_device *netdev,
 				   netdev_features_t features);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index e1dde93e8af82..4347a3c95350f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2691,7 +2691,6 @@ static int otx2_get_vf_config(struct net_device *netdev, int vf,
 static int otx2_xdp_xmit_tx(struct otx2_nic *pf, struct xdp_frame *xdpf,
 			    int qidx)
 {
-	struct page *page;
 	u64 dma_addr;
 	int err = 0;
 
@@ -2701,11 +2700,11 @@ static int otx2_xdp_xmit_tx(struct otx2_nic *pf, struct xdp_frame *xdpf,
 	if (dma_mapping_error(pf->dev, dma_addr))
 		return -ENOMEM;
 
-	err = otx2_xdp_sq_append_pkt(pf, dma_addr, xdpf->len, qidx);
+	err = otx2_xdp_sq_append_pkt(pf, xdpf, dma_addr, xdpf->len,
+				     qidx, XDP_REDIRECT);
 	if (!err) {
 		otx2_dma_unmap_page(pf, dma_addr, xdpf->len, DMA_TO_DEVICE);
-		page = virt_to_page(xdpf->data);
-		put_page(page);
+		xdp_return_frame(xdpf);
 		return -ENOMEM;
 	}
 	return 0;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 224cef9389274..4a72750431036 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -96,20 +96,16 @@ static unsigned int frag_num(unsigned int i)
 
 static void otx2_xdp_snd_pkt_handler(struct otx2_nic *pfvf,
 				     struct otx2_snd_queue *sq,
-				 struct nix_cqe_tx_s *cqe)
+				     struct nix_cqe_tx_s *cqe)
 {
 	struct nix_send_comp_s *snd_comp = &cqe->comp;
 	struct sg_list *sg;
-	struct page *page;
-	u64 pa;
 
 	sg = &sq->sg[snd_comp->sqe_id];
-
-	pa = otx2_iova_to_phys(pfvf->iommu_domain, sg->dma_addr[0]);
-	otx2_dma_unmap_page(pfvf, sg->dma_addr[0],
-			    sg->size[0], DMA_TO_DEVICE);
-	page = virt_to_page(phys_to_virt(pa));
-	put_page(page);
+	if (sg->flags & XDP_REDIRECT)
+		otx2_dma_unmap_page(pfvf, sg->dma_addr[0], sg->size[0], DMA_TO_DEVICE);
+	xdp_return_frame((struct xdp_frame *)sg->skb);
+	sg->skb = (u64)NULL;
 }
 
 static void otx2_snd_pkt_handler(struct otx2_nic *pfvf,
@@ -1359,8 +1355,9 @@ void otx2_free_pending_sqe(struct otx2_nic *pfvf)
 	}
 }
 
-static void otx2_xdp_sqe_add_sg(struct otx2_snd_queue *sq, u64 dma_addr,
-				int len, int *offset)
+static void otx2_xdp_sqe_add_sg(struct otx2_snd_queue *sq,
+				struct xdp_frame *xdpf,
+				u64 dma_addr, int len, int *offset, u16 flags)
 {
 	struct nix_sqe_sg_s *sg = NULL;
 	u64 *iova = NULL;
@@ -1377,9 +1374,12 @@ static void otx2_xdp_sqe_add_sg(struct otx2_snd_queue *sq, u64 dma_addr,
 	sq->sg[sq->head].dma_addr[0] = dma_addr;
 	sq->sg[sq->head].size[0] = len;
 	sq->sg[sq->head].num_segs = 1;
+	sq->sg[sq->head].flags = flags;
+	sq->sg[sq->head].skb = (u64)xdpf;
 }
 
-bool otx2_xdp_sq_append_pkt(struct otx2_nic *pfvf, u64 iova, int len, u16 qidx)
+bool otx2_xdp_sq_append_pkt(struct otx2_nic *pfvf, struct xdp_frame *xdpf,
+			    u64 iova, int len, u16 qidx, u16 flags)
 {
 	struct nix_sqe_hdr_s *sqe_hdr;
 	struct otx2_snd_queue *sq;
@@ -1405,7 +1405,7 @@ bool otx2_xdp_sq_append_pkt(struct otx2_nic *pfvf, u64 iova, int len, u16 qidx)
 
 	offset = sizeof(*sqe_hdr);
 
-	otx2_xdp_sqe_add_sg(sq, iova, len, &offset);
+	otx2_xdp_sqe_add_sg(sq, xdpf, iova, len, &offset, flags);
 	sqe_hdr->sizem1 = (offset / 16) - 1;
 	pfvf->hw_ops->sqe_flush(pfvf, sq, offset, qidx);
 
@@ -1419,6 +1419,8 @@ static bool otx2_xdp_rcv_pkt_handler(struct otx2_nic *pfvf,
 				     bool *need_xdp_flush)
 {
 	unsigned char *hard_start;
+	struct otx2_pool *pool;
+	struct xdp_frame *xdpf;
 	int qidx = cq->cq_idx;
 	struct xdp_buff xdp;
 	struct page *page;
@@ -1426,6 +1428,7 @@ static bool otx2_xdp_rcv_pkt_handler(struct otx2_nic *pfvf,
 	u32 act;
 	int err;
 
+	pool = &pfvf->qset.pool[qidx];
 	iova = cqe->sg.seg_addr - OTX2_HEAD_ROOM;
 	pa = otx2_iova_to_phys(pfvf->iommu_domain, iova);
 	page = virt_to_page(phys_to_virt(pa));
@@ -1444,19 +1447,21 @@ static bool otx2_xdp_rcv_pkt_handler(struct otx2_nic *pfvf,
 	case XDP_TX:
 		qidx += pfvf->hw.tx_queues;
 		cq->pool_ptrs++;
-		return otx2_xdp_sq_append_pkt(pfvf, iova,
-					      cqe->sg.seg_size, qidx);
+		xdpf = xdp_convert_buff_to_frame(&xdp);
+		return otx2_xdp_sq_append_pkt(pfvf, xdpf, cqe->sg.seg_addr,
+					      cqe->sg.seg_size, qidx, XDP_TX);
 	case XDP_REDIRECT:
 		cq->pool_ptrs++;
 		err = xdp_do_redirect(pfvf->netdev, &xdp, prog);
-
-		otx2_dma_unmap_page(pfvf, iova, pfvf->rbsize,
-				    DMA_FROM_DEVICE);
 		if (!err) {
 			*need_xdp_flush = true;
 			return true;
 		}
-		put_page(page);
+
+		otx2_dma_unmap_page(pfvf, iova, pfvf->rbsize,
+				    DMA_FROM_DEVICE);
+		xdpf = xdp_convert_buff_to_frame(&xdp);
+		xdp_return_frame(xdpf);
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(pfvf->netdev, prog, act);
@@ -1465,10 +1470,14 @@ static bool otx2_xdp_rcv_pkt_handler(struct otx2_nic *pfvf,
 		trace_xdp_exception(pfvf->netdev, prog, act);
 		break;
 	case XDP_DROP:
-		otx2_dma_unmap_page(pfvf, iova, pfvf->rbsize,
-				    DMA_FROM_DEVICE);
-		put_page(page);
 		cq->pool_ptrs++;
+		if (page->pp) {
+			page_pool_recycle_direct(pool->page_pool, page);
+		} else {
+			otx2_dma_unmap_page(pfvf, iova, pfvf->rbsize,
+					    DMA_FROM_DEVICE);
+			put_page(page);
+		}
 		return true;
 	}
 	return false;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index d23810963fdbd..92e1e84cad75c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -76,6 +76,7 @@ struct otx2_rcv_queue {
 
 struct sg_list {
 	u16	num_segs;
+	u16	flags;
 	u64	skb;
 	u64	size[OTX2_MAX_FRAGS_IN_SQE];
 	u64	dma_addr[OTX2_MAX_FRAGS_IN_SQE];
-- 
2.39.5



