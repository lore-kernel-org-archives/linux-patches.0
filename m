Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C7F17A2E8;
	Mon, 10 Mar 2025 18:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629638; cv=none; b=LZrUCVdlJNkxeHbCvS3vC2VY11aM8QTXKjmKauPIA+BMYSQHzZ6VDloBS/fC1ALC1KgpGUA7Y4ttUywHDqfC3iXuL46FT7I0J8GzRbAmmkoLpU9BmdcOl2Imd4bKDm6Xmg2iPEHOSELQYspXsOhhhi1aqoGBFqCpEVgPTEcF7Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629638; c=relaxed/simple;
	bh=NnyRAV8WItI7TkhKvDwZTAuClLpaSvmIGCQX7EE6Y6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F30ffyalEHjwIWktqmlg/qvyJpFJd2WW+ga0FaU8t40vlgJ2kD9Yeh5VPGsYsr4yqQRViRtX76KRLmAh5qYknZUEBeiBNJV2BX9RRBCBW9uup8v/MrUc70Ihr3RGZprPqnIm5BN0o/L/bXDC11NVaEcOFpPDQiQGyvqQC8WeSoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SbE7WBB7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SbE7WBB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82765C4CEE5;
	Mon, 10 Mar 2025 18:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629637;
	bh=NnyRAV8WItI7TkhKvDwZTAuClLpaSvmIGCQX7EE6Y6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SbE7WBB7pGnArlLZRJqbsq81m6hadQw0dsd5l0LmygOh22LYPowP1+1QkssK6wwni
	 5dl/2xTmLfwUl1T4ISl98MGZ93G4kjz5Vg4nEJyAFXAUfOfsc/KJ8mri45prjqnWpf
	 Nw/VKFPfrC98SEc5vsR8dxX54hUesIfrS7355fJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 364/620] usb: core: fix pipe creation for get_bMaxPacketSize0
Date: Mon, 10 Mar 2025 18:03:30 +0100
Message-ID: <20250310170559.974948177@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

commit 4aac0db5a0ebc599d4ad9bf5ebab78afa1f33e10 upstream.

When usb_control_msg is used in the get_bMaxPacketSize0 function, the
USB pipe does not include the endpoint device number. This can cause
failures when a usb hub port is reinitialized after encountering a bad
cable connection. As a result, the system logs the following error
messages:
usb usb2-port1: cannot reset (err = -32)
usb usb2-port1: Cannot enable. Maybe the USB cable is bad?
usb usb2-port1: attempt power cycle
usb 2-1: new high-speed USB device number 5 using ci_hdrc
usb 2-1: device descriptor read/8, error -71

The problem began after commit 85d07c556216 ("USB: core: Unite old
scheme and new scheme descriptor reads"). There
usb_get_device_descriptor was replaced with get_bMaxPacketSize0. Unlike
usb_get_device_descriptor, the get_bMaxPacketSize0 function uses the
macro usb_rcvaddr0pipe, which does not include the endpoint device
number. usb_get_device_descriptor, on the other hand, used the macro
usb_rcvctrlpipe, which includes the endpoint device number.

By modifying the get_bMaxPacketSize0 function to use usb_rcvctrlpipe
instead of usb_rcvaddr0pipe, the issue can be resolved. This change will
ensure that the endpoint device number is included in the USB pipe,
preventing reinitialization failures. If the endpoint has not set the
device number yet, it will still work because the device number is 0 in
udev.

Cc: stable <stable@kernel.org>
Fixes: 85d07c556216 ("USB: core: Unite old scheme and new scheme descriptor reads")
Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20250203105840.17539-1-eichest@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4636,7 +4636,6 @@ void usb_ep0_reinit(struct usb_device *u
 EXPORT_SYMBOL_GPL(usb_ep0_reinit);
 
 #define usb_sndaddr0pipe()	(PIPE_CONTROL << 30)
-#define usb_rcvaddr0pipe()	((PIPE_CONTROL << 30) | USB_DIR_IN)
 
 static int hub_set_address(struct usb_device *udev, int devnum)
 {
@@ -4737,7 +4736,7 @@ static int get_bMaxPacketSize0(struct us
 	for (i = 0; i < GET_MAXPACKET0_TRIES; ++i) {
 		/* Start with invalid values in case the transfer fails */
 		buf->bDescriptorType = buf->bMaxPacketSize0 = 0;
-		rc = usb_control_msg(udev, usb_rcvaddr0pipe(),
+		rc = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				USB_REQ_GET_DESCRIPTOR, USB_DIR_IN,
 				USB_DT_DEVICE << 8, 0,
 				buf, size,


