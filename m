Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8A01EF945;
	Mon, 21 Oct 2024 10:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507286; cv=none; b=r5VmYJ3ZB/CZvw32vIZv/6yQr6Jx7rWZere8TUsHilHzP1nEDed51TBR1A8hAT376lI7I63XUi7olKBGfi85x96VfMVhPf2wm/IUYmL3Z5NTOnzRrEvlj7N04pcophWD4Qf1cOn9uPBZ8hXrXple+Vm7chEc50xiFCwcnQ4YVdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507286; c=relaxed/simple;
	bh=XFPO8qQHAIIKZKAZYkW41arcK18t0vWSuI/E+z+Q9lU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vm6gYczor7RMlrtk4hibpjDrEgXzBQ1IUdug4B/nCI7k4RrafJtUWjh8iM0EbaoZ6A+CF53fbnmec7eMNDB641kvY27keAhToGO9zw2pj/lQaNpUvIbtJkNJANoSnwgItq8OiSP1KGb9M/t0ST/Ei7Ei35hu6U5Th/SgGwnmNy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KjntyqMF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KjntyqMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A378FC4CEC3;
	Mon, 21 Oct 2024 10:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507286;
	bh=XFPO8qQHAIIKZKAZYkW41arcK18t0vWSuI/E+z+Q9lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KjntyqMFnBreWjoOmETJ0vja2qKqjll1ghLI6ywamxftPyF4N0Qntja7O51oJXhzk
	 0n33rrgbAR7kKsct/d5tJbJ/LwYiiWZikvx+GA99DWlxubaUNPhEI0LvY4Hvpi1O4G
	 pDPO6U0QRsNM8fXqo8wpRexsY6vp5xHw2nu/lCBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 6.1 08/91] udf: Move udf_expand_dir_adinicb() to its callsite
Date: Mon, 21 Oct 2024 12:24:22 +0200
Message-ID: <20241021102250.125753099@linuxfoundation.org>
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
@@ -325,88 +325,6 @@ int udf_expand_file_adinicb(struct inode
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


