Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3FB4F55A5;
	Wed,  9 Sep 2026 13:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962168; cv=none; b=YXdJfKPK9M3r4toBj7trK8reJIcbXzq9fNpHQFtmBXuRbMzKemvTyqIXSK/fj9xZ0OuseXENgtPcMlkY2i7vcgxI9pbztvcRe8Qe0RVBhpHRJRif9ZrcKNgImhKZn3qwROU8Rj/8/JvhZVEJgbR9tSVXWBS6SCIC6jybWYf9YAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962168; c=relaxed/simple;
	bh=HEC38DXEwPKFz/sGMLsrcB3IOm0+a2QK4KL3LX8Y/qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hjxhp1cMVXeYcm3F3JNmejXeEnukRgF9il/F09vUx29tEimuLJG0kUshjrq/pbMd/XuGsMDAYqqoCFwK20KkTEp0gKYmGGB/YW/29+AKwMVC/Y0bQdYizkd5JINVcoPg9dLAzDaSbMvQ79bG1wJO39g/6Ms+0nSxuwp5ka2calE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1xtqFOh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1xtqFOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80811F00A3A;
	Wed,  9 Sep 2026 13:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962167;
	bh=5N/f1g1R+pldk/Wt90/0gbcm4kbcyK5ujg7SD4xhPpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X1xtqFOhcOY2fq9wtz6KgfY5z/iobXo9hyXTIlxKDK7Idb0YfB/ofQFX3Jwdc11LS
	 mLBrTOmaTBUoCKONIWbXb9u4NZez8B/KdK8PvpcdGBzEYUQMqWO7p7UdL/9+7BZbKg
	 Dyk4PDRCi1nm+gce3H3/0SZ6wXNEVF90j8ldEBd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 7.2 196/556] mtd: rawnand: sunxi: group controller delay tables
Date: Wed,  9 Sep 2026 15:37:56 +0200
Message-ID: <20260909134237.298539857@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Hilliard <james.hilliard1@gmail.com>

commit 9f2e033754c6c023150f184b4e72bbcc5d6eea13 upstream.

The tWB and tRHW timing field encodings are controller properties, but
they currently live in standalone lookup tables.

Group them in a timing descriptor selected through the controller
capability data. Point every existing controller at the legacy values so
this is a pure preparation change.

Fixes: 88fd4e4deae8 ("mtd: rawnand: sunxi: Add support for H616 nand controller")
Cc: stable@vger.kernel.org
Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/sunxi_nand.c |   36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -237,6 +237,14 @@ struct sunxi_nand_hw_ecc {
 	u32 ecc_ctl;
 };
 
