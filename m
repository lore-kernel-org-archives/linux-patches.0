Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D67DBA45;
	Fri,  9 Oct 2026 14:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556600; cv=none; b=Iiv4G+iZSQXklgIJVd8B/bHO/a6YRlaelJxiuDrWXXtHm1+JxNdML/5bCEaPBbbsNlrMk4fGmkZvRGNROE8Iv/LQuKiFBR+i1QvMAyiIV8wJQeubZIJX8cOzdiZaNCA4eb5PvAplFPVjdhOUUx35rlV3fB+EjGOi8eKbgmtcTIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556600; c=relaxed/simple;
	bh=W4WDQ5U3ZjnMnNMAUkMVKIlCJWl7pYkUilrzkpHqw5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+Q9M2BcAc+T1r0ZpOEsr9O8ZColUchZWeTOPw7b7q43ou6wgtgU0UuPqA1n/PDZFWZzUAZAujVR3JzGNxzXE5Oy8kKHrFBMmNz5FsHPHb2m8tVPgfy2YQFuVyHuJR9poIuo6Es+mTQtykGE8q8t5S5vacTY9HRpOsxY6C/Hg10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=juDYL2A3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="juDYL2A3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6552A1F000FF;
	Fri,  9 Oct 2026 14:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556598;
	bh=Gd06CcLnTLOv1teR7aRld/5/ArfFfLl+72Zy4Q3JzZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=juDYL2A3Q3u62FXbDWX9P4pITQa7vWTkbKTMTVS4v6awg/sbQRs2ce1PGcno6WrIi
	 3MIPW5sYZViO2KDZCy6WRf/1rho0TpCNtt60B7TKibBLz9QpDJV7l5DMVA3hdoQVLc
	 tSqNi0+fskWV/Yhiv3g9szBx8c50xq3q5hnw5/VA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e5e28c3e953b2eebb16e@syzkaller.appspotmail.com,
	Alan Stern <stern@rowland.harvard.edu>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.2 207/428] USB: serial: fix port tear down use-after-free
Date: Fri,  9 Oct 2026 16:09:04 +0200
Message-ID: <20261009140950.674715621@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1191,12 +1191,17 @@ static void usb_serial_disconnect(struct
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


