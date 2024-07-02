Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E12315218A;
	Tue,  2 Jul 2024 17:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941058; cv=none; b=Gh/YZrNY4r7xDB6l9dza+y3W7bpAY0BvyQZhRx+4gk0pQNh8+dXskNipK3WNI1/VcZ6fyNMrxOGhAq5lmszsVNIuixVxaoEYoujLKU0DQMVrYmxJb7B52bL6PN2KGmLm99w3Irpc9y0PMDWan3fFC1qCqOStTdYXHBrfdctBmXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941058; c=relaxed/simple;
	bh=tBDlXoEI8Yx1Y7gI8pAupH1O9nN3v7Ev15AJLofoLGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sm9Om7GoT6icWwmQAGxOjwHjxxv7H+Wm6xH/TgkQX8XneX+QEkFFnzCkt3T6O/qbS8dyWybt6uVx2u543DMKWB+oou79+E5vI8jrxIqsA1vKSoS1KJCQXR2hMs1m+mA/BBpmvqKZx+dpOEE+5O/uDg3U8iWE9O2r9dR5UgYfFu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tunPFUOP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tunPFUOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF2CC116B1;
	Tue,  2 Jul 2024 17:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941058;
	bh=tBDlXoEI8Yx1Y7gI8pAupH1O9nN3v7Ev15AJLofoLGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tunPFUOPSy3SMLV1VY2pj7sD/vtsid/oYZrcQ9IWzxVo0OH+vGYJ/aDAJavEqjcsC
	 T1kTqtqXhwzrykZ+X2EUi9ZqecjZQttrxU872av1JkecWIMLNlNCazGFVEqsmgL6uW
	 +p8wFEAEMXoQHWgxYio4m/jB8f0HGBg0uAgvSAu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Udit Kumar <u-kumar1@ti.com>
Subject: [PATCH 6.6 116/163] serial: 8250_omap: Implementation of Errata i2310
Date: Tue,  2 Jul 2024 19:03:50 +0200
Message-ID: <20240702170237.446836585@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

From: Udit Kumar <u-kumar1@ti.com>

commit 9d141c1e615795eeb93cd35501ad144ee997a826 upstream.

As per Errata i2310[0], Erroneous timeout can be triggered,
if this Erroneous interrupt is not cleared then it may leads
to storm of interrupts, therefore apply Errata i2310 solution.

[0] https://www.ti.com/lit/pdf/sprz536 page 23

Fixes: b67e830d38fa ("serial: 8250: 8250_omap: Fix possible interrupt storm on K3 SoCs")
Cc: stable@vger.kernel.org
Signed-off-by: Udit Kumar <u-kumar1@ti.com>
Link: https://lore.kernel.org/r/20240619105903.165434-1-u-kumar1@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_omap.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -165,6 +165,10 @@ static u32 uart_read(struct omap8250_pri
 	return readl(priv->membase + (reg << OMAP_UART_REGSHIFT));
 }
 
+/* Timeout low and High */
+#define UART_OMAP_TO_L                 0x26
+#define UART_OMAP_TO_H                 0x27
+
 /*
  * Called on runtime PM resume path from omap8250_restore_regs(), and
  * omap8250_set_mctrl().
@@ -646,13 +650,24 @@ static irqreturn_t omap8250_irq(int irq,
 
 	/*
 	 * On K3 SoCs, it is observed that RX TIMEOUT is signalled after
-	 * FIFO has been drained, in which case a dummy read of RX FIFO
-	 * is required to clear RX TIMEOUT condition.
+	 * FIFO has been drained or erroneously.
+	 * So apply solution of Errata i2310 as mentioned in
+	 * https://www.ti.com/lit/pdf/sprz536
 	 */
 	if (priv->habit & UART_RX_TIMEOUT_QUIRK &&
-	    (iir & UART_IIR_RX_TIMEOUT) == UART_IIR_RX_TIMEOUT &&
-	    serial_port_in(port, UART_OMAP_RX_LVL) == 0) {
-		serial_port_in(port, UART_RX);
+		(iir & UART_IIR_RX_TIMEOUT) == UART_IIR_RX_TIMEOUT) {
+		unsigned char efr2, timeout_h, timeout_l;
+
+		efr2 = serial_in(up, UART_OMAP_EFR2);
+		timeout_h = serial_in(up, UART_OMAP_TO_H);
+		timeout_l = serial_in(up, UART_OMAP_TO_L);
+		serial_out(up, UART_OMAP_TO_H, 0xFF);
+		serial_out(up, UART_OMAP_TO_L, 0xFF);
+		serial_out(up, UART_OMAP_EFR2, UART_OMAP_EFR2_TIMEOUT_BEHAVE);
+		serial_in(up, UART_IIR);
+		serial_out(up, UART_OMAP_EFR2, efr2);
+		serial_out(up, UART_OMAP_TO_H, timeout_h);
+		serial_out(up, UART_OMAP_TO_L, timeout_l);
 	}
 
 	/* Stop processing interrupts on input overrun */


