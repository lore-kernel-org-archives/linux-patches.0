Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8567245BE4
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 22:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e59068ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37EF7C433C9;
	Wed, 15 Nov 2023 22:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700085811;
	bh=26590lgEHnRIl0ZgpdSA86JGhxmdOm88P6jLm+c02FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e59068otdUvr4ax1PkwNyi7mV6esnBYz+mXvltU4pA9e44H86LzpYlUQrY2ldrxcU
	 CX2dANIYbSs/u1/QCQkjai7ltXtm0lqp80n+xcM/knQvyrUe7WDKptM1oVpn10MFkZ
	 woA9QnNx1428VNVS9hWU/D05fAMJgDEYY+gt1wZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>,
	Jeff LaBundy <jeff@labundy.com>,
	Pavel Machek <pavel@ucw.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/119] leds: pwm: convert to atomic PWM API
Date: Wed, 15 Nov 2023 17:00:58 -0500
Message-ID: <20231115220134.744213580@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115220132.607437515@linuxfoundation.org>
References: <20231115220132.607437515@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <uwe@kleine-koenig.org>

[ Upstream commit dd47a83453e4a5b0d6a91fe702b7fbc1984fb610 ]

pwm_config(), pwm_enable() and pwm_disable() should get removed in the
long run. So update the driver to use the atomic API that is here to
stay.

A few side effects:

 - led_pwm_set() now returns an error when setting the PWM fails.
 - During .probe() the PWM isn't disabled implicitly by pwm_apply_args()
   any more.

Signed-off-by: Uwe Kleine-König <uwe@kleine-koenig.org>
Tested-by: Jeff LaBundy <jeff@labundy.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Stable-dep-of: 76fe464c8e64 ("leds: pwm: Don't disable the PWM when the LED should be off")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-pwm.c | 41 +++++++++--------------------------------
 1 file changed, 9 insertions(+), 32 deletions(-)

diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index b72fd89ff3903..9111cdede0eee 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -22,9 +22,8 @@
 struct led_pwm_data {
 	struct led_classdev	cdev;
 	struct pwm_device	*pwm;
+	struct pwm_state	pwmstate;
 	unsigned int		active_low;
-	unsigned int		period;
-	int			duty;
 };
 
 struct led_pwm_priv {
@@ -32,44 +31,29 @@ struct led_pwm_priv {
 	struct led_pwm_data leds[0];
 };
 
-static void __led_pwm_set(struct led_pwm_data *led_dat)
-{
-	int new_duty = led_dat->duty;
-
-	pwm_config(led_dat->pwm, new_duty, led_dat->period);
-
-	if (new_duty == 0)
-		pwm_disable(led_dat->pwm);
-	else
-		pwm_enable(led_dat->pwm);
-}
-
 static int led_pwm_set(struct led_classdev *led_cdev,
 		       enum led_brightness brightness)
 {
 	struct led_pwm_data *led_dat =
 		container_of(led_cdev, struct led_pwm_data, cdev);
 	unsigned int max = led_dat->cdev.max_brightness;
-	unsigned long long duty =  led_dat->period;
+	unsigned long long duty = led_dat->pwmstate.period;
 
 	duty *= brightness;
 	do_div(duty, max);
 
 	if (led_dat->active_low)
-		duty = led_dat->period - duty;
-
-	led_dat->duty = duty;
-
-	__led_pwm_set(led_dat);
+		duty = led_dat->pwmstate.period - duty;
 
-	return 0;
+	led_dat->pwmstate.duty_cycle = duty;
+	led_dat->pwmstate.enabled = duty > 0;
+	return pwm_apply_state(led_dat->pwm, &led_dat->pwmstate);
 }
 
 static int led_pwm_add(struct device *dev, struct led_pwm_priv *priv,
 		       struct led_pwm *led, struct fwnode_handle *fwnode)
 {
 	struct led_pwm_data *led_data = &priv->leds[priv->num_leds];
-	struct pwm_args pargs;
 	int ret;
 
 	led_data->active_low = led->active_low;
@@ -93,17 +77,10 @@ static int led_pwm_add(struct device *dev, struct led_pwm_priv *priv,
 
 	led_data->cdev.brightness_set_blocking = led_pwm_set;
 
-	/*
-	 * FIXME: pwm_apply_args() should be removed when switching to the
-	 * atomic PWM API.
-	 */
-	pwm_apply_args(led_data->pwm);
-
-	pwm_get_args(led_data->pwm, &pargs);
+	pwm_init_state(led_data->pwm, &led_data->pwmstate);
 
-	led_data->period = pargs.period;
-	if (!led_data->period)
-		led_data->period = led->pwm_period_ns;
+	if (!led_data->pwmstate.period)
+		led_data->pwmstate.period = led->pwm_period_ns;
 
 	ret = devm_led_classdev_register(dev, &led_data->cdev);
 	if (ret == 0) {
-- 
2.42.0



