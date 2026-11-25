Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620563;
	b=lLevuE0oP2bfsYc9VWHBO75HecAevWyBYp4aKnpD2Jnjgh92Cghh62sLWhi6+ovLrmTR
	 SEr/1z5kIDVywzVl3PuN3QhMkX23PwfifkaFJDXnfgDRlmEuWqQBnFbUvDeZh63JnE2Vx
	 yrH9/1gADmSxjztormX2MGA/wOCuK3lhe2ccR0IxdWTv+d8gJGBAcQraqube6rI/kA/Qo
	 alSzEzvsfhUBsjbtwEtC6m1K9cyQVkR3bmThHrq5hNfZ7GXl3OjK86cdMrkhlf3c0QS5U
	 M3rupLcs5IVgh9vNmSrKfagNbxBYxwFqyvUjjsCCi59hKKzzK8gk7QX251iXcd4r5tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620563;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5iv6uuMUOteJ5zqj8UyBreAchWPljArG2lrAnIk0r88=;
	b=pXL8Mcv9GORP/4ZqOV6AEW7Ua97ibluPUEdc72WY4Cr4G5v000bal1AEsnYX+xRsmfPx
	 K4Re57R5ns1IynGlYoOHc+cbAEA82EaNp0OeZEFgxcycUJEJMvWNJBfa/0Q3CDT95B+m5
	 Ss+zueWN7+EHXpYNZO1rBYKpT6My7yCG1VoTlfI8qVTIbq1mpZfh2dvKwlpoEkM9/8n5v
	 QOfZjJqXOckCD8T+wa3aURV1O2MSnpK544ezjcun7EJ/LQW9LwzKhjIw/FsYvLPQCqPHi
	 UIWrwFNAaUf57xZI8C/ZhFGbF9bwrmhBig8/TERYQSsPER5OmwDilap5gXJU0zbjrTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mjhJMQPr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C075A606A321;
	Wed, 25 Nov 2026 15:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mjhJMQPr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C11E1F000C4;
	Wed, 25 Nov 2026 15:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620562;
	bh=5iv6uuMUOteJ5zqj8UyBreAchWPljArG2lrAnIk0r88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mjhJMQPryqEAj/A0WyHsYbNQUMCr+FIICVSit/CGQ3w8Rxwr+feEgooYsObDm90/2
	 Taw8r93DwZH5BFkXsLruKn+zTmXicQ6lyrDXx8Qi8fDFATfX7/YAbxy7fE7+vVJi8W
	 aIYHlTUyM8mMg49AmlX51P8SojI4qMm2nZk0dA88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.3 0959/1005] USB: serial: io_edgeport: move initial termios update to open()
Date: Wed, 25 Nov 2026 15:38:17 +0100
Message-ID: <20261125143844.136127196@linuxfoundation.org>
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

commit febadc65a4ef8d08a12e76d6ec50834d72cc0e59 upstream.

Explicitly update the terminal settings on open() instead of doing so
from the interrupt completion handler when receiving an open command
response, which in theory can be received after a failed open attempt.

Note that this will be used to fix a FIFO corruption issue and also
allows for switching to synchronous commands.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/io_edgeport.c |   64 ++++++---------------------------------
 1 file changed, 10 insertions(+), 54 deletions(-)

