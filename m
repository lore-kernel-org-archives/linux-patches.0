Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0404C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509CDC433C1;
	Mon, 14 Nov 2022 12:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430774;
	bh=J8FeYCzhsj9DawneU/nb6hHSr9nNVxC2e3w/I0oE91o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VIQ4U1EZ2Jwi8RQbZuXjuIxaMeFmX+mZJQf+Y+D51EkvAQTDQZXHhm1A3N8EEjvug
	 Wat2z2F4GdTdSir7egIZy46aIYuBEil4Tf42Ft0sjpAgV4rburH/a3RafMKhkVe9Rt
	 o/k/+V5osIb+LeuMsZsngV4fOnyYWMmamXw4NMno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Rosin <peda@axentia.se>,
	Tudor Ambarus <tudor.ambarus@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 123/131] dmaengine: at_hdmac: Fix concurrency over the active list
Date: Mon, 14 Nov 2022 13:46:32 +0100
Message-Id: <20221114124453.923973956@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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

commit 03ed9ba357cc78116164b90b87f45eacab60b561 upstream.

The tasklet (atc_advance_work()) did not held the channel lock when
retrieving the first active descriptor, causing concurrency problems if
issue_pending() was called in between. If issue_pending() was called
exactly after the lock was released in the tasklet (atc_advance_work()),
atc_chain_complete() could complete a descriptor for which the controller
has not yet raised an interrupt.

Fixes: dc78baa2b90b ("dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller")
Reported-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-11-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -462,8 +462,6 @@ atc_chain_complete(struct at_dma_chan *a
 	if (!atc_chan_is_cyclic(atchan))
 		dma_cookie_complete(txd);
 
-	/* Remove transfer node from the active list. */
-	list_del_init(&desc->desc_node);
 	spin_unlock_irqrestore(&atchan->lock, flags);
 
 	dma_descriptor_unmap(txd);
@@ -495,6 +493,7 @@ atc_chain_complete(struct at_dma_chan *a
  */
 static void atc_advance_work(struct at_dma_chan *atchan)
 {
+	struct at_desc *desc;
 	unsigned long flags;
 
 	dev_vdbg(chan2dev(&atchan->chan_common), "advance_work\n");
@@ -502,9 +501,12 @@ static void atc_advance_work(struct at_d
 	spin_lock_irqsave(&atchan->lock, flags);
 	if (atc_chan_is_enabled(atchan) || list_empty(&atchan->active_list))
 		return spin_unlock_irqrestore(&atchan->lock, flags);
-	spin_unlock_irqrestore(&atchan->lock, flags);
 
-	atc_chain_complete(atchan, atc_first_active(atchan));
+	desc = atc_first_active(atchan);
+	/* Remove the transfer node from the active list. */
+	list_del_init(&desc->desc_node);
+	spin_unlock_irqrestore(&atchan->lock, flags);
+	atc_chain_complete(atchan, desc);
 
 	/* advance work */
 	spin_lock_irqsave(&atchan->lock, flags);


