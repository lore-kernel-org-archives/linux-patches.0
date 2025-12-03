Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052CD3563D3;
	Wed,  3 Dec 2025 16:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778666; cv=none; b=OMoxVWzq2YMW4td5LdlDgntVAnXJq776c78b21GSCVjNxBw8zpW7SkT24Hx+FvMuMVm09QlJBlitCrI7jOYJCxiDCpeVh5fl3OOZxY2r8eHAzfbq6W9jBVKt+5gxhr2YoNre85ihOBvlbSsIAWylLbk+mEq9ZzJ7d8+lfuV3eQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778666; c=relaxed/simple;
	bh=7Ua+EJGrgtViNMiW7ptCE/JC/tTqfplJTdr7NYjatsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soViMWt874i5vMF4E0K4MRViFYltY5NQMTsd+XIjijb2v3Hr/AX0LuOyCuZfF1JKyruA7fuCryq0wmgaYy6NJPB35Bs6s/47+oyBoWJwt7izpy167/Xo+/nqKUJSaQRVrmp5srvg7cIuY4u3w43OgrkGV/LFqQDxWY5ofSCEOS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VAMND4MM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VAMND4MM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3DDC4CEF5;
	Wed,  3 Dec 2025 16:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778665;
	bh=7Ua+EJGrgtViNMiW7ptCE/JC/tTqfplJTdr7NYjatsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VAMND4MMU8Du880Qt9W1lQGtZ5V/1cOj1wC/zsFKTLLuQTlGAHQQczbFnz7f2m6JP
	 uttr1b/22x7HIJnGIRT1CqXfB8Ini0ZbE8R297D73iNkes8p/3T7uh02Y8SHfAWYeD
	 qYMS4EpXKVkqYg4++uCNDK2wH0u2Ox2p6XcNLJO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/568] serial: sc16is7xx: refactor EFR lock
Date: Wed,  3 Dec 2025 16:20:24 +0100
Message-ID: <20251203152441.475749056@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 0c84bea0cabc4e2b98a3de88eeb4ff798931f056 ]

Move common code for EFR lock/unlock of mutex into functions for code reuse
and clarity.

With the addition of old_lcr, move irda_mode within struct sc16is7xx_one to
reduce memory usage:
    Before: /* size: 752, cachelines: 12, members: 10 */
    After:  /* size: 744, cachelines: 12, members: 10 */

Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231221231823.2327894-17-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 1c05bf6c0262 ("serial: sc16is7xx: remove useless enable of enhanced features")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |  106 ++++++++++++++++++++++-------------------
 1 file changed, 57 insertions(+), 49 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -329,8 +329,9 @@ struct sc16is7xx_one {
 	struct kthread_work		reg_work;
 	struct kthread_delayed_work	ms_work;
 	struct sc16is7xx_one_config	config;
-	bool				irda_mode;
 	unsigned int			old_mctrl;
+	u8				old_lcr; /* Value before EFR access. */
+	bool				irda_mode;
 };
 
 struct sc16is7xx_port {
@@ -412,6 +413,49 @@ static void sc16is7xx_power(struct uart_
 			      on ? 0 : SC16IS7XX_IER_SLEEP_BIT);
 }
 
+/*
+ * In an amazing feat of design, the Enhanced Features Register (EFR)
+ * shares the address of the Interrupt Identification Register (IIR).
+ * Access to EFR is switched on by writing a magic value (0xbf) to the
+ * Line Control Register (LCR). Any interrupt firing during this time will
+ * see the EFR where it expects the IIR to be, leading to
+ * "Unexpected interrupt" messages.
+ *
+ * Prevent this possibility by claiming a mutex while accessing the EFR,
+ * and claiming the same mutex from within the interrupt handler. This is
+ * similar to disabling the interrupt, but that doesn't work because the
+ * bulk of the interrupt processing is run as a workqueue job in thread
+ * context.
+ */
+static void sc16is7xx_efr_lock(struct uart_port *port)
+{
+	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
+
+	mutex_lock(&one->efr_lock);
+
+	/* Backup content of LCR. */
+	one->old_lcr = sc16is7xx_port_read(port, SC16IS7XX_LCR_REG);
+
+	/* Enable access to Enhanced register set */
+	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, SC16IS7XX_LCR_CONF_MODE_B);
+
+	/* Disable cache updates when writing to EFR registers */
+	regcache_cache_bypass(one->regmap, true);
+}
+
+static void sc16is7xx_efr_unlock(struct uart_port *port)
+{
+	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
+
+	/* Re-enable cache updates when writing to normal registers */
+	regcache_cache_bypass(one->regmap, false);
+
+	/* Restore original content of LCR */
+	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, one->old_lcr);
+
+	mutex_unlock(&one->efr_lock);
+}
+
 static void sc16is7xx_ier_clear(struct uart_port *port, u8 bit)
 {
 	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
@@ -538,39 +582,12 @@ static int sc16is7xx_set_baud(struct uar
 		div /= prescaler;
 	}
 
-	/* In an amazing feat of design, the Enhanced Features Register shares
-	 * the address of the Interrupt Identification Register, and is
-	 * switched in by writing a magic value (0xbf) to the Line Control
-	 * Register. Any interrupt firing during this time will see the EFR
-	 * where it expects the IIR to be, leading to "Unexpected interrupt"
-	 * messages.
-	 *
-	 * Prevent this possibility by claiming a mutex while accessing the
-	 * EFR, and claiming the same mutex from within the interrupt handler.
-	 * This is similar to disabling the interrupt, but that doesn't work
-	 * because the bulk of the interrupt processing is run as a workqueue
-	 * job in thread context.
-	 */
-	mutex_lock(&one->efr_lock);
-
-	lcr = sc16is7xx_port_read(port, SC16IS7XX_LCR_REG);
-
-	/* Open the LCR divisors for configuration */
-	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG,
-			     SC16IS7XX_LCR_CONF_MODE_B);
-
 	/* Enable enhanced features */
