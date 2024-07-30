Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C11D145A18;
	Tue, 30 Jul 2024 15:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354862; cv=none; b=uRR9rGDgbeGaTVCkyJMpS08KtKvle/08aGTb/pRhufZxjfGG3/BkXQbco98DSUakuHECurzUqdMSu2os9DnSw3sviFvOdTYRgKN4Ov6DINI8Uj+rgdQlIIcryUX2KE1hHymQDq0eGDgXfEgkAZDlsPRyJv3k4gJcLtoE+tbccB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354862; c=relaxed/simple;
	bh=3VyzZp7gQZn3IimvGP/k+ILRNOFkPjiDDRdUj9a7pUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ncsq3WOAfWyrwmmPLGeAmp3jtYwPNJC4Osah3U7kyU4fvIKaCiYsrPtBggtJYZqLsYD15pqryZZ4zsxBj7jQa8vWgvsWxfIojSX94FgCgjEpGKMftMv4MSXOGS+d9RBZ3ZWUm5hsIxX5Yke7bKUp+6tfujR/0XawwTSGi94e5OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gyXR/qMJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gyXR/qMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701B8C32782;
	Tue, 30 Jul 2024 15:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354861;
	bh=3VyzZp7gQZn3IimvGP/k+ILRNOFkPjiDDRdUj9a7pUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gyXR/qMJLnK4J+fQc5TM91qAuBUeIU6RGsnm4DfUNXhWuurPH0DWM6G7sSEfUsuvg
	 UgC/cUAFQEbb5nUqm9L9jqNRXfJ1JNI2ROMfK4LNqQjxabwER/C2oc/j5kAIkIghu+
	 vV2yEwhurA3jdVxXI4q7V8HXfqO6bVWiyz0fHZSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/440] pwm: atmel-tcb: Dont track polarity in driver data
Date: Tue, 30 Jul 2024 17:44:20 +0200
Message-ID: <20240730151616.827130233@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 28a1dadc49e2902d0a7a2e8c699a15f93b1b6f40 ]

struct atmel_tcb_pwm_device::polarity is only used in atmel_tcb_pwm_enable
and atmel_tcb_pwm_disable(). These functions are only called by
atmel_tcb_pwm_apply() after the member variable was assigned to
state->polarity. So the value assigned in atmel_tcb_pwm_request() is
never used and the member can be dropped from struct atmel_tcb_pwm_device.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Stable-dep-of: 37f7707077f5 ("pwm: atmel-tcb: Fix race condition and convert to guards")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-atmel-tcb.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
index 32a60d7f8ed2e..30c966238e41c 100644
--- a/drivers/pwm/pwm-atmel-tcb.c
+++ b/drivers/pwm/pwm-atmel-tcb.c
@@ -34,7 +34,6 @@
 				 ATMEL_TC_BEEVT | ATMEL_TC_BSWTRG)
 
 struct atmel_tcb_pwm_device {
-	enum pwm_polarity polarity;	/* PWM polarity */
 	unsigned div;			/* PWM clock divider */
 	unsigned duty;			/* PWM duty expressed in clk cycles */
 	unsigned period;		/* PWM period expressed in clk cycles */
@@ -80,7 +79,6 @@ static int atmel_tcb_pwm_request(struct pwm_chip *chip,
 	if (ret)
 		return ret;
 
-	tcbpwm->polarity = PWM_POLARITY_NORMAL;
 	tcbpwm->duty = 0;
 	tcbpwm->period = 0;
 	tcbpwm->div = 0;
@@ -123,12 +121,12 @@ static void atmel_tcb_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
 	clk_disable_unprepare(tcbpwmc->clk);
 }
 
-static void atmel_tcb_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+static void atmel_tcb_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm,
+				  enum pwm_polarity polarity)
 {
 	struct atmel_tcb_pwm_chip *tcbpwmc = to_tcb_chip(chip);
 	struct atmel_tcb_pwm_device *tcbpwm = &tcbpwmc->pwms[pwm->hwpwm];
 	unsigned cmr;
-	enum pwm_polarity polarity = tcbpwm->polarity;
 
 	/*
 	 * If duty is 0 the timer will be stopped and we have to
@@ -180,12 +178,12 @@ static void atmel_tcb_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 	spin_unlock(&tcbpwmc->lock);
 }
 
-static int atmel_tcb_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+static int atmel_tcb_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm,
+				enum pwm_polarity polarity)
 {
 	struct atmel_tcb_pwm_chip *tcbpwmc = to_tcb_chip(chip);
 	struct atmel_tcb_pwm_device *tcbpwm = &tcbpwmc->pwms[pwm->hwpwm];
 	u32 cmr;
-	enum pwm_polarity polarity = tcbpwm->polarity;
 
 	/*
 	 * If duty is 0 the timer will be stopped and we have to
@@ -345,15 +343,11 @@ static int atmel_tcb_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 static int atmel_tcb_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 			       const struct pwm_state *state)
 {
-	struct atmel_tcb_pwm_chip *tcbpwmc = to_tcb_chip(chip);
-	struct atmel_tcb_pwm_device *tcbpwm = &tcbpwmc->pwms[pwm->hwpwm];
 	int duty_cycle, period;
 	int ret;
 
-	tcbpwm->polarity = state->polarity;
-
 	if (!state->enabled) {
-		atmel_tcb_pwm_disable(chip, pwm);
+		atmel_tcb_pwm_disable(chip, pwm, state->polarity);
 		return 0;
 	}
 
@@ -364,7 +358,7 @@ static int atmel_tcb_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	if (ret)
 		return ret;
 
-	return atmel_tcb_pwm_enable(chip, pwm);
+	return atmel_tcb_pwm_enable(chip, pwm, state->polarity);
 }
 
 static const struct pwm_ops atmel_tcb_pwm_ops = {
-- 
2.43.0



