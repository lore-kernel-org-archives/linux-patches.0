Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C68A3D96E
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/eLur/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B945C433C8;
	Wed, 15 Nov 2023 19:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078356;
	bh=cYQDfy+nssJTpkROZ6bQDI3+Ov2Ke7n8XgVBe+hQ350=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/eLur/E96bEzTLM/+goinqfCbPsswXrcxsf2l/mN7bnLBaCa1/To5H1c6us0cKSC
	 IdPTaX2/7ptIcsNc39va+mJ5N4QU1melUmTOG4AAoctOcUe6yO1++sGJog1mPKY0XY
	 xHR/KaiMp4Fl39rxSzqu4/sybNW4LyzjtQzkB068=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rogan Dawes <rogan@dawes.za.net>,
	Fabio Estevam <festevam@denx.de>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 248/379] leds: pwm: Dont disable the PWM when the LED should be off
Date: Wed, 15 Nov 2023 14:25:23 -0500
Message-ID: <20231115192659.804412924@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

[ Upstream commit 76fe464c8e64e71b2e4af11edeef0e5d85eeb6aa ]

Disabling a PWM (i.e. calling pwm_apply_state with .enabled = false)
gives no guarantees what the PWM output does. It might freeze where it
currently is, or go in a High-Z state or drive the active or inactive
state, it might even continue to toggle.

To ensure that the LED gets really disabled, don't disable the PWM even
when .duty_cycle is zero.

This fixes disabling a leds-pwm LED on i.MX28. The PWM on this SoC is
one of those that freezes its output on disable, so if you disable an
LED that is full on, it stays on. If you disable a LED with half
brightness it goes off in 50% of the cases and full on in the other 50%.

Fixes: 41c42ff5dbe2 ("leds: simple driver for pwm driven LEDs")
Reported-by: Rogan Dawes <rogan@dawes.za.net>
Reported-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Fabio Estevam <festevam@denx.de>
Link: https://lore.kernel.org/r/20230922192834.1695727-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-pwm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index cc892ecd52408..6d3e33e8b5f91 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -53,7 +53,7 @@ static int led_pwm_set(struct led_classdev *led_cdev,
 		duty = led_dat->pwmstate.period - duty;
 
 	led_dat->pwmstate.duty_cycle = duty;
-	led_dat->pwmstate.enabled = duty > 0;
+	led_dat->pwmstate.enabled = true;
 	return pwm_apply_state(led_dat->pwm, &led_dat->pwmstate);
 }
 
-- 
2.42.0



