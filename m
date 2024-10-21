Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FFC1E47C9;
	Mon, 21 Oct 2024 10:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507258; cv=none; b=t8MmRlw7Uyl1MksoYaPrx4SSX7cSkgoxYooKe6azPb+iQbVVaM8Abu6N1olN0aVqCiOiAuC0GZg9xpZDl/n1OPdI3WqgYydl4xjVfRbN28zJYP7R1Knwsq4ZlJ+204Fa4zdR+j3dbyg4rCF/sQpLvdwVUAhcF2j4PFf2sfKQS58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507258; c=relaxed/simple;
	bh=jsi1UiDf6PqzxyOYMy6TI6u140pgoC0P2gnNIRyQLU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fF6Y1xUIP64+FH3w/Rv/FtvXtdVer5pQHJoVMyppo/+6uD33a/Cpen58RTE+C1z8oUJRy5WGSqOOwaYuGQZQUN1NS+crkqzyDY0c/EZHROF1ummqO6XeBJ2DbMq5YTg1+PxxB5U4fGU7dN8EvkeAHQqJHUm/m2eRwHpyNvS7WTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Apq579h/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Apq579h/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17222C4CEE5;
	Mon, 21 Oct 2024 10:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507258;
	bh=jsi1UiDf6PqzxyOYMy6TI6u140pgoC0P2gnNIRyQLU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Apq579h/j30Z97Ml+QrS7eVchKRCrRqydxKV9qksl+klUuIiArA/74pdB1k+mfyXp
	 BcHaLen7oxG9ty99Xoo4tdNnxC7Pr9OHasNyMjzqnP58xhGxp3XO3X7ZQi6dUKn+zA
	 AXAad5rbU3T1sIBnoRPTI6lW8UeA3rJJ9xSgV0DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 6.1 18/91] udf: Implement adding of dir entries using new iteration code
Date: Mon, 21 Oct 2024 12:24:32 +0200
Message-ID: <20241021102250.525671494@linuxfoundation.org>
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

[ Upstream commit f2844803404d9729f893e279ddea12678710e7fb ]

Implement function udf_fiiter_add_entry() adding new directory entries
using new directory iteration code.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/directory.c |   57 +++++++++++++++++++++++++++
 fs/udf/namei.c     |  110 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/udf/udfdecl.h   |    2 
 3 files changed, 169 insertions(+)

--- a/fs/udf/directory.c
+++ b/fs/udf/directory.c
@@ -413,6 +413,63 @@ void udf_fiiter_write_fi(struct udf_file
 	inode_inc_iversion(iter->dir);
 }
 
+void udf_fiiter_update_elen(struct udf_fileident_iter *iter, uint32_t new_elen)
+{
+	struct udf_inode_info *iinfo = UDF_I(iter->dir);
+	int diff = new_elen - iter->elen;
+
+	/* Skip update when we already went past the last extent */
+	if (!iter->elen)
+		return;
+	iter->elen = new_elen;
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
+		iter->epos.offset -= sizeof(struct short_ad);
+	else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
+		iter->epos.offset -= sizeof(struct long_ad);
+	udf_write_aext(iter->dir, &iter->epos, &iter->eloc, iter->elen, 1);
+	iinfo->i_lenExtents += diff;
+	mark_inode_dirty(iter->dir);
+}
+
+/* Append new block to directory. @iter is expected to point at EOF */
+int udf_fiiter_append_blk(struct udf_fileident_iter *iter)
+{
+	struct udf_inode_info *iinfo = UDF_I(iter->dir);
+	int blksize = 1 << iter->dir->i_blkbits;
+	struct buffer_head *bh;
+	sector_t block;
+	uint32_t old_elen = iter->elen;
+	int err;
+
+	if (WARN_ON_ONCE(iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB))
+		return -EINVAL;
+
+	/* Round up last extent in the file */
+	udf_fiiter_update_elen(iter, ALIGN(iter->elen, blksize));
+
+	/* Allocate new block and refresh mapping information */
+	block = iinfo->i_lenExtents >> iter->dir->i_blkbits;
+	bh = udf_bread(iter->dir, block, 1, &err);
+	if (!bh) {
+		udf_fiiter_update_elen(iter, old_elen);
+		return err;
+	}
+	if (inode_bmap(iter->dir, block, &iter->epos, &iter->eloc, &iter->elen,
+		       &iter->loffset) != (EXT_RECORDED_ALLOCATED >> 30)) {
+		udf_err(iter->dir->i_sb,
+			"block %llu not allocated in directory (ino %lu)\n",
+			(unsigned long long)block, iter->dir->i_ino);
+		return -EFSCORRUPTED;
+	}
+	if (!(iter->pos & (blksize - 1))) {
+		brelse(iter->bh[0]);
+		iter->bh[0] = bh;
+	} else {
+		iter->bh[1] = bh;
+	}
+	return 0;
+}
+
 struct fileIdentDesc *udf_fileident_read(struct inode *dir, loff_t *nf_pos,
 					 struct udf_fileident_bh *fibh,
 					 struct fileIdentDesc *cfi,
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -472,6 +472,116 @@ static struct buffer_head *udf_expand_di
 	return dbh;
 }
 
