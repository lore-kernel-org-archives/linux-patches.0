Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBF415218A;
	Tue,  2 Jul 2024 17:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941068; cv=none; b=SxnjVayoHvzuFktTR5Ff/zFeaJr8kh3evGXnuMdQbDqtpJWayl5sIcVB0LRDYsyBw9lXk+MuVIo+OMBshhlHlit1AIHngX+JJFhQXc26CZHcLqC75DEiX+F72ToWBruhcmTYHKbKLOK2Imw/v7n4dxVGMe1D5qRM/8TyoiWoDy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941068; c=relaxed/simple;
	bh=5ZN5bG/OkC/Iw5d4FnPpbjpMssh6Bg0QeSUEYq00c80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O86YFBHS8pnvd54LA+WZVVIBuazy6eL1ywFV1K4AgSz8ntbhVaizIiy+86tJRcbp1YgRqGczhgip20j2XBRjxmp8UZUAmeWDNf4u6Oo63MxkHJBau93ypMo/CRPy/D2TkRHWF65sWZ3fzqN5qr5d3DvlEf3m9A+vEJqJHTWEq7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4jhXxO7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4jhXxO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B03C116B1;
	Tue,  2 Jul 2024 17:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941068;
	bh=5ZN5bG/OkC/Iw5d4FnPpbjpMssh6Bg0QeSUEYq00c80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y4jhXxO7WsJ/Y3hD47quqzE54aZ1/t7S5KrBWft9tNoAvCi0pAtSTOF2RRwoaem2C
	 KfcShYSATX21UJhqtQKhmsAXju14jeyMSk6MAlIAeA0Jung4KcnVU6doRFjtU/BnJf
	 DKkChlzduCg/jKAys3Mwdxj1RKh3DsJRqxrj2Lm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Doug Brown <doug@schmorgal.com>
Subject: [PATCH 6.6 119/163] serial: bcm63xx-uart: fix tx after conversion to uart_port_tx_limited()
Date: Tue,  2 Jul 2024 19:03:53 +0200
Message-ID: <20240702170237.558358364@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

From: Jonas Gorski <jonas.gorski@gmail.com>

commit ea55c65dedf40e9c1911dc1e63e26bc9a59692b9 upstream.

When bcm63xx-uart was converted to uart_port_tx_limited(), it implicitly
added a call to stop_tx(). This causes garbage to be put out on the
serial console. To fix this, pass UART_TX_NOSTOP in flags, and manually
call stop_tx() ourselves analogue to how a similar issue was fixed in
commit 7be50f2e8f20 ("serial: mxs-auart: fix tx").

Fixes: d11cc8c3c4b6 ("tty: serial: use uart_port_tx_limited()")
Cc: stable@vger.kernel.org
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Signed-off-by: Doug Brown <doug@schmorgal.com>
Link: https://lore.kernel.org/r/20240606195632.173255-4-doug@schmorgal.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/bcm63xx_uart.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/bcm63xx_uart.c
+++ b/drivers/tty/serial/bcm63xx_uart.c
@@ -309,8 +309,8 @@ static void bcm_uart_do_tx(struct uart_p
 
 	val = bcm_uart_readl(port, UART_MCTL_REG);
 	val = (val & UART_MCTL_TXFIFOFILL_MASK) >> UART_MCTL_TXFIFOFILL_SHIFT;
-
-	pending = uart_port_tx_limited(port, ch, port->fifosize - val,
+	pending = uart_port_tx_limited_flags(port, ch, UART_TX_NOSTOP,
+		port->fifosize - val,
 		true,
 		bcm_uart_writel(port, ch, UART_FIFO_REG),
 		({}));
@@ -321,6 +321,9 @@ static void bcm_uart_do_tx(struct uart_p
 	val = bcm_uart_readl(port, UART_IR_REG);
 	val &= ~UART_TX_INT_MASK;
 	bcm_uart_writel(port, val, UART_IR_REG);
+
+	if (uart_tx_stopped(port))
+		bcm_uart_stop_tx(port);
 }
 
 /*


