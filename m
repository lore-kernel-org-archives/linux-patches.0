Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AB7221543;
	Mon, 23 Jun 2025 22:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717550; cv=none; b=kDqFROrmkcj0xEDmuDR0/naqUySnxvD2CUyVj+/guwx0JomhFr+eVtmW9a6OJP6wg3dHyvdD0QbiuwLWUvuLe/Ze4ytPqim8gpoLc+Yd6wN7iPlvBTpaWRLVrdtJeAuFY2rRI/nhcaJYKtHjQJk283Ubm0Yq/y21lZNEDBdbGCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717550; c=relaxed/simple;
	bh=+jrC7HgT2ssyfa6URUgi5mKzFW6DAATZlNvyKUPWhC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIXPkoZbBxQflYPcK9LPOsT9NjyBn6NJ8HZu4qXcLTaDcvUDoIwOfw+vd/2gsz0uTts+JiPJMn9VVL4JFfHHktZUBTx2oZPn3BiJLsXw1ce6zQBOkep17jR7oNY0isZi2sI9YPuijn8Ov48nTjq1KdMfdgAGZNehnOVfGjczROs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWsQjdeY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWsQjdeY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50059C4CEEA;
	Mon, 23 Jun 2025 22:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717550;
	bh=+jrC7HgT2ssyfa6URUgi5mKzFW6DAATZlNvyKUPWhC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QWsQjdeY+baiv5I21I0bh6WB+wg2TT/VAWiZiM3N8mZof2aKiNXYmLNf2KksyB3oC
	 A9/i/9vBHdYUqI5ZE/wiNKemYH7gX008OMpz9ydc05QLtIFWgdot0vFnBeJvrPNXPv
	 px8t9IwGFNePPnyEG1lW8K2o9tgEkSTkNvjd0OWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 6.12 398/414] serial: sh-sci: Clean sci_ports[0] after at earlycon exit
Date: Mon, 23 Jun 2025 15:08:55 +0200
Message-ID: <20250623130651.888887229@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit 5f1017069933489add0c08659673443c9905659e upstream.

The early_console_setup() function initializes sci_ports[0].port with an
object of type struct uart_port obtained from the struct earlycon_device
passed as an argument to early_console_setup().

Later, during serial port probing, the serial port used as earlycon
(e.g., port A) might be remapped to a different position in the sci_ports[]
array, and a different serial port (e.g., port B) might be assigned to slot
0. For example:

sci_ports[0] = port B
sci_ports[X] = port A

In this scenario, the new port mapped at index zero (port B) retains the
data associated with the earlycon configuration. Consequently, after the
Linux boot process, any access to the serial port now mapped to
sci_ports[0] (port B) will block the original earlycon port (port A).

To address this, introduce an early_console_exit() function to clean up
sci_ports[0] when earlycon is exited.

To prevent the cleanup of sci_ports[0] while the serial device is still
being used by earlycon, introduce the struct sci_port::probing flag and
account for it in early_console_exit().

Fixes: 0b0cced19ab1 ("serial: sh-sci: Add CONFIG_SERIAL_EARLYCON support")
Cc: stable@vger.kernel.org
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://lore.kernel.org/r/20250116182249.3828577-5-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sh-sci.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -183,6 +183,7 @@ static struct sci_port sci_ports[SCI_NPO
 static unsigned long sci_ports_in_use;
 static struct uart_driver sci_uart_driver;
 static bool sci_uart_earlycon;
+static bool sci_uart_earlycon_dev_probing;
 
 static inline struct sci_port *
 to_sci_port(struct uart_port *uart)
@@ -3404,7 +3405,8 @@ static struct plat_sci_port *sci_parse_d
 static int sci_probe_single(struct platform_device *dev,
 				      unsigned int index,
 				      struct plat_sci_port *p,
-				      struct sci_port *sciport)
+				      struct sci_port *sciport,
+				      struct resource *sci_res)
 {
 	int ret;
 
@@ -3451,6 +3453,14 @@ static int sci_probe_single(struct platf
 		sciport->port.flags |= UPF_HARD_FLOW;
 	}
 
+	if (sci_uart_earlycon && sci_ports[0].port.mapbase == sci_res->start) {
+		/*
+		 * Skip cleanup the sci_port[0] in early_console_exit(), this
+		 * port is the same as the earlycon one.
+		 */
+		sci_uart_earlycon_dev_probing = true;
+	}
+
 	return uart_add_one_port(&sci_uart_driver, &sciport->port);
 }
 
@@ -3509,7 +3519,7 @@ static int sci_probe(struct platform_dev
 
 	platform_set_drvdata(dev, sp);
 
-	ret = sci_probe_single(dev, dev_id, p, sp);
+	ret = sci_probe_single(dev, dev_id, p, sp, res);
 	if (ret)
 		return ret;
 
@@ -3666,6 +3676,22 @@ sh_early_platform_init_buffer("earlyprin
 #ifdef CONFIG_SERIAL_SH_SCI_EARLYCON
 static struct plat_sci_port port_cfg;
 
+static int early_console_exit(struct console *co)
+{
+	struct sci_port *sci_port = &sci_ports[0];
+
+	/*
+	 * Clean the slot used by earlycon. A new SCI device might
+	 * map to this slot.
+	 */
+	if (!sci_uart_earlycon_dev_probing) {
+		memset(sci_port, 0, sizeof(*sci_port));
+		sci_uart_earlycon = false;
+	}
+
+	return 0;
+}
+
 static int __init early_console_setup(struct earlycon_device *device,
 				      int type)
 {
@@ -3683,6 +3709,8 @@ static int __init early_console_setup(st
 		       SCSCR_RE | SCSCR_TE | port_cfg.scscr);
 
 	device->con->write = serial_console_write;
+	device->con->exit = early_console_exit;
+
 	return 0;
 }
 static int __init sci_early_console_setup(struct earlycon_device *device,


