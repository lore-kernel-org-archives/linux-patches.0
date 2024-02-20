Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C131151CCC;
	Tue, 20 Feb 2024 21:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462817; cv=none; b=jSMAGbsRw1Kkbn5dsVGATnLXonSD7mxN4a3HEtEVYcSuZ/y230PE0wISOeG1P8ciKnPQplNTMtWabHt6dDWzHvMoh2v9RVp+lQCeQpSAo2UBaHJfPk1gLa78nQUruf0iCzrnVr6Bjs1ap1EQS3/YFFm1oRKizDRamQEfxHO775E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462817; c=relaxed/simple;
	bh=oIkUQEZCSEaIim3+0zyBEceR/00HPf/bSHUSax3xMMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZt006N7mva/UZcp98plvpR4dDtmNCmwlOGaVe1lOc7g9TKrAGfPJa37GhGa8bmzntJS5iIEvkMZuRxQ3RXo8npDGnBevjYhgojBimzJk8un6Qdcn3N0i/7kcdCbjRidWYkSv72thk7C2b1kc7jBAtQIw1M5guBPPnp+mEOAMgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cixwYdks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cixwYdks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DA8C43390;
	Tue, 20 Feb 2024 21:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462816;
	bh=oIkUQEZCSEaIim3+0zyBEceR/00HPf/bSHUSax3xMMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cixwYdkswRVVaNg5pNxna4jcUaosdaB5vixae4TpjVirjDOOPSq+WU/7b4x9IKL/H
	 F2x0m5ox6KmGiXBq8swidVWjV5zbNBSdGhpFxYpnJlh1A1NLN7f013QHsjL+YR4Vmi
	 LTn3AYOqhciRHIVCuNhmU4JtuRevDdEaYZ9+AzK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 046/197] HID: wacom: Do not register input devices until after hid_hw_start
Date: Tue, 20 Feb 2024 21:50:05 +0100
Message-ID: <20240220204842.459980126@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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
@@ -2379,6 +2398,20 @@ static int wacom_parse_and_register(stru
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
@@ -2393,16 +2426,6 @@ static int wacom_parse_and_register(stru
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


