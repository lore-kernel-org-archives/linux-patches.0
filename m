Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19403EDE41;
	Tue, 12 May 2026 17:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608672; cv=none; b=cjkFGkRzAWVm49UIV7O5jJ8pS6WpzMu+ganKAspHdzGQkSFPGkkPnWHtHzIrMMHlBmPYTxWrZj3R3ELxg/nXk9mcs76c3O/KJ5666/x1xj9CxvCbv4E2Rn6737AgLbI8wMDtv1acW4RjAq8BQ/XtHoX82+5WXbchyS4Fe6IKz/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608672; c=relaxed/simple;
	bh=Ezdl8c71RYmwsWtXoORhZnGc9v8oMFsSzzKosYNmc8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVBNXtpyGiad7XwXI9DIhMC+mYiTuPkMxyCcQE6ySzInNWXOBge4a1yOEv2qWZ9y+QcbLAoPaqLHk851Rj0EruUZythQHcFB6TWiZrRZdBaiBvMJSxd/exDoBt3zzdj3HE5/ojtyT7J6CxkisGxVtqWGDyeTKUBv5nO/s+buk00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mClVe8R3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mClVe8R3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60259C2BCB0;
	Tue, 12 May 2026 17:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608672;
	bh=Ezdl8c71RYmwsWtXoORhZnGc9v8oMFsSzzKosYNmc8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mClVe8R3/a5GOoIK0V4nzyoz0wKGlWEqPvmlHCqwKrk3dLh7GkAUAZLiY+cRJ8zNu
	 sXOersd9pEVW8Y4oO1UFzERqRiZkhD7Yn4ceuGJAIG/Wo9FpNYGpjefOM8ZtajYaAi
	 PV5v2UlvPkgbeIcozB9QmDM7dlC63UKPlN7ghXLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 129/270] spi: microchip-core-qspi: control built-in cs manually
Date: Tue, 12 May 2026 19:38:50 +0200
Message-ID: <20260512173941.169842331@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Conor Dooley <conor.dooley@microchip.com>

commit 7672749e1496215e8683ce57cf323119033954cf upstream.

The coreQSPI IP supports only a single chip select, which is
automagically operated by the hardware - set low when the transmit
buffer first gets written to and set high when the number of bytes
written to the TOTALBYTES field of the FRAMES register have been sent on
the bus. Additional devices must use GPIOs for their chip selects.
It was reported to me that if there are two devices attached to this
QSPI controller that the in-built chip select is set low while linux
tries to access the device attached to the GPIO.

This went undetected as the boards that connected multiple devices to
the SPI controller all exclusively used GPIOs for chip selects, not
relying on the built-in chip select at all. It turns out that this was
because the built-in chip select, when controlled automagically, is set
low when active and high when inactive, thereby ruling out its use for
active-high devices or devices that need to transmit with the chip
select disabled.

Modify the driver so that it controls chip select directly, retaining
the behaviour for mem_ops of setting the chip select active for the
entire duration of the transfer in the exec_op callback. For regular
transfers, implement the set_cs callback for the core to use.

As part of this, the existing setup callback, mchp_coreqspi_setup_op(),
is removed. Modifying the CLKIDLE field is not safe to do during
operation when there are multiple devices, so this code is removed
entirely. Setting the MASTER and ENABLE fields is something that can be
done once at probe, it doesn't need to be re-run for each device.
Instead the new setup callback sets the built-in chip select to its
inactive state for active-low devices, as the reset value of the chip
select in software controlled mode is low.

Fixes: 8f9cf02c88528 ("spi: microchip-core-qspi: Add regular transfers")
Fixes: 8596124c4c1bc ("spi: microchip-core-qspi: Add support for microchip fpga qspi controllers")
CC: stable@vger.kernel.org
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/20260430-hamstring-busload-f941d0347b5e@spud
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-microchip-core-qspi.c |   79 +++++++++++++++++++++++++++-------
 1 file changed, 64 insertions(+), 15 deletions(-)

--- a/drivers/spi/spi-microchip-core-qspi.c
+++ b/drivers/spi/spi-microchip-core-qspi.c
@@ -74,6 +74,13 @@
 #define STATUS_FLAGSX4		BIT(8)
 #define STATUS_MASK		GENMASK(8, 0)
 
+/*
+ * QSPI Direct Access register defines
+ */
+#define DIRECT_ACCESS_EN_SSEL		BIT(0)
+#define DIRECT_ACCESS_OP_SSEL		BIT(1)
+#define DIRECT_ACCESS_OP_SSEL_SHIFT	1
+
 #define BYTESUPPER_MASK		GENMASK(31, 16)
 #define BYTESLOWER_MASK		GENMASK(15, 0)
 
@@ -158,6 +165,38 @@ static int mchp_coreqspi_set_mode(struct
 	return 0;
 }
 
