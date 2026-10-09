Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE384E5332;
	Fri,  9 Oct 2026 14:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555641; cv=none; b=Zx0UkY9Atve4biWZvnGT81laN+/RiUZEVWJE3MO5sJBz8/Dvblw8c2+uASRmGZUKyulU4JDNV9CjrY5r8HYbYEUh3f8qn18BC456DmO2NGEvUPyeSsOalF7ghLrTsAE+8hcGPAdynGPDHjab/FO16EWq4p7aUWoenaEaB0/Y7YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555641; c=relaxed/simple;
	bh=LdPuvpb7r0R1pSQ4BfEfsZSXyuEC5JAV6qBqrG4Cknc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qk+kmtq8URaQuufYBq1sKBGZAW5nXXJEXmANQBUOwxgskZWpOdgPRlAiqZYcBYKaQDpKTWk+tNVTyvKL7l5abtJwefjPPMhhsoJUGA1Dpclx5kejiITIYDBMhBZ+9pMRpcp8P+5YUQn8blxp1XJUoFQPQCUgejn01eVGWJMn+Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQYZfBgL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQYZfBgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDA91F000FF;
	Fri,  9 Oct 2026 14:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555634;
	bh=zW0V8kINA8POboZYT6Lup+LnNkCOnd3uMm65kh7/GDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LQYZfBgL8MZcMrG7gceQsBNaHO1elWVXl617GPPWxdxnp3pe6QauRRh2ZWs2GOYOS
	 MtkRbBumX9oBzoEi5Ol3aIe0myM+qmTqzypwWqDfG7x2qhhH4y2pcfoiNd0xqBq0eS
	 OZm1b8HO3mlX3D1f/uJecrvtZZuw3qHTTSb8Rvew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 091/403] net: bcmgenet: allocate RX buffers as page fragments
Date: Fri,  9 Oct 2026 16:07:32 +0200
Message-ID: <20261009140954.218357238@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 0e7fe2b0ca45343b53345edc174898b448ccdaa4 ]

Since the page_pool conversion every RX buffer is a whole page and the
skb truesize is the page, although the hardware writes at most 2 KiB of
it. On 64 KiB pages a packet therefore counts 65792 bytes against the
socket buffer where it used to count 2752. As a result a UDP socket
with the default buffer starts to drop after three packets, and the RX
rings pin 16 MiB for 512 KiB of buffers.

Fix this and allocate the buffers as page fragments, so the truesize is
what a packet occupies. 4 KiB pages stay one buffer per page.

Sync each buffer in the refill path, as page_pool can only sync a whole
page on recycle. On 4 KiB pages that is twice what the hardware wrote.

Fixes: 7bc054c2d4ed ("net: bcmgenet: convert RX path to page_pool")
Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
Closes: https://lore.kernel.org/all/20260924065839.56793-1-kmehltretter@gmail.com/
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260924101922.2675127-1-nb@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 29 ++++++++++++++-----
 .../net/ethernet/broadcom/genet/bcmgenet.h    |  2 ++
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index a72e136fd9c38..151403442e4ea 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -58,6 +58,9 @@
  */
 #define GENET_RSB_PAD		(sizeof(struct status_64) + 2)
 
+/* RX buffer plus the skb_shared_info napi_build_skb() places behind it */
+#define GENET_RX_BUF_SIZE	SKB_HEAD_ALIGN(RX_BUF_LENGTH)
+
 /* Tx/Rx DMA register offset, skip 256 descriptors */
 #define WORDS_PER_BD(p)		(p->hw_params->words_per_bd)
 #define DMA_DESC_SIZE		(WORDS_PER_BD(priv) * sizeof(u32))
