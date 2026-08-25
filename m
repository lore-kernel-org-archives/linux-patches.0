Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBE3390613;
	Tue, 25 Aug 2026 13:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665922; cv=none; b=hM034DZVCwfUG8fXXiB/MMMrzmug0F6sefvIPndIxzPacl+B6GajzKUJ2kPQUXXwmqkW/gD7KPC4Em/uni2fVEeR+Z5o7PPmYHE1SeIrMEY2kohOqTnqwY8GjSimzdNczBKAqsGZVvYDVid2PpW4KxU6hSLUjFNaMC5ohMnShK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665922; c=relaxed/simple;
	bh=iM/DlnnnvNjKUjlwapjJyEEZ8cWCensUcH1xQF9ZjLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLhy8umVbNBhQVM/0RDMx0QevyVCvhJs5okGGaEXCgXmHYaLCPX6o1PaoiP3g6tPy53FmxjyIPR/sGDPfS8aOGJiLwepPHBYJD0fgNhBfZg9/Ge/RMK1gyv7S2mW4ltz+amPyG5jtXOF61zQOZSyXVXAb0ECbARK+wPybQFqV5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jN7iDq0G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jN7iDq0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27AB1F000E9;
	Tue, 25 Aug 2026 13:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665921;
	bh=kUBnaoKson+iMX/S98itPXx9QUL8YcvSXY+aoYq9AOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jN7iDq0GYdH57AOjKch4DjO4GkL/5pmteLYFB9qy58ug+H0p9gwesmfXqLiw5K6DL
	 FqitgY6/E30eWBv/9ayzrJ2vti4Ch1eZxdHHSHJYJLE/lxjTFXEo/QLvb9yuFFlrr7
	 c/lXwXg3dPBAwKfCGG7goIRQcEMPWvBXabs+wUUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 23/79] serial: sc16is7xx: rename EFR mutex with generic name
Date: Tue, 25 Aug 2026 15:26:03 +0200
Message-ID: <20260825132542.603614906@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

[ Upstream commit d9b2d7ddbb973b981c20b21e9228581bb156f66f ]

This mutex is used as a lock when accessing registers that share the same
address space, not necessarily EFR registers.

For example, address 0x06 is shared by MSR, TCR and XOFF1 registers,
independently of EFR.

Rename the mutex with a more generic name to avoid misinterpreting its
usage.

Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://patch.msgid.link/20251027142957.1032073-3-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 246ac114f485 ("serial: sc16is7xx: enable THRI before filling TX FIFO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -330,7 +330,7 @@ struct sc16is7xx_one_config {
 struct sc16is7xx_one {
 	struct uart_port		port;
 	struct regmap			*regmap;
-	struct mutex			efr_lock; /* EFR registers access */
+	struct mutex			lock; /* For registers sharing same address space. */
 	struct kthread_work		tx_work;
 	struct kthread_work		reg_work;
 	struct kthread_delayed_work	ms_work;
@@ -437,7 +437,7 @@ static void sc16is7xx_efr_lock(struct ua
 {
 	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 
-	mutex_lock(&one->efr_lock);
+	mutex_lock(&one->lock);
 
 	/* Backup content of LCR. */
 	one->old_lcr = sc16is7xx_port_read(port, SC16IS7XX_LCR_REG);
@@ -459,7 +459,7 @@ static void sc16is7xx_efr_unlock(struct
 	/* Restore original content of LCR */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, one->old_lcr);
 
-	mutex_unlock(&one->efr_lock);
+	mutex_unlock(&one->lock);
 }
 
 static void sc16is7xx_ier_clear(struct uart_port *port, u8 bit)
@@ -594,7 +594,7 @@ static int sc16is7xx_set_baud(struct uar
 			      prescaler == 1 ? 0 : SC16IS7XX_MCR_CLKSEL_BIT);
 
 
-	mutex_lock(&one->efr_lock);
+	mutex_lock(&one->lock);
 
 	/* Backup LCR and access special register set (DLL/DLH) */
 	lcr = sc16is7xx_port_read(port, SC16IS7XX_LCR_REG);
@@ -610,7 +610,7 @@ static int sc16is7xx_set_baud(struct uar
 	/* Restore LCR and access to general register set */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, lcr);
 
-	mutex_unlock(&one->efr_lock);
+	mutex_unlock(&one->lock);
 
 	return DIV_ROUND_CLOSEST((clk / prescaler) / 16, div);
 }
@@ -768,7 +768,7 @@ static void sc16is7xx_update_mlines(stru
 	unsigned long flags;
 	unsigned int status, changed;
 
-	lockdep_assert_held_once(&one->efr_lock);
+	lockdep_assert_held_once(&one->lock);
 
 	status = sc16is7xx_get_hwmctrl(port);
 	changed = status ^ one->old_mctrl;
@@ -799,7 +799,7 @@ static bool sc16is7xx_port_irq(struct sc
 	struct uart_port *port = &s->p[portno].port;
 	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 
-	mutex_lock(&one->efr_lock);
+	mutex_lock(&one->lock);
 
 	iir = sc16is7xx_port_read(port, SC16IS7XX_IIR_REG);
 	if (iir & SC16IS7XX_IIR_NO_INT_BIT) {
@@ -846,7 +846,7 @@ static bool sc16is7xx_port_irq(struct sc
 	}
 
 out_port_irq:
-	mutex_unlock(&one->efr_lock);
+	mutex_unlock(&one->lock);
 
 	return rc;
 }
@@ -878,9 +878,9 @@ static void sc16is7xx_tx_proc(struct kth
 	    (port->rs485.delay_rts_before_send > 0))
 		msleep(port->rs485.delay_rts_before_send);
 
-	mutex_lock(&one->efr_lock);
+	mutex_lock(&one->lock);
 	sc16is7xx_handle_tx(port);
-	mutex_unlock(&one->efr_lock);
+	mutex_unlock(&one->lock);
 }
 
 static void sc16is7xx_reconf_rs485(struct uart_port *port)
@@ -947,9 +947,9 @@ static void sc16is7xx_ms_proc(struct kth
 	struct sc16is7xx_port *s = dev_get_drvdata(one->port.dev);
 
 	if (one->port.state) {
-		mutex_lock(&one->efr_lock);
+		mutex_lock(&one->lock);
 		sc16is7xx_update_mlines(one);
-		mutex_unlock(&one->efr_lock);
+		mutex_unlock(&one->lock);
 
 		kthread_queue_delayed_work(&s->kworker, &one->ms_work, HZ);
 	}
@@ -1567,7 +1567,7 @@ static int sc16is7xx_probe(struct device
 		s->p[i].old_mctrl	= 0;
 		s->p[i].regmap		= regmaps[i];
 
-		mutex_init(&s->p[i].efr_lock);
+		mutex_init(&s->p[i].lock);
 
 		ret = uart_get_rs485_mode(&s->p[i].port);
 		if (ret)


