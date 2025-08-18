Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0440431AF15;
	Mon, 18 Aug 2025 13:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522013; cv=none; b=X5iKMS+IhjMBVcg9aPugZZSRCTpP0Mc9VIX0Ae4spcmCmO5hW3uRs9mit8+0nALe/cn5CXEZUuCiaKr4jKzDAl7NR7eW0BbgMEkO8DQgmdkfSGdeUMT295ylC81nYG3NxnZ0UNR781Y26BrPkXJdP4Z5EC+tLTouPHmfuxtGflU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522013; c=relaxed/simple;
	bh=z1HExUjLeqQKYXwL8T9qsNVMcpVND6/Is/GDzHcMv5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVUw0OF04OX76QL4q6013e4Ku5DdRDxfJkqE69c11b6pj67PWFEfGv/NBgIp5ubupZmc7rvD2a/ifdYScyzqPwGt62TDHFSYczCFxSm9EhQJ0xLCvJNgLwF7MjLmOS1YutKpRe96BFLQSgOIb4+Ay8GBdI/7XlIHAMMVoXrmIAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ek+ML6NZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ek+ML6NZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396B2C4CEEB;
	Mon, 18 Aug 2025 13:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522012;
	bh=z1HExUjLeqQKYXwL8T9qsNVMcpVND6/Is/GDzHcMv5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ek+ML6NZo/NzOp1pj/1YxZ+75Kfv0WW5a/5UwyUuCVAiZLartm9be/2woDIJ6gNmL
	 PL43zqWMjRqXYkBetkJXDhMF2DrHiKHxrqsmt7zxGpV6b3C6f/pCqY/M3xtoXd7DUC
	 I3oWcM4HlvIUQwx3w3zie4TPzOzpDvh0e8XLseVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Tilahun <jtilahun@astranis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 146/444] tty: serial: fix print format specifiers
Date: Mon, 18 Aug 2025 14:42:52 +0200
Message-ID: <20250818124454.387316391@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Joseph Tilahun <jtilahun@astranis.com>

[ Upstream commit 33a2515abd45c64911955ff1da179589db54f99f ]

The serial info sometimes produces negative TX/RX counts. E.g.:

3: uart:FSL_LPUART mmio:0x02970000 irq:46 tx:-1595870545 rx:339619
RTS|CTS|DTR|DSR|CD

It appears that the print format specifiers don't match with the types of
the respective variables. E.g.: All of the fields in struct uart_icount
are u32, but the format specifier used is %d, even though u32 is unsigned
and %d is for signed integers. Update drivers/tty/serial/serial_core.c
to use the proper format specifiers. Reference
https://docs.kernel.org/core-api/printk-formats.html as the documentation
for what format specifiers are the proper ones to use for a given C type.

Signed-off-by: Joseph Tilahun <jtilahun@astranis.com>
Link: https://lore.kernel.org/r/20250610065653.3750067-1-jtilahun@astranis.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 44 ++++++++++++++++----------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index d94d73e45fb6..440303566b14 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1353,28 +1353,28 @@ static void uart_sanitize_serial_rs485_delays(struct uart_port *port,
 	if (!port->rs485_supported.delay_rts_before_send) {
 		if (rs485->delay_rts_before_send) {
 			dev_warn_ratelimited(port->dev,
-				"%s (%d): RTS delay before sending not supported\n",
+				"%s (%u): RTS delay before sending not supported\n",
 				port->name, port->line);
 		}
 		rs485->delay_rts_before_send = 0;
 	} else if (rs485->delay_rts_before_send > RS485_MAX_RTS_DELAY) {
 		rs485->delay_rts_before_send = RS485_MAX_RTS_DELAY;
 		dev_warn_ratelimited(port->dev,
-			"%s (%d): RTS delay before sending clamped to %u ms\n",
+			"%s (%u): RTS delay before sending clamped to %u ms\n",
 			port->name, port->line, rs485->delay_rts_before_send);
 	}
 
 	if (!port->rs485_supported.delay_rts_after_send) {
 		if (rs485->delay_rts_after_send) {
 			dev_warn_ratelimited(port->dev,
-				"%s (%d): RTS delay after sending not supported\n",
+				"%s (%u): RTS delay after sending not supported\n",
 				port->name, port->line);
 		}
 		rs485->delay_rts_after_send = 0;
 	} else if (rs485->delay_rts_after_send > RS485_MAX_RTS_DELAY) {
 		rs485->delay_rts_after_send = RS485_MAX_RTS_DELAY;
 		dev_warn_ratelimited(port->dev,
-			"%s (%d): RTS delay after sending clamped to %u ms\n",
+			"%s (%u): RTS delay after sending clamped to %u ms\n",
 			port->name, port->line, rs485->delay_rts_after_send);
 	}
 }
