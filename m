Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7181330FA4
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0B4C433CB;
	Wed, 20 Sep 2023 12:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212336;
	bh=541C3GukpRPAK88SOLo6wHFFM0RrIiLNw/+fAzzefjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jUZTRud7PB/QCcAmBz4DFU2TQSL4eSIZmQinaRO+CideYriiJ+h+ODyvBXiTZ/pjT
	 CT2KEtXmFALq+iSd3WwpXG/FdHsPEI06IlVaQUm90mVesF7Zc9CRakjqIWNh6lumI4
	 hDOz9/tfuskyhlPhnOIucrEZlTEbJTQCyFafRa20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vladimir Zapolskiy <vz@mleia.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 209/273] pwm: lpc32xx: Remove handling of PWM channels
Date: Wed, 20 Sep 2023 13:30:49 +0200
Message-ID: <20230920112852.934000932@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vz@mleia.com>

[ Upstream commit 4aae44f65827f0213a7361cf9c32cfe06114473f ]

Because LPC32xx PWM controllers have only a single output which is
registered as the only PWM device/channel per controller, it is known in
advance that pwm->hwpwm value is always 0. On basis of this fact
simplify the code by removing operations with pwm->hwpwm, there is no
controls which require channel number as input.

Even though I wasn't aware at the time when I forward ported that patch,
this fixes a null pointer dereference as lpc32xx->chip.pwms is NULL
before devm_pwmchip_add() is called.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Fixes: 3d2813fb17e5 ("pwm: lpc32xx: Don't modify HW state in .probe() after the PWM chip was registered")
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-lpc32xx.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
index ed8e9406b4af2..b5f8b86b328af 100644
--- a/drivers/pwm/pwm-lpc32xx.c
+++ b/drivers/pwm/pwm-lpc32xx.c
@@ -55,10 +55,10 @@ static int lpc32xx_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	if (duty_cycles > 255)
 		duty_cycles = 255;
 
-	val = readl(lpc32xx->base + (pwm->hwpwm << 2));
+	val = readl(lpc32xx->base);
 	val &= ~0xFFFF;
 	val |= (period_cycles << 8) | duty_cycles;
-	writel(val, lpc32xx->base + (pwm->hwpwm << 2));
+	writel(val, lpc32xx->base);
 
 	return 0;
 }
@@ -73,9 +73,9 @@ static int lpc32xx_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 	if (ret)
 		return ret;
 
-	val = readl(lpc32xx->base + (pwm->hwpwm << 2));
+	val = readl(lpc32xx->base);
 	val |= PWM_ENABLE;
-	writel(val, lpc32xx->base + (pwm->hwpwm << 2));
+	writel(val, lpc32xx->base);
 
 	return 0;
 }
@@ -85,9 +85,9 @@ static void lpc32xx_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 	struct lpc32xx_pwm_chip *lpc32xx = to_lpc32xx_pwm_chip(chip);
 	u32 val;
 
-	val = readl(lpc32xx->base + (pwm->hwpwm << 2));
+	val = readl(lpc32xx->base);
 	val &= ~PWM_ENABLE;
-	writel(val, lpc32xx->base + (pwm->hwpwm << 2));
+	writel(val, lpc32xx->base);
 
 	clk_disable_unprepare(lpc32xx->clk);
 }
@@ -125,9 +125,9 @@ static int lpc32xx_pwm_probe(struct platform_device *pdev)
 	lpc32xx->chip.base = -1;
 
 	/* If PWM is disabled, configure the output to the default value */
-	val = readl(lpc32xx->base + (lpc32xx->chip.pwms[0].hwpwm << 2));
+	val = readl(lpc32xx->base);
 	val &= ~PWM_PIN_LEVEL;
-	writel(val, lpc32xx->base + (lpc32xx->chip.pwms[0].hwpwm << 2));
+	writel(val, lpc32xx->base);
 
 	ret = pwmchip_add(&lpc32xx->chip);
 	if (ret < 0) {
-- 
2.40.1



