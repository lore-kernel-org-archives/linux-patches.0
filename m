Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EF9363C66;
	Tue, 16 Dec 2025 12:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887754; cv=none; b=QaRA5PdyCAsAjdg/bBFW6SUxABWC98l9C7tICnc8I3ftl2/aaw2q8O/MtbYxmCn7U7EMNYiZQExDknNsddex93DxtdM+r69XHRgmDddVooLCtFyZ7Hbu58CvgRxfytNf6L1rtTgD2lFaIlcx+XJUqsPFeCHs63gMl2SpYYL02uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887754; c=relaxed/simple;
	bh=qu7SiDJMAZEeYh+UoIwMwqBCWXvB3p+RsSHGyKhDCd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HTPjAs28G6R6SBfvj0KsNbmhchZkHvNST7pFZrZU/LmLlyo/oJdOiXjPlb5ZZufjKuHzFk9CunkEnnHPLZuWzsAQiWXNnD+uPmywnxabjQVxzx5sjL3thoPZRdqX+vcW22zqS2mv5s3Tbqr9tf+JuOzk8SsnYq1UDjbyqoLa03U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q63EFwaa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q63EFwaa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84EA1C4CEF1;
	Tue, 16 Dec 2025 12:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887754;
	bh=qu7SiDJMAZEeYh+UoIwMwqBCWXvB3p+RsSHGyKhDCd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q63EFwaarE2Zs+dlKp/P8x52F7tZoGerkpjIShp+gL9KahI7Z0xnckz764DJLU2jb
	 eKOp9EQrbzVXyNrdyjafaiBt7WJW6oo5qha16026yPJqDVMBwip3SngLmETF5QYnqm
	 cl6oq1rI4Oj8yvyRXBK5qm+RIdqRDr8RMnsVpGaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 328/614] pwm: bcm2835: Make sure the channel is enabled after pwm_request()
Date: Tue, 16 Dec 2025 12:11:35 +0100
Message-ID: <20251216111413.250280142@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



