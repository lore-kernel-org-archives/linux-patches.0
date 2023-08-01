Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C72E1F95A
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21CEC433C8;
	Tue,  1 Aug 2023 09:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690881754;
	bh=UDW1hqmp94pWpO+buYKzdpE+iBmujjM+l2GHDJV8IDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RkrEMC9TAoOgySSdN21eiy3BXYmzi0RmRiXCzp3gV78JV4BxH+fnVBK2dbp+h2u/e
	 HccOgyL/b7cHM2W6ebfdNIjWEkD+U9s05thQNf1YwdRdbWwZ2MLv8/wYQSKeCV+CO1
	 LoL6/cYQYEfH6FP6vBAvN5/lgItjklbX0diwDQqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Andy Shevchenko <andy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/155] gpio: mvebu: Make use of devm_pwmchip_add
Date: Tue,  1 Aug 2023 11:18:37 +0200
Message-ID: <20230801091910.360226662@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 1945063eb59e64d2919cb14d54d081476d9e53bb ]

This allows to get rid of a call to pwmchip_remove() in the error path. There
is no .remove function for this driver, so this change fixes a resource leak
when a gpio-mvebu device is unbound.

Fixes: 757642f9a584 ("gpio: mvebu: Add limited PWM support")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mvebu.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index a245bfd5a6173..4d64b3358c50c 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -874,7 +874,7 @@ static int mvebu_pwm_probe(struct platform_device *pdev,
 
 	spin_lock_init(&mvpwm->lock);
 
-	return pwmchip_add(&mvpwm->chip);
+	return devm_pwmchip_add(dev, &mvpwm->chip);
 }
 
 #ifdef CONFIG_DEBUG_FS
@@ -1244,8 +1244,7 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 	if (!mvchip->domain) {
 		dev_err(&pdev->dev, "couldn't allocate irq domain %s (DT).\n",
 			mvchip->chip.label);
-		err = -ENODEV;
-		goto err_pwm;
+		return -ENODEV;
 	}
 
 	err = irq_alloc_domain_generic_chips(
@@ -1297,9 +1296,6 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 
 err_domain:
 	irq_domain_remove(mvchip->domain);
-err_pwm:
-	pwmchip_remove(&mvchip->mvpwm->chip);
-
 	return err;
 }
 
-- 
2.39.2



