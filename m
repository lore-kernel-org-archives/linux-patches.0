Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D691946A8;
	Mon, 21 Oct 2024 10:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507517; cv=none; b=gjPlFOZwYBr2GnVllpvKTXBiFiVDkh2tyUxFyhLgbQIuLx0GESAxHe4CNjFSAib2DnAxzBnMQU4w6PcgRlbKIZP5aWz7iACdNIwx51tM5rXDHlqOVIHKU3KjgPjmg7C1Sc/yUX4pob+5yEJ8K06xfX0Rwmpxd5FWJi4JkX81Dfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507517; c=relaxed/simple;
	bh=0HFT6ZJSmNqQq9BX+3yamXab2ePBKTYkiQw6h7rROCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMN8z8/jHn2PtvRzjh/SJvOYJE4GkyAbK50DMf1edXKhQyGxoedt8i07bSG/8+ZUGiYtcskBOggMmlQRTwVX25O8K7bOcHIQeDdh3Fdj5mxpFnbceyTJ8a0xsdaAY66/b+0mLtsuCiTvy4x39Y9puZ1lMO3mVCSgjvf2euRWY2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VWdbWoDe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VWdbWoDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95076C4AF10;
	Mon, 21 Oct 2024 10:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507517;
	bh=0HFT6ZJSmNqQq9BX+3yamXab2ePBKTYkiQw6h7rROCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWdbWoDekWz4SMsvIiMHxD0VXD9hvyuqhn0gg+Uaw2MNSJLFpFbZfDUPZ4z3an5Os
	 03hoRDV3bg3MNzRw90jfxgU/tzZmFOTwubYkocsoixzlUZXt7ksCnInOxRyOlduNMF
	 cau++cY+WkbQ+VgkgmBMwObpM9QH/XBz683xmcYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.15 04/82] udf: Move udf_expand_dir_adinicb() to its callsite
Date: Mon, 21 Oct 2024 12:24:45 +0200
Message-ID: <20241021102247.388812506@linuxfoundation.org>
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

[ Upstream commit a27b2923de7efaa1da1e243fb80ff0fa432e4be0 ]

