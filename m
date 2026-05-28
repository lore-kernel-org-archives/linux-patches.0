Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396C3254B1F;
	Thu, 28 May 2026 20:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999960; cv=none; b=uLjknmTtTIS4Ih1tyh9nOWI0zEEZmYewmS8I0uEGK0IMq6Qxs0e3ThsDHC42kTQiyu3tx8B49iOC5LY+LEU3JmRFV1KHo3d+XPTL39C9nPRYBuMEwok9eoeTaPZ7fKtgLj7u2LdzgZIKgkbRbCJK9zJ6zh/NUjIeethUC8+hFDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999960; c=relaxed/simple;
	bh=aP37UI3dDpFI07qL/ddMv613bJH3/2PI3c6xHGiyYRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdmqpwzgqFKsZ4c3KMthFNt2Y0ZT4AtrkgxUXacRFkDGORMWC8zcTZeG5fzTrFn4p7TSvLBF4++tfizUofV2+4MJuuTqAwxH0+WZBgVIqYhHrVhldAgQZfmxzW64T1GIjReZcwJYaIWQQMyzsCJ1eoFrn7rqdJQp4mXQ5gY4UI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6LKPfIb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6LKPfIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979301F000E9;
	Thu, 28 May 2026 20:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999959;
	bh=0C4dwnY/xoG9Tb6zpEf+hyS1LQsrBbDS5A+5lWZxR/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s6LKPfIbP0CeWCvK9VWW2xuXwodbqeEeZmedwYYfknqZfftTnOAxXo1w+GCA6Xr1D
	 kHLz3tW5jUAf8+dfmMonyEGHvwwIu+FD0GUTkKGAF7WIYFH3+Enz5DrxTpI8brbvEm
	 p/W0Ug/ZadngtScol2YbQoL2Z2GjNh2+MuZ3H094=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 252/377] net: ethernet: cortina: Carry over frag counter
Date: Thu, 28 May 2026 21:48:10 +0200
Message-ID: <20260528194645.672628078@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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
index 63f444e13d6f2..40bec34f06a7b 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -123,6 +123,7 @@ struct gemini_ethernet_port {
 	struct hrtimer		rx_coalesce_timer;
 	unsigned int		rx_coalesce_nsecs;
 	struct sk_buff		*rx_skb;
+	unsigned int		rx_frag_nr;
 
 	unsigned int		freeq_refill;
 	struct gmac_txq		txq[TX_QUEUE_NUM];
@@ -1445,6 +1446,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 	unsigned short m = (1 << port->rxq_order) - 1;
 	struct gemini_ethernet *geth = port->geth;
 	void __iomem *ptr_reg = port->rxq_rwptr;
+	unsigned int frag_nr = port->rx_frag_nr;
 	struct sk_buff *skb = port->rx_skb;
 	unsigned int frame_len, frag_len;
 	struct gmac_rxdesc *rx = NULL;
@@ -1458,7 +1460,6 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 	unsigned short r, w;
 	union dma_rwptr rw;
 	dma_addr_t mapping;
-	int frag_nr = 0;
 
 	spin_lock_irqsave(&geth->irq_lock, flags);
 	rw.bits32 = readl(ptr_reg);
@@ -1498,6 +1499,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 				napi_free_frags(&port->napi);
 				port->stats.rx_dropped++;
 				skb = NULL;
+				frag_nr = 0;
 			}
 			continue;
 		}
@@ -1508,6 +1510,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 				napi_free_frags(&port->napi);
 				port->stats.rx_dropped++;
 				skb = NULL;
+				frag_nr = 0;
 			}
 
 			skb = gmac_skb_if_good_frame(port, word0, frame_len);
@@ -1542,6 +1545,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 		if (word3.bits32 & EOF_BIT) {
 			napi_gro_frags(&port->napi);
 			skb = NULL;
+			frag_nr = 0;
 			--budget;
 		}
 		continue;
@@ -1550,6 +1554,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 		if (skb) {
 			napi_free_frags(&port->napi);
 			skb = NULL;
+			frag_nr = 0;
 		}
 
 		if (mapping)
@@ -1559,6 +1564,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 	}
 
 	port->rx_skb = skb;
+	port->rx_frag_nr = frag_nr;
 	writew(r, ptr_reg);
 	return budget;
 }
@@ -1887,6 +1893,7 @@ static int gmac_stop(struct net_device *netdev)
 	gmac_stop_dma(port);
 	napi_disable(&port->napi);
 	port->rx_skb = NULL;
+	port->rx_frag_nr = 0;
 
 	gmac_enable_irq(netdev, 0);
 	gmac_cleanup_rxq(netdev);
-- 
2.53.0



