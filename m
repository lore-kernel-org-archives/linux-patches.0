Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063376;
	b=EUMXq7OmJwgjhvJ+aSUF8a4d4f48q+E1Y3g9bQtH/Xn/EvVvUp6un29QNLkFeA2s/jdM
	 V4O/tdfh6oUdoJBXpAHkLww4wC+2xKoG+KfSgR4qibwDf4qG7DV3A1WNELFSuP4C/p30F
	 3IqWfjlYA9Nvz3Ejc1VfW5PRJ8rlA/ybjqNvxTI/iMEH7CpD0e5qdmjTbh0KcbJWH5TWn
	 GQsfOHFUBZyyCyqyYftE1CIssGafpwpn9Sr5LQ/viSGP0YGcDootvFEJYNy6gMj467OYX
	 ua4+aIkMqJTYJX7BRM/A0vI4s5oxFnGfZJTQHHtWakomy9EBXxViHl9EAy7E/oppMHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063376;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qQ4bmQZfC+HlbHqmI1k3RC3PyN81ZL0vrw7vApZjqeY=;
	b=EoWz0Q2wwZnsrRicV2bKA/SDf4vjGpp+mqfbdU7a3oSwhIYhdkim259tR5oqN3z9pj1h
	 rqeFWpqyr8aAOtdZ5j4jO3P8QEUmBQHJQhHPosNvorq6WmDfiNkYWHGEn3WONpqkbupdY
	 duFqm8TOKa25fkiFCH9mxg76fbTdhogo+UrJgI+4rlAd7UFwmMEr/5ic4A7IOHwLaxqc9
	 5yjpu7E9/EhKOIvQQS8GfmjCgdkel/GkJiOpFSxRMlJXOw7A0DXr1cT4V4h5Csk2lvhSf
	 WfVmjN4z+IReQmQd45dkyLTJZ+98/kLxHz2vAzYRqdfwzdDd5UgefKC0RLO781ZJRaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="N2hjBV/Z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05312606EEBA;
	Sat,  7 Nov 2026 14:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N2hjBV/Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7FC21F008A1;
	Sat,  7 Nov 2026 14:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063375;
	bh=qQ4bmQZfC+HlbHqmI1k3RC3PyN81ZL0vrw7vApZjqeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N2hjBV/Z3gGKYhhKS9kuLqkonDDZe43KDQfPXiyDQzl6e5vDXYnxnKQ0vATeXErLo
	 KRVW1cK9Y7PRllnKENirdO///tFSol7+SSXaXFbQSEbskXLnFdzkQ7c+zEcTNRhPiv
	 PeOwfh9ky0tyC2p1tWGS1ndliFJctsyqog8wAO/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 550/869] serial: amba-pl011: keep transmitter enabled when disabling RS485
Date: Sat,  7 Nov 2026 08:53:52 -0500
Message-ID: <20261107134912.015556482@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 97f85204275ae4d7fb530e451f3acc65c1ec1155 ]

Disabling RS485 on an open port calls pl011_rs485_tx_stop(), which
turns off the transmitter. Only the RS485 TX path turns it back on, so
any later output stays queued and tcdrain() hangs until the port is
closed.

pl011_rs485_tx_stop() also checks only the hardware FIFO. If a DMA
transfer has started but has not filled the FIFO yet, the transmitter
is turned off under the transfer and the DMA channel never recovers.

When leaving RS485 mode, cancel pending deferred starts and stops, leave
the transmitter enabled and start any TX that was still waiting for
delay_rts_before_send.

Fixes: 8d479237727c ("serial: amba-pl011: add RS485 support")
Cc: stable@kernel.org
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20261012-fix-pl011-rs485-txe-v2-1-e9bf7d218389@tipi-net.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/amba-pl011.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 3e777e4d13f20..20d2a8612cbcb 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2308,8 +2308,31 @@ static int pl011_rs485_config(struct uart_port *port, struct ktermios *termios,
 	struct uart_amba_port *uap =
 		container_of(port, struct uart_amba_port, port);
 
-	if (port->rs485.flags & SER_RS485_ENABLED)
+	if ((port->rs485.flags & SER_RS485_ENABLED) &&
+	    !(rs485->flags & SER_RS485_ENABLED)) {
+		bool tx_pending = uap->rs485_tx_state == WAIT_AFTER_RTS;
+		u32 cr = pl011_read(uap, REG_CR);
+
+		/*
+		 * Leaving RS485 mode, which only enables the transmitter while
+		 * sending. Don't stop it, as that stalls a DMA transfer still
+		 * in flight. Drop pending deferred starts and stops and keep
+		 * it enabled.
+		 */
+		hrtimer_try_to_cancel(&uap->trigger_start_tx);
+		hrtimer_try_to_cancel(&uap->trigger_stop_tx);
+		uap->rs485_tx_state = OFF;
+
+		cr |= UART011_CR_TXE | UART011_CR_RXE;
+		pl011_write(cr, uap, REG_CR);
+
+		/* Start TX that was still waiting for delay_rts_before_send */
+		if (tx_pending && !uart_tx_stopped(port) &&
+		    !pl011_dma_tx_start(uap))
+			pl011_start_tx_pio(uap);
+	} else if (port->rs485.flags & SER_RS485_ENABLED) {
 		pl011_rs485_tx_stop(uap);
+	}
 
 	/* Make sure auto RTS is disabled */
 	if (rs485->flags & SER_RS485_ENABLED) {
-- 
2.53.0



