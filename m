Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E6627054C;
	Tue, 11 Nov 2025 01:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823336; cv=none; b=a3SkxjxOpfEU6Nrgc6vet0kiU9gp9Go1S5Gh0uJRCqVBzJciQg8tTfxIZ6MWVZTYfBIupuAN8lAQ1uYERyJyXXgXsZ9okxRocg/5EQvgelVl84o54RUyT6oulZtgp/XWxr9ggP9zFn45HFSL3ncRPUHx66xCDOmy0R+Xa8yLVaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823336; c=relaxed/simple;
	bh=MOuqlRa4NpXvToIdF+npYmDSZsXmUoalQnTjuxzKIJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rqM1ipG9g5JN0Jse2MFD5+YHfYCFJJFWq3ntBNZJG113HDCZ2nj3iJBCW3qS9lDyRTlSiVnicmceVdS3GgidzL6Rk8DzgD5WfPyCFFGWRLhTauRG/jwKYHTI11PINWYUoTGo6wqI05qmV6guoLK+u8vX0bYmyDQwxq+MkYetR0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHfFl5oP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHfFl5oP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28EAFC116B1;
	Tue, 11 Nov 2025 01:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823336;
	bh=MOuqlRa4NpXvToIdF+npYmDSZsXmUoalQnTjuxzKIJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHfFl5oPPHdc8qCuSxMrWyRsEaoDmyAMs8dL/8QtrQUK6R3+NC+PYxspt7onIpT2D
	 edAZBBdO7k2wTbY7RFexfkCZhGPhBTx30mxBRLaAdX3hPcNzrDWgtDPrVWbYBSOiLy
	 oxyigiOfpPG31ObP6VZtHfXyyoKL/YBg6GyAOsdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Oleg Makarenko <oleg@makarenk.ooo>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 222/565] HID: pidff: Use direction fix only for conditional effects
Date: Tue, 11 Nov 2025 09:41:18 +0900
Message-ID: <20251111004531.917410871@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit f345a4798dab800159b09d088e7bdae0f16076c3 ]

The already fixed bug in SDL only affected conditional effects. This
should fix FFB in Forza Horizion 4/5 on Moza Devices as Forza Horizon
flips the constant force direction instead of using negative magnitude
values.

Changing the direction in the effect directly in pidff_upload_effect()
would affect it's value in further operations like comparing to the old
effect and/or just reading the effect values in the user application.

This, in turn, would lead to constant PID_SET_EFFECT spam as the effect
direction would constantly not match the value that's set by the
application.

This way, it's still transparent to any software/API.

Only affects conditional effects now so it's better for it to explicitly
state that in the name. If any HW ever needs fixed direction for other
effects, we'll add more quirks.

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Reviewed-by: Oleg Makarenko <oleg@makarenk.ooo>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-universal-pidff.c | 20 ++++++++++----------
 drivers/hid/usbhid/hid-pidff.c    | 28 +++++++++++++++++++++++-----
 drivers/hid/usbhid/hid-pidff.h    |  2 +-
 3 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/drivers/hid/hid-universal-pidff.c b/drivers/hid/hid-universal-pidff.c
index 5b89ec7b5c26c..dc1b262f28331 100644
--- a/drivers/hid/hid-universal-pidff.c
+++ b/drivers/hid/hid-universal-pidff.c
@@ -143,25 +143,25 @@ static int universal_pidff_input_configured(struct hid_device *hdev,
 
 static const struct hid_device_id universal_pidff_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MOZA, USB_DEVICE_ID_MOZA_R3),
