Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A827451B190;
	Wed, 30 Sep 2026 18:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793853; cv=none; b=iW4o9F3W5BI7fbm7cZwri+C1qf+ziKXtH6l7jFFohXOgNcGpTFF9yQXZYljFeJqY7RJH5z06k3RZ/4OM46JP89rqtObCtEjes6uodfeUdBYyv9KUZ27TwVgBKTpYRzsNuWlvih4pY/IJtt6oOIZz0WKDGJcbs6GmO7TIfYNm/E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793853; c=relaxed/simple;
	bh=s9CUGxg6M0kLKFbVBnHEkoPKqMLQec1CAu7LKd3vRQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZVIlN0Y9S+ue0vUz/qBgYUqsOupDHjZZXNuql/WJvRcaJGADOc1RuR8DYIVc5JxHPAkFtC7sjORBXtWIB33IQKk+lsA7RLnRlygo6uDaLWJ/5lJ6/Jje59eXv0LXvUAV0sjsEmpI8pVg/ORMLEyhLqnYD63+9CsW5+R9meIAuf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LUhPZlZA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUhPZlZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8201F000FF;
	Wed, 30 Sep 2026 18:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793852;
	bh=N+d1QOIZbLcSlvITQC7c9U4ASadbuVCbmDlse7347vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LUhPZlZAqf5tK0fePq2VTJ0fbj/1ED+/cCbi4aFKPajrT2GtFb7cU1dAKi+Z9Vrkx
	 1DEdG6VNn2mFdA852QjrpNLbgFA1Hfk2p/gGPA9NAOgR+Dy0sZ4pCBLSW51qcQWDIT
	 5kvICuBddNJCBBIr0I22ujsH/ETk02s6HDlZb5JU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 370/395] net: macb: fix dma_alloc_coherent() leak on macb_alloc() error paths
Date: Wed, 30 Sep 2026 17:30:32 +0200
Message-ID: <20260930152348.720171219@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Théo Lebrun <theo.lebrun@bootlin.com>

[ Upstream commit 23d42b9a3bcd55b17d3b371544fedc708c2397e9 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2663,14 +2663,24 @@ static int macb_alloc_consistent(struct
 
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
 	netdev_dbg(bp->dev, "Allocated %zu bytes for %u TX rings at %08lx (mapped %p)\n",
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
 	netdev_dbg(bp->dev, "Allocated %zu bytes for %u RX rings at %08lx (mapped %p)\n",
 		   size, bp->num_queues, (unsigned long)rx_dma, rx);


