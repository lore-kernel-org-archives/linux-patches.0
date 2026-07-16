Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A476B4248D2;
	Thu, 16 Jul 2026 13:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209796; cv=none; b=mpdpyExllw/t8UtwZqfc7eewHAXHak6qdFdjEQSpMh+s/8slMW7BSd87T7gFuntjL6LKWvZrEv9sWEy+0X+BhFOncGtItrBYcvycaXaAJlpn7fGmeEJxj7RadvrbepsLRuPDQ4vUY4rO8Frh+5zXcMy/U963mfrRS/dVPgOnGls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209796; c=relaxed/simple;
	bh=21kP6Lg1Ct0b4hqIKFxKwX5wKSXIrkEvWZkXCFe3BWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obVu7c9125mLxDHPghaA640ke7Hr2CC9vLy0BCazwMhijz6sgcDlQZqNoB+vugqtTzP7gO5I3w/Dt7QvHUbfXubXXkRAn0rgoZq0YpzKWVI2Zm+iQ3lXVYNJCVcUvqLMt7mmupM98vI8fEjdanDs3Cg9W/qv6CuQo75htEETDOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzJkQ1g6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzJkQ1g6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7683C1F00AC4;
	Thu, 16 Jul 2026 13:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209789;
	bh=q5LPX6I7RlpKKVlVhe7jksjyJDF4SJjdSnI1X1RRuW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xzJkQ1g6Q7tK+CUy+GPizk5nGQz9KDgVfsoEPpdLynmwY7SZnD3uEU0cqJFAlsTeh
	 LjyI1iZFeuNtAbJJpEIHxMGW6OoH83krCMUHGILGKF6MhBwDaGhomXP78G2s2uVCqY
	 qzqTUkYJ7ZkTUaW6gnacxPdZRC/ZByqCqtayxNOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.1 320/518] USB: serial: digi_acceleport: fix broken rx after throttle
Date: Thu, 16 Jul 2026 15:29:48 +0200
Message-ID: <20260716133054.821568150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 


