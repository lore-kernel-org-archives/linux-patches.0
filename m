Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2B2451996;
	Thu, 30 Jul 2026 16:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428352; cv=none; b=gTs+h6YIBEKSg26zEeNgKoPskw/PZFmoibmXUT0ON/PBGEqBTN+lR9rwaGFjFhfmAG5BaqO4B8w4IcwfzJt4pjs62GpTaS7Ob1F/FDXRJ6aAYnuX1DN6fQSjr58jDjWvy0t4KnX5ohBli3QRSIQQLrVUQz8kfiw7qznXJto4riE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428352; c=relaxed/simple;
	bh=VNlOd69qyeJvifWKbxZdTruEqqlC2u7SyfZ/ffjhQJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xiq25JDPLATCXlpm9JNpB3pH7Sxem2bwYAmH/fe1LdKW3ogI3fypkpQQrezBPND7hMzhdk203Jv439G7pw8upuyUeUx4gv6WxLS4Sk9bl5/RjhT/QsleLDnk1DRaosZwVR6F1Mug7fcvq0uteU6TdNs22HcjWd1iyWTHfloJAPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sz1e0kUT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sz1e0kUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658F11F000E9;
	Thu, 30 Jul 2026 16:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428350;
	bh=srQRlyqgLPtOQF3AG+zB4xY3wGvHn4Hzwrgto5jbZYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sz1e0kUTIVhqvZ5h5YjQWGPwiFl3zhN5fjLpcB3oTXS7FeK2tIwcUg7XVOuaXtKX9
	 z7jbtAHQoUnAN0bHNvrSYIFGJtDaseJ2DschWx8QrIVF8fMVk59hWg5V3xQQF8LR3f
	 pk0itpI5pT/DisO/OgIGhfgoH1i6a8PEobHwyxUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 472/484] net: macb: drop in-flight Tx SKBs on close
Date: Thu, 30 Jul 2026 16:16:09 +0200
Message-ID: <20260730141433.745204194@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Théo Lebrun <theo.lebrun@bootlin.com>

[ Upstream commit 27f575836cfebbf872dec020428742b10650a955 ]

The MACB driver has since forever leaked the outgoing SKBs that
have not yet been marked as completed. They live in queue->tx_skb
which gets freed without remorse nor checking.

macb_free_consistent() gets called in a few codepaths, but only close will
trigger the added expressions. In macb_open() and macb_alloc_consistent()
failure cases, queues' tx_skb just got allocated and are empty.

Fixes: 89e5785fc8a6 ("[PATCH] Atmel MACB ethernet driver")
Cc: stable@vger.kernel.org
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Théo Lebrun <theo.lebrun@bootlin.com>
Link: https://patch.msgid.link/20260702-macb-drop-tx-v4-1-1c833eebdbc8@bootlin.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ adjusted context to free each queue's Tx/Rx rings individually since 6.12 lacks the single-dma_alloc_coherent refactor ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2582,8 +2582,26 @@ static void macb_free_consistent(struct
 	bp->macbgem_ops.mog_free_rx_buffers(bp);
 
 	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
-		kfree(queue->tx_skb);
-		queue->tx_skb = NULL;
+		if (queue->tx_skb) {
+			unsigned int dropped = 0, tail;
+
+			for (tail = queue->tx_tail; tail != queue->tx_head;
+			     tail++) {
+				if (macb_tx_skb(queue, tail)->skb)
+					dropped++;
+				macb_tx_unmap(bp, macb_tx_skb(queue, tail), 0);
+			}
+
+			queue->stats.tx_dropped += dropped;
+			bp->dev->stats.tx_dropped += dropped;
+
+			kfree(queue->tx_skb);
+			queue->tx_skb = NULL;
+		}
+
+		queue->tx_head = 0;
+		queue->tx_tail = 0;
+
 		if (queue->tx_ring) {
 			size = TX_RING_BYTES(bp) + bp->tx_bd_rd_prefetch;
 			dma_free_coherent(&bp->pdev->dev, size,


