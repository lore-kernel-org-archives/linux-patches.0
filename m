Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3254847010D;
	Tue, 21 Jul 2026 20:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665277; cv=none; b=cuao56JkITJw91Ktoh7OfrKoY0iXHHQzIQSPbaRACuLzQMs/R2s9s7jASOpi+zX1N2MpBte7wzMx60sg0YUCG8r0pbqEdoY4um9ELcwLLKpDS4WqoTXuutjXqQkIzlh4v6lGWm+zHGXCogIOyrNckgl42So/YmIgxIYZ/av0GGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665277; c=relaxed/simple;
	bh=/n3j3gd1E4puImiHUalwUfk+PxmQmZslzwsycfylvYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJlhUSbV0ZyQUi1uhwWzah823rzA7CXlLcCJUQukhXmLw8F3BHJRO9TOngiHYVou+jgchbbpnzGFVWhgby9bGkiaVKBnmN9K1hsIKThM91qO+irwe6vH5iXuAiptv6oAm26P3BIoXd05FzU/BSfS6mcULfvHVWzUwd9g6e9oq+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t5mX6mao; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t5mX6mao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94AA91F00A3A;
	Tue, 21 Jul 2026 20:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665276;
	bh=/KTxW/c4AejtVrnUa7FcCmbib7WHdp0lJNRA0aD6QJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t5mX6mao2bYSN5el6oglPSp4L9dUZ1IW7nDQ9JnLCpTPecbZnOuFrgfmn5Ie31YtW
	 Hez7PJLBwdH47CO2YOWEsIJaHHBOL91lmihLxktjcs9A7j+c+7Q/fM5S0NBaa5KusS
	 104NcT3MvS6CQGU9pgAA/XK6rkPHWCIXIbgg2LKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 0244/1266] USB: serial: digi_acceleport: fix broken rx after throttle
Date: Tue, 21 Jul 2026 17:11:21 +0200
Message-ID: <20260721152447.275747656@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
@@ -1073,6 +1073,7 @@ static int digi_open(struct tty_struct *
 	unsigned char buf[32];
 	struct digi_port *priv = usb_get_serial_port_data(port);
 	struct ktermios not_termios;
+	int throttled;
 
 	/* be sure the device is started up */
 	if (digi_startup_device(port->serial) != 0)
@@ -1100,6 +1101,21 @@ static int digi_open(struct tty_struct *
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
 


