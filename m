Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39753262BE;
	Mon, 27 May 2024 19:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838052; cv=none; b=SoiAYJTjlujiAiRX0Q9Tl6Oj7CG1xgXypHTPEZ2Bd15Z+jSnk7AEmt8totWMTpr85FCNip4OIVEwTlXhA5Fn6lyLe92guKuDLHv+R/GPuQ/jc6rYDCZgN7ZLSB74sTpATuQTt6oo0DuLPNG896+xhPNZG6KHHsO+nVVoxqjcN7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838052; c=relaxed/simple;
	bh=Dfk/kBjznLIp1A5fVIyU0PdObY1eJ/R3LIkDFHT2qCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XKFc7h8l9FLGTqBRfhYYAX9rukA4P6lQAkX6LXnimKKRthYgWVIxCDQyV2HCiaAH8RtguM2x/zcOVwWrmRrjHGG8wZLc4O6He1hRwnz5jEPSQT4YtEgx8GClruoSE78STBovSMXNbfmDJwNF3mZ9E1IpZh9IS19SeCJmWUvCrCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NhKkaGOr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NhKkaGOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C710CC2BBFC;
	Mon, 27 May 2024 19:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838052;
	bh=Dfk/kBjznLIp1A5fVIyU0PdObY1eJ/R3LIkDFHT2qCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NhKkaGOrFQ9SMQuq2M4z13dzbyXj7SG3p98z137FdXhlK1OYIt44pbKx44MF33EWD
	 Z+SkmkHpdOQ+gAucPSZ6wF/cMikExFgXXGsHNL9Gc5mxY1HGSOnm58QC5hZHOBQ/dQ
	 Ifz8j6saVA38EkYSf360rTUsQEgdJ/tAqd8tYhlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 247/493] pwm: sti: Simplify probe function using devm functions
Date: Mon, 27 May 2024 20:54:09 +0200
Message-ID: <20240527185638.385295035@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 826eb547cc96f..f3df7b1895d35 100644
--- a/drivers/pwm/pwm-sti.c
+++ b/drivers/pwm/pwm-sti.c
@@ -624,32 +624,20 @@ static int sti_pwm_probe(struct platform_device *pdev)
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
@@ -666,27 +654,7 @@ static int sti_pwm_probe(struct platform_device *pdev)
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
@@ -701,7 +669,6 @@ static struct platform_driver sti_pwm_driver = {
 		.of_match_table = sti_pwm_of_match,
 	},
 	.probe = sti_pwm_probe,
-	.remove_new = sti_pwm_remove,
 };
 module_platform_driver(sti_pwm_driver);
 
-- 
2.43.0



