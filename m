Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F603196DA5;
	Thu,  6 Jun 2024 14:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683271; cv=none; b=BJgT1r3Q6UW5IG9ThcOjRfHe6b47onMYc2j0dEAv63SH7c0J0/2NRNWBXFPT862TUNSxCvxX2mR0bClEmEa97bYTNzdeL9+dcuH1t4Kz1qqTKJFmJlYeU53O05s2ruyvLUDMP1FjICTpJR9Wjb7D0yTCsUQtH4Js8TBwnRmOocU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683271; c=relaxed/simple;
	bh=uRRpW8JdGsrkptbxiTeRRP/sKiBxn4G+NA3ieJwMRFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ff5YCXACiJRtmZMHVJKwU9sI5DcahOW5A3CTCImxw/Bb+YlH2dVT37jYs23wjmh2fUTJC4Rne1OHVS0HNFO1Mv5LL+XU+PsQ4KVEGf4sJTNaqZEdnjf6twcS50y+I/rZDdGu1R850zHWOI9kzifoH5upATcIF0ySkj1fSK//9Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dTL8vtR7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dTL8vtR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485D2C2BD10;
	Thu,  6 Jun 2024 14:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683271;
	bh=uRRpW8JdGsrkptbxiTeRRP/sKiBxn4G+NA3ieJwMRFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dTL8vtR7IaKDqZQ9KZne0eWIn+1iGmtHwRMZ9Ek5w7GLAoeWMF6rc8uQtRKrOFJB1
	 WRt3GWQOPMRBQyfK7v6fCq0EqEfCQAXnY8spYt4vnwiuHzSEtPRfMKAqWQz+qC74rK
	 LJZs4mEBN/1bUdaQuiZA39PUQKlGBUbldbESujUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 140/473] pwm: sti: Simplify probe function using devm functions
Date: Thu,  6 Jun 2024 16:01:09 +0200
Message-ID: <20240606131704.568391315@linuxfoundation.org>
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

[ Upstream commit 5bb0b194aeee5d5da6881232f4e9989b35957c25 ]

Instead of of_clk_get_by_name() use devm_clk_get_prepared() which has
several advantages:

 - Combines getting the clock and a call to clk_prepare(). The latter
   can be dropped from sti_pwm_probe() accordingly.
 - Cares for calling clk_put() which is missing in both probe's error
   path and the remove function.
 - Cares for calling clk_unprepare() which can be dropped from the error
   paths and the remove function. (Note that not all error path got this
   right.)

With additionally using devm_pwmchip_add() instead of pwmchip_add() the
remove callback can be dropped completely. With it the last user of
platform_get_drvdata() goes away and so platform_set_drvdata() can be
dropped from the probe function, too.

Fixes: 378fe115d19d ("pwm: sti: Add new driver for ST's PWM IP")
Link: https://lore.kernel.org/r/81f0e1d173652f435afda6719adaed1922fe059a.1710068192.git.u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-sti.c | 39 +++------------------------------------
 1 file changed, 3 insertions(+), 36 deletions(-)

diff --git a/drivers/pwm/pwm-sti.c b/drivers/pwm/pwm-sti.c
index 8f7aff51787be..a0467f0b549c2 100644
--- a/drivers/pwm/pwm-sti.c
+++ b/drivers/pwm/pwm-sti.c
@@ -625,32 +625,20 @@ static int sti_pwm_probe(struct platform_device *pdev)
 		return ret;
 
 	if (cdata->pwm_num_devs) {
-		pc->pwm_clk = of_clk_get_by_name(dev->of_node, "pwm");
+		pc->pwm_clk = devm_clk_get_prepared(dev, "pwm");
 		if (IS_ERR(pc->pwm_clk)) {
 			dev_err(dev, "failed to get PWM clock\n");
 			return PTR_ERR(pc->pwm_clk);
 		}
-
-		ret = clk_prepare(pc->pwm_clk);
-		if (ret) {
-			dev_err(dev, "failed to prepare clock\n");
-			return ret;
-		}
 	}
 
 	if (cdata->cpt_num_devs) {
-		pc->cpt_clk = of_clk_get_by_name(dev->of_node, "capture");
+		pc->cpt_clk = devm_clk_get_prepared(dev, "capture");
 		if (IS_ERR(pc->cpt_clk)) {
 			dev_err(dev, "failed to get PWM capture clock\n");
 			return PTR_ERR(pc->cpt_clk);
 		}
 
-		ret = clk_prepare(pc->cpt_clk);
-		if (ret) {
-			dev_err(dev, "failed to prepare clock\n");
-			return ret;
-		}
-
 		cdata->ddata = devm_kzalloc(dev, cdata->cpt_num_devs * sizeof(*cdata->ddata), GFP_KERNEL);
 		if (!cdata->ddata)
 			return -ENOMEM;
@@ -667,27 +655,7 @@ static int sti_pwm_probe(struct platform_device *pdev)
 		mutex_init(&ddata->lock);
 	}
 
-	ret = pwmchip_add(chip);
-	if (ret < 0) {
-		clk_unprepare(pc->pwm_clk);
-		clk_unprepare(pc->cpt_clk);
-		return ret;
-	}
-
-	platform_set_drvdata(pdev, chip);
-
-	return 0;
-}
-
-static void sti_pwm_remove(struct platform_device *pdev)
-{
-	struct pwm_chip *chip = platform_get_drvdata(pdev);
-	struct sti_pwm_chip *pc = to_sti_pwmchip(chip);
-
-	pwmchip_remove(chip);
-
-	clk_unprepare(pc->pwm_clk);
-	clk_unprepare(pc->cpt_clk);
+	return devm_pwmchip_add(dev, chip);
 }
 
 static const struct of_device_id sti_pwm_of_match[] = {
@@ -702,7 +670,6 @@ static struct platform_driver sti_pwm_driver = {
 		.of_match_table = sti_pwm_of_match,
 	},
 	.probe = sti_pwm_probe,
-	.remove_new = sti_pwm_remove,
 };
 module_platform_driver(sti_pwm_driver);
 
-- 
2.43.0



