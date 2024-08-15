Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390911714A1;
	Thu, 15 Aug 2024 13:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730133; cv=none; b=R/BC7QWXH5uwjeuH/8/qzmPuvXD/2XWZGUOePkHV7Xf+SHgQoiBImsfbOfccDVSD132RjxBHPOOxd6XwteFHyBB2ElIHqGtHYiwXXUr0O7YGs9ETyGYDqotU+9GM8noOHE1iT4jN0lggfM5e926KAHeEaerhctGXkv52L4xmqbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730133; c=relaxed/simple;
	bh=/Xaxb8MLZMu7TaB7gnp/oDkO/KRfLBJl94etI2CEFjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCbH0gsNblfxVTEPwq+fVte9aS4kAuaYcksqY4A2IF7AKBbnh7gVwAvzZMxuu1dqBYO98iHuJdhjqyW9cuIuzcucuCO7Y1RJRb2KRZyIorKlijTqgmB9JYazOLZbmW7swK1Lh6KJDgtMmA2+O5Om4HYdw4ibq6xMNX71XVfle80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GLu2Ym/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLu2Ym/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F2CC32786;
	Thu, 15 Aug 2024 13:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730133;
	bh=/Xaxb8MLZMu7TaB7gnp/oDkO/KRfLBJl94etI2CEFjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLu2Ym/O88es8g1xM4MzSTZE+XEej2K9tadJRAydtfxklXN/9zWlejOp6skAspJUO
	 8A031M8A+vmCZ0RzN/86Lu3HtvmUq5kKD37WwUGwVKttenp4UE2syFqj9bcgnQz6wk
	 jQswj8EGbgk8kh3W2SP2Z5RYf9awQ19fEnXMGqls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 314/484] leds: trigger: Store brightness set by led_trigger_event()
Date: Thu, 15 Aug 2024 15:22:52 +0200
Message-ID: <20240815131953.532594428@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 822c91e72eac568ed8d83765634f00decb45666c ]

If a simple trigger is assigned to a LED, then the LED may be off until
the next led_trigger_event() call. This may be an issue for simple
triggers with rare led_trigger_event() calls, e.g. power supply
charging indicators (drivers/power/supply/power_supply_leds.c).
Therefore persist the brightness value of the last led_trigger_event()
call and use this value if the trigger is assigned to a LED.
In addition add a getter for the trigger brightness value.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/b1358b25-3f30-458d-8240-5705ae007a8a@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: ab477b766edd ("leds: triggers: Flush pending brightness before activating trigger")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-triggers.c |  6 ++++--
 include/linux/leds.h        | 15 +++++++++++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index dddfc301d3414..cdb446cb84af2 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -193,11 +193,11 @@ int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 		spin_unlock(&trig->leddev_list_lock);
 		led_cdev->trigger = trig;
 
+		ret = 0;
 		if (trig->activate)
 			ret = trig->activate(led_cdev);
 		else
-			ret = 0;
-
+			led_set_brightness(led_cdev, trig->brightness);
 		if (ret)
 			goto err_activate;
 
@@ -372,6 +372,8 @@ void led_trigger_event(struct led_trigger *trig,
 	if (!trig)
 		return;
 
+	trig->brightness = brightness;
+
 	rcu_read_lock();
 	list_for_each_entry_rcu(led_cdev, &trig->led_cdevs, trig_list)
 		led_set_brightness(led_cdev, brightness);
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 2bbff7519b731..79ab2dfd3c72f 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -356,6 +356,9 @@ struct led_trigger {
 	int		(*activate)(struct led_classdev *led_cdev);
 	void		(*deactivate)(struct led_classdev *led_cdev);
 
+	/* Brightness set by led_trigger_event */
+	enum led_brightness brightness;
+
 	/* LED-private triggers have this set */
 	struct led_hw_trigger_type *trigger_type;
 
@@ -409,6 +412,12 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
 	return led_cdev->trigger_data;
 }
 
+static inline enum led_brightness
+led_trigger_get_brightness(const struct led_trigger *trigger)
+{
+	return trigger ? trigger->brightness : LED_OFF;
+}
+
 #define module_led_trigger(__led_trigger) \
 	module_driver(__led_trigger, led_trigger_register, \
 		      led_trigger_unregister)
@@ -445,6 +454,12 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
 	return NULL;
 }
 
+static inline enum led_brightness
+led_trigger_get_brightness(const struct led_trigger *trigger)
+{
+	return LED_OFF;
+}
+
 #endif /* CONFIG_LEDS_TRIGGERS */
 
 /* Trigger specific functions */
-- 
2.43.0



