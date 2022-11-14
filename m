Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA724C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E960AC433D6;
	Mon, 14 Nov 2022 12:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430364;
	bh=WbBpas0mvd04JRbgT16+vXrhTVDhRPYxB5XAdtwYoZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lmlgbIW+fGGqkZTizDyzmPcbMgfXT+DGhN5pH7gsohNeHzpPev73JBr1RQ7eQKV1q
	 mGj2GxlQM89UwQ6bNBPOMjYRTRiqkr6553tDS/QrOml8LRGil6a3XFxjwiPEiRoNrG
	 wRe1QZmMEOFXQhSQbl/JRzEpduzThHYZidLQqKys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Rosin <peda@axentia.se>,
	Tudor Ambarus <tudor.ambarus@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 84/95] dmaengine: at_hdmac: Protect atchan->status with the channel lock
Date: Mon, 14 Nov 2022 13:46:18 +0100
Message-Id: <20221114124446.034004136@linuxfoundation.org>
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

commit 6e5ad28d16f082efeae3d0bd2e31f24bed218019 upstream.

Now that the complete callback call was removed from
device_terminate_all(), we can protect the atchan->status with the channel
lock. The atomic bitops on atchan->status do not substitute proper locking
on the status, as one could still modify the status after the lock was
dropped in atc_terminate_all() but before the atomic bitops were executed.

Fixes: 078a6506141a ("dmaengine: at_hdmac: Fix deadlocks")
Reported-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-7-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1433,12 +1433,12 @@ static int atc_terminate_all(struct dma_
 	list_splice_tail_init(&atchan->queue, &atchan->free_list);
 	list_splice_tail_init(&atchan->active_list, &atchan->free_list);
 
-	spin_unlock_irqrestore(&atchan->lock, flags);
-
 	clear_bit(ATC_IS_PAUSED, &atchan->status);
 	/* if channel dedicated to cyclic operations, free it */
 	clear_bit(ATC_IS_CYCLIC, &atchan->status);
 
+	spin_unlock_irqrestore(&atchan->lock, flags);
+
 	return 0;
 }
 


