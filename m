Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4395136679;
	Tue, 14 May 2024 10:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684400; cv=none; b=qkCe9aJBSR3hrUf390WieArOyLGu2GZFfTYFUirlA/e5peCc9C4bLLl9fjLvc4GY3D26zDPz5DKR1YOHMOv2d6rdQifbxqeSzHKKZDrITC+7x+rJowxSC1/iZoV7RPQ82NwaMxuO07iy4EcUyP8vm8bMlEbvSZCcrCm0JpgFi1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684400; c=relaxed/simple;
	bh=hMN9kuV8Qc0+3495P5lO00390Hldd0Bx1w1PWbret+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxV9wiOpPHCqwD7Cl9vpja5TDzhdyrns5XZ8LitENWc71ak/gNlo2hmTLfC58NWQczP97cTc0Q4vMyS/RGnshyC7V0VruhmWDwhOTrJNQVzMPnDgdJlnIEecO8hZSRxZVdDzYhAr7bmDvR0YEuDFAGHT9IYDW++5245y9etiYd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E94wT4j9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E94wT4j9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5897DC2BD10;
	Tue, 14 May 2024 10:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684399;
	bh=hMN9kuV8Qc0+3495P5lO00390Hldd0Bx1w1PWbret+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E94wT4j9+FTfv8KuOx/aWVhv9INsoui8pbMDYGBgsRUgJqfKJBfUCPgFZmJfj6sWc
	 0z9EnU0kzQyJjw8jBY0+UXgoSdvasJtxHR3FET1s2heV1YIT+58ryCqTj3EBfwUQZ3
	 x+6u1vKY3EbVx2Q/DkkXDLVDo1QoYt+qB2K+qzdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/301] spi: axi-spi-engine: use devm_spi_alloc_host()
Date: Tue, 14 May 2024 12:15:08 +0200
Message-ID: <20240514101033.646561128@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit e12cd96e8e93044646fdf4b2c9a1de62cfa01e7c ]

This modifies the AXI SPI Engine driver to use devm_spi_alloc_host()
instead of spi_alloc_host() to simplify the code a bit.

In addition to simplifying the error paths in the probe function, we
can also remove spi_controller_get/put() calls in the remove function
since devm_spi_alloc_host() sets a flag to no longer decrement the
controller reference count in the spi_unregister_controller() function.

Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://lore.kernel.org/r/20231117-axi-spi-engine-series-1-v1-4-cc59db999b87@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0064db9ce4aa ("spi: axi-spi-engine: fix version format string")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-axi-spi-engine.c | 31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff --git a/drivers/spi/spi-axi-spi-engine.c b/drivers/spi/spi-axi-spi-engine.c
index bdf0aa4ceb1df..77c1c115448d6 100644
--- a/drivers/spi/spi-axi-spi-engine.c
+++ b/drivers/spi/spi-axi-spi-engine.c
@@ -473,7 +473,7 @@ static int spi_engine_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	host = spi_alloc_host(&pdev->dev, sizeof(*spi_engine));
+	host = devm_spi_alloc_host(&pdev->dev, sizeof(*spi_engine));
 	if (!host)
 		return -ENOMEM;
 
@@ -482,22 +482,16 @@ static int spi_engine_probe(struct platform_device *pdev)
 	spin_lock_init(&spi_engine->lock);
 
 	spi_engine->clk = devm_clk_get_enabled(&pdev->dev, "s_axi_aclk");
-	if (IS_ERR(spi_engine->clk)) {
-		ret = PTR_ERR(spi_engine->clk);
-		goto err_put_host;
-	}
+	if (IS_ERR(spi_engine->clk))
+		return PTR_ERR(spi_engine->clk);
 
 	spi_engine->ref_clk = devm_clk_get_enabled(&pdev->dev, "spi_clk");
-	if (IS_ERR(spi_engine->ref_clk)) {
-		ret = PTR_ERR(spi_engine->ref_clk);
-		goto err_put_host;
-	}
+	if (IS_ERR(spi_engine->ref_clk))
+		return PTR_ERR(spi_engine->ref_clk);
 
 	spi_engine->base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(spi_engine->base)) {
-		ret = PTR_ERR(spi_engine->base);
-		goto err_put_host;
-	}
+	if (IS_ERR(spi_engine->base))
+		return PTR_ERR(spi_engine->base);
 
 	version = readl(spi_engine->base + SPI_ENGINE_REG_VERSION);
 	if (SPI_ENGINE_VERSION_MAJOR(version) != 1) {
@@ -505,8 +499,7 @@ static int spi_engine_probe(struct platform_device *pdev)
 			SPI_ENGINE_VERSION_MAJOR(version),
 			SPI_ENGINE_VERSION_MINOR(version),
 			SPI_ENGINE_VERSION_PATCH(version));
-		ret = -ENODEV;
-		goto err_put_host;
+		return -ENODEV;
 	}
 
 	writel_relaxed(0x00, spi_engine->base + SPI_ENGINE_REG_RESET);
@@ -515,7 +508,7 @@ static int spi_engine_probe(struct platform_device *pdev)
 
 	ret = request_irq(irq, spi_engine_irq, 0, pdev->name, host);
 	if (ret)
-		goto err_put_host;
+		return ret;
 
 	host->dev.of_node = pdev->dev.of_node;
 	host->mode_bits = SPI_CPOL | SPI_CPHA | SPI_3WIRE;
@@ -533,14 +526,12 @@ static int spi_engine_probe(struct platform_device *pdev)
 	return 0;
 err_free_irq:
 	free_irq(irq, host);
-err_put_host:
-	spi_controller_put(host);
 	return ret;
 }
 
 static void spi_engine_remove(struct platform_device *pdev)
 {
-	struct spi_controller *host = spi_controller_get(platform_get_drvdata(pdev));
+	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct spi_engine *spi_engine = spi_controller_get_devdata(host);
 	int irq = platform_get_irq(pdev, 0);
 
@@ -548,8 +539,6 @@ static void spi_engine_remove(struct platform_device *pdev)
 
 	free_irq(irq, host);
 
-	spi_controller_put(host);
-
 	writel_relaxed(0xff, spi_engine->base + SPI_ENGINE_REG_INT_PENDING);
 	writel_relaxed(0x00, spi_engine->base + SPI_ENGINE_REG_INT_ENABLE);
 	writel_relaxed(0x01, spi_engine->base + SPI_ENGINE_REG_RESET);
-- 
2.43.0



