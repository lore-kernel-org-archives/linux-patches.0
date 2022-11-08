Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7433515CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07E5C433C1;
	Tue,  8 Nov 2022 14:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916491;
	bh=8CcrbfD+XgWexLjRJq/8HSqYZIY3mKJ96VSH0WCfyQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xst5zB0lzyoaGxqnESDV/MVDdNjAqCjs8eEw9FePlRbeDc7FqjXiDjYkVGscXeMPh
	 D7+rnuYxDaeAAuVkVGBNvo5E8PeTHJcB+L2IJimPAPt/7WEeiFIen1go2hKfn/5hA9
	 oFSriMURH/myUyAjwHWBUiMMMfHMlLMJKyn4ZMGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 038/197] net: lan966x: Fix unmapping of received frames using FDMA
Date: Tue,  8 Nov 2022 14:37:56 +0100
Message-Id: <20221108133356.550576266@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit fc57062f98b0b0ae52bc584d8fd5ac77c50df607 ]

When lan966x was receiving a frame, then it was building the skb and
after that it was calling dma_unmap_single with frame size as the
length. This actually has 2 issues:
1. It is using a length to map and a different length to unmap.
2. When the unmap was happening, the data was sync for cpu but it could
   be that this will overwrite what build_skb was initializing.

The fix for these two problems is to change the order of operations.
First to sync the frame for cpu, then to build the skb and in the end to
unmap using the correct size but without sync the frame again for cpu.

Fixes: c8349639324a ("net: lan966x: Add FDMA functionality")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://lore.kernel.org/r/20221031133421.1283196-1-horatiu.vultur@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/microchip/lan966x/lan966x_fdma.c  | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 407a6c125515..3a1a0f9178c0 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -414,13 +414,15 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx)
 	/* Get the received frame and unmap it */
 	db = &rx->dcbs[rx->dcb_index].db[rx->db_index];
 	page = rx->page[rx->dcb_index][rx->db_index];
+
+	dma_sync_single_for_cpu(lan966x->dev, (dma_addr_t)db->dataptr,
+				FDMA_DCB_STATUS_BLOCKL(db->status),
+				DMA_FROM_DEVICE);
+
 	skb = build_skb(page_address(page), PAGE_SIZE << rx->page_order);
 	if (unlikely(!skb))
 		goto unmap_page;
 
-	dma_unmap_single(lan966x->dev, (dma_addr_t)db->dataptr,
-			 FDMA_DCB_STATUS_BLOCKL(db->status),
-			 DMA_FROM_DEVICE);
 	skb_put(skb, FDMA_DCB_STATUS_BLOCKL(db->status));
 
 	lan966x_ifh_get_src_port(skb->data, &src_port);
@@ -429,6 +431,10 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx)
 	if (WARN_ON(src_port >= lan966x->num_phys_ports))
 		goto free_skb;
 
+	dma_unmap_single_attrs(lan966x->dev, (dma_addr_t)db->dataptr,
+			       PAGE_SIZE << rx->page_order, DMA_FROM_DEVICE,
+			       DMA_ATTR_SKIP_CPU_SYNC);
+
 	skb->dev = lan966x->ports[src_port]->dev;
 	skb_pull(skb, IFH_LEN * sizeof(u32));
 
@@ -454,9 +460,9 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx)
 free_skb:
 	kfree_skb(skb);
 unmap_page:
-	dma_unmap_page(lan966x->dev, (dma_addr_t)db->dataptr,
-		       FDMA_DCB_STATUS_BLOCKL(db->status),
-		       DMA_FROM_DEVICE);
+	dma_unmap_single_attrs(lan966x->dev, (dma_addr_t)db->dataptr,
+			       PAGE_SIZE << rx->page_order, DMA_FROM_DEVICE,
+			       DMA_ATTR_SKIP_CPU_SYNC);
 	__free_pages(page, rx->page_order);
 
 	return NULL;
-- 
2.35.1



