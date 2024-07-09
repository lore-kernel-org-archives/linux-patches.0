Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E01814EC4D;
	Tue,  9 Jul 2024 11:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523798; cv=none; b=aa7SlCMd1B401ECnp3XGje8N8cVgJSMATCE+sdX+zMQ8LQcbEr9DFoBYkN4zgW/dsSBaQ53p7DB4+qLOdLiGqT7E7mFqrwZyyyeLfOUbunBn/SvNE6ZKgWACGKT/pC/YSsqEP0uU4948uSEnyjvdRbN2eBZ4jDw+x+Sq07pCZ8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523798; c=relaxed/simple;
	bh=8xiRQLJBCK3nWis9cfOD3wLvtJV83RGmVz47sOzprCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXdl5vsD+GjgLbMoo7xJ4hmxa/KTN3sE3RV8VOWEqr8uT66AZnbVDspGnimgYzM4EsHMjD7uzSZDLXXYHeQIHow8/fOTcOOYYlr76u0n9Yz4G+oYm2fTYVm2iV0adGOkJZCPvekLGwnwpZMcUKRt1auJypw+mWaLMdubl7C3zF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NRNT1bGC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NRNT1bGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235BAC32786;
	Tue,  9 Jul 2024 11:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523798;
	bh=8xiRQLJBCK3nWis9cfOD3wLvtJV83RGmVz47sOzprCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NRNT1bGCQJmCnxTQCie1gY6Mf7dos3GaGILg/QwUTkH3VTv53f57l78xP7lUJGTQA
	 02Pv1wvvGB/xe5dhRjTzuHox1EIhLgI5E39xzjpw0ePhOacAQ+DSV9TrVIY1Uz7AQ+
	 7kUiJ8t0vS4ytLJD7tDr7W4XJhb4pQ2hlQBWcb9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Dahl <ada@thorsis.com>,
	Steven Seeger <steven.seeger@flightsystems.net>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 6.6 111/139] mtd: rawnand: Bypass a couple of sanity checks during NAND identification
Date: Tue,  9 Jul 2024 13:10:11 +0200
Message-ID: <20240709110702.464212385@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 8754d9835683e8fab9a8305acdb38a3aeb9d20bd upstream.

Early during NAND identification, mtd_info fields have not yet been
initialized (namely, writesize and oobsize) and thus cannot be used for
sanity checks yet. Of course if there is a misuse of
nand_change_read_column_op() so early we won't be warned, but there is
anyway no actual check to perform at this stage as we do not yet know
the NAND geometry.

So, if the fields are empty, especially mtd->writesize which is *always*
set quite rapidly after identification, let's skip the sanity checks.

nand_change_read_column_op() is subject to be used early for ONFI/JEDEC
identification in the very unlikely case of:
- bitflips appearing in the parameter page,
- the controller driver not supporting simple DATA_IN cycles.

As nand_change_read_column_op() uses nand_fill_column_cycles() the logic
explaind above also applies in this secondary helper.

Fixes: c27842e7e11f ("mtd: rawnand: onfi: Adapt the parameter page read to constraint controllers")
Fixes: daca31765e8b ("mtd: rawnand: jedec: Adapt the parameter page read to constraint controllers")
Cc: stable@vger.kernel.org
Reported-by: Alexander Dahl <ada@thorsis.com>
Closes: https://lore.kernel.org/linux-mtd/20240306-shaky-bunion-d28b65ea97d7@thorsis.com/
Reported-by: Steven Seeger <steven.seeger@flightsystems.net>
Closes: https://lore.kernel.org/linux-mtd/DM6PR05MB4506554457CF95191A670BDEF7062@DM6PR05MB4506.namprd05.prod.outlook.com/
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://lore.kernel.org/linux-mtd/20240516131320.579822-3-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/nand_base.c |   57 +++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 25 deletions(-)

--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -1090,28 +1090,32 @@ static int nand_fill_column_cycles(struc
 				   unsigned int offset_in_page)
 {
 	struct mtd_info *mtd = nand_to_mtd(chip);
+	bool ident_stage = !mtd->writesize;
 
-	/* Make sure the offset is less than the actual page size. */
-	if (offset_in_page > mtd->writesize + mtd->oobsize)
-		return -EINVAL;
-
-	/*
-	 * On small page NANDs, there's a dedicated command to access the OOB
-	 * area, and the column address is relative to the start of the OOB
-	 * area, not the start of the page. Asjust the address accordingly.
-	 */
-	if (mtd->writesize <= 512 && offset_in_page >= mtd->writesize)
-		offset_in_page -= mtd->writesize;
-
-	/*
-	 * The offset in page is expressed in bytes, if the NAND bus is 16-bit
-	 * wide, then it must be divided by 2.
-	 */
-	if (chip->options & NAND_BUSWIDTH_16) {
-		if (WARN_ON(offset_in_page % 2))
+	/* Bypass all checks during NAND identification */
+	if (likely(!ident_stage)) {
+		/* Make sure the offset is less than the actual page size. */
+		if (offset_in_page > mtd->writesize + mtd->oobsize)
 			return -EINVAL;
 
-		offset_in_page /= 2;
+		/*
+		 * On small page NANDs, there's a dedicated command to access the OOB
+		 * area, and the column address is relative to the start of the OOB
+		 * area, not the start of the page. Asjust the address accordingly.
+		 */
+		if (mtd->writesize <= 512 && offset_in_page >= mtd->writesize)
+			offset_in_page -= mtd->writesize;
+
+		/*
+		 * The offset in page is expressed in bytes, if the NAND bus is 16-bit
+		 * wide, then it must be divided by 2.
+		 */
+		if (chip->options & NAND_BUSWIDTH_16) {
+			if (WARN_ON(offset_in_page % 2))
+				return -EINVAL;
+
+			offset_in_page /= 2;
+		}
 	}
 
 	addrs[0] = offset_in_page;
@@ -1120,7 +1124,7 @@ static int nand_fill_column_cycles(struc
 	 * Small page NANDs use 1 cycle for the columns, while large page NANDs
 	 * need 2
 	 */
-	if (mtd->writesize <= 512)
+	if (!ident_stage && mtd->writesize <= 512)
 		return 1;
 
 	addrs[1] = offset_in_page >> 8;
@@ -1419,16 +1423,19 @@ int nand_change_read_column_op(struct na
 			       unsigned int len, bool force_8bit)
 {
 	struct mtd_info *mtd = nand_to_mtd(chip);
+	bool ident_stage = !mtd->writesize;
 
 	if (len && !buf)
 		return -EINVAL;
 
-	if (offset_in_page + len > mtd->writesize + mtd->oobsize)
-		return -EINVAL;
+	if (!ident_stage) {
+		if (offset_in_page + len > mtd->writesize + mtd->oobsize)
+			return -EINVAL;
 
-	/* Small page NANDs do not support column change. */
-	if (mtd->writesize <= 512)
-		return -ENOTSUPP;
+		/* Small page NANDs do not support column change. */
+		if (mtd->writesize <= 512)
+			return -ENOTSUPP;
+	}
 
 	if (nand_has_exec_op(chip)) {
 		const struct nand_interface_config *conf =


