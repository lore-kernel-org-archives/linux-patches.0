Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4440386C3B;
	Tue, 25 Aug 2026 13:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665104; cv=none; b=I5c1TqsosbhSglwswjalWzVSrrBnjo3g7BJ3vNc3pi2EGDsxxC+LFndVfg3j4dkmBH8H+QHh2/A5Xz95kZz7xhNGDAs6veiGyr6S544n5of0NbvOEtbhaC5s/s4BSRKwJhZaxCWo/phCrfysoK6mjtH3GXh3wolmHozoIoO+DFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665104; c=relaxed/simple;
	bh=aSJKrUgj3Fts1yjXQ0OjzgNtZaiwmYwO9/JcLGmliNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnyF89gLq3gG10gBI8WfcW12GUsmWdFXiwAzidTkA6oftYbYB57GpBAXw66EjGzeerNdTo8dufTb6nwkDhD8irHZ/wqutT3FkWlL95aDfXJD+eyfL7LGjtb28P2lv/InNdyb8tUwu/Ootawk8w9LnE0I8wYUbqKnshSYtl9otVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vw+7CpZJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vw+7CpZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE0D1F000E9;
	Tue, 25 Aug 2026 13:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665102;
	bh=bI4QeT4jAC8oIouuYSGJVO9mfv2BlinSkhUsW9+BblM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vw+7CpZJ6pfOLlkLtvXP0cF7eWHkG9IGupFZFeUULt4bQR6XP7gxJQPFDzQy3g5uN
	 DIBoU269GC0OVU48loHFdbjiwrcXiXO6GC8XNPtmorh43NtmjT659aSPh4cOrhU235
	 jKTa+xetIZ1HeelOjZBvBFNxI5HTe9+jx8WIIdso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 01/94] serial: sc16is7xx: rename EFR mutex with generic name
Date: Tue, 25 Aug 2026 15:24:57 +0200
Message-ID: <20260825132541.941747084@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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
@@ -328,7 +328,7 @@ struct sc16is7xx_one_config {
 struct sc16is7xx_one {
 	struct uart_port		port;
 	struct regmap			*regmap;
-	struct mutex			efr_lock; /* EFR registers access */
+	struct mutex			lock; /* For registers sharing same address space. */
 	struct kthread_work		tx_work;
 	struct kthread_work		reg_work;
 	struct kthread_delayed_work	ms_work;
@@ -436,7 +436,7 @@ static void sc16is7xx_efr_lock(struct ua
 {
 	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 
-	mutex_lock(&one->efr_lock);
+	mutex_lock(&one->lock);
 
 	/* Backup content of LCR. */
 	one->old_lcr = sc16is7xx_port_read(port, SC16IS7XX_LCR_REG);
@@ -458,7 +458,7 @@ static void sc16is7xx_efr_unlock(struct
 	/* Restore original content of LCR */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, one->old_lcr);
 
-	mutex_unlock(&one->efr_lock);
+	mutex_unlock(&one->lock);
 }
 
 static void sc16is7xx_ier_clear(struct uart_port *port, u8 bit)
@@ -593,7 +593,7 @@ static int sc16is7xx_set_baud(struct uar
 			      SC16IS7XX_MCR_CLKSEL_BIT,
 			      prescaler == 1 ? 0 : SC16IS7XX_MCR_CLKSEL_BIT);
 
-	mutex_lock(&one->efr_lock);
+	mutex_lock(&one->lock);
 
 	/* Backup LCR and access special register set (DLL/DLH) */
 	lcr = sc16is7xx_port_read(port, SC16IS7XX_LCR_REG);
@@ -609,7 +609,7 @@ static int sc16is7xx_set_baud(struct uar
 	/* Restore LCR and access to general register set */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, lcr);
 
-	mutex_unlock(&one->efr_lock);
+	mutex_unlock(&one->lock);
 
 	return DIV_ROUND_CLOSEST((clk / prescaler) / 16, div);
 }
@@ -756,7 +756,7 @@ static void sc16is7xx_update_mlines(stru
 	unsigned long flags;
 	unsigned int status, changed;
 
-	lockdep_assert_held_once(&one->efr_lock);
+	lockdep_assert_held_once(&one->lock);
 
 	status = sc16is7xx_get_hwmctrl(port);
 	changed = status ^ one->old_mctrl;
@@ -787,7 +787,7 @@ static bool sc16is7xx_port_irq(struct sc
 	struct uart_port *port = &s->p[portno].port;
 	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 
-	mutex_lock(&one->efr_lock);
+	mutex_lock(&one->lock);
 
 	iir = sc16is7xx_port_read(port, SC16IS7XX_IIR_REG);
 	if (iir & SC16IS7XX_IIR_NO_INT_BIT) {
@@ -834,7 +834,7 @@ static bool sc16is7xx_port_irq(struct sc
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
@@ -1635,7 +1635,7 @@ int sc16is7xx_probe(struct device *dev,
 		s->p[i].old_mctrl	= 0;
 		s->p[i].regmap		= regmaps[i];
 
-		mutex_init(&s->p[i].efr_lock);
+		mutex_init(&s->p[i].lock);
 
 		ret = uart_get_rs485_mode(&s->p[i].port);
 		if (ret)


