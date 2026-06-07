Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7AA2D8378;
	Sun,  7 Jun 2026 10:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829372; cv=none; b=Gu09HamsO+kb3i20nrbVFWaFYPX2bkJ4QuepL9VqCTqqu3t2IaDnOja/RmrmwvacRzFV1krV29eIm8ewBazQffFxWfd3XEaUXLow3p9t6+F5CeT0zTcSVf53rMNR7ZSsiQcjQ6E1WD9V6vL8qXLcN7C5Y+HLFh/OpMV10cBpLt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829372; c=relaxed/simple;
	bh=CpSrGqFn0BDdQNRp8rvoK4TVF5f9V6Lhsbx1NX9T6+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRB85Ta/GftEAd8FEscYrIrzGprCjdWz+498fKyWiFxINa54KWsRVI3TbEw2IFk0Mi8E+B03sxRglEWf8PtA9TzV+lAxKG/nOSems16VOvihWKPEyVWpXTtJ8KICRdBF1vTV3FHltHJj9nbIE7Cvg3TSR4XykKk3aIg7gvrtvU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s0+V4ChJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s0+V4ChJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27581F00893;
	Sun,  7 Jun 2026 10:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829371;
	bh=PLMSSXBHpLnKO0ncEQ0SMjm1+8PLN2tcqo4jljUBM6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s0+V4ChJyRLLK1kNU3+W/mpxqO7knHNEFN8TqPEW55hk10uAxTxBXIV9xsBAIdVKw
	 YUkuNFB+UBBgRapS9Dw1EqJ3YtMWGVucB9YVGaMFkhtLU34MILnjM8b4Ee9URHlLSG
	 ehBvFPCUZYbmrGXoPoYMCQMb/peQgDPQHeNdZBp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Kai Aizen <kai.aizen.dev@gmail.com>
Subject: [PATCH 7.0 273/332] usb: gadget: uvc: hold opts->lock across XU walks in uvc_function_bind
Date: Sun,  7 Jun 2026 12:00:42 +0200
Message-ID: <20260607095738.072302244@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Aizen <kai.aizen.dev@gmail.com>

commit 68aa70648b625fa684bc0b71bbfd905f4943ca20 upstream.

uvc_function_bind() walks &opts->extension_units twice without holding
opts->lock:

  - directly, for the iExtension string-descriptor fixup loop;
  - indirectly, four times via uvc_copy_descriptors() (once per speed),
    where the helper iterates uvc->desc.extension_units (which aliases
    &opts->extension_units) to size and emit XU descriptors.

The configfs side (uvcg_extension_make / uvcg_extension_drop, in
drivers/usb/gadget/function/uvc_configfs.c) takes opts->lock around its
list_add_tail / list_del operations.  A privileged userspace process
that holds the configfs subtree open and writes the gadget UDC name
to bind the function while concurrently rmdir()'ing an extensions
subdir can race uvcg_extension_drop() against the bind-time list walks
and dereference a freed struct uvcg_extension.

Hold opts->lock from the start of the XU string-descriptor fixup
through the last uvc_copy_descriptors() call, releasing on the
descriptor-error path via a new error_unlock label that drops the
lock before falling through to the existing error label.  This
matches the locking discipline of the configfs callbacks and removes
the only remaining unsynchronised reader of the XU list during bind.

Reachability: only privileged processes that can mount configfs and
write to gadget UDC files can trigger the race, so this is a
correctness fix rather than a security boundary.

Fixes: 0525210c9840 ("usb: gadget: uvc: Allow definition of XUs in configfs")
Cc: stable <stable@kernel.org>
Signed-off-by: Kai Aizen <kai.aizen.dev@gmail.com>
Link: https://patch.msgid.link/20260430175643.67120-1-kai.aizen.dev@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uvc.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -769,6 +769,16 @@ uvc_function_bind(struct usb_configurati
 	uvc_ss_streaming_ep.bEndpointAddress = uvc->video.ep->address;
 
 	/*
+	 * Hold opts->lock across both the XU string-descriptor fixup below and
+	 * the descriptor-copy block further down.  Without this, configfs
+	 * uvcg_extension_drop() (which takes opts->lock) can race with the
+	 * list_for_each_entry() walks here and inside uvc_copy_descriptors(),
+	 * leading to a UAF on a freed struct uvcg_extension.  See
+	 * drivers/usb/gadget/function/uvc_configfs.c::uvcg_extension_drop().
+	 */
+	mutex_lock(&opts->lock);
+
+	/*
 	 * XUs can have an arbitrary string descriptor describing them. If they
 	 * have one pick up the ID.
 	 */
@@ -785,7 +795,7 @@ uvc_function_bind(struct usb_configurati
 				 ARRAY_SIZE(uvc_en_us_strings));
 	if (IS_ERR(us)) {
 		ret = PTR_ERR(us);
-		goto error;
+		goto error_unlock;
 	}
 
 	uvc_iad.iFunction = opts->iad_index ? cdev->usb_strings[opts->iad_index].id :
@@ -799,14 +809,14 @@ uvc_function_bind(struct usb_configurati
 
 	/* Allocate interface IDs. */
 	if ((ret = usb_interface_id(c, f)) < 0)
-		goto error;
+		goto error_unlock;
 	uvc_iad.bFirstInterface = ret;
 	uvc_control_intf.bInterfaceNumber = ret;
 	uvc->control_intf = ret;
 	opts->control_interface = ret;
 
 	if ((ret = usb_interface_id(c, f)) < 0)
-		goto error;
+		goto error_unlock;
 	uvc_streaming_intf_alt0.bInterfaceNumber = ret;
 	uvc_streaming_intf_alt1.bInterfaceNumber = ret;
 	uvc->streaming_intf = ret;
@@ -817,30 +827,32 @@ uvc_function_bind(struct usb_configurati
 	if (IS_ERR(f->fs_descriptors)) {
 		ret = PTR_ERR(f->fs_descriptors);
 		f->fs_descriptors = NULL;
-		goto error;
+		goto error_unlock;
 	}
 
 	f->hs_descriptors = uvc_copy_descriptors(uvc, USB_SPEED_HIGH);
 	if (IS_ERR(f->hs_descriptors)) {
 		ret = PTR_ERR(f->hs_descriptors);
 		f->hs_descriptors = NULL;
-		goto error;
+		goto error_unlock;
 	}
 
 	f->ss_descriptors = uvc_copy_descriptors(uvc, USB_SPEED_SUPER);
 	if (IS_ERR(f->ss_descriptors)) {
 		ret = PTR_ERR(f->ss_descriptors);
 		f->ss_descriptors = NULL;
-		goto error;
+		goto error_unlock;
 	}
 
 	f->ssp_descriptors = uvc_copy_descriptors(uvc, USB_SPEED_SUPER_PLUS);
 	if (IS_ERR(f->ssp_descriptors)) {
 		ret = PTR_ERR(f->ssp_descriptors);
 		f->ssp_descriptors = NULL;
-		goto error;
+		goto error_unlock;
 	}
 
+	mutex_unlock(&opts->lock);
+
 	/* Preallocate control endpoint request. */
 	uvc->control_req = usb_ep_alloc_request(cdev->gadget->ep0, GFP_KERNEL);
 	uvc->control_buf = kmalloc(UVC_MAX_REQUEST_SIZE, GFP_KERNEL);
@@ -872,6 +884,8 @@ uvc_function_bind(struct usb_configurati
 
 	return 0;
 
+error_unlock:
+	mutex_unlock(&opts->lock);
 v4l2_error:
 	v4l2_device_unregister(&uvc->v4l2_dev);
 error:


