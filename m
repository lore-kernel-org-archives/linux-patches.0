Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E77114389E;
	Tue, 23 Apr 2024 21:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908520; cv=none; b=sMznKWOPOhq4oYMIyJ0MOuKYJLcGUmh3wVUoYGZXeoyCRq4A1Vs0ygXN3vWF+MkThCzMN8lQWFvVV5m6DnYLYXUOYAVPNR03DZ/M2RqGD1+9NUpFiBWxxRPfE3z3O7J/QQKsvtW1ntWh7ygl83l9GkDck7AOZ8EOs6iqDbwmZMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908520; c=relaxed/simple;
	bh=2qUZBFW6oigOqBK/umkhlGzl65EOwNzAdPmfX9REKsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhVC7TnB6l2RhnlTrJNFmqVzopsXAj42blihnBv3FBKIHp3DV/ED80l5v7A15LQh6a5ixT6mVqBcXPe90QRRJU7XUlLtSzo4bKvlyPxJUTA8DpGMWNOt4zbbEznzYFMf7RuRBADycJ48ctcjlWTKelspcoBmUfSu+joJrYYvME0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pAqKeof/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pAqKeof/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2377DC116B1;
	Tue, 23 Apr 2024 21:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908520;
	bh=2qUZBFW6oigOqBK/umkhlGzl65EOwNzAdPmfX9REKsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pAqKeof/h5kZr+hgMkW7DmA5JVu6bAw9MRgWGL8ZckHGp41s7G14ZIie97PRCfz/L
	 fKB3rIRlr7i5BK7RU01E8W+PQM1i8xVn6gbb95//XDtTqWD3fg9i0E7GQnrTADeMPy
	 TC0e9k86rOxrNjYkxCQGI/A4aTzDYbau1dR57GRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Tony Lindgren <tony@atomide.com>
Subject: [PATCH 6.8 108/158] serial: core: Fix missing shutdown and startup for serial base port
Date: Tue, 23 Apr 2024 14:38:50 -0700
Message-ID: <20240423213859.448520987@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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
 
@@ -1775,6 +1788,7 @@ static void uart_tty_port_shutdown(struc
 	uport->ops->stop_rx(uport);
 	uart_port_unlock_irq(uport);
 
+	serial_base_port_shutdown(uport);
 	uart_port_shutdown(port);
 
 	/*
--- a/drivers/tty/serial/serial_port.c
+++ b/drivers/tty/serial/serial_port.c
@@ -36,8 +36,12 @@ static int serial_port_runtime_resume(st
 
 	/* Flush any pending TX for the port */
 	uart_port_lock_irqsave(port, &flags);
+	if (!port_dev->tx_enabled)
+		goto unlock;
 	if (__serial_port_busy(port))
 		port->ops->start_tx(port);
+
+unlock:
 	uart_port_unlock_irqrestore(port, flags);
 
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


