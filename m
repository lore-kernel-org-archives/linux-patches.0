Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7939918EFE6;
	Mon, 28 Oct 2024 06:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097730; cv=none; b=HTpVD2pjeDGmxTrNUgrw4f59HkDNIipLyhA+DuR2O5LQUAFzmRlgL0PS+Ibrl5LXLfyp6P9sSV4L+7NLzAzssm3hGcOF5B2SBuBZfdpjmPAINkZvCCKuHsC/vdKQXD4BZVCMPHBPNHSLUjnRHscHdTLiaMmiZFWlO84uwFopo2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097730; c=relaxed/simple;
	bh=ZKF9x8v6uP9j0fxnM3nfTTkODUuYlDOV3dn/tiow52g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlueN8+3oUnqZSqp5WQZVR/aykxkNRdpFJbdbwBIo1ZGVg3W1GyolJZhIW9z1dorq0PeFoquYmKE3a7Opa2FD/X+X2hvLYzedDj+sPEp8424rqnph74apkuS46UiAIEuSZnynOCADN4fJIQf+3UXwJQuC+VveK387oXlh0gA8HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P181gFST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P181gFST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C392DC4CEE3;
	Mon, 28 Oct 2024 06:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097730;
	bh=ZKF9x8v6uP9j0fxnM3nfTTkODUuYlDOV3dn/tiow52g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P181gFSTWxBaZvo04A4g9TX9cayAUfHk++SUYk1OakUFU5hcEXMjvHTyFVPKSfght
	 K4cwnchQMupK2AF/4UlVXs9A8SCqRtIckvFhU+c/HT3c/PqhDqREYh/ON1sDQGXt2u
	 8dR+kMW1igmr/6OieY10k9oEQqk7ehDucrM6R33M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7a4842f0b1801230a989@syzkaller.appspotmail.com,
	Zhao Mengmeng <zhaomengmeng@kylinos.cn>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/208] udf: refactor inode_bmap() to handle error
Date: Mon, 28 Oct 2024 07:25:02 +0100
Message-ID: <20241028062309.652443695@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

From: Zhao Mengmeng <zhaomengmeng@kylinos.cn>

[ Upstream commit c226964ec786f3797ed389a16392ce4357697d24 ]

Refactor inode_bmap() to handle error since udf_next_aext() can return
error now. On situations like ftruncate, udf_extend_file() can now
detect errors and bail out early without resorting to checking for
particular offsets and assuming internal behavior of these functions.

Reported-by: syzbot+7a4842f0b1801230a989@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7a4842f0b1801230a989
Tested-by: syzbot+7a4842f0b1801230a989@syzkaller.appspotmail.com
Signed-off-by: Zhao Mengmeng <zhaomengmeng@kylinos.cn>
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20241001115425.266556-4-zhaomzhao@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/directory.c | 13 ++++++++-----
 fs/udf/inode.c     | 40 +++++++++++++++++++++++++---------------
 fs/udf/partition.c |  6 ++++--
 fs/udf/truncate.c  |  6 ++++--
 fs/udf/udfdecl.h   |  5 +++--
 5 files changed, 44 insertions(+), 26 deletions(-)

