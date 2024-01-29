Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE4872223;
	Mon, 29 Jan 2024 17:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548504; cv=none; b=CFXQcGt4B7LkLFyjvS3n0baCsaN1JiNaUv5KLuGSWliXrwk7NACJ89V3LhLYhaxxEhrwMlxo0R5Wns7UlMPI+FUef+TQRvWEe9xQUqP95081GZzvPk3Rg/LfgJp4fojvbu++/0w5lN79Pf/l4EbguRi/LJZoz1evpI2Cm+Sm1M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548504; c=relaxed/simple;
	bh=k4QGPme5E0u6cxFIySPE5UuULOJHrCsUfZRT7qrt5Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/kJT2AdntnUrIVcjOI2jRBuaYonRrrtoqW4PGIpe1qHdouedlywKUhyx2ttyb6xaRl4xHKLVLewEcaUCACAdboVEmBf5G8ZnhH0ShUhlnuIujL/btam4ZAyB3A0qP9p/CfLo7/56z8zrL4oLOUYZoxVMW4Yuh2uMyvoRFkDBi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cM9RnE1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cM9RnE1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269A8C43394;
	Mon, 29 Jan 2024 17:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548504;
	bh=k4QGPme5E0u6cxFIySPE5UuULOJHrCsUfZRT7qrt5Bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cM9RnE1oybFC5/HGpiPM0MTxvyAFbEGgl4PAc+2vaGmSYRW2RVD2IcwNeQmRecFjb
	 roFA8UIptwLvyy0Pv/jvsgocsSj+j+GX8+TZXgDroXOYxf/Xy4cOBfSH1M0LdqBN7E
	 LY9U3ROdy4G1PzNZoyi3P0DIkF5RKhvlwcfri8s0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.6 132/331] serial: sc16is7xx: change EFR lock to operate on each channels
Date: Mon, 29 Jan 2024 09:03:16 -0800
Message-ID: <20240129170018.806832435@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 4409df5866b7ff7686ba27e449ca97a92ee063c9 upstream.

Now that the driver has been converted to use one regmap per port, change
efr locking to operate on a channel basis instead of on the whole IC.

