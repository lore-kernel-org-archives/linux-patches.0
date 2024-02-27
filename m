Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1F013AA4C;
	Tue, 27 Feb 2024 14:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043110; cv=none; b=cPre4MprdqzRc2TqTZ+yHMwVPB6Goz41oRjogIy8YTkozcNWIpMPUNI9KYdenk6MyyoGs4HnBSQj2v283wun5JOHYLfDFVR8EW7xPAbMLZaNR8wptIiKhGqheeYIAq2ehvkKP6RqlKrHx0nW/ewj3eZoUMNP75PZZf3gCRFpz6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043110; c=relaxed/simple;
	bh=cFvEMQWrF0beEyecdy77gVZC88Oq0crX7Ttu5PT1Hoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDFPy0DW60sMKf0XHmqmC7Is9VJZRyJyuaz0YKjyir/xTPIp0wDw5vWPNkW4kiB+Y2JlDB4mbgwz0PzX6Cn5vZRQRaIhuPCOR2Xw1xyC9oNhOuutkBK5HQp6GnJzJwbleZhlJvPhkrW+nT1CbsfgKEXl+Z0PnWsNGdAZ9PnZQwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0I3a7eO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0I3a7eO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBDBC433F1;
	Tue, 27 Feb 2024 14:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043110;
	bh=cFvEMQWrF0beEyecdy77gVZC88Oq0crX7Ttu5PT1Hoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0I3a7eOv3O6Tmj6+CWHleLkLAJkGO+sCAQ+SnLJtPzBtPj/xz5d37HXLbZ6nz8vh
	 c4xvs69W8WEn/CvMdUXFHwPjih8bEALMqqgIFpDPFP0CQJtW6Wv6xlWozhNaCHYsAP
	 X55XUYOdMISiRRK5ShW2VqWq1ys7pKuoB+rS9pU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <minyard@acm.org>,
	Andrew Manley <andrew.manley@sealingtech.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 237/245] i2c: imx: Add timer for handling the stop condition
Date: Tue, 27 Feb 2024 14:27:05 +0100
Message-ID: <20240227131622.870343372@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Minyard <minyard@acm.org>

[ Upstream commit f89bf95632b41695402996d96476c44c641d23d7 ]

Most IMX I2C interfaces don't generate an interrupt on a stop condition,
so it won't generate a timely stop event on a slave mode transfer.
Some users, like IPMB, need a timely stop event to work properly.

So, add a timer and add the proper handling to generate a stop event in
slave mode if the interface goes idle.

