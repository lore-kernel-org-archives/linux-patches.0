Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF646328610;
	Tue, 16 Jun 2026 17:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629446; cv=none; b=uayNJSTlhY8aJq4fO8sg3373nKdq1z75/7+RuV2uz/NE05VFqaLQdd2vAsS/uLrBMdjXh2X83iTG6c9J5PJcmxm5Wj+mHKfrauLGBb9c6HFLgpMPlwcus3vVOQ3IAyOSajXIV8pVo4Y5cJlt0sqY7LidavbBjyBEbZ3WX1e4v8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629446; c=relaxed/simple;
	bh=/KJNRfOFCVbeu2R1UY3McMbPEgASWPF44FvoaS7uxRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJqTpcI0fu0vtyeaGRjWWfUPrnJ9LFR6kzGo3g1OTHFQBiaSI2IhPLL6zDvxEDeNKv0bMGY+1nIk3ubiRHHRRnwx8ZVvX9o73vmO0bVJ+r6idujz+aXbUGzJ7fG1kiMVw+n/UjOxfUqeML0DGtXKfnic7p3MiJc0RdvdnZbuVt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+zl0i95; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+zl0i95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B559F1F000E9;
	Tue, 16 Jun 2026 17:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629445;
	bh=DP8P8K61XHr72P2gfQvX89A59jBMZnItx2sfzuPY4vY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V+zl0i95OU+iOhEm4FitQLkJ8+TYtvnuMQFoXLLKmjn06P11zADzguY0dqE6D9bw6
	 +Urxl6qbNkbHKT2PJ2Qg/XU4unRPSzXQtMlok2G49zcErVnDlXMxn3fyx8InZTt00/
	 R3VIzcDTF7lf75syNUHPRc4xpkuim3CxaU7LE47A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Til Kaiser <mail@tk154.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 285/452] net: mvpp2: build skb from XDP-adjusted data on XDP_PASS
Date: Tue, 16 Jun 2026 20:28:32 +0530
Message-ID: <20260616145132.573625821@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5bdc26bebe4488..ab608cd497a936 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3919,10 +3919,10 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
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
 
@@ -3935,6 +3935,8 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		rx_status = mvpp2_rxdesc_status_get(port, rx_desc);
 		rx_bytes = mvpp2_rxdesc_size_get(port, rx_desc);
 		rx_bytes -= MVPP2_MH_SIZE;
+		rx_sync_size = rx_bytes + MVPP2_MH_SIZE;
+		rx_offset = MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM;
 		dma_addr = mvpp2_rxdesc_dma_addr_get(port, rx_desc);
 
 		pool = (rx_status & MVPP2_RXD_BM_POOL_ID_MASK) >>
@@ -3950,7 +3952,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 
 		dma_sync_single_range_for_cpu(dev->dev.parent, dma_addr,
 					      MVPP2_SKB_HEADROOM,
-					      rx_bytes + MVPP2_MH_SIZE,
+					      rx_sync_size,
 					      dma_dir);
 
 		/* Buffer header not supported */
@@ -4001,6 +4003,14 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
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
 
@@ -4012,8 +4022,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 			netdev_warn(port->dev, "skb build failed\n");
 			if (pp) {
 				page_pool_put_page(pp, virt_to_head_page(data),
-						   rx_bytes + MVPP2_MH_SIZE,
-						   true);
+						   rx_sync_size, true);
 			} else {
 				dma_unmap_single_attrs(dev->dev.parent, dma_addr,
 						       bm_pool->buf_size,
@@ -4043,7 +4052,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		ps.rx_packets++;
 		ps.rx_bytes += rx_bytes;
 
-		skb_reserve(skb, MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM);
+		skb_reserve(skb, rx_offset);
 		skb_put(skb, rx_bytes);
 		if (metasize)
 			skb_metadata_set(skb, metasize);
-- 
2.53.0