There is just one caller of udf_expand_dir_adinicb(). Move the function
to its caller into namei.c as it is more about directory handling than
anything else anyway.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c   |   82 -------------------------------------------------------
 fs/udf/namei.c   |   82 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/udf/udfdecl.h |    2 -
 3 files changed, 82 insertions(+), 84 deletions(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -324,88 +324,6 @@ int udf_expand_file_adinicb(struct inode
 	return err;
 }
 
-struct buffer_head *udf_expand_dir_adinicb(struct inode *inode,
-					    udf_pblk_t *block, int *err)
-{
-	udf_pblk_t newblock;
-	struct buffer_head *dbh = NULL;
-	struct kernel_lb_addr eloc;
-	struct extent_position epos;
-	uint8_t alloctype;
-	struct udf_inode_info *iinfo = UDF_I(inode);
-	struct udf_fileident_iter iter;
-	uint8_t *impuse;
-	int ret;
-
-	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
-		alloctype = ICBTAG_FLAG_AD_SHORT;
-	else
-		alloctype = ICBTAG_FLAG_AD_LONG;
-
-	if (!inode->i_size) {
-		iinfo->i_alloc_type = alloctype;
-		mark_inode_dirty(inode);
-		return NULL;
-	}
-
-	/* alloc block, and copy data to it */
-	*block = udf_new_block(inode->i_sb, inode,
-			       iinfo->i_location.partitionReferenceNum,
-			       iinfo->i_location.logicalBlockNum, err);
-	if (!(*block))
-		return NULL;
-	newblock = udf_get_pblock(inode->i_sb, *block,
-				  iinfo->i_location.partitionReferenceNum,
-				0);
-	if (!newblock)
-		return NULL;
-	dbh = udf_tgetblk(inode->i_sb, newblock);
-	if (!dbh)
-		return NULL;
-	lock_buffer(dbh);
-	memcpy(dbh->b_data, iinfo->i_data, inode->i_size);
-	memset(dbh->b_data + inode->i_size, 0,
-	       inode->i_sb->s_blocksize - inode->i_size);
-	set_buffer_uptodate(dbh);
-	unlock_buffer(dbh);
-
-	/* Drop inline data, add block instead */
-	iinfo->i_alloc_type = alloctype;
-	memset(iinfo->i_data + iinfo->i_lenEAttr, 0, iinfo->i_lenAlloc);
-	iinfo->i_lenAlloc = 0;
-	eloc.logicalBlockNum = *block;
-	eloc.partitionReferenceNum =
-				iinfo->i_location.partitionReferenceNum;
-	iinfo->i_lenExtents = inode->i_size;
-	epos.bh = NULL;
-	epos.block = iinfo->i_location;
-	epos.offset = udf_file_entry_alloc_offset(inode);
-	udf_add_aext(inode, &epos, &eloc, inode->i_size, 0);
-	brelse(epos.bh);
-	mark_inode_dirty(inode);
-
-	/* Now fixup tags in moved directory entries */
-	for (ret = udf_fiiter_init(&iter, inode, 0);
-	     !ret && iter.pos < inode->i_size;
-	     ret = udf_fiiter_advance(&iter)) {
-		iter.fi.descTag.tagLocation = cpu_to_le32(*block);
-		if (iter.fi.lengthOfImpUse != cpu_to_le16(0))
-			impuse = dbh->b_data + iter.pos +
-						sizeof(struct fileIdentDesc);
-		else
-			impuse = NULL;
-		udf_fiiter_write_fi(&iter, impuse);
-	}
-	/*
-	 * We don't expect the iteration to fail as the directory has been
-	 * already verified to be correct
-	 */
-	WARN_ON_ONCE(ret);
-	udf_fiiter_release(&iter);
-
-	return dbh;
-}
-
 static int udf_get_block(struct inode *inode, sector_t block,
 			 struct buffer_head *bh_result, int create)
 {
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -326,6 +326,88 @@ static struct dentry *udf_lookup(struct
 	return d_splice_alias(inode, dentry);
 }
 
+static struct buffer_head *udf_expand_dir_adinicb(struct inode *inode,
+					udf_pblk_t *block, int *err)
+{
+	udf_pblk_t newblock;
+	struct buffer_head *dbh = NULL;
+	struct kernel_lb_addr eloc;
+	struct extent_position epos;
+	uint8_t alloctype;
+	struct udf_inode_info *iinfo = UDF_I(inode);
+	struct udf_fileident_iter iter;
+	uint8_t *impuse;
+	int ret;
+
+	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
+		alloctype = ICBTAG_FLAG_AD_SHORT;
+	else
+		alloctype = ICBTAG_FLAG_AD_LONG;
+
+	if (!inode->i_size) {
+		iinfo->i_alloc_type = alloctype;
+		mark_inode_dirty(inode);
+		return NULL;
+	}
+
+	/* alloc block, and copy data to it */
+	*block = udf_new_block(inode->i_sb, inode,
+			       iinfo->i_location.partitionReferenceNum,
+			       iinfo->i_location.logicalBlockNum, err);
+	if (!(*block))
+		return NULL;
+	newblock = udf_get_pblock(inode->i_sb, *block,
+				  iinfo->i_location.partitionReferenceNum,
+				0);
+	if (!newblock)
+		return NULL;
+	dbh = udf_tgetblk(inode->i_sb, newblock);
+	if (!dbh)
+		return NULL;
+	lock_buffer(dbh);
+	memcpy(dbh->b_data, iinfo->i_data, inode->i_size);
+	memset(dbh->b_data + inode->i_size, 0,
+	       inode->i_sb->s_blocksize - inode->i_size);
+	set_buffer_uptodate(dbh);
+	unlock_buffer(dbh);
+
+	/* Drop inline data, add block instead */
+	iinfo->i_alloc_type = alloctype;
+	memset(iinfo->i_data + iinfo->i_lenEAttr, 0, iinfo->i_lenAlloc);
+	iinfo->i_lenAlloc = 0;
+	eloc.logicalBlockNum = *block;
+	eloc.partitionReferenceNum =
+				iinfo->i_location.partitionReferenceNum;
+	iinfo->i_lenExtents = inode->i_size;
+	epos.bh = NULL;
+	epos.block = iinfo->i_location;
+	epos.offset = udf_file_entry_alloc_offset(inode);
+	udf_add_aext(inode, &epos, &eloc, inode->i_size, 0);
+	brelse(epos.bh);
+	mark_inode_dirty(inode);
+
+	/* Now fixup tags in moved directory entries */
+	for (ret = udf_fiiter_init(&iter, inode, 0);
+	     !ret && iter.pos < inode->i_size;
+	     ret = udf_fiiter_advance(&iter)) {
+		iter.fi.descTag.tagLocation = cpu_to_le32(*block);
+		if (iter.fi.lengthOfImpUse != cpu_to_le16(0))
+			impuse = dbh->b_data + iter.pos +
+						sizeof(struct fileIdentDesc);
+		else
+			impuse = NULL;
+		udf_fiiter_write_fi(&iter, impuse);
+	}
+	/*
+	 * We don't expect the iteration to fail as the directory has been
+	 * already verified to be correct
+	 */
+	WARN_ON_ONCE(ret);
+	udf_fiiter_release(&iter);
+
+	return dbh;
+}
+
 static struct fileIdentDesc *udf_add_entry(struct inode *dir,
 					   struct dentry *dentry,
 					   struct udf_fileident_bh *fibh,
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -169,8 +169,6 @@ static inline struct inode *udf_iget(str
 	return __udf_iget(sb, ino, false);
 }
 extern int udf_expand_file_adinicb(struct inode *);
-extern struct buffer_head *udf_expand_dir_adinicb(struct inode *inode,
-						  udf_pblk_t *block, int *err);
 extern struct buffer_head *udf_bread(struct inode *inode, udf_pblk_t block,
 				      int create, int *err);
 extern int udf_setsize(struct inode *, loff_t);


