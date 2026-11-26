Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704790;
	b=AVdhPmafaIFDUNQEotHdnQWIL7WFp06Obg1i1hgvm7UC9LKEqtsrK7SUH7dZ8CrOPEH2
	 mBtwY8aj0pYB6DWrnuzohds+V2zz3nP6Q246V4ensbKutMaNmK5ExOr36KiCjHQ4dXWkq
	 W8/HGmwTxIJQc4WkoCAzM6fj5nABM6ZoV9FchvacocRKL4kYNRXhQI2gvakyczq2mKYhP
	 +8RGjRNELXbOMJPSDnOc193aKH7LPNBUz7JJsWhh1j2l6AFgdeJ2zoMYZ0vV8+RJK+xPM
	 lOHh5yZv1Vztglo3gIIDa+ls1z0aA6EB1IbV5Kwj9AtMWOrTk41+ug3AO0cRcABmz4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IOCeQ6w5JsvsOKBO8xQG8cJB5krbA6o6pJqbAO9nJls=;
	b=Ha7ypubU1gKpwx0TUhOSDTKhwVtTiWKqz+aJPsJWhZfrZY4umocMa2LW7U+4uTxJpAMY
	 9RuUj1g3mn+IFgEFi0gKKfcLQ0jFCuXBRcv2PiG7u9d7Pzck0em45VcovVZnataTRWh6X
	 Suu2+GN4CPyPqfSoYB5ilnRqmlzcI4duAVIEACoXYFU/VKpllPFB49INcyKozpJOqz3vS
	 PQOcev5UN5Tv+u62mOIPu9RAebYMLb1JCIrbwszN61XBnLFuMhyWZWB/YEIhqrX53Gm1s
	 vyD/iSCK+4RytLA3BbHWH9KHMOYu+aCiHSkxBPxxm/oqEJOKHpMR2leidOw+rontUxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yjRY9mcq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C64960A2635;
	Thu, 26 Nov 2026 14:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yjRY9mcq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FE81F0281F;
	Thu, 26 Nov 2026 14:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704790;
	bh=IOCeQ6w5JsvsOKBO8xQG8cJB5krbA6o6pJqbAO9nJls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yjRY9mcqItFDdxYs4fldyM5O9eLF+CZju0oMTT7S1way2L9GOb81rQlTsUO76Mc4J
	 noKKp4jeDKT/anyS7G1CIM3Who013SYhQou3V95RAk6vM6m2eptjhFIPZmNlM/se2W
	 56iiVvJB086tw3TxdRIioEll/h2QWurZdHgaWFrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+763813d65c7e18c1b6d5@syzkaller.appspotmail.com,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 237/265] USB: serial: io_edgeport: fix NULL-deref on early status
Date: Thu, 26 Nov 2026 15:39:27 +0100
Message-ID: <20261126143621.811080959@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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
@@ -953,11 +953,6 @@ static int edge_open(struct tty_struct *
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
@@ -3081,6 +3076,11 @@ static int edge_port_probe(struct usb_se
 		return -ENOMEM;
 
 	spin_lock_init(&edge_port->ep_lock);
+
+	init_waitqueue_head(&edge_port->wait_open);
+	init_waitqueue_head(&edge_port->wait_chase);
+	init_waitqueue_head(&edge_port->wait_command);
+
 	edge_port->port = port;
 
 	usb_set_serial_port_data(port, edge_port);


