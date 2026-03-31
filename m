Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33DD3FADEE;
	Tue, 31 Mar 2026 16:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974446; cv=none; b=qdDKA+r/bmYLJWTCrakwu7xCtYloDJDveFBKXXVF2QAHb6qBWkpy0krMARGVPpxhovSNodgAWalzAIjBJA5K9HOF+CB55Rtrg4e79iPKnIoq5EFA057sk0+Ng1MkK0AywP7O3f3opRORe0n1FlB39Xm6AoJZVsJ4YmV2R7a+dzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974446; c=relaxed/simple;
	bh=e5e8quDCOGs4ioD+AQSmfvzNlHOj8d56Pgnmb7eXH3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJe5ncf5phBu7m7Vejd3t/XvH3MA+iXeRRGsIp7WU83wic//szV+bQdk6I/xsCQvSghHdAo/GDTLZ6CD4OVVgAYEX4u2yQLf5WAplp8ZiOqLjUPR+9pT0667mZRWt82CmByPaAXRNwK2N2qsHCyvJjSqSExRo2itHOtmnFd9yKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDY1jm/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDY1jm/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A9AC19423;
	Tue, 31 Mar 2026 16:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974446;
	bh=e5e8quDCOGs4ioD+AQSmfvzNlHOj8d56Pgnmb7eXH3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FDY1jm/CotTDPQ3IG2aS+YGPnJpU2NMojOaq1lGuygBNlMv8sbcRRttUWiEL56Ovd
	 DMeAfxgXNGUH1BSiyZzPsxakTt0NEgdOWhj6rloArnd+x2AWSibgQTxF/6tI0OXrx7
	 OVyph7EKGb6gZImiVFruGgFxcOlExzl/qrnmeFLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/175] spi: sn-f-ospi: Fix resource leak in f_ospi_probe()
Date: Tue, 31 Mar 2026 18:21:13 +0200
Message-ID: <20260331161733.041373425@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit ef3d549e1deb3466c61f3b01d22fc3fe3e5efb08 ]

In f_ospi_probe(), when num_cs validation fails, it returns without
calling spi_controller_put() on the SPI controller, which causes a
resource leak.

Use devm_spi_alloc_host() instead of spi_alloc_host() to ensure the
SPI controller is properly freed when probe fails.

Fixes: 1b74dd64c861 ("spi: Add Socionext F_OSPI SPI flash controller driver")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260319-sn-f-v1-1-33a6738d2da8@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sn-f-ospi.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/spi/spi-sn-f-ospi.c b/drivers/spi/spi-sn-f-ospi.c
index fd8c8eb37d01d..2d6d50b6f4dc9 100644
--- a/drivers/spi/spi-sn-f-ospi.c
+++ b/drivers/spi/spi-sn-f-ospi.c
@@ -609,7 +609,7 @@ static int f_ospi_probe(struct platform_device *pdev)
 	u32 num_cs = OSPI_NUM_CS;
 	int ret;
 
-	ctlr = spi_alloc_host(dev, sizeof(*ospi));
+	ctlr = devm_spi_alloc_host(dev, sizeof(*ospi));
 	if (!ctlr)
 		return -ENOMEM;
 
@@ -632,16 +632,12 @@ static int f_ospi_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, ospi);
 
 	ospi->base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(ospi->base)) {
-		ret = PTR_ERR(ospi->base);
-		goto err_put_ctlr;
-	}
+	if (IS_ERR(ospi->base))
+		return PTR_ERR(ospi->base);
 
 	ospi->clk = devm_clk_get_enabled(dev, NULL);
-	if (IS_ERR(ospi->clk)) {
-		ret = PTR_ERR(ospi->clk);
-		goto err_put_ctlr;
-	}
+	if (IS_ERR(ospi->clk))
+		return PTR_ERR(ospi->clk);
 
 	mutex_init(&ospi->mlock);
 
@@ -658,9 +654,6 @@ static int f_ospi_probe(struct platform_device *pdev)
 err_destroy_mutex:
 	mutex_destroy(&ospi->mlock);
 
-err_put_ctlr:
-	spi_controller_put(ctlr);
-
 	return ret;
 }
 
-- 
2.53.0



