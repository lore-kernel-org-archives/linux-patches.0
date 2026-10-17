Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDFC39F18A;
	Sat, 17 Oct 2026 17:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259331; cv=none; b=WNoBMkDk8JWdO5yojlFY9CVyN4fv7P6IJV/Dc3oMW8MTknYkkDrUm3jwwapLqvWk4iPQ766qblQmTp6mdC+oAr8ULbQAFvhgegFLShBiX4WSfjXbh+kMnkDmfXKB9vbhjpfy9MOxtUalg2DOszpzz98+BREDp+9q1W7yCNDAYg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259331; c=relaxed/simple;
	bh=hsgcioNtNHbkuMBnvlehhyf6fgnf7HPEq+sRzbptTx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQJdUr5P4zzajclhWSpjD4kD8BxPO4KRL9K4kDzX+s4nB2LD2T4AIWmvv9vpxqSmhXolzDdRXxpNV7jF0vZicfEj98wnrTRuclua+U1H7A3PCVM+/L/59FdnquMVaJydrlTI8KEVBHr2t5m8T85w2N+9X7zhsl/zk7IZ4Q2kStA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMfq8n0v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMfq8n0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA611F000C4;
	Sat, 17 Oct 2026 17:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259330;
	bh=6MOY9h6jmP69hMiBNILkG+BfrNW2fsfqioethO/X2kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aMfq8n0vxWorzr9cBmIhPlIniil86H6wYQ4s37WZQPCkYSDfULv37G4F1R860Koob
	 tnLc37XIhsWBP4St9hu0ipfPd/r4pr4B5Mc9hobwX2JbCIg54YCmFpUQxH8H25Ki0Z
	 I7u0Pb6mQv3I85C+1v9bumbC4dtvzSf/SCp/slC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunsheng Lin <linyunsheng@huawei.com>,
	Jason Wang <jasowang@redhat.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1177/1674] net: introduce page_frag_cache_drain()
Date: Sat, 17 Oct 2026 17:57:29 +0200
Message-ID: <20261017160501.363149350@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit a0727489ac22d6fbd2e390d38a51193bba61da83 ]

