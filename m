Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9889C342513;
	Tue, 16 Dec 2025 11:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884411; cv=none; b=Vq+/iJtLpCjGQ4kIqF+7BgonAZ3j7O5yTGEx5tEjeXn8Ko1eL8c/N7mY+DDDFvbccmytIw5Ht2Ad3jECJ3aSAhSKDhYEWM8D9HtMRyUncSHxji04OCxkXLtrH38DUDl+AAHBdtDQb8wVZFUUGNcpTAd5cYiMCTMNWREj8lP2/MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884411; c=relaxed/simple;
	bh=vfFagRBDIJutv4r5ycdWqOym9iALUE6Mm8MbdgGZBwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CyiswBT3k6F86qxg0eywT++vO7QoFsvrZXGFZHU6TxaiLS9O+l1uMeMo5MbVhJBZU/9UXBg7LjWEjs4aTQEwuN3DacA9r3U8s6yf1oqeVhqlaLcMxR6rjeVgb1K5C1caZSKqPdStelomZmns+obfnqh3S2GMxGztBjVHhWZlfmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vsEG6nJJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vsEG6nJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22414C16AAE;
	Tue, 16 Dec 2025 11:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884411;
	bh=vfFagRBDIJutv4r5ycdWqOym9iALUE6Mm8MbdgGZBwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vsEG6nJJYEBDhbYhEzEHdN3SvXOWnyxchpYPVca+T6mV8sZ7VxyWoPIdZw9t7bHKk
	 5lcq9uyovhyKz/saS3WAETKbNgQ4ehBPpBHx1kyucnG47QuJsKxUIrVa7/OUHfx0fq
	 TnLZI+3DQA/kEvDLpqAjvzRCrda32OcQ52q0mdJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 186/354] pwm: bcm2835: Make sure the channel is enabled after pwm_request()
Date: Tue, 16 Dec 2025 12:12:33 +0100
Message-ID: <20251216111327.652319625@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit cda323dbda76600bf9761970d58517648f0de67d ]

The .free callback cleared among others the enable bit PWENx in the
control register. When the PWM is requested later again this bit isn't
restored but the core assumes the PWM is enabled and thus skips a
request to configure the same state as before.

To fix that don't touch the hardware configuration in .free(). For
symmetry also drop .request() and configure the mode completely in
.apply().

Fixes: e5a06dc5ac1f ("pwm: Add BCM2835 PWM driver")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20251118174303.1761577-2-u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-bcm2835.c | 28 +++-------------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

diff --git a/drivers/pwm/pwm-bcm2835.c b/drivers/pwm/pwm-bcm2835.c
index 578e95e0296c6..532903da521fd 100644
--- a/drivers/pwm/pwm-bcm2835.c
+++ b/drivers/pwm/pwm-bcm2835.c
@@ -34,29 +34,6 @@ static inline struct bcm2835_pwm *to_bcm2835_pwm(struct pwm_chip *chip)
 	return pwmchip_get_drvdata(chip);
 }
 
-static int bcm2835_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
-{
-	struct bcm2835_pwm *pc = to_bcm2835_pwm(chip);
-	u32 value;
-
-	value = readl(pc->base + PWM_CONTROL);
-	value &= ~(PWM_CONTROL_MASK << PWM_CONTROL_SHIFT(pwm->hwpwm));
-	value |= (PWM_MODE << PWM_CONTROL_SHIFT(pwm->hwpwm));
-	writel(value, pc->base + PWM_CONTROL);
-
-	return 0;
-}
-
-static void bcm2835_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
-{
-	struct bcm2835_pwm *pc = to_bcm2835_pwm(chip);
-	u32 value;
-
-	value = readl(pc->base + PWM_CONTROL);
-	value &= ~(PWM_CONTROL_MASK << PWM_CONTROL_SHIFT(pwm->hwpwm));
-	writel(value, pc->base + PWM_CONTROL);
-}
-
 static int bcm2835_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 			     const struct pwm_state *state)
 {
@@ -102,6 +79,9 @@ static int bcm2835_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	/* set polarity */
 	val = readl(pc->base + PWM_CONTROL);
 
+	val &= ~(PWM_CONTROL_MASK << PWM_CONTROL_SHIFT(pwm->hwpwm));
+	val |= PWM_MODE << PWM_CONTROL_SHIFT(pwm->hwpwm);
+
 	if (state->polarity == PWM_POLARITY_NORMAL)
 		val &= ~(PWM_POLARITY << PWM_CONTROL_SHIFT(pwm->hwpwm));
 	else
@@ -119,8 +99,6 @@ static int bcm2835_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 }
 
 static const struct pwm_ops bcm2835_pwm_ops = {
-	.request = bcm2835_pwm_request,
-	.free = bcm2835_pwm_free,
 	.apply = bcm2835_pwm_apply,
 };
 
-- 
2.51.0



