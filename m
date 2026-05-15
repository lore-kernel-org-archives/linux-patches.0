Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B183BB11C;
	Fri, 15 May 2026 16:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861719; cv=none; b=WXfdYpyzHk9303btDOJhwt2dePenIPhUhuQFpZRDwkG74hH5q/dGPydqe85EpMq3HSmYlMu5sfQx6sDAFHP+IQEjc05fKkDlenPAgH51ww1xNzfdDtiX+vkTqERhNsyPwMrXMJZg742DgWwKfkZFUp09J0UiMKC6YIZvS6Dp29k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861719; c=relaxed/simple;
	bh=Y3zdEfvOFu8ScWSxlVxWBebzA9LvcL0PN37c8KD9SoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zwh89Q1w5H8riwxuj3ndVLrwjCCVJBr6xonErCnM4w1pRfU7Atn6f5FnbAkEuPvOh38V3/b/6OayBA4OOi2PT33KhUpN8rkEPFVr3SL0hdCrryyKaG1RcyDt3fTq6FQP/sNbgMWRMG/ELxx3KAAGvl12k82opswt/2sZ4K9e/PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VtVP1vEC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VtVP1vEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277C2C2BCB0;
	Fri, 15 May 2026 16:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861719;
	bh=Y3zdEfvOFu8ScWSxlVxWBebzA9LvcL0PN37c8KD9SoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VtVP1vECRjSXlTGHoUsq44OeY6Kx0k8Bl1DkjPUXgdx9XTMh8jSP8L6yuIiK9q894
	 OIMhAanwBLRyXfy/XzrWOsn4VIszHJV3Mescj4Vj0QQsDWdfteSzOy/WoFA7w74M2O
	 m/KAy7eHRvypJluxef5E0QCuCXfAQsokm+d2C+pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 438/474] spi: uniphier: Simplify clock handling with devm_clk_get_enabled()
Date: Fri, 15 May 2026 17:49:07 +0200
Message-ID: <20260515154724.560002948@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit fdca270f8f87cae2eb5b619234b9dd11a863ce6b ]

Replace devm_clk_get() followed by clk_prepare_enable() with
devm_clk_get_enabled() for the clock. This removes the need for
explicit clock enable and disable calls, as the managed API automatically
handles clock disabling on device removal or probe failure.

Remove the now-unnecessary clk_disable_unprepare() calls from the probe
error path and the remove callback. Adjust error labels accordingly.

Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Reviewed-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Link: https://patch.msgid.link/b2deeefd4ef1a4bce71116aabfcb7e81400f6d37.1775546948.git.xiaopei01@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0245435f7772 ("spi: uniphier: fix controller deregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-uniphier.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/drivers/spi/spi-uniphier.c
+++ b/drivers/spi/spi-uniphier.c
@@ -666,28 +666,24 @@ static int uniphier_spi_probe(struct pla
 	}
 	priv->base_dma_addr = res->start;
 
-	priv->clk = devm_clk_get(&pdev->dev, NULL);
+	priv->clk = devm_clk_get_enabled(&pdev->dev, NULL);
 	if (IS_ERR(priv->clk)) {
 		dev_err(&pdev->dev, "failed to get clock\n");
 		ret = PTR_ERR(priv->clk);
 		goto out_host_put;
 	}
 
-	ret = clk_prepare_enable(priv->clk);
-	if (ret)
-		goto out_host_put;
-
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		ret = irq;
-		goto out_disable_clk;
+		goto out_host_put;
 	}
 
 	ret = devm_request_irq(&pdev->dev, irq, uniphier_spi_handler,
 			       0, "uniphier-spi", priv);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to request IRQ\n");
-		goto out_disable_clk;
+		goto out_host_put;
 	}
 
 	init_completion(&priv->xfer_done);
@@ -717,7 +713,7 @@ static int uniphier_spi_probe(struct pla
 	if (IS_ERR_OR_NULL(host->dma_tx)) {
 		if (PTR_ERR(host->dma_tx) == -EPROBE_DEFER) {
 			ret = -EPROBE_DEFER;
-			goto out_disable_clk;
+			goto out_host_put;
 		}
 		host->dma_tx = NULL;
 		dma_tx_burst = INT_MAX;
@@ -767,9 +763,6 @@ out_release_dma:
 		host->dma_tx = NULL;
 	}
 
-out_disable_clk:
-	clk_disable_unprepare(priv->clk);
-
 out_host_put:
 	spi_controller_put(host);
 	return ret;
@@ -778,14 +771,11 @@ out_host_put:
 static void uniphier_spi_remove(struct platform_device *pdev)
 {
 	struct spi_controller *host = platform_get_drvdata(pdev);
-	struct uniphier_spi_priv *priv = spi_controller_get_devdata(host);
 
 	if (host->dma_tx)
 		dma_release_channel(host->dma_tx);
 	if (host->dma_rx)
 		dma_release_channel(host->dma_rx);
-
-	clk_disable_unprepare(priv->clk);
 }
 
 static const struct of_device_id uniphier_spi_match[] = {


