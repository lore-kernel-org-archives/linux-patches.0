Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EF452F7C;
	Tue, 23 Jan 2024 00:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969918; cv=none; b=dc1xAoIDgFJYvhMNFxsXB+7HguoXTo+WCVM2HAzmSXJTQGT5RSGLIJPwJyxX8IjSLWK/0C+VWVBd8LT5iPgAvpCDlf13vxmbU5TSJvpjWcXDbWdEaQ2o5nx8I3aQLFbNVkoKOluwiTaYdFzOqnBBOe1szo7dmcnYEOW7ZBqobCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969918; c=relaxed/simple;
	bh=XHKgBQN5STb+Sk/8YSJ6T4llW7VhJxpCxYywqyS3GdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5rwUPxMfS1jgbFs+R11YS1i9+7BR/caBmzn8vETP4waTH2u1lwHGnnF9K8J03dzM0U/C8NXBX8g6ghwxKuOOZlS8uHasrX2V9HQGeAEgukpyf3UC0ic0rbE6s1nDfrH0/Qml15dGu7Lm4GHDp9IlbIr2UYd6fNHYXQlmFJydZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkcVbmoG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkcVbmoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D27C433C7;
	Tue, 23 Jan 2024 00:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969918;
	bh=XHKgBQN5STb+Sk/8YSJ6T4llW7VhJxpCxYywqyS3GdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkcVbmoGe+3SVDybHXeXOQX3R0wEnRqgjS4eRqCHo44oLRzPOYuxncEpkypGKEvTc
	 /a+APwVMk+3/i4xCKHGMLHQtS04BIE7jDyoaHhuo5M8sMCSUEm9jzZXSuvQwbe2/zK
	 WCz4dDIrFmLLVd9MVBhW8RdL/Dgnkmvs9dd8xHwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Geurts <paul_geurts@live.nl>,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
	Eberhard Stoll <eberhard.stoll@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 523/641] serial: imx: fix tx statemachine deadlock
Date: Mon, 22 Jan 2024 15:57:07 -0800
Message-ID: <20240122235834.452698591@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Geurts <paul_geurts@live.nl>

[ Upstream commit 78d60dae9a0c9f09aa3d6477c94047df2fe6f7b0 ]

When using the serial port as RS485 port, the tx statemachine is used to
control the RTS pin to drive the RS485 transceiver TX_EN pin. When the
TTY port is closed in the middle of a transmission (for instance during
userland application crash), imx_uart_shutdown disables the interface
and disables the Transmission Complete interrupt. afer that,
imx_uart_stop_tx bails on an incomplete transmission, to be retriggered
by the TC interrupt. This interrupt is disabled and therefore the tx
statemachine never transitions out of SEND. The statemachine is in
deadlock now, and the TX_EN remains low, making the interface useless.

imx_uart_stop_tx now checks for incomplete transmission AND whether TC
interrupts are enabled before bailing to be retriggered. This makes sure
the state machine handling is reached, and is properly set to
WAIT_AFTER_SEND.

Fixes: cb1a60923609 ("serial: imx: implement rts delaying for rs485")
Signed-off-by: Paul Geurts <paul_geurts@live.nl>
Tested-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Tested-by: Eberhard Stoll <eberhard.stoll@gmx.de>
Link: https://lore.kernel.org/r/AM0PR09MB26758F651BC1B742EB45775995B8A@AM0PR09MB2675.eurprd09.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/imx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 4cecc097408e..16207b9a8c81 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -415,13 +415,13 @@ static void imx_uart_stop_tx(struct uart_port *port)
 	ucr1 = imx_uart_readl(sport, UCR1);
 	imx_uart_writel(sport, ucr1 & ~UCR1_TRDYEN, UCR1);
 
+	ucr4 = imx_uart_readl(sport, UCR4);
 	usr2 = imx_uart_readl(sport, USR2);
-	if (!(usr2 & USR2_TXDC)) {
+	if ((!(usr2 & USR2_TXDC)) && (ucr4 & UCR4_TCEN)) {
 		/* The shifter is still busy, so retry once TC triggers */
 		return;
 	}
 
-	ucr4 = imx_uart_readl(sport, UCR4);
 	ucr4 &= ~UCR4_TCEN;
 	imx_uart_writel(sport, ucr4, UCR4);
 
-- 
2.43.0



