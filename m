Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3400A12CDAE;
	Tue, 30 Apr 2024 11:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476248; cv=none; b=KHsXomr7LhPh1yRyG4xAy1Mn/I20nrOV2iCnXfmYO3ApRijXnf+vh/zBCu5HsdK+JbeQRwC7CPXAk32U/5QJ1MqSUZQZVBUF2AucJ5OAsmpCR/rtObPS/UhjF+5uxuv0x4M95xmPJqh7Kk98mCcPZmUHUmeqF3uuvULpn3JLSaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476248; c=relaxed/simple;
	bh=GS5DPl2Z01Q0Z8nQ7bAc3ppGysfmMFDSvtNwIvMy6Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W0KFMMmyzxayPqLxZ8xzoH1Xcl4XcldbRNdkTRw1CJxgKJUJUgIHxciQLN9UEIFCHSaR02tHqXC4mgv45zNJmbrDqSuc07nY7qjKbtt5RXHXLmIM+hRyOfQV2G+n/gtvei+KPOpXAjcv4kAVo3xoNeO/+EloEb7DDQz86/vY/YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fAarsMvA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fAarsMvA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29C5C2BBFC;
	Tue, 30 Apr 2024 11:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476248;
	bh=GS5DPl2Z01Q0Z8nQ7bAc3ppGysfmMFDSvtNwIvMy6Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fAarsMvAaChaIJD+KXAfmq6stgs95N66AEjWnpKm6IgpvKKoGjHGlMpyWh6fGqo81
	 QwhoUjg7+HkkXfLo2rGghhlV8q4Q5Wg1R6hjZ+QpdPQfdj+SGKcuGpZCiT7PepCL3I
	 jhEnxF2n1FUYfvlP6tL1L/Gxze2aohmbZvJr4vD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	John Ogness <john.ogness@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/107] serial: core: Provide port lock wrappers
Date: Tue, 30 Apr 2024 12:40:39 +0200
Message-ID: <20240430103046.989258407@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit b0af4bcb49464c221ad5f95d40f2b1b252ceedcc ]

When a serial port is used for kernel console output, then all
modifications to the UART registers which are done from other contexts,
e.g. getty, termios, are interference points for the kernel console.

So far this has been ignored and the printk output is based on the
principle of hope. The rework of the console infrastructure which aims to
support threaded and atomic consoles, requires to mark sections which
modify the UART registers as unsafe. This allows the atomic write function
to make informed decisions and eventually to restore operational state. It
also allows to prevent the regular UART code from modifying UART registers
while printk output is in progress.

All modifications of UART registers are guarded by the UART port lock,
which provides an obvious synchronization point with the console
infrastructure.

Provide wrapper functions for spin_[un]lock*(port->lock) invocations so
that the console mechanics can be applied later on at a single place and
does not require to copy the same logic all over the drivers.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Link: https://lore.kernel.org/r/20230914183831.587273-2-john.ogness@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 54c4ec5f8c47 ("serial: mxs-auart: add spinlock around changing cts state")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/serial_core.h | 79 +++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 10f209d54f18a..bc374d9df99fe 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -255,6 +255,85 @@ struct uart_port {
 	void			*private_data;		/* generic platform data pointer */
 };
 
+/**
+ * uart_port_lock - Lock the UART port
+ * @up:		Pointer to UART port structure
+ */
+static inline void uart_port_lock(struct uart_port *up)
+{
+	spin_lock(&up->lock);
+}
+
+/**
+ * uart_port_lock_irq - Lock the UART port and disable interrupts
+ * @up:		Pointer to UART port structure
+ */
+static inline void uart_port_lock_irq(struct uart_port *up)
+{
+	spin_lock_irq(&up->lock);
+}
+
+/**
+ * uart_port_lock_irqsave - Lock the UART port, save and disable interrupts
+ * @up:		Pointer to UART port structure
+ * @flags:	Pointer to interrupt flags storage
+ */
+static inline void uart_port_lock_irqsave(struct uart_port *up, unsigned long *flags)
+{
+	spin_lock_irqsave(&up->lock, *flags);
+}
+
+/**
+ * uart_port_trylock - Try to lock the UART port
+ * @up:		Pointer to UART port structure
+ *
+ * Returns: True if lock was acquired, false otherwise
+ */
+static inline bool uart_port_trylock(struct uart_port *up)
+{
+	return spin_trylock(&up->lock);
+}
+
+/**
+ * uart_port_trylock_irqsave - Try to lock the UART port, save and disable interrupts
+ * @up:		Pointer to UART port structure
+ * @flags:	Pointer to interrupt flags storage
+ *
+ * Returns: True if lock was acquired, false otherwise
+ */
+static inline bool uart_port_trylock_irqsave(struct uart_port *up, unsigned long *flags)
+{
+	return spin_trylock_irqsave(&up->lock, *flags);
+}
+
+/**
+ * uart_port_unlock - Unlock the UART port
+ * @up:		Pointer to UART port structure
+ */
+static inline void uart_port_unlock(struct uart_port *up)
+{
+	spin_unlock(&up->lock);
+}
+
+/**
+ * uart_port_unlock_irq - Unlock the UART port and re-enable interrupts
+ * @up:		Pointer to UART port structure
+ */
+static inline void uart_port_unlock_irq(struct uart_port *up)
+{
+	spin_unlock_irq(&up->lock);
+}
+
+/**
+ * uart_port_lock_irqrestore - Unlock the UART port, restore interrupts
+ * @up:		Pointer to UART port structure
+ * @flags:	The saved interrupt flags for restore
+ */
+static inline void uart_port_unlock_irqrestore(struct uart_port *up, unsigned long flags)
+{
+	spin_unlock_irqrestore(&up->lock, flags);
+}
+
 static inline int serial_port_in(struct uart_port *up, int offset)
 {
 	return up->serial_in(up, offset);
-- 
2.43.0



