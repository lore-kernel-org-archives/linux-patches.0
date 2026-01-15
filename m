Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68402C0F83;
	Thu, 15 Jan 2026 17:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499035; cv=none; b=Jv7QqZ8fTLZbT3T2OwxmDtQ2My+BDA6+xCA/ENHvGE1bL7tWz57fqh94gn09emArUXo4jKKwK7FG2WY4INkub/5UJa3gRZfYWWedD98ZCaiFsAPO93PmSIEcB9jkeNwsIf5g+tTQWPDIsYC3e2zwpZbylvLwWcH5J2DsO/ppmyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499035; c=relaxed/simple;
	bh=kA3OqcCzohelUcNYnHo3u/EJ4fqffm5g/a/3BAT8AfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a+rhJIJbKQ2kG9WJmCp/rUVpt463wZdAAdKopd5mSVncKOJBed3DHDpERJr+7Jp+Vm3YpBbYD3562e2FhN3Fo9vD9YlKrDwFDjhyibgDpR5+euqErqXkIiNN33be4T/dD/7n8OoHLH6w6qdEfsphhRjFmidxLmUuBzzQbt46Q60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+Oe1WyM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+Oe1WyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5160AC116D0;
	Thu, 15 Jan 2026 17:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499035;
	bh=kA3OqcCzohelUcNYnHo3u/EJ4fqffm5g/a/3BAT8AfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+Oe1WyM1ElqR7CPAbPpjdaSqUSUuDe6wlTQ3ilfTRULP8maYGExEHE9IYOkFBjU4
	 FbbZESsu5AwaF7iQc1dUMEmFFpqU+isxsWgCvXCocUyLgS+2MauCEFx7u+GnlC/H4w
	 B6PCM8gVJhnLxg7UV/oK6vne22g4Ywz7a6Qx7eOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lino Sanfilippo <LinoSanfilippo@gmx.de>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/451] pwm: bcm2835: Support apply function for atomic configuration
Date: Thu, 15 Jan 2026 17:44:45 +0100
Message-ID: <20260115164233.954934453@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lino Sanfilippo <LinoSanfilippo@gmx.de>

[ Upstream commit 2f81b51d0d02074502ad27424c228ca760823668 ]

Use the newer .apply function of pwm_ops instead of .config, .enable,
.disable and .set_polarity. This guarantees atomic changes of the pwm
controller configuration. It also reduces the size of the driver.

Since now period is a 64 bit value, add an extra check to reject periods
that exceed the possible max value for the 32 bit register.

This has been tested on a Raspberry PI 4.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Stable-dep-of: cda323dbda76 ("pwm: bcm2835: Make sure the channel is enabled after pwm_request()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-bcm2835.c | 69 ++++++++++++++-------------------------
 1 file changed, 24 insertions(+), 45 deletions(-)

diff --git a/drivers/pwm/pwm-bcm2835.c b/drivers/pwm/pwm-bcm2835.c
index 6841dcfe27fc8..aec1a963f46e2 100644
--- a/drivers/pwm/pwm-bcm2835.c
+++ b/drivers/pwm/pwm-bcm2835.c
@@ -58,13 +58,15 @@ static void bcm2835_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
 	writel(value, pc->base + PWM_CONTROL);
 }
 
-static int bcm2835_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
-			      int duty_ns, int period_ns)
+static int bcm2835_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
+			     const struct pwm_state *state)
 {
+
 	struct bcm2835_pwm *pc = to_bcm2835_pwm(chip);
 	unsigned long rate = clk_get_rate(pc->clk);
+	unsigned long long period;
 	unsigned long scaler;
-	u32 period;
+	u32 val;
 
 	if (!rate) {
 		dev_err(pc->dev, "failed to get clock rate\n");
@@ -72,54 +74,34 @@ static int bcm2835_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	}
 
 	scaler = DIV_ROUND_CLOSEST(NSEC_PER_SEC, rate);
-	period = DIV_ROUND_CLOSEST(period_ns, scaler);
+	/* set period */
+	period = DIV_ROUND_CLOSEST_ULL(state->period, scaler);
 
-	if (period < PERIOD_MIN)
+	/* dont accept a period that is too small or has been truncated */
+	if ((period < PERIOD_MIN) || (period > U32_MAX))
 		return -EINVAL;
 
-	writel(DIV_ROUND_CLOSEST(duty_ns, scaler),
-	       pc->base + DUTY(pwm->hwpwm));
 	writel(period, pc->base + PERIOD(pwm->hwpwm));
 
-	return 0;
-}
-
-static int bcm2835_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
-{
-	struct bcm2835_pwm *pc = to_bcm2835_pwm(chip);
-	u32 value;
-
-	value = readl(pc->base + PWM_CONTROL);
-	value |= PWM_ENABLE << PWM_CONTROL_SHIFT(pwm->hwpwm);
-	writel(value, pc->base + PWM_CONTROL);
+	/* set duty cycle */
+	val = DIV_ROUND_CLOSEST_ULL(state->duty_cycle, scaler);
+	writel(val, pc->base + DUTY(pwm->hwpwm));
 
-	return 0;
-}
+	/* set polarity */
+	val = readl(pc->base + PWM_CONTROL);
 
-static void bcm2835_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
-{
-	struct bcm2835_pwm *pc = to_bcm2835_pwm(chip);
-	u32 value;
-
-	value = readl(pc->base + PWM_CONTROL);
-	value &= ~(PWM_ENABLE << PWM_CONTROL_SHIFT(pwm->hwpwm));
-	writel(value, pc->base + PWM_CONTROL);
-}
-
-static int bcm2835_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
-				enum pwm_polarity polarity)
-{
-	struct bcm2835_pwm *pc = to_bcm2835_pwm(chip);
-	u32 value;
-
-	value = readl(pc->base + PWM_CONTROL);
+	if (state->polarity == PWM_POLARITY_NORMAL)
+		val &= ~(PWM_POLARITY << PWM_CONTROL_SHIFT(pwm->hwpwm));
+	else
+		val |= PWM_POLARITY << PWM_CONTROL_SHIFT(pwm->hwpwm);
 
-	if (polarity == PWM_POLARITY_NORMAL)
-		value &= ~(PWM_POLARITY << PWM_CONTROL_SHIFT(pwm->hwpwm));
+	/* enable/disable */
+	if (state->enabled)
+		val |= PWM_ENABLE << PWM_CONTROL_SHIFT(pwm->hwpwm);
 	else
-		value |= PWM_POLARITY << PWM_CONTROL_SHIFT(pwm->hwpwm);
+		val &= ~(PWM_ENABLE << PWM_CONTROL_SHIFT(pwm->hwpwm));
 
-	writel(value, pc->base + PWM_CONTROL);
+	writel(val, pc->base + PWM_CONTROL);
 
 	return 0;
 }
@@ -127,10 +109,7 @@ static int bcm2835_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
 static const struct pwm_ops bcm2835_pwm_ops = {
 	.request = bcm2835_pwm_request,
 	.free = bcm2835_pwm_free,
-	.config = bcm2835_pwm_config,
-	.enable = bcm2835_pwm_enable,
-	.disable = bcm2835_pwm_disable,
-	.set_polarity = bcm2835_set_polarity,
+	.apply = bcm2835_pwm_apply,
 	.owner = THIS_MODULE,
 };
 
-- 
2.51.0



