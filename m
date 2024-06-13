Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3184F387;
	Thu, 13 Jun 2024 12:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281977; cv=none; b=SCVCfVdMlOi7iqOIP+K9EjD3jtkRBFQ6BVTYsbNL67xZ0lRUGHB/Uw/XG2lJppfE0A7QAnJnC3KwL6+pSZmcMD1/l9ByCR6Sq4DFT48ojLdTgWZZSBHu72Dt4+K56o7RG8kx90lWI+d7EAoYg/TmMaAEIjSROIO2hhyIclzATrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281977; c=relaxed/simple;
	bh=w8XshnDwfWZ8DcdtuHH3kuDTzYbmeOwNpf6+sQRMGCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d6x4Zof0RB+bHhjzRaLM1mabp1fqnAxEDgPkIM9vSyYzVR54FF0PMyA/lVoo5BJ0xJp8x397rtUL5kpQUzaG3Ij0SndRHgrDq0WCXgqaC0qwWx97MEGuIPwD0hxKoVPRqWN/gVqLVfZrGK7S/yrkzmOVONF9JefKBSY2Uyvf+bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=txrsPYkb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txrsPYkb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5451C2BBFC;
	Thu, 13 Jun 2024 12:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281977;
	bh=w8XshnDwfWZ8DcdtuHH3kuDTzYbmeOwNpf6+sQRMGCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txrsPYkbgQCP4qSao/VTMdwdBD41P3v6GQzXFQfzTLoHUc9r6cGVJyO0m7GpN0H/z
	 QjmRLbks7Nk8/3oM+3sPLC6PGxCpeFcBu2hah6zUkNT2I3km4wdrjKjWtIDziwYJq/
	 fINNYgxQpq7qSrG3kuG4EJzC1s06k9hcJz+6BXDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/402] pwm: sti: Prepare removing pwm_chip from driver data
Date: Thu, 13 Jun 2024 13:30:47 +0200
Message-ID: <20240613113305.649975259@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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