--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -281,8 +281,7 @@ static void handle_new_lsr(struct edgepo
 static int  send_iosp_ext_cmd(struct edgeport_port *edge_port, __u8 command,
 				__u8 param);
 static int  calc_baud_rate_divisor(struct device *dev, int baud_rate, int *divisor);
-static void change_port_settings(struct tty_struct *tty,
-				struct edgeport_port *edge_port,
+static void edge_set_termios(struct tty_struct *tty, struct usb_serial_port *port,
 				const struct ktermios *old_termios);
 static int  send_cmd_write_uart_register(struct edgeport_port *edge_port,
 				__u8 regNum, __u8 regValue);
@@ -923,6 +922,9 @@ static int edge_open(struct tty_struct *
 		return -ENOMEM;
 	}
 
+	if (tty)
+		edge_set_termios(tty, port, NULL);
+
 	spin_lock_irq(&edge_port->ep_lock);
 	edge_port->open = true;
 	spin_unlock_irq(&edge_port->ep_lock);
@@ -1444,30 +1446,6 @@ static void edge_unthrottle(struct tty_s
 
 
 /*****************************************************************************
- * SerialSetTermios
- *	this function is called by the tty driver when it wants to change
- * the termios structure
- *****************************************************************************/
-static void edge_set_termios(struct tty_struct *tty,
-			     struct usb_serial_port *port,
-			     const struct ktermios *old_termios)
-{
-	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
-
-	if (edge_port == NULL)
-		return;
-
-	if (!edge_port->open) {
-		dev_dbg(&port->dev, "%s - port not opened\n", __func__);
-		return;
-	}
-
-	/* change the port settings to the new ones specified */
-	change_port_settings(tty, edge_port, old_termios);
-}
-
-
-/*****************************************************************************
  * get_lsr_info - get line status register info
  *
  * Purpose: Let user call ioctl() to get info when the UART physically
@@ -1756,7 +1734,6 @@ static void process_rcvd_status(struct e
 {
 	struct usb_serial_port *port;
 	struct edgeport_port *edge_port;
-	struct tty_struct *tty;
 	struct device *dev;
 	__u8 code = edge_serial->rxStatusCode;
 
@@ -1808,15 +1785,6 @@ static void process_rcvd_status(struct e
 			__func__, edge_serial->rxPort, byte2, edge_port->txCredits);
 		handle_new_msr(edge_port, byte2);
 
-		/* send the current line settings to the port so we are
-		   in sync with any further termios calls */
-		tty = tty_port_tty_get(&edge_port->port->port);
-		if (tty) {
-			change_port_settings(tty,
-				edge_port, &tty->termios);
-			tty_kref_put(tty);
-		}
-
 		/* we have completed the open */
 		edge_port->openPending = false;
 		wake_up(&edge_port->wait_open);
@@ -2328,18 +2296,12 @@ static int send_cmd_write_uart_register(
 }
 
 
-/*****************************************************************************
- * change_port_settings
- *	This routine is called to set the UART on the device to match the
- *	specified new settings.
- *****************************************************************************/
-
-static void change_port_settings(struct tty_struct *tty,
-	struct edgeport_port *edge_port, const struct ktermios *old_termios)
+static void edge_set_termios(struct tty_struct *tty, struct usb_serial_port *port,
+		const struct ktermios *old_termios)
 {
-	struct device *dev = &edge_port->port->dev;
-	struct edgeport_serial *edge_serial =
-			usb_get_serial_data(edge_port->port->serial);
+	struct edgeport_serial *edge_serial = usb_get_serial_data(port->serial);
+	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
+	struct device *dev = &port->dev;
 	int baud;
 	unsigned cflag;
 	__u8 mask = 0xff;
@@ -2350,12 +2312,6 @@ static void change_port_settings(struct
 	__u8 txFlow;
 	int status;
 
-	if (!edge_port->open &&
-	    !edge_port->openPending) {
-		dev_dbg(dev, "%s - port not opened\n", __func__);
-		return;
-	}
-
 	cflag = tty->termios.c_cflag;
 
 	switch (cflag & CSIZE) {
@@ -2489,7 +2445,7 @@ static void change_port_settings(struct
 
 	dev_dbg(dev, "%s - baud rate = %d\n", __func__, baud);
 	status = send_cmd_write_baud_rate(edge_port, baud);
-	if (status == -1) {
+	if (status == -1 && old_termios) {
 		/* Speed change was not possible - put back the old speed */
 		baud = tty_termios_baud_rate(old_termios);
 		tty_encode_baud_rate(tty, baud, baud);