+#define SUNXI_NFC_TIMING_STEPS	4
+
+/* Delay arrays contain internal NDFC clock cycles for field values 0 to 3. */
+struct sunxi_nfc_timings {
+	s32 tWB[SUNXI_NFC_TIMING_STEPS];
+	s32 tRHW[SUNXI_NFC_TIMING_STEPS];
+};
+
 /**
  * struct sunxi_nand_chip - stores NAND chip device related information
  *
@@ -301,6 +309,7 @@ static inline struct sunxi_nand_chip *to
  *			bytes to write
  * @nuser_data_tab:	Size of @user_data_len_tab
  * @sram_size:		Size of the NAND controller SRAM
+ * @timings:		Controller timing characteristics
  */
 struct sunxi_nfc_caps {
 	bool has_mdma;
@@ -327,6 +336,7 @@ struct sunxi_nfc_caps {
 	unsigned int nuser_data_tab;
 	unsigned int max_ecc_steps;
 	int sram_size;
+	const struct sunxi_nfc_timings *timings;
 };
 
 /**
@@ -1667,8 +1677,10 @@ static int sunxi_nfc_hw_ecc_write_oob(st
 	return nand_prog_page_end_op(nand);
 }
 
-static const s32 tWB_lut[] = {6, 12, 16, 20};
-static const s32 tRHW_lut[] = {4, 8, 12, 20};
+static const struct sunxi_nfc_timings sun4i_a10_nfc_timings = {
+	.tWB = { 6, 12, 16, 20 },
+	.tRHW = { 4, 8, 12, 20 },
+};
 
 static int _sunxi_nand_lookup_timing(const s32 *lut, int lut_size, u32 duration,
 		u32 clk_period)
@@ -1693,6 +1705,7 @@ static int sunxi_nfc_setup_interface(str
 {
 	struct sunxi_nand_chip *sunxi_nand = to_sunxi_nand(nand);
 	struct sunxi_nfc *nfc = to_sunxi_nfc(sunxi_nand->nand.controller);
+	const struct sunxi_nfc_timings *nfc_timings = nfc->caps->timings;
 	const struct nand_sdr_timings *timings;
 	u32 min_clk_period = 0;
 	s32 tWB, tADL, tWHR, tRHW, tCAD;
@@ -1763,8 +1776,10 @@ static int sunxi_nfc_setup_interface(str
 		min_clk_period = DIV_ROUND_UP(timings->tWC_min, 2);
 
 	/* T16 - T19 + tCAD */
-	if (timings->tWB_max > (min_clk_period * 20))
-		min_clk_period = DIV_ROUND_UP(timings->tWB_max, 20);
+	if (timings->tWB_max >
+	    (min_clk_period * nfc_timings->tWB[SUNXI_NFC_TIMING_STEPS - 1]))
+		min_clk_period = DIV_ROUND_UP(timings->tWB_max,
+					      nfc_timings->tWB[SUNXI_NFC_TIMING_STEPS - 1]);
 
 	if (timings->tADL_min > (min_clk_period * 32))
 		min_clk_period = DIV_ROUND_UP(timings->tADL_min, 32);
@@ -1772,8 +1787,10 @@ static int sunxi_nfc_setup_interface(str
 	if (timings->tWHR_min > (min_clk_period * 32))
 		min_clk_period = DIV_ROUND_UP(timings->tWHR_min, 32);
 
-	if (timings->tRHW_min > (min_clk_period * 20))
-		min_clk_period = DIV_ROUND_UP(timings->tRHW_min, 20);
+	if (timings->tRHW_min >
+	    (min_clk_period * nfc_timings->tRHW[SUNXI_NFC_TIMING_STEPS - 1]))
+		min_clk_period = DIV_ROUND_UP(timings->tRHW_min,
+					      nfc_timings->tRHW[SUNXI_NFC_TIMING_STEPS - 1]);
 
 	/*
 	 * In non-EDO, tREA should be less than tRP to guarantee that the
@@ -1789,7 +1806,7 @@ static int sunxi_nfc_setup_interface(str
 	if (timings->tREA_max > min_clk_period && !timings->tRLOH_min)
 		min_clk_period = timings->tREA_max;
 
-	tWB  = sunxi_nand_lookup_timing(tWB_lut, timings->tWB_max,
+	tWB  = sunxi_nand_lookup_timing(nfc_timings->tWB, timings->tWB_max,
 					min_clk_period);
 	if (tWB < 0) {
 		dev_err(nfc->dev, "unsupported tWB\n");
@@ -1808,7 +1825,7 @@ static int sunxi_nfc_setup_interface(str
 		return -EINVAL;
 	}
 
-	tRHW = sunxi_nand_lookup_timing(tRHW_lut, timings->tRHW_min,
+	tRHW = sunxi_nand_lookup_timing(nfc_timings->tRHW, timings->tRHW_min,
 					min_clk_period);
 	if (tRHW < 0) {
 		dev_err(nfc->dev, "unsupported tRHW\n");
@@ -2595,6 +2612,7 @@ static const struct sunxi_nfc_caps sunxi
 	.nstrengths = ARRAY_SIZE(sunxi_ecc_strengths_a10),
 	.max_ecc_steps = 16,
 	.sram_size = 1024,
+	.timings = &sun4i_a10_nfc_timings,
 };
 
 static const struct sunxi_nfc_caps sunxi_nfc_a23_caps = {
@@ -2617,6 +2635,7 @@ static const struct sunxi_nfc_caps sunxi
 	.nstrengths = ARRAY_SIZE(sunxi_ecc_strengths_a10),
 	.max_ecc_steps = 16,
 	.sram_size = 1024,
+	.timings = &sun4i_a10_nfc_timings,
 };
 
 static const struct sunxi_nfc_caps sunxi_nfc_h616_caps = {
@@ -2641,6 +2660,7 @@ static const struct sunxi_nfc_caps sunxi
 	.nuser_data_tab = ARRAY_SIZE(sunxi_user_data_len_h6),
 	.max_ecc_steps = 32,
 	.sram_size = 8192,
+	.timings = &sun4i_a10_nfc_timings,
 };
 
 static const struct of_device_id sunxi_nfc_ids[] = {


