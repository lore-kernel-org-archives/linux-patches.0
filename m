Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1BB8472
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B107C433C9;
	Mon, 11 Sep 2023 14:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442880;
	bh=5YCjcl9HFmQMyHDUYAT2R2RTAbn1H8w1pPqll9GKypY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lj4ys45iZGge44KJ8AKqS7BO39VlMRNB0B61J7l6RRnSfOETw8ruhysCDAF1bIUQH
	 SDt60SpGqsTFAC2dNvbH/vv1UYQwOJ2OxPdqX7xbJdVPf1hRylk50RDP+mA2wj9htY
	 W8NID/DQdUu+9WzccFiFNy/2Zh+7C0Z1mQFzwnaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 153/737] hwrng: pic32 - use devm_clk_get_enabled
Date: Mon, 11 Sep 2023 15:40:12 +0200
Message-ID: <20230911134654.759425455@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Kaiser <martin@kaiser.cx>

[ Upstream commit 6755ad74aac0fb1c79b14724feb81b2f6ff25847 ]

Use devm_clk_get_enabled in the pic32 driver. Ensure that the clock is
enabled as long as the driver is registered with the hwrng core.

Fixes: 7ea39973d1e5 ("hwrng: pic32 - Use device-managed registration API")
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/pic32-rng.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/char/hw_random/pic32-rng.c b/drivers/char/hw_random/pic32-rng.c
index 99c8bd0859a14..e04a054e89307 100644
--- a/drivers/char/hw_random/pic32-rng.c
+++ b/drivers/char/hw_random/pic32-rng.c
@@ -36,7 +36,6 @@
 struct pic32_rng {
 	void __iomem	*base;
 	struct hwrng	rng;
-	struct clk	*clk;
 };
 
 /*
@@ -70,6 +69,7 @@ static int pic32_rng_read(struct hwrng *rng, void *buf, size_t max,
 static int pic32_rng_probe(struct platform_device *pdev)
 {
 	struct pic32_rng *priv;
+	struct clk *clk;
 	u32 v;
 	int ret;
 
@@ -81,13 +81,9 @@ static int pic32_rng_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->base))
 		return PTR_ERR(priv->base);
 
-	priv->clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(priv->clk))
-		return PTR_ERR(priv->clk);
-
-	ret = clk_prepare_enable(priv->clk);
-	if (ret)
-		return ret;
+	clk = devm_clk_get_enabled(&pdev->dev, NULL);
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
 
 	/* enable TRNG in enhanced mode */
 	v = TRNGEN | TRNGMOD;
@@ -98,15 +94,11 @@ static int pic32_rng_probe(struct platform_device *pdev)
 
 	ret = devm_hwrng_register(&pdev->dev, &priv->rng);
 	if (ret)
-		goto err_register;
+		return ret;
 
 	platform_set_drvdata(pdev, priv);
 
 	return 0;
-
-err_register:
-	clk_disable_unprepare(priv->clk);
-	return ret;
 }
 
 static int pic32_rng_remove(struct platform_device *pdev)
@@ -114,7 +106,6 @@ static int pic32_rng_remove(struct platform_device *pdev)
 	struct pic32_rng *rng = platform_get_drvdata(pdev);
 
 	writel(0, rng->base + RNGCON);
-	clk_disable_unprepare(rng->clk);
 	return 0;
 }
 
-- 
2.40.1



