Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B70334DCE4;
	Tue, 21 Jul 2026 22:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673302; cv=none; b=nII2vQWBdbxKs9RAvJbEZmkW8ER03FEapMzukpLgquNiiUTFUl8/7I5iab8Hayjg6nydW6SF/NePH0YWApmjXRkqcAUuLO5C52S9tBPHIrH6UmWDw7ee3D0J/Q5XajfB13tTYHs/mo2XkiSpsIvp5Y3ZchSZVs7e+0vZZnLqgcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673302; c=relaxed/simple;
	bh=FO/pM4dSrHad95eUCb2cmx5yuADkPoqCgWFRYFR4dh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNCv2x90Q/+My4fqcKPnHWNikedmA+xr5mdfDwIE+5NuR6vuYurpJpxpJkIBFBU5smwsQXK3ii2dx+mXWQOdqQ2N2LdoJ4oABHop8Dp+wK/5npQzkEmNq7cEjUO2z5OaMqr4ATk4XQBVwN6f728PRc7RLzQvgVIJoLHtID9FHc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ov9IzuTR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ov9IzuTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D075E1F000E9;
	Tue, 21 Jul 2026 22:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673301;
	bh=GpEYuLwapbWtho6v4UX7fpjnvDu5EU05jrL8TVOZdi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ov9IzuTRJZXRKHKz6oiM8AaXqrdAKBnmbxn4RI14cb6N+s+JUnO/Std/lOMWgo33p
	 F7SfY29NIuMYQcZAq9LsiIW+S3VWu+EwwKelbwZH83+BJcUf0PsmkcMVmO/vQmS01i
	 8UdidEdqvzbcquSVI6p8eO//yehTINr4tK/Aqwe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 110/699] USB: serial: digi_acceleport: fix broken rx after throttle
Date: Tue, 21 Jul 2026 17:17:49 +0200
Message-ID: <20260721152358.183202952@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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
@@ -1070,6 +1070,7 @@ static int digi_open(struct tty_struct *
 	unsigned char buf[32];
 	struct digi_port *priv = usb_get_serial_port_data(port);
 	struct ktermios not_termios;
+	int throttled;
 
 	/* be sure the device is started up */
 	if (digi_startup_device(port->serial) != 0)
@@ -1097,6 +1098,21 @@ static int digi_open(struct tty_struct *
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
 


