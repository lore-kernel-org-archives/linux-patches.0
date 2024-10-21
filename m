Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1911239FD6;
	Mon, 21 Oct 2024 10:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507568; cv=none; b=ovEt2+jGmSn9JaqCiDq9fKrpsYU2WBqKeXcU8qM6qLThVa2pNfCf1hD3jXU8uW5jGCAkG0w/6930zL2+e6QjBYWJTaE/C8IV7R/AIJl2bqAA4ZWafSUjk/KV5kvbjKTpxA5+O+3/pbD8Lbty1jH5ZkLE5Rsfqy1Pc0g34pqfPKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507568; c=relaxed/simple;
	bh=zzuedcecjQLLE3iAVELXdv3AUqE5HS1aj3SRf1qXlVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PA2iw48vRVqj9urQNOGbvinwUGjNCou3HSRDs2sZZFYORKHpGoEpByk9c7fx7rXwzvVEFU/8NQ3xzkf/loUR1abwFDtfdWKuZX8ex852HF/F6kjTgIhI5yhoJcL782acaJ1yrY6FQZLCiJPAJyZsqfAWzMUUqXCp4vgChCPRePA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glFJqyWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glFJqyWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8951DC4CEC7;
	Mon, 21 Oct 2024 10:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507567;
	bh=zzuedcecjQLLE3iAVELXdv3AUqE5HS1aj3SRf1qXlVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glFJqyWuFciybb6Z2hL2HwJrA1mF+jUFgxBmiL2oHDE2C67mWCIuEqJuZwc+zUWaD
	 iucy2gBP75FZaO1LVvk+ISBfbt9FxkezK1Q2KX8/bVXF3eiTUZ1nrr5QMMGXK21VE5
	 CnRgbEG0ce2wtFp2ZjM2iI4LJ6evwm2mqplZDK4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.15 11/82] udf: Convert empty_dir() to new directory iteration code
Date: Mon, 21 Oct 2024 12:24:52 +0200
Message-ID: <20241021102247.673170229@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit afb525f466f9fdc140b975221cb43fbb5c59314e ]

Convert empty_dir() to new directory iteration code.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/namei.c |   68 +++++++--------------------------------------------------
 1 file changed, 9 insertions(+), 59 deletions(-)

--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -879,69 +879,19 @@ out:
 
 static int empty_dir(struct inode *dir)
 {
-	struct fileIdentDesc *fi, cfi;
-	struct udf_fileident_bh fibh;
-	loff_t f_pos;
-	loff_t size = udf_ext0_offset(dir) + dir->i_size;
-	udf_pblk_t block;
-	struct kernel_lb_addr eloc;
-	uint32_t elen;
-	sector_t offset;
-	struct extent_position epos = {};
-	struct udf_inode_info *dinfo = UDF_I(dir);
+	struct udf_fileident_iter iter;
+	int ret;
 
-	f_pos = udf_ext0_offset(dir);
-	fibh.soffset = fibh.eoffset = f_pos & (dir->i_sb->s_blocksize - 1);
-
-	if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
-		fibh.sbh = fibh.ebh = NULL;
-	else if (inode_bmap(dir, f_pos >> dir->i_sb->s_blocksize_bits,
-			      &epos, &eloc, &elen, &offset) ==
-					(EXT_RECORDED_ALLOCATED >> 30)) {
-		block = udf_get_lb_pblock(dir->i_sb, &eloc, offset);
-		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
-			if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
-				epos.offset -= sizeof(struct short_ad);
-			else if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
-				epos.offset -= sizeof(struct long_ad);
-		} else
-			offset = 0;
-
-		fibh.sbh = fibh.ebh = udf_tread(dir->i_sb, block);
-		if (!fibh.sbh) {
-			brelse(epos.bh);
-			return 0;
-		}
-	} else {
-		brelse(epos.bh);
-		return 0;
-	}
-
-	while (f_pos < size) {
-		fi = udf_fileident_read(dir, &f_pos, &fibh, &cfi, &epos, &eloc,
-					&elen, &offset);
-		if (!fi) {
-			if (fibh.sbh != fibh.ebh)
-				brelse(fibh.ebh);
-			brelse(fibh.sbh);
-			brelse(epos.bh);
-			return 0;
-		}
-
-		if (cfi.lengthFileIdent &&
-		    (cfi.fileCharacteristics & FID_FILE_CHAR_DELETED) == 0) {
-			if (fibh.sbh != fibh.ebh)
-				brelse(fibh.ebh);
-			brelse(fibh.sbh);
-			brelse(epos.bh);
+	for (ret = udf_fiiter_init(&iter, dir, 0);
+	     !ret && iter.pos < dir->i_size;
+	     ret = udf_fiiter_advance(&iter)) {
+		if (iter.fi.lengthFileIdent &&
+		    !(iter.fi.fileCharacteristics & FID_FILE_CHAR_DELETED)) {
+			udf_fiiter_release(&iter);
 			return 0;
 		}
 	}
-
-	if (fibh.sbh != fibh.ebh)
-		brelse(fibh.ebh);
-	brelse(fibh.sbh);
-	brelse(epos.bh);
+	udf_fiiter_release(&iter);
 
 	return 1;
 }


