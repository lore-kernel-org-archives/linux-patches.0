Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F34F296FBD;
	Mon, 12 May 2025 18:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073057; cv=none; b=Wc6em1PXb7/jS/btlR927LEWggAf/TDJvYHNqfYrTWbHkBmtw22dJElU0laqFzmkRwW5/ASrtCtbU+jxmw9SZyJNUyGCMNLLJpMWWUpzNRFSCBmnVEl7dDIKtAt3nU53EqUqW/Sgq0aKdVa+D3f4TwsAlJOEd3k0Dk2UQM0bcZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073057; c=relaxed/simple;
	bh=0RrDHPKBXyaRDEcdta9Mt+YcmvtP1RsMgsqgP1LVL78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxWr3KTxQK9MXPB//F3JkBdAQ7wwOonIpsTr/rlfVvdLtQUW6KZRebm407SdZyaCpB9iu20qQeLo24GKxoi27DbwEBKJnS28xLiQDiIYM8+AOh080qfw8YcaV2ntky9xD/SQEA2CEIPwV9XelaKAr/4Zz76uoheTFVNwM7nLhsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QtmB5Ea/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QtmB5Ea/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3373DC4CEE7;
	Mon, 12 May 2025 18:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073055;
	bh=0RrDHPKBXyaRDEcdta9Mt+YcmvtP1RsMgsqgP1LVL78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QtmB5Ea/mpUUugMgf9uyAkURfIj+I9zIH6INc6XW7UQ4r27nlEMUeCMwVHqwZcUZ2
	 ONvtC8j9ojtu9gL2NSRrVw6zD0FI0Cy+Zrs98B3mhgTEU57+4AAjJPPyZTOzp9Swmi
	 ltqan3TlFjXIrNQyO5kFw0lDCpjQHGEbOonza2b0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a5d8c609c02f508672cc@syzkaller.appspotmail.com,
	Ming Lei <ming.lei@redhat.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 141/184] loop: Fix ABBA locking race
Date: Mon, 12 May 2025 19:45:42 +0200
Message-ID: <20250512172047.550723864@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

[ Upstream commit b49125574cae26458d4aa02ce8f4523ba9a2a328 ]

Current loop calls vfs_statfs() while holding the q->limits_lock. If
FS takes some locking in vfs_statfs callback, this may lead to ABBA
locking bug (at least, FAT fs has this issue actually).

So this patch calls vfs_statfs() outside q->limits_locks instead,
because looks like no reason to hold q->limits_locks while getting
discord configs.

Chain exists of:
  &sbi->fat_lock --> &q->q_usage_counter(io)#17 --> &q->limits_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&q->limits_lock);
                               lock(&q->q_usage_counter(io)#17);
                               lock(&q->limits_lock);
  lock(&sbi->fat_lock);

 *** DEADLOCK ***

Reported-by: syzbot+a5d8c609c02f508672cc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a5d8c609c02f508672cc
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: f5c84eff634b ("loop: Add sanity check for read/write_iter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 1f55ddef53f3d..27e4bd8ee9dc9 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -694,12 +694,11 @@ static void loop_sysfs_exit(struct loop_device *lo)
 				   &loop_attribute_group);
 }
 
-static void loop_config_discard(struct loop_device *lo,
-		struct queue_limits *lim)
+static void loop_get_discard_config(struct loop_device *lo,
+				    u32 *granularity, u32 *max_discard_sectors)
 {
 	struct file *file = lo->lo_backing_file;
 	struct inode *inode = file->f_mapping->host;
-	u32 granularity = 0, max_discard_sectors = 0;
 	struct kstatfs sbuf;
 
 	/*
@@ -712,24 +711,17 @@ static void loop_config_discard(struct loop_device *lo,
 	if (S_ISBLK(inode->i_mode)) {
 		struct block_device *bdev = I_BDEV(inode);
 
-		max_discard_sectors = bdev_write_zeroes_sectors(bdev);
-		granularity = bdev_discard_granularity(bdev);
+		*max_discard_sectors = bdev_write_zeroes_sectors(bdev);
+		*granularity = bdev_discard_granularity(bdev);
 
 	/*
 	 * We use punch hole to reclaim the free space used by the
 	 * image a.k.a. discard.
 	 */
 	} else if (file->f_op->fallocate && !vfs_statfs(&file->f_path, &sbuf)) {
-		max_discard_sectors = UINT_MAX >> 9;
-		granularity = sbuf.f_bsize;
+		*max_discard_sectors = UINT_MAX >> 9;
+		*granularity = sbuf.f_bsize;
 	}
-
-	lim->max_hw_discard_sectors = max_discard_sectors;
-	lim->max_write_zeroes_sectors = max_discard_sectors;
-	if (max_discard_sectors)
-		lim->discard_granularity = granularity;
-	else
-		lim->discard_granularity = 0;
 }
 
 struct loop_worker {
@@ -915,6 +907,7 @@ static int loop_reconfigure_limits(struct loop_device *lo, unsigned int bsize)
 	struct inode *inode = file->f_mapping->host;
 	struct block_device *backing_bdev = NULL;
 	struct queue_limits lim;
+	u32 granularity = 0, max_discard_sectors = 0;
 
 	if (S_ISBLK(inode->i_mode))
 		backing_bdev = I_BDEV(inode);
@@ -924,6 +917,8 @@ static int loop_reconfigure_limits(struct loop_device *lo, unsigned int bsize)
 	if (!bsize)
 		bsize = loop_default_blocksize(lo, backing_bdev);
 
+	loop_get_discard_config(lo, &granularity, &max_discard_sectors);
+
 	lim = queue_limits_start_update(lo->lo_queue);
 	lim.logical_block_size = bsize;
 	lim.physical_block_size = bsize;
@@ -933,7 +928,12 @@ static int loop_reconfigure_limits(struct loop_device *lo, unsigned int bsize)
 		lim.features |= BLK_FEAT_WRITE_CACHE;
 	if (backing_bdev && !bdev_nonrot(backing_bdev))
 		lim.features |= BLK_FEAT_ROTATIONAL;
-	loop_config_discard(lo, &lim);
+	lim.max_hw_discard_sectors = max_discard_sectors;
+	lim.max_write_zeroes_sectors = max_discard_sectors;
+	if (max_discard_sectors)
+		lim.discard_granularity = granularity;
+	else
+		lim.discard_granularity = 0;
 	return queue_limits_commit_update(lo->lo_queue, &lim);
 }
 
-- 
2.39.5



