Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5C82590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B35C433D2;
	Sun, 22 Jan 2023 15:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401143;
	bh=pqyvqxdruOvQAcDL8l9prxe5yXyt9IjHkwX8r1fqcWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3ShIqCKgk0w1f7WvjZUU97N+Uu3Gur33zmdRn7QsDAJD/wElIBty7OQMFNlu15be
	 CCQyNYcgDVakj6/8ywGczR0yQ57tjJiHYCW2hcYcZYKebvr1+5/ql2DVdvOoG0VsBD
	 x7F39/GZ+zsnRpjWsk63WIEPs6hXmnH0ArJnQfeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>
Subject: [PATCH 6.1 125/193] serial: amba-pl011: fix high priority character transmission in rs486 mode
Date: Sun, 22 Jan 2023 16:04:14 +0100
Message-Id: <20230122150252.020495028@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lino Sanfilippo <l.sanfilippo@kunbus.com>

commit 4f39aca2360c82dccd2f5179d77e94aab665bea6 upstream.

In RS485 mode the transmission of a high priority character fails since it
is written to the data register before the transmitter is enabled. Fix this
in pl011_tx_chars() by enabling RS485 transmission before writing the
character.

Fixes: 8d479237727c ("serial: amba-pl011: add RS485 support")
Cc: stable@vger.kernel.org
Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Link: https://lore.kernel.org/r/20230108181735.10937-1-LinoSanfilippo@gmx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/amba-pl011.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1467,6 +1467,10 @@ static bool pl011_tx_chars(struct uart_a
 	struct circ_buf *xmit = &uap->port.state->xmit;
 	int count = uap->fifosize >> 1;
 
+	if ((uap->port.rs485.flags & SER_RS485_ENABLED) &&
+	    !uap->rs485_tx_started)
+		pl011_rs485_tx_start(uap);
+
 	if (uap->port.x_char) {
 		if (!pl011_tx_char(uap, uap->port.x_char, from_irq))
 			return true;
@@ -1478,10 +1482,6 @@ static bool pl011_tx_chars(struct uart_a
 		return false;
 	}
 
-	if ((uap->port.rs485.flags & SER_RS485_ENABLED) &&
-	    !uap->rs485_tx_started)
-		pl011_rs485_tx_start(uap);
-
 	/* If we are using DMA mode, try to send some characters. */
 	if (pl011_dma_tx_irq(uap))
 		return true;


