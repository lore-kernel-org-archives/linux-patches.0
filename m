Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704866;
	b=US0tmAStX/RHw/FgDQ5oK+y3jDTRz6L6B6+3DiNnw7rRmfVY4jISDko47g6wRspAKzpj
	 YUr3q43hp+ELoSUSuaolDe9gicUnNVRjtn4KhcFAugeg6Y7Jg8s74F/A5Hdio5lO14Kjt
	 SEoE6ihiqCcoziZDAEP9qKSuZTE2ykMuGTrEXlslK2J9j20G8d6q/4jUIrSFUwNQRD7Dz
	 xO02dkfyb3pUsHg8aaQ44z9+mAZSms4M472YrxO2uDCKFl0MVDwPPldWKeKAcdyb88b3l
	 vxd3VMj/PAO/kCVHx249fKa1oBiIkcONaNSGlkHiqUgE/ePXE/johoqAE5SwdljOahA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704866;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cFBWD5cdaWMxD2OkQQZnxcrgCc3bkBKB4NaYmVfjUck=;
	b=A4LgP1IovY22mWE97fR8MqLoQz9Ns2mmIqcwG77C1qWRCXH//V2Pd6i+8e+7fwr3i760
	 NI/cdF42KSjPlfY5VUsB56pl54neGEKQGeQHh0mENyXMmkbX7pQMvj7VasGbmz4e8r2i0
	 ulSucvODElPMPavWpGt3WgEs9yef+X74q0W8KjeYJBn+15wGQK77fPpQbkeX+tp6aMohE
	 glsJQq5fwvLQBBuVY0YG7FqIdnN0b0EbqOGd0VzBSAYlG6PZ084NSb68EPyzmC0lQvwyR
	 hf0AYDJtnM5wlwTTy8+W1ZrbZ6YcHf6fZLblVd6X/ksuYQFkvcf+0U/VDaGWNGe3hRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="H0/Tof6n";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67050606A31C;
	Thu, 26 Nov 2026 14:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H0/Tof6n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCAD1F000CA;
	Thu, 26 Nov 2026 14:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704865;
	bh=cFBWD5cdaWMxD2OkQQZnxcrgCc3bkBKB4NaYmVfjUck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H0/Tof6nHZat5okHJBQbm8yJT52ggH4BQsykQV9fEbTdyXzvmHAirOkW5pgdKOYB+
	 nTnUjVxN9JI6OErvY6aKGeX9N0FmuPbpb/MZYkWKiVgEKgGEEJMo/TcCxzhwbIhO2v
	 YZUEipcfbd6JUsvK4EFgr1zQUw/u3LnburG+7Cuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 241/265] USB: serial: io_edgeport: fix potential use-after-free on disconnect
Date: Thu, 26 Nov 2026 15:39:31 +0100
Message-ID: <20261126143622.142088873@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 50613e6380db7a904ef15c60ed0c436baf308f0a upstream.

The driver submits command URBs asynchronously but fails to stop them on
disconnect, something which could lead to a use-after-free when
accessing driver data in the completion handler after a port has been
unbound.

Add an URB anchor to track and kill outstanding command URBs on
disconnect.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/io_edgeport.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -225,6 +225,7 @@ struct edgeport_serial {
 	__u8			rxStatusParam;			/* the receive status paramater */
 	__s16			rxBytesRemaining;		/* the number of port bytes left to read */
 	struct usb_serial	*serial;			/* loop back to the owner of this object */
+	struct usb_anchor	cmd_anchor;
 };
 
 /* baud rate information */
@@ -261,9 +262,6 @@ static const struct divisor_table_entry
 	{   230400,	1},
 };
 
-/* Number of outstanding Command Write Urbs */
-static atomic_t CmdUrbs = ATOMIC_INIT(0);
-
 
 /* local function prototypes */
 
@@ -853,11 +851,6 @@ static void edge_bulk_out_cmd_callback(s
 	struct device *dev = &urb->dev->dev;
 	int status = urb->status;
 
-	atomic_dec(&CmdUrbs);
-	dev_dbg(dev, "%s - FREE URB %p (outstanding %d)\n", __func__, urb,
-		atomic_read(&CmdUrbs));
-
-
 	/* clean up the transfer buffer */
 	kfree(urb->transfer_buffer);
 
@@ -2275,24 +2268,21 @@ static int write_cmd_usb(struct edgeport
 	if (!urb)
 		return -ENOMEM;
 
-	atomic_inc(&CmdUrbs);
-	dev_dbg(dev, "%s - ALLOCATE URB %p (outstanding %d)\n",
-		__func__, urb, atomic_read(&CmdUrbs));
-
 	usb_fill_bulk_urb(urb, edge_serial->serial->dev,
 			usb_sndbulkpipe(edge_serial->serial->dev,
 					edge_serial->bulk_out_endpoint),
 			buffer, length, edge_bulk_out_cmd_callback, edge_port);
 
 	edge_port->commandPending = true;
+	usb_anchor_urb(urb, &edge_serial->cmd_anchor);
 	status = usb_submit_urb(urb, GFP_ATOMIC);
 
 	if (status) {
 		/* something went wrong */
 		dev_err(dev, "%s - usb_submit_urb(write command) failed, status = %d\n",
 			__func__, status);
+		usb_unanchor_urb(urb);
 		usb_free_urb(urb);
-		atomic_dec(&CmdUrbs);
 		return status;
 	}
 
@@ -2856,6 +2846,7 @@ static int edge_startup(struct usb_seria
 
 	spin_lock_init(&edge_serial->es_lock);
 	edge_serial->serial = serial;
+	init_usb_anchor(&edge_serial->cmd_anchor);
 	usb_set_serial_data(serial, edge_serial);
 
 	/* get the name for the device from the device */
@@ -3060,6 +3051,8 @@ static void edge_disconnect(struct usb_s
 {
 	struct edgeport_serial *edge_serial = usb_get_serial_data(serial);
 
+	usb_kill_anchored_urbs(&edge_serial->cmd_anchor);
+
 	if (edge_serial->is_epic) {
 		usb_kill_urb(edge_serial->interrupt_read_urb);
 		usb_kill_urb(edge_serial->read_urb);


