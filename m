Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8F71448D4;
	Tue, 23 Apr 2024 21:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908633; cv=none; b=jPBQt3R3M85htaNGalm7TwM9uHAGAdzRda7eMzYo7krmwXwo4+pHlN3zYcpy3xnWgZ2P70baZFWW1a7o3EjcSFvBC6Vz1/GjcM4+KYCU0nCIcifzzWl2v11Af6U+/o+eTCz5AQ/Kj2IlzwN2YzdGAtQ2F6Om+TKsQCez1gCDxf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908633; c=relaxed/simple;
	bh=Qow1x6YmDcIRywu2ZS8XKkwIRKWFh7LLY6NaOqz6zbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCIHs/X41g8igwr+k9SO/ElJxgAbxGnni8YIScH1A31B+U8e1eZYHvo7QQDaDubVMHO9opUCjX8H2Ce5GYl9pMwQb4lO4aioKNw/e4AoCOwd/VItX9ai6ARBU6gST5Hjsm1G6/Ma6rsuFoL9IQFSqvUHAfdQcOmDHSV7fY69Hc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GRn+9qWh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GRn+9qWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962F9C116B1;
	Tue, 23 Apr 2024 21:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908633;
	bh=Qow1x6YmDcIRywu2ZS8XKkwIRKWFh7LLY6NaOqz6zbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GRn+9qWhSmhXAk3UQNEB4zUId1E6FAbSijyGPMKxFN70wBd0x2xslSY0dUUhLV15m
	 c7nGxMAtkwlAj1OXCZobgUtLgT4Y8yRoqr73pygu0kTmTP9GufwkWqj9Y+jU43VjCK
	 tkP26ywwtO6OXck952qofd91aWez/4Pe4kMqSrmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Tony Lindgren <tony@atomide.com>
Subject: [PATCH 6.6 114/158] serial: core: Fix missing shutdown and startup for serial base port
Date: Tue, 23 Apr 2024 14:39:11 -0700
Message-ID: <20240423213859.446389490@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

From: Tony Lindgren <tony@atomide.com>

commit 1aa4ad4eb695bac1b0a7ba542a16d6833c9c8dd8 upstream.

We are seeing start_tx being called after port shutdown as noted by Jiri.
This happens because we are missing the startup and shutdown related
functions for the serial base port.

Let's fix the issue by adding startup and shutdown functions for the
serial base port to block tx flushing for the serial base port when the
port is not in use.

Fixes: 84a9582fd203 ("serial: core: Start managing serial controllers to enable runtime PM")
Cc: stable <stable@kernel.org>
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20240411055848.38190-1-tony@atomide.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_base.h |    4 ++++
 drivers/tty/serial/serial_core.c |   20 +++++++++++++++++---
 drivers/tty/serial/serial_port.c |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/serial_base.h
+++ b/drivers/tty/serial/serial_base.h
@@ -22,6 +22,7 @@ struct serial_ctrl_device {
 struct serial_port_device {
 	struct device dev;
 	struct uart_port *port;
+	unsigned int tx_enabled:1;
 };
 
 int serial_base_ctrl_init(void);
@@ -30,6 +31,9 @@ void serial_base_ctrl_exit(void);
 int serial_base_port_init(void);
 void serial_base_port_exit(void);
 
+void serial_base_port_startup(struct uart_port *port);
+void serial_base_port_shutdown(struct uart_port *port);
+
 int serial_base_driver_register(struct device_driver *driver);
 void serial_base_driver_unregister(struct device_driver *driver);
 
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -323,16 +323,26 @@ static int uart_startup(struct tty_struc
 			bool init_hw)
 {
 	struct tty_port *port = &state->port;
+	struct uart_port *uport;
 	int retval;
 
 	if (tty_port_initialized(port))
-		return 0;
+		goto out_base_port_startup;
 
 	retval = uart_port_startup(tty, state, init_hw);
-	if (retval)
+	if (retval) {
 		set_bit(TTY_IO_ERROR, &tty->flags);
+		return retval;
+	}
 
-	return retval;
+out_base_port_startup:
+	uport = uart_port_check(state);
+	if (!uport)
+		return -EIO;
+
+	serial_base_port_startup(uport);
+
+	return 0;
 }
 
 /*
@@ -355,6 +365,9 @@ static void uart_shutdown(struct tty_str
 	if (tty)
 		set_bit(TTY_IO_ERROR, &tty->flags);
 
+	if (uport)
+		serial_base_port_shutdown(uport);
+
 	if (tty_port_initialized(port)) {
 		tty_port_set_initialized(port, false);
 
@@ -1769,6 +1782,7 @@ static void uart_tty_port_shutdown(struc
 	uport->ops->stop_rx(uport);
 	spin_unlock_irq(&uport->lock);
 
+	serial_base_port_shutdown(uport);
 	uart_port_shutdown(port);
 
 	/*
--- a/drivers/tty/serial/serial_port.c
+++ b/drivers/tty/serial/serial_port.c
@@ -36,8 +36,12 @@ static int serial_port_runtime_resume(st
 
 	/* Flush any pending TX for the port */
 	spin_lock_irqsave(&port->lock, flags);
+	if (!port_dev->tx_enabled)
+		goto unlock;
 	if (__serial_port_busy(port))
 		port->ops->start_tx(port);
+
+unlock:
 	spin_unlock_irqrestore(&port->lock, flags);
 
 out:
@@ -57,6 +61,11 @@ static int serial_port_runtime_suspend(s
 		return 0;
 
 	uart_port_lock_irqsave(port, &flags);
+	if (!port_dev->tx_enabled) {
+		uart_port_unlock_irqrestore(port, flags);
+		return 0;
+	}
+
 	busy = __serial_port_busy(port);
 	if (busy)
 		port->ops->start_tx(port);
@@ -68,6 +77,31 @@ static int serial_port_runtime_suspend(s
 	return busy ? -EBUSY : 0;
 }
 
+static void serial_base_port_set_tx(struct uart_port *port,
+				    struct serial_port_device *port_dev,
+				    bool enabled)
+{
+	unsigned long flags;
+
+	uart_port_lock_irqsave(port, &flags);
+	port_dev->tx_enabled = enabled;
+	uart_port_unlock_irqrestore(port, flags);
+}
+
+void serial_base_port_startup(struct uart_port *port)
+{
+	struct serial_port_device *port_dev = port->port_dev;
+
+	serial_base_port_set_tx(port, port_dev, true);
+}
+
+void serial_base_port_shutdown(struct uart_port *port)
+{
+	struct serial_port_device *port_dev = port->port_dev;
+
+	serial_base_port_set_tx(port, port_dev, false);
+}
+
 static DEFINE_RUNTIME_DEV_PM_OPS(serial_port_pm,
 				 serial_port_runtime_suspend,
 				 serial_port_runtime_resume, NULL);


