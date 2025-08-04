Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF0818A6B0;
	Mon,  4 Aug 2025 00:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267433; cv=none; b=NmNJWmtjpkfp5mBDL8bfttIL8G9cLghsOKE1Tu16rvm3H+RdZmYbICWINqVIRuS1lU0zMS4dYNQing/X7bulw1Edqoy1XJhzQjpSwqqhe634AGqtHKK1gnaZ6PrqgnNfw7QRzwyfjyMVhcmxSsE1SmG4WZuYZWhIbx7xMq8d1Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267433; c=relaxed/simple;
	bh=Fx1LLTcQgnHys3EAZEeCY9nh50t+O9ev8j2WvwidOJg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TeP6WB5D0W6kMwr5/PwJayqrQUzAB1Vlaa4N3Cgp9/8Iyktm2URSmcwWD5Dkp9aLt5Z4ISOOoGZ+B8GARmHkKieArlY10QwAoyBGCwCouNKEscHTj5b8KbzA/SYsaMWnBZfSv4zkf6dG9j0fNXNP9uFwPkCzI6M/jHxl7R+XY5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mw3OVANe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mw3OVANe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F24C4CEF0;
	Mon,  4 Aug 2025 00:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267433;
	bh=Fx1LLTcQgnHys3EAZEeCY9nh50t+O9ev8j2WvwidOJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mw3OVANeixQ2EW5E4uavRgRBz9A1qfFVqeA0K4Xae4Yzo49OU8JE4MzYkrPgmvBRH
	 wPxCDLIsp8KXNxWS1oERaxtKseIQZyZ9ftTp9Q74rdjOQC+q+GrJoDK/9q4qBskmj+
	 DyL0c5B9jagTR7xxPqwjSLq8LhHQ4KNFxViOVb+wmUv7VKiXg+SmSBxNX24zCwc9J7
	 nlZWddSENMnWLfusOJ1D+jDazOFnr/mG7JtWNsTKLzSbYeBjwMTSc74o48gzYi5Tqc
	 iVFEmAeAkbeHjQ+c1z0ZOEE1ez9CfTxWTcS4LALMHB1CTv8xnfMc+NseMuu/aK1aFt
	 T+C/c/HQ2KFeg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Joseph Tilahun <jtilahun@astranis.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	jirislaby@kernel.org,
	pmladek@suse.com,
	ilpo.jarvinen@linux.intel.com,
	john.ogness@linutronix.de,
	mpdesouza@suse.com,
	zijun.hu@oss.qualcomm.com,
	linux@treblig.org
Subject: [PATCH AUTOSEL 6.15 64/80] tty: serial: fix print format specifiers
Date: Sun,  3 Aug 2025 20:27:31 -0400
Message-Id: <20250804002747.3617039-64-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002747.3617039-1-sashal@kernel.org>
References: <20250804002747.3617039-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.9
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **It fixes a real user-visible bug**: The commit fixes incorrect
   format specifiers that cause negative values to be displayed for
   TX/RX counts in `/proc/tty/driver/serial`. The example shows:
  ```
  3: uart:FSL_LPUART mmio:0x02970000 irq:46 tx:-1595870545 rx:339619
  ```
  This is clearly wrong as TX/RX counts should never be negative.

2. **The fix is simple and contained**: The changes only modify format
   specifiers from `%d` (signed) to `%u` (unsigned) in print statements.
   Looking at the code:
   - All `uart_icount` fields (tx, rx, frame, parity, brk, overrun,
     buf_overrun) are defined as `__u32` (unsigned 32-bit)
   - `port->line` is `unsigned int`
   - `port->irq` is `unsigned int`
   - `port->uartclk` is `unsigned int`
   - Other fields like `close_delay`, `closing_wait`, `io_type`,
     `iomem_reg_shift` are also unsigned types

3. **Low risk of regression**: The changes are purely cosmetic - they
   only affect how values are displayed, not the actual functionality.
   No logic changes, no structural changes, just format string
   corrections.

4. **Affects a core subsystem**: The serial core is used by many serial
   drivers, so this bug affects multiple platforms and drivers. The fix
   benefits all users of the serial subsystem.

5. **Follows stable tree rules**: This is exactly the type of fix
   suitable for stable:
   - Fixes an actual bug (incorrect display of statistics)
   - Minimal change
   - Obviously correct (matching format specifiers to variable types)
   - No new features or architectural changes

