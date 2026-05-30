Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC804315F;
	Sat, 30 May 2026 18:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167189; cv=none; b=M9quxmyZwYUf/bZxHEoQItVJ3DTjh4EqvOHUYmil4o2fxSqWPdBP8Nc24qWxKjIKvpR2Kstor97Yy0Lbw8TQyYHabPx9nHoFNqmb1izlKDanEk3Rk5ybcGBrs2YzBHqBe4S0pfJ/8pZiYBUM43JTMt8xq+j1M+m7jYIJfkoE4SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167189; c=relaxed/simple;
	bh=6Iml0bBb3aerY97YR1vkUb+jGt/6rM2SqzSLpY8CBGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQhgeOsVjOjhfe2d/SgYkYGJd6dlYs/4eSvtjAYISW/U9U1CLw9WYyrTUhf4ge5nHbxKVehIICzlHaNqTCzUNQdsLsyf18xro+QJLiF/sZkxpj6PhZTbM7Q7gzmgnEaJLOj1EgN8uWAOu0b1Rn7mK7j7urpaqoI5muX54nA6fso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XcjnGxFZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XcjnGxFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57A61F00893;
	Sat, 30 May 2026 18:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780167188;
	bh=Vi4/+bA629KPZO/AP0btmEHVAdboNg/AWbmqJl6BRHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XcjnGxFZ1yFDF1Rn9DaGah+J0p54ZN343h7PXzwXUtN+u5eDxeXf9KgBcWR/FCfDs
	 TE15gbK1jRMW5aI6Xa49TTAchzJ3q0sPLTs3G1yt11g2CogEai+vIxnMyBkmJNcZpJ
	 bljvBbGTdUmhsanWd1QRgUEu8bTmhZys1zlFadiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 577/589] net: ethernet: cortina: Carry over frag counter
Date: Sat, 30 May 2026 18:07:38 +0200
Message-ID: <20260530160239.770818494@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit ebd8ec2b309e3a447851b456ccaf8fb39f3661e7 ]

The gmac_rx() NAPI poll function assembles packets in an
SKB from a ring buffer.

If the ring buffer gets completely emptied during a poll cycle,
we exit gmac_rx(), but the packet is not yet completely
assembled in the SKB, yet the fragment counter frag_nr is
reset to zero on the next invocation.

Solve this by making the RX fragment counter a part of the
port struct, and carry it over between invocations.

Reset the fragment counter only right after calling
napi_gro_frags(), on error (after calling napi_free_frags())
or if stopping the port.

Reset it in some place where not strictly necessary just to
emphasize what is going on.

This was found by Sashiko during normal patch review.

Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
Link: https://sashiko.dev/#/patchset/20260505-gemini-ethernet-fix-v2-1-997c31d06079%40kernel.org
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260509-gemini-ethernet-fixes-v1-3-6c5d20ddc35b@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 642ef6b3eebaf..3e93d1115f1aa 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -122,6 +122,7 @@ struct gemini_ethernet_port {
 	struct hrtimer		rx_coalesce_timer;
 	unsigned int		rx_coalesce_nsecs;
 	struct sk_buff		*rx_skb;
+	unsigned int		rx_frag_nr;
 
 	unsigned int		freeq_refill;
 	struct gmac_txq		txq[TX_QUEUE_NUM];
@@ -1414,6 +1415,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 	unsigned short m = (1 << port->rxq_order) - 1;
 	struct gemini_ethernet *geth = port->geth;
 	void __iomem *ptr_reg = port->rxq_rwptr;
+	unsigned int frag_nr = port->rx_frag_nr;
 	struct sk_buff *skb = port->rx_skb;
 	unsigned int frame_len, frag_len;
 	struct gmac_rxdesc *rx = NULL;
@@ -1427,7 +1429,6 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 	unsigned short r, w;
 	union dma_rwptr rw;
 	dma_addr_t mapping;
-	int frag_nr = 0;
 
 	spin_lock_irqsave(&geth->irq_lock, flags);
 	rw.bits32 = readl(ptr_reg);
@@ -1467,6 +1468,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 				napi_free_frags(&port->napi);
 				port->stats.rx_dropped++;
 				skb = NULL;
+				frag_nr = 0;
 			}
 			continue;
 		}
@@ -1477,6 +1479,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 				napi_free_frags(&port->napi);
 				port->stats.rx_dropped++;
 				skb = NULL;
+				frag_nr = 0;
 			}
 
 			skb = gmac_skb_if_good_frame(port, word0, frame_len);
@@ -1511,6 +1514,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 		if (word3.bits32 & EOF_BIT) {
 			napi_gro_frags(&port->napi);
 			skb = NULL;
+			frag_nr = 0;
 			--budget;
 		}
 		continue;
@@ -1519,6 +1523,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 		if (skb) {
 			napi_free_frags(&port->napi);
 			skb = NULL;
+			frag_nr = 0;
 		}
 
 		if (mapping)
@@ -1528,6 +1533,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 	}
 
 	port->rx_skb = skb;
+	port->rx_frag_nr = frag_nr;
 	writew(r, ptr_reg);
 	return budget;
 }
@@ -1857,6 +1863,7 @@ static int gmac_stop(struct net_device *netdev)
 	gmac_stop_dma(port);
 	napi_disable(&port->napi);
 	port->rx_skb = NULL;
+	port->rx_frag_nr = 0;
 
 	gmac_enable_irq(netdev, 0);
 	gmac_cleanup_rxq(netdev);
-- 
2.53.0



