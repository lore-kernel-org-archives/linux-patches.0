Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037221;
	b=qAhuwFdwl2aYd6Nr1OR+dmQqeb6JlBlVKgAVQIEjKHwl8fTXSv9SB6qOOzg0kJraxGam
	 2sIvj1/1jMrDIKsQ4rTuWFBzRj/A/WHK2nLo3Omr72LxiL467Fhff3xrWio3F8RSZK2/N
	 adqq773u/ScILdkH5+JmAhUiTD/FzNIOkix57yCF1AWIHPxt/gTT20rezgAYdVdEuZlXG
	 q5oYc0X/HwiLEJjxLkgnF44uARl9k0vQ7u2TLQtQYCLybOD/GmL0FSEQggZx7BH45xMrI
	 FGQUyD4HmxD3KmsfE7GlLGlTSGQDOokUN4ySRXfKU9CAjkjcqnrIXnd3gxJcbvyBkzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wilY0thANUjHDAzJCHRrVsqLdPyD8d/OI6IRRRvkaUg=;
	b=DsKLQL/luPO1/4smJkAP8FlcdRnNFa0+qokTzUVulfm1IOUQKxG8FKRXcKTt5y5rXSoZ
	 mLjKgeDtdY+D9CaRnJFCXEedjv3gbdKOisimmAlnvyMzfyqXCbOmNPOJsk6JZ0tYTfuIx
	 Vsi/v/uW8uzSl94+w1YQpfJU0cXrf9n1o4aDhSFOZP0vtojh8JsTsR+EcqN3Ce4XXr9JS
	 gIpJS/AGF0SktHBEpYtdqd0xEsN5oN9c9+nM0HayJ+7VtvatLWYJdjGCE1D+x4E3PC2tO
	 qmzAU/5orxiNU9/neks/LkWQyCEbmGZC4yPcR7sAURqgN84POWHz44LfsOdLAP9TSpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OZtJhaWH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D5B606A330;
	Wed, 18 Nov 2026 21:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OZtJhaWH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CA01F000C8;
	Wed, 18 Nov 2026 21:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037221;
	bh=wilY0thANUjHDAzJCHRrVsqLdPyD8d/OI6IRRRvkaUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OZtJhaWHBxR+UDdMnIdY2MFySGLb0bavZdkFzubeE9ilEfSfhVgN3VfaGP/bGpAFp
	 vhqnD16IHCk9i4uD9G8C43gY8NFiFy84OhSaKeGzOuRFCjpprFXFhiWwysIpwdqVMP
	 6ayjAFpk8JKfsyWgIEZk1DDgx8kUlozw2qo1u1ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1332/3318] serial: amba-pl011: keep transmitter enabled when disabling RS485
Date: Wed, 18 Nov 2026 15:32:34 +0100
Message-ID: <20261118150400.295927025@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolai Buchwitz <nb@tipi-net.de>

commit 97f85204275ae4d7fb530e451f3acc65c1ec1155 upstream.

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
[nb: Use rs485_tx_started and omit timer handling on older kernels.]
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/amba-pl011.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 17b8b56565194..d7dbd4c0eae15 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2242,8 +2242,21 @@ static int pl011_rs485_config(struct uart_port *port, struct ktermios *termios,
 	struct uart_amba_port *uap =
 		container_of(port, struct uart_amba_port, port);
 
-	if (port->rs485.flags & SER_RS485_ENABLED)
+	if ((port->rs485.flags & SER_RS485_ENABLED) &&
+	    !(rs485->flags & SER_RS485_ENABLED)) {
+		u32 cr = pl011_read(uap, REG_CR);
+
+		/*
+		 * Leaving RS485 mode, which only enables the transmitter while
+		 * sending. Don't stop it, as that stalls a DMA transfer still
+		 * in flight. Keep the transmitter and receiver enabled.
+		 */
+		uap->rs485_tx_started = false;
+		cr |= UART011_CR_TXE | UART011_CR_RXE;
+		pl011_write(cr, uap, REG_CR);
+	} else if (port->rs485.flags & SER_RS485_ENABLED) {
 		pl011_rs485_tx_stop(uap);
+	}
 
 	/* Make sure auto RTS is disabled */
 	if (rs485->flags & SER_RS485_ENABLED) {
-- 
2.53.0



