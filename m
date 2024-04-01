Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FC2481D5;
	Mon,  1 Apr 2024 15:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986822; cv=none; b=lxvxyoNXjjr3V1VdkxK/fh0+V9gpg/iNC31KZhYBwFRLTob44WS9ZWCo94F0iYQ+tjQMsjqNrmCAnOAW6FgT9IB7wh1yKrf11U4+Nc0UYrlJU9s4/vIkHKMYA4YS6QVDQLlCDBtNz/wvADHMoooi8d0lKOrcjZwd3Tq51uwtLCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986822; c=relaxed/simple;
	bh=8Noye3CG/qbK0iqC8lzQGFe1NoWyCrIfQNeZ7EV+LsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXSiRObc8fj7m+VgL6NGe2jNKlatyLJcdhf2v0JVTjUjUid6KgAGU6Vy028vU6i9z/foAjNHcKgYIbpMPWpfY4EScxNGGHEqY1oYoYq9qEqOFnGXh90zIZCd4RUZf+5voUIisrQ+5+7QiiMm01jQrFTPWpHptdT6Z5/QJIlixRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VU3BOZJG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VU3BOZJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6C5C433C7;
	Mon,  1 Apr 2024 15:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986822;
	bh=8Noye3CG/qbK0iqC8lzQGFe1NoWyCrIfQNeZ7EV+LsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VU3BOZJGG54BWjhArd0fjzWzfpvjU1MeKSQL78NJ6nIXI9lXawu+hhz0l5M7bmJu9
	 xA6Rwnux5H900uLlC/82wR/ZGGsd6TP20ScjtYmEZRInKkhmKI60rRRHerdS4Zy59W
	 gTor90h6lB6Ntr8AmHiPvkqP8C60biW2Ja2f5qW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Collingbourne <pcc@google.com>,
	John Ogness <john.ogness@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 095/399] serial: Lock console when calling into driver before registration
Date: Mon,  1 Apr 2024 17:41:01 +0200
Message-ID: <20240401152552.019815558@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Collingbourne <pcc@google.com>

[ Upstream commit 801410b26a0e8b8a16f7915b2b55c9528b69ca87 ]

During the handoff from earlycon to the real console driver, we have
two separate drivers operating on the same device concurrently. In the
case of the 8250 driver these concurrent accesses cause problems due
to the driver's use of banked registers, controlled by LCR.DLAB. It is
possible for the setup(), config_port(), pm() and set_mctrl() callbacks
to set DLAB, which can cause the earlycon code that intends to access
TX to instead access DLL, leading to missed output and corruption on
the serial line due to unintended modifications to the baud rate.

In particular, for setup() we have:

univ8250_console_setup()
-> serial8250_console_setup()
-> uart_set_options()
-> serial8250_set_termios()
-> serial8250_do_set_termios()
-> serial8250_do_set_divisor()

For config_port() we have:

serial8250_config_port()
-> autoconfig()

For pm() we have:

serial8250_pm()
-> serial8250_do_pm()
-> serial8250_set_sleep()

For set_mctrl() we have (for some devices):

serial8250_set_mctrl()
-> omap8250_set_mctrl()
-> __omap8250_set_mctrl()

To avoid such problems, let's make it so that the console is locked
during pre-registration calls to these callbacks, which will prevent
the earlycon driver from running concurrently.

Remove the partial solution to this problem in the 8250 driver
that locked the console only during autoconfig_irq(), as this would
result in a deadlock with the new approach. The console continues
to be locked during autoconfig_irq() because it can only be called
through uart_configure_port().

Although this patch introduces more locking than strictly necessary
(and in particular it also locks during the call to rs485_config()
which is not affected by this issue as far as I can tell), it follows
the principle that it is the responsibility of the generic console
code to manage the earlycon handoff by ensuring that earlycon and real
console driver code cannot run concurrently, and not the individual
drivers.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Link: https://linux-review.googlesource.com/id/I7cf8124dcebf8618e6b2ee543fa5b25532de55d8
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240304214350.501253-1-pcc@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_port.c |  6 ------
 drivers/tty/serial/serial_core.c    | 12 ++++++++++++
 kernel/printk/printk.c              | 21 ++++++++++++++++++---
 3 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 8ca061d3bbb92..1d65055dde276 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1329,9 +1329,6 @@ static void autoconfig_irq(struct uart_8250_port *up)
 		inb_p(ICP);
 	}
 
-	if (uart_console(port))
-		console_lock();
-
 	/* forget possible initially masked and pending IRQ */
 	probe_irq_off(probe_irq_on());
 	save_mcr = serial8250_in_MCR(up);
@@ -1371,9 +1368,6 @@ static void autoconfig_irq(struct uart_8250_port *up)
 	if (port->flags & UPF_FOURPORT)
 		outb_p(save_ICP, ICP);
 
-	if (uart_console(port))
-		console_unlock();
-
 	port->irq = (irq > 0) ? irq : 0;
 }
 
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index d6a58a9e072a1..ff85ebd3a007d 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2608,7 +2608,12 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 			port->type = PORT_UNKNOWN;
 			flags |= UART_CONFIG_TYPE;
 		}
+		/* Synchronize with possible boot console. */
+		if (uart_console(port))
+			console_lock();
 		port->ops->config_port(port, flags);
+		if (uart_console(port))
+			console_unlock();
 	}
 
 	if (port->type != PORT_UNKNOWN) {
@@ -2616,6 +2621,10 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 
 		uart_report_port(drv, port);
 
+		/* Synchronize with possible boot console. */
+		if (uart_console(port))
+			console_lock();
+
 		/* Power up port for set_mctrl() */
 		uart_change_pm(state, UART_PM_STATE_ON);
 
@@ -2632,6 +2641,9 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 
 		uart_rs485_config(port);
 
+		if (uart_console(port))
+			console_unlock();
+
 		/*
 		 * If this driver supports console, and it hasn't been
 		 * successfully registered yet, try to re-register it.
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 72f6a564e832f..a11e1b6f29c04 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3295,6 +3295,21 @@ static int __init keep_bootcon_setup(char *str)
 
 early_param("keep_bootcon", keep_bootcon_setup);
 
+static int console_call_setup(struct console *newcon, char *options)
+{
+	int err;
+
+	if (!newcon->setup)
+		return 0;
+
+	/* Synchronize with possible boot console. */
+	console_lock();
+	err = newcon->setup(newcon, options);
+	console_unlock();
+
+	return err;
+}
+
 /*
  * This is called by register_console() to try to match
  * the newly registered console with any of the ones selected
@@ -3330,8 +3345,8 @@ static int try_enable_preferred_console(struct console *newcon,
 			if (_braille_register_console(newcon, c))
 				return 0;
 
-			if (newcon->setup &&
-			    (err = newcon->setup(newcon, c->options)) != 0)
+			err = console_call_setup(newcon, c->options);
+			if (err)
 				return err;
 		}
 		newcon->flags |= CON_ENABLED;
@@ -3357,7 +3372,7 @@ static void try_enable_default_console(struct console *newcon)
 	if (newcon->index < 0)
 		newcon->index = 0;
 
-	if (newcon->setup && newcon->setup(newcon, NULL) != 0)
+	if (console_call_setup(newcon, NULL) != 0)
 		return;
 
 	newcon->flags |= CON_ENABLED;
-- 
2.43.0



