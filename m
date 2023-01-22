Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6093E2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB3AC4339B;
	Sun, 22 Jan 2023 15:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400739;
	bh=ACUv1GCDZl5dqgNypOm45KYCeJ8uXIUPJlFxYQhnpHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k5enB4weqc/iZ2DBbJk1dF4jOScojxOKM1YhxRsGghwmbYeY3PIkEsFy3I7x/jpev
	 8dLlRTytW795mb4x6sxGKZE5J4bFfQC2n+0AHZ7EKwLgYZOlBgH4DhX3TPknP5EnGE
	 qiuSxNyrrxQ7TCnRZiz0O8GU6ftvpDSlkLqi7/Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>
Subject: [PATCH 5.15 090/117] serial: amba-pl011: fix high priority character transmission in rs486 mode
Date: Sun, 22 Jan 2023 16:04:40 +0100
Message-Id: <20230122150236.542409845@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
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
@@ -1472,6 +1472,10 @@ static bool pl011_tx_chars(struct uart_a
 	struct circ_buf *xmit = &uap->port.state->xmit;
 	int count = uap->fifosize >> 1;
 
+	if ((uap->port.rs485.flags & SER_RS485_ENABLED) &&
+	    !uap->rs485_tx_started)
+		pl011_rs485_tx_start(uap);
+
 	if (uap->port.x_char) {
 		if (!pl011_tx_char(uap, uap->port.x_char, from_irq))
 			return true;
@@ -1483,10 +1487,6 @@ static bool pl011_tx_chars(struct uart_a
 		return false;
 	}
 
-	if ((uap->port.rs485.flags & SER_RS485_ENABLED) &&
-	    !uap->rs485_tx_started)
-		pl011_rs485_tx_start(uap);
-
 	/* If we are using DMA mode, try to send some characters. */
 	if (pl011_dma_tx_irq(uap))
 		return true;


