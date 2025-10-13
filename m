Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BDE1EDA2B;
	Mon, 13 Oct 2025 15:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370125; cv=none; b=pSGeW86dkHz0NnZeQ8TlGxz7mBeAr+JZqg8Q6+31vKEPNnKvaLZ6nOi1hmmfnKtcn8aXGtitvECVQH0ebp6ew4oCP5NVXb2GeU38Ts5nWkq7ZQxpo8jLqS+ZHCMKw5KC616TIa/LkcwruyjCEJ4C1ZWxZvZMEhGFqoF8M0jLkSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370125; c=relaxed/simple;
	bh=gqdknuzirRb4FbQZox49sBE+cRicufSw1uFhmuev3tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HhLJ6g0lwRRAXwT6F7qgMu9hvV4XGp8n3l7HJGaQUgHbnXCFjo7mkqsqAKmLll6G1w0t2QyB4DmULw0/POIx2hfSjM/8GNQPMMJVL1HLtT4bU9VJMUGa+0T2grS2SAq4dXS+/DJyOKgbnT42cxg9i4Kr14HMVt9HNLqiiI7Aktg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BlYxGZt4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BlYxGZt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C4FC116C6;
	Mon, 13 Oct 2025 15:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370125;
	bh=gqdknuzirRb4FbQZox49sBE+cRicufSw1uFhmuev3tY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BlYxGZt4S7iO7O+lenTGQ6laHASHMiVhHGEgUKIoPVvPMiDaULzc6H3PRB2oFPsPb
	 SaWxmftGqRM6DSknwgcrEjJuOqEDqmeRWvoTwdrBiLT8wTOWXuADGmMRV4c98AH904
	 NePpm0bLsG5QzlxKQd8FYkvwrAGspS/wQ4fPh/OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 454/563] net: macb: move ring size computation to functions
Date: Mon, 13 Oct 2025 16:45:15 +0200
Message-ID: <20251013144427.727306646@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Théo Lebrun <theo.lebrun@bootlin.com>

[ Upstream commit 92d4256fafd8d0a14d3aaa10452ac771bf9b597c ]

The tx/rx ring size calculation is somewhat complex and partially hidden
behind a macro. Move that out of the {RX,TX}_RING_BYTES() macros and
macb_{alloc,free}_consistent() functions into neat separate functions.

In macb_free_consistent(), we drop the size variable and directly call
the size helpers in the arguments list. In macb_alloc_consistent(), we
keep the size variable that is used by netdev_dbg() calls.

Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Théo Lebrun <theo.lebrun@bootlin.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250923-macb-fixes-v6-3-772d655cdeb6@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 78d901897b3c ("net: macb: single dma_alloc_coherent() for DMA descriptors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 27 ++++++++++++++----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 3e634049dadf1..73840808ea801 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -51,14 +51,10 @@ struct sifive_fu540_macb_mgmt {
 #define DEFAULT_RX_RING_SIZE	512 /* must be power of 2 */
 #define MIN_RX_RING_SIZE	64
 #define MAX_RX_RING_SIZE	8192
-#define RX_RING_BYTES(bp)	(macb_dma_desc_get_size(bp)	\
-				 * (bp)->rx_ring_size)
 
 #define DEFAULT_TX_RING_SIZE	512 /* must be power of 2 */
 #define MIN_TX_RING_SIZE	64
 #define MAX_TX_RING_SIZE	4096
-#define TX_RING_BYTES(bp)	(macb_dma_desc_get_size(bp)	\
-				 * (bp)->tx_ring_size)
 
 /* level of occupied TX descriptors under which we wake up TX process */
 #define MACB_TX_WAKEUP_THRESH(bp)	(3 * (bp)->tx_ring_size / 4)
@@ -2470,11 +2466,20 @@ static void macb_free_rx_buffers(struct macb *bp)
 	}
 }
 
+static unsigned int macb_tx_ring_size_per_queue(struct macb *bp)
+{
+	return macb_dma_desc_get_size(bp) * bp->tx_ring_size + bp->tx_bd_rd_prefetch;
+}
+
+static unsigned int macb_rx_ring_size_per_queue(struct macb *bp)
+{
+	return macb_dma_desc_get_size(bp) * bp->rx_ring_size + bp->rx_bd_rd_prefetch;
+}
+
 static void macb_free_consistent(struct macb *bp)
 {
 	struct macb_queue *queue;
 	unsigned int q;
-	int size;
 
 	if (bp->rx_ring_tieoff) {
 		dma_free_coherent(&bp->pdev->dev, macb_dma_desc_get_size(bp),
@@ -2488,14 +2493,14 @@ static void macb_free_consistent(struct macb *bp)
 		kfree(queue->tx_skb);
 		queue->tx_skb = NULL;
 		if (queue->tx_ring) {
-			size = TX_RING_BYTES(bp) + bp->tx_bd_rd_prefetch;
-			dma_free_coherent(&bp->pdev->dev, size,
+			dma_free_coherent(&bp->pdev->dev,
+					  macb_tx_ring_size_per_queue(bp),
 					  queue->tx_ring, queue->tx_ring_dma);
 			queue->tx_ring = NULL;
 		}
 		if (queue->rx_ring) {
-			size = RX_RING_BYTES(bp) + bp->rx_bd_rd_prefetch;
-			dma_free_coherent(&bp->pdev->dev, size,
+			dma_free_coherent(&bp->pdev->dev,
+					  macb_rx_ring_size_per_queue(bp),
 					  queue->rx_ring, queue->rx_ring_dma);
 			queue->rx_ring = NULL;
 		}
@@ -2546,7 +2551,7 @@ static int macb_alloc_consistent(struct macb *bp)
 	int size;
 
 	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
-		size = TX_RING_BYTES(bp) + bp->tx_bd_rd_prefetch;
+		size = macb_tx_ring_size_per_queue(bp);
 		queue->tx_ring = dma_alloc_coherent(&bp->pdev->dev, size,
 						    &queue->tx_ring_dma,
 						    GFP_KERNEL);
@@ -2564,7 +2569,7 @@ static int macb_alloc_consistent(struct macb *bp)
 		if (!queue->tx_skb)
 			goto out_err;
 
-		size = RX_RING_BYTES(bp) + bp->rx_bd_rd_prefetch;
+		size = macb_rx_ring_size_per_queue(bp);
 		queue->rx_ring = dma_alloc_coherent(&bp->pdev->dev, size,
 						    &queue->rx_ring_dma,
 						    GFP_KERNEL);
-- 
2.51.0