@@ -2250,11 +2253,12 @@ static int bcmgenet_rx_refill(struct bcmgenet_rx_ring *ring,
 			      struct enet_cb *cb)
 {
 	struct bcmgenet_priv *priv = ring->priv;
+	unsigned int size = GENET_RX_BUF_SIZE;
+	unsigned int offset;
 	dma_addr_t mapping;
 	struct page *page;
 
-	page = page_pool_alloc_pages(ring->page_pool,
-				     GFP_ATOMIC);
+	page = page_pool_dev_alloc(ring->page_pool, &offset, &size);
 	if (!page) {
 		priv->mib.alloc_rx_buff_failed++;
 		netif_err(priv, rx_err, priv->dev,
@@ -2263,9 +2267,13 @@ static int bcmgenet_rx_refill(struct bcmgenet_rx_ring *ring,
 	}
 
 	/* page_pool handles DMA mapping via PP_FLAG_DMA_MAP */
-	mapping = page_pool_get_dma_addr(page);
+	mapping = page_pool_get_dma_addr(page) + offset;
+	dma_sync_single_for_device(&priv->pdev->dev, mapping, RX_BUF_LENGTH,
+				   DMA_FROM_DEVICE);
 
 	cb->rx_page = page;
+	cb->rx_offset = offset;
+	cb->rx_size = size;
 	dmadesc_set_addr(priv, cb->bd_addr, mapping);
 
 	return 0;
@@ -2319,6 +2327,7 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
 
 	while ((rxpktprocessed < rxpkttoprocess) &&
 	       (rxpktprocessed < budget)) {
+		unsigned int rx_offset, rx_size;
 		struct status_64 *status;
 		struct page *rx_page;
 		void *hard_start;
@@ -2328,6 +2337,8 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
 
 		/* Save the received page before refilling */
 		rx_page = cb->rx_page;
+		rx_offset = cb->rx_offset;
+		rx_size = cb->rx_size;
 
 		if (bcmgenet_rx_refill(ring, cb)) {
 			BCMGENET_STATS64_INC(stats, dropped);
@@ -2337,10 +2348,10 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
 		/* Sync the full buffer; the HW may have written anywhere
 		 * up to RX_BUF_LENGTH.
 		 */
-		page_pool_dma_sync_for_cpu(ring->page_pool, rx_page, 0,
+		page_pool_dma_sync_for_cpu(ring->page_pool, rx_page, rx_offset,
 					   RX_BUF_LENGTH);
 
-		hard_start = page_address(rx_page);
+		hard_start = page_address(rx_page) + rx_offset;
 		status = (struct status_64 *)hard_start;
 		dma_length_status = status->length_status;
 
@@ -2406,7 +2417,7 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
 		/* Build SKB from the page - data starts at hard_start,
 		 * frame begins after RSB(64) + pad(2) = 66 bytes.
 		 */
-		skb = napi_build_skb(hard_start, PAGE_SIZE);
+		skb = napi_build_skb(hard_start, rx_size);
 		if (unlikely(!skb)) {
 			BCMGENET_STATS64_INC(stats, dropped);
 			page_pool_put_full_page(ring->page_pool, rx_page,
@@ -2758,14 +2769,16 @@ static void bcmgenet_init_tx_ring(struct bcmgenet_priv *priv,
 static int bcmgenet_rx_ring_create_pool(struct bcmgenet_priv *priv,
 					struct bcmgenet_rx_ring *ring)
 {
+	/* Buffers share a page. bcmgenet_rx_refill() syncs each one for the
+	 * device, PP_FLAG_DMA_SYNC_DEV would sync the whole page.
+	 */
 	struct page_pool_params pp_params = {
 		.order = 0,
-		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
+		.flags = PP_FLAG_DMA_MAP,
 		.pool_size = ring->size,
 		.nid = NUMA_NO_NODE,
 		.dev = &priv->pdev->dev,
 		.dma_dir = DMA_FROM_DEVICE,
-		.max_len = RX_BUF_LENGTH,
 	};
 	int err;
 
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index 22a958ba99024..86f2aed20dbe8 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -470,6 +470,8 @@ struct bcmgenet_rx_stats64 {
 struct enet_cb {
 	struct sk_buff      *skb;
 	struct page         *rx_page;
+	unsigned int        rx_offset;
+	unsigned int        rx_size;
 	void __iomem *bd_addr;
 	DEFINE_DMA_UNMAP_ADDR(dma_addr);
 	DEFINE_DMA_UNMAP_LEN(dma_len);
-- 
2.53.0



