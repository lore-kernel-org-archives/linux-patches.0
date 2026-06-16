Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9A1472771;
	Tue, 16 Jun 2026 17:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632359; cv=none; b=bl4wWtyNc4W2ePBMF13rXIO1sUp3ENV4gpmBQ2ZsE2YqQTISxLhQJ8XHj75c4d47HVq1OgOdIgqX3vvhgyvHuDNX76hxghJuC5liiDYBm+Lh7UAxu2NrDYafXGnelpXBb6r81TyBiyhM960yZMkQbfuAR1AyGzTTOobgaTkkQHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632359; c=relaxed/simple;
	bh=IiiQGSoqXh+sWdr6dJWhgLCSL1XMeFVxcxJkSw5vbxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghVDbbBLYDJPSkzyFHBjdblbYWIIQ4J4TUPHaWdY3WO5TUtp9c4O8lut7Tl3WEsdy1FIEkVg3ztjWW9FwpetMULst9x95ASKUCzbOIFkJhCF6GQddm82ZuWEZ8Yp4VbvvG+wf4TTZ2LGEjpGfCxSUlXSv16xYq1f7ld9EpJV4KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fL8MWQ/M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fL8MWQ/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292EA1F000E9;
	Tue, 16 Jun 2026 17:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632356;
	bh=kkaxYV7pNechZnG7moOEjpPpTy2IvCpGUSsQ/EgsaUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fL8MWQ/MNp6vk5na9uqN9E7YAd2Pv27ATA0NuhDRiW3R2JLRltivYDMeXirZZbDmU
	 6/c2jhhYlm8eDMEqD5dNu2Dp+0HLZOYhSiBqOPdXpMQ0+LQTnX+4zSnKSZd+wWUs6D
	 axRL/a6eSN0C+YSoePXQzxHbFfxSvhy//0UVa2No=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 395/522] spi: s3c64xx: Use devm_clk_get_enabled()
Date: Tue, 16 Jun 2026 20:29:02 +0530
Message-ID: <20260616145144.362081196@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Andi Shyti <andi.shyti@kernel.org>

[ Upstream commit 20c475d21ed9326f7b1396c9bb8991b375cb6c50 ]

Replace the tuple devm_clk_get()/clk_prepare_enable() with the
single function devm_clk_get_enabled().

Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20230531205550.568340-1-andi.shyti@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 45daacbead8a ("spi: s3c64xx: fix NULL-deref on driver unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-s3c64xx.c |   39 +++++----------------------------------
 1 file changed, 5 insertions(+), 34 deletions(-)

--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -1189,46 +1189,28 @@ static int s3c64xx_spi_probe(struct plat
 	}
 
 	/* Setup clocks */
-	sdd->clk = devm_clk_get(&pdev->dev, "spi");
+	sdd->clk = devm_clk_get_enabled(&pdev->dev, "spi");
 	if (IS_ERR(sdd->clk)) {
 		dev_err(&pdev->dev, "Unable to acquire clock 'spi'\n");
 		ret = PTR_ERR(sdd->clk);
 		goto err_deref_master;
 	}
 
-	ret = clk_prepare_enable(sdd->clk);
-	if (ret) {
-		dev_err(&pdev->dev, "Couldn't enable clock 'spi'\n");
-		goto err_deref_master;
-	}
-
 	sprintf(clk_name, "spi_busclk%d", sci->src_clk_nr);
-	sdd->src_clk = devm_clk_get(&pdev->dev, clk_name);
+	sdd->src_clk = devm_clk_get_enabled(&pdev->dev, clk_name);
 	if (IS_ERR(sdd->src_clk)) {
 		dev_err(&pdev->dev,
 			"Unable to acquire clock '%s'\n", clk_name);
 		ret = PTR_ERR(sdd->src_clk);
-		goto err_disable_clk;
-	}
-
-	ret = clk_prepare_enable(sdd->src_clk);
-	if (ret) {
-		dev_err(&pdev->dev, "Couldn't enable clock '%s'\n", clk_name);
-		goto err_disable_clk;
+		goto err_deref_master;
 	}
 
 	if (sdd->port_conf->clk_ioclk) {
-		sdd->ioclk = devm_clk_get(&pdev->dev, "spi_ioclk");
+		sdd->ioclk = devm_clk_get_enabled(&pdev->dev, "spi_ioclk");
 		if (IS_ERR(sdd->ioclk)) {
 			dev_err(&pdev->dev, "Unable to acquire 'ioclk'\n");
 			ret = PTR_ERR(sdd->ioclk);
-			goto err_disable_src_clk;
-		}
-
-		ret = clk_prepare_enable(sdd->ioclk);
-		if (ret) {
-			dev_err(&pdev->dev, "Couldn't enable clock 'ioclk'\n");
-			goto err_disable_src_clk;
+			goto err_deref_master;
 		}
 	}
 
@@ -1277,11 +1259,6 @@ err_pm_put:
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 
-	clk_disable_unprepare(sdd->ioclk);
-err_disable_src_clk:
-	clk_disable_unprepare(sdd->src_clk);
-err_disable_clk:
-	clk_disable_unprepare(sdd->clk);
 err_deref_master:
 	spi_master_put(master);
 
@@ -1302,12 +1279,6 @@ static int s3c64xx_spi_remove(struct pla
 		dma_release_channel(sdd->tx_dma.ch);
 	}
 
-	clk_disable_unprepare(sdd->ioclk);
-
-	clk_disable_unprepare(sdd->src_clk);
-
-	clk_disable_unprepare(sdd->clk);
-
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);


