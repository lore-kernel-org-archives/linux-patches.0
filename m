Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C39418A58;
	Tue, 21 Jul 2026 21:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671171; cv=none; b=c3pDvtqtn6Up+wWkZcGBgrK0bKQkGDY5+BaPnw2xCXTbZyOV0xA6ntfDziSt8CLR8vMDWhzIUG3sKiMDNYKtIRh/2fAs5Y/iCEmaSsZinn46tN7yNsAeU+bULWAdC5WA6OIERpf58bUHpDFbwWDnjODmXMypttuNo/yrVrJhSE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671171; c=relaxed/simple;
	bh=CyNPWuX2B6fphTSM0vz3QjEPIlxrldNC6+xP+c00Ccw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udClEE4ozRNWwyl8cZa0N+30tiujjmk9jPVMlkZ8WIbVmR+l/gD+8ShTLLGzMgAitBDFyoGbGTnInFhby9a+Vm9UbviHbSdIXOPnqP20k5BKhdyjWpSy12X6itYtmKj5KVxN9mI3tUKO0kws4hTOL3qAgcvSFlPE7Sl9DVzuL8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rzsU5n+a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rzsU5n+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537051F000E9;
	Tue, 21 Jul 2026 21:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671169;
	bh=uZeTCKYI8jzpMegA51DY+YNIZ2X4+N5EcAlshYGsWu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rzsU5n+aIsXz+nH3p5jiafCrIzDmHjbFF9hAYfvrgLz+I5OIZe9DUXWqD0ixS38aJ
	 L3L0LutrjR34BgMq4QsoXMkf7WCZGRvQ6ZOUu0LJvgtUrYkVMNt6V4IB0DGXy7SVH1
	 5K63qE802jyB3NXLuwPlR9rr/ph7kOTSGoP+6h4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 145/843] USB: serial: digi_acceleport: fix broken rx after throttle
Date: Tue, 21 Jul 2026 17:16:20 +0200
Message-ID: <20260721152409.273871702@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


