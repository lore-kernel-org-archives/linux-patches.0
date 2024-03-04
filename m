Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F36200CD;
	Mon,  4 Mar 2024 21:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588091; cv=none; b=eHNgAZr7bpI1CPJXPbMsYJhnQgyRYqC5D6RMppBT7p+YpnGVOcGzAkYzEB+H/Y1HGSH683W4/gioLuiEax7Lq83z5kMCH+4z9aXOiMzQlKzv8lb2OkKDSkvqahxSCWvQJNJYG4QA63MFAdSoqNq3WOENYjr29FCGsWs/8PkVIqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588091; c=relaxed/simple;
	bh=pZzk4XBMaQ2ZqqgbAQE9Yf1j6sSWtlfuXNOFBI07IOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ldfa3o3xxyJataNsVYmWlhxsD6uLM5eILNE9nZ27O8LhlMdV/PHkh1wQ1Khgy7hziPd+rvWAza75tGI9/fIbuWjWSNLn3VAF8oUTebpDhpBmyAC8BDLpI9tcvCJT8dhzK+V5vGFMGYFOaqqFsidAuHUjZBNw3n5IJOBiJHlo2SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07tJt2aS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07tJt2aS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6E7C433C7;
	Mon,  4 Mar 2024 21:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588091;
	bh=pZzk4XBMaQ2ZqqgbAQE9Yf1j6sSWtlfuXNOFBI07IOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=07tJt2aSruHlpoLc1A0EwK5n/c4Y9GgAVyXROWBtgC0R/Hi7pu/+uWerG2WGSQVPQ
	 mLIFUTcSUrDve7MgLWy5D5lD8XTaVI3ZApwgch/lANLMDRD5vcX/r+EYbQNGWovLE6
	 P+miVzQUybzphCUFfXeaqZIlpUlzXr4UTspQkCyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reto Schneider <reto.schneider@husqvarnagroup.com>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Stefan Roese <sr@denx.de>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 03/42] mtd: spinand: gigadevice: Support GD5F1GQ5UExxG
Date: Mon,  4 Mar 2024 21:23:30 +0000
Message-ID: <20240304211537.750565870@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211537.631764077@linuxfoundation.org>
References: <20240304211537.631764077@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reto Schneider <reto.schneider@husqvarnagroup.com>

[ Upstream commit 469b992489852b500d39048aa0013639dfe9f2e6 ]

The relevant changes to the already existing GD5F1GQ4UExxG support has
been determined by consulting the GigaDevice product change notice
AN-0392-10, version 1.0 from November 30, 2020.

As the overlaps are huge, variable names have been generalized
accordingly.

Apart from the lowered ECC strength (4 instead of 8 bits per 512 bytes),
the new device ID, and the extra quad IO dummy byte, no changes had to
be taken into account.

New hardware features are not supported, namely:
 - Power on reset
 - Unique ID
 - Double transfer rate (DTR)
 - Parameter page
 - Random data quad IO

The inverted semantic of the "driver strength" register bits, defaulting
to 100% instead of 50% for the Q5 devices, got ignored as the driver has
never touched them anyway.

The no longer supported "read from cache during block erase"
functionality is not reflected as the current SPI NAND core does not
support it anyway.

Implementation has been tested on MediaTek MT7688 based GARDENA smart
Gateways using both, GigaDevice GD5F1GQ5UEYIG and GD5F1GQ4UBYIG.

