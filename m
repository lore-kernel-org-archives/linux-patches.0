Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E57A31281C;
	Wed, 21 Jan 2026 18:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019806; cv=none; b=JanpjoypNjh7tKjQm9H2xxk/5Eh4bxXxe1GS7d0Hx2UV19U6WISSRx/so91XdEO6j51vtI/UxHMcULw5h1MCdo8yNvovr5o7TQk1I0/vO0fR05oIDUGRk/w0U+4hza106nhLN9NmilmnzHqacDwFW67JqLJtBVSwWwIUn7KbPPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019806; c=relaxed/simple;
	bh=Im5DY7ph9oV48T2FHZg8q6pXEVyHRrJl5tC+wB7o5tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9+NEQc5/lUEBkaaXEtPM1RlV0gSqlYG1o6wYXY/bYlu8MfS0Ie1zgpnzcIAdPxiU/bGJLgDELkrhWnI1L+Wv7Q/hRVbxYyOiIqzGpOhkbNeCHzGfEA0ygNukWcGwNEXLB3AY0/apiLIoAfpoOkKCfz/Z8eh/sVJm7/D7A0RzYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jrJ9b9UF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jrJ9b9UF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DACAC4CEF1;
	Wed, 21 Jan 2026 18:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019806;
	bh=Im5DY7ph9oV48T2FHZg8q6pXEVyHRrJl5tC+wB7o5tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrJ9b9UFzZyTnudYW5mC+aXiAIU47ahMM3l4BlhMisrfUwAZ7xmzNezUYTclDaIvE
	 Ilg/SSUqNIlzHl6aVUSG9AZeyGVKvGC4RPpvpzsZhPEQ13Zz4lPrQoXn4JpPctIbxC
	 bVGccmtWDo2altex28NuCeoOdWm8uuP8YIbLPJME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Vladimir Zapolskiy <vz@mleia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 113/139] dmaengine: lpc18xx-dmamux: fix device leak on route allocation
Date: Wed, 21 Jan 2026 19:16:01 +0100
Message-ID: <20260121181415.517344935@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -57,30 +57,31 @@ static void *lpc18xx_dmamux_reserve(stru
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
@@ -89,7 +90,8 @@ static void *lpc18xx_dmamux_reserve(stru
 		dev_err(&pdev->dev, "dma request %u busy with %u.%u\n",
 			mux, mux, dmamux->muxes[mux].value);
 		of_node_put(dma_spec->np);
-		return ERR_PTR(-EBUSY);
+		ret = -EBUSY;
+		goto err_put_pdev;
 	}
 
 	dmamux->muxes[mux].busy = true;
@@ -106,7 +108,14 @@ static void *lpc18xx_dmamux_reserve(stru
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


