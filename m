Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CB42B9B9;
	Tue,  3 Dec 2024 16:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242495; cv=none; b=HHdGXyaAVVtEhtEhyR62Tdc1oh/yuKizh4LYAKjnqJVIURAvOkL42nme9A6/k6Pi4yLSv5DP9F/kWkOjAmU9VAd25TppgQUjbBZzNaqQlXkxLBSPOAqjBmEfS1jynfT4U3TaBEyC7F7vC4Xnj74os3f+MUMOm0oZOTdB/2m/3ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242495; c=relaxed/simple;
	bh=OnqTrKnbSRDNhlsky/ZwQcuf2Q9SXaPy/5JsljNf9Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ki1nVqolfyLRdU9EU0cbHQCAmadf5VRAAM6mH0CGg3ucClnzfKGt083PT2Bi8QI3+pS5tNjpdbH+89s5D+sXwM7SZkft55yHQu/SWhnm1HsAb7XzuE24XkiicKdMXMrPaSO1OWA8RaeWL4+/zgkxjswCmI0qKqicFuhKWy9/lP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wS1wlliW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wS1wlliW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191F6C4CECF;
	Tue,  3 Dec 2024 16:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242495;
	bh=OnqTrKnbSRDNhlsky/ZwQcuf2Q9SXaPy/5JsljNf9Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wS1wlliWWsO1y8LXyMlyADFhS56/DJUOvZvkOibPSv0ksdqOFHw9cIvTT4sJjRgG0
	 UseEjQa0diM5UtUey3xSXRt9QSJ3X2eY2rZs3nEg7ehRpUvYDf3Q2sL6xUzLv4fKj6
	 fZSxV/A3DZzjyGuCs3nHKYWv7oAAcnxRPPYemJAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	stable <stable@kernel.org>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 6.12 690/826] Revert "serial: sh-sci: Clean sci_ports[0] after at earlycon exit"
Date: Tue,  3 Dec 2024 15:46:57 +0100
Message-ID: <20241203144810.672115383@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 718632467d88e98816fa01ab12681ef1c2aa56f8 upstream.

This reverts commit 3791ea69a4858b81e0277f695ca40f5aae40f312.

It was reported to cause boot-time issues, so revert it for now.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Fixes: 3791ea69a485 ("serial: sh-sci: Clean sci_ports[0] after at earlycon exit")
Cc: stable <stable@kernel.org>
Cc: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sh-sci.c |   28 ----------------------------
 1 file changed, 28 deletions(-)

--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -3535,32 +3535,6 @@ sh_early_platform_init_buffer("earlyprin
 #ifdef CONFIG_SERIAL_SH_SCI_EARLYCON
 static struct plat_sci_port port_cfg __initdata;
 
-static int early_console_exit(struct console *co)
-{
-	struct sci_port *sci_port = &sci_ports[0];
-	struct uart_port *port = &sci_port->port;
-	unsigned long flags;
-	int locked = 1;
-
-	if (port->sysrq)
-		locked = 0;
-	else if (oops_in_progress)
-		locked = uart_port_trylock_irqsave(port, &flags);
-	else
-		uart_port_lock_irqsave(port, &flags);
-
-	/*
-	 * Clean the slot used by earlycon. A new SCI device might
-	 * map to this slot.
-	 */
-	memset(sci_ports, 0, sizeof(*sci_port));
-
-	if (locked)
-		uart_port_unlock_irqrestore(port, flags);
-
-	return 0;
-}
-
 static int __init early_console_setup(struct earlycon_device *device,
 				      int type)
 {
@@ -3577,8 +3551,6 @@ static int __init early_console_setup(st
 		       SCSCR_RE | SCSCR_TE | port_cfg.scscr);
 
 	device->con->write = serial_console_write;
-	device->con->exit = early_console_exit;
-
 	return 0;
 }
 static int __init sci_early_console_setup(struct earlycon_device *device,