+static void mchp_coreqspi_set_cs(struct spi_device *spi, bool enable)
+{
+	struct mchp_coreqspi *qspi = spi_controller_get_devdata(spi->controller);
+	u32 val;
+
+	val = readl(qspi->regs + REG_DIRECT_ACCESS);
+
+	val &= ~DIRECT_ACCESS_OP_SSEL;
+	val |= !enable << DIRECT_ACCESS_OP_SSEL_SHIFT;
+
+	writel(val, qspi->regs + REG_DIRECT_ACCESS);
+}
+
+static int mchp_coreqspi_setup(struct spi_device *spi)
+{
+	struct mchp_coreqspi *qspi = spi_controller_get_devdata(spi->controller);
+	u32 val;
+
+	/*
+	 * Active low devices need to be specifically set to their inactive
+	 * states during probe.
+	 */
+	if (spi->mode & SPI_CS_HIGH)
+		return 0;
+
+	val = readl(qspi->regs + REG_DIRECT_ACCESS);
+	val |= DIRECT_ACCESS_OP_SSEL;
+	writel(val, qspi->regs + REG_DIRECT_ACCESS);
+
+	return 0;
+}
+
 static inline void mchp_coreqspi_read_op(struct mchp_coreqspi *qspi)
 {
 	u32 control, data;
@@ -380,19 +419,6 @@ static int mchp_coreqspi_setup_clock(str
 	return 0;
 }
 
-static int mchp_coreqspi_setup_op(struct spi_device *spi_dev)
-{
-	struct spi_controller *ctlr = spi_dev->controller;
-	struct mchp_coreqspi *qspi = spi_controller_get_devdata(ctlr);
-	u32 control = readl_relaxed(qspi->regs + REG_CONTROL);
-
-	control |= (CONTROL_MASTER | CONTROL_ENABLE);
-	control &= ~CONTROL_CLKIDLE;
-	writel_relaxed(control, qspi->regs + REG_CONTROL);
-
-	return 0;
-}
-
 static inline void mchp_coreqspi_config_op(struct mchp_coreqspi *qspi, const struct spi_mem_op *op)
 {
 	u32 idle_cycles = 0;
@@ -483,6 +509,7 @@ static int mchp_coreqspi_exec_op(struct
 
 	reinit_completion(&qspi->data_completion);
 	mchp_coreqspi_config_op(qspi, op);
+	mchp_coreqspi_set_cs(mem->spi, true);
 	if (op->cmd.opcode) {
 		qspi->txbuf = &opcode;
 		qspi->rxbuf = NULL;
@@ -523,6 +550,7 @@ static int mchp_coreqspi_exec_op(struct
 		err = -ETIMEDOUT;
 
 error:
+	mchp_coreqspi_set_cs(mem->spi, false);
 	mutex_unlock(&qspi->op_lock);
 	mchp_coreqspi_disable_ints(qspi);
 
@@ -696,6 +724,7 @@ static int mchp_coreqspi_probe(struct pl
 	struct device *dev = &pdev->dev;
 	struct device_node *np = dev->of_node;
 	int ret;
+	u32 num_cs, val;
 
 	ctlr = devm_spi_alloc_host(&pdev->dev, sizeof(*qspi));
 	if (!ctlr)
@@ -728,10 +757,18 @@ static int mchp_coreqspi_probe(struct pl
 		return ret;
 	}
 
+	/*
+	 * The IP core only has a single CS, any more have to be provided via
+	 * gpios
+	 */
+	if (of_property_read_u32(pdev->dev.of_node, "num-cs", &num_cs))
+		num_cs = 1;
+
+	ctlr->num_chipselect = num_cs;
+
 	ctlr->bits_per_word_mask = SPI_BPW_MASK(8);
 	ctlr->mem_ops = &mchp_coreqspi_mem_ops;
 	ctlr->mem_caps = &mchp_coreqspi_mem_caps;
-	ctlr->setup = mchp_coreqspi_setup_op;
 	ctlr->mode_bits = SPI_CPOL | SPI_CPHA | SPI_RX_DUAL | SPI_RX_QUAD |
 			  SPI_TX_DUAL | SPI_TX_QUAD;
 	ctlr->dev.of_node = np;
@@ -739,9 +776,21 @@ static int mchp_coreqspi_probe(struct pl
 	ctlr->prepare_message = mchp_coreqspi_prepare_message;
 	ctlr->unprepare_message = mchp_coreqspi_unprepare_message;
 	ctlr->transfer_one = mchp_coreqspi_transfer_one;
-	ctlr->num_chipselect = 2;
+	ctlr->setup = mchp_coreqspi_setup;
+	ctlr->set_cs = mchp_coreqspi_set_cs;
 	ctlr->use_gpio_descriptors = true;
 
+	val = readl_relaxed(qspi->regs + REG_CONTROL);
+	val |= (CONTROL_MASTER | CONTROL_ENABLE);
+	writel_relaxed(val, qspi->regs + REG_CONTROL);
+
+	/*
+	 * Put cs into software controlled mode
+	 */
+	val = readl_relaxed(qspi->regs + REG_DIRECT_ACCESS);
+	val |= DIRECT_ACCESS_EN_SSEL;
+	writel(val, qspi->regs + REG_DIRECT_ACCESS);
+
 	ret = spi_register_controller(ctlr);
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret,


