Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18AD882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E79C433EF;
	Fri, 10 Mar 2023 15:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460737;
	bh=vYKrF8LfbcEY50jVQyedLPtVAEhEDbWRjMx4/YkiO8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZowS2iyYZ2gJnR7uAiAtHT43Hk/nx3Zw03G+my3yXxZs7hdl4Aaf2utyzAuFVrVo
	 0BBByNadcMSzDPzYv4yQEVKeYh6yjREdM4nwPLFuhGw95+iSjDaQfUbhdzwIg3xBao
	 KimMa3mz/WtNk/p4y3bpesdtRoh2gU5HHyLJM4/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Emil Renner Berthing <emil.renner.berthing@canonical.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 434/529] pwm: sifive: Reduce time the controller lock is held
Date: Fri, 10 Mar 2023 14:39:37 +0100
Message-Id: <20230310133825.028779564@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 0f02f491b786143f08eb19840f1cf4f12aec6dee ]

The lock is only to serialize access and update to user_count and
approx_period between different PWMs served by the same pwm_chip.
So the lock needs only to be taken during the check if the (chip global)
period can and/or needs to be changed.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Tested-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Stable-dep-of: 334c7b13d383 ("pwm: sifive: Always let the first pwm_apply_state succeed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-sifive.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/pwm/pwm-sifive.c b/drivers/pwm/pwm-sifive.c
index 12e9e23272ab1..400cc91057acf 100644
--- a/drivers/pwm/pwm-sifive.c
+++ b/drivers/pwm/pwm-sifive.c
@@ -41,7 +41,7 @@
 
 struct pwm_sifive_ddata {
 	struct pwm_chip	chip;
-	struct mutex lock; /* lock to protect user_count */
+	struct mutex lock; /* lock to protect user_count and approx_period */
 	struct notifier_block notifier;
 	struct clk *clk;
 	void __iomem *regs;
@@ -76,6 +76,7 @@ static void pwm_sifive_free(struct pwm_chip *chip, struct pwm_device *pwm)
 	mutex_unlock(&ddata->lock);
 }
 
+/* Called holding ddata->lock */
 static void pwm_sifive_update_clock(struct pwm_sifive_ddata *ddata,
 				    unsigned long rate)
 {
@@ -163,7 +164,6 @@ static int pwm_sifive_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 		return ret;
 	}
 
-	mutex_lock(&ddata->lock);
 	cur_state = pwm->state;
 	enabled = cur_state.enabled;
 
@@ -182,14 +182,17 @@ static int pwm_sifive_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	/* The hardware cannot generate a 100% duty cycle */
 	frac = min(frac, (1U << PWM_SIFIVE_CMPWIDTH) - 1);
 
+	mutex_lock(&ddata->lock);
 	if (state->period != ddata->approx_period) {
 		if (ddata->user_count != 1) {
+			mutex_unlock(&ddata->lock);
 			ret = -EBUSY;
 			goto exit;
 		}
 		ddata->approx_period = state->period;
 		pwm_sifive_update_clock(ddata, clk_get_rate(ddata->clk));
 	}
+	mutex_unlock(&ddata->lock);
 
 	writel(frac, ddata->regs + PWM_SIFIVE_PWMCMP(pwm->hwpwm));
 
@@ -198,7 +201,6 @@ static int pwm_sifive_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 exit:
 	clk_disable(ddata->clk);
-	mutex_unlock(&ddata->lock);
 	return ret;
 }
 
-- 
2.39.2



