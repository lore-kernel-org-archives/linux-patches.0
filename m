Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940A81BA863;
	Thu, 15 Aug 2024 14:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730994; cv=none; b=uRaaQ4ER6XhiDWFiUUgn57KIWZtxCYswrPWT5PT7ITkOAzCD0MPowNmvClACFmQ+auGv1E7HvwziaFoNPHUuTCpDPbjB1z9doguSHooqqw0YFq1lfs+A760JzJvXjAOmGJSaoYQ7sR22S2kS+mFCgs2ZlfV1bndGrIFfno0rTPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730994; c=relaxed/simple;
	bh=AYlJHoUxOuPG2QyyWZSD1eBAaw2nfUHDWDKyHCWVNmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUIXVxf+6r4bc1qllwJG28BbA/WKBRU2p7jDPilDwEhZJnYndN7VkURo2IIal4T78Jaj72BlS+Dvn/nWdAH2L3BUiNyNhhUtpMqjcbcGBMCjG1HTbenZ7W7ohfv33zh26MBK/SqJh5CtLoyLu+dPCGts5/Dbs35K4TfQsiJaPAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ulIYBEv/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulIYBEv/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F867C32786;
	Thu, 15 Aug 2024 14:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730994;
	bh=AYlJHoUxOuPG2QyyWZSD1eBAaw2nfUHDWDKyHCWVNmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ulIYBEv/EOMY2lMWWIUhVjKrgLuDGMQobcYKQR4d5/HF0OBgqmLVYZxWWQL+D12Kv
	 0If0ty6DkIRVaBqE8ZPeETPLaDjpq2gyKc90Ds8cX/lM4CeZtQSc1AIdceXRJmc3bN
	 +XsAVrISTcWUiMT0o5wvMifFUXFoYyoSZEnyw36I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net,
	Christoph Hellwig <hch@lst.de>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 26/67] jfs: Convert to bdev_open_by_dev()
Date: Thu, 15 Aug 2024 15:25:40 +0200
Message-ID: <20240815131839.336155371@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit 898c57f456b537e90493a9e9222226aa3ea66267 ]

Convert jfs to use bdev_open_by_dev() and pass the handle around.

