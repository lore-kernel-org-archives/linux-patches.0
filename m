Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CB343302F;
	Tue, 21 Jul 2026 19:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663802; cv=none; b=RmASUSPekXfaIqdB+ygu6qpFfPNWEI6SbI7/RsDyzUHp6Bt1xZ7so6RI6X4FQ1q3HwEvwpOmh3bj5RpptyuJItTW2gxLDyDQCR910ba0szwa3hSzo3mkQLf07iAGfB0V/+UbWVrvtJ+6fZya1ZnLgGMVTNguMuFQ523VIdMBg3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663802; c=relaxed/simple;
	bh=YCjv70h41dttxp+HRoyRer3/gLiI90dL5AyUA5FJlsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nUYRf6KZ39MB+NMS1tVjI9eS0SMxuOqszuRyV3ZFBFg9i6NawXNFwn8kgofLZmiXjiXQKJCa4kY6c94Y3joWDrhacLtX7JjKMCTWL7t4E2a88XhwTz25JV6WjG49N+v790c1BsQyLH51HDOgOOuC69u5Rsug6Ly+2lCttfWXg6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vbp7p3xf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vbp7p3xf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173841F000E9;
	Tue, 21 Jul 2026 19:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663800;
	bh=Z2vSRltc2Im7dmikrgI2x0ePK9sH8d9mmmYPgsqtTyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vbp7p3xfgabD9qi1AxIbA2Cq52xU7C/vziiCRaZAcEQSSl0Vff2ULo6vUFTg+zSQP
	 5SBBkxskllTdTPKBQmLIr5j93wEBzd5qXv0uRkImCW/WAj3LJ1Vi3NGH/QnCbl+QZa
	 YGEx5I4Bd1BCYglWFzStyq3IeW7iulU0dgv72FlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 0959/1276] mtd: rawnand: Pause continuous reads at block boundaries
Date: Tue, 21 Jul 2026 17:23:22 +0200
Message-ID: <20260721152507.488317675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

commit 8e4531667d718e2e9b193928cf9b2497fa0d01ef upstream.

Some chips do not support sequential cached reads past block
boundaries, like Winbond. In practice when using UBI, this should very
rarely happen, but let's make sure it never happens.

Cc: stable@vger.kernel.org
Fixes: 003fe4b9545b ("mtd: rawnand: Support for sequential cache reads")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/nand_base.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -1215,32 +1215,32 @@ static int nand_lp_exec_read_page_op(str
 	return nand_exec_op(chip, &op);
 }
 
-static unsigned int rawnand_last_page_of_lun(unsigned int pages_per_lun, unsigned int lun)
+static unsigned int rawnand_last_page_of_block(unsigned int ppb, unsigned int block)
 {
-	/* lun is expected to be very small */
-	return (lun * pages_per_lun) + pages_per_lun - 1;
+	/* block is expected to be very small */
+	return (block * ppb) + ppb - 1;
 }
 
 static void rawnand_cap_cont_reads(struct nand_chip *chip)
 {
 	struct nand_memory_organization *memorg;
-	unsigned int ppl, first_lun, last_lun;
+	unsigned int ppb, first_block, last_block;
 
 	memorg = nanddev_get_memorg(&chip->base);
-	ppl = memorg->pages_per_eraseblock * memorg->eraseblocks_per_lun;
-	first_lun = chip->cont_read.first_page / ppl;
-	last_lun = chip->cont_read.last_page / ppl;
-
-	/* Prevent sequential cache reads across LUN boundaries */
-	if (first_lun != last_lun)
-		chip->cont_read.pause_page = rawnand_last_page_of_lun(ppl, first_lun);
+	ppb = memorg->pages_per_eraseblock;
+	first_block = chip->cont_read.first_page / ppb;
+	last_block = chip->cont_read.last_page / ppb;
+
+	/* Prevent sequential cache reads across block boundaries */
+	if (first_block != last_block)
+		chip->cont_read.pause_page = rawnand_last_page_of_block(ppb, first_block);
 	else
 		chip->cont_read.pause_page = chip->cont_read.last_page;
 
 	if (chip->cont_read.first_page == chip->cont_read.pause_page) {
 		chip->cont_read.first_page++;
 		chip->cont_read.pause_page = min(chip->cont_read.last_page,
-						 rawnand_last_page_of_lun(ppl, first_lun + 1));
+						 rawnand_last_page_of_block(ppb, first_block + 1));
 	}
 
 	if (chip->cont_read.first_page >= chip->cont_read.last_page)


