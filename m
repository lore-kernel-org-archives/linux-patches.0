Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6686E1F953
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FBDC433C8;
	Tue,  1 Aug 2023 09:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882821;
	bh=kQ/bIJaR44bwcMYishJ9+cuWM6LjeLo5rihxWKCT3FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0hLDivuHyHY2Zuf30vPImN0+pq6f46Yd4KRy0fo2yrYGu8F/6oANfdEKVYqs8qYyD
	 FgmsXHMzjTv8wT1d49AMek0hcUDrEnewt/j3EPFBYxQmwPjvwCPQX36pW1VFbUsSQ5
	 BL9g5M/U8EG763HXjGYBp4ENWhA03ZWurYJLnH2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Andy Shevchenko <andy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 015/239] gpio: mvebu: Make use of devm_pwmchip_add
Date: Tue,  1 Aug 2023 11:17:59 +0200
Message-ID: <20230801091926.191210297@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
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
index a68f682aec012..a35958e7adf60 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -874,7 +874,7 @@ static int mvebu_pwm_probe(struct platform_device *pdev,
 
 	spin_lock_init(&mvpwm->lock);
 
-	return pwmchip_add(&mvpwm->chip);
+	return devm_pwmchip_add(dev, &mvpwm->chip);
 }
 
 #ifdef CONFIG_DEBUG_FS
@@ -1243,8 +1243,7 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 	if (!mvchip->domain) {
 		dev_err(&pdev->dev, "couldn't allocate irq domain %s (DT).\n",
 			mvchip->chip.label);
-		err = -ENODEV;
-		goto err_pwm;
+		return -ENODEV;
 	}
 
 	err = irq_alloc_domain_generic_chips(
@@ -1296,9 +1295,6 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 
 err_domain:
 	irq_domain_remove(mvchip->domain);
-err_pwm:
-	pwmchip_remove(&mvchip->mvpwm->chip);
-
 	return err;
 }
 
-- 
2.39.2



