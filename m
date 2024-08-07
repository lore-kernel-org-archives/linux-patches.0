Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9EF374CC;
	Wed,  7 Aug 2024 15:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043564; cv=none; b=kcDJFwZW29Za0JGKopRZizFO5jYmupivqfB/bNSCntsL/hDmEB/lzboCGcazz776C0hKlTlVuM6aSWhY2bmuO+de5TLtxqUsc7OI9owpO3PdxcJVcUlqQC2yh5UwNvYSCy05UrLxCCxZt9MCz+nYed+513tZ1TeODGnNpSi41OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043564; c=relaxed/simple;
	bh=yPRRlz8nMY37XOoZCnBO6LOkshXELDrg6wAYqvBuSrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S897gM1KUm6uAvoEH4DzW8y9I/CezF426lf9AvMQdr9gbvKbtDKCOrxHxvMDB1Jvs7sDmQ7VpKiyWdKEoT3UMhUxr5XWggqvlnZ6Qmp4gRDGFdvfcUe+iyKb8zjvM+sPAxlnvMDJyZ/MfY0+gRsKKW/HoY9smFvelXvg5ZQYb9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ex6rS2bT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ex6rS2bT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205EFC32781;
	Wed,  7 Aug 2024 15:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043564;
	bh=yPRRlz8nMY37XOoZCnBO6LOkshXELDrg6wAYqvBuSrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ex6rS2bTyRrTIlg94n/A4g7xtsV94P7QqP3NwUCS6tsGlRMUh8LNAWV2/+1FiNO4G
	 HqXdHh44ss0aBwa0y1l1KsvcrKkU+c1Fi5ejoWLrvI00lY82VlmcsUl8GE/VzSmw6M
	 D1T3bX4MR3GdKjpZmq5LVItJHVTM9JeBLL3KAagc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 17/86] leds: trigger: Store brightness set by led_trigger_event()
Date: Wed,  7 Aug 2024 16:59:56 +0200
Message-ID: <20240807150039.807319523@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



