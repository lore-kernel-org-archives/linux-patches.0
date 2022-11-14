Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7EB4C70
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A146C433C1;
	Mon, 14 Nov 2022 13:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668431316;
	bh=gy/S17sFEoUkovssIC83Mzw4wHwkYitBcBIaYbhfWBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+MlWjwqjdFJB6fU2km06n9Dd8P5zR7dvvMTzt0apoZo63mOIShtt6DmLaIA/YzP0
	 Uo1barIWX49czYNrwFlUhdoG/St8tnY+FunOdjZ7633cH0T+8m91xCX2gvQnWS/vOU
	 pddWJDnCyITkTWadTtWXZxaR8azWX0xK8UfZYej8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Rosin <peda@axentia.se>,
	Tudor Ambarus <tudor.ambarus@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.0 181/190] dmaengine: at_hdmac: Fix concurrency over descriptor
Date: Mon, 14 Nov 2022 13:46:45 +0100
Message-Id: <20221114124506.795860670@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

commit 06988949df8c3007ad82036d3606d8ae72ed9000 upstream.

The descriptor was added to the free_list before calling the callback,
which could result in reissuing of the same descriptor and calling of a
single callback for both. Move the decriptor to the free list after the
callback is invoked.

Fixes: dc78baa2b90b ("dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller")
Reported-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-9-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -469,11 +469,8 @@ atc_chain_complete(struct at_dma_chan *a
 		desc->memset_buffer = false;
 	}
 
-	/* move children to free_list */
-	list_splice_init(&desc->tx_list, &atchan->free_list);
-	/* move myself to free_list */
-	list_move(&desc->desc_node, &atchan->free_list);
-
+	/* Remove transfer node from the active list. */
+	list_del_init(&desc->desc_node);
 	spin_unlock_irqrestore(&atchan->lock, flags);
 
 	dma_descriptor_unmap(txd);
@@ -483,6 +480,13 @@ atc_chain_complete(struct at_dma_chan *a
 		dmaengine_desc_get_callback_invoke(txd, NULL);
 
 	dma_run_dependencies(txd);
+
+	spin_lock_irqsave(&atchan->lock, flags);
+	/* move children to free_list */
+	list_splice_init(&desc->tx_list, &atchan->free_list);
+	/* add myself to free_list */
+	list_add(&desc->desc_node, &atchan->free_list);
+	spin_unlock_irqrestore(&atchan->lock, flags);
 }
 
 /**


