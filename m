Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC85208D0;
	Sat, 12 Sep 2026 10:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209510; cv=none; b=qDYBZCB8oGrGWYqTvaDvFImKRz+5r0NkzH+krbQY1wwYisjCEM64mGE5ZlH54B0O0gW65vpAAsiudYTFkeD7eJg0T4NlDy5fewdG57JeRRPwX3O8qfopEhJ4akjgpZVxBEkopgpvwWhXHMcM8X06RuNiQBH4+V6pdvYS/meVe1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209510; c=relaxed/simple;
	bh=LmswjWlPiaAcrB//T2QAuLNRMTHM0A/szakuR1fXZFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8uq6kPkifcloxozwtqWgFDQeLR9O1It/qrY+AYc4LpSc9Hz5xqZQwOh7rLiMylO6X41BdEs0QD37ewZ82p1I+F9TTBykchgzvsxaOJxunAiZjU/VAOlL7kPNoFnOxslwsJ5SEUdaWos5YXt2IwgqsHq+rZrHORfRoevyygCkw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=caKCVlgw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="caKCVlgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB7D1F000FF;
	Sat, 12 Sep 2026 10:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209509;
	bh=Hve/Bsm4rRsLHQGGlRxJQjm0AfKTJYNcX8KPpJ2om+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=caKCVlgwMDW8SuIX8hZVaoEk10ZIKOGrwEuwU89XQLCz0hOUpIZaxeP5osC1Us+xP
	 XtaZH4FrBBNfRCy/g09v8KRXhImCHQ5ZJD2hFXsCkoUSrdyeiEcHUIHoX7raw67LJa
	 +aKXFTWsY/Lx954+2BPTQr62nwpSx+81A7cZbQtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0836/1518] serial: amba-pl011: keep console clock enabled for atomic writes
Date: Sat, 12 Sep 2026 08:50:05 +0200
Message-ID: <20260912065642.351359267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit c0e8cfef754645856374e82c8effd54b7d82002b ]

pl011_console_write_atomic() runs from nbcon atomic context, where
sleeping is not allowed. It calls clk_enable(), which takes the common-clk
enable_lock. Under PREEMPT_RT that is a sleeping lock:
clk_enable_lock() first tries spin_trylock_irqsave(), but on contention
falls back to spin_lock_irqsave(). Therefore, an atomic-context printk on
an RT kernel with a clk-backed pl011 can trip:

  BUG: sleeping function called from invalid context at spinlock_rt.c:48
    __might_resched from rt_spin_lock
    rt_spin_lock from clk_enable_lock
    clk_enable_lock from clk_enable
    clk_enable from pl011_console_write_atomic
    ... from vprintk_emit

This was found and reproduced on PREEMPT_RT. Arm32 and arm64 DT SoCs are
affected; arm64 SBSA/ACPI has no clk, so clk_enable(NULL) short-circuits
before the lock. In addition, write_atomic() may be invoked from NMI
context and is documented to avoid locking. Removing clk_enable() from
the callback also avoids a potentially unsafe NMI acquisition of the
common-clock enable_lock.

An nbcon atomic-capable console must be printable from any context, so
the clock cannot be gated between writes. Enable the clock while the
console is available for output: use clk_prepare_enable() in
pl011_console_setup(), release it via clk_disable_unprepare() in the
console .exit() callback, and drop the per-write clk_enable()/clk_disable()
pairs from write_atomic() and write_thread().

When printk suspends consoles, drop the reference after
uart_suspend_port() stops console access and restore it before
uart_resume_port() -- but only if suspend actually marked the port
suspended (a wake-capable tty stays running and must keep its clock), and
keep it when console_suspend_enabled is false so no_console_suspend works.

The active power cost of keeping the clock enabled is platform-dependent:
none where the UART clock is a fixed always-on oscillator, real where it
is a gateable clock branch, which then cannot be gated (nor possibly can
its parent clocks) while the console is available for output. When serial
core actually suspends the port, the reference is released so the clock
provider can gate the clock tree.

