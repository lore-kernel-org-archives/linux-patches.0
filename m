Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3E22F5E;
	Tue, 12 Aug 2025 18:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021856; cv=none; b=DYfdoAIprCsFLQr7v74Cm0IYIRv2aDfYTWdT4Z/na96ZxB2opf3bkqNQNGb162mt4aTZAujU7qejTHGRf34d0fjkvHv1C9yQ6oN61YwpVVGIJ5ukjVwgkCfmgLBwK1PlYsIPyKulm3Rul/1bxIzzha4gCsyFZdfmLMWieDvSLGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021856; c=relaxed/simple;
	bh=kQTPk4j5JjZsxt+TJC4ChRYNTioWVpZsbfNHsNnG3KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLOTk6ZGismYSs4Ap0KMguCqzmDt2RSnBIRA6ED+whmGoHpUX3RH1gHfZIo1tIkMm2i9YJZFmYI2FuvCrbK+R4wo5fodbie17Merdg5WXf7B5Mj/uukdJ8O/3xeKB4/4C7VYXISXPIvS4pWzkhRfUPaYeTEZJRDRge3iLyy67cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LuXwqTI9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LuXwqTI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F120AC4CEF0;
	Tue, 12 Aug 2025 18:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021856;
	bh=kQTPk4j5JjZsxt+TJC4ChRYNTioWVpZsbfNHsNnG3KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LuXwqTI9WVYv/sqJRLfHq8Erh6zlq1IJ+384CfO0Q8XjrSzIUhFPN0ZSlqVpOcsM9
	 PwJ4FjOAqTEEZ57e0++Aa9DiScDk9kzKcW2fKleHU6E3x80DpHa2oOU50LQozV0mbF
	 wmRTgQCMgi3hopb7VbYk0D4nBqHYFGAdfvLbzYNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Volmat <alain.volmat@foss.st.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 245/262] i2c: stm32f7: perform most of irq job in threaded handler
Date: Tue, 12 Aug 2025 19:30:33 +0200
Message-ID: <20250812173003.582819818@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alain Volmat <alain.volmat@foss.st.com>

[ Upstream commit e6103cd45ef0e14eb02f0666bc6b494902cfe821 ]

