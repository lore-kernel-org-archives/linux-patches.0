Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA2215E8B;
	Mon, 30 Dec 2024 15:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573767; cv=none; b=qcJlWQxFqpYKoWN73WNmwyrrhqgG41Lie4jArklWK4AvOrEGNGccJGGji0UduET1bAdPQnnUvBwL71MegROXrLuRC7XvKWkFypJYfnLsR0tYUgFCAS3FJ/6AjwI464ZpvWljlg+3F9Sv3ewkphWlpFzE+OdTQQaz1BgPbvc6iek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573767; c=relaxed/simple;
	bh=ooAuMuyPjgUfQRS3N1fRTsoTirH6kr72rxbs/kXuXiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IL1RuEIXPpXegFWZlKt+GhL1uwLXLPTlCrXqj0d8NIWIx6x7e9Rx0jcbaicG7VEGtzUSN3toGf2zHjDH0fCdLwi86osXknrhhePJENYXx+64bFRlZeqTP/RFemaIO01qYrES8toB+2RtEgXRk6jM1MAvDrdBAszOWL//w5G5gbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AqKsZhvw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AqKsZhvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E600C4CED0;
	Mon, 30 Dec 2024 15:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573767;
	bh=ooAuMuyPjgUfQRS3N1fRTsoTirH6kr72rxbs/kXuXiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AqKsZhvwlrPvDbsa0KYzEOSS+5NlJciBvQp2kiRQ1kbORxhjq73nffgyKl7cMis73
	 oY+/KxnOK1+W5PpOGhE3bICccecj5bNsFORzxUb252XXupRvb8C+dSVuq663XPhu6E
	 Otk55os67yGE2H3SXTMqy43cZcI6eBO08T/WEuJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Finkelstein <fnkl.kernel@gmail.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 26/86] dmaengine: apple-admac: Avoid accessing registers in probe
Date: Mon, 30 Dec 2024 16:42:34 +0100
Message-ID: <20241230154212.714590126@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sasha Finkelstein <fnkl.kernel@gmail.com>

commit 8d55e8a16f019211163f1180fd9f9fbe05901900 upstream.

The ADMAC attached to the AOP has complex power sequencing, and is
power gated when the probe callback runs. Move the register reads
to other functions, where we can guarantee that the hardware is
switched on.

Fixes: 568aa6dd641f ("dmaengine: apple-admac: Allocate cache SRAM to channels")
Signed-off-by: Sasha Finkelstein <fnkl.kernel@gmail.com>
Link: https://lore.kernel.org/r/20241124-admac-power-v1-1-58f2165a4d55@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/apple-admac.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/dma/apple-admac.c
+++ b/drivers/dma/apple-admac.c
@@ -153,6 +153,8 @@ static int admac_alloc_sram_carveout(str
 {
 	struct admac_sram *sram;
 	int i, ret = 0, nblocks;
+	ad->txcache.size = readl_relaxed(ad->base + REG_TX_SRAM_SIZE);
+	ad->rxcache.size = readl_relaxed(ad->base + REG_RX_SRAM_SIZE);
 
 	if (dir == DMA_MEM_TO_DEV)
 		sram = &ad->txcache;
@@ -912,12 +914,7 @@ static int admac_probe(struct platform_d
 		goto free_irq;
 	}
 
-	ad->txcache.size = readl_relaxed(ad->base + REG_TX_SRAM_SIZE);
-	ad->rxcache.size = readl_relaxed(ad->base + REG_RX_SRAM_SIZE);
-
 	dev_info(&pdev->dev, "Audio DMA Controller\n");
-	dev_info(&pdev->dev, "imprint %x TX cache %u RX cache %u\n",
-		 readl_relaxed(ad->base + REG_IMPRINT), ad->txcache.size, ad->rxcache.size);
 
 	return 0;
 


