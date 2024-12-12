Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7164F2144C4;
	Thu, 12 Dec 2024 17:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024336; cv=none; b=AHttsCyeHZk0kjcixkVEUbbNa7zEsIGj/Y2fdYIwI3qsiYjuI3LkNna/Lh59Snp0OvZIzm3HsO5PF4fIdcYIYC9iy49bNN+qe26SobQ+iNeA10ph4jgW86SqCVbNpfvcPnnMbdGuni//ssLDoQiIh45wRZw7jYmrf2nyPuIi2JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024336; c=relaxed/simple;
	bh=+CgvA/J8OfwgXVCWHKYKsI6kPJk72AeYbjszlezCu6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qBwgAbjBlLPXsqFDPxEIRoUPIUZLTDV/fxQFLYCUlO6kAp1YLDwUBBbQNW5+zC369TZb1NOak1nyT8cjGjCcqrb33OM+cg4l+k8sIljO7NaajZ3OJwlljGrheSPjVvK2KSpIY22wsWRd/yThYrzZ/3Ahv+9Lbk8shPjO+QxUxLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x0Ij8k0C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x0Ij8k0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9DEEC4CECE;
	Thu, 12 Dec 2024 17:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024336;
	bh=+CgvA/J8OfwgXVCWHKYKsI6kPJk72AeYbjszlezCu6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x0Ij8k0C4beeLRpTEpyEIDTtFm/DKVDH0AY5IO3c2VdfV9BHzeO8DVWJwJnYJHc0M
	 0gR9TuTyioRgxncVaBr4N4kDgmgAhYQ3dCSoDFp5EBD8ZgXrOqdW5/trSDdCW0+Aqq
	 977m3QeXSwcov/SLz377leILw1ayNBP9MFDBnkIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	stable <stable@kernel.org>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 5.10 263/459] Revert "serial: sh-sci: Clean sci_ports[0] after at earlycon exit"
Date: Thu, 12 Dec 2024 16:00:01 +0100
Message-ID: <20241212144303.991122665@linuxfoundation.org>
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
@@ -3457,32 +3457,6 @@ sh_early_platform_init_buffer("earlyprin
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
@@ -3501,8 +3475,6 @@ static int __init early_console_setup(st
 		       SCSCR_RE | SCSCR_TE | port_cfg.scscr);
 
 	device->con->write = serial_console_write;
-	device->con->exit = early_console_exit;
-
 	return 0;
 }
 static int __init sci_early_console_setup(struct earlycon_device *device,


