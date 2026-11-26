Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705725;
	b=0lSdTFARrkQxt3W7v+PUx6TcnlSWfhGWc2KNTX6bCAzuFssY67h6Y80VzJQ/8Fd6o+i6
	 EuEkIx9hL8IhB2MQ6YHjgEWSeOwidNFyn7yuw6EQ5n9AuUyXs+t3BsmWsNOTePfkYbHb4
	 Y4mSqFbQ89XDUPH3CAlWMlNkJWom6SIF8iynrSi/kAm9QfEmc/LQMYgOpDAjgTCtcQjVn
	 ni60U/78/d6jpTNZT+x6Zf4YY1431Fh2ZJ/WGfcUceE/HWBoRUxAcZV740NWa2GFYrxUW
	 d8cmj3qBCnAc5EukJSA9DUOUD3ASv8xQSEx+77hxlr4ezlvanCfpUpj2Tj+jofDmDrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9jEtsx3/fiziUxMReeHgacVw9BsZv/6HV1T/uU+8QgI=;
	b=B4UKX2pIxCb7xf9IvFkjQ5R3RAIWZeq1Pl5Q7L3JbnhwRxEAAhS60/+6ROjIScqbjb8D
	 /cnZA/8rxN6j4RbjPkG8uOw5EBPUiIYDifWmYg/eZtkZv+nwNUPPSY1HjHysVw3rjdI6d
	 IpPgNg6FsY78P/Gbqvt7GVGOJQKhXBmh1gTeL1+sOzbG0agoqz1rP5lsu9tfxfMpPeY1f
	 U9zBriqaJJ1v0sj8yjJFPPwIK+QxizOMMuP9m+yLLFu6oC6S4XmUgLRXMMwMY6WetOpL0
	 QEXjYD9z3DZDgsOwdx6nP9zeLgJL9fI3zhvsS0GnJPgY8LYRZStue4CL6UF9G339Neg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WQ3z1qKL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87144606A31C;
	Thu, 26 Nov 2026 15:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WQ3z1qKL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8268B1F000D3;
	Thu, 26 Nov 2026 15:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705725;
	bh=9jEtsx3/fiziUxMReeHgacVw9BsZv/6HV1T/uU+8QgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WQ3z1qKLmm7p0Do7SmjSrungkFO10oYA0Siz7aZ7h9zhmjSqc7B6c/Cai1BMxkkou
	 6wO0iVKDmeIbATvnybaHoYeVcw1qc2l74d6YwFElaApHvZkT7CWdp2LMuhdFgo9g08
	 E+FFrfN3FmjSPR4Uz2AU/q34pi0+QGBLi9AUHY44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 294/319] USB: serial: io_edgeport: fix potential use-after-free on disconnect
Date: Thu, 26 Nov 2026 15:41:02 +0100
Message-ID: <20261126144013.393976072@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 
 /* function prototypes */
 
@@ -777,11 +775,6 @@ static void edge_bulk_out_cmd_callback(s
 	struct device *dev = &urb->dev->dev;
 	int status = urb->status;
 
-	atomic_dec(&CmdUrbs);
-	dev_dbg(dev, "%s - FREE URB %p (outstanding %d)\n", __func__, urb,
-		atomic_read(&CmdUrbs));
-
-
 	/* clean up the transfer buffer */
 	kfree(urb->transfer_buffer);
 
@@ -2156,24 +2149,21 @@ static int write_cmd_usb(struct edgeport
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
 
@@ -2737,6 +2727,7 @@ static int edge_startup(struct usb_seria
 
 	spin_lock_init(&edge_serial->es_lock);
 	edge_serial->serial = serial;
+	init_usb_anchor(&edge_serial->cmd_anchor);
 	usb_set_serial_data(serial, edge_serial);
 
 	/* get the name for the device from the device */
@@ -2941,6 +2932,8 @@ static void edge_disconnect(struct usb_s
 {
 	struct edgeport_serial *edge_serial = usb_get_serial_data(serial);
 
+	usb_kill_anchored_urbs(&edge_serial->cmd_anchor);
+
 	if (edge_serial->is_epic) {
 		usb_kill_urb(edge_serial->interrupt_read_urb);
 		usb_kill_urb(edge_serial->read_urb);


