Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623676;
	b=lpgU2r0h/s/D0EhZ5kQpz3HADNinVOGMKOIxlVisRLYmkpbYt1ZnG1QyUpgvZ1u4WUzr
	 Hh38yfPTG8upXD/6TboXpwBZ4kuP4XU6mk3gtRbyW8coRKItmnQ62aTAeH6cTDMIJRcSr
	 ECjicNB7QVvrmEtRNbzbpAvb7tH03zCjlL+AtbBQx57bCUMNXnmdEezuoG0lFZ6n79d65
	 NZ1s2R/9LKyhdgXqfItfeeJLMcNG8ISre6r6tDD4fY1js5PA+QSeEt3cxxXyB9ZqJPlrp
	 S2JpZsN2msoUAa+pgM5aVHV2wtRb4ZjSdzUVhfyclPgZkNjHn+KQIg9nW1lG/l3jMTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623676;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ky6uswKtwOptGnRaT1q6Vea4kMxP5Y368nvTww4azg8=;
	b=ZG7HdhyzYsDc495vy3xO1DoVLNsnT63zuAUfNo5e0gGRTUrnSAA5KQKTDO1pUOigAWcR
	 9WTvOFWdAG6/WpRJ3hT2aluNXECSD45gJDUX6Hl++wlq6P3YBtB/zswEyl8dR0Wr+xbPu
	 y5rvMJ7JoQdbxSlHGkMgPRXmKxJQsrWrDtxi74CZlm3SXrTbtj1VjaPiAEbfif+6T7MYs
	 45QL8mbxZzdDORaDhdyluLvZT6VtlkUR0eDL9lelLMo6iEB8T/4TwIs/GeIcK5wqsKUcf
	 M9KEAbsV2Q0I629AiutLYCL9bX8ULaQNshtGBgHxF5Km2CrNKJfmtd0jr8XYCun2oDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CAFhQ9ye;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28986606A339;
	Wed, 25 Nov 2026 16:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CAFhQ9ye
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32951F000CA;
	Wed, 25 Nov 2026 16:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623675;
	bh=ky6uswKtwOptGnRaT1q6Vea4kMxP5Y368nvTww4azg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CAFhQ9yetdan3QYdH7UdlRsxJuzhQq+oB6KmaJFl6d+qpWmrygySkYWr9rft7zlNk
	 AJGFFZKvukOi9qt3wz3YUP+g8ASkPHuB/CFIt38CXIqzI/L6cyScQ5NgFKIBhj3d4Z
	 RjwV5s+qDxV9R+VxGn/3jcSYDqIw69RGkCtgtZHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+763813d65c7e18c1b6d5@syzkaller.appspotmail.com,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 936/990] USB: serial: io_edgeport: fix NULL-deref on early status
Date: Wed, 25 Nov 2026 15:38:23 +0100
Message-ID: <20261125143843.918185920@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit ae22e9b6412e5dc99e1cf8bd13c6176d44c7d42e upstream.

The driver submits the interrupt-in URB during probe or on first port
open, which on completion may submit the bulk-in URB before all ports
have been opened and their waitqueues have been initialised.

If a (malicious) device sends a status message for a port that has not
yet been opened this may lead to a NULL-pointer dereference in the
bulk-in completion handler when attempting to wakeup blocked tasks.

Move waitqueue initialisation from open() to port_probe() to address
this.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+763813d65c7e18c1b6d5@syzkaller.appspotmail.com
Link: https://lore.kernel.org/6a8818d8.ae6ddae5.3da009.0031.GAE@google.com
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/io_edgeport.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -877,11 +877,6 @@ static int edge_open(struct tty_struct *
 		}
 	}
 
-	/* initialize our wait queues */
-	init_waitqueue_head(&edge_port->wait_open);
-	init_waitqueue_head(&edge_port->wait_chase);
-	init_waitqueue_head(&edge_port->wait_command);
-
 	/* initialize our port settings */
 	edge_port->txCredits = 0;	/* Can't send any data yet */
 	/* Must always set this bit to enable ints! */
@@ -2965,6 +2960,11 @@ static int edge_port_probe(struct usb_se
 		return -ENOMEM;
 
 	spin_lock_init(&edge_port->ep_lock);
+
+	init_waitqueue_head(&edge_port->wait_open);
+	init_waitqueue_head(&edge_port->wait_chase);
+	init_waitqueue_head(&edge_port->wait_command);
+
 	edge_port->port = port;
 
 	usb_set_serial_port_data(port, edge_port);


