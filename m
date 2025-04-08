Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B7F26A1C3;
	Tue,  8 Apr 2025 11:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111528; cv=none; b=QdG6uvO9UQv6syNF3ZScuRHmL1Y7Yrz1eMoSmgCJL1umrDAXBx8N6QJW9lgZhWzGstAcPf6at3+sdVmv56QcQZJxXchz19+167ttF2RoBZt0LmDng60urqR45Xr2HGdIy1zF6q2w3OrsdG9pzTWMxhUGxejWNFM54q7lNrlgg3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111528; c=relaxed/simple;
	bh=kgOwGHJU80Wm+hxrGY8nH/gort+K7UXfd2bzjzTrciM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kcHJk+1RsZ/bOiyeO4vCXKzWP5ZbL0a0Jpy1Cjmz/+TYkpNHoiguUiNBkzKVWtrMc+9IHyUFhI7/467L3ean7gLBrMEUC7WPdpnb9czkZd3piZ8TZNlM98S5ueXRVXncCINmFkHiC0yv2dNS8Jzzx7ox4l+PAKi7PFrZr33CASs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vsogl6H5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vsogl6H5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A857AC4CEE5;
	Tue,  8 Apr 2025 11:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111527;
	bh=kgOwGHJU80Wm+hxrGY8nH/gort+K7UXfd2bzjzTrciM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vsogl6H5I3DkpLp4u52MP7RKiq9shLv2lsW2mr/984xp/7FwsVtkglL7stANWpIJG
	 /v7slqFsiRfPBDYPQhqHnAbcdbbUTpkrrMK7DsXN3qllrAQFxrWZ8xBBfs6nZd60Z7
	 fmd89SE52s+bDuKY7j6of7yWX6wQkJe8W33YntKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Remi Pommarel <repk@triplefau.lt>,
	Hans de Goede <hdegoede@redhat.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 426/731] leds: Fix LED_OFF brightness race
Date: Tue,  8 Apr 2025 12:45:23 +0200
Message-ID: <20250408104924.183575414@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Remi Pommarel <repk@triplefau.lt>

[ Upstream commit 2c70953b6f535f7698ccbf22c1f5ba26cb6c2816 ]

While commit fa15d8c69238 ("leds: Fix set_brightness_delayed() race")
successfully forces led_set_brightness() to be called with LED_OFF at
least once when switching from blinking to LED on state so that
hw-blinking can be disabled, another race remains. Indeed in
led_set_brightness(LED_OFF) followed by led_set_brightness(any)
scenario the following CPU scheduling can happen:

    CPU0                                     CPU1
    ----                                     ----
 set_brightness_delayed() {
   test_and_clear_bit(BRIGHTNESS_OFF)
                                         led_set_brightness(LED_OFF) {
                                           set_bit(BRIGHTNESS_OFF)
					   queue_work()
                                         }
                                         led_set_brightness(any) {
                                           set_bit(BRIGHTNESS)
					   queue_work() //already queued
                                         }
   test_and_clear_bit(BRIGHTNESS)
     /* LED set with brightness any */
 }

 /* From previous CPU1 queue_work() */
 set_brightness_delayed() {
   test_and_clear_bit(BRIGHTNESS_OFF)
     /* LED turned off */
   test_and_clear_bit(BRIGHTNESS)
     /* Clear from previous run, LED remains off */

In that case the led_set_brightness(LED_OFF)/led_set_brightness(any)
sequence will be effectively executed in reverse order and LED will
remain off.

With the introduction of commit 32360bf6a5d4 ("leds: Introduce ordered
workqueue for LEDs events instead of system_wq") the race is easier to
trigger as sysfs brightness configuration does not wait for
set_brightness_delayed() work to finish (flush_work() removal).

Use delayed_set_value to optionnally re-configure brightness after a
LED_OFF. That way a LED state could be configured more that once but
final state will always be as expected. Ensure that delayed_set_value
modification is seen before set_bit() using smp_mb__before_atomic().

Fixes: fa15d8c69238 ("leds: Fix set_brightness_delayed() race")
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/19c81177059dab7b656c42063958011a8e4d1a66.1740050412.git.repk@triplefau.lt
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-core.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
index f6c46d2e5276b..e3d8ddcff5670 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -159,8 +159,19 @@ static void set_brightness_delayed(struct work_struct *ws)
 	 * before this work item runs once. To make sure this works properly
 	 * handle LED_SET_BRIGHTNESS_OFF first.
 	 */
-	if (test_and_clear_bit(LED_SET_BRIGHTNESS_OFF, &led_cdev->work_flags))
+	if (test_and_clear_bit(LED_SET_BRIGHTNESS_OFF, &led_cdev->work_flags)) {
 		set_brightness_delayed_set_brightness(led_cdev, LED_OFF);
+		/*
+		 * The consecutives led_set_brightness(LED_OFF),
+		 * led_set_brightness(LED_FULL) could have been executed out of
+		 * order (LED_FULL first), if the work_flags has been set
+		 * between LED_SET_BRIGHTNESS_OFF and LED_SET_BRIGHTNESS of this
+		 * work. To avoid ending with the LED turned off, turn the LED
+		 * on again.
+		 */
+		if (led_cdev->delayed_set_value != LED_OFF)
+			set_bit(LED_SET_BRIGHTNESS, &led_cdev->work_flags);
+	}
 
 	if (test_and_clear_bit(LED_SET_BRIGHTNESS, &led_cdev->work_flags))
 		set_brightness_delayed_set_brightness(led_cdev, led_cdev->delayed_set_value);
@@ -331,10 +342,13 @@ void led_set_brightness_nopm(struct led_classdev *led_cdev, unsigned int value)
 	 * change is done immediately afterwards (before the work runs),
 	 * it uses a separate work_flag.
 	 */
-	if (value) {
-		led_cdev->delayed_set_value = value;
+	led_cdev->delayed_set_value = value;
+	/* Ensure delayed_set_value is seen before work_flags modification */
+	smp_mb__before_atomic();
+
+	if (value)
 		set_bit(LED_SET_BRIGHTNESS, &led_cdev->work_flags);
-	} else {
+	else {
 		clear_bit(LED_SET_BRIGHTNESS, &led_cdev->work_flags);
 		clear_bit(LED_SET_BLINK, &led_cdev->work_flags);
 		set_bit(LED_SET_BRIGHTNESS_OFF, &led_cdev->work_flags);
-- 
2.39.5



