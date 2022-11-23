Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14CD1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:13:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4695FC433D6;
	Wed, 23 Nov 2022 09:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194782;
	bh=DHnu9Kj8lDXtv7Qud2tqVP72YccyPGWrtfhI/W4B+Ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zKWRm4xHr66KKcIEWn7aWj2SIfQFKj8C6uxlT6FS1JHjxQJfHBb6nw37Bpxx4tjGz
	 X/X1gaN2GVlmtM1IVfrBrxm14exEKX0GXBi4Te8fXO2i31FXRzB9ZHOq45Dq2iMqXF
	 ts8RG9nYRvYdtoL8Wp7SraErxJa/iEJxp7wN3gYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Rosin <peda@axentia.se>,
	Tudor Ambarus <tudor.ambarus@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 058/156] dmaengine: at_hdmac: Fix completion of unissued descriptor in case of errors
Date: Wed, 23 Nov 2022 09:50:15 +0100
Message-Id: <20221123084600.051447788@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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

commit ef2cb4f0ce479f77607b04c4b0414bf32f863ee8 upstream.

In case the controller detected an error, the code took the chance to move
all the queued (submitted) descriptors to the active (issued) list. This
was wrong as if there were any descriptors in the submitted list they were
moved to the issued list without actually issuing them to the controller,
thus a completion could be raised without even fireing the descriptor.

Fixes: dc78baa2b90b ("dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller")
Reported-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-13-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -550,10 +550,6 @@ static void atc_handle_error(struct at_d
 	bad_desc = atc_first_active(atchan);
 	list_del_init(&bad_desc->desc_node);
 
-	/* As we are stopped, take advantage to push queued descriptors
-	 * in active_list */
-	list_splice_init(&atchan->queue, atchan->active_list.prev);
-
 	/* Try to restart the controller */
 	if (!list_empty(&atchan->active_list))
 		atc_dostart(atchan, atc_first_active(atchan));


