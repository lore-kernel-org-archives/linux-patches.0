Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210930;
	b=C8RyuDX6oW6n0M6LvISMT2xxnRwgOn5enLbGZLgFmvWGOsf17cYIWE15W+Gf/wcE6Wz1
	 uDuduA8K+aBgscwEn93SjsESuO7+9e5rHFr8mvHfW2AUng7pIWrUB3DXT8BprpMcrxfeS
	 oCzfDfSag4eL53rP8bjhKKllx6H9+5PT8HMJi/P/zfLxn8Iy1TaCWaDtZ+kch/aBiwhoE
	 mgcq3hSJaOqCV59o/qiLS87ckKbtVaJw45W8cZFOjV3zOnwF3VR9W2gC21LmNkusYpVt+
	 DHv+05TNi9tZydctsAjErAbcnoQxRMMaWIDrTaC7/WxNepu0YvEKj+cN8pE1ORbufQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210930;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nIfN2AaWBqFJJ5GuYIp3z5E+K4EUXB03fvk//DXYwg0=;
	b=gpFqBZfr7fBZe1VprZhGD0gfcF0aZqB8tNgE+ZLHA2mxw7qk4nSJFpfEQcGgkhhRK9qI
	 AKv3y7eGAB8d9mWAAuzRgx3vxjbvIoel54gRcQ5B64N4RodO3DJ3lfHMw1SYlL+Sjr5GD
	 x4GkYdyOfDByVoGMrs9rE4GxxZ3fXGeNM5OiX9k50w/hw47cpYR47uNIcIh24N9fnN3eJ
	 +i1lqlSwLKDwAKiZcpVix7fctQhS8NHi8riObTcHomduTXa94Igyg6CMP63Ho0CxoR2IS
	 YUE8PcalYCo+v+cBR4d6ilemhMw/PY6vcjyr+nv92yqw5UkPCMYbqwRzgnMNlNzmSzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=faBNLikS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BADB606A31E;
	Wed, 28 Oct 2026 18:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=faBNLikS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE141F01825;
	Wed, 28 Oct 2026 18:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210930;
	bh=nIfN2AaWBqFJJ5GuYIp3z5E+K4EUXB03fvk//DXYwg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=faBNLikSIVsyUiV6RIrEnZ3NQalH47hQNvZdYMkQG2VrJaZC39Eks0e5TlA9o8tyt
	 iGeDUvlyei2zNWQGE3zUhHixJDMwLX4FUx9/QWvCZNDD/KugoJ4E5Z4XhCFCk+H7J3
	 g43eScbgMxKfLSay8aoeIzrkDaAgOL0sjQGIKWW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e5e28c3e953b2eebb16e@syzkaller.appspotmail.com,
	Alan Stern <stern@rowland.harvard.edu>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 199/571] USB: serial: fix port tear down use-after-free
Date: Wed, 28 Oct 2026 17:55:46 +0100
Message-ID: <20261028170012.728830387@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1198,12 +1198,17 @@ static void usb_serial_disconnect(struct
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