Signed-off-by: Reto Schneider <reto.schneider@husqvarnagroup.com>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reviewed-by: Stefan Roese <sr@denx.de>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210211113619.3502-1-code@reto-schneider.ch
Stable-dep-of: 59950610c0c0 ("mtd: spinand: gigadevice: Fix the get ecc status issue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/spi/gigadevice.c | 69 +++++++++++++++++++++++++++----
 1 file changed, 60 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/nand/spi/gigadevice.c b/drivers/mtd/nand/spi/gigadevice.c
index 33c67403c4aa1..1dd1c58980934 100644
--- a/drivers/mtd/nand/spi/gigadevice.c
+++ b/drivers/mtd/nand/spi/gigadevice.c
@@ -13,7 +13,10 @@
 #define GD5FXGQ4XA_STATUS_ECC_1_7_BITFLIPS	(1 << 4)
 #define GD5FXGQ4XA_STATUS_ECC_8_BITFLIPS	(3 << 4)
 
-#define GD5FXGQ4UEXXG_REG_STATUS2		0xf0
+#define GD5FXGQ5XE_STATUS_ECC_1_4_BITFLIPS	(1 << 4)
+#define GD5FXGQ5XE_STATUS_ECC_4_BITFLIPS	(3 << 4)
+
+#define GD5FXGQXXEXXG_REG_STATUS2		0xf0
 
 #define GD5FXGQ4UXFXXG_STATUS_ECC_MASK		(7 << 4)
 #define GD5FXGQ4UXFXXG_STATUS_ECC_NO_BITFLIPS	(0 << 4)
@@ -102,7 +105,7 @@ static int gd5fxgq4xa_ecc_get_status(struct spinand_device *spinand,
 	return -EINVAL;
 }
 
-static int gd5fxgq4_variant2_ooblayout_ecc(struct mtd_info *mtd, int section,
+static int gd5fxgqx_variant2_ooblayout_ecc(struct mtd_info *mtd, int section,
 				       struct mtd_oob_region *region)
 {
 	if (section)
@@ -114,7 +117,7 @@ static int gd5fxgq4_variant2_ooblayout_ecc(struct mtd_info *mtd, int section,
 	return 0;
 }
 
-static int gd5fxgq4_variant2_ooblayout_free(struct mtd_info *mtd, int section,
+static int gd5fxgqx_variant2_ooblayout_free(struct mtd_info *mtd, int section,
 					struct mtd_oob_region *region)
 {
 	if (section)
@@ -127,9 +130,10 @@ static int gd5fxgq4_variant2_ooblayout_free(struct mtd_info *mtd, int section,
 	return 0;
 }
 
-static const struct mtd_ooblayout_ops gd5fxgq4_variant2_ooblayout = {
-	.ecc = gd5fxgq4_variant2_ooblayout_ecc,
-	.free = gd5fxgq4_variant2_ooblayout_free,
+/* Valid for Q4/Q5 and Q6 (untested) devices */
+static const struct mtd_ooblayout_ops gd5fxgqx_variant2_ooblayout = {
+	.ecc = gd5fxgqx_variant2_ooblayout_ecc,
+	.free = gd5fxgqx_variant2_ooblayout_free,
 };
 
 static int gd5fxgq4xc_ooblayout_256_ecc(struct mtd_info *mtd, int section,
@@ -165,7 +169,7 @@ static int gd5fxgq4uexxg_ecc_get_status(struct spinand_device *spinand,
 					u8 status)
 {
 	u8 status2;
-	struct spi_mem_op op = SPINAND_GET_FEATURE_OP(GD5FXGQ4UEXXG_REG_STATUS2,
+	struct spi_mem_op op = SPINAND_GET_FEATURE_OP(GD5FXGQXXEXXG_REG_STATUS2,
 						      &status2);
 	int ret;
 
@@ -203,6 +207,43 @@ static int gd5fxgq4uexxg_ecc_get_status(struct spinand_device *spinand,
 	return -EINVAL;
 }
 
+static int gd5fxgq5xexxg_ecc_get_status(struct spinand_device *spinand,
+					u8 status)
+{
+	u8 status2;
+	struct spi_mem_op op = SPINAND_GET_FEATURE_OP(GD5FXGQXXEXXG_REG_STATUS2,
+						      &status2);
+	int ret;
+
+	switch (status & STATUS_ECC_MASK) {
+	case STATUS_ECC_NO_BITFLIPS:
+		return 0;
+
+	case GD5FXGQ5XE_STATUS_ECC_1_4_BITFLIPS:
+		/*
+		 * Read status2 register to determine a more fine grained
+		 * bit error status
+		 */
+		ret = spi_mem_exec_op(spinand->spimem, &op);
+		if (ret)
+			return ret;
+
+		/*
+		 * 1 ... 4 bits are flipped (and corrected)
+		 */
+		/* bits sorted this way (1...0): ECCSE1, ECCSE0 */
+		return ((status2 & STATUS_ECC_MASK) >> 4) + 1;
+
+	case STATUS_ECC_UNCOR_ERROR:
+		return -EBADMSG;
+
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+
 static int gd5fxgq4ufxxg_ecc_get_status(struct spinand_device *spinand,
 					u8 status)
 {
@@ -282,7 +323,7 @@ static const struct spinand_info gigadevice_spinand_table[] = {
 					      &write_cache_variants,
 					      &update_cache_variants),
 		     SPINAND_HAS_QE_BIT,
-		     SPINAND_ECCINFO(&gd5fxgq4_variant2_ooblayout,
+		     SPINAND_ECCINFO(&gd5fxgqx_variant2_ooblayout,
 				     gd5fxgq4uexxg_ecc_get_status)),
 	SPINAND_INFO("GD5F1GQ4UFxxG",
 		     SPINAND_ID(SPINAND_READID_METHOD_OPCODE, 0xb1, 0x48),
@@ -292,8 +333,18 @@ static const struct spinand_info gigadevice_spinand_table[] = {
 					      &write_cache_variants,
 					      &update_cache_variants),
 		     SPINAND_HAS_QE_BIT,
-		     SPINAND_ECCINFO(&gd5fxgq4_variant2_ooblayout,
+		     SPINAND_ECCINFO(&gd5fxgqx_variant2_ooblayout,
 				     gd5fxgq4ufxxg_ecc_get_status)),
+	SPINAND_INFO("GD5F1GQ5UExxG",
+		     SPINAND_ID(SPINAND_READID_METHOD_OPCODE_DUMMY, 0x51),
+		     NAND_MEMORG(1, 2048, 128, 64, 1024, 20, 1, 1, 1),
+		     NAND_ECCREQ(4, 512),
+		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants,
+					      &write_cache_variants,
+					      &update_cache_variants),
+		     SPINAND_HAS_QE_BIT,
+		     SPINAND_ECCINFO(&gd5fxgqx_variant2_ooblayout,
+				     gd5fxgq5xexxg_ecc_get_status)),
 };
 
 static const struct spinand_manufacturer_ops gigadevice_spinand_manuf_ops = {
-- 
2.43.0



