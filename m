Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B991B5835;
	Tue, 30 Jul 2024 15:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355017; cv=none; b=n4cWnOAjjSM3Ni7srHJFVy4Q0UxBeT9xqUrV/b84iHb2sxklN4x0VRb3KL3oJROg+Ga8D84MTPIyVaGI1luxN6xiGRG1n47GjTQRTkOUUwd0Toc/Z1QxUDf9hfknPVQ4H/4vmSlKAk5WeSyvFjwRmkQCepqaRJck0WLDDqlK8JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355017; c=relaxed/simple;
	bh=0xTt3XS6FaeYXepTvvdTfLKBKAYEH8NvzvNyM8xqvzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sM5dteijHgbhHUwX4kjpxyOtmK14rjpmgG9GTkllTYiP+oqk9BXEORgt3ZBJACOknL5NAbz+Q1qz4rapsAFvNqRpvYAKTM9Rh3v+MOeCSiNMbZnFB1dnFtWdFxN/BbnSFeONfQUDw3o7PvrLQM/6XlcPNzaO+XF/Zm0ssQaMZz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0C5ginx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0C5ginx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476ABC32782;
	Tue, 30 Jul 2024 15:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355017;
	bh=0xTt3XS6FaeYXepTvvdTfLKBKAYEH8NvzvNyM8xqvzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h0C5ginxiv2fEXptzULbem7YgZuq8ogItEc1e7/6+yEzR6aNJE9RfYvHrmI0HUdAw
	 wLHaHFgI4aVOWEGirXwfGgrKtZ6gkcJX/Pudgk/nwF+b9aZlrAALxulpaFjVlg7eTN
	 hqbUswhcmKXkh0zrJNqMaAPib7cvEnzfQ0ionAKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/440] pwm: atmel-tcb: Put per-channel data into driver data
Date: Tue, 30 Jul 2024 17:44:18 +0200
Message-ID: <20240730151616.748716656@linuxfoundation.org>
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

[ Upstream commit 78dca23bd6706dd6a3cdb5c0052f48794b4d2bed ]

This simplifies the code, reduces the number of memory allocations and
pointer dereferences.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Stable-dep-of: 37f7707077f5 ("pwm: atmel-tcb: Fix race condition and convert to guards")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-atmel-tcb.c | 29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
index 2826fc216d291..ae274bd7907dd 100644
--- a/drivers/pwm/pwm-atmel-tcb.c
+++ b/drivers/pwm/pwm-atmel-tcb.c
@@ -57,7 +57,7 @@ struct atmel_tcb_pwm_chip {
 	struct clk *clk;
 	struct clk *gclk;
 	struct clk *slow_clk;
-	struct atmel_tcb_pwm_device *pwms[NPWM];
+	struct atmel_tcb_pwm_device pwms[NPWM];
 	struct atmel_tcb_channel bkup;
 };
 
@@ -73,7 +73,7 @@ static int atmel_tcb_pwm_set_polarity(struct pwm_chip *chip,
 				      enum pwm_polarity polarity)
 {
 	struct atmel_tcb_pwm_chip *tcbpwmc = to_tcb_chip(chip);
-	struct atmel_tcb_pwm_device *tcbpwm = tcbpwmc->pwms[pwm->hwpwm];
+	struct atmel_tcb_pwm_device *tcbpwm = &tcbpwmc->pwms[pwm->hwpwm];
 
 	tcbpwm->polarity = polarity;
 
@@ -84,19 +84,13 @@ static int atmel_tcb_pwm_request(struct pwm_chip *chip,
 				 struct pwm_device *pwm)
 {
 	struct atmel_tcb_pwm_chip *tcbpwmc = to_tcb_chip(chip);
-	struct atmel_tcb_pwm_device *tcbpwm;
+	struct atmel_tcb_pwm_device *tcbpwm = &tcbpwmc->pwms[pwm->hwpwm];
 	unsigned cmr;
 	int ret;
 
-	tcbpwm = devm_kzalloc(chip->dev, sizeof(*tcbpwm), GFP_KERNEL);
-	if (!tcbpwm)
-		return -ENOMEM;
-
 	ret = clk_prepare_enable(tcbpwmc->clk);
-	if (ret) {
-		devm_kfree(chip->dev, tcbpwm);
+	if (ret)
 		return ret;
-	}
 
 	tcbpwm->polarity = PWM_POLARITY_NORMAL;
 	tcbpwm->duty = 0;
@@ -131,25 +125,20 @@ static int atmel_tcb_pwm_request(struct pwm_chip *chip,
 	regmap_write(tcbpwmc->regmap, ATMEL_TC_REG(tcbpwmc->channel, CMR), cmr);
 	spin_unlock(&tcbpwmc->lock);
 
-	tcbpwmc->pwms[pwm->hwpwm] = tcbpwm;
-
 	return 0;
 }
 
 static void atmel_tcb_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct atmel_tcb_pwm_chip *tcbpwmc = to_tcb_chip(chip);
-	struct atmel_tcb_pwm_device *tcbpwm = tcbpwmc->pwms[pwm->hwpwm];
 
 	clk_disable_unprepare(tcbpwmc->clk);
-	tcbpwmc->pwms[pwm->hwpwm] = NULL;
-	devm_kfree(chip->dev, tcbpwm);
 }
 
 static void atmel_tcb_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct atmel_tcb_pwm_chip *tcbpwmc = to_tcb_chip(chip);
-	struct atmel_tcb_pwm_device *tcbpwm = tcbpwmc->pwms[pwm->hwpwm];
+	struct atmel_tcb_pwm_device *tcbpwm = &tcbpwmc->pwms[pwm->hwpwm];
 	unsigned cmr;
 	enum pwm_polarity polarity = tcbpwm->polarity;
 
@@ -206,7 +195,7 @@ static void atmel_tcb_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 static int atmel_tcb_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct atmel_tcb_pwm_chip *tcbpwmc = to_tcb_chip(chip);
-	struct atmel_tcb_pwm_device *tcbpwm = tcbpwmc->pwms[pwm->hwpwm];
+	struct atmel_tcb_pwm_device *tcbpwm = &tcbpwmc->pwms[pwm->hwpwm];
 	u32 cmr;
 	enum pwm_polarity polarity = tcbpwm->polarity;
 
@@ -291,7 +280,7 @@ static int atmel_tcb_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 				int duty_ns, int period_ns)
 {
 	struct atmel_tcb_pwm_chip *tcbpwmc = to_tcb_chip(chip);
-	struct atmel_tcb_pwm_device *tcbpwm = tcbpwmc->pwms[pwm->hwpwm];
+	struct atmel_tcb_pwm_device *tcbpwm = &tcbpwmc->pwms[pwm->hwpwm];
 	struct atmel_tcb_pwm_device *atcbpwm = NULL;
 	int i = 0;
 	int slowclk = 0;
@@ -338,9 +327,9 @@ static int atmel_tcb_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	period = div_u64(period_ns, min);
 
 	if (pwm->hwpwm == 0)
-		atcbpwm = tcbpwmc->pwms[1];
+		atcbpwm = &tcbpwmc->pwms[1];
 	else
-		atcbpwm = tcbpwmc->pwms[0];
+		atcbpwm = &tcbpwmc->pwms[0];
 
 	/*
 	 * PWM devices provided by the TCB driver are grouped by 2.
-- 
2.43.0



