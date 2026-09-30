Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5065515964;
	Wed, 30 Sep 2026 17:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787741; cv=none; b=KfIK2iYIDGHbAAz/7uky5PzizgjWSE2y8g4800rXx64hjjN55yYHYOy5FMvzAwqbDD5NX20MfMK1kKCNnyvveh3rifbg83DshdoU3hNWH1Rf6eNKmX4P9ypUk3A3kGktwaBdigvQ9f8CykAr1xC6Aj8wJOl3MHu0C/+pIxweKfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787741; c=relaxed/simple;
	bh=v+qW/7A5uQKeADjZAKMitdoSvayZH9ZYxPtEfi7MC0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ufbrZ8h1RjDm5y3rv8S2c0jaYNicLa/XSyp6TRYjgNyOmcfcfFTAUu5fniyjyY4N/xhO4uiAz0Hqkt4qomzYwjOO6eNhUbzsXWGWIbFhoY7uTOzFIJ7w9SgFBZ7e4xomp34WrjUIKQuwKA4zqsid2lcKaAW1VmyOdSpGv2YU6Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXxTCVOO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXxTCVOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6711F000FF;
	Wed, 30 Sep 2026 17:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787740;
	bh=dJxIzLnCH658nv7XEsI/r3ZkFl9S2a+GDC9k3hyL0BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXxTCVOOK+WBzDKGLPKoz46DK4wIh6QZwjZ45WOCb5eSTEvvk/GRU3KQ2dpJSjxbz
	 8pDUn8w9st7PxlaAGilUtUH+JyEs7ss/BIJuV+J9Pg0LpLqCbFmhM7B9g650sAbJk+
	 x1QcuFezGy4u/AqYH8bE2FCtfm7DjP5avvDkP8OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.2 336/457] net: macb: fix dma_alloc_coherent() leak on macb_alloc() error paths
Date: Wed, 30 Sep 2026 17:27:21 +0200
Message-ID: <20260930152353.266561513@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Théo Lebrun <theo.lebrun@bootlin.com>

commit 23d42b9a3bcd55b17d3b371544fedc708c2397e9 upstream.

Fix 3 leaks in macb_alloc() error paths:
- Tx buffer allocated but crossing a 4G boundary: Tx leaked.
- Rx buffer allocation fails: Tx leaked.
- Rx buffer allocated but crossing a 4G boundary: Tx & Rx leaked.

This is because our error handling calls macb_free(bp) which in turn
frees the buffers stored in bp->queues[0], but nothing has been stored
in there. Fix by storing allocated buffers into bp->queues[0] ASAP.

Fixes: 78d901897b3c ("net: macb: single dma_alloc_coherent() for DMA descriptors")
Cc: stable@vger.kernel.org
Signed-off-by: Théo Lebrun <theo.lebrun@bootlin.com>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20260918-macb-alloc-leak-v1-1-aba9a3d4f6e3@bootlin.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2756,14 +2756,24 @@ static int macb_alloc_consistent(struct
 
 	size = bp->num_queues * macb_tx_ring_size_per_queue(bp);
 	tx = dma_alloc_coherent(dev, size, &tx_dma, GFP_KERNEL);
-	if (!tx || upper_32_bits(tx_dma) != upper_32_bits(tx_dma + size - 1))
+	if (!tx)
+		goto out_err;
+	/* Record the buffer so that the error path frees it. */
+	bp->queues[0].tx_ring = tx;
+	bp->queues[0].tx_ring_dma = tx_dma;
+	if (upper_32_bits(tx_dma) != upper_32_bits(tx_dma + size - 1))
 		goto out_err;
 	netdev_dbg(bp->netdev, "Allocated %zu bytes for %u TX rings at %08lx (mapped %p)\n",
 		   size, bp->num_queues, (unsigned long)tx_dma, tx);
 
 	size = bp->num_queues * macb_rx_ring_size_per_queue(bp);
 	rx = dma_alloc_coherent(dev, size, &rx_dma, GFP_KERNEL);
-	if (!rx || upper_32_bits(rx_dma) != upper_32_bits(rx_dma + size - 1))
+	if (!rx)
+		goto out_err;
+	/* Record the buffer so that the error path frees it. */
+	bp->queues[0].rx_ring = rx;
+	bp->queues[0].rx_ring_dma = rx_dma;
+	if (upper_32_bits(rx_dma) != upper_32_bits(rx_dma + size - 1))
 		goto out_err;
 	netdev_dbg(bp->netdev, "Allocated %zu bytes for %u RX rings at %08lx (mapped %p)\n",
 		   size, bp->num_queues, (unsigned long)rx_dma, rx);


