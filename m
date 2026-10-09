Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290144E4C43;
	Fri,  9 Oct 2026 14:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556544; cv=none; b=oDKzu8SASTxkSa3sVOEq3+OLlnpLHEUUkiOcBCOn7+cdqaBAt993R7PaK22fcy0pssnrAEeT6x8X9eibWTz8ZeeqF2oBFTDgr2+PllDBPRqWbG7XHMSf5Wh3WIyFYuYnksiv5/ID7rdZUx5yPtieJzOgg6LrbW/362BsiNXYJ/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556544; c=relaxed/simple;
	bh=jUkh5hXfqTbuNvgOHKxTedCH+J3ipXaAbWvBihsj2Ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOFja9kNsKlefP+mINIw8YItVUIS6qUKJFTm7P7x/Erl9QA2bjeI7NpPWnW8F+P06Sw1smvTtDme+avu0/nzcwrHLbOcss1nfPdUnRvTa16Zig8ZrfgG9aBB4iYCWJP1s2WMCnDlE6yctITaAtcKjOAoC6DR6rS6Q9vFb4maZlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RLqrjzgA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RLqrjzgA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC501F000FF;
	Fri,  9 Oct 2026 14:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556542;
	bh=MEPcnBeGGwKfh7RXjWVetIrpaBzjoXD5y4HU8erIYJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RLqrjzgAu6uHoZY9ioyUJ+dXaJtVA0WFPQOE4/eBCEVUFVonbdaHKTp7mPBUULWqN
	 b87NHZ784U0zoRE7nksZuyp6WGPXlF6GAb/ZR/oyhkR4YU8V1M/Yt9/gBEiVPkiw2a
	 wli3cMRJF5F0xNYzy5JbLjuThzLGW8opfEKEY+g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Karpicz <webmaster@toradex.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Mehmet Fide <mehmet.fide@screeningeagle.com>
Subject: [PATCH 6.18 252/403] mtd: rawnand: vf610_nfc: fix reads on chips with more than 64 bytes of OOB
Date: Fri,  9 Oct 2026 16:10:13 +0200
Message-ID: <20261009140958.064761155@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

commit 37adc9c5789c76db3b1ee7aeec3999b8503020d0 upstream.

The controller transfers 64 spare bytes per page and the driver only
implements the matching 64-byte ECC layout, so attach_chip() shrinks
mtd->oobsize when the chip provides more. That clamp does not survive:
nand_scan_tail() runs nanddev_init() after ->attach_chip(), and it
restores mtd->oobsize from the memory organization, which still holds
the value detected from the chip. The driver then transfers writesize
plus the chip's full OOB size, the hardware ECC parity ends up at a
different offset than the layout the controller was set up for, and
every ECC-protected read fails with -EBADMSG.

Measured on a Colibri VF61 (MX30LF4G28AC, 2048-byte pages, 112 bytes of
OOB): with the clamp lost, UBI cannot read the erase counter headers of
the pages U-Boot has just written, and the on-flash bad block table
written by an older kernel reads back with ECC errors, so the board
does not boot. Kernels before commit a7ab085d7c16 ("mtd: rawnand:
Initialize the nand_device object") are not affected because nothing
overwrote the clamp there, which is why the same chip works with a v4.4
kernel and with U-Boot, whose copy of this driver has no memory
organization to restore the value from. Edward Karpicz reported that
the clamp no longer takes effect on this chip; see the link below.

Instead of modifying the memory organization, keep the detected OOB
size and give the driver its own mtd_ooblayout_ops: the same layout the
NAND core uses for large pages, but computed on the first 64 OOB bytes
instead of the whole OOB, so the ECC bytes stay where U-Boot and the
old kernels put them. The data paths transfer writesize plus those 64
bytes, as the controller always has.

Since mtd->oobsize now reports the chip's real spare size, fill the
tail of oob_poi with 0xff after the 64 transferred bytes on ECC page
reads: the core may copy the full mtd->oobsize from it, which would
otherwise expose whatever the buffer held before. 0xff also matches
what a raw read returns from flash, since the write path only ever
programs the first 64 spare bytes.

Reported-by: Edward Karpicz <webmaster@toradex.com>
Link: https://community.toradex.com/t/colibri-vf50-vf61-on-the-current-bsp-mainline-u-boot-v2026-07-and-linux-6-18-lts/30735
Suggested-by: Miquel Raynal <miquel.raynal@bootlin.com>
Fixes: a7ab085d7c16 ("mtd: rawnand: Initialize the nand_device object")
Cc: stable@vger.kernel.org
Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/vf610_nfc.c |   72 ++++++++++++++++++++++++++++++++-------
 1 file changed, 60 insertions(+), 12 deletions(-)

--- a/drivers/mtd/nand/raw/vf610_nfc.c
+++ b/drivers/mtd/nand/raw/vf610_nfc.c
@@ -505,6 +505,11 @@ static int vf610_nfc_exec_op(struct nand
 				      check_only);
 }
 
