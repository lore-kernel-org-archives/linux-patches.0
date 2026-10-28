Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208653;
	b=h4qNy71q8/L/gVX41zXaGIutKaGBUrjjAvUQpHIjMNjDdG8sBd0Z9sv/xtavU2VrTLRP
	 IGJw46p7vrB+cWH0LK/nKpMgkKj/+EBdQMcAhQ1GPkoRVPrRPhxKsQTTsWsQvAV2HfjeW
	 Qk3VgYA1Z0YXdZJCHTPiHHlOAuMvmwRaQSe1CYqdaAKQWbe12QIrfr7th7oKL+tGyweqV
	 cVI2VdXaL25tly4Wg5Gh3+uOsy78JOUgMwLQL5PGUSi4gFV0A3yrU0jIiatocuMifPkcO
	 xotCMGYzmwHg4qBQJN7IofMaif1fwV0B5FHNySuBD4UkU5mEFloBXkJIgiuSDI22qSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208653;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8/Y2Wa7wS0n2BVXvhCGa+sCuyNYV9hI/sq2+yxLTCXA=;
	b=rfxwC1Za2fzpOTRQCxZop+kbmi8drbJBAVrxTEmXeXNVPqjFrY/PJPFKVIOOh5FL07in
	 uLfqJkIJ9WkxiE+jfOD3JJMszFWprEC0hmFBmt4YxB3Zqevq4LfrhbscickN2ooE0FAXy
	 p4tG+b07vIf+2D0bxGMJ+5UMFmLDmTArGL9flbMn+vlcbXg7DRn8tcv89c8IJ9r3Z8KgC
	 ocBOzZeFe4NVZIk9VvwA6FKby3YX6AXAZwFdDZ3/l8OupijKEsxkjZ5rcbfFmI60bxYNu
	 ZDP9SdlbTA1wgOBnC0wo7qcb/vm/1968SuUzkgmnBIKSi2lQvBVznUN6UPSi9Ubbq9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lEhuz+Kh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AA9606A321;
	Wed, 28 Oct 2026 17:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lEhuz+Kh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C579E1F01825;
	Wed, 28 Oct 2026 17:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208653;
	bh=8/Y2Wa7wS0n2BVXvhCGa+sCuyNYV9hI/sq2+yxLTCXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lEhuz+Kh/HuEhrCLzzMyUdTw9r+D4W3C+vhg6suPRyUBl8Fp0xrhk8L++VOJXGGVa
	 86ww9vb2dUkzuiQ9ZrIA7v/K25xOLNibdjyLj+8dgLkmlZCco3cgsCTvNw5OPTzWBy
	 Ejc6V7Dwk/cFLFf4P+IL62DT9NWIlyRIJ7AJCm1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e5e28c3e953b2eebb16e@syzkaller.appspotmail.com,
	Alan Stern <stern@rowland.harvard.edu>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 188/516] USB: serial: fix port tear down use-after-free
Date: Wed, 28 Oct 2026 17:55:40 +0100
Message-ID: <20261028170007.956013428@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1098,12 +1098,17 @@ static void usb_serial_disconnect(struct
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
 	/* let the last holder of this object cause it to be cleaned up */
 	usb_serial_put(serial);
 	dev_info(dev, "device disconnected\n");


