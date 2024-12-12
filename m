Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915E120969B;
	Thu, 12 Dec 2024 16:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020248; cv=none; b=Zu48AY0y8fSUVTV/2nqK4YqMUF25lb4aHbkf7Z2vu7eYgiRFyDKRVNTb8oz+PdXrFKnGZfQLr1kgN1KBNM83ALV6h3TlZYqW87AySj6WqdcL+bjyzG2Ohnc6VQ1+gyP6soiq0hA8+lDuUKf0iallxDJ3RX19/vW5bPlZBZ8p2g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020248; c=relaxed/simple;
	bh=KWnqwK5IGJOf38hHWNQGTs2O46JvLDarOBRNoB43KPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAWH4B33zreiEO3hCxq1O1G9TUQQ3PWwSrP8spADf6pJonfLXeFSgxd/BDfX7yMlQyuGCGVttGdCAer2iHZUdYv1UAiA9ytQapz7nRYrSPur/x9Gn4J9X5idMf9aTQC3l++bd5HBvgxhsW06zzAMAW3I55WjXIbATGC0CXxkxNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qcujszdl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qcujszdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1AA0C4CECE;
	Thu, 12 Dec 2024 16:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020248;
	bh=KWnqwK5IGJOf38hHWNQGTs2O46JvLDarOBRNoB43KPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QcujszdlDNfU7CCNlno0uRvZ9OZ/L1T8MxTHsl+ilpwFnWHmanFK4o0TsMY2K4asm
	 QOrw8JLRMqwKsR5b9CdmsGI/TGTpzfY0HO9lmCTHDuNStZa85zoWLU4X71ssd1H1C4
	 NW0oFthcIaXVtmnUWNgrTez7+yY1utdBeGEaxNc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	stable <stable@kernel.org>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 6.1 389/772] Revert "serial: sh-sci: Clean sci_ports[0] after at earlycon exit"
Date: Thu, 12 Dec 2024 15:55:34 +0100
Message-ID: <20241212144405.981234171@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3432,32 +3432,6 @@ sh_early_platform_init_buffer("earlyprin
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
@@ -3476,8 +3450,6 @@ static int __init early_console_setup(st
 		       SCSCR_RE | SCSCR_TE | port_cfg.scscr);
 
 	device->con->write = serial_console_write;
-	device->con->exit = early_console_exit;
-
 	return 0;
 }
 static int __init sci_early_console_setup(struct earlycon_device *device,


