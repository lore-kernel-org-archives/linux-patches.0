Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E5543AB9
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/v4dfvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F6DC433CA;
	Wed, 15 Nov 2023 20:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081153;
	bh=FTHdB8nMEM98kCnX3O3C4PRQmQ7lCVRqoUVJaCbUqvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/v4dfvvTC+BR5KHt7Evp67qmnXER2/oTfzDcAjxeUa5NLYqOrmvf9gRDazjbb15L
	 nMbREttDA+z/4c+AkcQhwf6SY2L71MFprXfMTjWxmZj70SmgLxZCUaCvL1+B+3daWg
	 RhA+zLCoYsUnA3g7KBo1Us97zHADRNDBnCCdxrFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Stark <gnstark@sberdevices.ru>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 69/88] pwm: sti: Reduce number of allocations and drop usage of chip_data
Date: Wed, 15 Nov 2023 15:36:21 -0500
Message-ID: <20231115191430.258458520@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191426.221330369@linuxfoundation.org>
References: <20231115191426.221330369@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 2d6812b41e0d832919d72c72ebddf361df53ba1b ]

Instead of using one allocation per capture channel, use a single one. Also
store it in driver data instead of chip data.

This has several advantages:

 - driver data isn't cleared when pwm_put() is called
 - Reduces memory fragmentation

Also register the pwm chip only after the per capture channel data is
initialized as the capture callback relies on this initialization and it
might be called even before pwmchip_add() returns.

It would be still better to have struct sti_pwm_compat_data and the
per-channel data struct sti_cpt_ddata in a single memory chunk, but that's
not easily possible because the number of capture channels isn't known yet
when the driver data struct is allocated.

Fixes: e926b12c611c ("pwm: Clear chip_data in pwm_put()")
Reported-by: George Stark <gnstark@sberdevices.ru>
Fixes: c97267ae831d ("pwm: sti: Add PWM capture callback")
Link: https://lore.kernel.org/r/20230705080650.2353391-7-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-sti.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/pwm/pwm-sti.c b/drivers/pwm/pwm-sti.c
index f413b41dc69d8..059650d8118e0 100644
--- a/drivers/pwm/pwm-sti.c
+++ b/drivers/pwm/pwm-sti.c
@@ -83,6 +83,7 @@ struct sti_pwm_compat_data {
 	unsigned int cpt_num_devs;
 	unsigned int max_pwm_cnt;
 	unsigned int max_prescale;
+	struct sti_cpt_ddata *ddata;
 };
 
 struct sti_pwm_chip {
@@ -318,7 +319,7 @@ static int sti_pwm_capture(struct pwm_chip *chip, struct pwm_device *pwm,
 {
 	struct sti_pwm_chip *pc = to_sti_pwmchip(chip);
 	struct sti_pwm_compat_data *cdata = pc->cdata;
-	struct sti_cpt_ddata *ddata = pwm_get_chip_data(pwm);
+	struct sti_cpt_ddata *ddata = &cdata->ddata[pwm->hwpwm];
 	struct device *dev = pc->dev;
 	unsigned int effective_ticks;
 	unsigned long long high, low;
@@ -421,7 +422,7 @@ static irqreturn_t sti_pwm_interrupt(int irq, void *data)
 	while (cpt_int_stat) {
 		devicenum = ffs(cpt_int_stat) - 1;
 
-		ddata = pwm_get_chip_data(&pc->chip.pwms[devicenum]);
+		ddata = &pc->cdata->ddata[devicenum];
 
 		/*
 		 * Capture input:
@@ -625,6 +626,10 @@ static int sti_pwm_probe(struct platform_device *pdev)
 			dev_err(dev, "failed to prepare clock\n");
 			return ret;
 		}
+
+		cdata->ddata = devm_kzalloc(dev, cdata->cpt_num_devs * sizeof(*cdata->ddata), GFP_KERNEL);
+		if (!cdata->ddata)
+			return -ENOMEM;
 	}
 
 	pc->chip.dev = dev;
@@ -632,24 +637,18 @@ static int sti_pwm_probe(struct platform_device *pdev)
 	pc->chip.base = -1;
 	pc->chip.npwm = pc->cdata->pwm_num_devs;
 
-	ret = pwmchip_add(&pc->chip);
-	if (ret < 0) {
-		clk_unprepare(pc->pwm_clk);
-		clk_unprepare(pc->cpt_clk);
-		return ret;
-	}
-
 	for (i = 0; i < cdata->cpt_num_devs; i++) {
-		struct sti_cpt_ddata *ddata;
-
-		ddata = devm_kzalloc(dev, sizeof(*ddata), GFP_KERNEL);
-		if (!ddata)
-			return -ENOMEM;
+		struct sti_cpt_ddata *ddata = &cdata->ddata[i];
 
 		init_waitqueue_head(&ddata->wait);
 		mutex_init(&ddata->lock);
+	}
 
-		pwm_set_chip_data(&pc->chip.pwms[i], ddata);
+	ret = pwmchip_add(&pc->chip);
+	if (ret < 0) {
+		clk_unprepare(pc->pwm_clk);
+		clk_unprepare(pc->cpt_clk);
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, pc);
-- 
2.42.0



