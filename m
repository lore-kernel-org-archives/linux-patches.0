Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7BD1772F
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDE8C4339B;
	Mon, 15 May 2023 18:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173720;
	bh=zbv5u0E7fTINTdTIpq8QOJIuOePMyYIPIZS1552Wfak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fe2IbAp2P8wXNbyXQjA5bBc06ZjiJFwHK5Ml3dFWizDDKQNoKMnGGd6wB/R73HlZu
	 NjBqNknnCz0UR1CDPWSdLiCiXQApKE5Cz9Xsafz6fnTym98HPPWBV+JgUyIJJFONkI
	 FZgf/ML77AHxVUbTQIojJq5qWKN3uxyIDUvPKP1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jitao Shi <jitao.shi@mediatek.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 185/282] pwm: mtk-disp: Adjust the clocks to avoid them mismatch
Date: Mon, 15 May 2023 18:29:23 +0200
Message-Id: <20230515161727.818392415@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jitao Shi <jitao.shi@mediatek.com>

[ Upstream commit d7a4e582587d97a586b1f7709e3bddcf35928e96 ]

The clks "main" and "mm" are prepared in .probe() (and unprepared in
.remove()). This results in the clocks being on during suspend which
results in unnecessarily increased power consumption.

Remove the clock operations from .probe() and .remove(). Add the
clk_prepare_enable() in .enable() and the clk_disable_unprepare() in
.disable().

Signed-off-by: Jitao Shi <jitao.shi@mediatek.com>
[thierry.reding@gmail.com: squashed in fixup patch]
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Stable-dep-of: 36dd7f530ae7 ("pwm: mtk-disp: Disable shadow registers before setting backlight values")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-mtk-disp.c | 91 +++++++++++++++++---------------------
 1 file changed, 41 insertions(+), 50 deletions(-)

diff --git a/drivers/pwm/pwm-mtk-disp.c b/drivers/pwm/pwm-mtk-disp.c
index af63aaab8e153..a594a0fdddd7b 100644
--- a/drivers/pwm/pwm-mtk-disp.c
+++ b/drivers/pwm/pwm-mtk-disp.c
@@ -74,6 +74,19 @@ static int mtk_disp_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	u64 div, rate;
 	int err;
 
+	err = clk_prepare_enable(mdp->clk_main);
+	if (err < 0) {
+		dev_err(chip->dev, "Can't enable mdp->clk_main: %pe\n", ERR_PTR(err));
+		return err;
+	}
+
+	err = clk_prepare_enable(mdp->clk_mm);
+	if (err < 0) {
+		dev_err(chip->dev, "Can't enable mdp->clk_mm: %pe\n", ERR_PTR(err));
+		clk_disable_unprepare(mdp->clk_main);
+		return err;
+	}
+
 	/*
 	 * Find period, high_width and clk_div to suit duty_ns and period_ns.
 	 * Calculate proper div value to keep period value in the bound.
@@ -87,8 +100,11 @@ static int mtk_disp_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	rate = clk_get_rate(mdp->clk_main);
 	clk_div = div_u64(rate * period_ns, NSEC_PER_SEC) >>
 			  PWM_PERIOD_BIT_WIDTH;
-	if (clk_div > PWM_CLKDIV_MAX)
+	if (clk_div > PWM_CLKDIV_MAX) {
+		clk_disable_unprepare(mdp->clk_mm);
+		clk_disable_unprepare(mdp->clk_main);
 		return -EINVAL;
+	}
 
 	div = NSEC_PER_SEC * (clk_div + 1);
 	period = div64_u64(rate * period_ns, div);
@@ -98,16 +114,6 @@ static int mtk_disp_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	high_width = div64_u64(rate * duty_ns, div);
 	value = period | (high_width << PWM_HIGH_WIDTH_SHIFT);
 
-	err = clk_enable(mdp->clk_main);
-	if (err < 0)
-		return err;
-
-	err = clk_enable(mdp->clk_mm);
-	if (err < 0) {
-		clk_disable(mdp->clk_main);
-		return err;
-	}
-
 	mtk_disp_pwm_update_bits(mdp, mdp->data->con0,
 				 PWM_CLKDIV_MASK,
 				 clk_div << PWM_CLKDIV_SHIFT);
@@ -122,10 +128,21 @@ static int mtk_disp_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 		mtk_disp_pwm_update_bits(mdp, mdp->data->commit,
 					 mdp->data->commit_mask,
 					 0x0);
+	} else {
+		/*
+		 * For MT2701, disable double buffer before writing register
+		 * and select manual mode and use PWM_PERIOD/PWM_HIGH_WIDTH.
+		 */
+		mtk_disp_pwm_update_bits(mdp, mdp->data->bls_debug,
+					 mdp->data->bls_debug_mask,
+					 mdp->data->bls_debug_mask);
+		mtk_disp_pwm_update_bits(mdp, mdp->data->con0,
+					 mdp->data->con0_sel,
+					 mdp->data->con0_sel);
 	}
 
