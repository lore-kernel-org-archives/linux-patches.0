Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6663B582F;
	Fri,  9 Oct 2026 14:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556026; cv=none; b=IVuvfY8ywoczYdLOBGjX+XJCRIUan11YMWynTuJ+Xhv8pt4QYwCJdsvmrxKsnfaWpzd6pK+qRzOskiMEdCYnGY9ejQxy9lWU3HwfGPIPqE3mZL+NXcQsuPV0PWJjnBUOFbZMn7wKZPKMcL2fJKrtaLw1WrBQRSs807L35yzyNs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556026; c=relaxed/simple;
	bh=HjhPOpT+D/YyVQV2WadvT/q1zdADk1LVh2ia/hIZzKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfzRrcD1WoQ0WM6MKaGUA1zltTn1m3Wc3wzUSu29H1Ydzh0y95KOHoKMVW9uLga0NtRwOpdEL8yG19kYKtsVfC0KsgOlBPzyM+rQKRseUAf3imt1rTMC7b6ikbk5w8p1Bi7h/rVgockfoAGoqTO23/0wu3G/OHPClBZUAzbsmiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTZ9fiKK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTZ9fiKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C481F000FF;
	Fri,  9 Oct 2026 14:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556025;
	bh=deY4y3lwZpQ4hv1mzOg9XrS2bSWyBhdFoZLOR3u4b84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tTZ9fiKKnr2RcNGzUORXvKzh5MIcUDDd0OkjWyxGzGo1wgQE6y6d8j7+WzEjgal11
	 rI6Rc2kyV8XdAyOBeLYUW8DqDbc+w9g7SfdCxwzDZxEmVY8jdC+44Iy1v0u8PtvqYw
	 Yh3ObmtiHrXCEaX6kN9VFej5fzy9+NHzsl4/OdpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e5e28c3e953b2eebb16e@syzkaller.appspotmail.com,
	Alan Stern <stern@rowland.harvard.edu>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 162/403] USB: serial: fix port tear down use-after-free
Date: Fri,  9 Oct 2026 16:08:43 +0200
Message-ID: <20261009140955.879946202@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

commit 33c920f7c5952dfc42d1b8ea6efe16b1f0bb0c5b upstream.

Some drivers for multiport devices access port driver data from
completion handlers of shared URBs submitted at attach() or first open()
and stopped at disconnect() or last close(), respectively.

A simple NULL check before accessing the driver data makes sure that a
port state container has at least been allocated, but a completion
handler can still race with port tear down.

Reorder the disconnect handling so that ports are not deregistered (and
their driver data freed) until after all ports have been hung up and the
driver disconnect() callback has run so that all I/O has been stopped.

Fixes: 2d93148ab698 ("USB: serial: fix lifetime and locking problems")
Reported-by: syzbot+e5e28c3e953b2eebb16e@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/6a7e6fb9.ec5dc6cc.21cb3f.00c0.GAE@google.com/
Cc: stable@vger.kernel.org	# 2.6.30
Cc: Alan Stern <stern@rowland.harvard.edu>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/usb-serial.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1194,12 +1194,17 @@ static void usb_serial_disconnect(struct
 		usb_serial_port_poison_urbs(port);
 		wake_up_interruptible(&port->port.delta_msr_wait);
 		cancel_work_sync(&port->work);
-		if (device_is_registered(&port->dev))
-			device_del(&port->dev);
 	}
+
 	if (serial->type->disconnect)
 		serial->type->disconnect(serial);
 
+	for (i = 0; i < serial->num_ports; ++i) {
+		port = serial->port[i];
+		if (device_is_registered(&port->dev))
+			device_del(&port->dev);
+	}
+
 	release_sibling(serial, interface);
 
 	/* let the last holder of this object cause it to be cleaned up */