+static unsigned int vf610_nfc_spare_size(struct mtd_info *mtd)
+{
+	return min_t(unsigned int, mtd->oobsize, 64);
+}
+
 static inline int vf610_nfc_correct_data(struct nand_chip *chip, uint8_t *dat,
 					 uint8_t *oob, int page)
 {
@@ -522,7 +527,7 @@ static inline int vf610_nfc_correct_data
 		return ecc_count;
 
 	nfc->data_access = true;
-	nand_read_oob_op(&nfc->chip, page, 0, oob, mtd->oobsize);
+	nand_read_oob_op(&nfc->chip, page, 0, oob, vf610_nfc_spare_size(mtd));
 	nfc->data_access = false;
 
 	/*
@@ -530,7 +535,7 @@ static inline int vf610_nfc_correct_data
 	 * at least less then half of the ECC strength.
 	 */
 	return nand_check_erased_ecc_chunk(dat, nfc->chip.ecc.size, oob,
-					   mtd->oobsize, NULL, 0,
+					   vf610_nfc_spare_size(mtd), NULL, 0,
 					   flips_threshold);
 }
 
@@ -551,7 +556,7 @@ static int vf610_nfc_read_page(struct na
 {
 	struct vf610_nfc *nfc = chip_to_nfc(chip);
 	struct mtd_info *mtd = nand_to_mtd(chip);
-	int trfr_sz = mtd->writesize + mtd->oobsize;
+	int trfr_sz = mtd->writesize + vf610_nfc_spare_size(mtd);
 	u32 row = 0, cmd1 = 0, cmd2 = 0, code = 0;
 	int stat;
 
@@ -577,11 +582,16 @@ static int vf610_nfc_read_page(struct na
 	 */
 	vf610_nfc_rd_from_sram(buf, nfc->regs + NFC_MAIN_AREA(0),
 			       mtd->writesize, false);
-	if (oob_required)
+	if (oob_required) {
+		unsigned int spare = vf610_nfc_spare_size(mtd);
+
 		vf610_nfc_rd_from_sram(chip->oob_poi,
 				       nfc->regs + NFC_MAIN_AREA(0) +
 						   mtd->writesize,
-				       mtd->oobsize, false);
+				       spare, false);
+		/* Not transferred, and never written: reads back erased */
+		memset(chip->oob_poi + spare, 0xff, mtd->oobsize - spare);
+	}
 
 	stat = vf610_nfc_correct_data(chip, buf, chip->oob_poi, page);
 
@@ -599,7 +609,7 @@ static int vf610_nfc_write_page(struct n
 {
 	struct vf610_nfc *nfc = chip_to_nfc(chip);
 	struct mtd_info *mtd = nand_to_mtd(chip);
-	int trfr_sz = mtd->writesize + mtd->oobsize;
+	int trfr_sz = mtd->writesize + vf610_nfc_spare_size(mtd);
 	u32 row = 0, cmd1 = 0, cmd2 = 0, code = 0;
 	u8 status;
 	int ret;
@@ -740,6 +750,49 @@ static void vf610_nfc_init_controller(st
 	}
 }
 
+/*
+ * With 64 byte OOB chips the core's large page layout matches what
+ * U-Boot uses, and on chips with more, U-Boot and older kernels clamped
+ * mtd->oobsize to 64. Modifying the OOB size is no longer possible, the
+ * actual chip geometry must be respected, so to avoid breaking those
+ * existing setups use our own layout: the core's large page one,
+ * computed over the first 64 spare bytes only.
+ */
+static int vf610_nfc_ooblayout_ecc(struct mtd_info *mtd, int section,
+				   struct mtd_oob_region *oobregion)
+{
+	struct nand_device *nand = mtd_to_nanddev(mtd);
+	unsigned int total_ecc_bytes = nand->ecc.ctx.total;
+
+	if (section || !total_ecc_bytes)
+		return -ERANGE;
+
+	oobregion->length = total_ecc_bytes;
+	oobregion->offset = vf610_nfc_spare_size(mtd) - oobregion->length;
+
+	return 0;
+}
+
+static int vf610_nfc_ooblayout_free(struct mtd_info *mtd, int section,
+				    struct mtd_oob_region *oobregion)
+{
+	struct nand_device *nand = mtd_to_nanddev(mtd);
+	unsigned int total_ecc_bytes = nand->ecc.ctx.total;
+
+	if (section)
+		return -ERANGE;
+
+	oobregion->length = vf610_nfc_spare_size(mtd) - total_ecc_bytes - 2;
+	oobregion->offset = 2;
+
+	return 0;
+}
+
+static const struct mtd_ooblayout_ops vf610_nfc_ooblayout_ops = {
+	.ecc = vf610_nfc_ooblayout_ecc,
+	.free = vf610_nfc_ooblayout_free,
+};
+
 static int vf610_nfc_attach_chip(struct nand_chip *chip)
 {
 	struct mtd_info *mtd = nand_to_mtd(chip);
@@ -770,12 +823,7 @@ static int vf610_nfc_attach_chip(struct
 		return -ENXIO;
 	}
 
-	/* Only 64 byte ECC layouts known */
-	if (mtd->oobsize > 64)
-		mtd->oobsize = 64;
-
-	/* Use default large page ECC layout defined in NAND core */
-	mtd_set_ooblayout(mtd, nand_get_large_page_ooblayout());
+	mtd_set_ooblayout(mtd, &vf610_nfc_ooblayout_ops);
 	if (chip->ecc.strength == 32) {
 		nfc->ecc_mode = ECC_60_BYTE;
 		chip->ecc.bytes = 60;


