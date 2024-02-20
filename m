Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8E714A4D2;
	Tue, 20 Feb 2024 21:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464629; cv=none; b=XBCaImP0XpU8/1sUla34RC+P3akDs53mdEJr35AJo2UcHr+jlvJNR89rV+sME0yV+MHAzxCUx8fYU+0LwfxoCXRtwtN97pf9WUYvferDifBk9Xv7BGYebs2xw+wAf7hZCYnOHa7V6AK0gyRqPazIHdtS4aFYWYv+SLISOPCTsOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464629; c=relaxed/simple;
	bh=KyfJXqVzZGEFoKK6BPMIguYtr4lAnwl3pC3gyqRrEtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8Cf9jR7zakiDSQlFcwYa4we4hR+VHZuh49nnqfXrUaKimCLGI9O1ejAZvRICT7W5goEh6hirfah75nswLsPMLoKSA238V9hBnBjH/yTrT1QOOfshomH5slYMZtY4ujIeSDyahZJEHfClFsf6Cvzhmnoq24pE7OluVOwQXeaDz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lsV23YGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lsV23YGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2BAC433C7;
	Tue, 20 Feb 2024 21:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464629;
	bh=KyfJXqVzZGEFoKK6BPMIguYtr4lAnwl3pC3gyqRrEtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lsV23YGVi2UK3qTRV/MnNBVpm1UfNxWIjdAZdexLlImPxy4qEZCQwo9m+1Dcum98i
	 LxTZNumrG2V9YRPhqT8Enf9oyKnzB6TJo7AOkl6e7UDO7zqw2FrzbbT4KAFLmpHw9F
	 emlRjm+p0E8FKqzhr/9X9cl09ikTe3laliZI+X7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.7 085/309] HID: wacom: Do not register input devices until after hid_hw_start
Date: Tue, 20 Feb 2024 21:54:04 +0100
Message-ID: <20240220205635.857648152@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2080,7 +2080,7 @@ static int wacom_allocate_inputs(struct
 	return 0;
 }
 
-static int wacom_register_inputs(struct wacom *wacom)
+static int wacom_setup_inputs(struct wacom *wacom)
 {
 	struct input_dev *pen_input_dev, *touch_input_dev, *pad_input_dev;
 	struct wacom_wac *wacom_wac = &(wacom->wacom_wac);
@@ -2099,10 +2099,6 @@ static int wacom_register_inputs(struct
 		input_free_device(pen_input_dev);
 		wacom_wac->pen_input = NULL;
 		pen_input_dev = NULL;
-	} else {
-		error = input_register_device(pen_input_dev);
-		if (error)
-			goto fail;
 	}
 
 	error = wacom_setup_touch_input_capabilities(touch_input_dev, wacom_wac);
@@ -2111,10 +2107,6 @@ static int wacom_register_inputs(struct
 		input_free_device(touch_input_dev);
 		wacom_wac->touch_input = NULL;
 		touch_input_dev = NULL;
-	} else {
-		error = input_register_device(touch_input_dev);
-		if (error)
-			goto fail;
 	}
 
 	error = wacom_setup_pad_input_capabilities(pad_input_dev, wacom_wac);
@@ -2123,7 +2115,34 @@ static int wacom_register_inputs(struct
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
@@ -2376,6 +2395,20 @@ static int wacom_parse_and_register(stru
 	if (error)
 		goto fail;
 
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
@@ -2390,16 +2423,6 @@ static int wacom_parse_and_register(stru
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


