Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046034;
	b=ZILFiYmqyUf6J79bs0U0oBOPnLHGtTFsxaUx25IMSemR5Y4ULHjcHcMTZ4chdvybg+X+
	 9JGjejr9Jrs9uquHhDM3TncjebVV9+iONuCZ+mNVtCw6A+QsOt+Jbfd4Yo818CRup8B6p
	 vVermUpidF9xaQy7WYGNH9J0K7XEiM4JDAB2goBpYo34oakypx6km3fYIp++41uyMtJFB
	 Jo2lMb5Z1p1LQv6XFEqbsC7WGgVlqErTBeb91SaM/eJfXPwkQjRmf2YpMMno5sdQXzuSd
	 ku/pDIOE6fHRrcmpwQuKUnZHpHO5Ug289ROpFRLX98BI0i7WEVOJnKgbv3zzpAfczFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046034;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tCGfHu1rZqNZoxvB3SQ58KZ/Ir+RVw7g7gAgHslA2X4=;
	b=4bNo/z3VM5FTSpStzDo3hsU9i880mv73qB3iLJiY6Rlh6B1VgNiy9PXxwJlB1ge8QkNk
	 5E25syJhdHEQTCfWVvkcwpl0q8R5RhwPAxBYkETHU5Y8TcGmq0OoN6Chp3BfTAvs+Pe8Q
	 W09gQYDsh5fj+87rwzJ9LJKdKA/bKPeDjJej3vSoiDwAo2LTyZPrCmalfj1ttTRR6BnFa
	 HnOOp1cyFm5ReeZv+T5LHxn8vsBWc3u5ZH/cqcQXep1rJIbduRsHIsSMh93K1fLr5F2H4
	 ElZ1sqiaHQ+n7/Ua3seLOMqzHP6x60RZQ1h+eNfj9QK6qXJHy1hAHMZZYUFJym6tMCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bVU3uvR9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B8B606A325;
	Wed, 18 Nov 2026 23:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bVU3uvR9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A358F1F000C5;
	Wed, 18 Nov 2026 23:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046034;
	bh=tCGfHu1rZqNZoxvB3SQ58KZ/Ir+RVw7g7gAgHslA2X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bVU3uvR944w/AwyywGgLSzGa9eFX1wMAoPKgL6N2FLuxmSVSAUNctI1owbhLQKRqj
	 F7n8MDgY+CC5shlc/DycFt+iU76ODNIkzIJoXVc88g/hfm1Zej+Re86tYJHo6USOfk
	 IhwHwKFhmAP0IougLdQrkp2D87JnifJ3uyEZ1mrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1137/2857] serial: amba-pl011: keep transmitter enabled when disabling RS485
Date: Wed, 18 Nov 2026 15:36:11 +0100
Message-ID: <20261118150242.531185620@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d61ecbb06d94e..ca970fad7f103 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2235,8 +2235,21 @@ static int pl011_rs485_config(struct uart_port *port, struct ktermios *termios,
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