@@ -1404,14 +1404,14 @@ static void uart_sanitize_serial_rs485(struct uart_port *port, struct serial_rs4
 			rs485->flags &= ~SER_RS485_RTS_AFTER_SEND;
 
 			dev_warn_ratelimited(port->dev,
-				"%s (%d): invalid RTS setting, using RTS_ON_SEND instead\n",
+				"%s (%u): invalid RTS setting, using RTS_ON_SEND instead\n",
 				port->name, port->line);
 		} else {
 			rs485->flags |= SER_RS485_RTS_AFTER_SEND;
 			rs485->flags &= ~SER_RS485_RTS_ON_SEND;
 
 			dev_warn_ratelimited(port->dev,
-				"%s (%d): invalid RTS setting, using RTS_AFTER_SEND instead\n",
+				"%s (%u): invalid RTS setting, using RTS_AFTER_SEND instead\n",
 				port->name, port->line);
 		}
 	}
@@ -1850,7 +1850,7 @@ static void uart_wait_until_sent(struct tty_struct *tty, int timeout)
 
 	expire = jiffies + timeout;
 
-	pr_debug("uart_wait_until_sent(%d), jiffies=%lu, expire=%lu...\n",
+	pr_debug("uart_wait_until_sent(%u), jiffies=%lu, expire=%lu...\n",
 		port->line, jiffies, expire);
 
 	/*
@@ -2046,7 +2046,7 @@ static void uart_line_info(struct seq_file *m, struct uart_driver *drv, int i)
 		return;
 
 	mmio = uport->iotype >= UPIO_MEM;
-	seq_printf(m, "%d: uart:%s %s%08llX irq:%d",
+	seq_printf(m, "%u: uart:%s %s%08llX irq:%u",
 			uport->line, uart_type(uport),
 			mmio ? "mmio:0x" : "port:",
 			mmio ? (unsigned long long)uport->mapbase
@@ -2068,18 +2068,18 @@ static void uart_line_info(struct seq_file *m, struct uart_driver *drv, int i)
 		if (pm_state != UART_PM_STATE_ON)
 			uart_change_pm(state, pm_state);
 
-		seq_printf(m, " tx:%d rx:%d",
+		seq_printf(m, " tx:%u rx:%u",
 				uport->icount.tx, uport->icount.rx);
 		if (uport->icount.frame)
-			seq_printf(m, " fe:%d",	uport->icount.frame);
+			seq_printf(m, " fe:%u",	uport->icount.frame);
 		if (uport->icount.parity)
-			seq_printf(m, " pe:%d",	uport->icount.parity);
+			seq_printf(m, " pe:%u",	uport->icount.parity);
 		if (uport->icount.brk)
-			seq_printf(m, " brk:%d", uport->icount.brk);
+			seq_printf(m, " brk:%u", uport->icount.brk);
 		if (uport->icount.overrun)
-			seq_printf(m, " oe:%d", uport->icount.overrun);
+			seq_printf(m, " oe:%u", uport->icount.overrun);
 		if (uport->icount.buf_overrun)
-			seq_printf(m, " bo:%d", uport->icount.buf_overrun);
+			seq_printf(m, " bo:%u", uport->icount.buf_overrun);
 
 #define INFOBIT(bit, str) \
 	if (uport->mctrl & (bit)) \
@@ -2571,7 +2571,7 @@ uart_report_port(struct uart_driver *drv, struct uart_port *port)
 		break;
 	}
 
-	pr_info("%s%s%s at %s (irq = %d, base_baud = %d) is a %s\n",
+	pr_info("%s%s%s at %s (irq = %u, base_baud = %u) is a %s\n",
 	       port->dev ? dev_name(port->dev) : "",
 	       port->dev ? ": " : "",
 	       port->name,
@@ -2579,7 +2579,7 @@ uart_report_port(struct uart_driver *drv, struct uart_port *port)
 
 	/* The magic multiplier feature is a bit obscure, so report it too.  */
 	if (port->flags & UPF_MAGIC_MULTIPLIER)
-		pr_info("%s%s%s extra baud rates supported: %d, %d",
+		pr_info("%s%s%s extra baud rates supported: %u, %u",
 			port->dev ? dev_name(port->dev) : "",
 			port->dev ? ": " : "",
 			port->name,
@@ -2978,7 +2978,7 @@ static ssize_t close_delay_show(struct device *dev,
 	struct tty_port *port = dev_get_drvdata(dev);
 
 	uart_get_info(port, &tmp);
-	return sprintf(buf, "%d\n", tmp.close_delay);
+	return sprintf(buf, "%u\n", tmp.close_delay);
 }
 
 static ssize_t closing_wait_show(struct device *dev,
@@ -2988,7 +2988,7 @@ static ssize_t closing_wait_show(struct device *dev,
 	struct tty_port *port = dev_get_drvdata(dev);
 
 	uart_get_info(port, &tmp);
-	return sprintf(buf, "%d\n", tmp.closing_wait);
+	return sprintf(buf, "%u\n", tmp.closing_wait);
 }
 
 static ssize_t custom_divisor_show(struct device *dev,
@@ -3008,7 +3008,7 @@ static ssize_t io_type_show(struct device *dev,
 	struct tty_port *port = dev_get_drvdata(dev);
 
 	uart_get_info(port, &tmp);
-	return sprintf(buf, "%d\n", tmp.io_type);
+	return sprintf(buf, "%u\n", tmp.io_type);
 }
 
 static ssize_t iomem_base_show(struct device *dev,
@@ -3028,7 +3028,7 @@ static ssize_t iomem_reg_shift_show(struct device *dev,
 	struct tty_port *port = dev_get_drvdata(dev);
 
 	uart_get_info(port, &tmp);
-	return sprintf(buf, "%d\n", tmp.iomem_reg_shift);
+	return sprintf(buf, "%u\n", tmp.iomem_reg_shift);
 }
 
 static ssize_t console_show(struct device *dev,
@@ -3168,7 +3168,7 @@ static int serial_core_add_one_port(struct uart_driver *drv, struct uart_port *u
 	state->pm_state = UART_PM_STATE_UNDEFINED;
 	uart_port_set_cons(uport, drv->cons);
 	uport->minor = drv->tty_driver->minor_start + uport->line;
-	uport->name = kasprintf(GFP_KERNEL, "%s%d", drv->dev_name,
+	uport->name = kasprintf(GFP_KERNEL, "%s%u", drv->dev_name,
 				drv->tty_driver->name_base + uport->line);
 	if (!uport->name) {
 		ret = -ENOMEM;
@@ -3211,7 +3211,7 @@ static int serial_core_add_one_port(struct uart_driver *drv, struct uart_port *u
 		device_set_wakeup_capable(tty_dev, 1);
 	} else {
 		uport->flags |= UPF_DEAD;
-		dev_err(uport->dev, "Cannot register tty device on line %d\n",
+		dev_err(uport->dev, "Cannot register tty device on line %u\n",
 		       uport->line);
 	}
 
-- 
2.39.5



