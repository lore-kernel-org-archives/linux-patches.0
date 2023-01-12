Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99151749D
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164D4C433D2;
	Thu, 12 Jan 2023 14:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533059;
	bh=JgKe15jaV9shHN3aN5fip3zQtjObwCyaBdkTTFakv3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7AkElTSbIk7DBBjK8avsMaUKa0ZUrMis1XS/D6D8DXyv4voKOWL+Ds0SqbXlI+7B
	 s0piR8J9Tg1VixBnBfGlGPUFFrzp2W77sOREfKIYiCS2cZYW3vzM8MbQyGRuCN/hfn
	 OLP3oFsBu26bi8ekOWdYvwaS63Wvn4kJgvJ4NpDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Klauser <tklauser@distanz.ch>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jiri Slaby <jslaby@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 356/783] tty: serial: altera_uart_{r,t}x_chars() need only uart_port
Date: Thu, 12 Jan 2023 14:51:12 +0100
Message-Id: <20230112135540.841412061@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit 3af44d9bb0539d5fa27d6159d696fda5f3747bff ]

Both altera_uart_{r,t}x_chars() need only uart_port, not altera_uart. So
pass the former from altera_uart_interrupt() directly.

Apart it maybe saves a dereference, this makes the transition of
altera_uart_tx_chars() easier to follow in the next patch.

Cc: Tobias Klauser <tklauser@distanz.ch>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Acked-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20220920052049.20507-4-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 1307c5d33cce ("serial: altera_uart: fix locking in polling mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/altera_uart.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/altera_uart.c b/drivers/tty/serial/altera_uart.c
index 508a3c2b7781..20c610440133 100644
--- a/drivers/tty/serial/altera_uart.c
+++ b/drivers/tty/serial/altera_uart.c
@@ -199,9 +199,8 @@ static void altera_uart_set_termios(struct uart_port *port,
 	 */
 }
 
-static void altera_uart_rx_chars(struct altera_uart *pp)
+static void altera_uart_rx_chars(struct uart_port *port)
 {
-	struct uart_port *port = &pp->port;
 	unsigned char ch, flag;
 	unsigned short status;
 
@@ -248,9 +247,8 @@ static void altera_uart_rx_chars(struct altera_uart *pp)
 	spin_lock(&port->lock);
 }
 
-static void altera_uart_tx_chars(struct altera_uart *pp)
+static void altera_uart_tx_chars(struct uart_port *port)
 {
-	struct uart_port *port = &pp->port;
 	struct circ_buf *xmit = &port->state->xmit;
 
 	if (port->x_char) {
@@ -288,9 +286,9 @@ static irqreturn_t altera_uart_interrupt(int irq, void *data)
 
 	spin_lock(&port->lock);
 	if (isr & ALTERA_UART_STATUS_RRDY_MSK)
-		altera_uart_rx_chars(pp);
+		altera_uart_rx_chars(port);
 	if (isr & ALTERA_UART_STATUS_TRDY_MSK)
-		altera_uart_tx_chars(pp);
+		altera_uart_tx_chars(port);
 	spin_unlock(&port->lock);
 
 	return IRQ_RETVAL(isr);
-- 
2.35.1



