Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEC81EABAE;
	Mon, 21 Oct 2024 10:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507240; cv=none; b=UuUd8AQPcPViBS4F6hIvgYqRbt+jyIP8FBzI9q5A79SrYrbB/Es8kz8uV3yee7zbV7s9LBIBYEKm3UxrGu8Oenggp+SbZHiquKQV8AyKRVxlTIVtmiyITVOuG0j6TeGpKllubNvzqdiAKGevgemyga34Qb6r76iXJnNl6/etCZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507240; c=relaxed/simple;
	bh=QR5JFqkbWam2jDA3iMh/9GH3SNYwGEa1nCXIZ64w4Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGTi7V5gogTW887JOyXFAeRI2OcY6EpdHOJd6wsnoHbBul/zXLtEg6WLfvQiGtVCEUVEOpt18aHAlUEUmhrgsAk6txwYMhS/BESnh2yZ9s9cP8DEDL1DOKTYyRoWzzi6NfwaegyvsbAd/gL+y1NY1Eer30NpJ0Bs+ZdsnMbQaTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JtJQeF6Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JtJQeF6Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5F8C4CEC3;
	Mon, 21 Oct 2024 10:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507240;
	bh=QR5JFqkbWam2jDA3iMh/9GH3SNYwGEa1nCXIZ64w4Ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JtJQeF6Y3StlSvrlfN3KoAtULuB1CuhdPnsJkQO+GgVJpol9IQVeXLBGssIo2sFZY
	 upwRvZqL5vAmDHjExkl2ZZK9EC+Twnu7+bXd0z/G+rNH+tIsele2uzOg44cGxqXIRV
	 A3sCkWIROlM5jGuT8E/IjptGbyyAHQXWmmduIgCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 6.1 12/91] udf: Convert udf_readdir() to new directory iteration
Date: Mon, 21 Oct 2024 12:24:26 +0200
Message-ID: <20241021102250.285017948@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 7cd7a36ab44d3e8c1dee7185ef407b9831a8220b ]

Convert udf_readdir() to new directory iteration functions.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/dir.c |  148 ++++++++++-------------------------------------------------
 1 file changed, 27 insertions(+), 121 deletions(-)

--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -39,26 +39,13 @@
 static int udf_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct inode *dir = file_inode(file);
-	struct udf_inode_info *iinfo = UDF_I(dir);
-	struct udf_fileident_bh fibh = { .sbh = NULL, .ebh = NULL};
-	struct fileIdentDesc *fi = NULL;
-	struct fileIdentDesc cfi;
-	udf_pblk_t block, iblock;
 	loff_t nf_pos, emit_pos = 0;
 	int flen;
-	unsigned char *fname = NULL, *copy_name = NULL;
-	unsigned char *nameptr;
-	uint16_t liu;
-	uint8_t lfi;
-	loff_t size = udf_ext0_offset(dir) + dir->i_size;
-	struct buffer_head *tmp, *bha[16];
-	struct kernel_lb_addr eloc;
-	uint32_t elen;
-	sector_t offset;
-	int i, num, ret = 0;
-	struct extent_position epos = { NULL, 0, {0, 0} };
+	unsigned char *fname = NULL;
+	int ret = 0;
 	struct super_block *sb = dir->i_sb;
 	bool pos_valid = false;
