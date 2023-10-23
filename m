Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8332515492
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VAI20TRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010DCC433CC;
	Mon, 23 Oct 2023 11:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060255;
	bh=IPLBqCQu9Nh3SH9OJXc05Bq0HG/Cy33N8RSHEMCKdN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VAI20TRaxBEPlrGM98hCYg2k7/vZhb18GBF/pvzsx0+DGgWLrui3dt6jWmAwMfmUL
	 S7NiaJxSjaKask8ZrXLDBwD9JByUX+x+P/B4thWBRXJe3Nor3ai6Sf4zVhL0yWSObG
	 M94Bfofai36H7lJVpwFFyH9xuVuGJlBm+GE77KF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lino Sanfilippo <LinoSanfilippo@gmx.de>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/196] serial: Reduce spinlocked portion of uart_rs485_config()
Date: Mon, 23 Oct 2023 12:55:49 +0200
Message-ID: <20231023104830.919095730@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 8679328eb859d06a1984ab48d90ac35d11bbcaf1 ]

Commit 44b27aec9d96 ("serial: core, 8250: set RS485 termination GPIO in
serial core") enabled support for RS485 termination GPIOs behind i2c
expanders by setting the GPIO outside of the critical section protected
by the port spinlock.  Access to the i2c expander may sleep, which
caused a splat with the port spinlock held.

Commit 7c7f9bc986e6 ("serial: Deassert Transmit Enable on probe in
driver-specific way") erroneously regressed that by spinlocking the
GPIO manipulation again.

Fix by moving uart_rs485_config() (the function manipulating the GPIO)
outside of the spinlocked section and acquiring the spinlock inside of
uart_rs485_config() for the invocation of ->rs485_config() only.

This gets us one step closer to pushing the spinlock down into the
->rs485_config() callbacks which actually need it.  (Some callbacks
do not want to be spinlocked because they perform sleepable register
accesses, see e.g. sc16is7xx_config_rs485().)

Stack trace for posterity:

 Voluntary context switch within RCU read-side critical section!
 WARNING: CPU: 0 PID: 56 at kernel/rcu/tree_plugin.h:318 rcu_note_context_switch
 Call trace:
 rcu_note_context_switch
 __schedule
 schedule
 schedule_timeout
 wait_for_completion_timeout
 bcm2835_i2c_xfer
 __i2c_transfer
 i2c_transfer
 i2c_transfer_buffer_flags
 regmap_i2c_write
 _regmap_raw_write_impl
 _regmap_bus_raw_write
 _regmap_write
 _regmap_update_bits
 regmap_update_bits_base
 pca953x_gpio_set_value
 gpiod_set_raw_value_commit
 gpiod_set_value_nocheck
 gpiod_set_value_cansleep
 uart_rs485_config
 uart_add_one_port
 pl011_register_port
 pl011_probe

Fixes: 7c7f9bc986e6 ("serial: Deassert Transmit Enable on probe in driver-specific way")
Suggested-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v6.1+
Link: https://lore.kernel.org/r/f3a35967c28b32f3c6432d0aa5936e6a9908282d.1695307688.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 25972767129a3..d4e57f9017db9 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1387,12 +1387,18 @@ static void uart_set_rs485_termination(struct uart_port *port,
 static int uart_rs485_config(struct uart_port *port)
 {
 	struct serial_rs485 *rs485 = &port->rs485;
+	unsigned long flags;
 	int ret;
 
+	if (!(rs485->flags & SER_RS485_ENABLED))
+		return 0;
+
 	uart_sanitize_serial_rs485(port, rs485);
 	uart_set_rs485_termination(port, rs485);
 
+	spin_lock_irqsave(&port->lock, flags);
 	ret = port->rs485_config(port, NULL, rs485);
+	spin_unlock_irqrestore(&port->lock, flags);
 	if (ret)
 		memset(rs485, 0, sizeof(*rs485));
 
@@ -2455,11 +2461,10 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 			if (ret == 0) {
 				if (tty)
 					uart_change_line_settings(tty, state, NULL);
+				uart_rs485_config(uport);
 				spin_lock_irq(&uport->lock);
 				if (!(uport->rs485.flags & SER_RS485_ENABLED))
 					ops->set_mctrl(uport, uport->mctrl);
-				else
-					uart_rs485_config(uport);
 				ops->start_tx(uport);
 				spin_unlock_irq(&uport->lock);
 				tty_port_set_initialized(port, 1);
@@ -2568,10 +2573,10 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 		port->mctrl &= TIOCM_DTR;
 		if (!(port->rs485.flags & SER_RS485_ENABLED))
 			port->ops->set_mctrl(port, port->mctrl);
-		else
-			uart_rs485_config(port);
 		spin_unlock_irqrestore(&port->lock, flags);
 
+		uart_rs485_config(port);
+
 		/*
 		 * If this driver supports console, and it hasn't been
 		 * successfully registered yet, try to re-register it.
-- 
2.40.1