+static int udf_fiiter_add_entry(struct inode *dir, struct dentry *dentry,
+				struct udf_fileident_iter *iter)
+{
+	struct udf_inode_info *dinfo = UDF_I(dir);
+	int nfidlen, namelen = 0;
+	int ret;
+	int off, blksize = 1 << dir->i_blkbits;
+	udf_pblk_t block;
+	char name[UDF_NAME_LEN_CS0];
+
+	if (dentry) {
+		if (!dentry->d_name.len)
+			return -EINVAL;
+		namelen = udf_put_filename(dir->i_sb, dentry->d_name.name,
+					   dentry->d_name.len,
+					   name, UDF_NAME_LEN_CS0);
+		if (!namelen)
+			return -ENAMETOOLONG;
+	}
+	nfidlen = ALIGN(sizeof(struct fileIdentDesc) + namelen, UDF_NAME_PAD);
+
+	for (ret = udf_fiiter_init(iter, dir, 0);
+	     !ret && iter->pos < dir->i_size;
+	     ret = udf_fiiter_advance(iter)) {
+		if (iter->fi.fileCharacteristics & FID_FILE_CHAR_DELETED) {
+			if (udf_dir_entry_len(&iter->fi) == nfidlen) {
+				iter->fi.descTag.tagSerialNum = cpu_to_le16(1);
+				iter->fi.fileVersionNum = cpu_to_le16(1);
+				iter->fi.fileCharacteristics = 0;
+				iter->fi.lengthFileIdent = namelen;
+				iter->fi.lengthOfImpUse = cpu_to_le16(0);
+				memcpy(iter->namebuf, name, namelen);
+				iter->name = iter->namebuf;
+				return 0;
+			}
+		}
+	}
+	if (ret) {
+		udf_fiiter_release(iter);
+		return ret;
+	}
+	if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB &&
+	    blksize - udf_ext0_offset(dir) - iter->pos < nfidlen) {
+		struct buffer_head *retbh;
+
+		udf_fiiter_release(iter);
+		/*
+		 * FIXME: udf_expand_dir_adinicb does not need to return bh
+		 * once other users are gone
+		 */
+		retbh = udf_expand_dir_adinicb(dir, &block, &ret);
+		if (!retbh)
+			return ret;
+		brelse(retbh);
+		ret = udf_fiiter_init(iter, dir, dir->i_size);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* Get blocknumber to use for entry tag */
+	if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
+		block = dinfo->i_location.logicalBlockNum;
+	} else {
+		block = iter->eloc.logicalBlockNum +
+				((iter->elen - 1) >> dir->i_blkbits);
+	}
+	off = iter->pos & (blksize - 1);
+	if (!off)
+		off = blksize;
+	/* Entry fits into current block? */
+	if (blksize - udf_ext0_offset(dir) - off >= nfidlen)
+		goto store_fi;
+
+	ret = udf_fiiter_append_blk(iter);
+	if (ret) {
+		udf_fiiter_release(iter);
+		return ret;
+	}
+
+	/* Entry will be completely in the new block? Update tag location... */
+	if (!(iter->pos & (blksize - 1)))
+		block = iter->eloc.logicalBlockNum +
+				((iter->elen - 1) >> dir->i_blkbits);
+store_fi:
+	memset(&iter->fi, 0, sizeof(struct fileIdentDesc));
+	if (UDF_SB(dir->i_sb)->s_udfrev >= 0x0200)
+		udf_new_tag((char *)(&iter->fi), TAG_IDENT_FID, 3, 1, block,
+			    sizeof(struct tag));
+	else
+		udf_new_tag((char *)(&iter->fi), TAG_IDENT_FID, 2, 1, block,
+			    sizeof(struct tag));
+	iter->fi.fileVersionNum = cpu_to_le16(1);
+	iter->fi.lengthFileIdent = namelen;
+	iter->fi.lengthOfImpUse = cpu_to_le16(0);
+	memcpy(iter->namebuf, name, namelen);
+	iter->name = iter->namebuf;
+
+	dir->i_size += nfidlen;
+	if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
+		dinfo->i_lenAlloc += nfidlen;
+	} else {
+		/* Truncate last extent to proper size */
+		udf_fiiter_update_elen(iter, iter->elen -
+					(dinfo->i_lenExtents - dir->i_size));
+	}
+	mark_inode_dirty(dir);
+
+	return 0;
+}
+
 static struct fileIdentDesc *udf_add_entry(struct inode *dir,
 					   struct dentry *dentry,
 					   struct udf_fileident_bh *fibh,
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -264,6 +264,8 @@ int udf_fiiter_init(struct udf_fileident
 int udf_fiiter_advance(struct udf_fileident_iter *iter);
 void udf_fiiter_release(struct udf_fileident_iter *iter);
 void udf_fiiter_write_fi(struct udf_fileident_iter *iter, uint8_t *impuse);
+void udf_fiiter_update_elen(struct udf_fileident_iter *iter, uint32_t new_elen);
+int udf_fiiter_append_blk(struct udf_fileident_iter *iter);
 extern struct fileIdentDesc *udf_fileident_read(struct inode *, loff_t *,
 						struct udf_fileident_bh *,
 						struct fileIdentDesc *,


