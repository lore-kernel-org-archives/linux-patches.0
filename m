Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623695;
	b=FWxd+Of1nkKEGR+71BsNFv0tvHhq9r++BbIdTYHvau0BMVjyPFkYJYEOBwUx5I1AcMzX
	 noCTSXjoMdnJo+zjq/aCOGRq+1g970NuqXo4M/c1EtViPI8tl790jPbZkbfjOmUTVwVIr
	 +mmpitAgsh2ePCDfK2JWg9psSgMFDN64cmYNVGQRLwxYqEDDvRGesijHgsvFx25wHCoRY
	 0KtvOZ2antlG3rMbG5Kgm6iMnGiS05dWoIfX15dHi+Gv0OVDuyYiSDZZOxX2Bkb4LR3mI
	 H9s9L9ZaceXyWGXGXDgbT0Ua24VtvrWSXlyEydJprPM88eSQQjZIO38RUAsr2j7ZKxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GwTMNTaVLH93eJsh68Kp8Ew1/xLKnEYTozrB25K0Ln0=;
	b=0X9TD9dLAKrQGhF6rFz+I4sqxYENxFU7wmh5XH5BgA+nkkIXFp6unMNLtgDnILjuzwKc
	 7RrjQTM5TgvxRJJSRwZSJyqvnF/UNoG3F9I7lalEtDTBTAzoB3DdLqJSL4kHvnP/8Y67l
	 Uw0Jn6MX1r9mOtr9EpFiNNkZ6/4Ny5LDY38fKuBpj4qKghEnYJVuuJDiHy9NLbBDXh2Ig
	 qZ55IYUbc+I1kmr7SWO8FdeZGBjrdJpkp+9xhsAteSxa3xlEwWeQogKgea1dVdIXzutVG
	 0s7G3Q7IpVkdYoHBomRI0LIrJKfLOz5bP8LdUqN29msH2yxGKF1bBzxBkaBfoNfMOKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1j9tFmHJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFD9606A335;
	Wed, 25 Nov 2026 16:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1j9tFmHJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484361F000C6;
	Wed, 25 Nov 2026 16:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623694;
	bh=GwTMNTaVLH93eJsh68Kp8Ew1/xLKnEYTozrB25K0Ln0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1j9tFmHJ1BzUOjR7cNznWFCHGC+LTQwhhxeAmxglrd2Eym8vZqgc+GgScaAOxTUJw
	 S7c8N8a0wq3knSkwjXCrBKFLna8GYmzvnzIvMXp1RUV1wotA1Vdqa6GSXdebLNuZcp
	 AW0xiANq4X6MCJyLJJ5ibMPGor++WvzjQFMNlMas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 942/990] USB: serial: io_edgeport: serialise MCR accesses
Date: Wed, 25 Nov 2026 15:38:29 +0100
Message-ID: <20261125143844.056711204@linuxfoundation.org>
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
@@ -877,7 +878,10 @@ static int edge_open(struct tty_struct *
 	spin_unlock_irq(&edge_port->ep_lock);
 
 	/* Must always set this bit to enable ints! */
+	mutex_lock(&edge_port->mutex);
 	edge_port->shadowMCR = MCR_MASTER_IE;
+	mutex_unlock(&edge_port->mutex);
+
 	edge_port->chaseResponsePending = false;
 
 	/* send a open port command */
@@ -1398,9 +1402,11 @@ static void edge_throttle(struct tty_str
 
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
@@ -1435,9 +1441,11 @@ static void edge_unthrottle(struct tty_s
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
 
@@ -1478,6 +1486,7 @@ static int edge_tiocmset(struct tty_stru
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	unsigned int mcr;
 
+	mutex_lock(&edge_port->mutex);
 	mcr = edge_port->shadowMCR;
 	if (set & TIOCM_RTS)
 		mcr |= MCR_RTS;
@@ -1496,6 +1505,7 @@ static int edge_tiocmset(struct tty_stru
 	edge_port->shadowMCR = mcr;
 
 	send_cmd_write_uart_register(edge_port, MCR, edge_port->shadowMCR);
+	mutex_unlock(&edge_port->mutex);
 
 	return 0;
 }
@@ -1509,6 +1519,7 @@ static int edge_tiocmget(struct tty_stru
 	unsigned int mcr;
 
 	msr = edge_port->shadowMSR;
+	mutex_lock(&edge_port->mutex);
 	mcr = edge_port->shadowMCR;
 	result = ((mcr & MCR_DTR)	? TIOCM_DTR: 0)	  /* 0x002 */
 		  | ((mcr & MCR_RTS)	? TIOCM_RTS: 0)   /* 0x004 */
@@ -1516,6 +1527,7 @@ static int edge_tiocmget(struct tty_stru
 		  | ((msr & EDGEPORT_MSR_CD)	? TIOCM_CAR: 0)   /* 0x040 */
 		  | ((msr & EDGEPORT_MSR_RI)	? TIOCM_RI:  0)   /* 0x080 */
 		  | ((msr & EDGEPORT_MSR_DSR)	? TIOCM_DSR: 0);  /* 0x100 */
+	mutex_unlock(&edge_port->mutex);
 
 	return result;
 }
@@ -2430,12 +2442,14 @@ static void edge_set_termios(struct tty_
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
 
@@ -2930,6 +2944,7 @@ static int edge_port_probe(struct usb_se
 		return -ENOMEM;
 
 	spin_lock_init(&edge_port->ep_lock);
+	mutex_init(&edge_port->mutex);
 
 	init_waitqueue_head(&edge_port->wait_open);
 	init_waitqueue_head(&edge_port->wait_chase);


