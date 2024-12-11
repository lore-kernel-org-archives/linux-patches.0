Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F91A1BEF9D
	for <patches@lists.linux.dev>; Wed, 11 Dec 2024 04:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733891170; cv=none; b=KVUxVqg27O8a+TmGXRSXd2q72yo3DtaZ/1OKgJH5gZuoR+O+H23D3DHk4O4U+C3Yj9m6TxPcztAy1QI9MnoSh7g+OcNb8JcZ17q01qx0xUkbEdmryBMowtAk/mpb4/jsxEeKA2iwrshTzFwikreuTvWW0jzdv9bTbV2kAUcNPlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733891170; c=relaxed/simple;
	bh=lDtAYU8h+UmkLGc77sibjVTO5pFWhvrWnYGSPAxBVOw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SmoTDU/yKqe+qzPyZMx71RlAcU0lDh6XKi2CqASJMqlmvqNjsPWoOfTlYBRjI/aK0ci4/E0Hl/uGVOPjUsjSIgbG0KH2OCXdF9upzdhsq+y2I2OgrwUsSFfcMzxfejHHuqp7XLKyVcqLdxrahcwpXB1rTPP13UtzOKy3QvHUy3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=fIZI85iG; arc=none smtp.client-ip=185.125.188.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="fIZI85iG"
