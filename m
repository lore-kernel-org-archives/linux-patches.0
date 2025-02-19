Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75292AE74;
	Wed, 19 Feb 2025 09:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957387; cv=none; b=MqxTADIKoQJz1ICkdXqo9oYOsp/pMFLJp5NsuJ9/CVPjTQNoMtfy0mwoP9q5GVtzuwwnyUK3s7Q2xPzl+pZ5MUYGj6ZgLFiA3TCzzF/6yPkbZfy8UNB6+sxECc5jSaqjbsFb8jt+eMliYInbKo5K+ozTkx4Oy54bVdYxD19J8ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957387; c=relaxed/simple;
	bh=arvPjKlLtSR3Wqbi1wkOBySWYcAgRSI7Wx1On1FkT9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQXsPXYAvG2epv2saIcmRMbhRy++R8zKYU/4bKhwZF1QNZJuAWQ9jVz2W5Mj57VFlhKoigEazcXma9N3015vP2mRnWrLKVKTyt0D3pXY1ktGqClAWZ+LYWyd2vREnxSbdj0aZ8JRV0DlTTzLhjGQruYD8t41hmkPz1CBGlIktqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjN6gjwy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjN6gjwy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CAEBC4CED1;
	Wed, 19 Feb 2025 09:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957387;
	bh=arvPjKlLtSR3Wqbi1wkOBySWYcAgRSI7Wx1On1FkT9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qjN6gjwyNqL6tuwx+5hypysTPgYeHPRtFDv8jKdt6M8VpqkVLqtRYUWXcinF78PLX
	 N1i9fcHSE1c29zO2OKjIVRelYjdFM3ohFJ5Os7UxABZOEX7QNTzu87+iXHaeLPPaRO
	 ImGEeuXUMNvJko474/778zi1oteScUXQqWX0j7Wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.1 508/578] usb: core: fix pipe creation for get_bMaxPacketSize0
Date: Wed, 19 Feb 2025 09:28:32 +0100
Message-ID: <20250219082712.968452003@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4651,7 +4651,6 @@ void usb_ep0_reinit(struct usb_device *u
 EXPORT_SYMBOL_GPL(usb_ep0_reinit);
 
 #define usb_sndaddr0pipe()	(PIPE_CONTROL << 30)
-#define usb_rcvaddr0pipe()	((PIPE_CONTROL << 30) | USB_DIR_IN)
 
 static int hub_set_address(struct usb_device *udev, int devnum)
 {
@@ -4757,7 +4756,7 @@ static int get_bMaxPacketSize0(struct us
 	for (i = 0; i < GET_MAXPACKET0_TRIES; ++i) {
 		/* Start with invalid values in case the transfer fails */
 		buf->bDescriptorType = buf->bMaxPacketSize0 = 0;
-		rc = usb_control_msg(udev, usb_rcvaddr0pipe(),
+		rc = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				USB_REQ_GET_DESCRIPTOR, USB_DIR_IN,
 				USB_DT_DEVICE << 8, 0,
 				buf, size,


