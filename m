Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5913081BA;
	Wed, 28 Jan 2026 15:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615918; cv=none; b=oOjmpeKnvys2ygXDig9Rfjq/6xIMmXqthxF2XaOvovtQf/CFXaEDfR4HszTTNvJ+Wn21Lh3xR6IHqiBILHkh4n58Dd5Xd/iiI6uuocYhB+gn2ORaYeJGyC5Wjm5sax/WAZ5Ox9tWZurcqChX9Bx43fSbXyNjEVcMlRiJJw00fpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615918; c=relaxed/simple;
	bh=acjSUe6s4OXQs6Y63e7tyoeKUjkLToLX8YkyNMAIBdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INsegt+mCrbYgkfM8BYOF8DhbRkxFA+XEG8u2AMYfMuT5wfPMN0w8bHVVSCDxlC16qPyZNqROYeVR5fi1Nq1qZECsU0bI9PH7zP8XEB3i+N9cOXbgx9KKuK0TbeKQTVvVL74LFwJQLrGiFwCIwfuQxbb1dyrUaT6lQtLKpPS/n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CA7NCz85; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CA7NCz85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7763EC4CEF7;
	Wed, 28 Jan 2026 15:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615918;
	bh=acjSUe6s4OXQs6Y63e7tyoeKUjkLToLX8YkyNMAIBdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CA7NCz85XpI9fHlPHln0CBW2SN0KqHAdM3rLPtfAQwewhhb1qbmTW9VS287EeINMd
	 fFWPkUXkbPNS7mFyBLdqjLJYcjl0xvOhIhwPjwX9N7dyeIWxUyFMkzg7LU1F6N1UHK
	 V2qaK8VSLUe+4/0K2LWPcXmUQAaK+m+JQu+SBUnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Sebastian Reichel <sre@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.18 152/227] leds: led-class: Only Add LED to leds_list when it is fully ready
Date: Wed, 28 Jan 2026 16:23:17 +0100
Message-ID: <20260128145349.924598294@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Hans de Goede <johannes.goede@oss.qualcomm.com>

commit d1883cefd31752f0504b94c3bcfa1f6d511d6e87 upstream.

Before this change the LED was added to leds_list before led_init_core()
gets called adding it the list before led_classdev.set_brightness_work gets
initialized.

This leaves a window where led_trigger_register() of a LED's default
trigger will call led_trigger_set() which calls led_set_brightness()
which in turn will end up queueing the *uninitialized*
led_classdev.set_brightness_work.

This race gets hit by the lenovo-thinkpad-t14s EC driver which registers
2 LEDs with a default trigger provided by snd_ctl_led.ko in quick
succession. The first led_classdev_register() causes an async modprobe of
snd_ctl_led to run and that async modprobe manages to exactly hit
the window where the second LED is on the leds_list without led_init_core()
being called for it, resulting in:

 ------------[ cut here ]------------
 WARNING: CPU: 11 PID: 5608 at kernel/workqueue.c:4234 __flush_work+0x344/0x390
 Hardware name: LENOVO 21N2S01F0B/21N2S01F0B, BIOS N42ET93W (2.23 ) 09/01/2025
 ...
 Call trace:
  __flush_work+0x344/0x390 (P)
  flush_work+0x2c/0x50
  led_trigger_set+0x1c8/0x340
  led_trigger_register+0x17c/0x1c0
  led_trigger_register_simple+0x84/0xe8
  snd_ctl_led_init+0x40/0xf88 [snd_ctl_led]
  do_one_initcall+0x5c/0x318
  do_init_module+0x9c/0x2b8
  load_module+0x7e0/0x998

Close the race window by moving the adding of the LED to leds_list to
after the led_init_core() call.

Cc: stable@vger.kernel.org
Fixes: d23a22a74fde ("leds: delay led_set_brightness if stopping soft-blink")
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Reviewed-by: Sebastian Reichel <sre@kernel.org>
Link: https://patch.msgid.link/20251211163727.366441-1-johannes.goede@oss.qualcomm.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/led-class.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -560,11 +560,6 @@ int led_classdev_register_ext(struct dev
 #ifdef CONFIG_LEDS_BRIGHTNESS_HW_CHANGED
 	led_cdev->brightness_hw_changed = -1;
 #endif
-	/* add to the list of leds */
-	down_write(&leds_list_lock);
-	list_add_tail(&led_cdev->node, &leds_list);
-	up_write(&leds_list_lock);
-
 	if (!led_cdev->max_brightness)
 		led_cdev->max_brightness = LED_FULL;
 
@@ -574,6 +569,11 @@ int led_classdev_register_ext(struct dev
 
 	led_init_core(led_cdev);
 
+	/* add to the list of leds */
+	down_write(&leds_list_lock);
+	list_add_tail(&led_cdev->node, &leds_list);
+	up_write(&leds_list_lock);
+
 #ifdef CONFIG_LEDS_TRIGGERS
 	led_trigger_set_default(led_cdev);
 #endif


