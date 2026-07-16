Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1F342CAF3;
	Thu, 16 Jul 2026 14:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212321; cv=none; b=n+F7wKDCVCNrPHMplKnebpFOl4dbG5Zvc0BVkkGrANJJcQtXj+muOfd2jiuc+s0EW/F2DuYLTS60Ll92Hcte5PQrNPNsmJwAyBvd+bxvxTRzuQ/SzrpruLU9xd6ssydMGd8ojRhHtlDniT1mqumdqVLgFD2v1BdJCLtlymi8jZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212321; c=relaxed/simple;
	bh=mesEE3Feg8kuXmn7bgibYIDYxLvMt91Jjsi/j4K7ZDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8WJD8+Zu+AJqIP2MSmmX4PWd/9+gVvWqvhmUjBeSxnD8jpfLKSWdo8JerHApSMDi8eglBHN5E0P4eZ56K6b8ki+5XsBsmpFKzOuklyazt8gHhi+O4JN4GX4nYNpvZG4KjFpSYZXy6uoPjAI2OO+yZ6tQ6fmfhmPMW/yy3GDZKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SFCp4EEj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SFCp4EEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E3D1F000E9;
	Thu, 16 Jul 2026 14:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212319;
	bh=vAd676zcl5teaKYkSz0cppWnfJlyHN38wJFWaCswAAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SFCp4EEjgfC3iRtq2or1EYHd/Pru2LgD4O+yulzcKHwwOTJp7uunZrL1rLH0R4DPA
	 qnpxC5ahFH9tY+zxqWsIMFgGSXk5dYxsvNP7BokuOqKHtwXJDpUhWnMtqlqN3eABkM
	 3HqTZxw8NGmD/y2mt4/gqfoLDjQBkMsqX4Xt70J4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 239/349] USB: serial: digi_acceleport: fix broken rx after throttle
Date: Thu, 16 Jul 2026 15:32:53 +0200
Message-ID: <20260716133038.710179939@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


