Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A105111B7;
	Wed, 30 Sep 2026 16:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784634; cv=none; b=Ho7DDyYEvH2+s4uTkKifHKwHoQ9VZUS/jr4qV/GkJKclLTqPBYzsBXzvbJjUbFKAqn5vXS/7HxG4VjGROlduStOxiz0tU3W6LKcYU36vh7Ma1JxY+FHKQ59yQd1UWG4de+YaK4UbrLd289fzjYNGy48JXsjnj/XEcOIqZuo12G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784634; c=relaxed/simple;
	bh=zG0qRkN1p/9od+lEMDtoYzPTv18+TGTZkbcQJHAE9Fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZr0P6ag/w3/DHvxg9WMRO/HVEKp6ke8ZDLuQIwbzjwS4dFblU1mTblVtFsA1c7oX6rShpsGYyFxAuk0LvfmnOYP1mmOfWvKET/p6704Kimp5vBSfIg+cJDLuFNqdSBcumy+Bmj/KkrxdXKa9G6qKaO19nam/gGZz34ouf1FHxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1rFbQB0A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1rFbQB0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9F61F0089B;
	Wed, 30 Sep 2026 16:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784629;
	bh=VfO+bOTb5/E7govTw41iL1JL2kWW/eM5nzDPoiXO2Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1rFbQB0AxVQykKhyQ9HmVCWzBenU2ov/pQSrOUdpN4nP2iWugHDIgfKz+000FHUN+
	 n8T/bzew5pOtPN37wuFrna2xoctnUsYJWUPibJ6gdQNNEvBeji8Le07zKPWtCztdWA
	 zwdeEG169x1/yPM8q0ITs+2u16CZyzLMDMigLZaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Deiminger <tobias.deiminger@linutronix.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 206/982] leds: pca9532: Dont stop blinking for non-zero brightness
Date: Wed, 30 Sep 2026 17:15:42 +0200
Message-ID: <20260930152421.234758710@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 40abb7eb033b9..b518b40099677 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -177,11 +177,13 @@ static int pca9532_set_brightness(struct led_classdev *led_cdev,
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
 		err = pca9532_calcpwm(led->client, 0, 0, value);
 		if (err)
-- 
2.53.0



