Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D362211493;
	Thu, 12 Dec 2024 17:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024333; cv=none; b=Zqentrz712hV8W1qVZnpBD8QOKtWQrqYX9H0YjOINuuB+LBfn3zBdPkltieHifSCSHO7ltcu2dFWQbegDMEP1UHsj7ithyZodertWxXujVF9V7TwsDrEBFP6BYHOXe0Y7uO9Agy+SSekEk7C4z82dIhb0B806WZxnpKgRTBFtKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024333; c=relaxed/simple;
	bh=SzMCPTK2u7yNIGehcR4grXwSHIghTIeJQd2Hfjz4LFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dl8DNHoJEmwJc/OCr9Tsrt7srow1Kr744JGtTzFkTJH7r1Yd0po5mSKkQGBtbF4qMNxfydBlrERBx0hBCVh3ARtDtdYXFnUEOvISG4iNB1LVzsq97wW3JG86/rnsQlsze0aYKdURthmUrEINwSg9icQBf/slTEPl2hHE7fsFHtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D4bg4sYx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D4bg4sYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBD7C4CECE;
	Thu, 12 Dec 2024 17:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024333;
	bh=SzMCPTK2u7yNIGehcR4grXwSHIghTIeJQd2Hfjz4LFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D4bg4sYx6YGL59di0Gf835EZyUA4+adUg/hiWZlTH1G4+JOva9aMoGp7QXcB3PCp6
	 JhISmmjekdMvgFM0OAz2sKoVUDwdpj3TG+OZIuqXEwzsjrSymh7E7D5hrV+ZJNkmSP
	 YMHsSEVT8YrS0bbZNpqZBAEW0AHt8zrI2sHqfFj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 5.10 262/459] serial: sh-sci: Clean sci_ports[0] after at earlycon exit
Date: Thu, 12 Dec 2024 16:00:00 +0100
Message-ID: <20241212144303.951891374@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit 3791ea69a4858b81e0277f695ca40f5aae40f312 upstream.

The early_console_setup() function initializes the sci_ports[0].port with
an object of type struct uart_port obtained from the object of type
struct earlycon_device received as argument by the early_console_setup().

It may happen that later, when the rest of the serial ports are probed,
the serial port that was used as earlycon (e.g., port A) to be mapped to a
different position in sci_ports[] and the slot 0 to be used by a different
serial port (e.g., port B), as follows:

sci_ports[0] = port A
sci_ports[X] = port B

In this case, the new port mapped at index zero will have associated data
that was used for earlycon.

In case this happens, after Linux boot, any access to the serial port that
maps on sci_ports[0] (port A) will block the serial port that was used as
earlycon (port B).

To fix this, add early_console_exit() that clean the sci_ports[0] at
earlycon exit time.

Fixes: 0b0cced19ab1 ("serial: sh-sci: Add CONFIG_SERIAL_EARLYCON support")
Cc: stable@vger.kernel.org
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://lore.kernel.org/r/20241106120118.1719888-4-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sh-sci.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -3457,6 +3457,32 @@ sh_early_platform_init_buffer("earlyprin
 #ifdef CONFIG_SERIAL_SH_SCI_EARLYCON
 static struct plat_sci_port port_cfg __initdata;
 
+static int early_console_exit(struct console *co)
+{
+	struct sci_port *sci_port = &sci_ports[0];
+	struct uart_port *port = &sci_port->port;
+	unsigned long flags;
+	int locked = 1;
+
+	if (port->sysrq)
+		locked = 0;
+	else if (oops_in_progress)
+		locked = uart_port_trylock_irqsave(port, &flags);
+	else
+		uart_port_lock_irqsave(port, &flags);
+
+	/*
+	 * Clean the slot used by earlycon. A new SCI device might
+	 * map to this slot.
+	 */
+	memset(sci_ports, 0, sizeof(*sci_port));
+
+	if (locked)
+		uart_port_unlock_irqrestore(port, flags);
+
+	return 0;
+}
+
 static int __init early_console_setup(struct earlycon_device *device,
 				      int type)
 {
@@ -3475,6 +3501,8 @@ static int __init early_console_setup(st
 		       SCSCR_RE | SCSCR_TE | port_cfg.scscr);
 
 	device->con->write = serial_console_write;
+	device->con->exit = early_console_exit;
+
 	return 0;
 }
 static int __init sci_early_console_setup(struct earlycon_device *device,


