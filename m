Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1555547D471;
	Thu, 20 Aug 2026 16:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244400; cv=none; b=PM5DbR/XSYXXjTMRCJFCILxFgtn8+5YA0zX/G5xQtBl2wrecGgwD7/6DIrm1ZRnSGNklU+2GMFnOTvUZkUsKtQKwAo+dUtqDhdgNACmcq/V1XwmoiIJdeAilZkjt6f1hglwKLrt3FNxVywwP94el/IEFun+m4JvCTz9S0c+rOd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244400; c=relaxed/simple;
	bh=jMvt8U7F2ucQOCUhBf8g77mO6JYPzbFs4LNsNnalEs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoXGL7qvJotQHstFfQ9JbPknlOP8U1t91nMkrBy/IqPmohjy5QLJHVd9WVrokbmJNCK3cBh9/YYV0PIWeGNPN5KGPUQ+P7E1+T51aK+JuCTSPkBev5VOYNnlMkAlxVueL92HTd2zHoVorF3VoL+Luo6h3BVp84+FT6MJrdlKVlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vTQEoqx8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vTQEoqx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B141F000E9;
	Thu, 20 Aug 2026 16:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244398;
	bh=mDHNKxr+jlH4f8NfoK2YKrCFsJL6q+NhbMRGqiV7mb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vTQEoqx8qNmYXv/VtDNvOj17wW30i6ChHG+9Wz7wNR2dyijQ31/JrnlrwRhJfbTjm
	 oX1vQGR9jtITeztqc6W1bPurFWoUIH1eyzvt8ssFMel79S6ahtYXEODdFwf025jFAh
	 miB3Q/EN/rh+4YDhXRa2FCTWEPEX7eZcEikTzTUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 138/235] USB: serial: keyspan_pda: add write-fifo support
Date: Thu, 20 Aug 2026 16:56:14 +0200
Message-ID: <20260820145220.627315870@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 034e38e8f68767fb5438ae3e608ee82919674177 ]

Use the port write fifo and generic chars_and_buffer and write_room
implementations when writing. This not only allows for more efficient
transfers, but more importantly fixes the remaining issues related to
the conservative write_room() implementation which could prevent the
line discipline from making forward progress (e.g. waiting for n > 1
bytes of space to become available).

Note that this also allows using the driver for the system console
without dropping data when the write URB is busy (including when adding
carriage return on line feed).

Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Stable-dep-of: 42a97c0480f9 ("USB: serial: keyspan_pda: fix data loss on receive throttling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/keyspan_pda.c |  134 ++++++++++++++++++---------------------
 1 file changed, 65 insertions(+), 69 deletions(-)

--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -5,6 +5,7 @@
  * Copyright (C) 1999 - 2001 Greg Kroah-Hartman	<greg@kroah.com>
  * Copyright (C) 1999, 2000 Brian Warner	<warner@lothar.com>
  * Copyright (C) 2000 Al Borchers		<borchers@steinerpoint.com>
+ * Copyright (C) 2020 Johan Hovold <johan@kernel.org>
  *
  * See Documentation/usb/usb-serial.rst for more information on using this
  * driver
@@ -37,7 +38,7 @@
 	#undef XIRCOM
 #endif
 
-#define DRIVER_AUTHOR "Brian Warner <warner@lothar.com>"
+#define DRIVER_AUTHOR "Brian Warner <warner@lothar.com>, Johan Hovold <johan@kernel.org>"
 #define DRIVER_DESC "USB Keyspan PDA Converter driver"
 
 #define KEYSPAN_TX_THRESHOLD	16
@@ -49,6 +50,7 @@ struct keyspan_pda_private {
 	struct usb_serial_port	*port;
 };
 
+static int keyspan_pda_write_start(struct usb_serial_port *port);
 
 #define KEYSPAN_VENDOR_ID		0x06cd
 #define KEYSPAN_PDA_FAKE_ID		0x0103
@@ -228,6 +230,9 @@ static void keyspan_pda_rx_interrupt(str
 			spin_lock_irqsave(&port->lock, flags);
 			priv->tx_room = max(priv->tx_room, KEYSPAN_TX_THRESHOLD);
 			spin_unlock_irqrestore(&port->lock, flags);
+
+			keyspan_pda_write_start(port);
+
 			/* queue up a wakeup at scheduler time */
 			usb_serial_port_softint(port);
 			break;
@@ -247,31 +252,30 @@ exit:
 			__func__, retval);
 }
 
