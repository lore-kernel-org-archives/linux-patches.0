Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026368;
	b=ONLkClY+/XgJdrB1yOG08CbRTpoBvzHKASfa25DkSWtPSxbIoNuOu7clXRIEyCghrSMm
	 Yc60/CooVi/bD/TYs3nbGWPcKjua/mT1LLZnkzq3iUyLirE1c7IX1Rq14uLhNUh+T+Vv/
	 EYqiFxVMhmoifUdLG+PTC9+ExG3AqGJvAGqyQxBANXMV9n0+TRmqltZh5FJFvFdBH57+m
	 urm1CQhMjzbonSZ29PmrVdr84SHuw18MoDF2rW5dDFcVM4gXQDAdSSfCiiKcqlgtfMQwU
	 XP526ffyi1HP+gXSuM8LdsS1hZECVZpVjgtarhRealVXWZV6P+ZNy0aE7C+MMOyHnSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S/gjngJxTSY8YOwi9J3VegRO1DKhY5wr23JdcomCFdE=;
	b=mI002QL5buTtUPfJAJ6/ZQJS6ZKWoU9EA13RaDEmOW9hIfPcrNH7g+sdZdJay3eSsySl
	 bVYh3zq6zWBTChyPW1BHdMvsKIKU9b6J90WrX+zuy0BgjuecesWyrKBdg+kptIuxe7bJX
	 RP95p836O2wRNYUvLKCx6cKHi3GpGL/3Bm8pa9XxQYUUvSwT9TdIP8ZZK7tUhz34ITznj
	 xSkkWA0tXZoD+APjMrZ5m/ORyPnzFwbuQnjOdqXASREcjAMbbvmlNX8o4SOLitQHSqLQ9
	 b6s65ZD39KZvg9lv6EwUzjsX0pTsYmMT9/xldrJtvDeeezqZ2hdCFdKKxGEpGSQNV7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yv6AuZy4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64642606A32C;
	Wed, 18 Nov 2026 18:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yv6AuZy4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE551F000C5;
	Wed, 18 Nov 2026 18:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026368;
	bh=S/gjngJxTSY8YOwi9J3VegRO1DKhY5wr23JdcomCFdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yv6AuZy4/rOM0f14EHCFCxuvpeVpKKgI+9B+BqGcEN7GgfNQXP9FmHZXZw6OuA5ub
	 IWBZ67wBhUW5CiSMtYKQZTaB38W1uZBgFsN8gKLQxE1V0LerTfW4i4rusAoqR9IecN
	 JdDPRx/wzizmaI+DjdZty5W0EXlNFKmmEmeexSYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tapio Reijonen <tapio.reijonen@vaisala.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1409/2151] serial: max310x: dont transmit while an RS485 reconfigure is pending
Date: Wed, 18 Nov 2026 15:52:24 +0100
Message-ID: <20261118150213.303606173@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tapio Reijonen <tapio.reijonen@vaisala.com>

[ Upstream commit ae588038e31c9dbd6836cb12bbdd82af0271c373 ]

TIOCSRS485 applies its register changes asynchronously: rs485_config()
stores the new configuration and schedules rs_work, which programs
HDPIXDELAY, MODE1.TRNSCVCTRL and the RTS path. A write() issued right
after the ioctl therefore transmits against the old, half-switched
state. On a single core the ordering is even deterministic: start_tx()
picks the stale path first, then rs_work reprograms the chip, then
tx_work pumps the data - with the transceiver already released. A
TIOCSRS485 switching from the hardware to the software RTS path
followed immediately by a write puts the whole transfer on the wire
with the transceiver disabled: nothing reaches the bus and no error is
reported anywhere. The inverse direction is as old as the asynchronous
reconfigure itself: enabling RS485 and writing immediately shifts the
first bytes out before rs_work has enabled the chip's auto-RTS.

Defer instead: rs485_config() marks the reconfigure pending under
port->lock, start_tx() leaves the data in the kfifo while the mark is
set, and rs_work restarts the transmission itself once the new
configuration is fully applied. The rs485-disable path's direct
tx_work kick is replaced by the same mechanism, which also orders that
flush after the reconfigure instead of before it.

The restart kick also checks port->x_char: uart_send_xchar() reaches
start_tx() too, and a lone x_char deferred by the pending gate leaves
the kfifo empty, so the kick would otherwise skip it and nothing else
would ever send it - an idle chip FIFO raises no TXEMPTY interrupt.
And start_tx() re-checks the pending mark after the
hrtimer_try_to_cancel(-1) path retakes the dropped lock, mirroring the
tx_teardown re-check there: a TIOCSRS485 posted inside that window
would otherwise let the transmission proceed on the stale path.

rs_work takes port->lock for that restart through
uart_port_lock_irqsave(): start_tx() may drop and retake the lock
through the uart_port API on its hrtimer_try_to_cancel(-1) path, and a
raw spinlock guard around the call would unbalance the nbcon console
handling underneath.

