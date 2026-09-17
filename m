Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83D552842B;
	Thu, 17 Sep 2026 17:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665939; cv=none; b=OFvXm9fAQIl1hvoJ5AZ8Nvn2qG7rZAmIWAIv7n+cNMgu9eWFrrZUXOBldJfscYBwMh3z9o1jfdHbJukwLUfolE8nKIF3H3AbNxlg5yUif8gD3fyejeSRjp03dOMC/NL+DtH9sImx9dOk05OhuGzEutbED7ykrcYHeTL2dL+ObA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665939; c=relaxed/simple;
	bh=9HN8XqAvxlUQH8+4U4ULExNkEJNzrQixIaUG7qC6NP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3j94+sxsiXF1o3NpUyBefzEs4L6tEaBaLWyP0rBzGMoMCOfLciwuE7cxMCwAwhRiSdxslmjRLte8Crbck1m5a+IF6le5pHGzqXqKi94ewOCYiBE3mdNVRaqpnss1+k5l5ZfoCg/QQOPXqPjKzuptyeIScQLWsi/ZzC1KI/VfSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QwGqLfdw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QwGqLfdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC261F00893;
	Thu, 17 Sep 2026 17:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665937;
	bh=xYxLBbpTKdZdx9JA07WUczeyMmQ9Wub3qHZUm9Ucoog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QwGqLfdw0KwLjB8dYU1OcqkiNaAfRj0Oq8dYjVALpD+BtafOLR1rlx3Wh+18NUoZI
	 UGKiIGenKBxqZU3Wre3A+bdlJQ3DiljCi0luCOMkD89uG2ABzWHBKCPy5CJcuNpPPS
	 HaBo6aoXlhrFRDKnoSVRaR/5YvJRiGuVTZTfr7RI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Linus Walleij <linusw@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0871/1250] net: ethernet: cortina: Count RX drops once per frame
Date: Thu, 17 Sep 2026 16:11:06 +0100
Message-ID: <20260917151615.583656663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 6520198c430c81bcc367f0dd5e32f2fb740b9d51 ]

The absence of a partial skb means either that the driver is not
assembling a frame or that the current frame was already dropped.
Consequently, repeated descriptor errors can increment rx_dropped more
than once, while an orphaned descriptor chain can reach EOF without being
counted at all.

Track the dropping state across NAPI polls. Clear it at frame boundaries
and route mapping failures and orphaned continuations through the common
drop path so each discarded frame is counted exactly once.

Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
Reported-by: Joe Damato <joe@dama.to>
Closes: https://lore.kernel.org/netdev/apdK5aMmvYssz35F@devvm20253.cco0.facebook.com/
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260903-gemini-ethernet-fixes-v2-4-2bbbd598ca6e@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 41 +++++++++++++++------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 552eec5db396c..efd8be172aa93 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -124,6 +124,7 @@ struct gemini_ethernet_port {
 	unsigned int		rx_coalesce_nsecs;
 	struct sk_buff		*rx_skb;
 	unsigned int		rx_frag_nr;
+	bool			rx_dropping;
 
 	unsigned int		freeq_refill;
 	struct gmac_txq		txq[TX_QUEUE_NUM];
@@ -1452,6 +1453,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 	struct gmac_rxdesc *rx = NULL;
 	struct gmac_queue_page *gpage;
 	unsigned int received = 0;
+	bool dropping = port->rx_dropping;
 	union gmac_rxdesc_0 word0;
 	union gmac_rxdesc_1 word1;
 	union gmac_rxdesc_3 word3;
@@ -1473,6 +1475,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 	w = rw.bits.wptr;
 
 	while (budget && w != r) {
+		page = NULL;
 		rx = port->rxq_ring + r;
 		word0 = rx->word0;
 		word1 = rx->word1;
@@ -1486,6 +1489,16 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 		frame_len = word1.bits.byte_count;
 		page_offs = mapping & ~PAGE_MASK;
 
+		if (word3.bits32 & SOF_BIT) {
+			if (skb) {
+				napi_free_frags(&port->napi);
+				port->stats.rx_dropped++;
+				skb = NULL;
+				frag_nr = 0;
+			}
+			dropping = false;
+		}
+
 		if (!mapping) {
 			netdev_err(netdev,
 				   "rxq[%u]: HW BUG: zero DMA desc\n", r);
@@ -1496,24 +1509,11 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 		gpage = gmac_get_queue_page(geth, port, mapping + PAGE_SIZE);
 		if (!gpage) {
 			dev_err(geth->dev, "could not find mapping\n");
-			port->stats.rx_dropped++;
-			if (skb) {
-				napi_free_frags(&port->napi);
-				skb = NULL;
-				frag_nr = 0;
-			}
-			goto next_desc;
+			goto err_drop;
 		}
 		page = gpage->page;
 
 		if (word3.bits32 & SOF_BIT) {
-			if (skb) {
-				napi_free_frags(&port->napi);
-				port->stats.rx_dropped++;
-				skb = NULL;
-				frag_nr = 0;
-			}
-
 			skb = gmac_skb_if_good_frame(port, word0, frame_len);
 			if (!skb)
 				goto err_drop;
@@ -1523,8 +1523,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 			frag_nr = 0;
 
 		} else if (!skb) {
-			put_page(page);
-			goto next_desc;
+			goto err_drop;
 		}
 
 		if (word3.bits32 & EOF_BIT)
@@ -1557,21 +1556,26 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 			frag_nr = 0;
 		}
 
-		if (mapping)
+		if (page)
 			put_page(page);
 
-		port->stats.rx_dropped++;
+		if (!dropping) {
+			port->stats.rx_dropped++;
+			dropping = true;
+		}
 
 next_desc:
 		/* Final or single-descriptor fragment, advance things */
 		if (word3.bits32 & EOF_BIT) {
 			budget--;
 			received++;
+			dropping = false;
 		}
 	}
 
 	port->rx_skb = skb;
 	port->rx_frag_nr = frag_nr;
+	port->rx_dropping = dropping;
 	writew(r, ptr_reg);
 	return received;
 }
@@ -1901,6 +1905,7 @@ static int gmac_stop(struct net_device *netdev)
 	napi_disable(&port->napi);
 	port->rx_skb = NULL;
 	port->rx_frag_nr = 0;
+	port->rx_dropping = false;
 
 	gmac_enable_irq(netdev, 0);
 	gmac_cleanup_rxq(netdev);
-- 
2.53.0



