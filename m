Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2D25683
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D01C433EF;
	Mon,  3 Apr 2023 14:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531160;
	bh=F5oEs+V5GQZXXD6ZvwNXlGjOnJSg8N0w220pJeonFL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FTsWLp8T9l1yHRVIcOt2ZhcSpEUeTayX4RqSF8jg9byATE1bH3Pa+BA/4xysdnmeU
	 c1LResUtrbA6MFObHK6pMtAyTkMZvPLCSF3bc8ZJzqL5SybF7ajzTJ1yVTYH0KC0hO
	 mKmec6yT29cJTyHGCFQLR2cNUZ+3QayQE43iGWQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Geoff Levand <geoff@infradead.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 12/66] net/ps3_gelic_net: Use dma_mapping_error
Date: Mon,  3 Apr 2023 16:08:20 +0200
Message-Id: <20230403140352.269758193@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140351.636471867@linuxfoundation.org>
References: <20230403140351.636471867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geoff Levand <geoff@infradead.org>

[ Upstream commit bebe933d35a63d4f042fbf4dce4f22e689ba0fcd ]

The current Gelic Etherenet driver was checking the return value of its
dma_map_single call, and not using the dma_mapping_error() routine.

Fixes runtime problems like these:

  DMA-API: ps3_gelic_driver sb_05: device driver failed to check map error
  WARNING: CPU: 0 PID: 0 at kernel/dma/debug.c:1027 .check_unmap+0x888/0x8dc

Fixes: 02c1889166b4 ("ps3: gigabit ethernet driver for PS3, take3")
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Geoff Levand <geoff@infradead.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 24 +++++++++++---------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index 67f61379ba672..572294678faf0 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -330,15 +330,17 @@ static int gelic_card_init_chain(struct gelic_card *card,
 
 	/* set up the hardware pointers in each descriptor */
 	for (i = 0; i < no; i++, descr++) {
+		dma_addr_t cpu_addr;
+
 		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
-		descr->bus_addr =
-			dma_map_single(ctodev(card), descr,
-				       GELIC_DESCR_SIZE,
-				       DMA_BIDIRECTIONAL);
 
-		if (!descr->bus_addr)
+		cpu_addr = dma_map_single(ctodev(card), descr,
+					  GELIC_DESCR_SIZE, DMA_BIDIRECTIONAL);
+
+		if (dma_mapping_error(ctodev(card), cpu_addr))
 			goto iommu_error;
 
+		descr->bus_addr = cpu_to_be32(cpu_addr);
 		descr->next = descr + 1;
 		descr->prev = descr - 1;
 	}
@@ -388,6 +390,7 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
 	static const unsigned int rx_skb_size =
 		ALIGN(GELIC_NET_MAX_FRAME, GELIC_NET_RXBUF_ALIGN) +
 		GELIC_NET_RXBUF_ALIGN - 1;
+	dma_addr_t cpu_addr;
 	int offset;
 
 	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE)
@@ -411,11 +414,10 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
 	if (offset)
 		skb_reserve(descr->skb, GELIC_NET_RXBUF_ALIGN - offset);
 	/* io-mmu-map the skb */
-	descr->buf_addr = cpu_to_be32(dma_map_single(ctodev(card),
-						     descr->skb->data,
-						     GELIC_NET_MAX_FRAME,
-						     DMA_FROM_DEVICE));
-	if (!descr->buf_addr) {
+	cpu_addr = dma_map_single(ctodev(card), descr->skb->data,
+				  GELIC_NET_MAX_FRAME, DMA_FROM_DEVICE);
+	descr->buf_addr = cpu_to_be32(cpu_addr);
+	if (dma_mapping_error(ctodev(card), cpu_addr)) {
 		dev_kfree_skb_any(descr->skb);
 		descr->skb = NULL;
 		dev_info(ctodev(card),
@@ -795,7 +797,7 @@ static int gelic_descr_prepare_tx(struct gelic_card *card,
 
 	buf = dma_map_single(ctodev(card), skb->data, skb->len, DMA_TO_DEVICE);
 
-	if (!buf) {
+	if (dma_mapping_error(ctodev(card), buf)) {
 		dev_err(ctodev(card),
 			"dma map 2 failed (%p, %i). Dropping packet\n",
 			skb->data, skb->len);
-- 
2.39.2



