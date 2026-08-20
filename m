Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FDB361640;
	Thu, 20 Aug 2026 15:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238221; cv=none; b=D7bMH9fE78/GWpx2ECA/Pm97dcnRp4sgRgT761oSopCetpntsw4zJ5R1Z24a5htIU3lSsupjxTVfI3z780kuVG0wAB0MX414f55gC3h7FA5cqt5+b7FL9QFT6uggLDu30vq6s2gAWq+MTQejmCixaD5FhKyrnySGx3PAlkJmegA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238221; c=relaxed/simple;
	bh=O8s1vJ/q4jcHUrCDgj2Rtmdzgzu0U6ODyZITn7fGSDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Un12qJCarARIc5IsScTpZvyazxIvabYmTTHRGVpwfBA7k/V/xK7pXZjWm/Fgxjf2luTkMqDlSTQ7wvazBtNZDc4Nwxr+RfpcbhuGHj29hIi/7Hvdhv65CCBXT2jMNr1QQmkRS/73VNH85oBrcF/9gk8n6WIQOA5jZjEhRk9n7kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d09Efwie; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d09Efwie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB941F000E9;
	Thu, 20 Aug 2026 15:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238220;
	bh=2zhT+OsUEMtO17bBD1hNtHXtnuMqoi9RCYhcz3cVwxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d09EfwieTR8HNU4xTIEmzWm27Txjq4U2K7cfz4r8xPYVDGGWNwRahR6Zd5aFpNoJQ
	 bjJKfofLO1SAYI9cWwReK94DKjYd6umZo2utOyqCA+2zoxvxbARfSXtmnajL9FkSpf
	 yhTdMh88f9AEw1rnmmjO37gDL5P0cfAPhQ9YAguo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 073/228] Input: sur40 - fix input device registration ordering
Date: Thu, 20 Aug 2026 16:53:35 +0200
Message-ID: <20260820145246.684486790@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 9da976eb649c9e2f588a4499410e4d8af687925f upstream.

In sur40_probe(), input_register_device() was previously called early before
the V4L2 video device and vb2_queue components were fully initialized. If
userspace opened the input device immediately upon registration, sur40_open()
would trigger and start the sur40_poll() worker thread. This worker thread
invokes sur40_process_video() and accesses the uninitialized vb2_queue
structure, leading to a data race and potential system crash.

Furthermore, if V4L2 or video registration failed after input_register_device()
succeeded, the error path fell through to calling input_free_device() on a
successfully registered device instead of input_unregister_device(), corrupting
input core state.

Move input_register_device() to the very end of sur40_probe(). This ensures
the V4L2 and video queue structures are fully initialized before polling can
start, and naturally resolves the error path bug since input_free_device()
is now only called when input registration has not yet occurred.

To maintain strict LIFO (Last-In, First-Out) teardown ordering, also move
input_unregister_device() to the very beginning of sur40_disconnect(). This
guarantees that the input polling worker thread is stopped before V4L2
video components or control handlers are unregistered.

Reported-by: sashiko-bot@kernel.org
Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Link: https://patch.msgid.link/20260616051235.1549517-1-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/sur40.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -725,21 +725,13 @@ static int sur40_probe(struct usb_interf
 		goto err_free_input;
 	}
 
-	/* register the polled input device */
-	error = input_register_device(input);
-	if (error) {
-		dev_err(&interface->dev,
-			"Unable to register polled input device.");
-		goto err_free_buffer;
-	}
-
 	/* register the video master device */
 	snprintf(sur40->v4l2.name, sizeof(sur40->v4l2.name), "%s", DRIVER_LONG);
 	error = v4l2_device_register(sur40->dev, &sur40->v4l2);
 	if (error) {
 		dev_err(&interface->dev,
 			"Unable to register video master device.");
-		goto err_unreg_v4l2;
+		goto err_free_buffer;
 	}
 
 	/* initialize the lock and subdevice */
@@ -798,6 +790,14 @@ static int sur40_probe(struct usb_interf
 		goto err_unreg_video;
 	}
 
+	/* register the polled input device */
+	error = input_register_device(input);
+	if (error) {
+		dev_err(&interface->dev,
+			"Unable to register polled input device.");
+		goto err_unreg_video;
+	}
+
 	/* we can register the device now, as it is ready */
 	usb_set_intfdata(interface, sur40);
 	dev_dbg(&interface->dev, "%s is now attached\n", DRIVER_DESC);
@@ -823,11 +823,12 @@ static void sur40_disconnect(struct usb_
 {
 	struct sur40_state *sur40 = usb_get_intfdata(interface);
 
+	input_unregister_device(sur40->input);
+
 	v4l2_ctrl_handler_free(&sur40->hdl);
 	video_unregister_device(&sur40->vdev);
 	v4l2_device_unregister(&sur40->v4l2);
 
-	input_unregister_device(sur40->input);
 	kfree(sur40->bulk_in_buffer);
 	kfree(sur40);
 