+	struct udf_fileident_iter iter;
 
 	if (ctx->pos == 0) {
 		if (!dir_emit_dot(file, ctx))
@@ -66,7 +53,7 @@ static int udf_readdir(struct file *file
 		ctx->pos = 1;
 	}
 	nf_pos = (ctx->pos - 1) << 2;
-	if (nf_pos >= size)
+	if (nf_pos >= dir->i_size)
 		goto out;
 
 	/*
@@ -90,138 +77,57 @@ static int udf_readdir(struct file *file
 		goto out;
 	}
 
-	if (nf_pos == 0)
-		nf_pos = udf_ext0_offset(dir);
-
-	fibh.soffset = fibh.eoffset = nf_pos & (sb->s_blocksize - 1);
-	if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB) {
-		if (inode_bmap(dir, nf_pos >> sb->s_blocksize_bits,
-		    &epos, &eloc, &elen, &offset)
-		    != (EXT_RECORDED_ALLOCATED >> 30)) {
-			ret = -ENOENT;
-			goto out;
-		}
-		block = udf_get_lb_pblock(sb, &eloc, offset);
-		if ((++offset << sb->s_blocksize_bits) < elen) {
-			if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
-				epos.offset -= sizeof(struct short_ad);
-			else if (iinfo->i_alloc_type ==
-					ICBTAG_FLAG_AD_LONG)
-				epos.offset -= sizeof(struct long_ad);
-		} else {
-			offset = 0;
-		}
-
-		if (!(fibh.sbh = fibh.ebh = udf_tread(sb, block))) {
-			ret = -EIO;
-			goto out;
-		}
-
-		if (!(offset & ((16 >> (sb->s_blocksize_bits - 9)) - 1))) {
-			i = 16 >> (sb->s_blocksize_bits - 9);
-			if (i + offset > (elen >> sb->s_blocksize_bits))
-				i = (elen >> sb->s_blocksize_bits) - offset;
-			for (num = 0; i > 0; i--) {
-				block = udf_get_lb_pblock(sb, &eloc, offset + i);
-				tmp = udf_tgetblk(sb, block);
-				if (tmp && !buffer_uptodate(tmp) && !buffer_locked(tmp))
-					bha[num++] = tmp;
-				else
-					brelse(tmp);
-			}
-			if (num) {
-				bh_readahead_batch(num, bha, REQ_RAHEAD);
-				for (i = 0; i < num; i++)
-					brelse(bha[i]);
-			}
-		}
-	}
-
-	while (nf_pos < size) {
+	for (ret = udf_fiiter_init(&iter, dir, nf_pos);
+	     !ret && iter.pos < dir->i_size;
+	     ret = udf_fiiter_advance(&iter)) {
 		struct kernel_lb_addr tloc;
-		loff_t cur_pos = nf_pos;
-
-		/* Update file position only if we got past the current one */
-		if (nf_pos >= emit_pos) {
-			ctx->pos = (nf_pos >> 2) + 1;
-			pos_valid = true;
-		}
+		udf_pblk_t iblock;
 
-		fi = udf_fileident_read(dir, &nf_pos, &fibh, &cfi, &epos, &eloc,
-					&elen, &offset);
-		if (!fi)
-			goto out;
 		/* Still not at offset where user asked us to read from? */
-		if (cur_pos < emit_pos)
+		if (iter.pos < emit_pos)
 			continue;
 
-		liu = le16_to_cpu(cfi.lengthOfImpUse);
-		lfi = cfi.lengthFileIdent;
-
-		if (fibh.sbh == fibh.ebh) {
-			nameptr = udf_get_fi_ident(fi);
-		} else {
-			int poffset;	/* Unpaded ending offset */
-
-			poffset = fibh.soffset + sizeof(struct fileIdentDesc) + liu + lfi;
-
-			if (poffset >= lfi) {
-				nameptr = (char *)(fibh.ebh->b_data + poffset - lfi);
-			} else {
-				if (!copy_name) {
-					copy_name = kmalloc(UDF_NAME_LEN,
-							    GFP_NOFS);
-					if (!copy_name) {
-						ret = -ENOMEM;
-						goto out;
-					}
-				}
-				nameptr = copy_name;
-				memcpy(nameptr, udf_get_fi_ident(fi),
-				       lfi - poffset);
-				memcpy(nameptr + lfi - poffset,
-				       fibh.ebh->b_data, poffset);
-			}
-		}
+		/* Update file position only if we got past the current one */
+		pos_valid = true;
+		ctx->pos = (iter.pos >> 2) + 1;
 
-		if ((cfi.fileCharacteristics & FID_FILE_CHAR_DELETED) != 0) {
+		if (iter.fi.fileCharacteristics & FID_FILE_CHAR_DELETED) {
 			if (!UDF_QUERY_FLAG(sb, UDF_FLAG_UNDELETE))
 				continue;
 		}
 
-		if ((cfi.fileCharacteristics & FID_FILE_CHAR_HIDDEN) != 0) {
+		if (iter.fi.fileCharacteristics & FID_FILE_CHAR_HIDDEN) {
 			if (!UDF_QUERY_FLAG(sb, UDF_FLAG_UNHIDE))
 				continue;
 		}
 
-		if (cfi.fileCharacteristics & FID_FILE_CHAR_PARENT) {
+		if (iter.fi.fileCharacteristics & FID_FILE_CHAR_PARENT) {
 			if (!dir_emit_dotdot(file, ctx))
-				goto out;
+				goto out_iter;
 			continue;
 		}
 
-		flen = udf_get_filename(sb, nameptr, lfi, fname, UDF_NAME_LEN);
+		flen = udf_get_filename(sb, iter.name,
+				iter.fi.lengthFileIdent, fname, UDF_NAME_LEN);
 		if (flen < 0)
 			continue;
 
-		tloc = lelb_to_cpu(cfi.icb.extLocation);
+		tloc = lelb_to_cpu(iter.fi.icb.extLocation);
 		iblock = udf_get_lb_pblock(sb, &tloc, 0);
 		if (!dir_emit(ctx, fname, flen, iblock, DT_UNKNOWN))
-			goto out;
-	} /* end while */
-
-	ctx->pos = (nf_pos >> 2) + 1;
-	pos_valid = true;
+			goto out_iter;
+	}
 
+	if (!ret) {
+		ctx->pos = (iter.pos >> 2) + 1;
+		pos_valid = true;
+	}
+out_iter:
+	udf_fiiter_release(&iter);
 out:
 	if (pos_valid)
 		file->f_version = inode_query_iversion(dir);
-	if (fibh.sbh != fibh.ebh)
-		brelse(fibh.ebh);
-	brelse(fibh.sbh);
-	brelse(epos.bh);
 	kfree(fname);
-	kfree(copy_name);
 
 	return ret;
 }