Fixes: 3837a0379533 ("serial: sc16is7xx: improve regmap debugfs by using one regmap per port")
Cc:  <stable@vger.kernel.org> # 6.1.x: 3837a03 serial: sc16is7xx: improve regmap debugfs by using one regmap per port
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231211171353.2901416-5-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |   49 +++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 23 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -324,6 +324,7 @@ struct sc16is7xx_one_config {
 struct sc16is7xx_one {
 	struct uart_port		port;
 	struct regmap			*regmap;
+	struct mutex			efr_lock; /* EFR registers access */
 	struct kthread_work		tx_work;
 	struct kthread_work		reg_work;
 	struct kthread_delayed_work	ms_work;
@@ -343,7 +344,6 @@ struct sc16is7xx_port {
 	unsigned char			buf[SC16IS7XX_FIFO_SIZE];
 	struct kthread_worker		kworker;
 	struct task_struct		*kworker_task;
-	struct mutex			efr_lock;
 	struct sc16is7xx_one		p[];
 };
 
@@ -496,7 +496,6 @@ static bool sc16is7xx_regmap_precious(st
 
 static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 {
-	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
 	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 	u8 lcr;
 	u8 prescaler = 0;
@@ -520,7 +519,7 @@ static int sc16is7xx_set_baud(struct uar
 	 * because the bulk of the interrupt processing is run as a workqueue
 	 * job in thread context.
 	 */
-	mutex_lock(&s->efr_lock);
+	mutex_lock(&one->efr_lock);
 
 	lcr = sc16is7xx_port_read(port, SC16IS7XX_LCR_REG);
 
@@ -539,7 +538,7 @@ static int sc16is7xx_set_baud(struct uar
 	/* Put LCR back to the normal mode */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, lcr);
 
-	mutex_unlock(&s->efr_lock);
+	mutex_unlock(&one->efr_lock);
 
 	sc16is7xx_port_update(port, SC16IS7XX_MCR_REG,
 			      SC16IS7XX_MCR_CLKSEL_BIT,
@@ -707,11 +706,10 @@ static unsigned int sc16is7xx_get_hwmctr
 static void sc16is7xx_update_mlines(struct sc16is7xx_one *one)
 {
 	struct uart_port *port = &one->port;
-	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
 	unsigned long flags;
 	unsigned int status, changed;
 
-	lockdep_assert_held_once(&s->efr_lock);
+	lockdep_assert_held_once(&one->efr_lock);
 
 	status = sc16is7xx_get_hwmctrl(port);
 	changed = status ^ one->old_mctrl;
@@ -737,15 +735,20 @@ static void sc16is7xx_update_mlines(stru
 
 static bool sc16is7xx_port_irq(struct sc16is7xx_port *s, int portno)
 {
+	bool rc = true;
 	struct uart_port *port = &s->p[portno].port;
+	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
+
+	mutex_lock(&one->efr_lock);
 
 	do {
 		unsigned int iir, rxlen;
-		struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 
 		iir = sc16is7xx_port_read(port, SC16IS7XX_IIR_REG);
-		if (iir & SC16IS7XX_IIR_NO_INT_BIT)
-			return false;
+		if (iir & SC16IS7XX_IIR_NO_INT_BIT) {
+			rc = false;
+			goto out_port_irq;
+		}
 
 		iir &= SC16IS7XX_IIR_ID_MASK;
 
@@ -785,15 +788,17 @@ static bool sc16is7xx_port_irq(struct sc
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
@@ -804,24 +809,22 @@ static irqreturn_t sc16is7xx_irq(int irq
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
 	unsigned long flags;
 
 	if ((port->rs485.flags & SER_RS485_ENABLED) &&
 	    (port->rs485.delay_rts_before_send > 0))
 		msleep(port->rs485.delay_rts_before_send);
 
-	mutex_lock(&s->efr_lock);
+	mutex_lock(&one->efr_lock);
 	sc16is7xx_handle_tx(port);
-	mutex_unlock(&s->efr_lock);
+	mutex_unlock(&one->efr_lock);
 
 	spin_lock_irqsave(&port->lock, flags);
 	sc16is7xx_ier_set(port, SC16IS7XX_IER_THRI_BIT);
@@ -928,9 +931,9 @@ static void sc16is7xx_ms_proc(struct kth
 	struct sc16is7xx_port *s = dev_get_drvdata(one->port.dev);
 
 	if (one->port.state) {
-		mutex_lock(&s->efr_lock);
+		mutex_lock(&one->efr_lock);
 		sc16is7xx_update_mlines(one);
-		mutex_unlock(&s->efr_lock);
+		mutex_unlock(&one->efr_lock);
 
 		kthread_queue_delayed_work(&s->kworker, &one->ms_work, HZ);
 	}
@@ -1014,7 +1017,6 @@ static void sc16is7xx_set_termios(struct
 				  struct ktermios *termios,
 				  const struct ktermios *old)
 {
-	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
 	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 	unsigned int lcr, flow = 0;
 	int baud;
@@ -1073,7 +1075,7 @@ static void sc16is7xx_set_termios(struct
 		port->ignore_status_mask |= SC16IS7XX_LSR_BRK_ERROR_MASK;
 
 	/* As above, claim the mutex while accessing the EFR. */
-	mutex_lock(&s->efr_lock);
+	mutex_lock(&one->efr_lock);
 
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG,
 			     SC16IS7XX_LCR_CONF_MODE_B);
@@ -1103,7 +1105,7 @@ static void sc16is7xx_set_termios(struct
 	/* Update LCR register */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, lcr);
 
-	mutex_unlock(&s->efr_lock);
+	mutex_unlock(&one->efr_lock);
 
 	/* Get baud rate generator configuration */
 	baud = uart_get_baud_rate(port, termios, old,
@@ -1514,7 +1516,6 @@ static int sc16is7xx_probe(struct device
 
 	s->devtype = devtype;
 	dev_set_drvdata(dev, s);
-	mutex_init(&s->efr_lock);
 
 	kthread_init_worker(&s->kworker);
 	s->kworker_task = kthread_run(kthread_worker_fn, &s->kworker,
@@ -1557,6 +1558,8 @@ static int sc16is7xx_probe(struct device
 			goto out_ports;
 		}
 
+		mutex_init(&s->p[i].efr_lock);
+
 		ret = uart_get_rs485_mode(&s->p[i].port);
 		if (ret)
 			goto out_ports;