-
 static void keyspan_pda_rx_throttle(struct tty_struct *tty)
 {
-	/* stop receiving characters. We just turn off the URB request, and
-	   let chars pile up in the device. If we're doing hardware
-	   flowcontrol, the device will signal the other end when its buffer
-	   fills up. If we're doing XON/XOFF, this would be a good time to
-	   send an XOFF, although it might make sense to foist that off
-	   upon the device too. */
 	struct usb_serial_port *port = tty->driver_data;
 
+	/*
+	 * Stop receiving characters. We just turn off the URB request, and
+	 * let chars pile up in the device. If we're doing hardware
+	 * flowcontrol, the device will signal the other end when its buffer
+	 * fills up. If we're doing XON/XOFF, this would be a good time to
+	 * send an XOFF, although it might make sense to foist that off upon
+	 * the device too.
+	 */
 	usb_kill_urb(port->interrupt_in_urb);
 }
 
-
 static void keyspan_pda_rx_unthrottle(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
-	/* just restart the receive interrupt URB */
 
+	/* just restart the receive interrupt URB */
 	if (usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL))
 		dev_dbg(&port->dev, "usb_submit_urb(read urb) failed\n");
 }
 
-
 static speed_t keyspan_pda_setbaud(struct usb_serial *serial, speed_t baud)
 {
 	int rc;
@@ -482,15 +486,15 @@ static int keyspan_pda_tiocmset(struct t
 	return rc;
 }
 
-static int keyspan_pda_write(struct tty_struct *tty,
-	struct usb_serial_port *port, const unsigned char *buf, int count)
+static int keyspan_pda_write_start(struct usb_serial_port *port)
 {
-	struct keyspan_pda_private *priv;
+	struct keyspan_pda_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
+	struct urb *urb;
+	int count;
 	int room;
 	int rc;
 
-	priv = usb_get_serial_port_data(port);
 	/*
 	 * Guess how much room is left in the device's ring buffer. If our
 	 * write will result in no room left, ask the device to give us an
@@ -499,105 +503,92 @@ static int keyspan_pda_write(struct tty_
 	 * too conservative and the buffer is already empty when the
 	 * unthrottle work is scheduled).
 	 */
-	if (count == 0) {
-		dev_dbg(&port->dev, "write request of 0 bytes\n");
-		return 0;
-	}
-
-	if (count > port->bulk_out_size)
-		count = port->bulk_out_size;
 
 	/* we might block because of:
 	   the TX urb is in-flight (wait until it completes)
 	   the device is full (wait until it says there is room)
 	*/
 	spin_lock_irqsave(&port->lock, flags);
+
 	room = priv->tx_room;
-	if (!test_bit(0, &port->write_urbs_free) || room == 0) {
+	count = kfifo_len(&port->write_fifo);
+
+	if (!test_bit(0, &port->write_urbs_free) || count == 0 || room == 0) {
 		spin_unlock_irqrestore(&port->lock, flags);
 		return 0;
 	}
-	clear_bit(0, &port->write_urbs_free);
+	__clear_bit(0, &port->write_urbs_free);
+
 	if (count > room)
 		count = room;
+	if (count > port->bulk_out_size)
+		count = port->bulk_out_size;
+
+	urb = port->write_urb;
+	count = kfifo_out(&port->write_fifo, urb->transfer_buffer, count);
+	urb->transfer_buffer_length = count;
+
+	port->tx_bytes += count;
 	priv->tx_room -= count;
-	spin_unlock_irqrestore(&port->lock, flags);
 
-	/* At this point the URB is in our control, nobody else can submit it
-	   again (the only sudden transition was the one from EINPROGRESS to
-	   finished).  Also, the tx process is not throttled. So we are
-	   ready to write. */
+	spin_unlock_irqrestore(&port->lock, flags);
 
 	dev_dbg(&port->dev, "%s - count = %d, txroom = %d\n", __func__, count, room);
 
-	memcpy(port->write_urb->transfer_buffer, buf, count);
-	port->write_urb->transfer_buffer_length = count;
-
-	rc = usb_submit_urb(port->write_urb, GFP_ATOMIC);
+	rc = usb_submit_urb(urb, GFP_ATOMIC);
 	if (rc) {
 		dev_dbg(&port->dev, "usb_submit_urb(write bulk) failed\n");
 
 		spin_lock_irqsave(&port->lock, flags);
+		port->tx_bytes -= count;
 		priv->tx_room = max(priv->tx_room, room + count);
+		__set_bit(0, &port->write_urbs_free);
 		spin_unlock_irqrestore(&port->lock, flags);
 
-		set_bit(0, &port->write_urbs_free);
-
 		return rc;
 	}
 
 	if (count == room)
 		schedule_work(&priv->unthrottle_work);
 
-	return count;
+	return 0;
 }
 
 static void keyspan_pda_write_bulk_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
+	unsigned long flags;
 
-	set_bit(0, &port->write_urbs_free);
+	spin_lock_irqsave(&port->lock, flags);
+	port->tx_bytes -= urb->transfer_buffer_length;
+	__set_bit(0, &port->write_urbs_free);
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	keyspan_pda_write_start(port);
 
 	/* queue up a wakeup at scheduler time */
 	usb_serial_port_softint(port);
 }
 
-
-static int keyspan_pda_write_room(struct tty_struct *tty)
+static int keyspan_pda_write(struct tty_struct *tty, struct usb_serial_port *port,
+		const unsigned char *buf, int count)
 {
-	struct usb_serial_port *port = tty->driver_data;
-	struct keyspan_pda_private *priv = usb_get_serial_port_data(port);
-	unsigned long flags;
-	int room = 0;
-
-	spin_lock_irqsave(&port->lock, flags);
-	if (test_bit(0, &port->write_urbs_free))
-		room = priv->tx_room;
-	spin_unlock_irqrestore(&port->lock, flags);
+	int rc;
 
-	return room;
-}
+	dev_dbg(&port->dev, "%s - count = %d\n", __func__, count);
 
-static int keyspan_pda_chars_in_buffer(struct tty_struct *tty)
-{
-	struct usb_serial_port *port = tty->driver_data;
-	struct keyspan_pda_private *priv;
-	unsigned long flags;
-	int ret = 0;
+	if (!count)
+		return 0;
 
-	priv = usb_get_serial_port_data(port);
+	count = kfifo_in_locked(&port->write_fifo, buf, count, &port->lock);
 
-	/* when throttled, return at least WAKEUP_CHARS to tell select() (via
-	   n_tty.c:normal_poll() ) that we're not writeable. */
+	rc = keyspan_pda_write_start(port);
+	if (rc)
+		return rc;
 
-	spin_lock_irqsave(&port->lock, flags);
-	if (!test_bit(0, &port->write_urbs_free) || priv->tx_room == 0)
-		ret = 256;
-	spin_unlock_irqrestore(&port->lock, flags);
-	return ret;
+	return count;
 }
 
-
 static void keyspan_pda_dtr_rts(struct usb_serial_port *port, int on)
 {
 	struct usb_serial *serial = port->serial;
@@ -638,12 +629,19 @@ static void keyspan_pda_close(struct usb
 {
 	struct keyspan_pda_private *priv = usb_get_serial_port_data(port);
 
-	usb_kill_urb(port->write_urb);
+	/*
+	 * Stop the interrupt URB first as its completion handler may submit
+	 * the write URB.
+	 */
 	usb_kill_urb(port->interrupt_in_urb);
+	usb_kill_urb(port->write_urb);
 
 	cancel_work_sync(&priv->unthrottle_work);
-}
 
+	spin_lock_irq(&port->lock);
+	kfifo_reset(&port->write_fifo);
+	spin_unlock_irq(&port->lock);
+}
 
 /* download the firmware to a "fake" device (pre-renumeration) */
 static int keyspan_pda_fake_startup(struct usb_serial *serial)
@@ -757,10 +755,8 @@ static struct usb_serial_driver keyspan_
 	.open =			keyspan_pda_open,
 	.close =		keyspan_pda_close,
 	.write =		keyspan_pda_write,
-	.write_room =		keyspan_pda_write_room,
 	.write_bulk_callback = 	keyspan_pda_write_bulk_callback,
 	.read_int_callback =	keyspan_pda_rx_interrupt,
-	.chars_in_buffer =	keyspan_pda_chars_in_buffer,
 	.throttle =		keyspan_pda_rx_throttle,
 	.unthrottle =		keyspan_pda_rx_unthrottle,
 	.set_termios =		keyspan_pda_set_termios,


