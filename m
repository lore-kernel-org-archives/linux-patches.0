Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6A82DEA6F;
	Fri,  9 Jan 2026 11:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959846; cv=none; b=O/BTYgkjrHkE8LuxdL58iCM3tbuu+CAK+Gx0VJvL7cwh1nV/a1WqalY/938BOvVVY5XN1HloAPr4KZX9JH8grZ5gj6RZNcz/zKFVL723xINfhE1+TX0V1PBzI1Iguj0WqBQUQjMFH0tMpJ2JxN/YEsO6IywA0peC+trK8+Vr2pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959846; c=relaxed/simple;
	bh=yuIDU1nWS66lbnrxKw/cNdXC40n9mtj4vM/d8NXD3GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SsQO28c71ebBXo0be0FofegWaeD5sBKTaqsLS9EMOgrIQi39Cdl/atIBe94yITJWOs70f4N0JFgP1uIa6rePVIv/pvl5txtfYkDcapeDReW5MDUfo704uQDIOj+bq5TJPlGt+nBSzwv8hDezDHNaSd1cZ32JXnMpw0EKEOKC+5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tgavJRZA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tgavJRZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B45FC4CEF1;
	Fri,  9 Jan 2026 11:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959845;
	bh=yuIDU1nWS66lbnrxKw/cNdXC40n9mtj4vM/d8NXD3GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tgavJRZApz96ruxRmgJoDivZXu/WnjG90HwndJPkPeg1r3RslTZWIinjtXK+YoUI0
	 8b7iAdv9KYizHjWn3TC5SeMeYxP9/iGRX58fvPp4xanYfd/Hzk3ND8VXmemt/KRDDP
	 G1Jdd5RI4+yjILrwuWBDljhp9Ykht5BbprJqgf70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 178/737] pwm: bcm2835: Make sure the channel is enabled after pwm_request()
Date: Fri,  9 Jan 2026 12:35:17 +0100
Message-ID: <20260109112140.687455910@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bdfc2a5ec0d69..5a51ba9b26d92 100644
--- a/drivers/pwm/pwm-bcm2835.c
+++ b/drivers/pwm/pwm-bcm2835.c
@@ -35,29 +35,6 @@ static inline struct bcm2835_pwm *to_bcm2835_pwm(struct pwm_chip *chip)
 	return container_of(chip, struct bcm2835_pwm, chip);
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
@@ -109,6 +86,9 @@ static int bcm2835_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	/* set polarity */
 	val = readl(pc->base + PWM_CONTROL);
 
+	val &= ~(PWM_CONTROL_MASK << PWM_CONTROL_SHIFT(pwm->hwpwm));
+	val |= PWM_MODE << PWM_CONTROL_SHIFT(pwm->hwpwm);
+
 	if (state->polarity == PWM_POLARITY_NORMAL)
 		val &= ~(PWM_POLARITY << PWM_CONTROL_SHIFT(pwm->hwpwm));
 	else
@@ -126,8 +106,6 @@ static int bcm2835_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 }
 
 static const struct pwm_ops bcm2835_pwm_ops = {
-	.request = bcm2835_pwm_request,
-	.free = bcm2835_pwm_free,
 	.apply = bcm2835_pwm_apply,
 	.owner = THIS_MODULE,
 };
-- 
2.51.0



