Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120CD153828;
	Thu, 13 Feb 2025 15:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460959; cv=none; b=ksJDmJLQcFoafhquRMkwpiIn6MlmEIkGY+8U68t3g5OKQ2za/vMp052TGL/crU64OXjg+9867/2xwBBWs+G4wVzlf/w6jI0U8uWFPk5s0EsEykWmx84iz5aIUukH3JJz7lLc19Eld4YPFeRWSnqtZKV/ti7NMBDdRztxphUJVPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460959; c=relaxed/simple;
	bh=0nIY21ILBkoNPTGW/Bqx57JIoRyA+owwuUSH2xZnhrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SlbuqpJfd1/jckH/0lqVz4jPYBfOLEktq/J/j7wZcpEI1+N/aQvNw7H1Mnb5igR+dIdFGIixjRQmqMo5gXOH3EgeSC1qJdQsAqBh6sWnyqP/iULbt+cH+rdoOwAmdjV9O7KgU2NFG+jHFjzxUSfbglDA83bd/aHdF6BWnaGKFZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhHupqZQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhHupqZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9BBC4CED1;
	Thu, 13 Feb 2025 15:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460958;
	bh=0nIY21ILBkoNPTGW/Bqx57JIoRyA+owwuUSH2xZnhrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AhHupqZQd90P2uf/Pl7OrZ1LzAhcY1OAHOaxB2YM1K25RJW7eCdiV1mxr4vFWz6D3
	 tQWH46v1YT/h4l8I71fMinsANJpcmLqHJyPM9B7vtu9PDfMNK0Nb1zgAnwIP73xYyB
	 hmLdho/bCeLmZWwFtp4I+yQ5EAti9Ch11m+N75kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 260/273] spi: atmel-quadspi: Create `atmel_qspi_ops` to support newer SoC families
Date: Thu, 13 Feb 2025 15:30:32 +0100
Message-ID: <20250213142417.693211460@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Csókás, Bence <csokas.bence@prolan.hu>

commit c0a0203cf57963792d59b3e4317a1d07b73df42a upstream.

Refactor the code to introduce an ops struct, to prepare for merging
support for later SoCs, such as SAMA7G5. This code was based on the
vendor's kernel (linux4microchip). Cc'ing original contributors.

Signed-off-by: Csókás, Bence <csokas.bence@prolan.hu>
Link: https://patch.msgid.link/20241128174316.3209354-2-csokas.bence@prolan.hu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/atmel-quadspi.c |  111 ++++++++++++++++++++++++++++++--------------
 1 file changed, 77 insertions(+), 34 deletions(-)

--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -138,11 +138,15 @@
 #define QSPI_WPSR_WPVSRC_MASK           GENMASK(15, 8)
 #define QSPI_WPSR_WPVSRC(src)           (((src) << 8) & QSPI_WPSR_WPVSRC)
 
+#define ATMEL_QSPI_TIMEOUT		1000	/* ms */
+
 struct atmel_qspi_caps {
 	bool has_qspick;
 	bool has_ricr;
 };
 
