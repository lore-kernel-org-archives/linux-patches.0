Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626242;
	b=4zJVKm+kDW7eE0A996GxdhQA1a7RHEbIFM36EppqYFBXLwJLgsg/pgBVfor6co7YJeUt
	 p9mcCh2YQ4baa3wl1YpP1uGYN6KOYmn0XE6c2NpnAzA14U1EhqOzdI8HR9/vgnxTrz8TO
	 rT5FthLJeIdwOYoU8WTM7JI3Mv/ioX0dGEAWTqzmy0GVMs26ltgWuNlfT+wnwk4uMRs0W
	 sFJcPbTRgT88UPPTtLD3pGl3SU54I4gtahtpIe8wAqjhxaRdriTmEPKYbP4DluuRU7/sI
	 gJaEJW4fNuMs56e0oi3vz7C3e6TMfm7w6NhHZ4xRejaxDYNaBtJHEgnaKsAZpkn/FEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626242;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eLFhdDm5xNWFkE2GGie+vOJw1OYCQ1eom6rn7Mtx0Q8=;
	b=xOPdyA/AYaVqyjtrSwnWawA79VN3fJ5cjob3T275+2mS5DoFjW9pfvkZ07ZBxF+JtGUs
	 M4f1JYmMR6qBWR7t7h4DVB+sgkRca5EcJCqpbvWb/sr0rdQRo4+yXKh8lGedXK2jhq7jS
	 SF5x95pi/dUudx90/GLFbTEttOswSp5TlkYF1ZeklC7nowrBWDryrw4Z+T7cuF8380vKm
	 favwl6DImYbxQRjYVffZ0hX8yJry7+75ebQImPGJFfecOAHDQTBDT0vg8QJCin+CVhf34
	 fiXwOE1r5iPXU/INuaxTsBHTESSA3npkFh4WoVh8tLMlhEowpiQBj+M8Hq0GW3ncOVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cegRBx3P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D900606A331;
	Wed, 25 Nov 2026 17:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cegRBx3P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2499C1F000D3;
	Wed, 25 Nov 2026 17:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626241;
	bh=eLFhdDm5xNWFkE2GGie+vOJw1OYCQ1eom6rn7Mtx0Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cegRBx3PgEWBLHWQj7jB+q/GodPPRSViXya8/CiNnaR9gFDC5+JSPl5eAHq2IJ0X7
	 6DHdmMF5qhf6F2wgvgvxd0uuD2tH3E8Euu4QShfUSMzMb+EsWGdR6gNWex6mcYirsN
	 dlqTNMYKP98JScltzBE25YKlbr1w3Kb+zdvvc1mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 779/816] USB: serial: io_edgeport: serialise MCR accesses
Date: Wed, 25 Nov 2026 15:38:47 +0100
Message-ID: <20261125143907.205977212@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


