Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4CF1BC066;
	Tue, 30 Jul 2024 15:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355072; cv=none; b=NbC5KbbfZFeQaPQ0OgdpbODuVKE00UVbS2drra+mdq218Ps9uM4yVcAuP8fWBL8DS40z9Q60Pfh3E+XXj50u/Gr2vb1t4KUhl7IUP/q/7lOZeRZGvydLCtRDF5OwDmlc8ADgjDi5OxxBc1+Tfo4Q9GEwtHKtGfDg6qH9hwRFhMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355072; c=relaxed/simple;
	bh=iD/ykxr5Op5HHFu/mS4/uOqaefFmRiqLSZUD4ex/IaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BFuOQIqX55TKCY1eng+1yFjMNClmHBtYuqmTZlp5ujIZ2L9kmRYOP3fWlL5ZvRJETcZ5hxknl0eq7HneIs+gKZ10b7C50IrVRWyQJ1ZObIf2J+z9EKDOyxY3+Y470IlSKFdXt+xPlzEsyMYTeU10FX6/8A8TgWZPwGhycTU+gVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rG7ZS9wZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rG7ZS9wZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA00C4AF0A;
	Tue, 30 Jul 2024 15:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355071;
	bh=iD/ykxr5Op5HHFu/mS4/uOqaefFmRiqLSZUD4ex/IaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rG7ZS9wZJ4nnaq1vapb8UfKOG57aoP6obaouOHwr4r1KhLwOHKP24HE41QkqoeVxQ
	 W7YOmQX2OyrJ15llZMW8g5qT8SGEK89uLXcbAydfcXrTHeCl360E+PlpwC0n408NnW
	 KrzG+PYQUY6mW3LiJucEfGt8o+kY9+tJeZdSICBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/568] pwm: atmel-tcb: Fix race condition and convert to guards
Date: Tue, 30 Jul 2024 17:42:12 +0200
Message-ID: <20240730151640.817202966@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 37f7707077f5ea2515bf4b1dc7fad43f8e12993e ]

The hardware only supports a single period length for both PWM outputs. So
atmel_tcb_pwm_config() checks the configuration of the other output if it's
compatible with the currently requested setting. The register values are
then actually updated in atmel_tcb_pwm_enable(). To make this race free
the lock must be held during the whole process, so grab the lock in
.apply() instead of individually in atmel_tcb_pwm_disable() and
atmel_tcb_pwm_enable() which then also covers atmel_tcb_pwm_config().

To simplify handling, use the guard helper to let the compiler care for
unlocking. Otherwise unlocking would be more difficult as there is more
than one exit path in atmel_tcb_pwm_apply().

Fixes: 9421bade0765 ("pwm: atmel: add Timer Counter Block PWM driver")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20240709101806.52394-3-u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-atmel-tcb.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
index c00dd37c5fbd8..06df8c6127416 100644
--- a/drivers/pwm/pwm-atmel-tcb.c
+++ b/drivers/pwm/pwm-atmel-tcb.c
@@ -82,7 +82,8 @@ static int atmel_tcb_pwm_request(struct pwm_chip *chip,
 	tcbpwm->period = 0;
 	tcbpwm->div = 0;
 
-	spin_lock(&tcbpwmc->lock);
+	guard(spinlock)(&tcbpwmc->lock);
+
 	regmap_read(tcbpwmc->regmap, ATMEL_TC_REG(tcbpwmc->channel, CMR), &cmr);
 	/*
 	 * Get init config from Timer Counter registers if
@@ -108,7 +109,6 @@ static int atmel_tcb_pwm_request(struct pwm_chip *chip,
 
 	cmr |= ATMEL_TC_WAVE | ATMEL_TC_WAVESEL_UP_AUTO | ATMEL_TC_EEVT_XC0;
 	regmap_write(tcbpwmc->regmap, ATMEL_TC_REG(tcbpwmc->channel, CMR), cmr);
-	spin_unlock(&tcbpwmc->lock);
 
 	return 0;
 }
@@ -138,7 +138,6 @@ static void atmel_tcb_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm,
 	if (tcbpwm->duty == 0)
 		polarity = !polarity;
 
-	spin_lock(&tcbpwmc->lock);
 	regmap_read(tcbpwmc->regmap, ATMEL_TC_REG(tcbpwmc->channel, CMR), &cmr);
 
 	/* flush old setting and set the new one */
@@ -173,8 +172,6 @@ static void atmel_tcb_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm,
 			     ATMEL_TC_SWTRG);
 		tcbpwmc->bkup.enabled = 0;
 	}
-
-	spin_unlock(&tcbpwmc->lock);
 }
 
 static int atmel_tcb_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm,
@@ -195,7 +192,6 @@ static int atmel_tcb_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm,
 	if (tcbpwm->duty == 0)
 		polarity = !polarity;
 
-	spin_lock(&tcbpwmc->lock);
 	regmap_read(tcbpwmc->regmap, ATMEL_TC_REG(tcbpwmc->channel, CMR), &cmr);
 
 	/* flush old setting and set the new one */
@@ -257,7 +253,6 @@ static int atmel_tcb_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm,
 	regmap_write(tcbpwmc->regmap, ATMEL_TC_REG(tcbpwmc->channel, CCR),
 		     ATMEL_TC_SWTRG | ATMEL_TC_CLKEN);
 	tcbpwmc->bkup.enabled = 1;
-	spin_unlock(&tcbpwmc->lock);
 	return 0;
 }
 
@@ -342,9 +337,12 @@ static int atmel_tcb_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 static int atmel_tcb_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 			       const struct pwm_state *state)
 {
+	struct atmel_tcb_pwm_chip *tcbpwmc = to_tcb_chip(chip);
 	int duty_cycle, period;
 	int ret;
 
+	guard(spinlock)(&tcbpwmc->lock);
+
 	if (!state->enabled) {
 		atmel_tcb_pwm_disable(chip, pwm, state->polarity);
 		return 0;
-- 
2.43.0