The irq handling is currently split between the irq handler
and the threaded irq handler.  Some of the handling (such as
dma related stuffs) done within the irq handler might sleep or
take some time leading to issues if the kernel is built with
realtime constraints.  In order to fix that, perform an overall
rework to perform most of the job within the threaded handler
and only keep fifo access in the non threaded handler.

Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 6aae87fe7f18 ("i2c: stm32f7: unmap DMA mapped buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-stm32f7.c |  126 +++++++++++++++++----------------------
 1 file changed, 56 insertions(+), 70 deletions(-)

--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -1496,17 +1496,11 @@ static irqreturn_t stm32f7_i2c_slave_isr
 static irqreturn_t stm32f7_i2c_isr_event(int irq, void *data)
 {
 	struct stm32f7_i2c_dev *i2c_dev = data;
-	struct stm32f7_i2c_msg *f7_msg = &i2c_dev->f7_msg;
-	struct stm32_i2c_dma *dma = i2c_dev->dma;
-	void __iomem *base = i2c_dev->base;
-	u32 status, mask;
-	int ret = IRQ_HANDLED;
+	u32 status;
 
-	/* Check if the interrupt if for a slave device */
-	if (!i2c_dev->master_mode) {
-		ret = stm32f7_i2c_slave_isr_event(i2c_dev);
-		return ret;
-	}
+	/* Check if the interrupt is for a slave device */
+	if (!i2c_dev->master_mode)
+		return IRQ_WAKE_THREAD;
 
 	status = readl_relaxed(i2c_dev->base + STM32F7_I2C_ISR);
 
@@ -1518,6 +1512,29 @@ static irqreturn_t stm32f7_i2c_isr_event
 	if (status & STM32F7_I2C_ISR_RXNE)
 		stm32f7_i2c_read_rx_data(i2c_dev);
 
+	/* Wake up the thread if other flags are raised */
+	if (status &
+	    (STM32F7_I2C_ISR_NACKF | STM32F7_I2C_ISR_STOPF |
+	     STM32F7_I2C_ISR_TC | STM32F7_I2C_ISR_TCR))
+		return IRQ_WAKE_THREAD;
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t stm32f7_i2c_isr_event_thread(int irq, void *data)
+{
+	struct stm32f7_i2c_dev *i2c_dev = data;
+	struct stm32f7_i2c_msg *f7_msg = &i2c_dev->f7_msg;
+	struct stm32_i2c_dma *dma = i2c_dev->dma;
+	void __iomem *base = i2c_dev->base;
+	u32 status, mask;
+	int ret;
+
+	if (!i2c_dev->master_mode)
+		return stm32f7_i2c_slave_isr_event(i2c_dev);
+
+	status = readl_relaxed(i2c_dev->base + STM32F7_I2C_ISR);
+
 	/* NACK received */
 	if (status & STM32F7_I2C_ISR_NACKF) {
 		dev_dbg(i2c_dev->dev, "<%s>: Receive NACK (addr %x)\n",
@@ -1530,33 +1547,28 @@ static irqreturn_t stm32f7_i2c_isr_event
 		f7_msg->result = -ENXIO;
 	}
 
-	/* STOP detection flag */
-	if (status & STM32F7_I2C_ISR_STOPF) {
-		/* Disable interrupts */
-		if (stm32f7_i2c_is_slave_registered(i2c_dev))
-			mask = STM32F7_I2C_XFER_IRQ_MASK;
+	if (status & STM32F7_I2C_ISR_TCR) {
+		if (f7_msg->smbus)
+			stm32f7_i2c_smbus_reload(i2c_dev);
 		else
-			mask = STM32F7_I2C_ALL_IRQ_MASK;
-		stm32f7_i2c_disable_irq(i2c_dev, mask);
-
-		/* Clear STOP flag */
-		writel_relaxed(STM32F7_I2C_ICR_STOPCF, base + STM32F7_I2C_ICR);
-
-		if (i2c_dev->use_dma && !f7_msg->result) {
-			ret = IRQ_WAKE_THREAD;
-		} else {
-			i2c_dev->master_mode = false;
-			complete(&i2c_dev->complete);
-		}
+			stm32f7_i2c_reload(i2c_dev);
 	}
 
 	/* Transfer complete */
 	if (status & STM32F7_I2C_ISR_TC) {
+		/* Wait for dma transfer completion before sending next message */
+		if (i2c_dev->use_dma && !f7_msg->result) {
+			ret = wait_for_completion_timeout(&i2c_dev->dma->dma_complete, HZ);
+			if (!ret) {
+				dev_dbg(i2c_dev->dev, "<%s>: Timed out\n", __func__);
+				stm32f7_i2c_disable_dma_req(i2c_dev);
+				dmaengine_terminate_async(dma->chan_using);
+				f7_msg->result = -ETIMEDOUT;
+			}
+		}
 		if (f7_msg->stop) {
 			mask = STM32F7_I2C_CR2_STOP;
 			stm32f7_i2c_set_bits(base + STM32F7_I2C_CR2, mask);
-		} else if (i2c_dev->use_dma && !f7_msg->result) {
-			ret = IRQ_WAKE_THREAD;
 		} else if (f7_msg->smbus) {
 			stm32f7_i2c_smbus_rep_start(i2c_dev);
 		} else {
@@ -1566,47 +1578,18 @@ static irqreturn_t stm32f7_i2c_isr_event
 		}
 	}
 
-	if (status & STM32F7_I2C_ISR_TCR) {
-		if (f7_msg->smbus)
-			stm32f7_i2c_smbus_reload(i2c_dev);
+	/* STOP detection flag */
+	if (status & STM32F7_I2C_ISR_STOPF) {
+		/* Disable interrupts */
+		if (stm32f7_i2c_is_slave_registered(i2c_dev))
+			mask = STM32F7_I2C_XFER_IRQ_MASK;
 		else
-			stm32f7_i2c_reload(i2c_dev);
-	}
-
-	return ret;
-}
-
-static irqreturn_t stm32f7_i2c_isr_event_thread(int irq, void *data)
-{
-	struct stm32f7_i2c_dev *i2c_dev = data;
-	struct stm32f7_i2c_msg *f7_msg = &i2c_dev->f7_msg;
-	struct stm32_i2c_dma *dma = i2c_dev->dma;
-	u32 status;
-	int ret;
-
-	/*
-	 * Wait for dma transfer completion before sending next message or
-	 * notity the end of xfer to the client
-	 */
-	ret = wait_for_completion_timeout(&i2c_dev->dma->dma_complete, HZ);
-	if (!ret) {
-		dev_dbg(i2c_dev->dev, "<%s>: Timed out\n", __func__);
-		stm32f7_i2c_disable_dma_req(i2c_dev);
-		dmaengine_terminate_async(dma->chan_using);
-		f7_msg->result = -ETIMEDOUT;
-	}
+			mask = STM32F7_I2C_ALL_IRQ_MASK;
+		stm32f7_i2c_disable_irq(i2c_dev, mask);
 
-	status = readl_relaxed(i2c_dev->base + STM32F7_I2C_ISR);
+		/* Clear STOP flag */
+		writel_relaxed(STM32F7_I2C_ICR_STOPCF, base + STM32F7_I2C_ICR);
 
-	if (status & STM32F7_I2C_ISR_TC) {
-		if (f7_msg->smbus) {
-			stm32f7_i2c_smbus_rep_start(i2c_dev);
-		} else {
-			i2c_dev->msg_id++;
-			i2c_dev->msg++;
-			stm32f7_i2c_xfer_msg(i2c_dev, i2c_dev->msg);
-		}
-	} else {
 		i2c_dev->master_mode = false;
 		complete(&i2c_dev->complete);
 	}
@@ -1614,7 +1597,7 @@ static irqreturn_t stm32f7_i2c_isr_event
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t stm32f7_i2c_isr_error(int irq, void *data)
+static irqreturn_t stm32f7_i2c_isr_error_thread(int irq, void *data)
 {
 	struct stm32f7_i2c_dev *i2c_dev = data;
 	struct stm32f7_i2c_msg *f7_msg = &i2c_dev->f7_msg;
@@ -2201,8 +2184,11 @@ static int stm32f7_i2c_probe(struct plat
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret, "Failed to request irq event\n");
 
-	ret = devm_request_irq(&pdev->dev, irq_error, stm32f7_i2c_isr_error, 0,
-			       pdev->name, i2c_dev);
+	ret = devm_request_threaded_irq(&pdev->dev, irq_error,
+					NULL,
+					stm32f7_i2c_isr_error_thread,
+					IRQF_ONESHOT,
+					pdev->name, i2c_dev);
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret, "Failed to request irq error\n");
 


