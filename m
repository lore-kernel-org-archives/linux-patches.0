Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8809747DD59;
	Thu, 20 Aug 2026 16:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244462; cv=none; b=Ij3myoW4EZU5BcDWLmH8PUohtCKJqntd5sU43AV8CCeFlDmk4TyYA1tYKX8y/MBXyeYsBBICYnI7kUQHInQNMK52rqyC3chIHAXr2IQ0lkv9u7f83LBgkrkv7WoryOCz1BK0J3TJuSw+sNXhgEzi7aiuZF+6rtJ7KnClQn2U0Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244462; c=relaxed/simple;
	bh=cPsvR/Ahg76fKM8qAtb6LdFTJdba12/aF8px+Wd/UNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqXbyqBKUcNDW9Gfum5TsTLWDchSA41L2lmzL0M06L5koeZ68fyrAnQeTYYOqNlTN2xcktQR2RqjswcHVa33x0P6ne6WVs+CaA2JuWua+35pzAKbpgjiECBhKYbd0TJtSVnyZl/Ikv3Fg4YvZgf4/mzbqEBxZAZ2iIFZ9v1/iOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fESgpYeW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fESgpYeW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D971B1F000E9;
	Thu, 20 Aug 2026 16:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244461;
	bh=7vynAMCNm/lI76cfaVp4V8W3GIRBxboQOR9ZXAGUl2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fESgpYeWKdTScfmbbXktj0teDBjVfJfOGyjx4UkDIQ8JwBUxySgEBba2W3yTQO8/q
	 wAtUkxuinq3Z7TBVi0YxePazyqz2ZA/VzrL09gMnvTYhncVwUymYM+wCPwpYDXOe5T
	 uEds+zpHZWNp66hjY6PG8JNeVelwgzQIDCK9HhUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/235] USB: serial: keyspan_pda: fix data loss on receive throttling
Date: Thu, 20 Aug 2026 16:56:16 +0200
Message-ID: <20260820145220.687087311@linuxfoundation.org>
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

[ Upstream commit 42a97c0480f96a2977e6d51ce512adc780f1ef5d ]

Killing the interrupt-in urb when the line disciple requests throttling
may lead to data loss if an ongoing transfer is cancelled.

Instead set a flag to prevent the completion handler from resubmitting
the urb until the port is unthrottled.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/keyspan_pda.c |   44 +++++++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 9 deletions(-)

--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -47,6 +47,8 @@ struct keyspan_pda_private {
 	struct work_struct	unthrottle_work;
 	struct usb_serial	*serial;
 	struct usb_serial_port	*port;
+	bool			throttled;
+	bool			throttle_req;
 };
 
 static int keyspan_pda_write_start(struct usb_serial_port *port);
@@ -184,6 +186,7 @@ static void keyspan_pda_rx_interrupt(str
 	int retval;
 	int status = urb->status;
 	struct keyspan_pda_private *priv;
+	bool throttled = false;
 	unsigned long flags;
 
 	priv = usb_get_serial_port_data(port);
@@ -245,16 +248,24 @@ static void keyspan_pda_rx_interrupt(str
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
@@ -264,16 +275,29 @@ static void keyspan_pda_rx_throttle(stru
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
@@ -609,6 +633,8 @@ static int keyspan_pda_open(struct tty_s
 
 	spin_lock_irq(&port->lock);
 	priv->tx_room = rc;
+	priv->throttled = false;
+	priv->throttle_req = false;
 	spin_unlock_irq(&port->lock);
 
 	rc = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);