-	clk_disable(mdp->clk_mm);
-	clk_disable(mdp->clk_main);
+	clk_disable_unprepare(mdp->clk_mm);
+	clk_disable_unprepare(mdp->clk_main);
 
 	return 0;
 }
@@ -135,13 +152,16 @@ static int mtk_disp_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 	struct mtk_disp_pwm *mdp = to_mtk_disp_pwm(chip);
 	int err;
 
-	err = clk_enable(mdp->clk_main);
-	if (err < 0)
+	err = clk_prepare_enable(mdp->clk_main);
+	if (err < 0) {
+		dev_err(chip->dev, "Can't enable mdp->clk_main: %pe\n", ERR_PTR(err));
 		return err;
+	}
 
-	err = clk_enable(mdp->clk_mm);
+	err = clk_prepare_enable(mdp->clk_mm);
 	if (err < 0) {
-		clk_disable(mdp->clk_main);
+		dev_err(chip->dev, "Can't enable mdp->clk_mm: %pe\n", ERR_PTR(err));
+		clk_disable_unprepare(mdp->clk_main);
 		return err;
 	}
 
@@ -158,8 +178,8 @@ static void mtk_disp_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 	mtk_disp_pwm_update_bits(mdp, DISP_PWM_EN, mdp->data->enable_mask,
 				 0x0);
 
-	clk_disable(mdp->clk_mm);
-	clk_disable(mdp->clk_main);
+	clk_disable_unprepare(mdp->clk_mm);
+	clk_disable_unprepare(mdp->clk_main);
 }
 
 static const struct pwm_ops mtk_disp_pwm_ops = {
@@ -194,14 +214,6 @@ static int mtk_disp_pwm_probe(struct platform_device *pdev)
 	if (IS_ERR(mdp->clk_mm))
 		return PTR_ERR(mdp->clk_mm);
 
-	ret = clk_prepare(mdp->clk_main);
-	if (ret < 0)
-		return ret;
-
-	ret = clk_prepare(mdp->clk_mm);
-	if (ret < 0)
-		goto disable_clk_main;
-
 	mdp->chip.dev = &pdev->dev;
 	mdp->chip.ops = &mtk_disp_pwm_ops;
 	mdp->chip.base = -1;
@@ -209,32 +221,13 @@ static int mtk_disp_pwm_probe(struct platform_device *pdev)
 
 	ret = pwmchip_add(&mdp->chip);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
-		goto disable_clk_mm;
+		dev_err(&pdev->dev, "pwmchip_add() failed: %pe\n", ERR_PTR(ret));
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, mdp);
 
-	/*
-	 * For MT2701, disable double buffer before writing register
-	 * and select manual mode and use PWM_PERIOD/PWM_HIGH_WIDTH.
-	 */
-	if (!mdp->data->has_commit) {
-		mtk_disp_pwm_update_bits(mdp, mdp->data->bls_debug,
-					 mdp->data->bls_debug_mask,
-					 mdp->data->bls_debug_mask);
-		mtk_disp_pwm_update_bits(mdp, mdp->data->con0,
-					 mdp->data->con0_sel,
-					 mdp->data->con0_sel);
-	}
-
 	return 0;
-
-disable_clk_mm:
-	clk_unprepare(mdp->clk_mm);
-disable_clk_main:
-	clk_unprepare(mdp->clk_main);
-	return ret;
 }
 
 static int mtk_disp_pwm_remove(struct platform_device *pdev)
@@ -242,8 +235,6 @@ static int mtk_disp_pwm_remove(struct platform_device *pdev)
 	struct mtk_disp_pwm *mdp = platform_get_drvdata(pdev);
 
 	pwmchip_remove(&mdp->chip);
-	clk_unprepare(mdp->clk_mm);
-	clk_unprepare(mdp->clk_main);
 
 	return 0;
 }
-- 
2.39.2



