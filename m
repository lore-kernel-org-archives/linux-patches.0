Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D202426EB9;
	Tue, 31 Mar 2026 16:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975122; cv=none; b=gu4qWXJ/gpZp7s+dTWeDH/jYNoEyeAhliiIa4rGzEfbaP4N36Ahz9n8bV3cwt1RI6qzBXCO4/Xz0ZXij98slzkvDHiIs5UQ3mDYMWu+PQqpGE1CWGpj/4+Irc2DMfc8WlETSItgga2qujjy9gAZF22bw4ObgHML/ihD5Isn0Wc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975122; c=relaxed/simple;
	bh=oKXWcNgzzcSxItDxOqPAGnWcIIg43sYg0e/z4Glvxsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WabNZJwsgCBHp4qO6y7LAmtR7PwbdoWgLku70ERJOj0sz35qB9tfrsx9jAEra+lT/Ym7QmPJSyzemz/TKA/EgAp9tOGASqp3Lo+OTaDdstVACBmIieLQXP/ZdVrk9nODpxi2YJyEPk4RiswRrmGPISqdvNz0iHFz56ItGN8xhiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UPjw85zJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UPjw85zJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30497C19424;
	Tue, 31 Mar 2026 16:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975122;
	bh=oKXWcNgzzcSxItDxOqPAGnWcIIg43sYg0e/z4Glvxsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UPjw85zJDTV872sPMsiY3jdXVmvWczLS3i6oHXX4jSiQIqI8cHbmO5HXSfbv2aHSH
	 EYunOh2rkjAb4EkqZzEh3IrIDQo92V1qDkdKhKVOIuW4ALvB8BApJCpb/ZDO5zYdUg
	 pU7UObQRckQZo6ftgP5mqpa/By4Pa85cMZHNxgP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 173/342] spi: sn-f-ospi: Fix resource leak in f_ospi_probe()
Date: Tue, 31 Mar 2026 18:20:06 +0200
Message-ID: <20260331161805.376284865@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index c4969f66a0ba9..84a5b327022e8 100644
--- a/drivers/spi/spi-sn-f-ospi.c
+++ b/drivers/spi/spi-sn-f-ospi.c
@@ -612,7 +612,7 @@ static int f_ospi_probe(struct platform_device *pdev)
 	u32 num_cs = OSPI_NUM_CS;
 	int ret;
 
-	ctlr = spi_alloc_host(dev, sizeof(*ospi));
+	ctlr = devm_spi_alloc_host(dev, sizeof(*ospi));
 	if (!ctlr)
 		return -ENOMEM;
 
@@ -636,16 +636,12 @@ static int f_ospi_probe(struct platform_device *pdev)
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
 
@@ -662,9 +658,6 @@ static int f_ospi_probe(struct platform_device *pdev)
 err_destroy_mutex:
 	mutex_destroy(&ospi->mlock);
 
-err_put_ctlr:
-	spi_controller_put(ctlr);
-
 	return ret;
 }
 
-- 
2.53.0