CC: Dave Kleikamp <shaggy@kernel.org>
CC: jfs-discussion@lists.sourceforge.net
Acked-by: Christoph Hellwig <hch@lst.de>
Acked-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230927093442.25915-24-jack@suse.cz
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 6306ff39a7fc ("jfs: fix log->bdev_handle null ptr deref in lbmStartIO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_logmgr.c | 29 +++++++++++++++--------------
 fs/jfs/jfs_logmgr.h |  2 +-
 fs/jfs/jfs_mount.c  |  3 ++-
 3 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index e855b8fde76ce..c911d838b8ec8 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -1058,7 +1058,7 @@ void jfs_syncpt(struct jfs_log *log, int hard_sync)
 int lmLogOpen(struct super_block *sb)
 {
 	int rc;
-	struct block_device *bdev;
+	struct bdev_handle *bdev_handle;
 	struct jfs_log *log;
 	struct jfs_sb_info *sbi = JFS_SBI(sb);
 
@@ -1070,7 +1070,7 @@ int lmLogOpen(struct super_block *sb)
 
 	mutex_lock(&jfs_log_mutex);
 	list_for_each_entry(log, &jfs_external_logs, journal_list) {
-		if (log->bdev->bd_dev == sbi->logdev) {
+		if (log->bdev_handle->bdev->bd_dev == sbi->logdev) {
 			if (!uuid_equal(&log->uuid, &sbi->loguuid)) {
 				jfs_warn("wrong uuid on JFS journal");
 				mutex_unlock(&jfs_log_mutex);
@@ -1100,14 +1100,14 @@ int lmLogOpen(struct super_block *sb)
 	 * file systems to log may have n-to-1 relationship;
 	 */
 
-	bdev = blkdev_get_by_dev(sbi->logdev, BLK_OPEN_READ | BLK_OPEN_WRITE,
-				 log, NULL);
-	if (IS_ERR(bdev)) {
-		rc = PTR_ERR(bdev);
+	bdev_handle = bdev_open_by_dev(sbi->logdev,
+			BLK_OPEN_READ | BLK_OPEN_WRITE, log, NULL);
+	if (IS_ERR(bdev_handle)) {
+		rc = PTR_ERR(bdev_handle);
 		goto free;
 	}
 
-	log->bdev = bdev;
+	log->bdev_handle = bdev_handle;
 	uuid_copy(&log->uuid, &sbi->loguuid);
 
 	/*
@@ -1141,7 +1141,7 @@ int lmLogOpen(struct super_block *sb)
 	lbmLogShutdown(log);
 
       close:		/* close external log device */
-	blkdev_put(bdev, log);
+	bdev_release(bdev_handle);
 
       free:		/* free log descriptor */
 	mutex_unlock(&jfs_log_mutex);
@@ -1162,7 +1162,7 @@ static int open_inline_log(struct super_block *sb)
 	init_waitqueue_head(&log->syncwait);
 
 	set_bit(log_INLINELOG, &log->flag);
-	log->bdev = sb->s_bdev;
+	log->bdev_handle = sb->s_bdev_handle;
 	log->base = addressPXD(&JFS_SBI(sb)->logpxd);
 	log->size = lengthPXD(&JFS_SBI(sb)->logpxd) >>
 	    (L2LOGPSIZE - sb->s_blocksize_bits);
@@ -1436,7 +1436,7 @@ int lmLogClose(struct super_block *sb)
 {
 	struct jfs_sb_info *sbi = JFS_SBI(sb);
 	struct jfs_log *log = sbi->log;
-	struct block_device *bdev;
+	struct bdev_handle *bdev_handle;
 	int rc = 0;
 
 	jfs_info("lmLogClose: log:0x%p", log);
@@ -1482,10 +1482,10 @@ int lmLogClose(struct super_block *sb)
 	 *	external log as separate logical volume
 	 */
 	list_del(&log->journal_list);
-	bdev = log->bdev;
+	bdev_handle = log->bdev_handle;
 	rc = lmLogShutdown(log);
 
-	blkdev_put(bdev, log);
+	bdev_release(bdev_handle);
 
 	kfree(log);
 
@@ -1972,7 +1972,7 @@ static int lbmRead(struct jfs_log * log, int pn, struct lbuf ** bpp)
 
 	bp->l_flag |= lbmREAD;
 
-	bio = bio_alloc(log->bdev, 1, REQ_OP_READ, GFP_NOFS);
+	bio = bio_alloc(log->bdev_handle->bdev, 1, REQ_OP_READ, GFP_NOFS);
 	bio->bi_iter.bi_sector = bp->l_blkno << (log->l2bsize - 9);
 	__bio_add_page(bio, bp->l_page, LOGPSIZE, bp->l_offset);
 	BUG_ON(bio->bi_iter.bi_size != LOGPSIZE);
@@ -2113,7 +2113,8 @@ static void lbmStartIO(struct lbuf * bp)
 
 	jfs_info("lbmStartIO");
 
-	bio = bio_alloc(log->bdev, 1, REQ_OP_WRITE | REQ_SYNC, GFP_NOFS);
+	bio = bio_alloc(log->bdev_handle->bdev, 1, REQ_OP_WRITE | REQ_SYNC,
+			GFP_NOFS);
 	bio->bi_iter.bi_sector = bp->l_blkno << (log->l2bsize - 9);
 	__bio_add_page(bio, bp->l_page, LOGPSIZE, bp->l_offset);
 	BUG_ON(bio->bi_iter.bi_size != LOGPSIZE);
diff --git a/fs/jfs/jfs_logmgr.h b/fs/jfs/jfs_logmgr.h
index 805877ce50204..84aa2d2539074 100644
--- a/fs/jfs/jfs_logmgr.h
+++ b/fs/jfs/jfs_logmgr.h
@@ -356,7 +356,7 @@ struct jfs_log {
 				 *    before writing syncpt.
 				 */
 	struct list_head journal_list; /* Global list */
-	struct block_device *bdev; /* 4: log lv pointer */
+	struct bdev_handle *bdev_handle; /* 4: log lv pointer */
 	int serial;		/* 4: log mount serial number */
 
 	s64 base;		/* @8: log extent address (inline log ) */
diff --git a/fs/jfs/jfs_mount.c b/fs/jfs/jfs_mount.c
index 631b8bd3e4384..9b5c6a20b30c8 100644
--- a/fs/jfs/jfs_mount.c
+++ b/fs/jfs/jfs_mount.c
@@ -430,7 +430,8 @@ int updateSuper(struct super_block *sb, uint state)
 
 	if (state == FM_MOUNT) {
 		/* record log's dev_t and mount serial number */
-		j_sb->s_logdev = cpu_to_le32(new_encode_dev(sbi->log->bdev->bd_dev));
+		j_sb->s_logdev = cpu_to_le32(
+			new_encode_dev(sbi->log->bdev_handle->bdev->bd_dev));
 		j_sb->s_logserial = cpu_to_le32(sbi->log->serial);
 	} else if (state == FM_CLEAN) {
 		/*
-- 
2.43.0



