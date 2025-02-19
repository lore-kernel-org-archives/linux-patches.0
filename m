Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40AB1DFD9D;
	Wed, 19 Feb 2025 09:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956529; cv=none; b=KnRBR2Lh5fpTnxf1BR49BqpGHjsAAVOsDKB+Dd9zPKq6j6bFn0DBmAJ+lzVAQCQDPdIoXGW+Wd7iolCi4H/IkKY5WIj+tvbYOnN94R8t1Vc4ZhT7NqSUMnIcwdJ7ZZCHU40LNB00CBGb0fHk4zKcjDnFEP3oHEjQMH/Q1Q265d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956529; c=relaxed/simple;
	bh=J6vWkVB6rj9Syn3up7p8EAVXNzEtXAOPxZtWwcq51j8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0yYZJ6dK3dEvWn/WVkzF4QSLwtUPQI5Li+bywLMz/i9FIIGfdlrfAATPsQwJzGvai+1UTo5VKJ334yigwIkO+tHARFnu2inH3kybv1vFBoe7gxFugmFSKmjLxsguTLzk2fGWOHLWw5z26mqxCyLrI8huts3cPSsE+rw164qcUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NtdYqGoC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NtdYqGoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10555C4CEE9;
	Wed, 19 Feb 2025 09:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956528;
	bh=J6vWkVB6rj9Syn3up7p8EAVXNzEtXAOPxZtWwcq51j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NtdYqGoCpxhU9h4Vjr0qdPZkde93aswlHPlQpfMOPKPr6jcL3QrVQZKRt2aaRTgc2
	 QsbiKpuEIbWqjTTw4ea/MljwwiuIR9A7A7lOy5JnrvpU4/fbyPUEyBIWx+RkgJAeXz
	 0RF4RuPD2b+daur1mOQRP8/+JOi4gD+guNqii1Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Wander Lairson Costa <wander@redhat.com>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 208/578] serial: 8250: Adjust the timeout for FIFO mode
Date: Wed, 19 Feb 2025 09:23:32 +0100
Message-ID: <20250219082701.243808435@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c744feabd7cdd..fb1ea2f448910 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2091,7 +2091,8 @@ static void serial8250_break_ctl(struct uart_port *port, int break_state)
 	serial8250_rpm_put(up);
 }
 
-static void wait_for_lsr(struct uart_8250_port *up, int bits)
+/* Returns true if @bits were set, false on timeout */
+static bool wait_for_lsr(struct uart_8250_port *up, int bits)
 {
 	unsigned int status, tmout = 10000;
 
@@ -2106,11 +2107,11 @@ static void wait_for_lsr(struct uart_8250_port *up, int bits)
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
@@ -3349,6 +3350,16 @@ static void serial8250_console_restore(struct uart_8250_port *up)
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
@@ -3358,13 +3369,15 @@ static void serial8250_console_restore(struct uart_8250_port *up)
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
@@ -3375,7 +3388,14 @@ static void serial8250_console_fifo_write(struct uart_8250_port *up,
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



