Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A303A9DA5;
	Sat, 17 Oct 2026 16:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255007; cv=none; b=budUIuERLfWkKWxJrF3wYwisqTbJwGhkEUamHFpezHDM6pcCi9DbE51Luy9sbQtjNR0aNMA/slWt9vHaYthY4M4Bv0y0XMOPBMy+452PrK8wOxC3oZ9Y8ZkvHQaCB2cKnpkAEnxpN2Vudl1TW867caAbl96ErOiodLL+1lbFXZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255007; c=relaxed/simple;
	bh=gw8gZd1gECW1VYzh0qvXYrZ+qrn1NvTcvgFlZnVtx6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RQqk27qhqzzoLBUUcUf1HXkx6uJhF8URwQCcT73nHbFTM97na+vXI3qDJoU6Umymd0MRN6tqkPIKMtKY5r0hu7vJ0jzK2mQ2FwZuTEue1Gvp/TgS98PHK9cYYG8f4QDyLsnRJ6AC16eWUnOLmV9wHLxgbIDPqLP01aRIqa46X20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJxPavta; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJxPavta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04901F000C4;
	Sat, 17 Oct 2026 16:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255006;
	bh=JUzl6UQBbfp4/re+5QQfPyOX0w+MswxZCMd9xp5O7ZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aJxPavtatXuy2D6TjsZEZRRkzECeTNQ0/6x6YTq+dEMxQIDA/hKcHghYeW/IIjLV8
	 z3PyPE5o9hHzskjgy5bVrbpbpq99LmM+JhNy1xWAchluYGQyTBDc7Wk8W2i3TPhWyQ
	 Racv7Ta160vCzm2hYmV0n19SwZPFgmVR1JlEAl8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 633/869] clocksource/drivers/samsung_pwm: Switch to raw_spinlock_t type
Date: Sat, 17 Oct 2026 17:57:54 +0200
Message-ID: <20261017160053.256363491@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 3b212f9d70805d91febae01d618868f4860e267c ]

Samsung PWM timer might be used as a clock source on some legacy systems.
When PREEMPT_RT is enabled on ARM, regular spinlock is converted to a
sleeping lock (mutex-based), which must not be used in atomic context
such as hard interrupt handlers. Switch the samsung_pwm_lock to the
raw_spinlock, which remains a true non-sleeping spinlock even
under PREEMPT_RT.

Fixes: 7aac482e6290 ("clocksource: samsung_pwm_timer: Make PWM spinlock global")
Fixes: f11899894c0a ("clocksource: add samsung pwm timer driver")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Uwe Kleine-König <ukleinek@kernel.org>
Link: https://patch.msgid.link/20260713085653.1145015-1-m.szyprowski@samsung.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/samsung_pwm_timer.c | 22 +++++++++++-----------
 drivers/pwm/pwm-samsung.c               | 22 +++++++++++-----------
 include/clocksource/samsung_pwm.h       |  2 +-
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/clocksource/samsung_pwm_timer.c b/drivers/clocksource/samsung_pwm_timer.c
index b9561e3f196c4..0544124cf5cea 100644
--- a/drivers/clocksource/samsung_pwm_timer.c
+++ b/drivers/clocksource/samsung_pwm_timer.c
@@ -56,7 +56,7 @@
 #define TCON_AUTORELOAD(chan)		\
 	((chan < 5) ? _TCON_AUTORELOAD(chan) : _TCON_AUTORELOAD4(chan))
 
-DEFINE_SPINLOCK(samsung_pwm_lock);
+DEFINE_RAW_SPINLOCK(samsung_pwm_lock);
 EXPORT_SYMBOL(samsung_pwm_lock);
 
 struct samsung_pwm_clocksource {
@@ -87,14 +87,14 @@ static void samsung_timer_set_prescale(unsigned int channel, u16 prescale)
 	if (channel >= 2)
 		shift = TCFG0_PRESCALER1_SHIFT;
 
-	spin_lock_irqsave(&samsung_pwm_lock, flags);
+	raw_spin_lock_irqsave(&samsung_pwm_lock, flags);
 
 	reg = readl(pwm.base + REG_TCFG0);
 	reg &= ~(TCFG0_PRESCALER_MASK << shift);
 	reg |= (prescale - 1) << shift;
 	writel(reg, pwm.base + REG_TCFG0);
 
-	spin_unlock_irqrestore(&samsung_pwm_lock, flags);
+	raw_spin_unlock_irqrestore(&samsung_pwm_lock, flags);
 }
 
 static void samsung_timer_set_divisor(unsigned int channel, u8 divisor)
