Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F2F17BED0;
	Sat, 17 Oct 2026 16:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254007; cv=none; b=ZasK9qyhBbZzYweIHbL+haM/OoEQJt3XZJ1GphuChshulwj93p3L9fdZDU4WwzyaPb2o5+oAgF7NewvsUl1W9BA45tFm+9UaiA2xJQrBLK0bGmF0r0BA+erykoiBxbNDRopy195TJr4JiZOdvIo7FJMIjN/eggYrt0biUTNgUk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254007; c=relaxed/simple;
	bh=lfkhD6utb6G3UHi46AsYDdjQG55qvjbIQS4a+9wrF68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4ZRBzzgDpumoU0tVkkMSzT04EagclS/sXPqIqJStDYH9a4NidLcJezMPOzd1bbbpwvwZ0zgJASIYsLlMnOLYhjIph7K3IbEqutSuGfXlWdJkPwrE142JvgF2fS4Znzw4DVDl5rohzXwDDOe3Kui1ZhjuPkUkOUqcdX7fPwylqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FOfOAJR/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FOfOAJR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA481F000C4;
	Sat, 17 Oct 2026 16:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254006;
	bh=/Dkc/tC/15T1bna0wKRnXq+dKvrdECdVf+AKumiwLrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FOfOAJR/yd/3Z7aVmaNmHq9uXxuXDi48bqI2wL3RdJsCbwdpRHchswDvbZxDxVvib
	 u/211ps5dxPMLSUfFVQ3wdnw6N0zVMPAjOs9o+ibFKIx12SOjug6/WkPZ7xoGFY8s1
	 E7LkX2yRn+Tvo4uylIh704mVejxNA+iLqq8eFaUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Daire McNamara <daire.mcnamara@microchip.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 288/869] spi: microchip-core-qspi: Support per spi-mem operation frequency switches
Date: Sat, 17 Oct 2026 17:52:09 +0200
Message-ID: <20261017160044.457991691@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 13529647743d906ed3cf991f1d77727e7ff1fb6f ]

Every ->exec_op() call correctly configures the spi bus speed to the
maximum allowed frequency for the memory using the constant spi default
parameter. Since we can now have per-operation constraints, let's use
the value that comes from the spi-mem operation structure instead. In
case there is no specific limitation for this operation, the default spi
device value will be given anyway.

This controller however performed a frequency check, which is also
observed during the ->check_op() phase.

The per-operation frequency capability is thus advertised to the spi-mem
core.

Cc: Conor Dooley <conor.dooley@microchip.com>
Cc: Daire McNamara <daire.mcnamara@microchip.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20241224-winbond-6-11-rc1-quad-support-v2-9-ad218dbc406f@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 7672749e1496 ("spi: microchip-core-qspi: control built-in cs manually")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-microchip-core-qspi.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-microchip-core-qspi.c b/drivers/spi/spi-microchip-core-qspi.c
index 6aba933fcc0b3..bda9a43dbf2ef 100644
--- a/drivers/spi/spi-microchip-core-qspi.c
+++ b/drivers/spi/spi-microchip-core-qspi.c
@@ -265,7 +265,8 @@ static irqreturn_t mchp_coreqspi_isr(int irq, void *dev_id)
 	return ret;
 }
 
-static int mchp_coreqspi_setup_clock(struct mchp_coreqspi *qspi, struct spi_device *spi)
+static int mchp_coreqspi_setup_clock(struct mchp_coreqspi *qspi, struct spi_device *spi,
+				     const struct spi_mem_op *op)
 {
 	unsigned long clk_hz;
 	u32 control, baud_rate_val = 0;
@@ -274,11 +275,11 @@ static int mchp_coreqspi_setup_clock(struct mchp_coreqspi *qspi, struct spi_devi
 	if (!clk_hz)
 		return -EINVAL;
 
-	baud_rate_val = DIV_ROUND_UP(clk_hz, 2 * spi->max_speed_hz);
+	baud_rate_val = DIV_ROUND_UP(clk_hz, 2 * op->max_freq);
 	if (baud_rate_val > MAX_DIVIDER || baud_rate_val < MIN_DIVIDER) {
 		dev_err(&spi->dev,
 			"could not configure the clock for spi clock %d Hz & system clock %ld Hz\n",
-			spi->max_speed_hz, clk_hz);
+			op->max_freq, clk_hz);
 		return -EINVAL;
 	}
 
@@ -399,7 +400,7 @@ static int mchp_coreqspi_exec_op(struct spi_mem *mem, const struct spi_mem_op *o
 	if (err)
 		goto error;
 
-	err = mchp_coreqspi_setup_clock(qspi, mem->spi);
+	err = mchp_coreqspi_setup_clock(qspi, mem->spi, op);
 	if (err)
 		goto error;
 
@@ -457,6 +458,10 @@ static int mchp_coreqspi_exec_op(struct spi_mem *mem, const struct spi_mem_op *o
 
 static bool mchp_coreqspi_supports_op(struct spi_mem *mem, const struct spi_mem_op *op)
 {
+	struct mchp_coreqspi *qspi = spi_controller_get_devdata(mem->spi->controller);
+	unsigned long clk_hz;
+	u32 baud_rate_val;
+
 	if (!spi_mem_default_supports_op(mem, op))
 		return false;
 
@@ -479,6 +484,14 @@ static bool mchp_coreqspi_supports_op(struct spi_mem *mem, const struct spi_mem_
 			return false;
 	}
 
+	clk_hz = clk_get_rate(qspi->clk);
+	if (!clk_hz)
+		return false;
+
+	baud_rate_val = DIV_ROUND_UP(clk_hz, 2 * op->max_freq);
+	if (baud_rate_val > MAX_DIVIDER || baud_rate_val < MIN_DIVIDER)
+		return false;
+
 	return true;
 }
 
@@ -498,6 +511,10 @@ static const struct spi_controller_mem_ops mchp_coreqspi_mem_ops = {
 	.exec_op = mchp_coreqspi_exec_op,
 };
 
+static const struct spi_controller_mem_caps mchp_coreqspi_mem_caps = {
+	.per_op_freq = true,
+};
+
 static int mchp_coreqspi_probe(struct platform_device *pdev)
 {
 	struct spi_controller *ctlr;
@@ -540,6 +557,7 @@ static int mchp_coreqspi_probe(struct platform_device *pdev)
 
 	ctlr->bits_per_word_mask = SPI_BPW_MASK(8);
 	ctlr->mem_ops = &mchp_coreqspi_mem_ops;
+	ctlr->mem_caps = &mchp_coreqspi_mem_caps;
 	ctlr->setup = mchp_coreqspi_setup_op;
 	ctlr->mode_bits = SPI_CPOL | SPI_CPHA | SPI_RX_DUAL | SPI_RX_QUAD |
 			  SPI_TX_DUAL | SPI_TX_QUAD;
-- 
2.53.0



