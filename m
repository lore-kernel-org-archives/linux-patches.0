Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EAA44E042;
	Thu, 30 Jul 2026 16:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427265; cv=none; b=MPARo/2uCYf84pIfZmBIACSxgI7OgkCcSCnJsw+D4seg3IUESP8R8LTR9z6l8I6tumG2aaSdUpm1Ohs3ljRhrfdBaGEVZTc2qEOc3EkBC7V693A6T+KfftyGO8gqZV+UzlJ7A+q769qVCCdlN3LRvCuVWNoodpq38FWGldoUfx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427265; c=relaxed/simple;
	bh=NCogJ4FC5z5jmCtSdeqzRc4eBqz9YCbD6V95Stev1aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DeYogwkewO60mcj3B4W5l1drwvo6NNaVwYgy3nhhqDIuxQ9Y/dDOs88Thwyp334WAX1LYCoCzQsZiegbD14Hf4V6DX+ZG2oAwBZDUtngv+6MtupmEqzFg36h/AnH5S4UFh+v6Yrp3xokGDxpQw8oi4TUKRD18+eOZY43FNbXxHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ugAmBpN2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ugAmBpN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD8C1F00A3F;
	Thu, 30 Jul 2026 16:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427263;
	bh=psbus4B+UcYIaZBKz4eaEZeyWTb3aH3mkulCuPt4vxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ugAmBpN2oqIu5hgwYpTZIZmo+4n41Ku6YFkqXFltv1jmrzxtGA/tgLMW8GkfXlAqC
	 yFSGMqqtA9yIvLks5yaN1W3oJlcFsUMWTLyk1DCFfAsbWKjWsL9Jdqn1s9mkIhmVdO
	 jUjfa5pdCQMOgchHqPus5tcqE8xjdsGd7wzlhy24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 109/484] USB: serial: keyspan_pda: fix data loss on receive throttling
Date: Thu, 30 Jul 2026 16:10:06 +0200
Message-ID: <20260730141425.827843925@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 42a97c0480f96a2977e6d51ce512adc780f1ef5d upstream.

Killing the interrupt-in urb when the line disciple requests throttling
may lead to data loss if an ongoing transfer is cancelled.

Instead set a flag to prevent the completion handler from resubmitting
the urb until the port is unthrottled.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/keyspan_pda.c |   44 +++++++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 9 deletions(-)

--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -35,6 +35,8 @@ struct keyspan_pda_private {
 	struct work_struct	unthrottle_work;
 	struct usb_serial	*serial;
 	struct usb_serial_port	*port;
+	bool			throttled;
+	bool			throttle_req;
 };
 
 static int keyspan_pda_write_start(struct usb_serial_port *port);
@@ -150,6 +152,7 @@ static void keyspan_pda_rx_interrupt(str
 	int retval;
 	int status = urb->status;
 	struct keyspan_pda_private *priv;
+	bool throttled = false;
 	unsigned long flags;
 
 	priv = usb_get_serial_port_data(port);
@@ -211,16 +214,24 @@ static void keyspan_pda_rx_interrupt(str
 	}
 
 exit:
-	retval = usb_submit_urb(urb, GFP_ATOMIC);
-	if (retval)
-		dev_err(&port->dev,
-			"%s - usb_submit_urb failed with result %d\n",
-			__func__, retval);
+	spin_lock_irqsave(&port->lock, flags);
+	if (priv->throttle_req) {
+		priv->throttled = true;
+		throttled = true;
+	}
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	if (!throttled) {
+		retval = usb_submit_urb(urb, GFP_ATOMIC);
+		if (retval)
+			dev_err(&port->dev, "failed to resubmit in urb: %d\n", retval);
+	}
 }
 
 static void keyspan_pda_rx_throttle(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
+	struct keyspan_pda_private *priv = usb_get_serial_port_data(port);
 
 	/*
 	 * Stop receiving characters. We just turn off the URB request, and
@@ -230,16 +241,29 @@ static void keyspan_pda_rx_throttle(stru
 	 * send an XOFF, although it might make sense to foist that off upon
 	 * the device too.
 	 */
-	usb_kill_urb(port->interrupt_in_urb);
+	spin_lock_irq(&port->lock);
+	priv->throttle_req = true;
+	spin_unlock_irq(&port->lock);
 }
 
 static void keyspan_pda_rx_unthrottle(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
+	struct keyspan_pda_private *priv = usb_get_serial_port_data(port);
+	bool throttled;
+	int ret;
+
+	spin_lock_irq(&port->lock);
+	throttled = priv->throttled;
+	priv->throttled = false;
+	priv->throttle_req = false;
+	spin_unlock_irq(&port->lock);
 
-	/* just restart the receive interrupt URB */
-	if (usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL))
-		dev_dbg(&port->dev, "usb_submit_urb(read urb) failed\n");
+	if (throttled) {
+		ret = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
+		if (ret)
+			dev_err(&port->dev, "failed to submit in urb: %d\n", ret);
+	}
 }
 
 static speed_t keyspan_pda_setbaud(struct usb_serial *serial, speed_t baud)
@@ -579,6 +603,8 @@ static int keyspan_pda_open(struct tty_s
 
 	spin_lock_irq(&port->lock);
 	priv->tx_room = rc;
+	priv->throttled = false;
+	priv->throttle_req = false;
 	spin_unlock_irq(&port->lock);
 
 	rc = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);


