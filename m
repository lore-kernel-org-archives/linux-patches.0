Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381BB69953;
	Wed, 21 Feb 2024 13:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521780; cv=none; b=fqujh+MmIdd439W1gBAvAQOvD2tOJc2ygzjnNZrhnkpRM7Ik4RFrtW8TlkWYm+XAnZyWsqqcid2D5ttIYoVEayLmppEeVwEwZvWy81TxI3Xwka9EeAwGWDo5tR9zgDYBowOZ0+LfCWxD5p5T3w8UNo1o8OC6oaqNoguYpSHDrw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521780; c=relaxed/simple;
	bh=5ib4JnIUwPFAXiv6/detgWamKPEKiJ1xaYbnu4xpj70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBzcN0jsVSOLFjHXLVPMtCTilCiZxZhQDMrDHzwBeYBFrr3w1pcNVW8iT5E0TCk+RXe9Q4jPZM4SBH9oeO2kKBhQiOdn0g2C3n19zcGJafng2Vk0PpFqSQXNz60fiJQAp9OjyZ63QkGMIxFxeNxU1+PN0qNIdPpC5bWJmGX3f5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jN4/vjLE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jN4/vjLE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E3FC433C7;
	Wed, 21 Feb 2024 13:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521780;
	bh=5ib4JnIUwPFAXiv6/detgWamKPEKiJ1xaYbnu4xpj70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jN4/vjLEl0rZRL9CLzMolCUwu7x+oEhouHjtp6Bc/idm3qQUOCbUiZN9qBOXJmvQZ
	 Y1ZVkJvBXOwK/vvhu3/+NqV4FdQZJ9SjY/lbJ48rZ36Z1COD4uZFKd/wbaCd4TGSQk
	 X+dSvqFyRHcfNWDJymH1NGowoI+WURgLEfV5SHiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 4.19 176/202] HID: wacom: Do not register input devices until after hid_hw_start
Date: Wed, 21 Feb 2024 14:07:57 +0100
Message-ID: <20240221125937.520408623@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gerecke <killertofu@gmail.com>

commit c1d6708bf0d3dd976460d435373cf5abf21ce258 upstream.

If a input device is opened before hid_hw_start is called, events may
not be received from the hardware. In the case of USB-backed devices,
for example, the hid_hw_start function is responsible for filling in
the URB which is submitted when the input device is opened. If a device
is opened prematurely, polling will never start because the device will
not have been in the correct state to send the URB.

Because the wacom driver registers its input devices before calling
hid_hw_start, there is a window of time where a device can be opened
and end up in an inoperable state. Some ARM-based Chromebooks in particular
reliably trigger this bug.

This commit splits the wacom_register_inputs function into two pieces.
One which is responsible for setting up the allocated inputs (and runs
prior to hid_hw_start so that devices are ready for any input events
they may end up receiving) and another which only registers the devices
(and runs after hid_hw_start to ensure devices can be immediately opened
without issue). Note that the functions to initialize the LEDs and remotes
are also moved after hid_hw_start to maintain their own dependency chains.

Fixes: 7704ac937345 ("HID: wacom: implement generic HID handling for pen generic devices")
Cc: stable@vger.kernel.org # v3.18+
Suggested-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Tested-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_sys.c |   63 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 43 insertions(+), 20 deletions(-)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -2059,7 +2059,7 @@ static int wacom_allocate_inputs(struct
 	return 0;
 }
 
-static int wacom_register_inputs(struct wacom *wacom)
+static int wacom_setup_inputs(struct wacom *wacom)
 {
 	struct input_dev *pen_input_dev, *touch_input_dev, *pad_input_dev;
 	struct wacom_wac *wacom_wac = &(wacom->wacom_wac);
@@ -2078,10 +2078,6 @@ static int wacom_register_inputs(struct
 		input_free_device(pen_input_dev);
 		wacom_wac->pen_input = NULL;
 		pen_input_dev = NULL;
-	} else {
-		error = input_register_device(pen_input_dev);
-		if (error)
-			goto fail;
 	}
 
 	error = wacom_setup_touch_input_capabilities(touch_input_dev, wacom_wac);
@@ -2090,10 +2086,6 @@ static int wacom_register_inputs(struct
 		input_free_device(touch_input_dev);
 		wacom_wac->touch_input = NULL;
 		touch_input_dev = NULL;
-	} else {
-		error = input_register_device(touch_input_dev);
-		if (error)
-			goto fail;
 	}
 
 	error = wacom_setup_pad_input_capabilities(pad_input_dev, wacom_wac);
@@ -2102,7 +2094,34 @@ static int wacom_register_inputs(struct
 		input_free_device(pad_input_dev);
 		wacom_wac->pad_input = NULL;
 		pad_input_dev = NULL;
-	} else {
+	}
+
+	return 0;
+}
+
+static int wacom_register_inputs(struct wacom *wacom)
+{
+	struct input_dev *pen_input_dev, *touch_input_dev, *pad_input_dev;
+	struct wacom_wac *wacom_wac = &(wacom->wacom_wac);
+	int error = 0;
+
+	pen_input_dev = wacom_wac->pen_input;
+	touch_input_dev = wacom_wac->touch_input;
+	pad_input_dev = wacom_wac->pad_input;
+
+	if (pen_input_dev) {
+		error = input_register_device(pen_input_dev);
+		if (error)
+			goto fail;
+	}
+
+	if (touch_input_dev) {
+		error = input_register_device(touch_input_dev);
+		if (error)
+			goto fail;
+	}
+
+	if (pad_input_dev) {
 		error = input_register_device(pad_input_dev);
 		if (error)
 			goto fail;
@@ -2352,6 +2371,20 @@ static int wacom_parse_and_register(stru
 			goto fail;
 	}
 
+	error = wacom_setup_inputs(wacom);
+	if (error)
+		goto fail;
+
+	if (features->type == HID_GENERIC)
+		connect_mask |= HID_CONNECT_DRIVER;
+
+	/* Regular HID work starts now */
+	error = hid_hw_start(hdev, connect_mask);
+	if (error) {
+		hid_err(hdev, "hw start failed\n");
+		goto fail;
+	}
+
 	error = wacom_register_inputs(wacom);
 	if (error)
 		goto fail;
@@ -2366,16 +2399,6 @@ static int wacom_parse_and_register(stru
 			goto fail;
 	}
 
-	if (features->type == HID_GENERIC)
-		connect_mask |= HID_CONNECT_DRIVER;
-
-	/* Regular HID work starts now */
-	error = hid_hw_start(hdev, connect_mask);
-	if (error) {
-		hid_err(hdev, "hw start failed\n");
-		goto fail;
-	}
-
 	if (!wireless) {
 		/* Note that if query fails it is not a hard failure */
 		wacom_query_tablet_data(wacom);