When draining a page_frag_cache, most user are doing
the similar steps, so introduce an API to avoid code
duplication.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 4dae39395609 ("nvmet-tcp: fix page fragment cache leak in error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_main.c | 11 ++---------
 drivers/net/ethernet/mediatek/mtk_wed_wo.c | 17 ++---------------
 drivers/nvme/host/tcp.c                    |  7 +------
 drivers/nvme/target/tcp.c                  |  4 +---
 include/linux/gfp.h                        |  1 +
 mm/page_alloc.c                            | 10 ++++++++++
 6 files changed, 17 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 9a287a3764798..5f966f0a049d1 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1272,17 +1272,10 @@ static void gve_unreg_xdp_info(struct gve_priv *priv)
 
 static void gve_drain_page_cache(struct gve_priv *priv)
 {
-	struct page_frag_cache *nc;
 	int i;
 
-	for (i = 0; i < priv->rx_cfg.num_queues; i++) {
-		nc = &priv->rx[i].page_cache;
-		if (nc->va) {
-			__page_frag_cache_drain(virt_to_page(nc->va),
-						nc->pagecnt_bias);
-			nc->va = NULL;
-		}
-	}
+	for (i = 0; i < priv->rx_cfg.num_queues; i++)
+		page_frag_cache_drain(&priv->rx[i].page_cache);
 }
 
 static int gve_open(struct net_device *dev)
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_wo.c b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
index ae44ad5f8ce8a..d3844ec7f9999 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_wo.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
@@ -285,7 +285,6 @@ mtk_wed_wo_queue_free(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q)
 static void
 mtk_wed_wo_queue_tx_clean(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q)
 {
-	struct page *page;
 	int i;
 
 	for (i = 0; i < q->n_desc; i++) {
@@ -300,19 +299,12 @@ mtk_wed_wo_queue_tx_clean(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q)
 		entry->buf = NULL;
 	}
 
-	if (!q->cache.va)
-		return;
-
-	page = virt_to_page(q->cache.va);
-	__page_frag_cache_drain(page, q->cache.pagecnt_bias);
-	memset(&q->cache, 0, sizeof(q->cache));
+	page_frag_cache_drain(&q->cache);
 }
 
 static void
 mtk_wed_wo_queue_rx_clean(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q)
 {
-	struct page *page;
-
 	for (;;) {
 		void *buf = mtk_wed_wo_dequeue(wo, q, NULL, true);
 
@@ -322,12 +314,7 @@ mtk_wed_wo_queue_rx_clean(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q)
 		skb_free_frag(buf);
 	}
 
-	if (!q->cache.va)
-		return;
-
-	page = virt_to_page(q->cache.va);
-	__page_frag_cache_drain(page, q->cache.pagecnt_bias);
-	memset(&q->cache, 0, sizeof(q->cache));
+	page_frag_cache_drain(&q->cache);
 }
 
 static void
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index cd8fb901cabcd..abfa680bdd216 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1449,7 +1449,6 @@ static int nvme_tcp_alloc_async_req(struct nvme_tcp_ctrl *ctrl)
 
 static void nvme_tcp_free_queue(struct nvme_ctrl *nctrl, int qid)
 {
-	struct page *page;
 	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(nctrl);
 	struct nvme_tcp_queue *queue = &ctrl->queues[qid];
 	unsigned int noreclaim_flag;
@@ -1460,11 +1459,7 @@ static void nvme_tcp_free_queue(struct nvme_ctrl *nctrl, int qid)
 	if (queue->hdr_digest || queue->data_digest)
 		nvme_tcp_free_crypto(queue);
 
-	if (queue->pf_cache.va) {
-		page = virt_to_head_page(queue->pf_cache.va);
-		__page_frag_cache_drain(page, queue->pf_cache.pagecnt_bias);
-		queue->pf_cache.va = NULL;
-	}
+	page_frag_cache_drain(&queue->pf_cache);
 
 	noreclaim_flag = memalloc_noreclaim_save();
 	sock_release(queue->sock);
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index c6610b7fc9560..e2d1f2e6012a7 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1585,7 +1585,6 @@ static void nvmet_tcp_free_cmd_data_in_buffers(struct nvmet_tcp_queue *queue)
 
 static void nvmet_tcp_release_queue_work(struct work_struct *w)
 {
-	struct page *page;
 	struct nvmet_tcp_queue *queue =
 		container_of(w, struct nvmet_tcp_queue, release_work);
 
@@ -1608,8 +1607,7 @@ static void nvmet_tcp_release_queue_work(struct work_struct *w)
 	if (queue->hdr_digest || queue->data_digest)
 		nvmet_tcp_free_crypto(queue);
 	ida_free(&nvmet_tcp_queue_ida, queue->idx);
-	page = virt_to_head_page(queue->pf_cache.va);
-	__page_frag_cache_drain(page, queue->pf_cache.pagecnt_bias);
+	page_frag_cache_drain(&queue->pf_cache);
 	kfree(queue);
 }
 
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index a0803ed4b469a..9794c6f5fcbfd 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -303,6 +303,7 @@ extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
 
 struct page_frag_cache;
+void page_frag_cache_drain(struct page_frag_cache *nc);
 extern void __page_frag_cache_drain(struct page *page, unsigned int count);
 extern void *page_frag_alloc_align(struct page_frag_cache *nc,
 				   unsigned int fragsz, gfp_t gfp_mask,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ffdc71103c2ad..06c493b908ed4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4633,6 +4633,16 @@ static struct page *__page_frag_cache_refill(struct page_frag_cache *nc,
 	return page;
 }
 
+void page_frag_cache_drain(struct page_frag_cache *nc)
+{
+	if (!nc->va)
+		return;
+
+	__page_frag_cache_drain(virt_to_head_page(nc->va), nc->pagecnt_bias);
+	nc->va = NULL;
+}
+EXPORT_SYMBOL(page_frag_cache_drain);
+
 void __page_frag_cache_drain(struct page *page, unsigned int count)
 {
 	VM_BUG_ON_PAGE(page_ref_count(page) == 0, page);
-- 
2.53.0



