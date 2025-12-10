Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4A030171D;
	Wed, 10 Dec 2025 07:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352015; cv=none; b=kVLWaHXyP2zroaNKCXXhYtV+M3XIBN7oGJ8t1dChYWQIbhpE2ZpqSksifemGzBVh8yCHgpGnyphUIhRcnkwtcZVvI0DG2SWRNGH6xawQAW/WMvaM6/mb3Itkm+JqPugUhTtDya9MV63JOp7DI2izWzfvhUH/YrnvUXWpqQPHjcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352015; c=relaxed/simple;
	bh=IIPgIsqYg+DU/BMlb4KiilpSFu/ZS51+gwZBAYXyjAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmXKl70Pq7cK5aDV+2MKCDmKLCoDyIWpDo2Zvuc1BxwJmKm+Zq917snf35GQJnjM03v+OJ/xam/tThm8i7QqEbwEHOT09SE4oX5+4+quHAEDQkjslySQJEUjC6N2657yAHOyIEwwDM48vzH/YVuShnBj3Hbwf6HVTLPmmf2Wh5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jxNjq2ug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxNjq2ug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC7CC4CEF1;
	Wed, 10 Dec 2025 07:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352014;
	bh=IIPgIsqYg+DU/BMlb4KiilpSFu/ZS51+gwZBAYXyjAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jxNjq2ugyHEqcBSVbvdes4yANhaDhW5JnIIvPa6tuHjxM+is7GhZo5mSvzggm/zMR
	 /hWXwfioX0Pvv2Onk5dvTLNEwUXFk0uZ4kT2QawJQWD8pZFkjOZfclx4ncMYKRN0uV
	 WBU5wO4bspWkbpkdZWqWHnFM2JxxWfGy+9B2C85M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.17 18/60] USB: serial: kobil_sct: fix TIOCMBIS and TIOCMBIC
Date: Wed, 10 Dec 2025 16:29:48 +0900
Message-ID: <20251210072948.286476460@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -418,7 +418,7 @@ static int kobil_tiocmset(struct tty_str
 	struct usb_serial_port *port = tty->driver_data;
 	struct device *dev = &port->dev;
 	struct kobil_private *priv;
-	int result;
+	int result = 0;
 	int dtr = 0;
 	int rts = 0;
 
@@ -435,12 +435,12 @@ static int kobil_tiocmset(struct tty_str
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
@@ -448,13 +448,13 @@ static int kobil_tiocmset(struct tty_str
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
@@ -462,7 +462,7 @@ static int kobil_tiocmset(struct tty_str
 			usb_sndctrlpipe(port->serial->dev, 0),
 			SUSBCRequest_SetStatusLinesOrQueues,
 			USB_TYPE_VENDOR | USB_RECIP_ENDPOINT | USB_DIR_OUT,
-			((rts != 0) ? SUSBCR_SSL_SETRTS : SUSBCR_SSL_CLRRTS),
+			((set & TIOCM_RTS) ? SUSBCR_SSL_SETRTS : SUSBCR_SSL_CLRRTS),
 			0,
 			NULL,
 			0,


