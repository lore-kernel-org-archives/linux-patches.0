Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFD635946;
	Wed,  5 Feb 2025 15:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768040; cv=none; b=fYxp3LOipXwB5en94FOdOnmAD3WB+kEZjHXu9vhVK8tt0eot9oZrVCV23Z044FZy1Do2zjxD1ilQCbu5X5gvNVIviIG/EsN2HTqLtBfLR610MPurdqXazkB1g3bkVNdbWDmpoDun8olD0kybFgdmY/HHmpnCA5x3K4kcmAccU78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768040; c=relaxed/simple;
	bh=PaSw4c/Y4kmiCLrDfBdxBE7q6SJ4ndmMnIxPQ6XsJu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUFsiCXKn5opvkS4ZLSqCO5iK4f8thP+v+/CTtgOENHLlIfZqa5I1ABnkUvzRNupiCYpE56MFxGQHHHJtDteTnadXSyPKQZN5wY1dvGmuj6d978CpvFkTBtH1a8CnBHQNlgjqE7x86GXLoM2IF9kTyukpWeYCUvWF6HKrxDNXoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wXfG31Da; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wXfG31Da"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F8AC4CED1;
	Wed,  5 Feb 2025 15:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768040;
	bh=PaSw4c/Y4kmiCLrDfBdxBE7q6SJ4ndmMnIxPQ6XsJu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wXfG31DaBeUq3DT9HmnUihRdYJez68eOUaD92FsQAQQPKmyaR1opXWz/d44P0ENg/
	 LN16HSXuFHfI3bEyXUHTZItJmK6f2rRGXlPGbOw+yg5EODuXVlpTzi/rNQVMg+8LQB
	 OS+/YVYSNbKx0uzJmqp6YdbWx9t9NC/J2LFqrbjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Wander Lairson Costa <wander@redhat.com>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 487/623] serial: 8250: Adjust the timeout for FIFO mode
Date: Wed,  5 Feb 2025 14:43:49 +0100
Message-ID: <20250205134514.849481640@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit d91f98be26510f5f81ec66425bb0306d1ccd571a ]

After a console has written a record into UART_TX, it uses
wait_for_xmitr() to wait until the data has been sent out before
returning. However, wait_for_xmitr() will timeout after 10ms,
regardless if the data has been transmitted or not.

For single bytes, this timeout is sufficient even at very slow
baud rates, such as 1200bps. However, when FIFO mode is used,
there may be 64 bytes pushed into the FIFO at once. At a baud
rate of 115200bps, the 10ms timeout is still sufficient. But
when using lower baud rates (such as 57600bps), the timeout
is _not_ sufficient. This causes longer lines to be cut off,
resulting in lost and horribly misformatted output on the
console.

When using FIFO mode, take the number of bytes into account to
determine an appropriate maximum timeout. Increasing the timeout
does not affect performance since ideally the timeout never
occurs.

Fixes: 8f3631f0f6eb ("serial/8250: Use fifo in 8250 console driver")
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Wander Lairson Costa <wander@redhat.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20250107212702.169493-2-john.ogness@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_port.c | 32 +++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 649e74e9b52f6..b8babbdec8f3f 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2079,7 +2079,8 @@ static void serial8250_break_ctl(struct uart_port *port, int break_state)
 	serial8250_rpm_put(up);
 }
 
-static void wait_for_lsr(struct uart_8250_port *up, int bits)
+/* Returns true if @bits were set, false on timeout */
+static bool wait_for_lsr(struct uart_8250_port *up, int bits)
 {
 	unsigned int status, tmout = 10000;
 
@@ -2094,11 +2095,11 @@ static void wait_for_lsr(struct uart_8250_port *up, int bits)
 		udelay(1);
 		touch_nmi_watchdog();
 	}
+
+	return (tmout != 0);
 }
 
-/*
- *	Wait for transmitter & holding register to empty
- */
+/* Wait for transmitter and holding register to empty with timeout */
 static void wait_for_xmitr(struct uart_8250_port *up, int bits)
 {
 	unsigned int tmout;
@@ -3317,6 +3318,16 @@ static void serial8250_console_restore(struct uart_8250_port *up)
 	serial8250_out_MCR(up, up->mcr | UART_MCR_DTR | UART_MCR_RTS);
 }
 
+static void fifo_wait_for_lsr(struct uart_8250_port *up, unsigned int count)
+{
+	unsigned int i;
+
+	for (i = 0; i < count; i++) {
+		if (wait_for_lsr(up, UART_LSR_THRE))
+			return;
+	}
+}
+
 /*
  * Print a string to the serial port using the device FIFO
  *
@@ -3326,13 +3337,15 @@ static void serial8250_console_restore(struct uart_8250_port *up)
 static void serial8250_console_fifo_write(struct uart_8250_port *up,
 					  const char *s, unsigned int count)
 {
-	int i;
 	const char *end = s + count;
 	unsigned int fifosize = up->tx_loadsz;
+	unsigned int tx_count = 0;
 	bool cr_sent = false;
+	unsigned int i;
 
 	while (s != end) {
-		wait_for_lsr(up, UART_LSR_THRE);
+		/* Allow timeout for each byte of a possibly full FIFO */
+		fifo_wait_for_lsr(up, fifosize);
 
 		for (i = 0; i < fifosize && s != end; ++i) {
 			if (*s == '\n' && !cr_sent) {
@@ -3343,7 +3356,14 @@ static void serial8250_console_fifo_write(struct uart_8250_port *up,
 				cr_sent = false;
 			}
 		}
+		tx_count = i;
 	}
+
+	/*
+	 * Allow timeout for each byte written since the caller will only wait
+	 * for UART_LSR_BOTH_EMPTY using the timeout of a single character
+	 */
+	fifo_wait_for_lsr(up, tx_count);
 }
 
 /*
-- 
2.39.5



