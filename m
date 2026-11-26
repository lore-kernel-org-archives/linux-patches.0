Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704869;
	b=OhS0T76jsG/ZSCok3TTNXDRB5x2OJQq9lMhIdVKn7t3VuzPkfUKvZYuSrS8vaS2QPuUQ
	 c4/rRJX8bhjZFYGZVr1x1acOcX8Lq1iZQ5fHWx1oZuRHSzHjRyh5WjMHpzXIdcBwwm4L+
	 pSpBfctIdcUOLZt0pxbYN+37vQA1KoP7GC87o1qNRXawlkH5cuOm+V1/Q83XdqRDtuEvk
	 ExAv2g9/zTU9XbidtWZsvuc/q5RxJo0YG9sfzFaZClCAkQdJEl4mNTadjVm9QZUXxHE5n
	 RSYV6hZ59tnEfRqm3vnexBKDZpfSG1OhvW3svVZvVn/fc8DB6FUWSR5wTXsC5iQ+a/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dnn3UXKl/h3sP2E9e1N+koIyZlJU0QzRcd9gVeKrE3M=;
	b=sExUorkE0XbG/l4ztJ4goR+OvBZJiteCe+0fsR1kXJg07zrWKlZl5Ah2JLg6OWnjhjTJ
	 pA5A2P2pcIfih2TdUnNHKhi5zyxeAOtTk0ZVENAzDsuYaAqgz16SUrmyXiPxxrF4V/+Gz
	 9rDD9PdDoWz+jqm03y2E0C7f3QOTLQQHvsvHmhWKatBqDCQyHPTD5J2TnSEm4sFrhrDEJ
	 +KykwGrafkrpxQmKIZ3/ZZdRlyOr0pLSce2WXopVg8NVjidUBjADewKI68C7cHTTnpUX9
	 qzPc5IEjoMljfUQ2GoBEJPkvFvCnBldKQE/KKsKdaUN+nC76ViDEMtqv94+AX9OdG1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nu2SpNDC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C872606A31E;
	Thu, 26 Nov 2026 14:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nu2SpNDC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227C61F000C6;
	Thu, 26 Nov 2026 14:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704868;
	bh=Dnn3UXKl/h3sP2E9e1N+koIyZlJU0QzRcd9gVeKrE3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nu2SpNDCrQbi/IKpjjSfIv/jldRBN+kjbldmr9amVjocQ7frNPVP5tUbPnqgS7yTQ
	 EGXiMo6ZgvAUcn7t2vJnB1OGO266trOkqSh3wRMUyxXtsq44obDmEldzX3gEoJvIZQ
	 j1I+s1d19fd1dKTz147x9J+7Q+LGboEAiyEXEv0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 242/265] USB: serial: io_edgeport: serialise MCR accesses
Date: Thu, 26 Nov 2026 15:39:32 +0100
Message-ID: <20261126143622.205039838@linuxfoundation.org>
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

commit 6e4629504d7e5a22dd26f3b262f0a0f80e3cad6a upstream.

Add a mutex to serialise modem control register updates to prevent
concurrent tasks from interfering with each other.

Note that the register updates are currently asynchronous so a task may
read back a value which has not yet taken effect.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/io_edgeport.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -168,6 +168,7 @@ struct edgeport_port {
 	struct urb		*write_urb;		/* write URB for this port */
 	bool			write_in_progress;	/* 'true' while a write URB is outstanding */
 	spinlock_t		ep_lock;
+	struct mutex		mutex;
 
 	__u8			shadowLCR;		/* last LCR value received */
 	__u8			shadowMCR;		/* last MCR value received */
@@ -954,7 +955,10 @@ static int edge_open(struct tty_struct *
 	spin_unlock_irq(&edge_port->ep_lock);
 
 	/* Must always set this bit to enable ints! */
+	mutex_lock(&edge_port->mutex);
 	edge_port->shadowMCR = MCR_MASTER_IE;
+	mutex_unlock(&edge_port->mutex);
+
 	edge_port->chaseResponsePending = false;
 
 	/* send a open port command */
@@ -1497,9 +1501,11 @@ static void edge_throttle(struct tty_str
 
 	/* if we are implementing RTS/CTS, toggle that line */
 	if (C_CRTSCTS(tty)) {
+		mutex_lock(&edge_port->mutex);
 		edge_port->shadowMCR &= ~MCR_RTS;
 		status = send_cmd_write_uart_register(edge_port, MCR,
 							edge_port->shadowMCR);
+		mutex_unlock(&edge_port->mutex);
 		if (status != 0)
 			return;
 	}
@@ -1534,9 +1540,11 @@ static void edge_unthrottle(struct tty_s
 	}
 	/* if we are implementing RTS/CTS, toggle that line */
 	if (C_CRTSCTS(tty)) {
+		mutex_lock(&edge_port->mutex);
 		edge_port->shadowMCR |= MCR_RTS;
 		send_cmd_write_uart_register(edge_port, MCR,
 						edge_port->shadowMCR);
+		mutex_unlock(&edge_port->mutex);
 	}
 }
 
@@ -1600,6 +1608,7 @@ static int edge_tiocmset(struct tty_stru
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	unsigned int mcr;
 
+	mutex_lock(&edge_port->mutex);
 	mcr = edge_port->shadowMCR;
 	if (set & TIOCM_RTS)
 		mcr |= MCR_RTS;
@@ -1618,6 +1627,7 @@ static int edge_tiocmset(struct tty_stru
 	edge_port->shadowMCR = mcr;
 
 	send_cmd_write_uart_register(edge_port, MCR, edge_port->shadowMCR);
+	mutex_unlock(&edge_port->mutex);
 
 	return 0;
 }
@@ -1631,6 +1641,7 @@ static int edge_tiocmget(struct tty_stru
 	unsigned int mcr;
 
 	msr = edge_port->shadowMSR;
+	mutex_lock(&edge_port->mutex);
 	mcr = edge_port->shadowMCR;
 	result = ((mcr & MCR_DTR)	? TIOCM_DTR: 0)	  /* 0x002 */
 		  | ((mcr & MCR_RTS)	? TIOCM_RTS: 0)   /* 0x004 */
@@ -1638,6 +1649,7 @@ static int edge_tiocmget(struct tty_stru
 		  | ((msr & EDGEPORT_MSR_CD)	? TIOCM_CAR: 0)   /* 0x040 */
 		  | ((msr & EDGEPORT_MSR_RI)	? TIOCM_RI:  0)   /* 0x080 */
 		  | ((msr & EDGEPORT_MSR_DSR)	? TIOCM_DSR: 0);  /* 0x100 */
+	mutex_unlock(&edge_port->mutex);
 
 	return result;
 }
@@ -2590,12 +2602,14 @@ static void change_port_settings(struct
 		return;
 
 	/* set up the MCR register and send it to the EdgePort */
+	mutex_lock(&edge_port->mutex);
 	edge_port->shadowMCR = MCR_MASTER_IE;
 	if (cflag & CBAUD)
 		edge_port->shadowMCR |= (MCR_DTR | MCR_RTS);
 
 	status = send_cmd_write_uart_register(edge_port, MCR,
 						edge_port->shadowMCR);
+	mutex_unlock(&edge_port->mutex);
 	if (status != 0)
 		return;
 
@@ -3090,6 +3104,7 @@ static int edge_port_probe(struct usb_se
 		return -ENOMEM;
 
 	spin_lock_init(&edge_port->ep_lock);
+	mutex_init(&edge_port->mutex);
 
 	init_waitqueue_head(&edge_port->wait_open);
 	init_waitqueue_head(&edge_port->wait_chase);


