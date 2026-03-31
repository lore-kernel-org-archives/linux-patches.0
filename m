Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3E1425CD4;
	Tue, 31 Mar 2026 16:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975870; cv=none; b=gpu7KKEHGTR1OSgyA/0jh5WnKlTyj07c4THIfee2ibn04ipRsI/78IS8QIgJtwUhtridJqBvHZUwW9YbK0ei3/HyZ0g0DOO4zs8+9oUOI171GmmoC+XRisf+uY1C/gPxG23IwHx7Jx+85mf1GDyq9f/xAgsBXnKDvgjos2jU87M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975870; c=relaxed/simple;
	bh=n80LRVviTYEzo4LI23v1fxRkF9f5wtZXY9GhDqewReo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBZRRxpEHQbfjuTa0OVNyMGMmpayHEP1smZr4x8HgizrsyRwEm7YfA845NP012onO6evbU1sOlgVfoD0D1EIrBRUWNvDzf5w0cm+eAihTktBcuDbOPK3P8/9lkEOK7Oh9zgZHRYrACpDRG5K/JZoSmzpCR8SE0OOMYSgeasP00s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gnLMi6nw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gnLMi6nw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D10C19423;
	Tue, 31 Mar 2026 16:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975870;
	bh=n80LRVviTYEzo4LI23v1fxRkF9f5wtZXY9GhDqewReo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gnLMi6nwvWlKfnYgjn20wZh6I9FU97PzP9TekhBhvK3Yj4FUxBdz+AXHSyX5BbKhW
	 6r2Ea2xi4Orfhehe9I0URifXCJrhvJ9NqdjU6NU7phms9ypgYWUPsoZxzb9IJZJzqI
	 0mx1q/Gvx6fZvxfsDVVpaXxmmQfq/bOZIh5q9elM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/244] spi: sn-f-ospi: Fix resource leak in f_ospi_probe()
Date: Tue, 31 Mar 2026 18:21:09 +0200
Message-ID: <20260331161746.056406396@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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



