Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620575;
	b=YlaSsuysLjXjXd+Ixl/TsyiEyDK9k+EwvEOIiozrbvL3QxhDfFrQPc5iGxTLZUF5b7WI
	 gy817mtS043HKMdmgsaYdtUS9S4lrZPJZNLOBHSlR3DYVAsFiEP08bRxCMzNWDKOnPR8h
	 jXiZSDxf/f11Mt9VQ5F4TxhoY2Cv8Pr0XAAEHVfcAxVxxlcPlcWm+UMVdAxTB6q3ovl0F
	 CsWU7Iw3l2L/D1WALozL495p+o5J+vQQvFIDMdsGwmpOmMuMZNxqwNM50h+HihQu3Yak+
	 gBhWINRM4aN267aWCchg50w7i1uhg3BQSFFFLRkXokQWkvQiIfNmzwqtAF+i8If98Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uHztLC0aE+Kt4aQh5gtVixBzrbSGu6VCba9mTIFp0tM=;
	b=Zn6jhG654gmziXnDCt2A6GNWDstmHaX5gOvMCwFpNKA8D4oTADLXRAvgVfdJE6acOygU
	 ti7BmyiFQ8ttA8JbxdmVRdQirJlxm4UKDjWkGjprAX10xwiH55D2zClU6RNtNGJkH4L5Q
	 PiTCVHVIEmPVDvudSfoPBS7hqBnjTMPy8+DZSPW+6Nk4dk55SPzbErprE8dVea1BS9SJZ
	 K4w0aF13mbNwQ706QOjSPKEfos5nY49Gqe0OoixgMx3d69sPwkFTeKtON+vG1Zk8TpEuo
	 mMBFAeVMvaoKGM8rCLh+8jKf0D/tFSq4jiiUL4wZFi4IUukLtd1Q5tN0U4LYLqj6R3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fh4jyWqz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FD3606A321;
	Wed, 25 Nov 2026 15:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fh4jyWqz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F69B1F000C4;
	Wed, 25 Nov 2026 15:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620575;
	bh=uHztLC0aE+Kt4aQh5gtVixBzrbSGu6VCba9mTIFp0tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fh4jyWqzkg7YNx5HKPowbjBDTtDTxU6uWgIc9oDtosX3bQYX/Q9qYXMkcE1reBUJj
	 eCjvHRo3JmhaV9vqqQUjkjsSOqTH8CZ5tFuDUVQyb3nka5Y+K7UNpN6ITJSeHs8O7+
	 ERJ9/X6/+kN0W2YvGoLVIuMBqOglV+XBlocL4Z44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.3 0962/1005] USB: serial: io_edgeport: serialise MCR accesses
Date: Wed, 25 Nov 2026 15:38:20 +0100
Message-ID: <20261125143844.204916138@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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


