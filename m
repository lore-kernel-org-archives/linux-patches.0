Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823D81E489;
	Wed, 17 Sep 2025 12:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113008; cv=none; b=l0OHDv/wPjJaqT17+qEUk5TxmZtz/8psjpKiGSLSLQIhjaF9IX/obZof+G3XTiwNfZSP0LSQADyBq07+511gFyA165wBlw096X2s09luAg5HVWXTisMi4dJHHrp8OZ77b41DRAH26ficsB2zOTE0Dg+K9Y5YGMYqnawcnaje/ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113008; c=relaxed/simple;
	bh=DbE7xEUbV8+8VbaxXx48Kv002Om9sUp294olrNPuJsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZuoyNKWeSlZ0SZDOJGlCeCo1ds9Ve/IMddmiREK3jK4HlACPCKXJ9aGs0vRcSVQ5c1t0eOZIp/tf9ZsLQYpeINp5T60yBwChSl/y9sQAc1EHTv9/yFIDp0JXeQKCEyE85CpVcfPtt5metVpEmtRahSLKVrC2auLF7cyg6OkSIlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2WyCP0LN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2WyCP0LN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D00C4CEF0;
	Wed, 17 Sep 2025 12:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113008;
	bh=DbE7xEUbV8+8VbaxXx48Kv002Om9sUp294olrNPuJsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2WyCP0LNggaQBb0MuXnOMB1Oy9GCZPP381B+sgn4GDh9DcV80agRGUE64lR3RU7D4
	 eX4Yo2dTlK5It74W05MhYwLWO5Erd7N7hH/HwXLQX/feZy04RCZL/WQECjmbSkZQtv
	 wOHEb5k20feP0Q7d3+PxriuKvAUdZIF3NzIU0qFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 106/189] mtd: spinand: winbond: Enable high-speed modes on w25n0xjw
Date: Wed, 17 Sep 2025 14:33:36 +0200
Message-ID: <20250917123354.453982908@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit f1a91175faaab02a45d1ceb313a315a5bfeb5416 ]

w25n0xjw chips have a high-speed capability hidden in a configuration
register. Once enabled, dual/quad SDR reads may be performed at a much
higher frequency.

Implement the new ->configure_chip() hook for this purpose and configure
the SR4 register accordingly.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Stable-dep-of: 4550d33e1811 ("mtd: spinand: winbond: Fix oob_layout for W25N01JW")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/core.c    |    2 -
 drivers/mtd/nand/spi/winbond.c |   45 +++++++++++++++++++++++++++++++++++++++--
 include/linux/mtd/spinand.h    |    1 
 3 files changed, 45 insertions(+), 3 deletions(-)

--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -20,7 +20,7 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/spi-mem.h>
 
