Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590845;
	b=xOMqoM2JOecgeEum3MzesE34Dr4CWXOLnjQXSBTHrQjBqOY9kzGVWPrUWqWaU6vvVHW4
	 +1CKIXQpdnysTIgedzzyFoV+8+sHUfFO1S4Kloq9qZD0GuGaa2gZ4ld8NXlja7AWQQK34
	 mN/up43KXFS+cDbxSp2wXuf+l/BeE6KroU2D9BcDS95GmPId4PAqWsV1HnQvk84TlBSca
	 PydCG/gAOGTmqHfePGQTu1H4jW2jbZ1HftXES5DIuvjrRsF6fz93n+RH3aSiFZj5F+K8S
	 FbsDJDaBa6+zjK/RQomuazbFZk/zx+7xzMKjJdyzjyp9w3y21MVx3IDodDX7i5EfWlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590845;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2ppshqaHpnO8hhswY+9dUUvb6xkfJlJBj/OuIMRsVVY=;
	b=iCVLHdq5VMDyJA3/j82bcC53u0r8vZHXrF8yYKdXr2SevJGEcXgDzngGQtGxmUTo93dI
	 RSveMLOR/7Ud5TrNSOszOF8cH1xGaR8yeUlcQ7MBrSM7YUMxKRd4U3ReME7++P1PMpdNH
	 SWjXtEqndDhqccDVrFJMce1kJ105UavtTfoHyOsQt6elsACN+NdZLX0b5ccfjaq8++chj
	 ZS5SnNtxIYKaXUrsazh6Ma2N/Fs8LjmdWG55gP57KDsKTOTgSK4Xs/i8NLWewXfgmAuBb
	 n6ndSO+eQZWg0hqP2zMVcCbcIOnGNpkkRIwOPGqOUjNRdKXOMY932oo9db3SiWGOXXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TsWx+gbX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57F0606D492;
	Fri, 13 Nov 2026 17:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TsWx+gbX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626101F000C4;
	Fri, 13 Nov 2026 17:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590845;
	bh=2ppshqaHpnO8hhswY+9dUUvb6xkfJlJBj/OuIMRsVVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TsWx+gbX/o3y8h/Rm6iNEoh23eJQd3L8npqHZ2BlFKZBdzKaUlQNJMEnPlJ8xOdCG
	 diJ/uwaxmJ778xdqLSg+nJNWnOxkh1i25ti0xZCdMNAYFLlBaAAy5xyxKBOpQ5u44j
	 jB0Th/qQm6F8hQAuY15AfD3NvliHZ3n6g+HvIFlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/670] serial: amba-pl011: keep transmitter enabled when disabling RS485
Date: Fri, 13 Nov 2026 10:43:30 -0500
Message-ID: <20261113153812.845754394@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index 3e1932a3bfbbd..a0e20bffefba8 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2224,8 +2224,21 @@ static int pl011_rs485_config(struct uart_port *port, struct ktermios *termios,
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



