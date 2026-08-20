Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FEC47DF91;
	Thu, 20 Aug 2026 16:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244367; cv=none; b=PSHkui54TOWEOe7gD6mOBk882pGLzvne1WXl4LKV0vXbZYJ91w8tslYB4n5mvxjB0KzYXfCTFYtCpqo6Tr2k8oAt0OGbuvXwgCG3kDyo1vOVR8Gyfm5OaeLKXP1y1GXNUUmkm1s3caz6uOFYiaBWEMPt1YxbqjnNv1DriUyjTVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244367; c=relaxed/simple;
	bh=gqNRme0ijVseCh2IuxG60HqdL6zgp9K1LJ/CTc5eSZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVPHbeqE9Aosd1jOYAs8wbq2AsGcosplUNlfcovDvLIEigDe2ZORXiIYbRchPAtVQy71lf63PC/77+D16IM+zohd8Ig1G7TV1wEtde1+c9o1vXgMr/jHuFxQR33ZKYasimrxclSiBO0GXtFXCgmqN4/wrn2WvzBOtVWohAf9rk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WRq31ANr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WRq31ANr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6117F1F000E9;
	Thu, 20 Aug 2026 16:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244365;
	bh=psuK2J+BvtDKCHt6qfuFsQdqK1BHVrpDNnsbHZ6/Um0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WRq31ANrx1840SzfLPAEQ0Z7/cIO+7oAM3tdaUJI2WgMjaVEXk6n4DMgfCrLAFiwa
	 NuuQdHaBddC2QUzAq4uRvMU9kIGMJksY+iP8SsH9capXBJYrfQaBC7ADf+30E/ReAP
	 ncTjWa5SVK5UT6c4/mdCb8Tck0rIAFylyisKoWOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 137/235] USB: serial: keyspan_pda: fix write implementation
Date: Thu, 20 Aug 2026 16:56:13 +0200
Message-ID: <20260820145220.597320434@linuxfoundation.org>
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

[ Upstream commit 7184933b52a6b3e64171819b77f0bab018696cb2 ]

Fix stalled writes by checking the available buffer space after
requesting an unthrottle notification in case the device buffer is
already empty so that no notification is ever sent (e.g. when doing
single character writes).

