Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041D62FDC53;
	Thu, 16 Jul 2026 14:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211113; cv=none; b=UyUq9JV6fiSFahc9ntVtrhSLGV17BnPiNCagt4qMmuK7EflsPRLwMz9PwgcwBeLW+Rqn3A0smbWTLewCZECQPnnIYa7KrOPYH3+NhA70KEk1fPa4i0pbUjyWD/HoQyyfaoXnWzQORwu11pgZjH582BlZWbvptE8FAVE+zpLhuwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211113; c=relaxed/simple;
	bh=hyQhC2A0B/ltgx478XTqeYKge/IpFYiuRl2Saya8EnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AnPdb+4cATZw7gUwvHaL1OJ6tviNgycqoQZv9bEwzkhUkF8tZpZzCwEkdzJF6hEqNh9XYGC0PqA86n0TEbhbgQZkGS/i06GOlIFK+3t2Qb2G0LULBFywDV/Pkc4orhogaN/rw/9YXxcRw5XoMVQWEmM5UlNevkPxZ0gFm/lSEuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q2VXb483; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q2VXb483"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C311F000E9;
	Thu, 16 Jul 2026 14:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211111;
	bh=5guzmoeumBO4WhLdPKIy+fs6Yy84ZZgLJIUZrk0Ty2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q2VXb483KPY0Kbdsa9kpqEKzaFb1/z6GAFy+y96ylyWs+sbPbuMP0pmciHKeOH9/Q
	 jpzdNFtW2QK/yO5Ia9tQTjkaftVr/yRuG4bKWLm3E6cc2l6SqiH1zQB9KunsH4G1NQ
	 t/HB0hH4oYLRsHuAs7xV5Dpdck/AEL1fwuDOQvGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 304/480] USB: serial: digi_acceleport: fix broken rx after throttle
Date: Thu, 16 Jul 2026 15:30:51 +0200
Message-ID: <20260716133051.394528688@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1071,6 +1071,7 @@ static int digi_open(struct tty_struct *
 	unsigned char buf[32];
 	struct digi_port *priv = usb_get_serial_port_data(port);
 	struct ktermios not_termios;
+	int throttled;
 
 	/* be sure the device is started up */
 	if (digi_startup_device(port->serial) != 0)
@@ -1098,6 +1099,21 @@ static int digi_open(struct tty_struct *
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
 


