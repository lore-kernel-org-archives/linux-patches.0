Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5723034A78E;
	Sat, 12 Sep 2026 14:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224081; cv=none; b=dmUggzkTDi12v9klfZzihhg0hbOhlG1D3SLVE4k580kcIZx0BTOahOJceDnjSIsG3WH0vNwcxFt+hufvWjB5jZMJbwt0XG4d5BXjZlmueBqYuUa1Tc7m3RpGorY38vstZfqiwYcYv2bGzSzpIIhkaNo92XdWi2hQXT3GtcrTjxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224081; c=relaxed/simple;
	bh=Z/C3MKNwQmU+Gu0iCTpeFi1Zm8+lJCMLQ1Q24ODItK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdoLD5kXwu3K+bJVNCiHX3IBLknwstYyA5vdrxmEPZeP2N0lDTUQAJNYpGJ3giSHexCeo8Rnxw+v5N/ppfzN+dtchsTjd3Tepii/Ao0t5Jt9s9I8hDBIC7Fj1u3biK+qk0carsznmp0oMYrV1k0fZYDs8Zk3F4c2o9pXUg9LFac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oDN3l7ET; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oDN3l7ET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3721F000FF;
	Sat, 12 Sep 2026 14:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224078;
	bh=TixZbCCn4DYbWwOtd4oBcfnTDhfLX+9iFaCLLAAR+yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oDN3l7ETrrXSYBQ/OoBNIfKDpfuPEec1AlZxz57/0Xj8q6Ff1cVor7red0HR4wVJP
	 QuCXJIyhbZMFJsAEEVa/28QeU4bdKxbEP2gt0PrugtKP1gQIAPO9WmXc/v6QYEwgNH
	 mCgs7y35erRuPqWpMphBIfnhWG8fTRkHrekLN+3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Li Zetao <lizetao1@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0921/1424] spi: davinci: Use helper function devm_clk_get_enabled()
Date: Sat, 12 Sep 2026 08:55:53 +0200
Message-ID: <20260912065627.949773039@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Li Zetao <lizetao1@huawei.com>

[ Upstream commit 9dc2aa96a3533215fbed9cf1297f7aa70dae840b ]

Since commit 7ef9651e9792 ("clk: Provide new devm_clk helpers for prepared
and enabled clocks"), devm_clk_get() and clk_prepare_enable() can now be
replaced by devm_clk_get_enabled() when driver enables (and possibly
prepares) the clocks for the whole lifetime of the device. Moreover, it is
no longer necessary to unprepare and disable the clocks explicitly.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Link: https://lore.kernel.org/r/20230823133938.1359106-11-lizetao1@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: ea408a05dc8f ("spi: davinci: switch to managed controller allocation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-davinci.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/spi/spi-davinci.c b/drivers/spi/spi-davinci.c
index c457b550d3adf..5688be245c68a 100644
--- a/drivers/spi/spi-davinci.c
+++ b/drivers/spi/spi-davinci.c
@@ -915,14 +915,11 @@ static int davinci_spi_probe(struct platform_device *pdev)
 
 	dspi->bitbang.master = host;
 
-	dspi->clk = devm_clk_get(&pdev->dev, NULL);
+	dspi->clk = devm_clk_get_enabled(&pdev->dev, NULL);
 	if (IS_ERR(dspi->clk)) {
 		ret = -ENODEV;
 		goto free_host;
 	}
-	ret = clk_prepare_enable(dspi->clk);
-	if (ret)
-		goto free_host;
 
 	host->use_gpio_descriptors = true;
 	host->dev.of_node = pdev->dev.of_node;
@@ -947,7 +944,7 @@ static int davinci_spi_probe(struct platform_device *pdev)
 
 	ret = davinci_spi_request_dma(dspi);
 	if (ret == -EPROBE_DEFER) {
-		goto free_clk;
+		goto free_host;
 	} else if (ret) {
 		dev_info(&pdev->dev, "DMA is not supported (%d)\n", ret);
 		dspi->dma_rx = NULL;
@@ -991,8 +988,6 @@ static int davinci_spi_probe(struct platform_device *pdev)
 		dma_release_channel(dspi->dma_rx);
 		dma_release_channel(dspi->dma_tx);
 	}
-free_clk:
-	clk_disable_unprepare(dspi->clk);
 free_host:
 	spi_controller_put(host);
 err:
@@ -1018,8 +1013,6 @@ static void davinci_spi_remove(struct platform_device *pdev)
 
 	spi_bitbang_stop(&dspi->bitbang);
 
-	clk_disable_unprepare(dspi->clk);
-
 	if (dspi->dma_rx) {
 		dma_release_channel(dspi->dma_rx);
 		dma_release_channel(dspi->dma_tx);
-- 
2.53.0



