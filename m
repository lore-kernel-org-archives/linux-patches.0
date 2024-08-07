Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716182AF07;
	Wed,  7 Aug 2024 15:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043336; cv=none; b=Qryt/Eki5Phxt6N7vJS/oxcFSf2csFIucKZRIAQXFHG3gWo8zuD8U5osGBTxGyAiCcVcue0jch5N6mpKdvOHf6VZvVNsGdGkrbnVr0uGkAJU6SJ2F5YbfhDXaQAuxXppkFHkX36XDfMjkFUCnzgzhAN9BzBz2nclX7QSEfJ9lH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043336; c=relaxed/simple;
	bh=ULQR64GHZFYVUyN69PjoDXC+syyjvEijkql0tnxQXJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2Vf7RQbrXmdIH+r/AzfhYll3OuJ8dG4iSzuV4Qt+kZiq4ysywbF/x/Uz/mQ/ThC32T3/Rcmuav1ntgKphImzMzMPbhXjQHI9OY4B+IiBD1dAj3UybbosLeCWkGKKlU8xuD1mj4cQxBK5C4POiLe1pRK8A5q/5R1P42Bv6+1Dso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0iFYMV/3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0iFYMV/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D69C32781;
	Wed,  7 Aug 2024 15:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043336;
	bh=ULQR64GHZFYVUyN69PjoDXC+syyjvEijkql0tnxQXJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0iFYMV/3PFgsulmIF4j6UMmJwabeZyMSK/BIuzG/DolrJ2eVsHggIHeEN4GXOnA8Y
	 pzTpnFw19K92POeMz3XGEINUvdZ2cDzxpxYfzNsKtVmYhcGgTKcK+H6aBGtoPXPse/
	 rzDzbCvjYq7JzXqj+oajMSg7GScamzzRwCQtn9bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/121] leds: trigger: Store brightness set by led_trigger_event()
Date: Wed,  7 Aug 2024 16:59:16 +0200
Message-ID: <20240807150020.133032468@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 081acf1f345b3..38f7896f374f6 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -194,11 +194,11 @@ int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
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
 
@@ -373,6 +373,8 @@ void led_trigger_event(struct led_trigger *trig,
 	if (!trig)
 		return;
 
+	trig->brightness = brightness;
+
 	rcu_read_lock();
 	list_for_each_entry_rcu(led_cdev, &trig->led_cdevs, trig_list)
 		led_set_brightness(led_cdev, brightness);
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 6a4973feecd65..d3056bc6f0a1a 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -474,6 +474,9 @@ struct led_trigger {
 	int		(*activate)(struct led_classdev *led_cdev);
 	void		(*deactivate)(struct led_classdev *led_cdev);
 
+	/* Brightness set by led_trigger_event */
+	enum led_brightness brightness;
+
 	/* LED-private triggers have this set */
 	struct led_hw_trigger_type *trigger_type;
 
@@ -527,6 +530,12 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
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
@@ -563,6 +572,12 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
 	return NULL;
 }
 
+static inline enum led_brightness
+led_trigger_get_brightness(const struct led_trigger *trigger)
+{
+	return LED_OFF;
+}
+
 #endif /* CONFIG_LEDS_TRIGGERS */
 
 /* Trigger specific enum */
-- 
2.43.0



