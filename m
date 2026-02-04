Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB98426D20;
	Wed,  4 Feb 2026 15:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217626; cv=none; b=JOOPa6Z8NIPdT/xzIMw9T7JRLgSmXZJYy1OI2ljdBhF61vZpiooMeiIjDT+gRo08FdFM3LfguGPHJz3nszjUYdScsqy30AIDDjEWW+Fml27xA0Au2NM0mEA3YkQ80PUoZCLYW6Fn6/tcEc0EdHX7JbJ+UBWvC5lUcYpyw1NHaJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217626; c=relaxed/simple;
	bh=FB9BblkcWaDJWPV3LLcbZ9/QcbztOl1uKSdHIPK/JNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFd6g7u8xmTCAM6ib7s7bP9Ph8DsTAWIUIZHvPrQS0SXAaoPaBFLYq40IIn6y6N4BKwxoxopdO27QskTmR96UHzmvb7L7x/0Gkv4lywYrJ8ut0BmeEI6RyMF+3TS7EIHkJUpUXPjISlPUQte7HsM4y/PXxvmdc2NQTqaxV9HE4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2OAj8Mzx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2OAj8Mzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C17C4CEF7;
	Wed,  4 Feb 2026 15:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217626;
	bh=FB9BblkcWaDJWPV3LLcbZ9/QcbztOl1uKSdHIPK/JNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2OAj8Mzx1YHN0GwXX667jqECafABmMtuL8brHhUrxgM480+DZH2UJxf3c7imgGvZC
	 ZadshH1gIw+UiC3lBS27s0FTB+T1tSisKLL2dPfvqyxt+PEET537JPXvrCr1AwpM+z
	 9yk5rvcNX19WoHDhKcnqi2OuKShwJ9HkbeVE0EDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Vladimir Zapolskiy <vz@mleia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 071/280] dmaengine: lpc18xx-dmamux: fix device leak on route allocation
Date: Wed,  4 Feb 2026 15:37:25 +0100
Message-ID: <20260204143912.211578956@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Johan Hovold <johan@kernel.org>

commit d4d63059dee7e7cae0c4d9a532ed558bc90efb55 upstream.

Make sure to drop the reference taken when looking up the DMA mux
platform device during route allocation.

Note that holding a reference to a device does not prevent its driver
data from going away so there is no point in keeping the reference.

Fixes: e5f4ae84be74 ("dmaengine: add driver for lpc18xx dmamux")
Cc: stable@vger.kernel.org	# 4.3
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Vladimir Zapolskiy <vz@mleia.com>
Link: https://patch.msgid.link/20251117161258.10679-8-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/lpc18xx-dmamux.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/dma/lpc18xx-dmamux.c
+++ b/drivers/dma/lpc18xx-dmamux.c
@@ -55,30 +55,31 @@ static void *lpc18xx_dmamux_reserve(stru
 	struct lpc18xx_dmamux_data *dmamux = platform_get_drvdata(pdev);
 	unsigned long flags;
 	unsigned mux;
+	int ret = -EINVAL;
 
 	if (dma_spec->args_count != 3) {
 		dev_err(&pdev->dev, "invalid number of dma mux args\n");
-		return ERR_PTR(-EINVAL);
+		goto err_put_pdev;
 	}
 
 	mux = dma_spec->args[0];
 	if (mux >= dmamux->dma_master_requests) {
 		dev_err(&pdev->dev, "invalid mux number: %d\n",
 			dma_spec->args[0]);
-		return ERR_PTR(-EINVAL);
+		goto err_put_pdev;
 	}
 
 	if (dma_spec->args[1] > LPC18XX_DMAMUX_MAX_VAL) {
 		dev_err(&pdev->dev, "invalid dma mux value: %d\n",
 			dma_spec->args[1]);
-		return ERR_PTR(-EINVAL);
+		goto err_put_pdev;
 	}
 
 	/* The of_node_put() will be done in the core for the node */
 	dma_spec->np = of_parse_phandle(ofdma->of_node, "dma-masters", 0);
 	if (!dma_spec->np) {
 		dev_err(&pdev->dev, "can't get dma master\n");
-		return ERR_PTR(-EINVAL);
+		goto err_put_pdev;
 	}
 
 	spin_lock_irqsave(&dmamux->lock, flags);
@@ -87,7 +88,8 @@ static void *lpc18xx_dmamux_reserve(stru
 		dev_err(&pdev->dev, "dma request %u busy with %u.%u\n",
 			mux, mux, dmamux->muxes[mux].value);
 		of_node_put(dma_spec->np);
-		return ERR_PTR(-EBUSY);
+		ret = -EBUSY;
+		goto err_put_pdev;
 	}
 
 	dmamux->muxes[mux].busy = true;
@@ -104,7 +106,14 @@ static void *lpc18xx_dmamux_reserve(stru
 	dev_dbg(&pdev->dev, "mapping dmamux %u.%u to dma request %u\n", mux,
 		dmamux->muxes[mux].value, mux);
 
+	put_device(&pdev->dev);
+
 	return &dmamux->muxes[mux];
+
+err_put_pdev:
+	put_device(&pdev->dev);
+
+	return ERR_PTR(ret);
 }
 
 static int lpc18xx_dmamux_probe(struct platform_device *pdev)


