Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFFF1F91F6;
	Tue, 13 Oct 2026 12:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895127; cv=none; b=DJOSKAMHgL9xRA6jTwaXFEwPZEvTvonhg+ou2iC6I1xbSOeB0CNAM4eYDtjsT11vh/5KiN8TXBRtp+aS7dotsTgNj1CqQ1cpC2P1bGCAJHdBJ/2yUdtB5xjoaDOMM4uBxC2gvlvu9tJI8LHpFe2OpFgOG55+1vWAQvuQAy9ag28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895127; c=relaxed/simple;
	bh=isPByFMMjjCVCnbcbX3U4ywss+cgmtSB89vF9AqVqCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpEBaFic4aKATSJ4BMli4kZFlGZuyMFD7nlJGd7UUgtsv2TOEMDPAEoVLFKwYXxkP9I1IF7XcLnAnlgjnnOFPMuiCHUGHBELOii9BBsDHpCKxnB/BmLhgq4p3tE2F5gB5UFWyVrPx0viBlekFjmNiino+jm7+y5gfrGvX5TqwD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQ1c5Dpb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQ1c5Dpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB4E1F00893;
	Tue, 13 Oct 2026 12:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895125;
	bh=cCSDH6EHgJi1LzUgSbrptTw+dMNtm6xgsiMCvcY5Yco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PQ1c5Dpb3EZmnOrN1weFqc1Tm2cCJMXZkGAg1J66OPp+dibzyBsCFGwTsCWvk+TY2
	 Lpr9Bdi1Ul0ps4l4F2a3bkjO86dcEA4e1GH19+ULBGKszKHcCAS8rLz1ylTrLkH2Ew
	 HrVMmchWSIfh5mnhuxMALOaKAsjabv6B5od6blxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Simon Gassner <simon.gassner@noxsystems.com>
Subject: [PATCH 6.12 169/497] serial: tegra: dont clear the Tx FIFO on an Rx-only reset
Date: Tue, 13 Oct 2026 13:35:36 +0200
Message-ID: <20261013112911.900857916@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Gassner <simon.gassner@noxsystems.com>

commit 8aebfde6e84dceb7d47fe8001e50b754eb45d5df upstream.

tegra_uart_fifo_reset() applies the Tegra30 workaround for
"cannot clear the Tx FIFO while FIFO mode is enabled"
unconditionally: it leaves FIFO mode, writes the requested FCR
clear bits, and re-enters FIFO mode. Leaving FIFO mode empties
both FIFOs, so an Rx-only reset discards queued Tx data as well.

The break handler in tegra_uart_decode_rx_error() calls it with
UART_FCR_CLEAR_RCVR only. On a half-duplex RS485 board whose Rx
line is pulled low while the transceiver drives the bus, every
transmission raises a spurious break, and all but the first
character of the frame is lost.

Only take the FIFO-mode path when the caller actually asked for
CLEAR_XMIT. Likewise only wait for TEMT in that case: with the Tx
FIFO deliberately left intact, that loop would otherwise spin for
a full frame time in hard IRQ context with the port lock held.

Tested on a Colibri T30 (Tegra30) with Rx DMA:

 - Break during transmission: the reset still fires from
   tegra_uart_decode_rx_error(), and the complete frame now
   reaches the peer. Before this change only the character in
   the shift register was sent.
 - Internal loopback with a generated break: the Rx FIFO is
   correctly cleared by the plain FCR write, and subsequent
   receive works with no frame, parity or overrun errors.

Fixes: e9ea096dd225 ("serial: tegra: add serial driver")
Cc: stable@kernel.org
Signed-off-by: Simon Gassner <simon.gassner@noxsystems.com>
Link: https://patch.msgid.link/20261001060539.32659-1-simon.gassner@noxsystems.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial-tegra.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -306,11 +306,19 @@ static void tegra_uart_fifo_reset(struct
 {
 	unsigned long fcr = tup->fcr_shadow;
 	unsigned int lsr, tmout = 10000;
+	bool clear_tx = !!(fcr_bits & UART_FCR_CLEAR_XMIT);
 
 	if (tup->rts_active)
 		set_rts(tup, false);
 
-	if (tup->cdata->allow_txfifo_reset_fifo_mode) {
+	/*
+	 * Leaving FIFO mode below is a workaround for a Tegra30
+	 * restriction on clearing the Tx FIFO while FIFO mode is
+	 * enabled. It empties both FIFOs, so applying it to an
+	 * Rx-only reset would destroy an in-flight transmission.
+	 * Only take that path when the caller asked for CLEAR_XMIT.
+	 */
+	if (tup->cdata->allow_txfifo_reset_fifo_mode || !clear_tx) {
 		fcr |= fcr_bits & (UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT);
 		tegra_uart_write(tup, fcr, UART_FCR);
 	} else {
@@ -335,9 +343,15 @@ static void tegra_uart_fifo_reset(struct
 	 */
 	tegra_uart_wait_cycle_time(tup, 32);
 
+	/*
+	 * Only wait for the transmitter to drain when the Tx FIFO was
+	 * part of the reset. For an Rx-only reset it is left intact,
+	 * and waiting for TEMT here would spin for a full frame time.
+	 */
 	do {
 		lsr = tegra_uart_read(tup, UART_LSR);
-		if ((lsr & UART_LSR_TEMT) && !(lsr & UART_LSR_DR))
+		if ((!clear_tx || (lsr & UART_LSR_TEMT)) &&
+		    !(lsr & UART_LSR_DR))
 			break;
 		udelay(1);
 	} while (--tmout);


