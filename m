Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43633F9D9;
	Mon, 29 Jan 2024 17:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548443; cv=none; b=uNiT5dOdA0ycE6CArT0JALcFxDp4gYWuYFSVXMs5M3K6c7zfZ8oIl/pYpe2dMSfcbvRKIB0obsGQ/5a3KIsi4DLFSh5Sx297BC2aoyd3ZxJhUy6MJMwCO2FF4qZOuL4l8L5hMddbMIt0AFkNJn4qtDzpObjByIpKlyendgjkK/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548443; c=relaxed/simple;
	bh=8l0xOgh8wXIbn2gF4TxHVK3yaL6kQJPQoHxjULxgZ5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dHHkiQchiIhfqgN9sw2Ij1gAbsH9G/nVbGCukfhS3ccaoV3By+5KmbdOqoxbqTxZamtTSFPr7CxcBH4h9CoHA1xnRJ4udBEekLJGabNWYlOOwmeh8LOU+Kprh13AMbj5xlXjYw/kGh/PkUKNKggW9nJv9EDqSKBkVHuYkyx2T0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/0X27RT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/0X27RT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C717C43390;
	Mon, 29 Jan 2024 17:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548443;
	bh=8l0xOgh8wXIbn2gF4TxHVK3yaL6kQJPQoHxjULxgZ5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/0X27RTOpO8hqt4vL4+pd8Ny93kz4ZdYqjvzWurbesmAm4PM3DdWrMG4rrCTHphT
	 rLpK7eNQrrgxvz7pl23NGod1cHBqjS1OGA68cMZVcCivW62y6ymhgYjEhO7FfgIx8/
	 8/7KIsBgYSvupwUql2remXrZdu25cIMmDK+45HnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	=?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>
Subject: [PATCH 6.6 049/331] mtd: rawnand: Clarify conditions to enable continuous reads
Date: Mon, 29 Jan 2024 09:01:53 -0800
Message-ID: <20240129170016.367435357@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 828f6df1bcba7f64729166efc7086ea657070445 upstream.

The current logic is probably fine but is a bit convoluted. Plus, we
don't want partial pages to be part of the sequential operation just in
case the core would optimize the page read with a subpage read (which
would break the sequence). This may happen on the first and last page
only, so if the start offset or the end offset is not aligned with a
page boundary, better avoid them to prevent any risk.

Cc: stable@vger.kernel.org
Fixes: 003fe4b9545b ("mtd: rawnand: Support for sequential cache reads")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Tested-by: Martin Hundebøll <martin@geanix.com>
Link: https://lore.kernel.org/linux-mtd/20231215123208.516590-5-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/nand_base.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -3461,21 +3461,29 @@ static void rawnand_enable_cont_reads(st
 				      u32 readlen, int col)
 {
 	struct mtd_info *mtd = nand_to_mtd(chip);
+	unsigned int end_page, end_col;
+
+	chip->cont_read.ongoing = false;
 
 	if (!chip->controller->supported_op.cont_read)
 		return;
 
-	if ((col && col + readlen < (3 * mtd->writesize)) ||
-	    (!col && readlen < (2 * mtd->writesize))) {
-		chip->cont_read.ongoing = false;
+	end_page = DIV_ROUND_UP(col + readlen, mtd->writesize);
+	end_col = (col + readlen) % mtd->writesize;
+
+	if (col)
+		page++;
+
+	if (end_col && end_page)
+		end_page--;
+
+	if (page + 1 > end_page)
 		return;
-	}
 
-	chip->cont_read.ongoing = true;
 	chip->cont_read.first_page = page;
-	if (col)
-		chip->cont_read.first_page++;
-	chip->cont_read.last_page = page + ((readlen >> chip->page_shift) & chip->pagemask);
+	chip->cont_read.last_page = end_page;
+	chip->cont_read.ongoing = true;
+
 	rawnand_cap_cont_reads(chip);
 }
 


