Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A3213B78F;
	Tue, 27 Feb 2024 13:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041055; cv=none; b=EkmyGCD5tqqlLfDycgT8jD+yRNzNDIqwRemFjq1msnlrkPEVZQns9GGUoIr5kSWaKFEK/i9B8jehJ0dynvolq0WywAwZq4ZswnLMCKZbi6HvUYMmBBP7TFoTpQtUVNDMoi+ZsDEauWBu5kFedOXVyJkrufEejsHC/fvBFdTPeOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041055; c=relaxed/simple;
	bh=0bMxuEoTMMeoNuLyb5nqA/B8hCGdmjLwC16+XXn4hOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rb+IxsoWASkuIxNsACE1lQ3Wz7HUP1aa92hKY+44ik9A/24GgpuhUgzGW3YzgXGWUCYYAX95iw3W8HoilMCAPaRMOPhzmv+Nr4Va2dQCB45k4Pt51dHNScYnCWfWjA9ZoDul8hIMl8WmEgLIg5TkEzVrniLc24ZeNpU0U47MalM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Av5Omz6W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Av5Omz6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CB3C433C7;
	Tue, 27 Feb 2024 13:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041054;
	bh=0bMxuEoTMMeoNuLyb5nqA/B8hCGdmjLwC16+XXn4hOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Av5Omz6WmvCD1/p3iycgwu1m1GXjj5sL0TmoRawE9ekRsniDndQ7XqeY5pAZNyz9g
	 xYXN8glsWpkvoqB9mplelUvET3k/Yi4yWNkvIFtOpt8wz7iOctyBMAprURsUtf8Vb/
	 nYskH4eIHLlDGop53YW+scuSZkKLQQlI6L2U8ieE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>
Subject: [PATCH 6.7 203/334] serial: amba-pl011: Fix DMA transmission in RS485 mode
Date: Tue, 27 Feb 2024 14:21:01 +0100
Message-ID: <20240227131637.292154353@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lino Sanfilippo <l.sanfilippo@kunbus.com>

commit 3b69e32e151bc4a4e3c785cbdb1f918d5ee337ed upstream.

When DMA is used in RS485 mode make sure that the UARTs tx section is
enabled before the DMA buffers are queued for transmission.

Cc: stable@vger.kernel.org
Fixes: 8d479237727c ("serial: amba-pl011: add RS485 support")
Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Link: https://lore.kernel.org/r/20240216224709.9928-2-l.sanfilippo@kunbus.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/amba-pl011.c |   60 ++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1345,11 +1345,41 @@ static void pl011_start_tx_pio(struct ua
 	}
 }
 
+static void pl011_rs485_tx_start(struct uart_amba_port *uap)
+{
+	struct uart_port *port = &uap->port;
+	u32 cr;
+
+	/* Enable transmitter */
+	cr = pl011_read(uap, REG_CR);
+	cr |= UART011_CR_TXE;
+
+	/* Disable receiver if half-duplex */
+	if (!(port->rs485.flags & SER_RS485_RX_DURING_TX))
+		cr &= ~UART011_CR_RXE;
+
+	if (port->rs485.flags & SER_RS485_RTS_ON_SEND)
+		cr &= ~UART011_CR_RTS;
+	else
+		cr |= UART011_CR_RTS;
+
+	pl011_write(cr, uap, REG_CR);
+
+	if (port->rs485.delay_rts_before_send)
+		mdelay(port->rs485.delay_rts_before_send);
+
+	uap->rs485_tx_started = true;
+}
+
 static void pl011_start_tx(struct uart_port *port)
 {
 	struct uart_amba_port *uap =
 	    container_of(port, struct uart_amba_port, port);
 
+	if ((uap->port.rs485.flags & SER_RS485_ENABLED) &&
+	    !uap->rs485_tx_started)
+		pl011_rs485_tx_start(uap);
+
 	if (!pl011_dma_tx_start(uap))
 		pl011_start_tx_pio(uap);
 }
@@ -1431,42 +1461,12 @@ static bool pl011_tx_char(struct uart_am
 	return true;
 }
 
-static void pl011_rs485_tx_start(struct uart_amba_port *uap)
-{
-	struct uart_port *port = &uap->port;
-	u32 cr;
-
-	/* Enable transmitter */
-	cr = pl011_read(uap, REG_CR);
-	cr |= UART011_CR_TXE;
-
-	/* Disable receiver if half-duplex */
-	if (!(port->rs485.flags & SER_RS485_RX_DURING_TX))
-		cr &= ~UART011_CR_RXE;
-
-	if (port->rs485.flags & SER_RS485_RTS_ON_SEND)
-		cr &= ~UART011_CR_RTS;
-	else
-		cr |= UART011_CR_RTS;
-
-	pl011_write(cr, uap, REG_CR);
-
-	if (port->rs485.delay_rts_before_send)
-		mdelay(port->rs485.delay_rts_before_send);
-
-	uap->rs485_tx_started = true;
-}
-
 /* Returns true if tx interrupts have to be (kept) enabled  */
 static bool pl011_tx_chars(struct uart_amba_port *uap, bool from_irq)
 {
 	struct circ_buf *xmit = &uap->port.state->xmit;
 	int count = uap->fifosize >> 1;
 
-	if ((uap->port.rs485.flags & SER_RS485_ENABLED) &&
-	    !uap->rs485_tx_started)
-		pl011_rs485_tx_start(uap);
-
 	if (uap->port.x_char) {
 		if (!pl011_tx_char(uap, uap->port.x_char, from_irq))
 			return true;