-static int spinand_read_reg_op(struct spinand_device *spinand, u8 reg, u8 *val)
+int spinand_read_reg_op(struct spinand_device *spinand, u8 reg, u8 *val)
 {
 	struct spi_mem_op op = SPINAND_GET_FEATURE_1S_1S_1S_OP(reg,
 						      spinand->scratchbuf);
--- a/drivers/mtd/nand/spi/winbond.c
+++ b/drivers/mtd/nand/spi/winbond.c
@@ -18,6 +18,9 @@
 
 #define W25N04KV_STATUS_ECC_5_8_BITFLIPS	(3 << 4)
 
+#define W25N0XJW_SR4			0xD0
+#define W25N0XJW_SR4_HS			BIT(2)
+
 /*
  * "X2" in the core is equivalent to "dual output" in the datasheets,
  * "X4" in the core is equivalent to "quad output" in the datasheets.
@@ -42,10 +45,12 @@ static SPINAND_OP_VARIANTS(update_cache_
 static SPINAND_OP_VARIANTS(read_cache_dual_quad_dtr_variants,
 		SPINAND_PAGE_READ_FROM_CACHE_1S_4D_4D_OP(0, 8, NULL, 0, 80 * HZ_PER_MHZ),
 		SPINAND_PAGE_READ_FROM_CACHE_1S_1D_4D_OP(0, 2, NULL, 0, 80 * HZ_PER_MHZ),
+		SPINAND_PAGE_READ_FROM_CACHE_1S_4S_4S_OP(0, 4, NULL, 0, 0),
 		SPINAND_PAGE_READ_FROM_CACHE_1S_4S_4S_OP(0, 2, NULL, 0, 104 * HZ_PER_MHZ),
 		SPINAND_PAGE_READ_FROM_CACHE_1S_1S_4S_OP(0, 1, NULL, 0),
 		SPINAND_PAGE_READ_FROM_CACHE_1S_2D_2D_OP(0, 4, NULL, 0, 80 * HZ_PER_MHZ),
 		SPINAND_PAGE_READ_FROM_CACHE_1S_1D_2D_OP(0, 2, NULL, 0, 80 * HZ_PER_MHZ),
+		SPINAND_PAGE_READ_FROM_CACHE_1S_2S_2S_OP(0, 2, NULL, 0, 0),
 		SPINAND_PAGE_READ_FROM_CACHE_1S_2S_2S_OP(0, 1, NULL, 0, 104 * HZ_PER_MHZ),
 		SPINAND_PAGE_READ_FROM_CACHE_1S_1S_2S_OP(0, 1, NULL, 0),
 		SPINAND_PAGE_READ_FROM_CACHE_1S_1D_1D_OP(0, 2, NULL, 0, 80 * HZ_PER_MHZ),
@@ -230,6 +235,40 @@ static int w25n02kv_ecc_get_status(struc
 	return -EINVAL;
 }
 
+static int w25n0xjw_hs_cfg(struct spinand_device *spinand)
+{
+	const struct spi_mem_op *op;
+	bool hs;
+	u8 sr4;
+	int ret;
+
+	op = spinand->op_templates.read_cache;
+	if (op->cmd.dtr || op->addr.dtr || op->dummy.dtr || op->data.dtr)
+		hs = false;
+	else if (op->cmd.buswidth == 1 && op->addr.buswidth == 1 &&
+		 op->dummy.buswidth == 1 && op->data.buswidth == 1)
+		hs = false;
+	else if (!op->max_freq)
+		hs = true;
+	else
+		hs = false;
+
+	ret = spinand_read_reg_op(spinand, W25N0XJW_SR4, &sr4);
+	if (ret)
+		return ret;
+
+	if (hs)
+		sr4 |= W25N0XJW_SR4_HS;
+	else
+		sr4 &= ~W25N0XJW_SR4_HS;
+
+	ret = spinand_write_reg_op(spinand, W25N0XJW_SR4, sr4);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static const struct spinand_info winbond_spinand_table[] = {
 	/* 512M-bit densities */
 	SPINAND_INFO("W25N512GW", /* 1.8V */
@@ -268,7 +307,8 @@ static const struct spinand_info winbond
 					      &write_cache_variants,
 					      &update_cache_variants),
 		     0,
-		     SPINAND_ECCINFO(&w25m02gv_ooblayout, NULL)),
+		     SPINAND_ECCINFO(&w25m02gv_ooblayout, NULL),
+		     SPINAND_CONFIGURE_CHIP(w25n0xjw_hs_cfg)),
 	SPINAND_INFO("W25N01KV", /* 3.3V */
 		     SPINAND_ID(SPINAND_READID_METHOD_OPCODE_DUMMY, 0xae, 0x21),
 		     NAND_MEMORG(1, 2048, 96, 64, 1024, 20, 1, 1, 1),
@@ -324,7 +364,8 @@ static const struct spinand_info winbond
 					      &write_cache_variants,
 					      &update_cache_variants),
 		     0,
-		     SPINAND_ECCINFO(&w25m02gv_ooblayout, NULL)),
+		     SPINAND_ECCINFO(&w25m02gv_ooblayout, NULL),
+		     SPINAND_CONFIGURE_CHIP(w25n0xjw_hs_cfg)),
 	SPINAND_INFO("W25N02KV", /* 3.3V */
 		     SPINAND_ID(SPINAND_READID_METHOD_OPCODE_DUMMY, 0xaa, 0x22),
 		     NAND_MEMORG(1, 2048, 128, 64, 2048, 40, 1, 1, 1),
--- a/include/linux/mtd/spinand.h
+++ b/include/linux/mtd/spinand.h
@@ -730,6 +730,7 @@ int spinand_match_and_init(struct spinan
 			   enum spinand_readid_method rdid_method);
 
 int spinand_upd_cfg(struct spinand_device *spinand, u8 mask, u8 val);
+int spinand_read_reg_op(struct spinand_device *spinand, u8 reg, u8 *val);
 int spinand_write_reg_op(struct spinand_device *spinand, u8 reg, u8 val);
 int spinand_select_target(struct spinand_device *spinand, unsigned int target);
 


