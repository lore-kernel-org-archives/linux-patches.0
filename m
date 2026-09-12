Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8654F288B2;
	Sat, 12 Sep 2026 10:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208630; cv=none; b=s15R3cbyPrmbHIOGfmcnnFZLv4DNn4oK2UevVKYHK1QbTEDcTI2rUGYpBKYGqgZ0+ith+JCJsQjWrFDcEeXLax3QglcimgLylOjop0LkfoubVHKAFVdGu669Ulx5N0CgAII0iDlltfrsr7ln8w8OSiHxfT8iDli5h21wrucJnwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208630; c=relaxed/simple;
	bh=zhJhm9BkBrVCTQ7fzyCPuy5zI++HnVbso3XoHxOpt/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWhJKFPC0Dy1jEfqClEPokp1ncK88cjZIAEoROxKrqcJP4SIRq5gVdWE25u+/VR89NDSc+AaYk7LMTwQLmwOj4spHYRAcCleBT8LioCxh3B7Cm42MslqlVT6xeJ2br/VByQR2uSrWeBYGPnVgF88awgJEcTcpXrrP5ei4PJ2c8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H3Cenbq6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H3Cenbq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED911F000FF;
	Sat, 12 Sep 2026 10:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208629;
	bh=V6uLj61Ct/00rkD5gGHFfepE7hgoEFlKdm06ZIc8W5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H3Cenbq66xkwAwzMxOYfXSPHoA26rwM2t//PGr0/rdaKO7QBEtBSZRnOqqFeZ99jZ
	 rKrMu1WHTHTIcV1N3K89OZU9woMpTcUUJ1xxMvignoE++FvWTzupA3xD06sG8Onn4J
	 X58FphMBGw/gIEg2bdFLAKwLpb8yvcTVkyEqKiX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	Fushuai Wang <wangfushuai@baidu.com>,
	John Ogness <john.ogness@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0657/1518] Revert "serial: 8250: Clear CON_PRINTBUFFER on port re-registration"
Date: Sat, 12 Sep 2026 08:47:06 +0200
Message-ID: <20260912065638.291153686@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fushuai Wang <wangfushuai@baidu.com>

[ Upstream commit 57c0741b8c15b93ba4aa92c6618cde6f3f4115b2 ]

This reverts commit d338ab1d90603f875c4f7ed223406535378173a5.

uart_console() only indicates that the port is selected as the console.
It does not mean that the console has already been registered or has
printed the buffered messages.

On platforms where an initial 8250 port is replaced when the real UART
device is registered, clearing CON_PRINTBUFFER causes the console to
start at the end of the printk ring buffer. Without earlycon, all
messages logged before UART registration are therefore lost.

Fixes: d338ab1d9060 ("serial: 8250: Clear CON_PRINTBUFFER on port re-registration")
Reported-by: Mark Brown <broonie@kernel.org>
Reported-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Link: https://lore.kernel.org/all/20260522101042.21976-1-fushuai.wang@linux.dev/
Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Link: https://patch.msgid.link/20260724093151.53216-1-fushuai.wang@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_core.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index b6568880f750d..ccd5a18f53356 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -716,12 +716,8 @@ int serial8250_register_8250_port(const struct uart_8250_port *up)
 	/* Preserve specified console flow control. */
 	cons_flow = uart_cons_flow_enabled(&uart->port);
 
-	if (uart->port.dev) {
-		if (uart_console(&uart->port))
-			uart->port.cons->flags &= ~CON_PRINTBUFFER;
-
+	if (uart->port.dev)
 		uart_remove_one_port(&serial8250_reg, &uart->port);
-	}
 
 	uart->port.ctrl_id	= up->port.ctrl_id;
 	uart->port.port_id	= up->port.port_id;
-- 
2.53.0



