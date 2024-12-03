Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73891F1313;
	Tue,  3 Dec 2024 14:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236761; cv=none; b=k+CqVrZmHXNDKMCMeTUgg/+XhA6fFzUtpsZLia0pn4GRh+i6K9rb+06wby+FHa7chWK481Gy20yJzonVAdO77CFiGiufx4g5FsucSvHMWOTCLiAjiG19JOfvJw0qqSOCn7c7E9SjKfKgu7fPL1Y301i4PKZD4My031JV1uT7VAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236761; c=relaxed/simple;
	bh=CHjICPKuyooT478r6YFMuuATdLm9LioPbkQwpjA6cWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KfCXfkYh9ZT2v2t2f/vrvc2zNcf5W1TEGRfYHIclH5hcn/Jc6me5n9rNE4s+Fye0ZYcpZ3bjNX/DJ3aW8ivf7znadejvbDtYF2JA+dhpffN35d6WLqoRiTWFM1sA+S3odQr8HOBM4o6iasbbsvwUSsqzoH89Fvx3RkeNb4xaCG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYk/x7Us; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYk/x7Us"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA009C4CECF;
	Tue,  3 Dec 2024 14:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236760;
	bh=CHjICPKuyooT478r6YFMuuATdLm9LioPbkQwpjA6cWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KYk/x7UsWkr6Ee0ThCEmYCH6R/uYLFSIj6tX3lhshesgafmECe0Ra4uBI0DiljlcO
	 tPfsMIUD9uFf/6IRM/HbULJpTpe/hoogHUOJps5u1NX5VDVC9Mm+pBdNZzBRsy5YvN
	 70F4lhX7HwgA3hJonpx0z0W7CT/Kb6J76FGCP+SI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	stable <stable@kernel.org>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 4.19 110/138] Revert "serial: sh-sci: Clean sci_ports[0] after at earlycon exit"
Date: Tue,  3 Dec 2024 15:32:19 +0100
Message-ID: <20241203141927.774970643@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3455,32 +3455,6 @@ early_platform_init_buffer("earlyprintk"
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
@@ -3499,8 +3473,6 @@ static int __init early_console_setup(st
 		       SCSCR_RE | SCSCR_TE | port_cfg.scscr);
 
 	device->con->write = serial_console_write;
-	device->con->exit = early_console_exit;
-
 	return 0;
 }
 static int __init sci_early_console_setup(struct earlycon_device *device,


