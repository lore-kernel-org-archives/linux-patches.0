Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BD78481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D88C433D2;
	Fri, 10 Mar 2023 14:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457511;
	bh=Na/UeYY5MDmE9VwrvDclgu0AGCWrjpu0E7eIISQvJ+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0R3cAa8tkQiA3tLP/mza//XyyB7cIsSPVb13s6JfpUG3l71MJvHAKEaQlAxx41lVg
	 IQO16T7VU1VPNe6y6QEZV8rRKYC7DNvK8WXmg6Yg16ZQRHtKzFTi2pzyhnu38lrAdK
	 uFjkA5ncp8NZjRkqMJDij8u9o03z/qyMsq4vGyEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Sun <sherry.sun@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 132/200] tty: serial: fsl_lpuart: disable the CTS when send break signal
Date: Fri, 10 Mar 2023 14:38:59 +0100
Message-Id: <20230310133721.175136637@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit c4c81db5cf8bc53d6160c3abf26d382c841aa434 ]

LPUART IP has a bug that it treats the CTS as higher priority than the
break signal, which cause the break signal sending through UARTCTRL_SBK
may impacted by the CTS input if the HW flow control is enabled.

Add this workaround patch to fix the IP bug, we can disable CTS before
asserting SBK to avoid any interference from CTS, and re-enable it when
break off.

Such as for the bluetooth chip power save feature, host can let the BT
chip get into sleep state by sending a UART break signal, and wake it up
by turning off the UART break. If the BT chip enters the sleep mode
successfully, it will pull up the CTS line, if the BT chip is woken up,
it will pull down the CTS line. If without this workaround patch, the
UART TX pin cannot send the break signal successfully as it affected by
the BT CTS pin. After adding this patch, the BT power save feature can
work well.

Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20221214031137.28815-2-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 13a6cd0116a13..f9d667ce1619e 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1468,12 +1468,32 @@ static void lpuart_break_ctl(struct uart_port *port, int break_state)
 
 static void lpuart32_break_ctl(struct uart_port *port, int break_state)
 {
-	unsigned long temp;
+	unsigned long temp, modem;
+	struct tty_struct *tty;
+	unsigned int cflag = 0;
+
+	tty = tty_port_tty_get(&port->state->port);
+	if (tty) {
+		cflag = tty->termios.c_cflag;
+		tty_kref_put(tty);
+	}
 
 	temp = lpuart32_read(port, UARTCTRL) & ~UARTCTRL_SBK;
+	modem = lpuart32_read(port, UARTMODIR);
 
-	if (break_state != 0)
+	if (break_state != 0) {
 		temp |= UARTCTRL_SBK;
+		/*
+		 * LPUART CTS has higher priority than SBK, need to disable CTS before
+		 * asserting SBK to avoid any interference if flow control is enabled.
+		 */
+		if (cflag & CRTSCTS && modem & UARTMODIR_TXCTSE)
+			lpuart32_write(port, modem & ~UARTMODIR_TXCTSE, UARTMODIR);
+	} else {
+		/* Re-enable the CTS when break off. */
+		if (cflag & CRTSCTS && !(modem & UARTMODIR_TXCTSE))
+			lpuart32_write(port, modem | UARTMODIR_TXCTSE, UARTMODIR);
+	}
 
 	lpuart32_write(port, temp, UARTCTRL);
 }
-- 
2.39.2



