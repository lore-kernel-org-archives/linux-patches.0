Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927D01BE22C;
	Tue,  2 Jul 2024 17:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719939990; cv=none; b=KPKHUu/WHJA/91vCyIcqEKYoPPooK9frVUwWNCcMVHmua02mA+Ho0F/gs5iI5KURIZgKqvlX0Bgw8D3jA55KboWXgw/GQF/I3OXetD/zSk7SFkWZL5p3OSlvfaW6rhHJ2q995m8Yfm6/7FULVCM9+g5YidIcHVpgTUkQQh0XY7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719939990; c=relaxed/simple;
	bh=DGqCP8FevJMts5EvU7An+AgkrYtRiY1Uh8UHdomLZi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rd38Is6A35wbhFxfBhZvZemQBW42CpK3ObDqhFczW5D2m/NSMKZ+BKwNjnA7hDDajUhCnGSIgc2Y5Ss/HwXRMH/Czg37ySJl6IL+lU/ejpwLy+K7Bl2LkExkpolcnCyBUSqj9aBxKK/3+n91gsC4PlyczmnC64+PJVt6xdhZr0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3NEv1ot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3NEv1ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E0FC116B1;
	Tue,  2 Jul 2024 17:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719939990;
	bh=DGqCP8FevJMts5EvU7An+AgkrYtRiY1Uh8UHdomLZi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3NEv1otcyNWTTb110eOJAudCkBiZMZUZRE5LHNRlOaVHaEoLN2f043V3Fg6G5Mv4
	 WfaINQAkBK6LMv1iNgPm9wQSLgxlcJs4jTXrN8Tu+il3+Um9S+TR9WHPgjir49DyDT
	 bvLH/3f+QQR/kBsG8OKI5XItakDdLjWXiZgVxlIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 012/222] pwm: stm32: Fix for settings using period > UINT32_MAX
Date: Tue,  2 Jul 2024 19:00:50 +0200
Message-ID: <20240702170244.442979853@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit d44d635635a7192c773a75e674a8590a163e879e ]

stm32_pwm_config() took the duty_cycle and period values with the type
int, however stm32_pwm_apply() passed u64 values there. Expand the
function parameters to u64 to not discard relevant bits and adapt the
calculations to the wider type.

To ensure the calculations won't overflow, check in .probe() the input
clk doesn't run faster than 1 GHz.

Link: https://lore.kernel.org/r/06b4a650a608d0887d934c1b2b8919e0f78e4db2.1710711976.git.u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Stable-dep-of: c45fcf46ca23 ("pwm: stm32: Refuse too small period requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-stm32.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/pwm/pwm-stm32.c b/drivers/pwm/pwm-stm32.c
index d50194ad24b1c..27fcc90504f67 100644
--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -309,16 +309,18 @@ static int stm32_pwm_capture(struct pwm_chip *chip, struct pwm_device *pwm,
 }
 
 static int stm32_pwm_config(struct stm32_pwm *priv, unsigned int ch,
-			    int duty_ns, int period_ns)
+			    u64 duty_ns, u64 period_ns)
 {
 	unsigned long long prd, div, dty;
 	unsigned int prescaler = 0;
 	u32 ccmr, mask, shift;
 
-	/* Period and prescaler values depends on clock rate */
-	div = (unsigned long long)clk_get_rate(priv->clk) * period_ns;
-
-	do_div(div, NSEC_PER_SEC);
+	/*
+	 * .probe() asserted that clk_get_rate() is not bigger than 1 GHz, so
+	 * this won't overflow.
+	 */
+	div = mul_u64_u64_div_u64(period_ns, clk_get_rate(priv->clk),
+				  NSEC_PER_SEC);
 	prd = div;
 
 	while (div > priv->max_arr) {
@@ -351,9 +353,8 @@ static int stm32_pwm_config(struct stm32_pwm *priv, unsigned int ch,
 	regmap_set_bits(priv->regmap, TIM_CR1, TIM_CR1_ARPE);
 
 	/* Calculate the duty cycles */
-	dty = (unsigned long long)clk_get_rate(priv->clk) * duty_ns;
-	do_div(dty, prescaler + 1);
-	do_div(dty, NSEC_PER_SEC);
+	dty = mul_u64_u64_div_u64(duty_ns, clk_get_rate(priv->clk),
+				  (u64)NSEC_PER_SEC * (prescaler + 1));
 
 	regmap_write(priv->regmap, TIM_CCR1 + 4 * ch, dty);
 
@@ -657,6 +658,17 @@ static int stm32_pwm_probe(struct platform_device *pdev)
 
 	stm32_pwm_detect_complementary(priv);
 
+	ret = devm_clk_rate_exclusive_get(dev, priv->clk);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to lock clock\n");
+
+	/*
+	 * With the clk running with not more than 1 GHz the calculations in
+	 * .apply() won't overflow.
+	 */
+	if (clk_get_rate(priv->clk) > 1000000000)
+		return dev_err_probe(dev, -EINVAL, "Failed to lock clock\n");
+
 	chip->ops = &stm32pwm_ops;
 
 	/* Initialize clock refcount to number of enabled PWM channels. */
-- 
2.43.0



