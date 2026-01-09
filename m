Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AED531A7EA;
	Fri,  9 Jan 2026 11:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959348; cv=none; b=ObletghTfVNV3LiW+O7f9y87sW6YEZTO7wQ9pMzdkcIqSJQWAX6nK7ast5jCwI0hBd/x2SfGVnhe1y66oGRfgUY5D9wYbaK1M/ws3QvUi6zg+Vgpe1KclMlvsmWuTt2Vo3SDZBWXZVdQ4kc3JZryUr+50YxdvAMvAcIDl6geyMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959348; c=relaxed/simple;
	bh=Cg5/NwJoAQbs2ibtppqQjNHeXousxQDxhtIjJFfO/Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hH8Ry3d2OQi/d3FWk6vRIr0StSP7IB3igBABrgTO4xNFNaRYqESXNQ4RoEQysNeUWpTeUc6JhrlXBRY5Yz7Vsz0CYT0fXAoE3WGskImzEMZXvQbuPhJ8/3kC9/lAvK2d2l4Bd3tJXEbhaJoL+yx1n9XSiSAgYc5eMuvyE7efW0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uGp+1LAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uGp+1LAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39FE0C4CEF1;
	Fri,  9 Jan 2026 11:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959347;
	bh=Cg5/NwJoAQbs2ibtppqQjNHeXousxQDxhtIjJFfO/Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGp+1LALoh/ATe4JjOufGSCuOM3ja5GS5MZZxIbuzHwg/DNpJ36nipKNACK1qUcWD
	 7TS6eFgBPU2bMf98dIlNzCpmkmkZpn76tIJXjzCxCJ3P+U5wMdUj8s9xNNB/YEqQhr
	 8ib/9Z3gZ+jntwLZON2ZVz86KXz4Fji6s4IXDoYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 020/737] USB: serial: kobil_sct: fix TIOCMBIS and TIOCMBIC
Date: Fri,  9 Jan 2026 12:32:39 +0100
Message-ID: <20260109112134.756304417@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

commit d432df758f92c4c28aac409bc807fd1716167577 upstream.

Asserting or deasserting a modem control line using TIOCMBIS or TIOCMBIC
should not deassert any lines that are not in the mask.

Fix this long-standing issue dating back to 2003 when the support for
these ioctls was added with the introduction of the tiocmset() callback.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/kobil_sct.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -420,7 +420,7 @@ static int kobil_tiocmset(struct tty_str
 	struct usb_serial_port *port = tty->driver_data;
 	struct device *dev = &port->dev;
 	struct kobil_private *priv;
-	int result;
+	int result = 0;
 	int dtr = 0;
 	int rts = 0;
 
@@ -437,12 +437,12 @@ static int kobil_tiocmset(struct tty_str
 	if (set & TIOCM_DTR)
 		dtr = 1;
 	if (clear & TIOCM_RTS)
-		rts = 0;
+		rts = 1;
 	if (clear & TIOCM_DTR)
-		dtr = 0;
+		dtr = 1;
 
-	if (priv->device_type == KOBIL_ADAPTER_B_PRODUCT_ID) {
-		if (dtr != 0)
+	if (dtr && priv->device_type == KOBIL_ADAPTER_B_PRODUCT_ID) {
+		if (set & TIOCM_DTR)
 			dev_dbg(dev, "%s - Setting DTR\n", __func__);
 		else
 			dev_dbg(dev, "%s - Clearing DTR\n", __func__);
@@ -450,13 +450,13 @@ static int kobil_tiocmset(struct tty_str
 			  usb_sndctrlpipe(port->serial->dev, 0),
 			  SUSBCRequest_SetStatusLinesOrQueues,
 			  USB_TYPE_VENDOR | USB_RECIP_ENDPOINT | USB_DIR_OUT,
-			  ((dtr != 0) ? SUSBCR_SSL_SETDTR : SUSBCR_SSL_CLRDTR),
+			  ((set & TIOCM_DTR) ? SUSBCR_SSL_SETDTR : SUSBCR_SSL_CLRDTR),
 			  0,
 			  NULL,
 			  0,
 			  KOBIL_TIMEOUT);
-	} else {
-		if (rts != 0)
+	} else if (rts) {
+		if (set & TIOCM_RTS)
 			dev_dbg(dev, "%s - Setting RTS\n", __func__);
 		else
 			dev_dbg(dev, "%s - Clearing RTS\n", __func__);
@@ -464,7 +464,7 @@ static int kobil_tiocmset(struct tty_str
 			usb_sndctrlpipe(port->serial->dev, 0),
 			SUSBCRequest_SetStatusLinesOrQueues,
 			USB_TYPE_VENDOR | USB_RECIP_ENDPOINT | USB_DIR_OUT,
-			((rts != 0) ? SUSBCR_SSL_SETRTS : SUSBCR_SSL_CLRRTS),
+			((set & TIOCM_RTS) ? SUSBCR_SSL_SETRTS : SUSBCR_SSL_CLRRTS),
 			0,
 			NULL,
 			0,


