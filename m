Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F494446F6;
	Mon, 17 Aug 2026 13:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975109; cv=none; b=D85uQP8a7rYYo1XwCYrJ26Q4XkhmayjJevUavIioNha3BIqyzhVX77lmHz9n/26asuObwAc4uxTHlGBaZw08NyriCxpWcp8qHKC7CjcB+m402mlAJyguitvhYhRm5SJOqVGGOjlJiCUt5HLuPlJDFj8p/elLVkpNZOvueiQ6x3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975109; c=relaxed/simple;
	bh=tbdyiLAsCGpiaFJZXMgnnFg8KbPk6BLTc1i1WcW/KnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDsXXmtEt7owbCcj7hZnpI0Gh8OTCF8inNWyzOIX3FU3MZW0ByTY5ABskj5LJEs8B/jnn91v6yzF0fKVx68PqWM6xOi+pVEC9469FCYZ+UPMAH5HL6U7OjK7nDKJwr/PbG/eaiiZQz215RN+Zbuu3OIz5Gk3DzN1kLzcxiv6TR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ka3hVNUg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ka3hVNUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9381F000E9;
	Mon, 17 Aug 2026 13:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975108;
	bh=8iF2MGciLAV2n4k9spQjGSg8EmMYj0WPzqSar5DGc1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ka3hVNUgdiduQNik/ho7UahQySfojdCJ823h2S39hwdybNnejIufG/cGQ2x87PvUD
	 3moN+EsHWAZO+o35Dwp/IzAl7JREtfq/ehnN/awt7XsPUh1fkTQiBVsUMrC5QNSrOZ
	 ZdHteo8nQYQOO4A1nLprYyzK+pDs7pAy08AqxtW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ryan Wilbur <rwilbur633@gmail.com>
Subject: [PATCH 6.18 166/250] serial: 8250_of: clear stuck empty-FIFO RX-timeout on LPC32xx
Date: Mon, 17 Aug 2026 15:32:07 +0200
Message-ID: <20260817132543.414934927@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Wilbur <rwilbur633@gmail.com>

commit 1423415471274abda87024967d7fe2206ceee0ea upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_of.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

--- a/drivers/tty/serial/8250/8250_of.c
+++ b/drivers/tty/serial/8250/8250_of.c
@@ -81,6 +81,40 @@ static int of_platform_serial_clk_notifi
 	return NOTIFY_DONE;
 }
 
+static int lpc32xx_handle_irq(struct uart_port *port)
+{
+	struct uart_8250_port *up = up_to_u8250p(port);
+	unsigned int iir;
+	u16 status;
+
+	guard(serial8250_rpm)(up);
+
+	iir = serial_port_in(port, UART_IIR);
+	if (iir & UART_IIR_NO_INT)
+		return 0;
+
+	guard(uart_port_lock_check_sysrq_irqsave)(port);
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
+		status = serial_lsr_in(up);
+		if (!(status & (UART_LSR_DR | UART_LSR_BI)))
+			serial_port_in(port, UART_RX);
+	}
+
+	serial8250_handle_irq_locked(port, iir);
+
+	return 1;
+}
+
 /*
  * Fill a struct uart_port for a given device node
  */
@@ -173,6 +207,9 @@ static int of_platform_serial_setup(stru
 	case PORT_NPCM:
 		ret = npcm_setup(port);
 		break;
+	case PORT_LPC3220:
+		port->handle_irq = lpc32xx_handle_irq;
+		break;
 	default:
 		/* Nothing to do */
 		ret = 0;
@@ -369,6 +406,7 @@ static struct platform_driver of_platfor
 
 module_platform_driver(of_platform_serial_driver);
 
+MODULE_IMPORT_NS("SERIAL_8250");
 MODULE_AUTHOR("Arnd Bergmann <arnd@arndb.de>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Serial Port driver for Open Firmware platform devices");