diff --git a/fs/udf/directory.c b/fs/udf/directory.c
index c6950050e7aeb..632453aa38934 100644
--- a/fs/udf/directory.c
+++ b/fs/udf/directory.c
@@ -246,6 +246,7 @@ int udf_fiiter_init(struct udf_fileident_iter *iter, struct inode *dir,
 {
 	struct udf_inode_info *iinfo = UDF_I(dir);
 	int err = 0;
+	int8_t etype;
 
 	iter->dir = dir;
 	iter->bh[0] = iter->bh[1] = NULL;
@@ -265,9 +266,9 @@ int udf_fiiter_init(struct udf_fileident_iter *iter, struct inode *dir,
 		goto out;
 	}
 
-	if (inode_bmap(dir, iter->pos >> dir->i_blkbits, &iter->epos,
-		       &iter->eloc, &iter->elen, &iter->loffset) !=
-	    (EXT_RECORDED_ALLOCATED >> 30)) {
+	err = inode_bmap(dir, iter->pos >> dir->i_blkbits, &iter->epos,
+			 &iter->eloc, &iter->elen, &iter->loffset, &etype);
+	if (err <= 0 || etype != (EXT_RECORDED_ALLOCATED >> 30)) {
 		if (pos == dir->i_size)
 			return 0;
 		udf_err(dir->i_sb,
@@ -463,6 +464,7 @@ int udf_fiiter_append_blk(struct udf_fileident_iter *iter)
 	sector_t block;
 	uint32_t old_elen = iter->elen;
 	int err;
+	int8_t etype;
 
 	if (WARN_ON_ONCE(iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB))
 		return -EINVAL;
@@ -477,8 +479,9 @@ int udf_fiiter_append_blk(struct udf_fileident_iter *iter)
 		udf_fiiter_update_elen(iter, old_elen);
 		return err;
 	}
-	if (inode_bmap(iter->dir, block, &iter->epos, &iter->eloc, &iter->elen,
-		       &iter->loffset) != (EXT_RECORDED_ALLOCATED >> 30)) {
+	err = inode_bmap(iter->dir, block, &iter->epos, &iter->eloc, &iter->elen,
+		   &iter->loffset, &etype);
+	if (err <= 0 || etype != (EXT_RECORDED_ALLOCATED >> 30)) {
 		udf_err(iter->dir->i_sb,
 			"block %llu not allocated in directory (ino %lu)\n",
 			(unsigned long long)block, iter->dir->i_ino);
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index f7623b49ec349..37fa27136fafb 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -408,7 +408,7 @@ struct udf_map_rq {
 
 static int udf_map_block(struct inode *inode, struct udf_map_rq *map)
 {
-	int err;
+	int ret;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 
 	if (WARN_ON_ONCE(iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB))
@@ -420,18 +420,24 @@ static int udf_map_block(struct inode *inode, struct udf_map_rq *map)
 		uint32_t elen;
 		sector_t offset;
 		struct extent_position epos = {};
+		int8_t etype;
 
 		down_read(&iinfo->i_data_sem);
-		if (inode_bmap(inode, map->lblk, &epos, &eloc, &elen, &offset)
-				== (EXT_RECORDED_ALLOCATED >> 30)) {
+		ret = inode_bmap(inode, map->lblk, &epos, &eloc, &elen, &offset,
+				 &etype);
+		if (ret < 0)
+			goto out_read;
+		if (ret > 0 && etype == (EXT_RECORDED_ALLOCATED >> 30)) {
 			map->pblk = udf_get_lb_pblock(inode->i_sb, &eloc,
 							offset);
 			map->oflags |= UDF_BLK_MAPPED;
+			ret = 0;
 		}
+out_read:
 		up_read(&iinfo->i_data_sem);
 		brelse(epos.bh);
 
-		return 0;
+		return ret;
 	}
 
 	down_write(&iinfo->i_data_sem);
@@ -442,9 +448,9 @@ static int udf_map_block(struct inode *inode, struct udf_map_rq *map)
 	if (((loff_t)map->lblk) << inode->i_blkbits >= iinfo->i_lenExtents)
 		udf_discard_prealloc(inode);
 	udf_clear_extent_cache(inode);
-	err = inode_getblk(inode, map);
+	ret = inode_getblk(inode, map);
 	up_write(&iinfo->i_data_sem);
-	return err;
+	return ret;
 }
 
 static int __udf_get_block(struct inode *inode, sector_t block,
@@ -666,8 +672,10 @@ static int udf_extend_file(struct inode *inode, loff_t newsize)
 	 */
 	udf_discard_prealloc(inode);
 
-	etype = inode_bmap(inode, first_block, &epos, &eloc, &elen, &offset);
-	within_last_ext = (etype != -1);
+	err = inode_bmap(inode, first_block, &epos, &eloc, &elen, &offset, &etype);
+	if (err < 0)
+		goto out;
+	within_last_ext = (err == 1);
 	/* We don't expect extents past EOF... */
 	WARN_ON_ONCE(within_last_ext &&
 		     elen > ((loff_t)offset + 1) << inode->i_blkbits);
@@ -2401,13 +2409,15 @@ int8_t udf_delete_aext(struct inode *inode, struct extent_position epos)
 	return (elen >> 30);
 }
 
-int8_t inode_bmap(struct inode *inode, sector_t block,
-		  struct extent_position *pos, struct kernel_lb_addr *eloc,
-		  uint32_t *elen, sector_t *offset)
+/*
+ * Returns 1 on success, -errno on error, 0 on hit EOF.
+ */
+int inode_bmap(struct inode *inode, sector_t block, struct extent_position *pos,
+	       struct kernel_lb_addr *eloc, uint32_t *elen, sector_t *offset,
+	       int8_t *etype)
 {
 	unsigned char blocksize_bits = inode->i_sb->s_blocksize_bits;
 	loff_t lbcount = 0, bcount = (loff_t) block << blocksize_bits;
-	int8_t etype;
 	struct udf_inode_info *iinfo;
 	int err = 0;
 
@@ -2419,13 +2429,13 @@ int8_t inode_bmap(struct inode *inode, sector_t block,
 	}
 	*elen = 0;
 	do {
-		err = udf_next_aext(inode, pos, eloc, elen, &etype, 1);
+		err = udf_next_aext(inode, pos, eloc, elen, etype, 1);
 		if (err <= 0) {
 			if (err == 0) {
 				*offset = (bcount - lbcount) >> blocksize_bits;
 				iinfo->i_lenExtents = lbcount;
 			}
-			return -1;
+			return err;
 		}
 		lbcount += *elen;
 	} while (lbcount <= bcount);
@@ -2433,5 +2443,5 @@ int8_t inode_bmap(struct inode *inode, sector_t block,
 	udf_update_extent_cache(inode, lbcount - *elen, pos);
 	*offset = (bcount + *elen - lbcount) >> blocksize_bits;
 
-	return etype;
+	return 1;
 }
diff --git a/fs/udf/partition.c b/fs/udf/partition.c
index af877991edc13..2b85c9501bed8 100644
--- a/fs/udf/partition.c
+++ b/fs/udf/partition.c
@@ -282,9 +282,11 @@ static uint32_t udf_try_read_meta(struct inode *inode, uint32_t block,
 	sector_t ext_offset;
 	struct extent_position epos = {};
 	uint32_t phyblock;
+	int8_t etype;
+	int err = 0;
 
-	if (inode_bmap(inode, block, &epos, &eloc, &elen, &ext_offset) !=
-						(EXT_RECORDED_ALLOCATED >> 30))
+	err = inode_bmap(inode, block, &epos, &eloc, &elen, &ext_offset, &etype);
+	if (err <= 0 || etype != (EXT_RECORDED_ALLOCATED >> 30))
 		phyblock = 0xFFFFFFFF;
 	else {
 		map = &UDF_SB(sb)->s_partmaps[partition];
diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
index 399958f891d14..4f33a4a488861 100644
--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -214,10 +214,12 @@ int udf_truncate_extents(struct inode *inode)
 	else
 		BUG();
 
-	etype = inode_bmap(inode, first_block, &epos, &eloc, &elen, &offset);
+	ret = inode_bmap(inode, first_block, &epos, &eloc, &elen, &offset, &etype);
+	if (ret < 0)
+		return ret;
 	byte_offset = (offset << sb->s_blocksize_bits) +
 		(inode->i_size & (sb->s_blocksize - 1));
-	if (etype == -1) {
+	if (ret == 0) {
 		/* We should extend the file? */
 		WARN_ON(byte_offset);
 		return 0;
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index 5067ed68a8b45..d159f20d61e89 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -157,8 +157,9 @@ extern struct buffer_head *udf_bread(struct inode *inode, udf_pblk_t block,
 extern int udf_setsize(struct inode *, loff_t);
 extern void udf_evict_inode(struct inode *);
 extern int udf_write_inode(struct inode *, struct writeback_control *wbc);
-extern int8_t inode_bmap(struct inode *, sector_t, struct extent_position *,
-			 struct kernel_lb_addr *, uint32_t *, sector_t *);
+extern int inode_bmap(struct inode *inode, sector_t block,
+		      struct extent_position *pos, struct kernel_lb_addr *eloc,
+		      uint32_t *elen, sector_t *offset, int8_t *etype);
 int udf_get_block(struct inode *, sector_t, struct buffer_head *, int);
 extern int udf_setup_indirect_aext(struct inode *inode, udf_pblk_t block,
 				   struct extent_position *epos);
-- 
2.43.0



