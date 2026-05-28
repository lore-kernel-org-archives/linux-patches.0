Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612B2339866;
	Thu, 28 May 2026 20:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998770; cv=none; b=BY3nv8+PpZOsjaOI1zyWKnhE3CFNE0NfQTrqUA/y5VKBVe8XwqtXmhvx5bJAVD6I2TkvhJKNJmWxc4fFjoVYVFu1F8gKDpXo5d54BMAWqMXGOggSnZzzaDyn/+36yTSEOHwF9LZBHVXrnkFjnkiYmYkKnMsqVjiU8jiiFxjXVk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998770; c=relaxed/simple;
	bh=Amy3hkgbaa6kXT7N27XVz3DKswKbP0C+Ch4jQu+zrEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMKZhYXoSUoNSsjMZF6SO5Cnx6AMNgqRSxTfT6OCKb4x2TmeXY7zQVgI5ohINkBhL+d3dmDbYxlTTUbUjsdec1gdQCiyLY4SpLEOPwZnzFHQIO93uxs+XwlrxLoCSyesn0goko1mY7f6zwJwpONMz1a0R/fN/T2BMA5pneu9b40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcVsO5LC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcVsO5LC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB301F000E9;
	Thu, 28 May 2026 20:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998769;
	bh=AZ8dswdZvFjPjuBE5upF+oiub8n8b9cCwVgAt5CR0zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FcVsO5LC8jVi82ySEICxUVc4hZpItAbmsYinB+azBDQox5EG/R/kGsU2zNp1z95pd
	 5RqR4dDy2osuOvmEoSn7P7aOSKsLShwIndsu2A54m7Lbz6eN3jYyaTEsU8LLyJPFjr
	 yT4eAXmwvI0PuCOgEWGdBgsADwDSBEkMFEuCzm6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 274/461] net: ethernet: cortina: Carry over frag counter
Date: Thu, 28 May 2026 21:46:43 +0200
Message-ID: <20260528194655.102448941@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index e8d973b8fb0c3..ccd14a386e3b9 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -123,6 +123,7 @@ struct gemini_ethernet_port {
 	struct hrtimer		rx_coalesce_timer;
 	unsigned int		rx_coalesce_nsecs;
 	struct sk_buff		*rx_skb;
+	unsigned int		rx_frag_nr;
 
 	unsigned int		freeq_refill;
 	struct gmac_txq		txq[TX_QUEUE_NUM];
@@ -1444,6 +1445,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 	unsigned short m = (1 << port->rxq_order) - 1;
 	struct gemini_ethernet *geth = port->geth;
 	void __iomem *ptr_reg = port->rxq_rwptr;
+	unsigned int frag_nr = port->rx_frag_nr;
 	struct sk_buff *skb = port->rx_skb;
 	unsigned int frame_len, frag_len;
 	struct gmac_rxdesc *rx = NULL;
@@ -1457,7 +1459,6 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 	unsigned short r, w;
 	union dma_rwptr rw;
 	dma_addr_t mapping;
-	int frag_nr = 0;
 
 	spin_lock_irqsave(&geth->irq_lock, flags);
 	rw.bits32 = readl(ptr_reg);
@@ -1497,6 +1498,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 				napi_free_frags(&port->napi);
 				port->stats.rx_dropped++;
 				skb = NULL;
+				frag_nr = 0;
 			}
 			continue;
 		}
@@ -1507,6 +1509,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 				napi_free_frags(&port->napi);
 				port->stats.rx_dropped++;
 				skb = NULL;
+				frag_nr = 0;
 			}
 
 			skb = gmac_skb_if_good_frame(port, word0, frame_len);
@@ -1541,6 +1544,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 		if (word3.bits32 & EOF_BIT) {
 			napi_gro_frags(&port->napi);
 			skb = NULL;
+			frag_nr = 0;
 			--budget;
 		}
 		continue;
@@ -1549,6 +1553,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 		if (skb) {
 			napi_free_frags(&port->napi);
 			skb = NULL;
+			frag_nr = 0;
 		}
 
 		if (mapping)
@@ -1558,6 +1563,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 	}
 
 	port->rx_skb = skb;
+	port->rx_frag_nr = frag_nr;
 	writew(r, ptr_reg);
 	return budget;
 }
@@ -1886,6 +1892,7 @@ static int gmac_stop(struct net_device *netdev)
 	gmac_stop_dma(port);
 	napi_disable(&port->napi);
 	port->rx_skb = NULL;
+	port->rx_frag_nr = 0;
 
 	gmac_enable_irq(netdev, 0);
 	gmac_cleanup_rxq(netdev);
-- 
2.53.0



