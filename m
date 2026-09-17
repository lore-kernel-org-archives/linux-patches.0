Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2584F4051;
	Thu, 17 Sep 2026 17:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664634; cv=none; b=on8oLsmNrGvkR3BCtCbuiWpnqXcYL+AXhPvmCiHjJ+iHahBMjeshePhLHSG4rfF4TcTR7smG8BiGERY8+pO7HyNDHUy7N/CFf9aTk8ua9E+KjURXf3juOLk2BJ4XGxad3v0Cc78d0YSfo8MzPZI+QtW/Q3VzppB2hZzOgWMXKfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664634; c=relaxed/simple;
	bh=nPhVfwCDoB+M57295mlxGQQswLCkijnmvlowBYlNwI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKeokzv1N5SRtYvUuIZbbTEzbwrvjW8S5H9I3LDPT+kpwUZQYntSiXimir14EbASSXqSf8Y94XvnANMTUn3kqgYJr5t4LbDCHqHRRN4TpRPsRpWLTDrnIXHQHn7tUHigw99vH4kigPFEeoTlcjdVD7xyANG/ZqAPFg75xo2AhgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itOMHN8P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itOMHN8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922AA1F0089A;
	Thu, 17 Sep 2026 17:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664633;
	bh=gw3C851JPmir1JjJE9jdkDkWAQe1fuSR/Tw2M5V4VkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=itOMHN8PVZI+zjz+CuHTxO7qfF6gmH6avX3t9+hDnpjvVuSaBf+BHy0OmDjPHNw2M
	 rYGhi9bBO2ZVC9oeGa/3N5ZERy/RrkZiLZizxWIMRFBQ1u2kqX94lwG3SbeV464hR0
	 x0RsR40DFCGe1Jo/eZf63f5sjRaSJ1eHZnFJ5Qmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Deiminger <tobias.deiminger@linutronix.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0430/1250] leds: pca9532: Dont stop blinking for non-zero brightness
Date: Thu, 17 Sep 2026 16:03:45 +0100
Message-ID: <20260917151603.673011313@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tobias Deiminger <tobias.deiminger@linutronix.de>

[ Upstream commit 0261683a4d31783d680e74b3ae5f22f6a62128cc ]

pca9532 unexpectedly stopped blinking when changing brightness to a
non-zero value. To reproduce:

 echo timer > /sys/class/leds/led-1/trigger   # blinks
 echo 255 > /sys/class/leds/led-1/brightness  # blinking stops, light on
 cat /sys/class/leds/led-1/trigger            # still claims [timer]

According to Documentation/leds/leds-class.rst, only brightness = 0
shall be a stop condition:

> You can change the brightness value of a LED independently of the
> timer trigger. However, if you set the brightness value to LED_OFF it
> will also disable the timer trigger.

Therefore add a guard to continue blinking when brightness != LED_OFF,
similar to how pca955x does it since 575f10dc64a2 ("leds: pca955x: Add
HW blink support").

Signed-off-by: Tobias Deiminger <tobias.deiminger@linutronix.de>
Link: https://patch.msgid.link/20260331202848.658676-1-tobias.deiminger@linutronix.de
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-pca9532.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index af141dec4b927..ba0fea0add2b7 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -182,11 +182,13 @@ static int pca9532_set_brightness(struct led_classdev *led_cdev,
 	int err = 0;
 	struct pca9532_led *led = ldev_to_led(led_cdev);
 
-	if (value == LED_OFF)
+	if (value == LED_OFF) {
 		led->state = PCA9532_OFF;
-	else if (value == LED_FULL)
+	} else if (led->state == PCA9532_PWM1) {
+		return 0; /* Non-zero brightness shall not stop HW blinking */
+	} else if (value == LED_FULL) {
 		led->state = PCA9532_ON;
-	else {
+	} else {
 		led->state = PCA9532_PWM0; /* Thecus: hardcode one pwm */
 		err = pca9532_calcpwm(led->client, PCA9532_PWM_ID_0, 0, value);
 		if (err)
-- 
2.53.0



