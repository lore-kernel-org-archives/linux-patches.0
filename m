Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A79734A77D;
	Tue, 16 Dec 2025 11:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885206; cv=none; b=tnTezsOOBGnhKZoXP+gJ1NBmhox2u5dnFs0CHSBIfU+D2s+uBrNEXcnH1JDcPdMJiV/WN0QlurD6FTty2jPNuUWs1qcI2SZ0U34YtLRiTgMSF9CFw8hZH9QzPPoPsXN7o4FxPpVNj4E8OCKzPXf2T6gbftulXHnIk/71gf26TVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885206; c=relaxed/simple;
	bh=otH6QjS8pSLgoOtX20j3PVGAvlA9A8LUP4vbPdkAM5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6/erCqYqJyw1edNkAyxliUaKTQlKhky8EpHPns7BJ1g7ywl1j2ekBqO9HcAqVMbZI3xC65wcvpHQPFxN/6ufkpTberzoU3Us4WtDW8/GNqJ+pRUZIxcihiQcCxNw9OQBuuE62zq9Ni61SU6JlqYqDAebM9PLw+cs6v0AMaW7cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKNF9LGZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKNF9LGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29359C16AAE;
	Tue, 16 Dec 2025 11:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885205;
	bh=otH6QjS8pSLgoOtX20j3PVGAvlA9A8LUP4vbPdkAM5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKNF9LGZBmSV2rVMV65UMhcHbDL4tUjJwAvw34BPRrJuI9s43+oLR9GxUCPYS1qij
	 4hMsgctpXDcucJphtaq0I4HP1hs2VPTp7TPMEnsCeC4L7pQ7q6eT/ipcf36YM0msJh
	 n6xPtxCSBdL6KGnoW6qTAo2b6TB/uKlYlUqjEWvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Sun <sherry.sun@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 070/507] tty: serial: imx: Only configure the wake register when device is set as wakeup source
Date: Tue, 16 Dec 2025 12:08:31 +0100
Message-ID: <20251216111348.079136334@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit d55f3d2375ceeb08330d30f1e08196993c0b6583 ]

Currently, the i.MX UART driver enables wake-related registers for all
UART devices by default. However, this is unnecessary for devices that
are not configured as wakeup sources. To address this, add a
device_may_wakeup() check before configuring the UART wake-related
registers.

Fixes: db1a9b55004c ("tty: serial: imx: Allow UART to be a source for wakeup")
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20251002045259.2725461-2-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/imx.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 500dfc009d03e..90e2ea1e8afe5 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -2697,8 +2697,22 @@ static void imx_uart_save_context(struct imx_port *sport)
 /* called with irq off */
 static void imx_uart_enable_wakeup(struct imx_port *sport, bool on)
 {
+	struct tty_port *port = &sport->port.state->port;
+	struct device *tty_dev;
+	bool may_wake = false;
 	u32 ucr3;
 
+	scoped_guard(tty_port_tty, port) {
+		struct tty_struct *tty = scoped_tty();
+
+		tty_dev = tty->dev;
+		may_wake = tty_dev && device_may_wakeup(tty_dev);
+	}
+
+	/* only configure the wake register when device set as wakeup source */
+	if (!may_wake)
+		return;
+
 	uart_port_lock_irq(&sport->port);
 
 	ucr3 = imx_uart_readl(sport, UCR3);
-- 
2.51.0



