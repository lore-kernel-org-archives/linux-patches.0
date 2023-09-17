Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225D8746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80793C433C7;
	Sun, 17 Sep 2023 20:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694983004;
	bh=ABup56S0kjlT3CPPEAyTtfI2Dr22DNGZUqTfa5vtL5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vPjuV0s9mksWXpbreYUNyHFY7IjjyCBX0/pVicgCumzCp4Wb838qvectAA8Jrw9YY
	 Hh+fZnDflrShn42nTVdc0HP/nOUjfglbF6e+8fc9d15T3EDuy9a4n3SuqpS8voOqVa
	 N3eoW2UXz8H+AhxbcWBQ8uIaVqFf6gH7Q8w1J3K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 414/511] pwm: atmel-tcb: Harmonize resource allocation order
Date: Sun, 17 Sep 2023 21:14:01 +0200
Message-ID: <20230917191123.779402717@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2a06b7dd224c9..4e07d4694bb60 100644
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