This also means we can drop the room query from write() which was
conditioned on in_interrupt() and prevented writing using this driver
from atomic contexts (e.g. PPP).

Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Stable-dep-of: 42a97c0480f9 ("USB: serial: keyspan_pda: fix data loss on receive throttling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/keyspan_pda.c |  111 ++++++++++++++++++---------------------
 1 file changed, 52 insertions(+), 59 deletions(-)

--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -44,7 +44,6 @@
 
 struct keyspan_pda_private {
 	int			tx_room;
-	int			tx_throttled;
 	struct work_struct	unthrottle_work;
 	struct usb_serial	*serial;
 	struct usb_serial_port	*port;
@@ -138,9 +137,13 @@ static void keyspan_pda_request_unthrott
 {
 	struct keyspan_pda_private *priv =
 		container_of(work, struct keyspan_pda_private, unthrottle_work);
+	struct usb_serial_port *port = priv->port;
 	struct usb_serial *serial = priv->serial;
+	unsigned long flags;
 	int result;
 
+	dev_dbg(&port->dev, "%s\n", __func__);
+
 	/* ask the device to tell us when the tx buffer becomes
 	   sufficiently empty */
 	result = usb_control_msg(serial->dev,
@@ -156,8 +159,19 @@ static void keyspan_pda_request_unthrott
 	if (result < 0)
 		dev_dbg(&serial->dev->dev, "%s - error %d from usb_control_msg\n",
 			__func__, result);
-}
+	/*
+	 * Need to check available space after requesting notification in case
+	 * buffer is already empty so that no notification is sent.
+	 */
+	result = keyspan_pda_get_write_room(priv);
+	if (result > KEYSPAN_TX_THRESHOLD) {
+		spin_lock_irqsave(&port->lock, flags);
+		priv->tx_room = max(priv->tx_room, result);
+		spin_unlock_irqrestore(&port->lock, flags);
 
+		usb_serial_port_softint(port);
+	}
+}
 
 static void keyspan_pda_rx_interrupt(struct urb *urb)
 {
@@ -212,7 +226,6 @@ static void keyspan_pda_rx_interrupt(str
 			break;
 		case 2: /* tx unthrottle interrupt */
 			spin_lock_irqsave(&port->lock, flags);
-			priv->tx_throttled = 0;
 			priv->tx_room = max(priv->tx_room, KEYSPAN_TX_THRESHOLD);
 			spin_unlock_irqrestore(&port->lock, flags);
 			/* queue up a wakeup at scheduler time */
@@ -472,35 +485,42 @@ static int keyspan_pda_tiocmset(struct t
 static int keyspan_pda_write(struct tty_struct *tty,
 	struct usb_serial_port *port, const unsigned char *buf, int count)
 {
-	int request_unthrottle = 0;
-	int rc = 0;
 	struct keyspan_pda_private *priv;
 	unsigned long flags;
+	int room;
+	int rc;
 
 	priv = usb_get_serial_port_data(port);
-	/* guess how much room is left in the device's ring buffer, and if we
-	   want to send more than that, check first, updating our notion of
-	   what is left. If our write will result in no room left, ask the
-	   device to give us an interrupt when the room available rises above
-	   a threshold, and hold off all writers (eventually, those using
-	   select() or poll() too) until we receive that unthrottle interrupt.
-	   Block if we can't write anything at all, otherwise write as much as
-	   we can. */
+	/*
+	 * Guess how much room is left in the device's ring buffer. If our
+	 * write will result in no room left, ask the device to give us an
+	 * interrupt when the room available rises above a threshold but also
+	 * query how much room is currently available (in case our guess was
+	 * too conservative and the buffer is already empty when the
+	 * unthrottle work is scheduled).
+	 */
 	if (count == 0) {
 		dev_dbg(&port->dev, "write request of 0 bytes\n");
 		return 0;
 	}
 
+	if (count > port->bulk_out_size)
+		count = port->bulk_out_size;
+
 	/* we might block because of:
 	   the TX urb is in-flight (wait until it completes)
 	   the device is full (wait until it says there is room)
 	*/
 	spin_lock_irqsave(&port->lock, flags);
-	if (!test_bit(0, &port->write_urbs_free) || priv->tx_throttled) {
+	room = priv->tx_room;
+	if (!test_bit(0, &port->write_urbs_free) || room == 0) {
 		spin_unlock_irqrestore(&port->lock, flags);
 		return 0;
 	}
 	clear_bit(0, &port->write_urbs_free);
+	if (count > room)
+		count = room;
+	priv->tx_room -= count;
 	spin_unlock_irqrestore(&port->lock, flags);
 
 	/* At this point the URB is in our control, nobody else can submit it
@@ -508,58 +528,30 @@ static int keyspan_pda_write(struct tty_
 	   finished).  Also, the tx process is not throttled. So we are
 	   ready to write. */
 
-	count = (count > port->bulk_out_size) ? port->bulk_out_size : count;
+	dev_dbg(&port->dev, "%s - count = %d, txroom = %d\n", __func__, count, room);
 
-	/* Check if we might overrun the Tx buffer.   If so, ask the
-	   device how much room it really has.  This is done only on
-	   scheduler time, since usb_control_msg() sleeps. */
-	if (count > priv->tx_room && !in_interrupt()) {
-		rc = keyspan_pda_get_write_room(priv);
-		if (rc < 0)
-			goto exit;
+	memcpy(port->write_urb->transfer_buffer, buf, count);
+	port->write_urb->transfer_buffer_length = count;
 
-		priv->tx_room = rc;
-	}
+	rc = usb_submit_urb(port->write_urb, GFP_ATOMIC);
+	if (rc) {
+		dev_dbg(&port->dev, "usb_submit_urb(write bulk) failed\n");
 
-	if (count >= priv->tx_room) {
-		/* we're about to completely fill the Tx buffer, so
-		   we'll be throttled afterwards. */
-		count = priv->tx_room;
-		request_unthrottle = 1;
-	}
+		spin_lock_irqsave(&port->lock, flags);
+		priv->tx_room = max(priv->tx_room, room + count);
+		spin_unlock_irqrestore(&port->lock, flags);
 
-	if (count) {
-		/* now transfer data */
-		memcpy(port->write_urb->transfer_buffer, buf, count);
-		/* send the data out the bulk port */
-		port->write_urb->transfer_buffer_length = count;
-
-		priv->tx_room -= count;
-
-		rc = usb_submit_urb(port->write_urb, GFP_ATOMIC);
-		if (rc) {
-			dev_dbg(&port->dev, "usb_submit_urb(write bulk) failed\n");
-			goto exit;
-		}
-	} else {
-		/* There wasn't any room left, so we are throttled until
-		   the buffer empties a bit */
-		request_unthrottle = 1;
+		set_bit(0, &port->write_urbs_free);
+
+		return rc;
 	}
 
-	if (request_unthrottle) {
-		priv->tx_throttled = 1; /* block writers */
+	if (count == room)
 		schedule_work(&priv->unthrottle_work);
-	}
 
-	rc = count;
-exit:
-	if (rc <= 0)
-		set_bit(0, &port->write_urbs_free);
-	return rc;
+	return count;
 }
 
-
 static void keyspan_pda_write_bulk_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
@@ -579,7 +571,7 @@ static int keyspan_pda_write_room(struct
 	int room = 0;
 
 	spin_lock_irqsave(&port->lock, flags);
-	if (test_bit(0, &port->write_urbs_free) && !priv->tx_throttled)
+	if (test_bit(0, &port->write_urbs_free))
 		room = priv->tx_room;
 	spin_unlock_irqrestore(&port->lock, flags);
 
@@ -599,7 +591,7 @@ static int keyspan_pda_chars_in_buffer(s
 	   n_tty.c:normal_poll() ) that we're not writeable. */
 
 	spin_lock_irqsave(&port->lock, flags);
-	if (!test_bit(0, &port->write_urbs_free) || priv->tx_throttled)
+	if (!test_bit(0, &port->write_urbs_free) || priv->tx_room == 0)
 		ret = 256;
 	spin_unlock_irqrestore(&port->lock, flags);
 	return ret;
@@ -628,8 +620,9 @@ static int keyspan_pda_open(struct tty_s
 	if (rc < 0)
 		return rc;
 
+	spin_lock_irq(&port->lock);
 	priv->tx_room = rc;
-	priv->tx_throttled = rc ? 0 : 1;
+	spin_unlock_irq(&port->lock);
 
 	/*Start reading from the device*/
 	rc = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);


