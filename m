Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705713;
	b=SzLlUAcHNF86p44MnRL8Q9iZlaeLhWFC7uArJNjL/0KN2hkZj6fQ85myWXRXkqIL6Lra
	 gYwL9PAkZDTL50b8Alx0lV1aSLF35PpHe3RD1X5hEotWdD+oJnGLLq2efd1HPeO4smLoU
	 N9wKrGTA+rm8jmiH4dVpB6OQcFoP2s3wOsxBbvvdiFmVk2lGoQzg70vZOq+1s/lhZ4FKC
	 m6LirBdSx53QOU/d9UXNcQunmkuWokBNPEX0GXXisfL044+6KvQH1vNO5VKwUX1eLEiyS
	 QZz8l6EGYmwkt9CidVPv4Im2obqkZ9kACGptjkF1D5kyMoOmpOGbTlD2fg9+qUPi1uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BxPOQ4UNqcOZKGkHLp6Mogl0BN0B1yltikz9Y+siJnE=;
	b=uDesPw7P2neixFOU5ViMw0NN83oZipD/EYDLT296smPzQceUMNBzHhuZ+9R10aPG4sFB
	 wbfW33i9USiEuScw65y9AX1IfJmrX50ARePX/GqIL4q+8IPvZusdYil4MMXCk9zQjvz+J
	 jHKHCsFSk/m/LDpfasMJrlCeDOBQA1U8wz8wErumIq/wmSld6PTzieW/5HOZP6xnY6kf3
	 rgegXmPBHZqIKGgyrFvNF7S3qVa6j3+KnCzSV/msHvXdpTSD/i36/iY6j/SYKDLrpfv1F
	 /T99bvFBnycJtGaeCGS3K6yUUU+3kjDSHdCyEPEzCW9rAxIbYQljWto17EWBvmsFSbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZskyZjMe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60011606A32D;
	Thu, 26 Nov 2026 15:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZskyZjMe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94F91F000E1;
	Thu, 26 Nov 2026 15:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705713;
	bh=BxPOQ4UNqcOZKGkHLp6Mogl0BN0B1yltikz9Y+siJnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZskyZjMeJ98b111AWXkNHxDNQu6tz7nEUY761Vr8i/ZVVJMDGZ17IQOAJsKEJpw2e
	 VDxMD18TmbGwNbHd30O3RX5HBYugpFV2ZYIb+dR3Zrw8Pu0KCBjAofbAthJDLeLPZm
	 1r6VaTEhS6foU7ihnCd6niJHFZhJqMx8JarPy+Rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+763813d65c7e18c1b6d5@syzkaller.appspotmail.com,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 290/319] USB: serial: io_edgeport: fix NULL-deref on early status
Date: Thu, 26 Nov 2026 15:40:58 +0100
Message-ID: <20261126144013.305685608@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
@@ -2962,6 +2957,11 @@ static int edge_port_probe(struct usb_se
 		return -ENOMEM;
 
 	spin_lock_init(&edge_port->ep_lock);
+
+	init_waitqueue_head(&edge_port->wait_open);
+	init_waitqueue_head(&edge_port->wait_chase);
+	init_waitqueue_head(&edge_port->wait_command);
+
 	edge_port->port = port;
 
 	usb_set_serial_port_data(port, edge_port);