Signed-off-by: Corey Minyard <minyard@acm.org>
Tested-by: Andrew Manley <andrew.manley@sealingtech.com>
Reviewed-by: Andrew Manley <andrew.manley@sealingtech.com>
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 87aec499368d ("i2c: imx: when being a target, mark the last read as processed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-imx.c | 92 ++++++++++++++++++++++++++++--------
 1 file changed, 73 insertions(+), 19 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index 5e8853d3f8da7..d545547c89ca7 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -37,6 +37,8 @@
 #include <linux/io.h>
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/hrtimer.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -51,6 +53,8 @@
 /* This will be the driver name the kernel reports */
 #define DRIVER_NAME "imx-i2c"
 
+#define I2C_IMX_CHECK_DELAY 30000 /* Time to check for bus idle, in NS */
+
 /*
  * Enable DMA if transfer byte size is bigger than this threshold.
  * As the hardware request, it must bigger than 4 bytes.\
@@ -210,6 +214,10 @@ struct imx_i2c_struct {
 	struct imx_i2c_dma	*dma;
 	struct i2c_client	*slave;
 	enum i2c_slave_event last_slave_event;
+
+	/* For checking slave events. */
+	spinlock_t     slave_lock;
+	struct hrtimer slave_timer;
 };
 
 static const struct imx_i2c_hwdata imx1_i2c_hwdata = {
@@ -680,7 +688,7 @@ static void i2c_imx_slave_event(struct imx_i2c_struct *i2c_imx,
 
 static void i2c_imx_slave_finish_op(struct imx_i2c_struct *i2c_imx)
 {
-	u8 val;
+	u8 val = 0;
 
 	while (i2c_imx->last_slave_event != I2C_SLAVE_STOP) {
 		switch (i2c_imx->last_slave_event) {
@@ -701,10 +709,11 @@ static void i2c_imx_slave_finish_op(struct imx_i2c_struct *i2c_imx)
 	}
 }
 
-static irqreturn_t i2c_imx_slave_isr(struct imx_i2c_struct *i2c_imx,
-				     unsigned int status, unsigned int ctl)
+/* Returns true if the timer should be restarted, false if not. */
+static irqreturn_t i2c_imx_slave_handle(struct imx_i2c_struct *i2c_imx,
+					unsigned int status, unsigned int ctl)
 {
-	u8 value;
+	u8 value = 0;
 
 	if (status & I2SR_IAL) { /* Arbitration lost */
 		i2c_imx_clear_irq(i2c_imx, I2SR_IAL);
@@ -712,6 +721,16 @@ static irqreturn_t i2c_imx_slave_isr(struct imx_i2c_struct *i2c_imx,
 			return IRQ_HANDLED;
 	}
 
+	if (!(status & I2SR_IBB)) {
+		/* No master on the bus, that could mean a stop condition. */
+		i2c_imx_slave_finish_op(i2c_imx);
+		return IRQ_HANDLED;
+	}
+
+	if (!(status & I2SR_ICF))
+		/* Data transfer still in progress, ignore this. */
+		goto out;
+
 	if (status & I2SR_IAAS) { /* Addressed as a slave */
 		i2c_imx_slave_finish_op(i2c_imx);
 		if (status & I2SR_SRW) { /* Master wants to read from us*/
@@ -737,16 +756,9 @@ static irqreturn_t i2c_imx_slave_isr(struct imx_i2c_struct *i2c_imx,
 			imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
 		}
 	} else if (!(ctl & I2CR_MTX)) { /* Receive mode */
-		if (status & I2SR_IBB) { /* No STOP signal detected */
-			value = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
-			i2c_imx_slave_event(i2c_imx,
-					    I2C_SLAVE_WRITE_RECEIVED, &value);
-		} else { /* STOP signal is detected */
-			dev_dbg(&i2c_imx->adapter.dev,
-				"STOP signal detected");
-			i2c_imx_slave_event(i2c_imx,
-					    I2C_SLAVE_STOP, &value);
-		}
+		value = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
+		i2c_imx_slave_event(i2c_imx,
+				    I2C_SLAVE_WRITE_RECEIVED, &value);
 	} else if (!(status & I2SR_RXAK)) { /* Transmit mode received ACK */
 		ctl |= I2CR_MTX;
 		imx_i2c_write_reg(ctl, i2c_imx, IMX_I2C_I2CR);
@@ -755,15 +767,43 @@ static irqreturn_t i2c_imx_slave_isr(struct imx_i2c_struct *i2c_imx,
 				    I2C_SLAVE_READ_PROCESSED, &value);
 
 		imx_i2c_write_reg(value, i2c_imx, IMX_I2C_I2DR);
-	} else { /* Transmit mode received NAK */
+	} else { /* Transmit mode received NAK, operation is done */
 		ctl &= ~I2CR_MTX;
 		imx_i2c_write_reg(ctl, i2c_imx, IMX_I2C_I2CR);
 		imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
+		i2c_imx_slave_finish_op(i2c_imx);
+		return IRQ_HANDLED;
 	}
 
+out:
+	/*
+	 * No need to check the return value here.  If it returns 0 or
+	 * 1, then everything is fine.  If it returns -1, then the
+	 * timer is running in the handler.  This will still work,
+	 * though it may be redone (or already have been done) by the
+	 * timer function.
+	 */
+	hrtimer_try_to_cancel(&i2c_imx->slave_timer);
+	hrtimer_forward_now(&i2c_imx->slave_timer, I2C_IMX_CHECK_DELAY);
+	hrtimer_restart(&i2c_imx->slave_timer);
 	return IRQ_HANDLED;
 }
 
+static enum hrtimer_restart i2c_imx_slave_timeout(struct hrtimer *t)
+{
+	struct imx_i2c_struct *i2c_imx = container_of(t, struct imx_i2c_struct,
+						      slave_timer);
+	unsigned int ctl, status;
+	unsigned long flags;
+
+	spin_lock_irqsave(&i2c_imx->slave_lock, flags);
+	status = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
+	ctl = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
+	i2c_imx_slave_handle(i2c_imx, status, ctl);
+	spin_unlock_irqrestore(&i2c_imx->slave_lock, flags);
+	return HRTIMER_NORESTART;
+}
+
 static void i2c_imx_slave_init(struct imx_i2c_struct *i2c_imx)
 {
 	int temp;
@@ -843,7 +883,9 @@ static irqreturn_t i2c_imx_isr(int irq, void *dev_id)
 {
 	struct imx_i2c_struct *i2c_imx = dev_id;
 	unsigned int ctl, status;
+	unsigned long flags;
 
+	spin_lock_irqsave(&i2c_imx->slave_lock, flags);
 	status = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
 	ctl = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
 
@@ -851,14 +893,20 @@ static irqreturn_t i2c_imx_isr(int irq, void *dev_id)
 		i2c_imx_clear_irq(i2c_imx, I2SR_IIF);
 		if (i2c_imx->slave) {
 			if (!(ctl & I2CR_MSTA)) {
-				return i2c_imx_slave_isr(i2c_imx, status, ctl);
-			} else if (i2c_imx->last_slave_event !=
-				   I2C_SLAVE_STOP) {
-				i2c_imx_slave_finish_op(i2c_imx);
+				irqreturn_t ret;
+
+				ret = i2c_imx_slave_handle(i2c_imx,
+							   status, ctl);
+				spin_unlock_irqrestore(&i2c_imx->slave_lock,
+						       flags);
+				return ret;
 			}
+			i2c_imx_slave_finish_op(i2c_imx);
 		}
+		spin_unlock_irqrestore(&i2c_imx->slave_lock, flags);
 		return i2c_imx_master_isr(i2c_imx, status);
 	}
+	spin_unlock_irqrestore(&i2c_imx->slave_lock, flags);
 
 	return IRQ_NONE;
 }
@@ -1380,6 +1428,10 @@ static int i2c_imx_probe(struct platform_device *pdev)
 	if (!i2c_imx)
 		return -ENOMEM;
 
+	spin_lock_init(&i2c_imx->slave_lock);
+	hrtimer_init(&i2c_imx->slave_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	i2c_imx->slave_timer.function = i2c_imx_slave_timeout;
+
 	match = device_get_match_data(&pdev->dev);
 	if (match)
 		i2c_imx->hwdata = match;
@@ -1491,6 +1543,8 @@ static int i2c_imx_remove(struct platform_device *pdev)
 
 	ret = pm_runtime_get_sync(&pdev->dev);
 
+	hrtimer_cancel(&i2c_imx->slave_timer);
+
 	/* remove adapter */
 	dev_dbg(&i2c_imx->adapter.dev, "adapter removed\n");
 	i2c_del_adapter(&i2c_imx->adapter);
-- 
2.43.0



