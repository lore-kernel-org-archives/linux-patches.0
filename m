Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1B44C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35B0C433C1;
	Mon, 14 Nov 2022 12:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430318;
	bh=hlFa+ybX/Wd8c8NLPdzBMGT+eBmagczC03D/ytBpEsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0L/sam3tD6Ou/JLTmqMerqXvuCT0L0u9jJw/5Wi0D/C1hso4j98PogpA/XZBlz+h
	 4sjpLchHyJBDL+KlHqx4hlpHXt5AMK2mdykL+FBAeh3OZvhY5eXE/bnrIW2+JInd3O
	 Go5GxvAOHfMArAcH1Mq9s1cqU3/IisydJGHxw3l0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Rosin <peda@axentia.se>,
	Tudor Ambarus <tudor.ambarus@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 90/95] dmaengine: at_hdmac: Fix completion of unissued descriptor in case of errors
Date: Mon, 14 Nov 2022 13:46:24 +0100
Message-Id: <20221114124446.232160409@linuxfoundation.org>
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
@@ -520,10 +520,6 @@ static void atc_handle_error(struct at_d
 	bad_desc = atc_first_active(atchan);
 	list_del_init(&bad_desc->desc_node);
 
-	/* As we are stopped, take advantage to push queued descriptors
-	 * in active_list */
-	list_splice_init(&atchan->queue, atchan->active_list.prev);
-
 	/* Try to restart the controller */
 	if (!list_empty(&atchan->active_list)) {
 		desc = atc_first_queued(atchan);


