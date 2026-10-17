Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19733C73F6;
	Sat, 17 Oct 2026 17:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259508; cv=none; b=Wl8tINC+3jkrLuOLW63ZZeoHyE+Uq859pYqym9G6vadxs1nuNln59n6Lj/VlhRFsnH5mMTyo3yIpousk24MBNCOsFUMeCyGelC0fc1dBVIrvDv5MWolJSyQPKqde3CotwMHSgLqQqny+Vw9qNg0o5J5GrLkB2c9q5aXOumDmcTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259508; c=relaxed/simple;
	bh=3u19HbY7qAfxF2LkpatJamTFBgUbhvJP25Gn/Ixi/bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0zVtflTE3zBbvX+rPsaHJ16HE6tI2p78IH5s2OfKesIWLfYN3DoCIuyAD36ABlLHU+46U+/qhLMH9Og3p0d+v9eksXf6EXCl8tTYMcqbQCEif48OY9sD4ITNSfNsUPTNxhM3QmCYoCBBFTBS70rlrCuq41H3amH9L1abFyygF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bw/8BOEl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bw/8BOEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD211F000C4;
	Sat, 17 Oct 2026 17:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259506;
	bh=qe/LNyTOlpnD0qssdg/MgsfgGMDoYwWcRvNAxO2ZZBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bw/8BOElvJC0UdFDMBcaxPOx5vkFBb9DKiopmydcCxGA+ShFzLdt63OWRC1+mrywV
	 jS2Ms53z096EsWaoLQE+WGYamtQm84x1toXnZ4wx6Sp0UNW/3deziWWMtsFjlXf4KE
	 vxrEdZGnngUtMR38V4Rekn57gLIN1ldM9gPl4Zag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ryan Wilbur <rwilbur633@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1196/1674] serial: 8250_of: clear stuck empty-FIFO RX-timeout on LPC32xx
Date: Sat, 17 Oct 2026 17:57:48 +0200
Message-ID: <20261017160501.840558241@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Wilbur <rwilbur633@gmail.com>

[ Upstream commit 1423415471274abda87024967d7fe2206ceee0ea ]

The NXP LPC32xx UART (PORT_LPC3220) can latch an RX character-timeout
interrupt while the RX FIFO is empty: IIR reports UART_IIR_RX_TIMEOUT
(0x0c) but LSR.DR is clear. A character timeout is only cleared by
reading RHR, but serial8250_rx_chars() reads RHR only when LSR.DR is
set, so nothing ever clears the condition. The interrupt is
level-triggered and re-fires immediately, so on a single-core ARM926
the resulting interrupt storm livelocks the CPU.

It is reproducible when userspace repeatedly opens the front-panel port
(ttyS1): serial8250_do_set_termios() re-enables interrupts on unlock and
the handler then spins forever with iir=0xcc lsr=0x60 ier=0x05, tripping
the soft-lockup detector in serial8250_handle_irq_locked().

LPC32xx has no dedicated 8250 glue driver, it's driven by the generic
8250_of. Add a hardware specific handle_irq for PORT_LPC3220, wired up
in of_platform_serial_setup() the same way fsl8250_handle_irq is
installed. The handler follows dw8250_handle_irq(): on an RX timeout
with an empty FIFO (LSR.DR and LSR.BI clear) it does one throwaway RHR
read to clear the condition, then calls serial8250_handle_irq_locked().
No real received data is ever discarded, and it is a no-op on healthy
UARTs which never report a timeout with DR clear.

This is the same class of bug already worked around in other 8250 drivers;
see commit 424d79183af0 ("serial: 8250_dw: Avoid "too much work" from bogus rx timeout interrupt")
which reports the identical iir=0xcc/lsr=0x60. See also
UART_RX_TIMEOUT_QUIRK in 8250_omap, and the note in 8250_bcm7271.

Cc: stable <stable@kernel.org>
Assisted-by: Claude:Opus4.8
Signed-off-by: Ryan Wilbur <rwilbur633@gmail.com>
Link: https://patch.msgid.link/20260730193920.28954-1-rwilbur633@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_of.c | 43 +++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_of.c b/drivers/tty/serial/8250/8250_of.c
index 51329625c48ab..b704248f6bb1a 100644
--- a/drivers/tty/serial/8250/8250_of.c
+++ b/drivers/tty/serial/8250/8250_of.c
@@ -25,6 +25,46 @@ struct of_serial_info {
 	int line;
 };
 
+static int lpc32xx_handle_irq(struct uart_port *port)
+{
+	struct uart_8250_port *up = up_to_u8250p(port);
+	unsigned long flags;
+	unsigned int iir;
+	u16 status;
+	int ret;
+
+	serial8250_rpm_get(up);
+
+	iir = serial_port_in(port, UART_IIR);
+	if (iir & UART_IIR_NO_INT) {
+		serial8250_rpm_put(up);
+		return 0;
+	}
+
+	/*
+	 * The LPC32xx UART can assert an RX character-timeout interrupt while
+	 * the RX FIFO is empty: IIR reports UART_IIR_RX_TIMEOUT but LSR.DR is
+	 * clear. The timeout is only cleared by reading RHR, but the core RX
+	 * path skips that read when the FIFO is empty, so the level-triggered
+	 * IRQ re-fires forever and livelocks this single-core SoC. Do one
+	 * throwaway RHR read to clear it; a healthy UART never reports a
+	 * timeout with DR/BI clear, so no received data is ever discarded.
+	 */
+	if ((iir & 0x3f) == UART_IIR_RX_TIMEOUT) {
+		spin_lock_irqsave(&port->lock, flags);
+		status = serial_lsr_in(up);
+		if (!(status & (UART_LSR_DR | UART_LSR_BI)))
+			serial_port_in(port, UART_RX);
+		spin_unlock_irqrestore(&port->lock, flags);
+	}
+
+	ret = serial8250_handle_irq(port, iir);
+
+	serial8250_rpm_put(up);
+
+	return ret;
+}
+
 /*
  * Fill a struct uart_port for a given device node
  */
@@ -175,6 +215,9 @@ static int of_platform_serial_setup(struct platform_device *ofdev,
 		if (ret)
 			goto err_unprepare;
 		break;
+	case PORT_LPC3220:
+		port->handle_irq = lpc32xx_handle_irq;
+		break;
 	}
 
 	if (IS_REACHABLE(CONFIG_SERIAL_8250_FSL) &&
-- 
2.53.0



