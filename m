Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917461AB53B;
	Thu,  6 Jun 2024 14:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683264; cv=none; b=AhglPopsxoORrAqJzWPTVWsu/hSJnoS+FILi4fjCxI8Pr57t9YlI2vpR1RS+U5BORZc1SEsfLaYlcI9QwOchVj5MkNtVAWI5Lh/fkwP3aklrUdlF4/whjVU6MkaDzP1vyLVexnGYr9rR37xLzegCgqiHHHxMLfuhiQv5RGTU6ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683264; c=relaxed/simple;
	bh=4BhVvEcKo7JB3v3j+lgcTW9WjSmAJg9wNwuKqQ/FlQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b0IhEdqmrMJkctxk07TDTvalt/BLbXhNiLUC3HtQFPUsKXhu2rR+euETpWt/SiDPFA9I9WZQzzjE1VFXEwogOpR31R8JVdh+tX6FQOrie6y7x4z89/n+eGCGCaPs/YuipNJipfxGVRzn0/KhZ5V5P3BL+ql/hZ7JNUFlJAi8VRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1lcSFkkC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1lcSFkkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDC8C32786;
	Thu,  6 Jun 2024 14:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683264;
	bh=4BhVvEcKo7JB3v3j+lgcTW9WjSmAJg9wNwuKqQ/FlQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1lcSFkkCFXOJMs5GxpSIvQlYGS1WWF/u9zIKWk9hFZaAZWUfVz6dgaiGxTm0wZjb4
	 HOWefmeCSDf30gfy2Y83rGlOeWIHGJsk+XGONjqzs5pwN6k4y5SAiWEgiUK6CGV8aL
	 w152PlJDoxl/3KPpuqkOztqAXZG99wQTg1bI9OGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 139/473] pwm: sti: Prepare removing pwm_chip from driver data
Date: Thu,  6 Jun 2024 16:01:08 +0200
Message-ID: <20240606131704.530659393@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

[ Upstream commit 54272761ce7c475fa30a31b59b0cb89f7652b39e ]

This prepares the driver for further changes that will drop struct
pwm_chip chip from struct sti_pwm_chip. Use the pwm_chip as driver data
instead of the sti_pwm_chip to get access to the pwm_chip in
sti_pwm_remove() without using pc->chip.

Link: https://lore.kernel.org/r/56d53372aacff6871df4d6c6779c9dac94592696.1707900770.git.u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Stable-dep-of: 5bb0b194aeee ("pwm: sti: Simplify probe function using devm functions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-sti.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/pwm/pwm-sti.c b/drivers/pwm/pwm-sti.c
index c782378dff5e5..8f7aff51787be 100644
--- a/drivers/pwm/pwm-sti.c
+++ b/drivers/pwm/pwm-sti.c
@@ -571,6 +571,7 @@ static int sti_pwm_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct sti_pwm_compat_data *cdata;
+	struct pwm_chip *chip;
 	struct sti_pwm_chip *pc;
 	unsigned int i;
 	int irq, ret;
@@ -578,6 +579,7 @@ static int sti_pwm_probe(struct platform_device *pdev)
 	pc = devm_kzalloc(dev, sizeof(*pc), GFP_KERNEL);
 	if (!pc)
 		return -ENOMEM;
+	chip = &pc->chip;
 
 	cdata = devm_kzalloc(dev, sizeof(*cdata), GFP_KERNEL);
 	if (!cdata)
@@ -654,9 +656,9 @@ static int sti_pwm_probe(struct platform_device *pdev)
 			return -ENOMEM;
 	}
 
-	pc->chip.dev = dev;
-	pc->chip.ops = &sti_pwm_ops;
-	pc->chip.npwm = max(cdata->pwm_num_devs, cdata->cpt_num_devs);
+	chip->dev = dev;
+	chip->ops = &sti_pwm_ops;
+	chip->npwm = max(cdata->pwm_num_devs, cdata->cpt_num_devs);
 
 	for (i = 0; i < cdata->cpt_num_devs; i++) {
 		struct sti_cpt_ddata *ddata = &cdata->ddata[i];
@@ -665,23 +667,24 @@ static int sti_pwm_probe(struct platform_device *pdev)
 		mutex_init(&ddata->lock);
 	}
 
-	ret = pwmchip_add(&pc->chip);
+	ret = pwmchip_add(chip);
 	if (ret < 0) {
 		clk_unprepare(pc->pwm_clk);
 		clk_unprepare(pc->cpt_clk);
 		return ret;
 	}
 
-	platform_set_drvdata(pdev, pc);
+	platform_set_drvdata(pdev, chip);
 
 	return 0;
 }
 
 static void sti_pwm_remove(struct platform_device *pdev)
 {
-	struct sti_pwm_chip *pc = platform_get_drvdata(pdev);
+	struct pwm_chip *chip = platform_get_drvdata(pdev);
+	struct sti_pwm_chip *pc = to_sti_pwmchip(chip);
 
-	pwmchip_remove(&pc->chip);
+	pwmchip_remove(chip);
 
 	clk_unprepare(pc->pwm_clk);
 	clk_unprepare(pc->cpt_clk);
-- 
2.43.0



