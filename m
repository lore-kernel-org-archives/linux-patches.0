Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49E613A863;
	Fri,  6 Dec 2024 15:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498164; cv=none; b=foniT/1rZDTnpBisTY71u2hCQOzEB/rKyfzBtuBPFzlXNOdVoRUsfwGhL99TnK7r0ROeFaiy5iwDizpVkqvM3gvc1YF3SHVvzS1XOS/sbLFdvIytF9Vk5Anq2Io54BvR67u++mz06kNWp1oDkFELUdMrszYhanvhANc5501bKMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498164; c=relaxed/simple;
	bh=iG2K8X3O7l2Hn+fUd3vF7VinDlAin5H7MgR5jkiPTq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlOFySFyGaC/V1hODFoBg0BMLD2RrG00r5s5POj1OlOIg1CULJAVMl4kCJNvecrUFUw8Xaux6c7QHTLSGRnWn9KY7f44HmJFaBnBkhgUrX7Hccg01SeP5Vt3mbf+pKDKoL5QzRqFlbQD/bCt/TRiVWBI3UCAW5aYIieZtb0V+f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ipIX6BPy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ipIX6BPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BCE9C4CED1;
	Fri,  6 Dec 2024 15:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498163;
	bh=iG2K8X3O7l2Hn+fUd3vF7VinDlAin5H7MgR5jkiPTq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ipIX6BPypoGdfNmAL7RFnP7FNieJYkRFJHWwnKL+Ct2ghuk6WRVNRR1OwK9XYJlHS
	 mae9n6PRddbV/dDpdv8OeGw9UmLRfoPEahdV0loVjRrM8UtoCLSOWYmyNPt1M4CWxE
	 3j4wGLckkxzMn5fS6BhpZgPQzAO7IneUaLfVvB3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 6.6 503/676] serial: sh-sci: Clean sci_ports[0] after at earlycon exit
Date: Fri,  6 Dec 2024 15:35:22 +0100
Message-ID: <20241206143713.003607041@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3505,6 +3505,32 @@ sh_early_platform_init_buffer("earlyprin
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
@@ -3523,6 +3549,8 @@ static int __init early_console_setup(st
 		       SCSCR_RE | SCSCR_TE | port_cfg.scscr);
 
 	device->con->write = serial_console_write;
+	device->con->exit = early_console_exit;
+
 	return 0;
 }
 static int __init sci_early_console_setup(struct earlycon_device *device,


