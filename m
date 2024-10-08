Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FF01DEFEA;
	Tue,  8 Oct 2024 12:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390294; cv=none; b=H1Avqguur1mBbZviFRI8HnYLDAnEzfq9LkgMFU98hXjm2bYyx0f5dLGqZReQmFFZvY3CNLu3lJfQilauFew4tLksyahGE1K7K5XAIGhAQPjK15fTOHO+yef1rMauDD1JQ7Bd3sDMVajsm706xIiEsKDzPd/7zGD4duTALmcZsb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390294; c=relaxed/simple;
	bh=06B3k5gdv5IdE7k7jcor34XygFYuh493WMu4K9fOVL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNIy06ZznvRpTFU0Mhuu5qq/VQzNTvgZxedsoh72UnaWlKB8AOmiUZpQba8evIyoXoiR/m3/p7NtWMrUOIO/seBz1C+kuibtjFeoqBShPxg3bRpA6b5ucD1XNjibPDvyCY6uJBA7ps8NNlAVfSrc6p50qWBprdHFSQJ2Ns6jiQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2K10XI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2K10XI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3738C4CEC7;
	Tue,  8 Oct 2024 12:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390294;
	bh=06B3k5gdv5IdE7k7jcor34XygFYuh493WMu4K9fOVL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2K10XI7IJv6rQxaTf7g8D4qobpTxEqIGLDVVTW5cd38o4ZIED0miBZE/R7o/9JGP
	 IHkHS66GklUB7kYZpYd1HDkkve1OqDo+MAkMytyIWFCGbbch9WMgyHiWrd8rljcWOt
	 6Gw3d+d99g7the/KRCPncvafm3U33W5IGz6mwkfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 248/482] platform/x86: x86-android-tablets: Adjust Xiaomi Pad 2 bottom bezel touch buttons LED
Date: Tue,  8 Oct 2024 14:05:11 +0200
Message-ID: <20241008115658.053344391@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit df40a23cc34c200cfde559eda7ca540f3ae7bd9e ]

The "input-events" LED trigger used to turn on the backlight LEDs had to
be rewritten to use led_trigger_register_simple() + led_trigger_event()
to fix a serious locking issue.

This means it no longer supports using blink_brightness to set a per LED
brightness for the trigger and it no longer sets LED_CORE_SUSPENDRESUME.

Adjust the MiPad 2 bottom bezel touch buttons LED class device to match:

1. Make LED_FULL the maximum brightness to fix the LED brightness
   being very low when on.
2. Set flags = LED_CORE_SUSPENDRESUME.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240916090255.35548-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/x86-android-tablets/other.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/x86-android-tablets/other.c b/drivers/platform/x86/x86-android-tablets/other.c
index eb0e55c69dfed..2549c348c8825 100644
--- a/drivers/platform/x86/x86-android-tablets/other.c
+++ b/drivers/platform/x86/x86-android-tablets/other.c
@@ -670,7 +670,7 @@ static const struct software_node *ktd2026_node_group[] = {
  * is controlled by the "pwm_soc_lpss_2" PWM output.
  */
 #define XIAOMI_MIPAD2_LED_PERIOD_NS		19200
-#define XIAOMI_MIPAD2_LED_DEFAULT_DUTY		 6000 /* From Android kernel */
+#define XIAOMI_MIPAD2_LED_MAX_DUTY_NS		 6000 /* From Android kernel */
 
 static struct pwm_device *xiaomi_mipad2_led_pwm;
 
@@ -679,7 +679,7 @@ static int xiaomi_mipad2_brightness_set(struct led_classdev *led_cdev,
 {
 	struct pwm_state state = {
 		.period = XIAOMI_MIPAD2_LED_PERIOD_NS,
-		.duty_cycle = val,
+		.duty_cycle = XIAOMI_MIPAD2_LED_MAX_DUTY_NS * val / LED_FULL,
 		/* Always set PWM enabled to avoid the pin floating */
 		.enabled = true,
 	};
@@ -701,11 +701,11 @@ static int __init xiaomi_mipad2_init(struct device *dev)
 		return -ENOMEM;
 
 	led_cdev->name = "mipad2:white:touch-buttons-backlight";
-	led_cdev->max_brightness = XIAOMI_MIPAD2_LED_PERIOD_NS;
-	/* "input-events" trigger uses blink_brightness */
-	led_cdev->blink_brightness = XIAOMI_MIPAD2_LED_DEFAULT_DUTY;
+	led_cdev->max_brightness = LED_FULL;
 	led_cdev->default_trigger = "input-events";
 	led_cdev->brightness_set_blocking = xiaomi_mipad2_brightness_set;
+	/* Turn LED off during suspend */
+	led_cdev->flags = LED_CORE_SUSPENDRESUME;
 
 	ret = devm_led_classdev_register(dev, led_cdev);
 	if (ret)
-- 
2.43.0