+struct atmel_qspi_ops;
+
 struct atmel_qspi {
 	void __iomem		*regs;
 	void __iomem		*mem;
@@ -150,13 +154,22 @@ struct atmel_qspi {
 	struct clk		*qspick;
 	struct platform_device	*pdev;
 	const struct atmel_qspi_caps *caps;
+	const struct atmel_qspi_ops *ops;
 	resource_size_t		mmap_size;
 	u32			pending;
+	u32			irq_mask;
 	u32			mr;
 	u32			scr;
 	struct completion	cmd_completion;
 };
 
+struct atmel_qspi_ops {
+	int (*set_cfg)(struct atmel_qspi *aq, const struct spi_mem_op *op,
+		       u32 *offset);
+	int (*transfer)(struct spi_mem *mem, const struct spi_mem_op *op,
+			u32 offset);
+};
+
 struct atmel_qspi_mode {
 	u8 cmd_buswidth;
 	u8 addr_buswidth;
@@ -404,10 +417,60 @@ static int atmel_qspi_set_cfg(struct atm
 	return 0;
 }
 
+static int atmel_qspi_wait_for_completion(struct atmel_qspi *aq, u32 irq_mask)
+{
+	int err = 0;
+	u32 sr;
+
+	/* Poll INSTRuction End status */
+	sr = atmel_qspi_read(aq, QSPI_SR);
+	if ((sr & irq_mask) == irq_mask)
+		return 0;
+
+	/* Wait for INSTRuction End interrupt */
+	reinit_completion(&aq->cmd_completion);
+	aq->pending = sr & irq_mask;
+	aq->irq_mask = irq_mask;
+	atmel_qspi_write(irq_mask, aq, QSPI_IER);
+	if (!wait_for_completion_timeout(&aq->cmd_completion,
+					 msecs_to_jiffies(ATMEL_QSPI_TIMEOUT)))
+		err = -ETIMEDOUT;
+	atmel_qspi_write(irq_mask, aq, QSPI_IDR);
+
+	return err;
+}
+
+static int atmel_qspi_transfer(struct spi_mem *mem,
+			       const struct spi_mem_op *op, u32 offset)
+{
+	struct atmel_qspi *aq = spi_controller_get_devdata(mem->spi->controller);
+
+	/* Skip to the final steps if there is no data */
+	if (!op->data.nbytes)
+		return atmel_qspi_wait_for_completion(aq,
+						      QSPI_SR_CMD_COMPLETED);
+
+	/* Dummy read of QSPI_IFR to synchronize APB and AHB accesses */
+	(void)atmel_qspi_read(aq, QSPI_IFR);
+
+	/* Send/Receive data */
+	if (op->data.dir == SPI_MEM_DATA_IN)
+		memcpy_fromio(op->data.buf.in, aq->mem + offset,
+			      op->data.nbytes);
+	else
+		memcpy_toio(aq->mem + offset, op->data.buf.out,
+			    op->data.nbytes);
+
+	/* Release the chip-select */
+	atmel_qspi_write(QSPI_CR_LASTXFER, aq, QSPI_CR);
+
+	return atmel_qspi_wait_for_completion(aq, QSPI_SR_CMD_COMPLETED);
+}
+
 static int atmel_qspi_exec_op(struct spi_mem *mem, const struct spi_mem_op *op)
 {
 	struct atmel_qspi *aq = spi_controller_get_devdata(mem->spi->controller);
-	u32 sr, offset;
+	u32 offset;
 	int err;
 
 	/*
@@ -416,46 +479,20 @@ static int atmel_qspi_exec_op(struct spi
 	 * when the flash memories overrun the controller's memory space.
 	 */
 	if (op->addr.val + op->data.nbytes > aq->mmap_size)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
+
+	if (op->addr.nbytes > 4)
+		return -EOPNOTSUPP;
 
 	err = pm_runtime_resume_and_get(&aq->pdev->dev);
 	if (err < 0)
 		return err;
 
-	err = atmel_qspi_set_cfg(aq, op, &offset);
+	err = aq->ops->set_cfg(aq, op, &offset);
 	if (err)
 		goto pm_runtime_put;
 
-	/* Skip to the final steps if there is no data */
-	if (op->data.nbytes) {
-		/* Dummy read of QSPI_IFR to synchronize APB and AHB accesses */
-		(void)atmel_qspi_read(aq, QSPI_IFR);
-
-		/* Send/Receive data */
-		if (op->data.dir == SPI_MEM_DATA_IN)
-			memcpy_fromio(op->data.buf.in, aq->mem + offset,
-				      op->data.nbytes);
-		else
-			memcpy_toio(aq->mem + offset, op->data.buf.out,
-				    op->data.nbytes);
-
-		/* Release the chip-select */
-		atmel_qspi_write(QSPI_CR_LASTXFER, aq, QSPI_CR);
-	}
-
-	/* Poll INSTRuction End status */
-	sr = atmel_qspi_read(aq, QSPI_SR);
-	if ((sr & QSPI_SR_CMD_COMPLETED) == QSPI_SR_CMD_COMPLETED)
-		goto pm_runtime_put;
-
-	/* Wait for INSTRuction End interrupt */
-	reinit_completion(&aq->cmd_completion);
-	aq->pending = sr & QSPI_SR_CMD_COMPLETED;
-	atmel_qspi_write(QSPI_SR_CMD_COMPLETED, aq, QSPI_IER);
-	if (!wait_for_completion_timeout(&aq->cmd_completion,
-					 msecs_to_jiffies(1000)))
-		err = -ETIMEDOUT;
-	atmel_qspi_write(QSPI_SR_CMD_COMPLETED, aq, QSPI_IDR);
+	err = aq->ops->transfer(mem, op, offset);
 
 pm_runtime_put:
 	pm_runtime_mark_last_busy(&aq->pdev->dev);
@@ -571,12 +608,17 @@ static irqreturn_t atmel_qspi_interrupt(
 		return IRQ_NONE;
 
 	aq->pending |= pending;
-	if ((aq->pending & QSPI_SR_CMD_COMPLETED) == QSPI_SR_CMD_COMPLETED)
+	if ((aq->pending & aq->irq_mask) == aq->irq_mask)
 		complete(&aq->cmd_completion);
 
 	return IRQ_HANDLED;
 }
 
+static const struct atmel_qspi_ops atmel_qspi_ops = {
+	.set_cfg = atmel_qspi_set_cfg,
+	.transfer = atmel_qspi_transfer,
+};
+
 static int atmel_qspi_probe(struct platform_device *pdev)
 {
 	struct spi_controller *ctrl;
@@ -601,6 +643,7 @@ static int atmel_qspi_probe(struct platf
 
 	init_completion(&aq->cmd_completion);
 	aq->pdev = pdev;
+	aq->ops = &atmel_qspi_ops;
 
 	/* Map the registers */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "qspi_base");


