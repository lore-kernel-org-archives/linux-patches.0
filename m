Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B083F1A9F89;
	Tue, 12 Aug 2025 18:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024377; cv=none; b=YAZCAT9myStiNPUfNDldxK5+nxfvAybHkSGy8eFUELOjq+f0uweqHxiMBy6E0Qpm1Dw67CRCFmnfBKOuy3bLgMdrVBvToKqxPl3Tzsi0Ceav5MgD4ieCeywcilayfJnBWALTZRcxe2deLgBbtLsf+gliPCLZ//bU/UQjhvNg5yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024377; c=relaxed/simple;
	bh=zCuzxk7dWQF9ImV14BsJnCSSZillaAlOgyK2ZVn8aMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0R50v0ni+jO2jZHhuoa3UdvAm26+rgB/MxnHc9/ugV6cAU9cn/2PjmNSAzcQRCjL/EcwyHUbai4iRIvFN4q2HAeWQtZdlRTlWwCVPoOX+BLIgODLkkwk95X7uy3OIQ7I9LhLs26RUfIARE3wN9NNn5Dgk8lf/CUNp5TbZONzOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B9GRzfrh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B9GRzfrh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C238C4CEF0;
	Tue, 12 Aug 2025 18:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024377;
	bh=zCuzxk7dWQF9ImV14BsJnCSSZillaAlOgyK2ZVn8aMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B9GRzfrhLWudXLDegpeDvQ0YapJZSkof1vwcP4NmENy4V3Mrx8hz1KBWLs2T97VhD
	 Kh6Xhjyv/MRucl443O73RFwM8Qp8KNGZ91ah4sPPkg8fXj00dKuR2wupnxOx92XRRU
	 OmMarzm0K8mVYzo6REhh1XhCu7T8Go9y6/Igwz0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 356/627] mtd: spi-nor: spansion: Fixup params->set_4byte_addr_mode for SEMPER
Date: Tue, 12 Aug 2025 19:30:51 +0200
Message-ID: <20250812173432.834187968@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>

[ Upstream commit a45ab839f52f3f00ac3dae18a50e902efd216de2 ]

Infineon SEMPER flash family does not support E9h opcode as Exit 4-byte
mode (EX4B). Therefore, params->set_4byte_addr_mode is not determined by
BFPT parse. Fixup it up by introducing vendor specific EX4B opcode (B8h)
and function.

Fixes: c87c9b11c53ce ("mtd: spi-nor: spansion: Determine current address mode")
Signed-off-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
Acked-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Acked-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Link: https://lore.kernel.org/r/20250612074427.22263-1-Takahiro.Kuwano@infineon.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/spansion.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
index bf08dbf5e742..b9f156c0f8bc 100644
--- a/drivers/mtd/spi-nor/spansion.c
+++ b/drivers/mtd/spi-nor/spansion.c
@@ -17,6 +17,7 @@
 
 #define SPINOR_OP_CLSR		0x30	/* Clear status register 1 */
 #define SPINOR_OP_CLPEF		0x82	/* Clear program/erase failure flags */
+#define SPINOR_OP_CYPRESS_EX4B	0xB8	/* Exit 4-byte address mode */
 #define SPINOR_OP_CYPRESS_DIE_ERASE		0x61	/* Chip (die) erase */
 #define SPINOR_OP_RD_ANY_REG			0x65	/* Read any register */
 #define SPINOR_OP_WR_ANY_REG			0x71	/* Write any register */
@@ -58,6 +59,13 @@
 		   SPI_MEM_OP_DUMMY(ndummy, 0),				\
 		   SPI_MEM_OP_DATA_IN(1, buf, 0))
 
+#define CYPRESS_NOR_EN4B_EX4B_OP(enable)				\
+	SPI_MEM_OP(SPI_MEM_OP_CMD(enable ? SPINOR_OP_EN4B :		\
+					   SPINOR_OP_CYPRESS_EX4B, 0),	\
+		   SPI_MEM_OP_NO_ADDR,					\
+		   SPI_MEM_OP_NO_DUMMY,					\
+		   SPI_MEM_OP_NO_DATA)
+
 #define SPANSION_OP(opcode)						\
 	SPI_MEM_OP(SPI_MEM_OP_CMD(opcode, 0),				\
 		   SPI_MEM_OP_NO_ADDR,					\
@@ -356,6 +364,20 @@ static int cypress_nor_quad_enable_volatile(struct spi_nor *nor)
 	return 0;
 }
 
+static int cypress_nor_set_4byte_addr_mode(struct spi_nor *nor, bool enable)
+{
+	int ret;
+	struct spi_mem_op op = CYPRESS_NOR_EN4B_EX4B_OP(enable);
+
+	spi_nor_spimem_setup_op(nor, &op, nor->reg_proto);
+
+	ret = spi_mem_exec_op(nor->spimem, &op);
+	if (ret)
+		dev_dbg(nor->dev, "error %d setting 4-byte mode\n", ret);
+
+	return ret;
+}
+
 /**
  * cypress_nor_determine_addr_mode_by_sr1() - Determine current address mode
  *                                            (3 or 4-byte) by querying status
@@ -526,6 +548,9 @@ s25fs256t_post_bfpt_fixup(struct spi_nor *nor,
 	struct spi_mem_op op;
 	int ret;
 
+	/* Assign 4-byte address mode method that is not determined in BFPT */
+	nor->params->set_4byte_addr_mode = cypress_nor_set_4byte_addr_mode;
+
 	ret = cypress_nor_set_addr_mode_nbytes(nor);
 	if (ret)
 		return ret;
@@ -591,6 +616,9 @@ s25hx_t_post_bfpt_fixup(struct spi_nor *nor,
 {
 	int ret;
 
+	/* Assign 4-byte address mode method that is not determined in BFPT */
+	nor->params->set_4byte_addr_mode = cypress_nor_set_4byte_addr_mode;
+
 	ret = cypress_nor_set_addr_mode_nbytes(nor);
 	if (ret)
 		return ret;
@@ -718,6 +746,9 @@ static int s28hx_t_post_bfpt_fixup(struct spi_nor *nor,
 				   const struct sfdp_parameter_header *bfpt_header,
 				   const struct sfdp_bfpt *bfpt)
 {
+	/* Assign 4-byte address mode method that is not determined in BFPT */
+	nor->params->set_4byte_addr_mode = cypress_nor_set_4byte_addr_mode;
+
 	return cypress_nor_set_addr_mode_nbytes(nor);
 }
 
-- 
2.39.5



