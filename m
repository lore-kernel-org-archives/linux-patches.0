Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211A84C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C733C433D6;
	Mon, 14 Nov 2022 12:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430309;
	bh=zdPsptslFmSwYjF3tA2yC8tWAdOCh8O/4yBL0+WaVIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jyPPw/b+/2H+ZXAgr7zqlSQus8QYY4kM6Abfbg7brmvKOZwOKs+5UdATjapa3JnNd
	 15hKphwtartSbbwvPfOE3nLU4AWlqfDGmlwJojgPOhSxtV9ydAW91Tz9HIQOYYIToJ
	 HGi4MUikieGbi+SqZZyK7oPYDi8CJ4lD8EHdznh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 87/95] dmaengine: at_hdmac: Free the memset buf without holding the chan lock
Date: Mon, 14 Nov 2022 13:46:21 +0100
Message-Id: <20221114124446.132320509@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit 6ba826cbb57d675f447b59323204d1473bbd5593 upstream.

There's no need to hold the channel lock when freeing the memset buf, as
the operation has already completed. Free the memset buf without holding
the channel lock.

Fixes: 4d112426c344 ("dmaengine: hdmac: Add memset capabilities")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-10-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -443,13 +443,6 @@ atc_chain_complete(struct at_dma_chan *a
 	if (!atc_chan_is_cyclic(atchan))
 		dma_cookie_complete(txd);
 
-	/* If the transfer was a memset, free our temporary buffer */
-	if (desc->memset_buffer) {
-		dma_pool_free(atdma->memset_pool, desc->memset_vaddr,
-			      desc->memset_paddr);
-		desc->memset_buffer = false;
-	}
-
 	/* Remove transfer node from the active list. */
 	list_del_init(&desc->desc_node);
 	spin_unlock_irqrestore(&atchan->lock, flags);
@@ -468,6 +461,13 @@ atc_chain_complete(struct at_dma_chan *a
 	/* add myself to free_list */
 	list_add(&desc->desc_node, &atchan->free_list);
 	spin_unlock_irqrestore(&atchan->lock, flags);
+
+	/* If the transfer was a memset, free our temporary buffer */
+	if (desc->memset_buffer) {
+		dma_pool_free(atdma->memset_pool, desc->memset_vaddr,
+			      desc->memset_paddr);
+		desc->memset_buffer = false;
+	}
 }
 
 /**


