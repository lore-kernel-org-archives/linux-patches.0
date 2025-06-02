Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D870223DD1;
	Mon,  2 Jun 2025 15:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876573; cv=none; b=H3T+jSv43QqI1J9MeU6FdxVCmgvAZ4zTWo8rcdwW3ewZzaVwuv8fQMkixIoVG/o+KLCYogpal+7pmYhodN/SyVXjEzXzUBZZd8WS5hUMH64po5w3chVpUYn0v/3FEtOo2b9g9OqpWLy+5Wqwkj4++1uWoRUO/Gc3jpRPK9JtVus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876573; c=relaxed/simple;
	bh=V8CRxgXjj997D57lCSFfB2PrYhTUYcfIK2r52Nsw4mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plvc7E/QDdgMSYP6H9+SY6fCmNnJoQbg8GkOsptFleaKYyPmA9e8SLL7FXvwGeztRklro2e2/6KFT68ZGjyWl5MENgtnWsol4YKnNnvoV76HdTh1thXKUN6uUgGv5iYbGo+YXDvchXyBcp5Jl7F1qbs0yyeTtLBPSwu2V1QKLSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ryFuEsJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ryFuEsJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13A6C4CEEB;
	Mon,  2 Jun 2025 15:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876573;
	bh=V8CRxgXjj997D57lCSFfB2PrYhTUYcfIK2r52Nsw4mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ryFuEsJUEswa65ZWEJELgV2yDHiXLNcvtSLlvuqRzsoKK0KZ21tVmIMBkxyfrkKUJ
	 4mrQuhADUPQPp0qDJsErH33Kmawl2JDcXIawZZ0d3/AhpLVb0OFwOc5kNpavWHSN2y
	 xgjwe1M1iKiw+yQ6bik6w5vpEPkEFOmi63SSzem8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xulin Sun <xulin.sun@windriver.com>,
	Larisa Grigore <larisa.grigore@nxp.com>,
	James Clark <james.clark@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 182/207] spi: spi-fsl-dspi: restrict register range for regmap access
Date: Mon,  2 Jun 2025 15:49:14 +0200
Message-ID: <20250602134305.881410437@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larisa Grigore <larisa.grigore@nxp.com>

[ Upstream commit 283ae0c65e9c592f4a1ba4f31917f5e766da7f31 ]

DSPI registers are NOT continuous, some registers are reserved and
accessing them from userspace will trigger external abort, add regmap
register access table to avoid below abort.

  For example on S32G:

  # cat /sys/kernel/debug/regmap/401d8000.spi/registers

  Internal error: synchronous external abort: 96000210 1 PREEMPT SMP
  ...
  Call trace:
  regmap_mmio_read32le+0x24/0x48
  regmap_mmio_read+0x48/0x70
  _regmap_bus_reg_read+0x38/0x48
  _regmap_read+0x68/0x1b0
  regmap_read+0x50/0x78
  regmap_read_debugfs+0x120/0x338

Fixes: 1acbdeb92c87 ("spi/fsl-dspi: Convert to use regmap and add big-endian support")
Co-developed-by: Xulin Sun <xulin.sun@windriver.com>
Signed-off-by: Xulin Sun <xulin.sun@windriver.com>
Signed-off-by: Larisa Grigore <larisa.grigore@nxp.com>
Signed-off-by: James Clark <james.clark@linaro.org>
Link: https://patch.msgid.link/20250522-james-nxp-spi-v2-1-bea884630cfb@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 0d9201a2999de..7c26eef0570e7 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0+
 //
 // Copyright 2013 Freescale Semiconductor, Inc.
-// Copyright 2020 NXP
+// Copyright 2020-2025 NXP
 //
 // Freescale DSPI driver
 // This file contains a driver for the Freescale DSPI
@@ -1128,6 +1128,20 @@ static int dspi_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(dspi_pm, dspi_suspend, dspi_resume);
 
+static const struct regmap_range dspi_yes_ranges[] = {
+	regmap_reg_range(SPI_MCR, SPI_MCR),
+	regmap_reg_range(SPI_TCR, SPI_CTAR(3)),
+	regmap_reg_range(SPI_SR, SPI_TXFR3),
+	regmap_reg_range(SPI_RXFR0, SPI_RXFR3),
+	regmap_reg_range(SPI_CTARE(0), SPI_CTARE(3)),
+	regmap_reg_range(SPI_SREX, SPI_SREX),
+};
+
+static const struct regmap_access_table dspi_access_table = {
+	.yes_ranges	= dspi_yes_ranges,
+	.n_yes_ranges	= ARRAY_SIZE(dspi_yes_ranges),
+};
+
 static const struct regmap_range dspi_volatile_ranges[] = {
 	regmap_reg_range(SPI_MCR, SPI_TCR),
 	regmap_reg_range(SPI_SR, SPI_SR),
@@ -1145,6 +1159,8 @@ static const struct regmap_config dspi_regmap_config = {
 	.reg_stride	= 4,
 	.max_register	= 0x88,
 	.volatile_table	= &dspi_volatile_table,
+	.rd_table	= &dspi_access_table,
+	.wr_table	= &dspi_access_table,
 };
 
 static const struct regmap_range dspi_xspi_volatile_ranges[] = {
@@ -1166,6 +1182,8 @@ static const struct regmap_config dspi_xspi_regmap_config[] = {
 		.reg_stride	= 4,
 		.max_register	= 0x13c,
 		.volatile_table	= &dspi_xspi_volatile_table,
+		.rd_table	= &dspi_access_table,
+		.wr_table	= &dspi_access_table,
 	},
 	{
 		.name		= "pushr",
-- 
2.39.5