-	regcache_cache_bypass(one->regmap, true);
+	sc16is7xx_efr_lock(port);
 	sc16is7xx_port_update(port, SC16IS7XX_EFR_REG,
 			      SC16IS7XX_EFR_ENABLE_BIT,
 			      SC16IS7XX_EFR_ENABLE_BIT);
-
-	regcache_cache_bypass(one->regmap, false);
-
-	/* Put LCR back to the normal mode */
-	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, lcr);
-
-	mutex_unlock(&one->efr_lock);
+	sc16is7xx_efr_unlock(port);
 
 	/* If bit MCR_CLKSEL is set, the divide by 4 prescaler is activated. */
 	sc16is7xx_port_update(port, SC16IS7XX_MCR_REG,
@@ -580,7 +597,8 @@ static int sc16is7xx_set_baud(struct uar
 
 	mutex_lock(&one->efr_lock);
 
-	/* Open the LCR divisors for configuration */
+	/* Backup LCR and access special register set (DLL/DLH) */
+	lcr = sc16is7xx_port_read(port, SC16IS7XX_LCR_REG);
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG,
 			     SC16IS7XX_LCR_CONF_MODE_A);
 
@@ -590,7 +608,7 @@ static int sc16is7xx_set_baud(struct uar
 	sc16is7xx_port_write(port, SC16IS7XX_DLL_REG, div % 256);
 	regcache_cache_bypass(one->regmap, false);
 
-	/* Put LCR back to the normal mode */
+	/* Restore LCR and access to general register set */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, lcr);
 
 	mutex_unlock(&one->efr_lock);
@@ -1073,17 +1091,7 @@ static void sc16is7xx_set_termios(struct
 	if (!(termios->c_cflag & CREAD))
 		port->ignore_status_mask |= SC16IS7XX_LSR_BRK_ERROR_MASK;
 
-	/* As above, claim the mutex while accessing the EFR. */
-	mutex_lock(&one->efr_lock);
-
-	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG,
-			     SC16IS7XX_LCR_CONF_MODE_B);
-
 	/* Configure flow control */
-	regcache_cache_bypass(one->regmap, true);
-	sc16is7xx_port_write(port, SC16IS7XX_XON1_REG, termios->c_cc[VSTART]);
-	sc16is7xx_port_write(port, SC16IS7XX_XOFF1_REG, termios->c_cc[VSTOP]);
-
 	port->status &= ~(UPSTAT_AUTOCTS | UPSTAT_AUTORTS);
 	if (termios->c_cflag & CRTSCTS) {
 		flow |= SC16IS7XX_EFR_AUTOCTS_BIT |
@@ -1095,16 +1103,16 @@ static void sc16is7xx_set_termios(struct
 	if (termios->c_iflag & IXOFF)
 		flow |= SC16IS7XX_EFR_SWFLOW1_BIT;
 
-	sc16is7xx_port_update(port,
-			      SC16IS7XX_EFR_REG,
-			      SC16IS7XX_EFR_FLOWCTRL_BITS,
-			      flow);
-	regcache_cache_bypass(one->regmap, false);
-
 	/* Update LCR register */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, lcr);
 
-	mutex_unlock(&one->efr_lock);
+	/* Update EFR registers */
+	sc16is7xx_efr_lock(port);
+	sc16is7xx_port_write(port, SC16IS7XX_XON1_REG, termios->c_cc[VSTART]);
+	sc16is7xx_port_write(port, SC16IS7XX_XOFF1_REG, termios->c_cc[VSTOP]);
+	sc16is7xx_port_update(port, SC16IS7XX_EFR_REG,
+			      SC16IS7XX_EFR_FLOWCTRL_BITS, flow);
+	sc16is7xx_efr_unlock(port);
 
 	/* Get baud rate generator configuration */
 	baud = uart_get_baud_rate(port, termios, old,


