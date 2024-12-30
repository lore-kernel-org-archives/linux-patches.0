Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F7C2E414;
	Mon, 30 Dec 2024 15:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574086; cv=none; b=K3cDntA2Rra2+WeiKqqVpZpDEBVFzFcBggXnmvGyp83lxOw5ViU2tP5IY/1WDKijAPP1B0xW3ijuUpdgM453sFXdcF5owmmhy1RNhD0U/fPbkE3+2cIgJ3GHh7KePijOC9QNTPsfPRnaXTtZxZPByKhIV4WeGcpaCAWmhk6/wuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574086; c=relaxed/simple;
	bh=/acXmkfBLN2OSDGMY8Piqo3VXseDpa2vDT8a5hDGtmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmoAPHHE5yb5F+VxMpsrwz3eyuFh9KgQgYJMzPl1/KqlFqirFr6UHMBVkvRdC0QCSvZwZEZegXmbW90WID41FL3PnHhwBCDTL8xwBGDhU/WVs0OVd+nawRnbltYGBGu7WxbRl53RVfwyJGRBAio7bxFwX9uLMSY/BniKzK9i2Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1tLWAV0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1tLWAV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D11C4CED0;
	Mon, 30 Dec 2024 15:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574086;
	bh=/acXmkfBLN2OSDGMY8Piqo3VXseDpa2vDT8a5hDGtmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1tLWAV0/IlvGNdLxYT/2vSJAzkEw8TvWPBGG3Mj/D+eAuQ6LP50RZGpWvdtcPfLQ
	 spsjxoEhQDNfTqIbAh6UDhStcPEZBWuNWG4yCqbsrAG1QJ+NuUBVZhXg/pejEF/9Uy
	 E4zbefpZMJaqwIL9/u7gqGosqMQCta0Rg4lgiHjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Finkelstein <fnkl.kernel@gmail.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 033/114] dmaengine: apple-admac: Avoid accessing registers in probe
Date: Mon, 30 Dec 2024 16:42:30 +0100
Message-ID: <20241230154219.336558768@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