@@ -106,14 +106,14 @@ static void samsung_timer_set_divisor(unsigned int channel, u8 divisor)
 
 	bits = (fls(divisor) - 1) - pwm.variant.div_base;
 
-	spin_lock_irqsave(&samsung_pwm_lock, flags);
+	raw_spin_lock_irqsave(&samsung_pwm_lock, flags);
 
 	reg = readl(pwm.base + REG_TCFG1);
 	reg &= ~(TCFG1_MUX_MASK << shift);
 	reg |= bits << shift;
 	writel(reg, pwm.base + REG_TCFG1);
 
-	spin_unlock_irqrestore(&samsung_pwm_lock, flags);
+	raw_spin_unlock_irqrestore(&samsung_pwm_lock, flags);
 }
 
 static void samsung_time_stop(unsigned int channel)
@@ -124,13 +124,13 @@ static void samsung_time_stop(unsigned int channel)
 	if (channel > 0)
 		++channel;
 
-	spin_lock_irqsave(&samsung_pwm_lock, flags);
+	raw_spin_lock_irqsave(&samsung_pwm_lock, flags);
 
 	tcon = readl_relaxed(pwm.base + REG_TCON);
 	tcon &= ~TCON_START(channel);
 	writel_relaxed(tcon, pwm.base + REG_TCON);
 
-	spin_unlock_irqrestore(&samsung_pwm_lock, flags);
+	raw_spin_unlock_irqrestore(&samsung_pwm_lock, flags);
 }
 
 static void samsung_time_setup(unsigned int channel, unsigned long tcnt)
@@ -142,7 +142,7 @@ static void samsung_time_setup(unsigned int channel, unsigned long tcnt)
 	if (tcon_chan > 0)
 		++tcon_chan;
 
-	spin_lock_irqsave(&samsung_pwm_lock, flags);
+	raw_spin_lock_irqsave(&samsung_pwm_lock, flags);
 
 	tcon = readl_relaxed(pwm.base + REG_TCON);
 
@@ -153,7 +153,7 @@ static void samsung_time_setup(unsigned int channel, unsigned long tcnt)
 	writel_relaxed(tcnt, pwm.base + REG_TCMPB(channel));
 	writel_relaxed(tcon, pwm.base + REG_TCON);
 
-	spin_unlock_irqrestore(&samsung_pwm_lock, flags);
+	raw_spin_unlock_irqrestore(&samsung_pwm_lock, flags);
 }
 
 static void samsung_time_start(unsigned int channel, bool periodic)
@@ -164,7 +164,7 @@ static void samsung_time_start(unsigned int channel, bool periodic)
 	if (channel > 0)
 		++channel;
 
-	spin_lock_irqsave(&samsung_pwm_lock, flags);
+	raw_spin_lock_irqsave(&samsung_pwm_lock, flags);
 
 	tcon = readl_relaxed(pwm.base + REG_TCON);
 
@@ -178,7 +178,7 @@ static void samsung_time_start(unsigned int channel, bool periodic)
 
 	writel_relaxed(tcon, pwm.base + REG_TCON);
 
