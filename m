Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46871607B7;
	Wed,  5 Feb 2025 14:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765908; cv=none; b=T6LPjv7E7wuarhqhBk7lB3SVlN5P5cBWw1isHyMDmFioX3+CupnlJSs9XZPClg6h2XS3L25Nk62vhXXonGbF70O3rWtiX2VfWEDMgs7N5PpsFd87PoDVX9AqX5kw8j3AcqTeiDz6xRQ+VBAA6QYZ5gPxQ0Bn8WE7acvQz8xJK2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765908; c=relaxed/simple;
	bh=UCh/6y94X6W99NQmEsUsxCosK9Zmd0QymCakqu9Sq6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hfre2WtkkIeRpxNyCfKli/t2ko9XlNp0J/vBUlANFk3nxgfht3ekIBeVo5AFh2chT6QKhhKbLPX4236+HwBCiPVsn5Ek4snOoRFiiKiCtNOgVRfx+hBXZDcuGT0Ys2vRkiuTIzzuilpi8TtDv4+WlH1JPaCfZJs07kp5nAhU8+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJvRURd9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJvRURd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EC2C4CEE2;
	Wed,  5 Feb 2025 14:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765907;
	bh=UCh/6y94X6W99NQmEsUsxCosK9Zmd0QymCakqu9Sq6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJvRURd9ZyJnXfG8ZR2ma9Kd/CTKfWYB1NBkHMnXdckJgEMCzL2xGqCA6UgMr445Y
	 3YSHRywuewwDSz3Ci9TA9NiwQurKGJQtDKe/bj6AfF/Jao1puUF57uW7WA1P2tJRQg
	 tuqC98uHNxT2cwN5T0NOW5caxFtVUWNGiBRe0QOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Wander Lairson Costa <wander@redhat.com>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 311/393] serial: 8250: Adjust the timeout for FIFO mode
Date: Wed,  5 Feb 2025 14:43:50 +0100
Message-ID: <20250205134432.209894668@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a17803da83f8c..2b1b2928ef7b7 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2074,7 +2074,8 @@ static void serial8250_break_ctl(struct uart_port *port, int break_state)
 	serial8250_rpm_put(up);
 }
 
-static void wait_for_lsr(struct uart_8250_port *up, int bits)
+/* Returns true if @bits were set, false on timeout */
+static bool wait_for_lsr(struct uart_8250_port *up, int bits)
 {
 	unsigned int status, tmout = 10000;
 
@@ -2089,11 +2090,11 @@ static void wait_for_lsr(struct uart_8250_port *up, int bits)
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
@@ -3350,6 +3351,16 @@ static void serial8250_console_restore(struct uart_8250_port *up)
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
@@ -3359,13 +3370,15 @@ static void serial8250_console_restore(struct uart_8250_port *up)
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
@@ -3376,7 +3389,14 @@ static void serial8250_console_fifo_write(struct uart_8250_port *up,
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