Received: from hwang4-ThinkPad-T14s-Gen-2a.. (unknown [120.85.107.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 26AF53FE69;
	Wed, 11 Dec 2024 04:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1733891166;
	bh=9//78CVGoSj1CyUyONFCLABZgmpl8gzWjDud3ilLnFA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version;
	b=fIZI85iGdus+L8eSP0dqqkO/qJCq8GhfKIVLo/2sIurvgFz3fepASVmpWOBnYMUIm
	 STUoQRk8T8vUXKq2KzG262dSIh6u+Q00ZMChmmb7207hOb7tXIMxP5L7iNytPlihIP
	 4fX95ZLv+v/BBQqzEI1AfAa7ABm+JSTxQbObIc3rvPnlLKnci7vkFfA+fVnGZ6Q+Pt
	 NETzR0mwOpMK24vVLiMexSZX0E4CnzKB+H3SSMyb8E0X3FYddi8r5mmpFP1Zmf/O1s
	 1G/n2+9+Be9JEdZYiSSE/nOdY7d00WDNckjhUq2XuvFBYIJ1kOoJOlEzqYvQ7gWpBm
	 M+g/YAeon7V+w==
From: Hui Wang <hui.wang@canonical.com>
To: stable@vger.kernel.org,
	patches@lists.linux.dev,
	gregkh@linuxfoundation.org,
	sashal@kernel.org
Cc: hvilleneuve@dimonoff.com,
	hui.wang@canonical.com
Subject: [stable-kernel][5.15.y][PATCH 5/5] serial: sc16is7xx: change EFR lock to operate on each channels
Date: Wed, 11 Dec 2024 12:25:44 +0800
Message-Id: <20241211042545.202482-6-hui.wang@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241211042545.202482-1-hui.wang@canonical.com>
References: <20241211042545.202482-1-hui.wang@canonical.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 4409df5866b7ff7686ba27e449ca97a92ee063c9 upstream.

Now that the driver has been converted to use one regmap per port, change
efr locking to operate on a channel basis instead of on the whole IC.

[Hui: fixed some conflict when backporting to 5.15.y]

Fixes: 3837a0379533 ("serial: sc16is7xx: improve regmap debugfs by using one regmap per port")
Cc:  <stable@vger.kernel.org> # 6.1.x: 3837a03 serial: sc16is7xx: improve regmap debugfs by using one regmap per port
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231211171353.2901416-5-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 drivers/tty/serial/sc16is7xx.c | 41 +++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index a2d05dd5a339..692c14d7f7d1 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -314,6 +314,7 @@ struct sc16is7xx_one_config {
 struct sc16is7xx_one {
 	struct uart_port		port;
 	struct regmap			*regmap;
+	struct mutex			efr_lock; /* EFR registers access */
 	struct kthread_work		tx_work;
 	struct kthread_work		reg_work;
 	struct sc16is7xx_one_config	config;
@@ -329,7 +330,6 @@ struct sc16is7xx_port {
 	unsigned char			buf[SC16IS7XX_FIFO_SIZE];
 	struct kthread_worker		kworker;
 	struct task_struct		*kworker_task;
-	struct mutex			efr_lock;
 	struct sc16is7xx_one		p[];
 };
 
@@ -491,7 +491,6 @@ static bool sc16is7xx_regmap_noinc(struct device *dev, unsigned int reg)
  */
 static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 {
-	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
 	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 	u8 lcr;
 	unsigned int prescaler = 1;
@@ -515,7 +514,7 @@ static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 	 * because the bulk of the interrupt processing is run as a workqueue
 	 * job in thread context.
 	 */
-	mutex_lock(&s->efr_lock);
+	mutex_lock(&one->efr_lock);
 
 	lcr = sc16is7xx_port_read(port, SC16IS7XX_LCR_REG);
 
@@ -532,7 +531,7 @@ static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 	/* Put LCR back to the normal mode */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, lcr);
 
-	mutex_unlock(&s->efr_lock);
+	mutex_unlock(&one->efr_lock);
 
 	/* If bit MCR_CLKSEL is set, the divide by 4 prescaler is activated. */
 	sc16is7xx_port_update(port, SC16IS7XX_MCR_REG,
@@ -680,14 +679,20 @@ static void sc16is7xx_handle_tx(struct uart_port *port)
 
 static bool sc16is7xx_port_irq(struct sc16is7xx_port *s, int portno)
 {
+	bool rc = true;
 	struct uart_port *port = &s->p[portno].port;
+	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
+
+	mutex_lock(&one->efr_lock);
 
 	do {
 		unsigned int iir, rxlen;
 
 		iir = sc16is7xx_port_read(port, SC16IS7XX_IIR_REG);
-		if (iir & SC16IS7XX_IIR_NO_INT_BIT)
-			return false;
+		if (iir & SC16IS7XX_IIR_NO_INT_BIT) {
+			rc = false;
+			goto out_port_irq;
+		}
 
 		iir &= SC16IS7XX_IIR_ID_MASK;
 
@@ -722,15 +727,17 @@ static bool sc16is7xx_port_irq(struct sc16is7xx_port *s, int portno)
 			break;
 		}
 	} while (0);
-	return true;
+
+out_port_irq:
+	mutex_unlock(&one->efr_lock);
+
+	return rc;
 }
 
 static irqreturn_t sc16is7xx_irq(int irq, void *dev_id)
 {
 	struct sc16is7xx_port *s = (struct sc16is7xx_port *)dev_id;
 
-	mutex_lock(&s->efr_lock);
-
 	while (1) {
 		bool keep_polling = false;
 		int i;
@@ -741,23 +748,21 @@ static irqreturn_t sc16is7xx_irq(int irq, void *dev_id)
 			break;
 	}
 
-	mutex_unlock(&s->efr_lock);
-
 	return IRQ_HANDLED;
 }
 
 static void sc16is7xx_tx_proc(struct kthread_work *ws)
 {
 	struct uart_port *port = &(to_sc16is7xx_one(ws, tx_work)->port);
-	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
+	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 
 	if ((port->rs485.flags & SER_RS485_ENABLED) &&
 	    (port->rs485.delay_rts_before_send > 0))
 		msleep(port->rs485.delay_rts_before_send);
 
-	mutex_lock(&s->efr_lock);
+	mutex_lock(&one->efr_lock);
 	sc16is7xx_handle_tx(port);
-	mutex_unlock(&s->efr_lock);
+	mutex_unlock(&one->efr_lock);
 }
 
 static void sc16is7xx_reconf_rs485(struct uart_port *port)
@@ -878,7 +883,6 @@ static void sc16is7xx_set_termios(struct uart_port *port,
 				  struct ktermios *termios,
 				  struct ktermios *old)
 {
-	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
 	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 	unsigned int lcr, flow = 0;
 	int baud;
@@ -934,7 +938,7 @@ static void sc16is7xx_set_termios(struct uart_port *port,
 		port->ignore_status_mask |= SC16IS7XX_LSR_BRK_ERROR_MASK;
 
 	/* As above, claim the mutex while accessing the EFR. */
-	mutex_lock(&s->efr_lock);
+	mutex_lock(&one->efr_lock);
 
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG,
 			     SC16IS7XX_LCR_CONF_MODE_B);
@@ -957,7 +961,7 @@ static void sc16is7xx_set_termios(struct uart_port *port,
 	/* Update LCR register */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, lcr);
 
-	mutex_unlock(&s->efr_lock);
+	mutex_unlock(&one->efr_lock);
 
 	/* Get baud rate generator configuration */
 	baud = uart_get_baud_rate(port, termios, old,
@@ -1261,7 +1265,6 @@ static int sc16is7xx_probe(struct device *dev,
 
 	s->devtype = devtype;
 	dev_set_drvdata(dev, s);
-	mutex_init(&s->efr_lock);
 
 	kthread_init_worker(&s->kworker);
 	s->kworker_task = kthread_run(kthread_worker_fn, &s->kworker,
@@ -1302,6 +1305,8 @@ static int sc16is7xx_probe(struct device *dev,
 			goto out_ports;
 		}
 
+		mutex_init(&s->p[i].efr_lock);
+
 		/* Disable all interrupts */
 		sc16is7xx_port_write(&s->p[i].port, SC16IS7XX_IER_REG, 0);
 		/* Disable TX/RX */
-- 
2.34.1

