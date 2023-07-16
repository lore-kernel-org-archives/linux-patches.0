Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D728F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2AAC433C7;
	Sun, 16 Jul 2023 20:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540408;
	bh=lrSTKECLh5UyieDOYBCmMbD/hbAb3/C1glw8GSIIOGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eNtpFHYqfMV6YDhgtMb9OCV38NfGJqFIO2r9kgbYt1P8z+3WmDt5PFwuP1cChLzeP
	 Kimo4CQopY6oJZroKX6dAHalNX2W0C/4CFcaWwp4Eh/t3/rAsjwYLUj0P9gAiUJ/W3
	 vlQV2L32xPiC/TW+vg3cyJx5qqLYlQ50crBFezaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 353/591] hwrng: st - keep clock enabled while hwrng is registered
Date: Sun, 16 Jul 2023 21:48:12 +0200
Message-ID: <20230716194933.041439875@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Kaiser <martin@kaiser.cx>

[ Upstream commit 501e197a02d4aef157f53ba3a0b9049c3e52fedc ]

The st-rng driver uses devres to register itself with the hwrng core,
the driver will be unregistered from hwrng when its device goes out of
scope. This happens after the driver's remove function is called.

However, st-rng's clock is disabled in the remove function. There's a
short timeframe where st-rng is still registered with the hwrng core
although its clock is disabled. I suppose the clock must be active to
access the hardware and serve requests from the hwrng core.

Switch to devm_clk_get_enabled and let devres disable the clock and
unregister the hwrng. This avoids the race condition.

Fixes: 3e75241be808 ("hwrng: drivers - Use device-managed registration API")
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/st-rng.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/char/hw_random/st-rng.c b/drivers/char/hw_random/st-rng.c
index 15ba1e6fae4d2..6e9dfac9fc9f4 100644
--- a/drivers/char/hw_random/st-rng.c
+++ b/drivers/char/hw_random/st-rng.c
@@ -42,7 +42,6 @@
 
 struct st_rng_data {
 	void __iomem	*base;
-	struct clk	*clk;
 	struct hwrng	ops;
 };
 
@@ -85,26 +84,18 @@ static int st_rng_probe(struct platform_device *pdev)
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
-	clk = devm_clk_get(&pdev->dev, NULL);
+	clk = devm_clk_get_enabled(&pdev->dev, NULL);
 	if (IS_ERR(clk))
 		return PTR_ERR(clk);
 
-	ret = clk_prepare_enable(clk);
-	if (ret)
-		return ret;
-
 	ddata->ops.priv	= (unsigned long)ddata;
 	ddata->ops.read	= st_rng_read;
 	ddata->ops.name	= pdev->name;
 	ddata->base	= base;
-	ddata->clk	= clk;
-
-	dev_set_drvdata(&pdev->dev, ddata);
 
 	ret = devm_hwrng_register(&pdev->dev, &ddata->ops);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to register HW RNG\n");
-		clk_disable_unprepare(clk);
 		return ret;
 	}
 
@@ -113,15 +104,6 @@ static int st_rng_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int st_rng_remove(struct platform_device *pdev)
-{
-	struct st_rng_data *ddata = dev_get_drvdata(&pdev->dev);
-
-	clk_disable_unprepare(ddata->clk);
-
-	return 0;
-}
-
 static const struct of_device_id st_rng_match[] __maybe_unused = {
 	{ .compatible = "st,rng" },
 	{},
@@ -134,7 +116,6 @@ static struct platform_driver st_rng_driver = {
 		.of_match_table = of_match_ptr(st_rng_match),
 	},
 	.probe = st_rng_probe,
-	.remove = st_rng_remove
 };
 
 module_platform_driver(st_rng_driver);
-- 
2.39.2



