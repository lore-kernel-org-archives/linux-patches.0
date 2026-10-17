Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068723ACF0E;
	Sat, 17 Oct 2026 16:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255343; cv=none; b=lMKQT3yY4PlmVqIceMn0dy6tTJV8NVeUHT+/Qtkv/rqMrOmfRPNeIRqyiMw3/yQsDbIGA/+qrnDnRqwSN8G5tDMYTVSSZZw903vohBgMFeR4LOi6IUaGmcPJswvDY25Pc8Sr6kQqySqMS+gdLptnw8Ra7UYiClDj5vRT3p9fCho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255343; c=relaxed/simple;
	bh=k618+G56CGLZ6zqaUTynuSOV6iXhKuYa4LxENMLUxks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=biHN8htD3mVoGnaCKKo8WBAS0sOFM/svKlHf407iupRlDe0fYGMvkhx+ZdtA4l06L7mBHPLv5qfJ+eyFN9hD+y13zYGhJYHUxkmuo6ztX7L7P4Rpy3F2gnK7ervKOpVI7F3LqecYQEzrmm98QHhC18EGlH62TwOfVfGPRC59gbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNNKfxa3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNNKfxa3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E8A1F000C4;
	Sat, 17 Oct 2026 16:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255341;
	bh=BzJVNL/ZP/R4sCMRzg70mOPyrXL/Ejn3499s2HUOlmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YNNKfxa3wRDkycHltV2zTZTawAkY9VW6PmfACeqHt9nbrTwdB4K3WXDlCZILuAssK
	 WkMvnPnAVmhHZy6QQdGnu6C0lKafYJu+wSXTOrNDvCJcFtox5MsYMiybEAgqHhI/UX
	 6YPf+cAYBlbJmgREBR6erLtV9jjja61clOzfxgkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 742/869] serial: 8250: invert serial8250_register_8250_port() CIR condition
Date: Sat, 17 Oct 2026 17:59:43 +0200
Message-ID: <20261017160055.966109473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit 05b537a175442c530593013ea31b3f48d5624916 ]

There is no point in a long 'if' in serial8250_register_8250_port() to
just return ENOSPC for PORT_8250_CIR ports. Invert the condition and
return immediately.

'gpios' variable was moved to its set location.

And return ENODEV instead of ENOSPC. The latter is a leftover from the
previous find-uart 'if'. The former makes a lot more sense in this case.

Signed-off-by: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20250611100319.186924-31-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 941c9f84c9b6 ("tty: serial: 8250: protect against NULL uart->port.dev in register")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_core.c | 253 ++++++++++++++--------------
 1 file changed, 127 insertions(+), 126 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 68baf75bdadc4..d7034f305c7b2 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -715,139 +715,140 @@ int serial8250_register_8250_port(const struct uart_8250_port *up)
 		nr_uarts++;
 	}
 
