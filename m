Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28FC1B6CFA;
	Wed, 19 Feb 2025 09:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955640; cv=none; b=q2JECuzjtXLtxEMAfqKigbfoE+Xkj+2NUns193k9ACfereca+vAlMOdJVkYeK4nSH/UqIAODHH2OQL2M1KdMrNhEW4tUDEKpttVRIeSy0rVvU2shkJi1KzgRo32Lk2Gdm7AeNY7Tz2uGLV2JEWBqmqyPPaGMVweOpjaMe0o3v9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955640; c=relaxed/simple;
	bh=sShCU01vbugzz7Fl4Mbwjy+aQi/kG293e89lMrTIhJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nUcj7/7k7D8DnvyRhjWt1vu2IpU/pRj4TPJw2vQKLIZTfZ76VoBrDQ4+zVC09WG+S7FFF5UKLmajsvpjCTe2kHosq12ccPrfA2hIywewWzF8r+C5EUGkSKRsNhVnxXFWTSozYCbVhUXcP+46Co7Bqni4f3lKZ5yAqLhAHDJwnUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p3C6QeIF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p3C6QeIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D8CC4CEE7;
	Wed, 19 Feb 2025 09:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955640;
	bh=sShCU01vbugzz7Fl4Mbwjy+aQi/kG293e89lMrTIhJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p3C6QeIFXhd9QweR4O5UHuE7w+yYYrqh7QA7MFILj8kp9IEoEHmiDx+tDHtGDjQqj
	 Vb5urnNaySmnKZlOAXuuPEkCsgT53Q2H7zgVJ/wMqTREhvi2KHs+Y/vyTd6Ka55KuW
	 r3ICKuLdFB85LnydwtOfalAw4bwv3E84OWkjYoR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.6 062/152] usb: core: fix pipe creation for get_bMaxPacketSize0
Date: Wed, 19 Feb 2025 09:27:55 +0100
Message-ID: <20250219082552.498971008@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4666,7 +4666,6 @@ void usb_ep0_reinit(struct usb_device *u
 EXPORT_SYMBOL_GPL(usb_ep0_reinit);
 
 #define usb_sndaddr0pipe()	(PIPE_CONTROL << 30)
-#define usb_rcvaddr0pipe()	((PIPE_CONTROL << 30) | USB_DIR_IN)
 
 static int hub_set_address(struct usb_device *udev, int devnum)
 {
@@ -4772,7 +4771,7 @@ static int get_bMaxPacketSize0(struct us
 	for (i = 0; i < GET_MAXPACKET0_TRIES; ++i) {
 		/* Start with invalid values in case the transfer fails */
 		buf->bDescriptorType = buf->bMaxPacketSize0 = 0;
-		rc = usb_control_msg(udev, usb_rcvaddr0pipe(),
+		rc = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				USB_REQ_GET_DESCRIPTOR, USB_DIR_IN,
 				USB_DT_DEVICE << 8, 0,
 				buf, size,


