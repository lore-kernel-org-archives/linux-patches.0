Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9C51DE4C7;
	Wed, 19 Feb 2025 08:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955053; cv=none; b=G6BqxmDyQGGAfzOfnS4oCdQvQzQfDqCKRKSF7LWVBUCdEbjjjkomv6eikvWukeybQ8HLA4+NexpbklsN5h9UrJTxhjG0Qb8QyidxaPaYyn79uZH1R9Qw/6E7rcUdgCiHLoItGeIsF8oD327fNv7HXow3Lw/6bd1w+uTDjJA8uf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955053; c=relaxed/simple;
	bh=4G0/R3hUV3Cr+t0ioNgd5jMbXKpuMLB0E7/eK5QOfEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyd8ulByeG+JUKPeyyRYq1sWJlP3J1KM7rinShntWoLllTvcpOXt4D6o8mzMWR3WQ6Z69mcM/EPxcVsnvp5dneUVwHNaqK61qI6oTxKKLLBKuV6175Lu19Zu/t2TqRAn+0sOwLsSMAHneliB7L1LrN44QxJ2ylC9XnPz1yFVY+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QJIH/Yvm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJIH/Yvm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C365C4CED1;
	Wed, 19 Feb 2025 08:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955052;
	bh=4G0/R3hUV3Cr+t0ioNgd5jMbXKpuMLB0E7/eK5QOfEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJIH/Yvm7FLoDKt0cstDe8YR1XyaaoPCcFNW4bVwtBGBrbXzeOqbuDVKrtxwwIop1
	 eXA09g4MryLkN3yL3r0iEWrSB+PYM3dBhWNeEB+lTyHXOa2hDYiQ+ElCqDcCb/jdqD
	 IefAhDIkmkUFhImOojBLCNovptwOXXcHrQYUkE3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.12 116/230] usb: core: fix pipe creation for get_bMaxPacketSize0
Date: Wed, 19 Feb 2025 09:27:13 +0100
Message-ID: <20250219082606.229176484@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4698,7 +4698,6 @@ void usb_ep0_reinit(struct usb_device *u
 EXPORT_SYMBOL_GPL(usb_ep0_reinit);
 
 #define usb_sndaddr0pipe()	(PIPE_CONTROL << 30)
-#define usb_rcvaddr0pipe()	((PIPE_CONTROL << 30) | USB_DIR_IN)
 
 static int hub_set_address(struct usb_device *udev, int devnum)
 {
@@ -4804,7 +4803,7 @@ static int get_bMaxPacketSize0(struct us
 	for (i = 0; i < GET_MAXPACKET0_TRIES; ++i) {
 		/* Start with invalid values in case the transfer fails */
 		buf->bDescriptorType = buf->bMaxPacketSize0 = 0;
-		rc = usb_control_msg(udev, usb_rcvaddr0pipe(),
+		rc = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				USB_REQ_GET_DESCRIPTOR, USB_DIR_IN,
 				USB_DT_DEVICE << 8, 0,
 				buf, size,


