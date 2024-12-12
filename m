Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACC92253E0;
	Thu, 12 Dec 2024 17:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022857; cv=none; b=LX/uwCO2baYtQjgD6SBJZvBkWndLivfMQu3PN+SjZ+k8MaDEhX7A+6U+rUNjiDtbyK466X6vimDIbn3vOXiDzYY97YWEzMqxv9CTZhfTJxFOOyEkdaiviQr9wpIYSvvsRNezMsbPxwUAKDUCO5MNYKwv38mHT3xI8nG/ZjLPySg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022857; c=relaxed/simple;
	bh=t1y+78AIHiikiLHWVFOQ28auUGwELy51azDLRRQusCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obKzF7OMbXgFTZDpQmp3BWT0NzRSnuJsAEhhs21yP5EMyA1HpnMseru+v04xbEqkGT7vJJ53OgsE0yEKFnwOGJxvUbUV5Q5GxR0C442PbWofaqHf8mlBhvo/l1e+NvjGfgN9TgJjwjMFw+tEp5Cg3B5YWM7AuepUOTkwN1bKwPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L04/Wi8L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L04/Wi8L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DB1C4CED3;
	Thu, 12 Dec 2024 17:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022857;
	bh=t1y+78AIHiikiLHWVFOQ28auUGwELy51azDLRRQusCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L04/Wi8LkoSHtk6cb736TuggrRbZcP3u9V0TZmkCxdXgGSL4vPYVU/Id9GW/TmNp6
	 OpN4BKvmGtsNAc05qjNkMgpDMaAyuIElrNF4GOhFEpym1urCBHoptIIjgFd0sQWza6
	 Mq1GtR3AXSSupJaYpnHR5XTeAIz1Osp9SR/2J/KA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	stable <stable@kernel.org>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 5.15 324/565] Revert "serial: sh-sci: Clean sci_ports[0] after at earlycon exit"
Date: Thu, 12 Dec 2024 15:58:39 +0100
Message-ID: <20241212144324.408737326@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3433,32 +3433,6 @@ sh_early_platform_init_buffer("earlyprin
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
@@ -3477,8 +3451,6 @@ static int __init early_console_setup(st
 		       SCSCR_RE | SCSCR_TE | port_cfg.scscr);
 
 	device->con->write = serial_console_write;
-	device->con->exit = early_console_exit;
-
 	return 0;
 }
 static int __init sci_early_console_setup(struct earlycon_device *device,


