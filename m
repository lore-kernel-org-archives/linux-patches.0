Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2D1577E4D;
	Wed,  9 Sep 2026 14:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964927; cv=none; b=A4mSxo3ypkM9NYYqeEyQpenBEjO5eOihvr8Cw3qEKHndcl2CRQgaK4z2GRpdLD+8YnwfLH3+rHSCrbdsQjPtSZBFuXBZiroE+egVQwEHIsQycM40lyxY/NobuVI70SSESnmjE6U0idAFyazex+KJ+WS1OERnKEopKh8zAEfPGLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964927; c=relaxed/simple;
	bh=Kz+IlSivsTxnMJ9tBZX8wCZO6m9fqThUOsJounmNTWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=peV+C1qnaV5KkVfI0hoDfxLpwcc7FZ87JO8cdylJahiptiEWlvo9lK6Dca5qZoLdUUDzPqRoxfPvx2yH1FZjS6xUF7hDVWfMsML1zU5uawx+KyyW6XCuF7X5LkCRqoprZzqY5CSdV77HGmQ9sBtS3u55KZMtaQpBauMWuOt3NhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZvjfnC/S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZvjfnC/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8491F00A3A;
	Wed,  9 Sep 2026 14:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964926;
	bh=Ir4x5RfeMqxOUhmiG1Wtv5fK9/G5rseOGNtVL3pvTGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZvjfnC/Sd9WOtznz84rKFrpg77gGOF0XuYDjq/jzx2N+ODv+8eKtkcGb+nwJkXEXe
	 n52eaM14K0U008GBG6E/YWwW4A2BMXTu32bEJ7owUzTJxvk1rFbIhTEG7qK+dtV7R7
	 MneuR0ddrX0DKJPLKjz/o8M0XxUgBwm562xU0RYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@google.com>,
	Richard Chang <richardycc@google.com>,
	Yuwen Chen <ywen.chen@foxmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 556/583] zram: drop wb_limit_lock
Date: Wed,  9 Sep 2026 15:44:01 +0200
Message-ID: <20260909134256.960069822@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit a4f506c569e1320c2db4a32955e47961fcf02b05 ]

We don't need wb_limit_lock.  Writeback limit setters take an exclusive
write zram init_lock, while wb_limit modifications happen only from a
single task and under zram read init_lock.  No concurrent wb_limit
modifications are possible (we permit only one post-processing task at a
time).  Add lockdep assertions to wb_limit mutators.

While at it, fixup coding styles.

Link: https://lkml.kernel.org/r/20251122074029.3948921-5-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Yuwen Chen <ywen.chen@foxmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: dde75313eed0 ("zram: set default primary compressor in zram_destroy_comps()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |   23 ++++-------------------
 drivers/block/zram/zram_drv.h |    1 -
 2 files changed, 4 insertions(+), 20 deletions(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -512,9 +512,7 @@ static ssize_t writeback_limit_enable_st
 		return ret;
 
 	down_write(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	zram->wb_limit_enable = val;
-	spin_unlock(&zram->wb_limit_lock);
 	up_write(&zram->init_lock);
 	ret = len;
 
@@ -529,9 +527,7 @@ static ssize_t writeback_limit_enable_sh
 	struct zram *zram = dev_to_zram(dev);
 
 	down_read(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	val = zram->wb_limit_enable;
-	spin_unlock(&zram->wb_limit_lock);
 	up_read(&zram->init_lock);
 
 	return sysfs_emit(buf, "%d\n", val);
@@ -549,9 +545,7 @@ static ssize_t writeback_limit_store(str
 		return ret;
 
 	down_write(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	zram->bd_wb_limit = val;
-	spin_unlock(&zram->wb_limit_lock);
 	up_write(&zram->init_lock);
 	ret = len;
 
@@ -559,15 +553,13 @@ static ssize_t writeback_limit_store(str
 }
 
 static ssize_t writeback_limit_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+				    struct device_attribute *attr, char *buf)
 {
 	u64 val;
 	struct zram *zram = dev_to_zram(dev);
 
 	down_read(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	val = zram->bd_wb_limit;
-	spin_unlock(&zram->wb_limit_lock);
 	up_read(&zram->init_lock);
 
 	return sysfs_emit(buf, "%llu\n", val);
@@ -747,18 +739,17 @@ static int zram_writeback_slots(struct z
 	int ret = 0, err;
 	u32 index;
 
+	lockdep_assert_held_read(&zram->init_lock);
+
 	page = alloc_page(GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 
 	while ((pps = select_pp_slot(ctl))) {
-		spin_lock(&zram->wb_limit_lock);
 		if (zram->wb_limit_enable && !zram->bd_wb_limit) {
-			spin_unlock(&zram->wb_limit_lock);
 			ret = -EIO;
 			break;
 		}
-		spin_unlock(&zram->wb_limit_lock);
 
 		if (!blk_idx) {
 			blk_idx = alloc_block_bdev(zram);
@@ -824,10 +815,8 @@ static int zram_writeback_slots(struct z
 		zram_set_handle(zram, index, blk_idx);
 		blk_idx = 0;
 		atomic64_inc(&zram->stats.pages_stored);
-		spin_lock(&zram->wb_limit_lock);
 		if (zram->wb_limit_enable && zram->bd_wb_limit > 0)
 			zram->bd_wb_limit -=  1UL << (PAGE_SHIFT - 12);
-		spin_unlock(&zram->wb_limit_lock);
 next:
 		zram_slot_unlock(zram, index);
 		release_pp_slot(zram, pps);
@@ -2469,7 +2458,7 @@ static void zram_destroy_comps(struct zr
 
 static void zram_reset_device(struct zram *zram)
 {
-	down_write(&zram->init_lock);
+	guard(rwsem_write)(&zram->init_lock);
 
 	zram->limit_pages = 0;
 
@@ -2485,7 +2474,6 @@ static void zram_reset_device(struct zra
 	reset_bdev(zram);
 
 	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
-	up_write(&zram->init_lock);
 }
 
 static ssize_t disksize_store(struct device *dev,
@@ -2697,9 +2685,6 @@ static int zram_add(void)
 	device_id = ret;
 
 	init_rwsem(&zram->init_lock);
-#ifdef CONFIG_ZRAM_WRITEBACK
-	spin_lock_init(&zram->wb_limit_lock);
-#endif
 
 	/* gendisk structure */
 	zram->disk = blk_alloc_disk(&lim, NUMA_NO_NODE);
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -127,7 +127,6 @@ struct zram {
 	bool claim; /* Protected by disk->open_mutex */
 #ifdef CONFIG_ZRAM_WRITEBACK
 	struct file *backing_dev;
-	spinlock_t wb_limit_lock;
 	bool wb_limit_enable;
 	u64 bd_wb_limit;
 	struct block_device *bdev;


