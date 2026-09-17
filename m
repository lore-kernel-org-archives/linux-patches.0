Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99894FDA61;
	Thu, 17 Sep 2026 18:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668188; cv=none; b=ViovGWJwEo3CuGyEF4M88TgFA4Jg1+aGsU6LvaIg5GJVp8uEjWGMmY+6E8vfUwIQXe+L180MGVWdUSGuxSv6RoZWZyvQhLuxgZPGenZhgR5sse60Cjk8P3QdkfNejtep37A0x7dihM9jWW9cfDljK9fTtT1jKwqg6L2CrQvc1Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668188; c=relaxed/simple;
	bh=/cBu1P/ujOr3ngcSmOoJ9vgatV62qD/e4oLd7+Buric=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6/HoW7K/CyQeR89YB3U8Ofk7oKmgKgqzWevLYlju5j4J7J11i1QU+zjJFjZ9v9Z1N/qlxJ0kw9lbpZDPhLrd6k9RWXdr+i/e/fPN+ZIoI7TOrnK05hpjdHw+BUf4qOdlKwsgZ124VYZEVL/jRA8Hj/iEVnj+l/9imKr2eKdh1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gCJuxI+5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gCJuxI+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A74F1F000FF;
	Thu, 17 Sep 2026 18:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668186;
	bh=aGJKHo5cxE5GJQwPFsII1ENjeJ0HKcCazAOAWeBXHNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gCJuxI+5LQSqX1zx3WX/VqBH9owyon6kYdZQkJDGudPM59NulLmZlzBqhQEI+SZkv
	 1JuCe4ZQy+jI+o154EYSZLQdtEyViEkkcbCexxTji8pgmIgfpUUe/GrN2qZoGVDwI9
	 beacxJcbFSHR9OkcblUZzYHmppPRia8wE86DLalw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Deiminger <tobias.deiminger@linutronix.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0325/1102] leds: pca9532: Dont stop blinking for non-zero brightness
Date: Thu, 17 Sep 2026 16:04:28 +0100
Message-ID: <20260917151547.791769722@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4ecdfee14809f..e2c4aad89a7ca 100644
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



