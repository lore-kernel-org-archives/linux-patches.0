Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054247;
	b=BW6cZxD/rwo2iqH4tcB39rDmKSAOfQ96d89fBUpLWKT6273I18Dxq0P80F5Y003m1Vdj
	 RROxH4HJoYOl4u/ItuGUKOsaGgRd77KTg4zztpeDicMGLDGe7UrC3GlBDUIXUpg9/Xt4p
	 cgjVYTbaosYE4i1ByzeJcRqL3ldJ8zfXVVB6ACk6Q2+rQDAVPT8ls+3T+W/F+ts7cEM3o
	 vkg4UlqZzsERdx9ndTL4w2jbJ5hkf7TNiSNhvShkyRZDanPNceQFMAPFsjszPfmkz9TwM
	 5ghGO1VKRWfJs2igszMboWhtHXbxjfE9NeUy5+48a+7b/UBcFttTLwKfty5bOZAd4BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xbd/nnUHWBZPLa2XH7rPyvye30e8w0rALzjmuTDaXIY=;
	b=31EYavv4++Vd7m1l7wR10J2dZKFu6uMRRUSVHFhGfixnmbE91AmNCcKZXppJkSS+xyZo
	 XJpR6ToMPBfVbtRSljmDlKSS59Cv6DAILuUiS/zGCR7Rn4fvPzC9wrFYnRUb27CsnMMBN
	 6hN+iPsoJ6azbj7WmFHDZB8ElVawqmpL5/ogzP5gHEq20O5cm9DVseDEW7tQE+yTE8nqr
	 Mcw5d7g4JYY6TVX8jrE13FIST12FcpGY9Bl2x4jUz+o+SDi+BvMK577BkIsMwS4zhU55l
	 HvCgrZDs8PMuUIQNJ/U+lRWEUPKRZZyL1QeEdx6X76FJqFJY7VmImi5pqmzh387kWKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z6TgnFg2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F80606A31C;
	Thu, 19 Nov 2026 02:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z6TgnFg2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA461F000C4;
	Thu, 19 Nov 2026 02:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054247;
	bh=xbd/nnUHWBZPLa2XH7rPyvye30e8w0rALzjmuTDaXIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z6TgnFg2XetPeLx6A4wcxLXIMnZyvQ6jvA8egrtTbQbmc6DC1IbGACfGPunLcahVq
	 pWtIQDb6LBelkArjXDhn/orWKqDEs4kTz6UQzVBkTvJYnKfJmNrnB5fv0zr2hhbZca
	 2JMvt87esSu/BHHivJU3C+L35LTpBMZclCVx9ANQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1155/2214] serial: amba-pl011: keep transmitter enabled when disabling RS485
Date: Wed, 18 Nov 2026 15:47:11 +0100
Message-ID: <20261118150058.183641084@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted RS485 handling to the existing rs485_tx_started boolean and synchronous delays, omitting unavailable timer and deferred-start logic. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/amba-pl011.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 7b21907cd14dd..3f74b96e7745c 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2241,8 +2241,22 @@ static int pl011_rs485_config(struct uart_port *port,
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
+		 * in flight. Keep it enabled.
+		 */
+		uap->rs485_tx_started = false;
+
+		cr |= UART011_CR_TXE | UART011_CR_RXE;
+		pl011_write(cr, uap, REG_CR);
+	} else if (port->rs485.flags & SER_RS485_ENABLED) {
 		pl011_rs485_tx_stop(uap);
+	}
 
 	/* Make sure auto RTS is disabled */
 	if (rs485->flags & SER_RS485_ENABLED) {
-- 
2.53.0