-	if (uart->port.type != PORT_8250_CIR) {
-		struct mctrl_gpios *gpios;
-
-		if (uart->port.dev)
-			uart_remove_one_port(&serial8250_reg, &uart->port);
-
-		uart->port.ctrl_id	= up->port.ctrl_id;
-		uart->port.port_id	= up->port.port_id;
-		uart->port.iobase       = up->port.iobase;
-		uart->port.membase      = up->port.membase;
-		uart->port.irq          = up->port.irq;
-		uart->port.irqflags     = up->port.irqflags;
-		uart->port.uartclk      = up->port.uartclk;
-		uart->port.fifosize     = up->port.fifosize;
-		uart->port.regshift     = up->port.regshift;
-		uart->port.iotype       = up->port.iotype;
-		uart->port.flags        = up->port.flags | UPF_BOOT_AUTOCONF;
-		uart->bugs		= up->bugs;
-		uart->port.mapbase      = up->port.mapbase;
-		uart->port.mapsize      = up->port.mapsize;
-		uart->port.private_data = up->port.private_data;
-		uart->tx_loadsz		= up->tx_loadsz;
-		uart->capabilities	= up->capabilities;
-		uart->port.throttle	= up->port.throttle;
-		uart->port.unthrottle	= up->port.unthrottle;
-		uart->port.rs485_config	= up->port.rs485_config;
-		uart->port.rs485_supported = up->port.rs485_supported;
-		uart->port.rs485	= up->port.rs485;
-		uart->rs485_start_tx	= up->rs485_start_tx;
-		uart->rs485_stop_tx	= up->rs485_stop_tx;
-		uart->lsr_save_mask	= up->lsr_save_mask;
-		uart->dma		= up->dma;
-
-		/* Take tx_loadsz from fifosize if it wasn't set separately */
-		if (uart->port.fifosize && !uart->tx_loadsz)
-			uart->tx_loadsz = uart->port.fifosize;
-
-		if (up->port.dev) {
-			uart->port.dev = up->port.dev;
-			ret = uart_get_rs485_mode(&uart->port);
-			if (ret)
-				goto err;
-		}
+	if (uart->port.type == PORT_8250_CIR) {
+		ret = -ENODEV;
+		goto unlock;
+	}
 
-		if (up->port.flags & UPF_FIXED_TYPE)
-			uart->port.type = up->port.type;
+	if (uart->port.dev)
+		uart_remove_one_port(&serial8250_reg, &uart->port);
+
+	uart->port.ctrl_id	= up->port.ctrl_id;
+	uart->port.port_id	= up->port.port_id;
+	uart->port.iobase       = up->port.iobase;
+	uart->port.membase      = up->port.membase;
+	uart->port.irq          = up->port.irq;
+	uart->port.irqflags     = up->port.irqflags;
+	uart->port.uartclk      = up->port.uartclk;
+	uart->port.fifosize     = up->port.fifosize;
+	uart->port.regshift     = up->port.regshift;
+	uart->port.iotype       = up->port.iotype;
+	uart->port.flags        = up->port.flags | UPF_BOOT_AUTOCONF;
+	uart->bugs		= up->bugs;
+	uart->port.mapbase      = up->port.mapbase;
+	uart->port.mapsize      = up->port.mapsize;
+	uart->port.private_data = up->port.private_data;
+	uart->tx_loadsz		= up->tx_loadsz;
+	uart->capabilities	= up->capabilities;
+	uart->port.throttle	= up->port.throttle;
+	uart->port.unthrottle	= up->port.unthrottle;
+	uart->port.rs485_config	= up->port.rs485_config;
+	uart->port.rs485_supported = up->port.rs485_supported;
+	uart->port.rs485	= up->port.rs485;
+	uart->rs485_start_tx	= up->rs485_start_tx;
+	uart->rs485_stop_tx	= up->rs485_stop_tx;
+	uart->lsr_save_mask	= up->lsr_save_mask;
+	uart->dma		= up->dma;
+
+	/* Take tx_loadsz from fifosize if it wasn't set separately */
+	if (uart->port.fifosize && !uart->tx_loadsz)
+		uart->tx_loadsz = uart->port.fifosize;
+
+	if (up->port.dev) {
+		uart->port.dev = up->port.dev;
+		ret = uart_get_rs485_mode(&uart->port);
+		if (ret)
+			goto err;
+	}
 
-		/*
-		 * Only call mctrl_gpio_init(), if the device has no ACPI
-		 * companion device
-		 */
-		if (!has_acpi_companion(uart->port.dev)) {
-			gpios = mctrl_gpio_init(&uart->port, 0);
-			if (IS_ERR(gpios)) {
-				ret = PTR_ERR(gpios);
-				goto err;
-			} else {
-				uart->gpios = gpios;
-			}
-		}
+	if (up->port.flags & UPF_FIXED_TYPE)
+		uart->port.type = up->port.type;
 
-		serial8250_set_defaults(uart);
-
-		/* Possibly override default I/O functions.  */
-		if (up->port.serial_in)
-			uart->port.serial_in = up->port.serial_in;
-		if (up->port.serial_out)
-			uart->port.serial_out = up->port.serial_out;
-		if (up->port.handle_irq)
-			uart->port.handle_irq = up->port.handle_irq;
-		/*  Possibly override set_termios call */
-		if (up->port.set_termios)
-			uart->port.set_termios = up->port.set_termios;
-		if (up->port.set_ldisc)
-			uart->port.set_ldisc = up->port.set_ldisc;
-		if (up->port.get_mctrl)
-			uart->port.get_mctrl = up->port.get_mctrl;
-		if (up->port.set_mctrl)
-			uart->port.set_mctrl = up->port.set_mctrl;
-		if (up->port.get_divisor)
-			uart->port.get_divisor = up->port.get_divisor;
-		if (up->port.set_divisor)
-			uart->port.set_divisor = up->port.set_divisor;
-		if (up->port.startup)
-			uart->port.startup = up->port.startup;
-		if (up->port.shutdown)
-			uart->port.shutdown = up->port.shutdown;
-		if (up->port.pm)
-			uart->port.pm = up->port.pm;
-		if (up->port.handle_break)
-			uart->port.handle_break = up->port.handle_break;
-		if (up->dl_read)
-			uart->dl_read = up->dl_read;
-		if (up->dl_write)
-			uart->dl_write = up->dl_write;
-
-		if (uart->port.type != PORT_8250_CIR) {
-			if (uart_console_registered(&uart->port))
-				pm_runtime_get_sync(uart->port.dev);
-
-			if (serial8250_isa_config != NULL)
-				serial8250_isa_config(0, &uart->port,
-						&uart->capabilities);
-
-			serial8250_apply_quirks(uart);
-			ret = uart_add_one_port(&serial8250_reg,
-						&uart->port);
-			if (ret)
-				goto err;
-
-			ret = uart->port.line;
+	/*
+	 * Only call mctrl_gpio_init(), if the device has no ACPI
+	 * companion device
+	 */
+	if (!has_acpi_companion(uart->port.dev)) {
+		struct mctrl_gpios *gpios = mctrl_gpio_init(&uart->port, 0);
+		if (IS_ERR(gpios)) {
+			ret = PTR_ERR(gpios);
+			goto err;
 		} else {
-			dev_info(uart->port.dev,
-				"skipping CIR port at 0x%lx / 0x%llx, IRQ %d\n",
-				uart->port.iobase,
-				(unsigned long long)uart->port.mapbase,
-				uart->port.irq);
-
-			ret = 0;
+			uart->gpios = gpios;
 		}
+	}
 
-		if (!uart->lsr_save_mask)
-			uart->lsr_save_mask = LSR_SAVE_FLAGS;	/* Use default LSR mask */
+	serial8250_set_defaults(uart);
+
+	/* Possibly override default I/O functions.  */
+	if (up->port.serial_in)
+		uart->port.serial_in = up->port.serial_in;
+	if (up->port.serial_out)
+		uart->port.serial_out = up->port.serial_out;
+	if (up->port.handle_irq)
+		uart->port.handle_irq = up->port.handle_irq;
+	/*  Possibly override set_termios call */
+	if (up->port.set_termios)
+		uart->port.set_termios = up->port.set_termios;
+	if (up->port.set_ldisc)
+		uart->port.set_ldisc = up->port.set_ldisc;
+	if (up->port.get_mctrl)
+		uart->port.get_mctrl = up->port.get_mctrl;
+	if (up->port.set_mctrl)
+		uart->port.set_mctrl = up->port.set_mctrl;
+	if (up->port.get_divisor)
+		uart->port.get_divisor = up->port.get_divisor;
+	if (up->port.set_divisor)
+		uart->port.set_divisor = up->port.set_divisor;
+	if (up->port.startup)
+		uart->port.startup = up->port.startup;
+	if (up->port.shutdown)
+		uart->port.shutdown = up->port.shutdown;
+	if (up->port.pm)
+		uart->port.pm = up->port.pm;
+	if (up->port.handle_break)
+		uart->port.handle_break = up->port.handle_break;
+	if (up->dl_read)
+		uart->dl_read = up->dl_read;
+	if (up->dl_write)
+		uart->dl_write = up->dl_write;
 
-		/* Initialise interrupt backoff work if required */
-		if (up->overrun_backoff_time_ms > 0) {
-			uart->overrun_backoff_time_ms =
-				up->overrun_backoff_time_ms;
-			INIT_DELAYED_WORK(&uart->overrun_backoff,
-					serial_8250_overrun_backoff_work);
-		} else {
-			uart->overrun_backoff_time_ms = 0;
-		}
+	if (uart->port.type != PORT_8250_CIR) {
+		if (uart_console_registered(&uart->port))
+			pm_runtime_get_sync(uart->port.dev);
+
+		if (serial8250_isa_config != NULL)
+			serial8250_isa_config(0, &uart->port,
+					&uart->capabilities);
+
+		serial8250_apply_quirks(uart);
+		ret = uart_add_one_port(&serial8250_reg,
+					&uart->port);
+		if (ret)
+			goto err;
+
+		ret = uart->port.line;
+	} else {
+		dev_info(uart->port.dev,
+			"skipping CIR port at 0x%lx / 0x%llx, IRQ %d\n",
+			uart->port.iobase,
+			(unsigned long long)uart->port.mapbase,
+			uart->port.irq);
+
+		ret = 0;
+	}
+
+	if (!uart->lsr_save_mask)
+		uart->lsr_save_mask = LSR_SAVE_FLAGS;	/* Use default LSR mask */
+
+	/* Initialise interrupt backoff work if required */
+	if (up->overrun_backoff_time_ms > 0) {
+		uart->overrun_backoff_time_ms =
+			up->overrun_backoff_time_ms;
+		INIT_DELAYED_WORK(&uart->overrun_backoff,
+				serial_8250_overrun_backoff_work);
+	} else {
+		uart->overrun_backoff_time_ms = 0;
 	}
 
 unlock:
-- 
2.53.0



