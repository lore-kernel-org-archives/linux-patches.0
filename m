Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8727D2594B6;
	Mon, 30 Dec 2024 15:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573638; cv=none; b=K6Pc9dU1m2TK2D81Pi+pDNdmslUfmvtNyNcmYxu1Fdqs1f8fakOM4m/W4mqynl2zhS7GZqDv0/WFHSlNnWdUr2Ed2SDOxKWYqVYN0vnlodUYbb+/EPLM1w3elo35aSdqE4qYObWK1jPJ/nSkOmYmDsQKXRG+nA+YLSSsan7j8pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573638; c=relaxed/simple;
	bh=xz5gmXoW9BdPe3/OUSCplyyakmqfKsF5uWspwbj3x0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZnxCFaUMK5VwqUg/zlp4ynAfnknsKctI57QeH5IMtgnmLv3rZCzb3wUB3LZjnSVwMaIscnLrM0/q6cdmdUR5DLPyTFmhuLjW8hDgJEv61RXEB03jpDm3YBdWAc8Vzxh5VsGLrkxr7x+UDNMkCPSI/gvhlImNQqEWpMzsoQ0FBsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BexURkfJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BexURkfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84668C4CED0;
	Mon, 30 Dec 2024 15:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573638;
	bh=xz5gmXoW9BdPe3/OUSCplyyakmqfKsF5uWspwbj3x0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BexURkfJ9KxhKJSKQFWC1q/2pCmmea0aw7qUvR1kGvbE+y2jrrsnyOhsnfZtjBlAi
	 wAwuAAtPGtLhKzo55wxKqTKK1Z0NaLCfsKL4U759v6gYz90oEJjqi2KL3MTLiFHEIG
	 +I86cUnXEWr89YCBAkeiV/5D9CQap9xBwBOA37Uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Finkelstein <fnkl.kernel@gmail.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 21/60] dmaengine: apple-admac: Avoid accessing registers in probe
Date: Mon, 30 Dec 2024 16:42:31 +0100
Message-ID: <20241230154208.092028861@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -152,6 +152,8 @@ static int admac_alloc_sram_carveout(str
 {
 	struct admac_sram *sram;
 	int i, ret = 0, nblocks;
+	ad->txcache.size = readl_relaxed(ad->base + REG_TX_SRAM_SIZE);
+	ad->rxcache.size = readl_relaxed(ad->base + REG_RX_SRAM_SIZE);
 
 	if (dir == DMA_MEM_TO_DEV)
 		sram = &ad->txcache;
@@ -911,12 +913,7 @@ static int admac_probe(struct platform_d
 		goto free_irq;
 	}
 
-	ad->txcache.size = readl_relaxed(ad->base + REG_TX_SRAM_SIZE);
-	ad->rxcache.size = readl_relaxed(ad->base + REG_RX_SRAM_SIZE);
-
 	dev_info(&pdev->dev, "Audio DMA Controller\n");
-	dev_info(&pdev->dev, "imprint %x TX cache %u RX cache %u\n",
-		 readl_relaxed(ad->base + REG_IMPRINT), ad->txcache.size, ad->rxcache.size);
 
 	return 0;
 