Fixes: 2eb2608618ce ("serial: amba-pl011: Implement nbcon console")
Suggested-by: John Ogness <john.ogness@linutronix.de>
Link: https://lore.kernel.org/all/8733xeaxix.fsf@jogness.linutronix.de/
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260724213348.77418-3-kmehltretter@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/amba-pl011.c | 40 +++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 66a6d336255bd..4b213d0c61336 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2446,7 +2446,7 @@ static int pl011_console_setup(struct console *co, char *options)
 	/* Allow pins to be muxed in and configured */
 	pinctrl_pm_select_default_state(uap->port.dev);
 
-	ret = clk_prepare(uap->clk);
+	ret = clk_prepare_enable(uap->clk);
 	if (ret)
 		return ret;
 
@@ -2479,7 +2479,7 @@ static int pl011_console_exit(struct console *co)
 {
 	struct uart_amba_port *uap = amba_ports[co->index];
 
-	clk_unprepare(uap->clk);
+	clk_disable_unprepare(uap->clk);
 
 	return 0;
 }
@@ -2553,8 +2553,6 @@ pl011_console_write_atomic(struct console *co, struct nbcon_write_context *wctxt
 	if (!nbcon_enter_unsafe(wctxt))
 		return;
 
-	clk_enable(uap->clk);
-
 	if (!uap->vendor->always_enabled) {
 		old_cr = pl011_read(uap, REG_CR);
 		pl011_write((old_cr & ~UART011_CR_CTSEN) | (UART01x_CR_UARTEN | UART011_CR_TXE),
@@ -2571,8 +2569,6 @@ pl011_console_write_atomic(struct console *co, struct nbcon_write_context *wctxt
 	if (!uap->vendor->always_enabled)
 		pl011_write(old_cr, uap, REG_CR);
 
-	clk_disable(uap->clk);
-
 	nbcon_exit_unsafe(wctxt);
 }
 
@@ -2585,8 +2581,6 @@ pl011_console_write_thread(struct console *co, struct nbcon_write_context *wctxt
 	if (!nbcon_enter_unsafe(wctxt))
 		return;
 
-	clk_enable(uap->clk);
-
 	if (!uap->vendor->always_enabled) {
 		old_cr = pl011_read(uap, REG_CR);
 		pl011_write((old_cr & ~UART011_CR_CTSEN) | (UART01x_CR_UARTEN | UART011_CR_TXE),
@@ -2615,8 +2609,6 @@ pl011_console_write_thread(struct console *co, struct nbcon_write_context *wctxt
 	if (!uap->vendor->always_enabled)
 		pl011_write(old_cr, uap, REG_CR);
 
-	clk_disable(uap->clk);
-
 	nbcon_exit_unsafe(wctxt);
 }
 
@@ -2976,21 +2968,45 @@ static void pl011_remove(struct amba_device *dev)
 static int pl011_suspend(struct device *dev)
 {
 	struct uart_amba_port *uap = dev_get_drvdata(dev);
+	int ret;
 
 	if (!uap)
 		return -EINVAL;
 
-	return uart_suspend_port(&amba_reg, &uap->port);
+	ret = uart_suspend_port(&amba_reg, &uap->port);
+	if (ret)
+		return ret;
+
+	if (console_suspend_enabled && uap->port.suspended &&
+	    uart_console_registered(&uap->port))
+		clk_disable_unprepare(uap->clk);
+
+	return 0;
 }
 
 static int pl011_resume(struct device *dev)
 {
 	struct uart_amba_port *uap = dev_get_drvdata(dev);
+	bool resume_console;
+	int ret;
 
 	if (!uap)
 		return -EINVAL;
 
-	return uart_resume_port(&amba_reg, &uap->port);
+	resume_console = console_suspend_enabled &&
+			 uap->port.suspended &&
+			 uart_console_registered(&uap->port);
+	if (resume_console) {
+		ret = clk_prepare_enable(uap->clk);
+		if (ret)
+			return ret;
+	}
+
+	ret = uart_resume_port(&amba_reg, &uap->port);
+	if (ret && resume_console)
+		clk_disable_unprepare(uap->clk);
+
+	return ret;
 }
 #endif
 
-- 
2.53.0



