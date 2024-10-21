Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4830C1E47B2;
	Mon, 21 Oct 2024 10:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507529; cv=none; b=RDviW0by3VV30F0DItGsE1puCHflOHg7o2OYQf9WxNYpNZ+H5smmaO0lIOo0oIfvsYdb+bNosWG6o+JnwjRm+//4vLt4qoJB6dfIFePUIhCbBD0FDyPruBXTwClxAieI+9ATt4by+0oLUmUVrZDd7tlCwtNBi244AdHmTn0wD4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507529; c=relaxed/simple;
	bh=zU46pkGc6+Jny5hMoN97pDu3d8iWX3dnwrJr7KzL4+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfIN9NIkGMbupdWDKU3od+ybCBhuQZyMVfLnkb+zFtqhSgVqyH2DVYhFXSQiXLJ2CE/BXdxLI4Z8dT3dJIjduykeZj59nl/uTvhEvRyIiFnj8emu1/Lt5ApK5CbYHnh7DHfkPr33l/1gfJQBkoTHI59ULE/NvEGy7/NriKetXy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgDioFYN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgDioFYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0AEC4CEC3;
	Mon, 21 Oct 2024 10:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507528;
	bh=zU46pkGc6+Jny5hMoN97pDu3d8iWX3dnwrJr7KzL4+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgDioFYNy4HtyvVaP13zYB5d0aKqrOOCpvY+3hX2pqCCLhhZwMDlpXP74TIspaRP7
	 QSKYCudqceiTOQZw9dTcLqzMrLKVJvdYSnsDgBAvxlLe/kKhc5vUyR5+F1UHN5XmWD
	 jsA6vrsO+1uYgzakGeYA9uc4sksNKsd8CAcKM4wE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.15 08/82] udf: Convert udf_readdir() to new directory iteration
Date: Mon, 21 Oct 2024 12:24:49 +0200
Message-ID: <20241021102247.551495100@linuxfoundation.org>
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

[ Upstream commit 7cd7a36ab44d3e8c1dee7185ef407b9831a8220b ]

Convert udf_readdir() to new directory iteration functions.

Signed-off-by: Jan Kara <jack@suse.cz>
[cascardo: conflict due to skipped 59a16786fa7a ("udf: replace ll_rw_block()")]
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
-				ll_rw_block(REQ_OP_READ, REQ_RAHEAD, num, bha);
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


