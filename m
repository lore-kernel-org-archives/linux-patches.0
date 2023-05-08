Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E672915
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E74C433D2;
	Mon,  8 May 2023 10:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542460;
	bh=IRyQu29DKveqSSXFJYiUaxU4ytSJNcTUQalz8NB8ZAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0hZz+Sqa3NFkCG25W+Fh95LKk/Pwh/ctl3AOFmwRxljh2UTLBeRSa0VURSzQypXGe
	 k+DymnxEMuC4wom4lKUxatWp+4kJK8D8lYxgCx7cw5/c+T6mATTxRUjqNM0bQNkIGm
	 7zgVfJL6Xa8nD7N3cwQjlArc7PZ3qzwi/GO8xr+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 442/663] serial: stm32: Re-assert RTS/DE GPIO in RS485 mode only if more data are transmitted
Date: Mon,  8 May 2023 11:44:28 +0200
Message-Id: <20230508094442.414830462@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marex@denx.de>

[ Upstream commit c47527cbcc3c50800f34b8c684f29721f75de246 ]

The stm32_usart_transmit_chars() may be called with empty or stopped
transmit queue, and no XON/OFF character pending. This can happen at
the end of transmission, where this last call is used to either handle
the XON/XOFF x_char, or disable TX interrupt if queue is empty or
stopped.

If that occurs, do not assert the RS485 RTS/DE GPIO anymore, as the
GPIO would remain asserted past the end of transmission and that would
block the RS485 bus after the transmission.

Only assert the RS485 RTS/DE GPIO if there is either pending XON/XOFF
x_char, or at least one character in running transmit queue.

Fixes: d7c76716169d ("serial: stm32: Use TC interrupt to deassert GPIO RTS in RS485 mode")
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20230223042252.95480-2-marex@denx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 409e91d6829a5..81a53cc41dcb8 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -689,8 +689,9 @@ static void stm32_usart_transmit_chars(struct uart_port *port)
 	int ret;
 
 	if (!stm32_port->hw_flow_control &&
-	    port->rs485.flags & SER_RS485_ENABLED) {
-		stm32_port->txdone = false;
+	    port->rs485.flags & SER_RS485_ENABLED &&
+	    (port->x_char ||
+	     !(uart_circ_empty(xmit) || uart_tx_stopped(port)))) {
 		stm32_usart_tc_interrupt_disable(port);
 		stm32_usart_rs485_rts_enable(port);
 	}
-- 
2.39.2



