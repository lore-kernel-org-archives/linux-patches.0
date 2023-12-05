Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801B16AA0;
	Tue,  5 Dec 2023 03:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bDdtrQFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F53AC433C7;
	Tue,  5 Dec 2023 03:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746393;
	bh=MTb27EVe7NMROLtocAPOoV/gavD1aWvKO9INNJIXpQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDdtrQFEPYrXoeysIJvCVehIu7+1/PNdrTb6v6/Kl4SV5qNNs1Y7LAOWpA6wpM7P0
	 d0dbGtWngME2M3jUfU0OdlKSy4FMYB2snhFwwFBBZGLQw+rF52qweyn3FqEhS0OBid
	 xgo56KG9sfrSHuHKRh6DyKvKFHksFEEJo+UnRAMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Johannes=20Pen=C3=9Fel?= <johannes.penssel@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 001/134] leds: class: Dont expose color sysfs entry
Date: Tue,  5 Dec 2023 12:14:33 +0900
Message-ID: <20231205031535.269478329@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 8f2244c9af245ff72185c0473827125ee6b2d1a5 upstream.

The commit c7d80059b086 ("leds: class: Store the color index in struct
led_classdev") introduced a new sysfs entry "color" that is commonly
created for the led classdev.  Unfortunately, this conflicts with the
"color" sysfs entry of already existing drivers such as Logitech HID
or System76 ACPI drivers.  The driver probe fails due to the conflict,
hence it leads to a severe regression with the missing keyboard, for
example.

This patch reverts partially the change in the commit above for
removing the led class color sysfs entries again for addressing the
regressions.  The newly introduced led_classdev.color field is kept as
it's already used by other driver.

Fixes: c7d80059b086 ("leds: class: Store the color index in struct led_classdev")
Reported-by: Johannes Penßel <johannes.penssel@gmail.com>
Closes: https://lore.kernel.org/r/b5646db3-acff-45aa-baef-df3f660486fb@gmail.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218045
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218155
Link: https://bugzilla.suse.com/show_bug.cgi?id=1217172
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20231121162359.9332-1-tiwai@suse.de
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-class-led |  9 ---------
 drivers/leds/led-class.c                  | 14 --------------
 2 files changed, 23 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-led b/Documentation/ABI/testing/sysfs-class-led
index b2ff0012c0f2..2e24ac3bd7ef 100644
--- a/Documentation/ABI/testing/sysfs-class-led
+++ b/Documentation/ABI/testing/sysfs-class-led
@@ -59,15 +59,6 @@ Description:
 		brightness. Reading this file when no hw brightness change
 		event has happened will return an ENODATA error.
 
-What:		/sys/class/leds/<led>/color
-Date:		June 2023
-KernelVersion:	6.5
-Description:
-		Color of the LED.
-
-		This is a read-only file. Reading this file returns the color
-		of the LED as a string (e.g: "red", "green", "multicolor").
-
 What:		/sys/class/leds/<led>/trigger
 Date:		March 2006
 KernelVersion:	2.6.17
diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 974b84f6bd6a..ba1be15cfd8e 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -75,19 +75,6 @@ static ssize_t max_brightness_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(max_brightness);
 
-static ssize_t color_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	const char *color_text = "invalid";
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-
-	if (led_cdev->color < LED_COLOR_ID_MAX)
-		color_text = led_colors[led_cdev->color];
-
-	return sysfs_emit(buf, "%s\n", color_text);
-}
-static DEVICE_ATTR_RO(color);
-
 #ifdef CONFIG_LEDS_TRIGGERS
 static BIN_ATTR(trigger, 0644, led_trigger_read, led_trigger_write, 0);
 static struct bin_attribute *led_trigger_bin_attrs[] = {
@@ -102,7 +89,6 @@ static const struct attribute_group led_trigger_group = {
 static struct attribute *led_class_attrs[] = {
 	&dev_attr_brightness.attr,
 	&dev_attr_max_brightness.attr,
-	&dev_attr_color.attr,
 	NULL,
 };
 
-- 
2.43.0