-		.driver_data = HID_PIDFF_QUIRK_FIX_WHEEL_DIRECTION },
+		.driver_data = HID_PIDFF_QUIRK_FIX_CONDITIONAL_DIRECTION },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MOZA, USB_DEVICE_ID_MOZA_R3_2),
-		.driver_data = HID_PIDFF_QUIRK_FIX_WHEEL_DIRECTION },
+		.driver_data = HID_PIDFF_QUIRK_FIX_CONDITIONAL_DIRECTION },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MOZA, USB_DEVICE_ID_MOZA_R5),
-		.driver_data = HID_PIDFF_QUIRK_FIX_WHEEL_DIRECTION },
+		.driver_data = HID_PIDFF_QUIRK_FIX_CONDITIONAL_DIRECTION },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MOZA, USB_DEVICE_ID_MOZA_R5_2),
-		.driver_data = HID_PIDFF_QUIRK_FIX_WHEEL_DIRECTION },
+		.driver_data = HID_PIDFF_QUIRK_FIX_CONDITIONAL_DIRECTION },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MOZA, USB_DEVICE_ID_MOZA_R9),
-		.driver_data = HID_PIDFF_QUIRK_FIX_WHEEL_DIRECTION },
+		.driver_data = HID_PIDFF_QUIRK_FIX_CONDITIONAL_DIRECTION },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MOZA, USB_DEVICE_ID_MOZA_R9_2),
-		.driver_data = HID_PIDFF_QUIRK_FIX_WHEEL_DIRECTION },
+		.driver_data = HID_PIDFF_QUIRK_FIX_CONDITIONAL_DIRECTION },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MOZA, USB_DEVICE_ID_MOZA_R12),
-		.driver_data = HID_PIDFF_QUIRK_FIX_WHEEL_DIRECTION },
+		.driver_data = HID_PIDFF_QUIRK_FIX_CONDITIONAL_DIRECTION },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MOZA, USB_DEVICE_ID_MOZA_R12_2),
-		.driver_data = HID_PIDFF_QUIRK_FIX_WHEEL_DIRECTION },
+		.driver_data = HID_PIDFF_QUIRK_FIX_CONDITIONAL_DIRECTION },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MOZA, USB_DEVICE_ID_MOZA_R16_R21),
-		.driver_data = HID_PIDFF_QUIRK_FIX_WHEEL_DIRECTION },
+		.driver_data = HID_PIDFF_QUIRK_FIX_CONDITIONAL_DIRECTION },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MOZA, USB_DEVICE_ID_MOZA_R16_R21_2),
-		.driver_data = HID_PIDFF_QUIRK_FIX_WHEEL_DIRECTION },
+		.driver_data = HID_PIDFF_QUIRK_FIX_CONDITIONAL_DIRECTION },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CAMMUS, USB_DEVICE_ID_CAMMUS_C5) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CAMMUS, USB_DEVICE_ID_CAMMUS_C12) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_VRS, USB_DEVICE_ID_VRS_DFP),
diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index 8dfd2c554a276..0e60e4dc9e247 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -205,6 +205,14 @@ struct pidff_device {
 	u8 effect_count;
 };
 
+static int pidff_is_effect_conditional(struct ff_effect *effect)
+{
+	return effect->type == FF_SPRING  ||
+	       effect->type == FF_DAMPER  ||
+	       effect->type == FF_INERTIA ||
+	       effect->type == FF_FRICTION;
+}
+
 /*
  * Clamp value for a given field
  */
@@ -294,6 +302,20 @@ static void pidff_set_duration(struct pidff_usage *usage, u16 duration)
 	pidff_set_time(usage, duration);
 }
 
+static void pidff_set_effect_direction(struct pidff_device *pidff,
+				       struct ff_effect *effect)
+{
+	u16 direction = effect->direction;
+
+	/* Use fixed direction if needed */
+	if (pidff->quirks & HID_PIDFF_QUIRK_FIX_CONDITIONAL_DIRECTION &&
+	    pidff_is_effect_conditional(effect))
+		direction = PIDFF_FIXED_WHEEL_DIRECTION;
+
+	pidff->effect_direction->value[0] =
+		pidff_rescale(direction, U16_MAX, pidff->effect_direction);
+}
+
 /*
  * Send envelope report to the device
  */
@@ -394,11 +416,7 @@ static void pidff_set_effect_report(struct pidff_device *pidff,
 		pidff->set_effect[PID_GAIN].field->logical_maximum;
 	pidff->set_effect[PID_DIRECTION_ENABLE].value[0] = 1;
 
-	/* Use fixed direction if needed */
-	pidff->effect_direction->value[0] = pidff_rescale(
-		pidff->quirks & HID_PIDFF_QUIRK_FIX_WHEEL_DIRECTION ?
-		PIDFF_FIXED_WHEEL_DIRECTION : effect->direction,
-		U16_MAX, pidff->effect_direction);
+	pidff_set_effect_direction(pidff, effect);
 
 	/* Omit setting delay field if it's missing */
 	if (!(pidff->quirks & HID_PIDFF_QUIRK_MISSING_DELAY))
diff --git a/drivers/hid/usbhid/hid-pidff.h b/drivers/hid/usbhid/hid-pidff.h
index dda571e0a5bd3..e4ab05213ecac 100644
--- a/drivers/hid/usbhid/hid-pidff.h
+++ b/drivers/hid/usbhid/hid-pidff.h
@@ -17,7 +17,7 @@
 #define HID_PIDFF_QUIRK_PERMISSIVE_CONTROL	BIT(2)
 
 /* Use fixed 0x4000 direction during SET_EFFECT report upload */
-#define HID_PIDFF_QUIRK_FIX_WHEEL_DIRECTION	BIT(3)
+#define HID_PIDFF_QUIRK_FIX_CONDITIONAL_DIRECTION	BIT(3)
 
 /* Force all periodic effects to be uploaded as SINE */
 #define HID_PIDFF_QUIRK_PERIODIC_SINE_ONLY	BIT(4)
-- 
2.51.0



