Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F7C283FE5;
	Tue, 16 Jun 2026 15:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623616; cv=none; b=KOVAZ4tJd0TNpywxbCrO5aMyMdQSTx4nyH4vDuG+Gyex0VBiS0FGjViY+DXO7eR/hMBN4qXNQiXavXpglAehqyowAfh92vVM+dTVjKe4UV/MVH1uBiM6F835UGs3g7Azv5OQog3qMXHtIfyRUY6+FNg5/Sq8iDyfpSAE09ecgHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623616; c=relaxed/simple;
	bh=J2K6ZtdzlXvuUlPDmRidphsxO+4Bn3xITJx+73zej6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=daUjCLYDE0E5p4pyQOom9D5ZPukh+hYabLcxqligYa2ZSkdtIV0tPQYi4xap42IB/LBYQLDEVEDPyCqkuUqpStCJ9hIObN4DcbgD0vjRayhIkBOAWpZoypUMZG6r+DHJ40osbaFbK44jdtmuXUOik/7dYA4/Gc9p3DeHLAtHw7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+3RV/l3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+3RV/l3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081A01F000E9;
	Tue, 16 Jun 2026 15:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623614;
	bh=IWNoIWGJytMEISJX8eBQ+WwQWWWSJUyQSYfts2dgWTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n+3RV/l3Z5nijxA3Y3V/81nIRrWC7ur/joh3UepTJd2CHrcWmIbPVA7KNm8Vj1y06
	 XDQmics6WWnQKcqoveXKQD9nsHWUm+ZeCw0HtoWev8F3IiCOJKVZkH7ME9s6VpH79A
	 Y27Oc4VdAcY40NZS55FWiUJbrT9vXVWXjjFAhq5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Til Kaiser <mail@tk154.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 149/378] net: mvpp2: build skb from XDP-adjusted data on XDP_PASS
Date: Tue, 16 Jun 2026 20:26:20 +0530
Message-ID: <20260616145118.102215211@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

From: Til Kaiser <mail@tk154.de>

[ Upstream commit 77a6b90ce56bc982dcfa94229b8e28e6abb16e95 ]

When an XDP program uses bpf_xdp_adjust_head() or bpf_xdp_adjust_tail()
and then returns XDP_PASS, mvpp2 still builds the skb from fixed offsets
derived from the original RX descriptor. Packet geometry changes made by
the XDP program are therefore discarded before the skb reaches the stack.

Update rx_offset and rx_bytes from xdp.data and xdp.data_end for
XDP_PASS. This makes skb_reserve() and skb_put() reflect the packet seen
by XDP, and makes RX byte accounting for XDP_PASS follow the length of the
skb passed to the network stack.

Keep a separate rx_sync_size for page-pool recycling on skb allocation
failure, which must stay tied to the received buffer range.

Non-PASS verdicts continue to account the descriptor length because no skb
is passed up in those cases.

Fixes: 07dd0a7aae7f ("mvpp2: add basic XDP support")
Signed-off-by: Til Kaiser <mail@tk154.de>
Link: https://patch.msgid.link/20260607134943.21996-5-mail@tk154.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 21 +++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 481daafdc1cbc7..ccc24a1301f22d 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3917,10 +3917,10 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		struct mvpp2_bm_pool *bm_pool;
 		struct page_pool *pp = NULL;
 		struct sk_buff *skb;
-		unsigned int frag_size;
+		unsigned int frag_size, rx_sync_size;
 		dma_addr_t dma_addr;
 		phys_addr_t phys_addr;
-		int pool, rx_bytes, err, ret;
+		int pool, rx_bytes, rx_offset, err, ret;
 		struct page *page;
 		void *data;
 
@@ -3933,6 +3933,8 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		rx_status = mvpp2_rxdesc_status_get(port, rx_desc);
 		rx_bytes = mvpp2_rxdesc_size_get(port, rx_desc);
 		rx_bytes -= MVPP2_MH_SIZE;
+		rx_sync_size = rx_bytes + MVPP2_MH_SIZE;
+		rx_offset = MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM;
 		dma_addr = mvpp2_rxdesc_dma_addr_get(port, rx_desc);
 
 		pool = (rx_status & MVPP2_RXD_BM_POOL_ID_MASK) >>
@@ -3948,7 +3950,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 
 		dma_sync_single_range_for_cpu(dev->dev.parent, dma_addr,
 					      MVPP2_SKB_HEADROOM,
-					      rx_bytes + MVPP2_MH_SIZE,
+					      rx_sync_size,
 					      dma_dir);
 
 		/* Buffer header not supported */
@@ -3999,6 +4001,14 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 				continue;
 			}
 
+			rx_sync_size = max_t(unsigned int, rx_sync_size,
+					     xdp.data_end - xdp.data_hard_start -
+					     MVPP2_SKB_HEADROOM);
+
+			/* Update offset and length to reflect any XDP adjustments. */
+			rx_offset = xdp.data     - data;
+			rx_bytes  = xdp.data_end - xdp.data;
+
 			metasize = xdp.data - xdp.data_meta;
 		}
 
@@ -4010,8 +4020,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 			netdev_warn(port->dev, "skb build failed\n");
 			if (pp) {
 				page_pool_put_page(pp, virt_to_head_page(data),
-						   rx_bytes + MVPP2_MH_SIZE,
-						   true);
+						   rx_sync_size, true);
 			} else {
 				dma_unmap_single_attrs(dev->dev.parent, dma_addr,
 						       bm_pool->buf_size,
@@ -4041,7 +4050,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		ps.rx_packets++;
 		ps.rx_bytes += rx_bytes;
 
-		skb_reserve(skb, MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM);
+		skb_reserve(skb, rx_offset);
 		skb_put(skb, rx_bytes);
 		if (metasize)
 			skb_metadata_set(skb, metasize);
-- 
2.53.0