The commit is a straightforward correctness fix that improves the
reliability of kernel diagnostics output without any risk of breaking
functionality.

 drivers/tty/serial/serial_core.c | 44 ++++++++++++++++----------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 88669972d9a0..8658377dbe1c 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1337,28 +1337,28 @@ static void uart_sanitize_serial_rs485_delays(struct uart_port *port,
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
@@ -1388,14 +1388,14 @@ static void uart_sanitize_serial_rs485(struct uart_port *port, struct serial_rs4
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
@@ -1834,7 +1834,7 @@ static void uart_wait_until_sent(struct tty_struct *tty, int timeout)
 
 	expire = jiffies + timeout;
 
-	pr_debug("uart_wait_until_sent(%d), jiffies=%lu, expire=%lu...\n",
+	pr_debug("uart_wait_until_sent(%u), jiffies=%lu, expire=%lu...\n",
 		port->line, jiffies, expire);
 
 	/*
@@ -2029,7 +2029,7 @@ static void uart_line_info(struct seq_file *m, struct uart_state *state)
 		return;
 
 	mmio = uport->iotype >= UPIO_MEM;
-	seq_printf(m, "%d: uart:%s %s%08llX irq:%d",
+	seq_printf(m, "%u: uart:%s %s%08llX irq:%u",
 			uport->line, uart_type(uport),
 			mmio ? "mmio:0x" : "port:",
 			mmio ? (unsigned long long)uport->mapbase
@@ -2051,18 +2051,18 @@ static void uart_line_info(struct seq_file *m, struct uart_state *state)
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
@@ -2554,7 +2554,7 @@ uart_report_port(struct uart_driver *drv, struct uart_port *port)
 		break;
 	}
 
-	pr_info("%s%s%s at %s (irq = %d, base_baud = %d) is a %s\n",
+	pr_info("%s%s%s at %s (irq = %u, base_baud = %u) is a %s\n",
 	       port->dev ? dev_name(port->dev) : "",
 	       port->dev ? ": " : "",
 	       port->name,
@@ -2562,7 +2562,7 @@ uart_report_port(struct uart_driver *drv, struct uart_port *port)
 
 	/* The magic multiplier feature is a bit obscure, so report it too.  */
 	if (port->flags & UPF_MAGIC_MULTIPLIER)
-		pr_info("%s%s%s extra baud rates supported: %d, %d",
+		pr_info("%s%s%s extra baud rates supported: %u, %u",
 			port->dev ? dev_name(port->dev) : "",
 			port->dev ? ": " : "",
 			port->name,
@@ -2961,7 +2961,7 @@ static ssize_t close_delay_show(struct device *dev,
 	struct tty_port *port = dev_get_drvdata(dev);
 
 	uart_get_info(port, &tmp);
-	return sprintf(buf, "%d\n", tmp.close_delay);
+	return sprintf(buf, "%u\n", tmp.close_delay);
 }
 
 static ssize_t closing_wait_show(struct device *dev,
@@ -2971,7 +2971,7 @@ static ssize_t closing_wait_show(struct device *dev,
 	struct tty_port *port = dev_get_drvdata(dev);
 
 	uart_get_info(port, &tmp);
-	return sprintf(buf, "%d\n", tmp.closing_wait);
+	return sprintf(buf, "%u\n", tmp.closing_wait);
 }
 
 static ssize_t custom_divisor_show(struct device *dev,
@@ -2991,7 +2991,7 @@ static ssize_t io_type_show(struct device *dev,
 	struct tty_port *port = dev_get_drvdata(dev);
 
 	uart_get_info(port, &tmp);
-	return sprintf(buf, "%d\n", tmp.io_type);
+	return sprintf(buf, "%u\n", tmp.io_type);
 }
 
 static ssize_t iomem_base_show(struct device *dev,
@@ -3011,7 +3011,7 @@ static ssize_t iomem_reg_shift_show(struct device *dev,
 	struct tty_port *port = dev_get_drvdata(dev);
 
 	uart_get_info(port, &tmp);
-	return sprintf(buf, "%d\n", tmp.iomem_reg_shift);
+	return sprintf(buf, "%u\n", tmp.iomem_reg_shift);
 }
 
 static ssize_t console_show(struct device *dev,
@@ -3147,7 +3147,7 @@ static int serial_core_add_one_port(struct uart_driver *drv, struct uart_port *u
 	state->pm_state = UART_PM_STATE_UNDEFINED;
 	uart_port_set_cons(uport, drv->cons);
 	uport->minor = drv->tty_driver->minor_start + uport->line;
-	uport->name = kasprintf(GFP_KERNEL, "%s%d", drv->dev_name,
+	uport->name = kasprintf(GFP_KERNEL, "%s%u", drv->dev_name,
 				drv->tty_driver->name_base + uport->line);
 	if (!uport->name)
 		return -ENOMEM;
@@ -3186,7 +3186,7 @@ static int serial_core_add_one_port(struct uart_driver *drv, struct uart_port *u
 		device_set_wakeup_capable(tty_dev, 1);
 	} else {
 		uport->flags |= UPF_DEAD;
-		dev_err(uport->dev, "Cannot register tty device on line %d\n",
+		dev_err(uport->dev, "Cannot register tty device on line %u\n",
 		       uport->line);
 	}
 
-- 
2.39.5

