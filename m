Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B317E41223
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0yeDS8Se"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CFDC433C7;
	Wed, 15 Nov 2023 19:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076607;
	bh=+PEr+LndLYXOn2B3hbYAB2FLmKD1Y7E6BgB5p3ArbUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0yeDS8Se5/pGDfpeQ+ey618qLx3qhWMlpPdYRhervz6pLTHYogD1gjmfxGHYOfOsm
	 uDtFsI2iL7MIaWqsPA4z3s8IudGysiiIqAiYd19d0b/uTOvFvri3tqwy6eec6XZVvC
	 vNT6za80vMV/JtG8b66UYQoeB0/2EBPVgGmR+Cek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aisheng Dong <aisheng.dong@nxp.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 336/550] backlight: pwm_bl: Disable PWM on shutdown, suspend and remove
Date: Wed, 15 Nov 2023 14:15:20 -0500
Message-ID: <20231115191624.056264327@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 40da4737717b252fd01d92ff38d3b95a491167cc ]

Since commit 00e7e698bff1 ("backlight: pwm_bl: Configure pwm only once
per backlight toggle") calling pwm_backlight_power_off() doesn't disable
the PWM any more. However this is necessary to suspend because PWM
drivers usually refuse to suspend if they are still enabled.

Also adapt shutdown and remove callbacks to disable the PWM for similar
reasons.

Fixes: 00e7e698bff1 ("backlight: pwm_bl: Configure pwm only once per backlight toggle")
Reported-by: Aisheng Dong <aisheng.dong@nxp.com>
Tested-by: Aisheng Dong <aisheng.dong@nxp.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Link: https://lore.kernel.org/r/20231009093223.227286-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/pwm_bl.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index a51fbab963680..289bd9ce4d36d 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -626,9 +626,14 @@ static void pwm_backlight_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bl = platform_get_drvdata(pdev);
 	struct pwm_bl_data *pb = bl_get_data(bl);
+	struct pwm_state state;
 
 	backlight_device_unregister(bl);
 	pwm_backlight_power_off(pb);
+	pwm_get_state(pb->pwm, &state);
+	state.duty_cycle = 0;
+	state.enabled = false;
+	pwm_apply_state(pb->pwm, &state);
 
 	if (pb->exit)
 		pb->exit(&pdev->dev);
@@ -638,8 +643,13 @@ static void pwm_backlight_shutdown(struct platform_device *pdev)
 {
 	struct backlight_device *bl = platform_get_drvdata(pdev);
 	struct pwm_bl_data *pb = bl_get_data(bl);
+	struct pwm_state state;
 
 	pwm_backlight_power_off(pb);
+	pwm_get_state(pb->pwm, &state);
+	state.duty_cycle = 0;
+	state.enabled = false;
+	pwm_apply_state(pb->pwm, &state);
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -647,12 +657,24 @@ static int pwm_backlight_suspend(struct device *dev)
 {
 	struct backlight_device *bl = dev_get_drvdata(dev);
 	struct pwm_bl_data *pb = bl_get_data(bl);
+	struct pwm_state state;
 
 	if (pb->notify)
 		pb->notify(pb->dev, 0);
 
 	pwm_backlight_power_off(pb);
 
+	/*
+	 * Note that disabling the PWM doesn't guarantee that the output stays
+	 * at its inactive state. However without the PWM disabled, the PWM
+	 * driver refuses to suspend. So disable here even though this might
+	 * enable the backlight on poorly designed boards.
+	 */
+	pwm_get_state(pb->pwm, &state);
+	state.duty_cycle = 0;
+	state.enabled = false;
+	pwm_apply_state(pb->pwm, &state);
+
 	if (pb->notify_after)
 		pb->notify_after(pb->dev, 0);
 
-- 
2.42.0



