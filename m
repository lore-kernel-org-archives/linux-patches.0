Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335D46FCC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5F8C433C7;
	Sun, 17 Sep 2023 20:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981053;
	bh=GA9eCTvDrSp0YisS72swTMB7xdlYOzHDEP9IW659Vus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3ok3zPW99GPcW/7PEiRVQD3ccHmGSFG81Zrnkh2vgpm7Q1JQpCVaBy6gFufF45sa
	 iF9XTIMmL+PuVP6aVrqrUEZHLToGTBF0b8OMndLnpLCxkKFrpDQMSZ36ichUzOBDu4
	 sKmXZATwUr4Wfw+HDzgZWDESu6w7m0Ac4n5MpAVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/219] pwm: atmel-tcb: Harmonize resource allocation order
Date: Sun, 17 Sep 2023 21:13:14 +0200
Message-ID: <20230917191043.416875316@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 0323e8fedd1ef25342cf7abf3a2024f5670362b8 ]

Allocate driver data as first resource in the probe function. This way it
can be used during allocation of the other resources (instead of assigning
these to local variables first and update driver data only when it's
allocated). Also as driver data is allocated using a devm function this
should happen first to have the order of freeing resources in the error
path and the remove function in reverse.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Stable-dep-of: c11622324c02 ("pwm: atmel-tcb: Fix resource freeing in error path and remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-atmel-tcb.c | 49 +++++++++++++++----------------------
 1 file changed, 20 insertions(+), 29 deletions(-)

diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
index 4a116dc44f6e7..613dd1810fb53 100644
--- a/drivers/pwm/pwm-atmel-tcb.c
+++ b/drivers/pwm/pwm-atmel-tcb.c
@@ -422,13 +422,14 @@ static int atmel_tcb_pwm_probe(struct platform_device *pdev)
 	struct atmel_tcb_pwm_chip *tcbpwm;
 	const struct atmel_tcb_config *config;
 	struct device_node *np = pdev->dev.of_node;
-	struct regmap *regmap;
-	struct clk *clk, *gclk = NULL;
-	struct clk *slow_clk;
 	char clk_name[] = "t0_clk";
 	int err;
 	int channel;
 
+	tcbpwm = devm_kzalloc(&pdev->dev, sizeof(*tcbpwm), GFP_KERNEL);
+	if (tcbpwm == NULL)
+		return -ENOMEM;
+
 	err = of_property_read_u32(np, "reg", &channel);
 	if (err < 0) {
 		dev_err(&pdev->dev,
@@ -437,47 +438,37 @@ static int atmel_tcb_pwm_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	regmap = syscon_node_to_regmap(np->parent);
-	if (IS_ERR(regmap))
-		return PTR_ERR(regmap);
+	tcbpwm->regmap = syscon_node_to_regmap(np->parent);
+	if (IS_ERR(tcbpwm->regmap))
+		return PTR_ERR(tcbpwm->regmap);
 
-	slow_clk = of_clk_get_by_name(np->parent, "slow_clk");
-	if (IS_ERR(slow_clk))
-		return PTR_ERR(slow_clk);
+	tcbpwm->slow_clk = of_clk_get_by_name(np->parent, "slow_clk");
+	if (IS_ERR(tcbpwm->slow_clk))
+		return PTR_ERR(tcbpwm->slow_clk);
 
 	clk_name[1] += channel;
-	clk = of_clk_get_by_name(np->parent, clk_name);
-	if (IS_ERR(clk))
-		clk = of_clk_get_by_name(np->parent, "t0_clk");
-	if (IS_ERR(clk))
-		return PTR_ERR(clk);
+	tcbpwm->clk = of_clk_get_by_name(np->parent, clk_name);
+	if (IS_ERR(tcbpwm->clk))
+		tcbpwm->clk = of_clk_get_by_name(np->parent, "t0_clk");
+	if (IS_ERR(tcbpwm->clk))
+		return PTR_ERR(tcbpwm->clk);
 
 	match = of_match_node(atmel_tcb_of_match, np->parent);
 	config = match->data;
 
 	if (config->has_gclk) {
-		gclk = of_clk_get_by_name(np->parent, "gclk");
-		if (IS_ERR(gclk))
-			return PTR_ERR(gclk);
-	}
-
-	tcbpwm = devm_kzalloc(&pdev->dev, sizeof(*tcbpwm), GFP_KERNEL);
-	if (tcbpwm == NULL) {
-		err = -ENOMEM;
-		goto err_slow_clk;
+		tcbpwm->gclk = of_clk_get_by_name(np->parent, "gclk");
+		if (IS_ERR(tcbpwm->gclk))
+			return PTR_ERR(tcbpwm->gclk);
 	}
 
 	tcbpwm->chip.dev = &pdev->dev;
 	tcbpwm->chip.ops = &atmel_tcb_pwm_ops;
 	tcbpwm->chip.npwm = NPWM;
 	tcbpwm->channel = channel;
-	tcbpwm->regmap = regmap;
-	tcbpwm->clk = clk;
-	tcbpwm->gclk = gclk;
-	tcbpwm->slow_clk = slow_clk;
 	tcbpwm->width = config->counter_width;
 
-	err = clk_prepare_enable(slow_clk);
+	err = clk_prepare_enable(tcbpwm->slow_clk);
 	if (err)
 		goto err_slow_clk;
 
@@ -495,7 +486,7 @@ static int atmel_tcb_pwm_probe(struct platform_device *pdev)
 	clk_disable_unprepare(tcbpwm->slow_clk);
 
 err_slow_clk:
-	clk_put(slow_clk);
+	clk_put(tcbpwm->slow_clk);
 
 	return err;
 }
-- 
2.40.1