The restart also rewinds a send state adopted for the deferred write
itself: set_rts_ctl_params() cannot tell data the pending gate
deferred apart from an in-flight transfer's refill by the xmit buffer
alone, and a deferred write pumped in the adopted send phase would
skip the configured before-send delay. With the chip FIFO empty the
adopted state can only be the deferred write: rewind it and let the
restart run the full envelope.

The chip-FIFO check for that rewind is deliberately lock-free, so a
TX-empty refill can land between the read and the lock and the rewind
can hit a live envelope. The consequence is bounded: the rewind runs
under port->lock in a state the RTS worker reads as asserted, so the
envelope pauses one before-send delay with the transceiver held - the
same pause the unconditional rewind produced before patch 8's guard.

Fixes: 5bdb48b501e8 ("serial: max310x: Fix RS485 handling")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Tapio Reijonen <tapio.reijonen@vaisala.com>
Link: https://patch.msgid.link/20261008-max310x-rs485-sw-delay-v8-9-6ba881f81e1f@vaisala.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c |   51 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 9 deletions(-)

--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -306,6 +306,7 @@ struct max310x_one {
 	bool			sw_rts_during_tx;
 	bool			cancel_tx_delay_tmr;
 	bool			tx_teardown;	/* envelope being torn down */
+	bool			rs485_pending;	/* rs_work not yet applied */
 	bool			tx_break;	/* break_ctl() owns the transceiver */
 	enum max310x_tx_state	tx_state;
 
@@ -947,6 +948,16 @@ static void max310x_start_tx(struct uart
 	if (one->tx_teardown)
 		return;
 
+	/*
+	 * An RS485 reconfigure is scheduled but not applied yet: transmitting
+	 * now would use the old path against half-programmed registers - a
+	 * TIOCSRS485 switching paths followed immediately by a write puts the
+	 * data on the wire with the transceiver released. Leave the data in
+	 * the kfifo; rs_work restarts TX once the configuration is applied.
+	 */
+	if (one->rs485_pending)
+		return;
+
 	if (READ_ONCE(one->sw_rts_during_tx)) {
 		/*
 		 * The before- and after-send phases share one delay timer. If an
@@ -965,9 +976,10 @@ static void max310x_start_tx(struct uart
 			uart_port_lock(port);
 			/*
 			 * The lock was dropped: a teardown may have run to
-			 * completion meanwhile. Re-check before starting.
+			 * completion or a reconfigure may have been posted
+			 * meanwhile. Re-check before starting.
 			 */
-			if (one->tx_teardown)
+			if (one->tx_teardown || one->rs485_pending)
 				return;
 		}
 
@@ -1413,6 +1425,8 @@ static void max310x_rs_proc(struct work_
 {
 	struct max310x_one *one = container_of(ws, struct max310x_one, rs_work);
 	unsigned int mode2 = 0;
+	unsigned long flags;
+	bool chip_tx_empty;
 
 	/*
 	 * Serialize against break_ctl() and set_termios(), which run under
@@ -1433,6 +1447,31 @@ static void max310x_rs_proc(struct work_
 
 	max310x_port_update(&one->port, MAX310X_MODE2_REG,
 			    MAX310X_MODE2_ECHOSUPR_BIT, mode2);
+
+	/*
+	 * The configuration is applied: release any TX that start_tx()
+	 * deferred while the reconfigure was pending, now on the right
+	 * path. start_tx() can drop and retake the lock through the
+	 * uart_port API - a raw spinlock guard here would unbalance it.
+	 */
+	chip_tx_empty = !max310x_port_read(&one->port,
+					   MAX310X_TXFIFOLVL_REG);
+
+	uart_port_lock_irqsave(&one->port, &flags);
+	one->rs485_pending = false;
+	if (one->port.x_char ||
+	    !kfifo_is_empty(&one->port.state->port.xmit_fifo)) {
+		/*
+		 * A send state adopted without chip data is the deferred
+		 * write itself: restart it as a fresh envelope so the
+		 * before-send delay is honoured.
+		 */
+		if (chip_tx_empty &&
+		    READ_ONCE(one->tx_state) == MAX310X_TX_SEND)
+			WRITE_ONCE(one->tx_state, MAX310X_TX_OFF);
+		max310x_start_tx(&one->port);
+	}
+	uart_port_unlock_irqrestore(&one->port, flags);
 }
 
 /* called with port.lock taken and irqs off */
@@ -1458,17 +1497,11 @@ static int max310x_rs485_config(struct u
 		}
 		WRITE_ONCE(one->tx_state, MAX310X_TX_OFF);
 		one->tx_teardown = false;
-		/*
-		 * The port stays alive, and a write that raced the teardown
-		 * may have left data queued with no envelope left to pump it.
-		 * Kick tx_work; RS485 is disabled, so the plain path is right.
-		 */
-		if (!kfifo_is_empty(&port->state->port.xmit_fifo))
-			schedule_work(&one->tx_work);
 	}
 
 	port->rs485 = *rs485;
 
+	one->rs485_pending = true;
 	schedule_work(&one->rs_work);
 
 	return 0;


