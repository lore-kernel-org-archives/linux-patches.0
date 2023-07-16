Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1B38F6D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A4CC433C7;
	Sun, 16 Jul 2023 20:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538932;
	bh=C5bO7At461MhjZDtFoWWCzGB2FFFdsQt/fBJLeBaEFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JWbKspcWPwWyniya4qzk8XXEtmdrzpMKllY7iKrQuAcU+2aqSjyHViry1r+dMUp/A
	 8gXOTrXloDA3jlvsBK1So7B8/V07oemECkPJOitTdFGfok7QPwgG0COBcAAXNAGJDu
	 nwcvfA5fYG6WsUL3ngKUhPyckBZwZgvkOg+RtLp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 598/800] serial: 8250: lock port for UART_IER access in omap8250_irq()
Date: Sun, 16 Jul 2023 21:47:31 +0200
Message-ID: <20230716195002.992745140@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit 25614735a647693c1260f253dc3ab32127697806 ]

omap8250_irq() accesses UART_IER. This register is modified twice
by each console write (serial8250_console_write()) under the port
lock. omap8250_irq() must also take the port lock to guanentee
synchronized access to UART_IER.

Since the port lock is already being taken for the stop_rx() callback
and since it is safe to call cancel_delayed_work() while holding the
port lock, simply extend the port lock region to include UART_IER
access.

Fixes: 1fe0e1fa3209 ("serial: 8250_omap: Handle optional overrun-throttle-ms property")
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20230525093159.223817-8-john.ogness@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_omap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 05704d8c56566..0a90ddc0bdf66 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -649,17 +649,18 @@ static irqreturn_t omap8250_irq(int irq, void *dev_id)
 	if ((lsr & UART_LSR_OE) && up->overrun_backoff_time_ms > 0) {
 		unsigned long delay;
 
+		/* Synchronize UART_IER access against the console. */
+		spin_lock(&port->lock);
 		up->ier = port->serial_in(port, UART_IER);
 		if (up->ier & (UART_IER_RLSI | UART_IER_RDI)) {
-			spin_lock(&port->lock);
 			port->ops->stop_rx(port);
-			spin_unlock(&port->lock);
 		} else {
 			/* Keep restarting the timer until
 			 * the input overrun subsides.
 			 */
 			cancel_delayed_work(&up->overrun_backoff);
 		}
+		spin_unlock(&port->lock);
 
 		delay = msecs_to_jiffies(up->overrun_backoff_time_ms);
 		schedule_delayed_work(&up->overrun_backoff, delay);
-- 
2.39.2



