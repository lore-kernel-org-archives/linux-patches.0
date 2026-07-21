Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9415646A5F6;
	Tue, 21 Jul 2026 17:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655167; cv=none; b=LrG0MnDOFqNNYb6+XUGO2BZvVhLbnYGD1UYfXhbjf+EorhznI0LWM1qFfpeklQyRsizKBHtZryrv8MXHPPlfkSTjqbTE4mVqX0dparfzJPX27GL77h4yiQjAIS0Tc9kUNbVWePepL5rgKdC3qWxRn8SKHbTBOH1JBN99N359wvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655167; c=relaxed/simple;
	bh=owAl4iMkCDMENmLZNQSwQaWZezjtZdVpoVTbS/U5eFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pnI5Ro1i8UezACPBdn+eq1x/eqYywqc31+2Exxn+3MxWPNhxz7CPiU781vKah36jmkZw7k88FS0ZmWjjYcl5z8ndJwLfgcBxlPcglliWhI65H4c2PDJ9kd2CLtWkEc8HGsFNp7H6rtpbh+bYWy1FwSqt1N18zsxLgqJWnAZhVTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTiBAKpZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTiBAKpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070B11F000E9;
	Tue, 21 Jul 2026 17:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655166;
	bh=zsVLC+CfBwApsbedRCfWRu8sQyv3HHQpffGgKwTqiig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aTiBAKpZ7F4a+2Zsfyd0DmSlCnQhq9mw7f/07tTQWVUQTMCxlHMltff2IbmL8PvNm
	 oaluxNnXCRRhx5UHZI7rvTlPVyOwHYn4CYPd0x5W5wgBDl9y20K1xFzNheDmckHV32
	 giBq7b50IHef7b2liZnfA7GTaSwLuQB0O+5xFX3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.1 1979/2077] net: macb: drop in-flight Tx SKBs on close
Date: Tue, 21 Jul 2026 17:27:32 +0200
Message-ID: <20260721152639.385719753@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Théo Lebrun <theo.lebrun@bootlin.com>

commit 27f575836cfebbf872dec020428742b10650a955 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2668,8 +2668,25 @@ static void macb_free_consistent(struct
 	dma_free_coherent(dev, size, bp->queues[0].rx_ring, bp->queues[0].rx_ring_dma);
 
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
 		queue->tx_ring = NULL;
 		queue->rx_ring = NULL;
 	}


