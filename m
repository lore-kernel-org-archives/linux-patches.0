Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E574298CC4;
	Tue, 21 Jul 2026 21:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668461; cv=none; b=nirrHKw4AfKQUo/ECLEvWsERkivxNmzBa2QWxywCeeNgyM/2ujuwaRoN+rd9h4BPf6O8HMgEJ46vZOkmdQ0YVlRgg7bXfH74W+u2tO5UZK9GvbIlgeYkkRGBPSHj52ERQCKgZonTiP5MLt4k2DClwt7eojcLSm53JHuMO02xICo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668461; c=relaxed/simple;
	bh=KzPuA1Xx6qnYlULeLoGVfnkVg8OlWCfZpUT8jLY1B2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PAQw4wiyxZz4yCzBFW6718fQbV14+Qbe8L4yxrA0U8G6TpOiThCS09yQDMdK1HsK2CeovTuW7DGJn2XGXqUVysfIpdOd96vrXyGMPn7IT+gkL+KyqgzUIMMfxrc1y6YIq8p3gMF30mc98hXC06zXa34Zw2At12d1lqTRyaSMr2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BLrmuHif; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BLrmuHif"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B2F1F000E9;
	Tue, 21 Jul 2026 21:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668460;
	bh=ApQl/B9PUa24ITG874NTNLEh9Fu+L7ZXprDxQyCOik4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BLrmuHifLnITMX1sZ7pLd28BoeHj1HxuNaN8TmnEHN5MsuJicOMcVO7YpjpqN3V4D
	 u2iwOnccXKK/lI9EK2YPbriYgpzlpTvEnHKdxze2X/DbC57KAXsRA5qv1MJti0lNdt
	 maWXFG+1//WtHes4V3bR5/n9R5tu6+b4xt16rKSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 0183/1067] USB: serial: digi_acceleport: fix broken rx after throttle
Date: Tue, 21 Jul 2026 17:13:04 +0200
Message-ID: <20260721152428.688518877@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 83a3dfc018943b05b6daf3a6f891833e1aabfa1f upstream.

If the port is closed while throttled, the read urb is never resubmitted
and the port will not receive any further data until the device is
reconnected (or the driver is rebound).

Clear the throttle flags and submit the urb if needed when opening the
port.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/digi_acceleport.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -1072,6 +1072,7 @@ static int digi_open(struct tty_struct *
 	unsigned char buf[32];
 	struct digi_port *priv = usb_get_serial_port_data(port);
 	struct ktermios not_termios;
+	int throttled;
 
 	/* be sure the device is started up */
 	if (digi_startup_device(port->serial) != 0)
@@ -1099,6 +1100,21 @@ static int digi_open(struct tty_struct *
 		not_termios.c_iflag = ~tty->termios.c_iflag;
 		digi_set_termios(tty, port, &not_termios);
 	}
+
+	spin_lock_irq(&priv->dp_port_lock);
+	throttled = priv->dp_throttle_restart;
+	priv->dp_throttled = 0;
+	priv->dp_throttle_restart = 0;
+	spin_unlock_irq(&priv->dp_port_lock);
+
+	if (throttled) {
+		ret = usb_submit_urb(port->read_urb, GFP_KERNEL);
+		if (ret) {
+			dev_err(&port->dev, "failed to submit read urb: %d\n", ret);
+			return ret;
+		}
+	}
+
 	return 0;
 }
 