-	spin_unlock_irqrestore(&samsung_pwm_lock, flags);
+	raw_spin_unlock_irqrestore(&samsung_pwm_lock, flags);
 }
 
 static int samsung_set_next_event(unsigned long cycles,
diff --git a/drivers/pwm/pwm-samsung.c b/drivers/pwm/pwm-samsung.c
index 951b38ff5f8ec..14fb460a45655 100644
--- a/drivers/pwm/pwm-samsung.c
+++ b/drivers/pwm/pwm-samsung.c
@@ -102,7 +102,7 @@ struct samsung_pwm_chip {
  * IP. Should this change, both drivers will need to be modified to
  * properly synchronize accesses to particular instances.
  */
-static DEFINE_SPINLOCK(samsung_pwm_lock);
+static DEFINE_RAW_SPINLOCK(samsung_pwm_lock);
 #endif
 
 static inline
@@ -141,14 +141,14 @@ static void pwm_samsung_set_divisor(struct samsung_pwm_chip *our_chip,
 
 	bits = (fls(divisor) - 1) - our_chip->variant.div_base;
 
-	spin_lock_irqsave(&samsung_pwm_lock, flags);
+	raw_spin_lock_irqsave(&samsung_pwm_lock, flags);
 
 	reg = readl(our_chip->base + REG_TCFG1);
 	reg &= ~(TCFG1_MUX_MASK << shift);
 	reg |= bits << shift;
 	writel(reg, our_chip->base + REG_TCFG1);
 
-	spin_unlock_irqrestore(&samsung_pwm_lock, flags);
+	raw_spin_unlock_irqrestore(&samsung_pwm_lock, flags);
 }
 
 static int pwm_samsung_is_tdiv(struct samsung_pwm_chip *our_chip, unsigned int chan)
@@ -249,7 +249,7 @@ static int pwm_samsung_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 	unsigned long flags;
 	u32 tcon;
 
-	spin_lock_irqsave(&samsung_pwm_lock, flags);
+	raw_spin_lock_irqsave(&samsung_pwm_lock, flags);
 
 	tcon = readl(our_chip->base + REG_TCON);
 
@@ -263,7 +263,7 @@ static int pwm_samsung_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 
 	our_chip->disabled_mask &= ~BIT(pwm->hwpwm);
 
-	spin_unlock_irqrestore(&samsung_pwm_lock, flags);
+	raw_spin_unlock_irqrestore(&samsung_pwm_lock, flags);
 
 	return 0;
 }
@@ -275,7 +275,7 @@ static void pwm_samsung_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 	unsigned long flags;
 	u32 tcon;
 
-	spin_lock_irqsave(&samsung_pwm_lock, flags);
+	raw_spin_lock_irqsave(&samsung_pwm_lock, flags);
 
 	tcon = readl(our_chip->base + REG_TCON);
 	tcon &= ~TCON_AUTORELOAD(tcon_chan);
@@ -290,7 +290,7 @@ static void pwm_samsung_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 
 	our_chip->disabled_mask |= BIT(pwm->hwpwm);
 
-	spin_unlock_irqrestore(&samsung_pwm_lock, flags);
+	raw_spin_unlock_irqrestore(&samsung_pwm_lock, flags);
 }
 
 static void pwm_samsung_manual_update(struct samsung_pwm_chip *our_chip,
@@ -298,11 +298,11 @@ static void pwm_samsung_manual_update(struct samsung_pwm_chip *our_chip,
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&samsung_pwm_lock, flags);
+	raw_spin_lock_irqsave(&samsung_pwm_lock, flags);
 
 	__pwm_samsung_manual_update(our_chip, pwm);
 
-	spin_unlock_irqrestore(&samsung_pwm_lock, flags);
+	raw_spin_unlock_irqrestore(&samsung_pwm_lock, flags);
 }
 
 static int __pwm_samsung_config(struct pwm_chip *chip, struct pwm_device *pwm,
@@ -390,7 +390,7 @@ static void pwm_samsung_set_invert(struct samsung_pwm_chip *our_chip,
 	unsigned long flags;
 	u32 tcon;
 
-	spin_lock_irqsave(&samsung_pwm_lock, flags);
+	raw_spin_lock_irqsave(&samsung_pwm_lock, flags);
 
 	tcon = readl(our_chip->base + REG_TCON);
 
@@ -404,7 +404,7 @@ static void pwm_samsung_set_invert(struct samsung_pwm_chip *our_chip,
 
 	writel(tcon, our_chip->base + REG_TCON);
 
-	spin_unlock_irqrestore(&samsung_pwm_lock, flags);
+	raw_spin_unlock_irqrestore(&samsung_pwm_lock, flags);
 }
 
 static int pwm_samsung_set_polarity(struct pwm_chip *chip,
diff --git a/include/clocksource/samsung_pwm.h b/include/clocksource/samsung_pwm.h
index 9b435caa95fef..36f6f246e5594 100644
--- a/include/clocksource/samsung_pwm.h
+++ b/include/clocksource/samsung_pwm.h
@@ -15,7 +15,7 @@
  * spinlock is not shared between both drivers.
  */
 #ifdef CONFIG_CLKSRC_SAMSUNG_PWM
-extern spinlock_t samsung_pwm_lock;
+extern raw_spinlock_t samsung_pwm_lock;
 #endif
 
 struct samsung_pwm_variant {
-- 
2.53.0



