Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6308642882B;
	Sat, 12 Sep 2026 12:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217637; cv=none; b=iebS8dSwHH/qLaUKdW5anr9v7ioBj/BahcJ2NYG9Vb7V/s+rBx9RxJUosF720XxC3VDxgTZKp8PdOmSlPqqE03uClJKINRaciwQwrKR8TB+UM/yTj6vv5YPxHxfK5JFgyDZIfW6Oz8tOphkw6dka2MWRPk64dgT9UT2DCiSFylA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217637; c=relaxed/simple;
	bh=ZBXIAXC4u69SNamSDYoBUd+S67+K+I42kE0/apFFVXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2sp7ZAalPYw/9Tlbp3etVREK3qocVt63WiFp/NRWjzN1DFAToRAhGBdErjWWqYHUPxHkvwzy4dUJEgjYB6PuQTLLpO8tbxJ62D2woPAHe1cGjagVEGzu9F8Vi6g0Ljfo2iZ7CjqJMc7L5d80scnLbaJtaB1gY5uci4J9F95XE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0YuV+z8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0YuV+z8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BE71F000FF;
	Sat, 12 Sep 2026 12:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217636;
	bh=0h2kBa5X9UWcjoFB7szYFU9rwmBLhpwP6J9J6LLlQa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O0YuV+z8BUF+BNbHJF0lKzU2QukAwODO1jzfKJl27qgNe0d9kAPRZhKzc2ZMJViao
	 bJMhko0ELUsiv3+jSygD8Q8sMGO/mAZbaryCSXHTGkxXucvCBexnnplbpZTj+CAV/L
	 Q1yZZSEUinWzL3lYY/MUJUgaJn9nOm/8MztcNA8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Swarna Prabhu <s.prabhu@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0981/1376] scsi: sd: Enable sector size > PAGE_SIZE in SCSI sd driver
Date: Sat, 12 Sep 2026 08:56:47 +0200
Message-ID: <20260912065629.432226437@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Swarna Prabhu <sw.prabhu6@gmail.com>

[ Upstream commit 7179e626b76eb42f2529c6f6dd6ba88ea2445372 ]

The WRITE SAME(16) and WRITE SAME(10) SCSI commands use a page from a
dedicated mempool (sd_page_pool) for their payload. This pool was
initialized to allocate single pages, which was sufficient as long as the
device sector size did not exceed the PAGE_SIZE.

Given that block layer now supports block size upto 64KB, i.e. beyond
PAGE_SIZE, initialize a large page pool in sd_probe() if a higher sector
device is attached, ensuring atomicity. Adapt sd_set_special_bvec() to use
large page pool when a higher sector size device is attached. Hence enable
sector sizes > PAGE_SIZE in SCSI sd driver.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>
Co-developed-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Link: https://patch.msgid.link/20260219043741.276729-2-sw.prabhu6@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: bb31844d88b7 ("scsi: sd: Fix special_vec mempool leak when scsi_alloc_sgtables() fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 80 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 68 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d5f8701659a5a..f963b9374e0af 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -109,8 +109,11 @@ static void sd_unlock_native_capacity(struct gendisk *disk);
 static void scsi_disk_release(struct device *cdev);
 
 static DEFINE_IDA(sd_index_ida);
+static DEFINE_MUTEX(sd_mutex_lock);
 
 static mempool_t *sd_page_pool;
+static mempool_t *sd_large_page_pool;
+static atomic_t sd_large_page_pool_users = ATOMIC_INIT(0);
 static struct lock_class_key sd_bio_compl_lkclass;
 
 static const char *sd_cache_types[] = {
@@ -118,6 +121,33 @@ static const char *sd_cache_types[] = {
 	"write back, no read (daft)"
 };
 
+static int sd_large_pool_create(void)
+{
+	mutex_lock(&sd_mutex_lock);
+	if (!sd_large_page_pool) {
+		sd_large_page_pool = mempool_create_page_pool(
+			SD_MEMPOOL_SIZE, get_order(BLK_MAX_BLOCK_SIZE));
+		if (!sd_large_page_pool) {
+			printk(KERN_ERR "sd: can't create large page mempool\n");
+			mutex_unlock(&sd_mutex_lock);
+			return -ENOMEM;
+		}
+	}
+	atomic_inc(&sd_large_page_pool_users);
+	mutex_unlock(&sd_mutex_lock);
+	return 0;
+}
+
+static void sd_large_pool_destroy(void)
+{
+	mutex_lock(&sd_mutex_lock);
+	if (atomic_dec_and_test(&sd_large_page_pool_users)) {
+		mempool_destroy(sd_large_page_pool);
+		sd_large_page_pool = NULL;
+	}
+	mutex_unlock(&sd_mutex_lock);
+}
+
 static void sd_disable_discard(struct scsi_disk *sdkp)
 {
 	sdkp->provisioning_mode = SD_LBP_DISABLE;
@@ -889,14 +919,24 @@ static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
 	return protect;
 }
 
-static void *sd_set_special_bvec(struct request *rq, unsigned int data_len)
+static void *sd_set_special_bvec(struct scsi_cmnd *cmd, unsigned int data_len)
 {
 	struct page *page;
+	struct request *rq = scsi_cmd_to_rq(cmd);
+	struct scsi_device *sdp = cmd->device;
+	unsigned sector_size = sdp->sector_size;
+	unsigned int nr_pages = DIV_ROUND_UP(sector_size, PAGE_SIZE);
+	int n;
 
-	page = mempool_alloc(sd_page_pool, GFP_ATOMIC);
+	if (sector_size > PAGE_SIZE)
+		page = mempool_alloc(sd_large_page_pool, GFP_ATOMIC);
+	else
+		page = mempool_alloc(sd_page_pool, GFP_ATOMIC);
 	if (!page)
 		return NULL;
-	clear_highpage(page);
+
+	for (n = 0; n < nr_pages; n++)
+		clear_highpage(page + n);
 	bvec_set_page(&rq->special_vec, page, data_len, 0);
 	rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
 	return bvec_virt(&rq->special_vec);
@@ -912,7 +952,7 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	unsigned int data_len = 24;
 	char *buf;
 
-	buf = sd_set_special_bvec(rq, data_len);
+	buf = sd_set_special_bvec(cmd, data_len);
 	if (!buf)
 		return BLK_STS_RESOURCE;
 
@@ -1000,7 +1040,7 @@ static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	u32 data_len = sdp->sector_size;
 
-	if (!sd_set_special_bvec(rq, data_len))
+	if (!sd_set_special_bvec(cmd, data_len))
 		return BLK_STS_RESOURCE;
 
 	cmd->cmd_len = 16;
@@ -1027,7 +1067,7 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	u32 data_len = sdp->sector_size;
 
-	if (!sd_set_special_bvec(rq, data_len))
+	if (!sd_set_special_bvec(cmd, data_len))
 		return BLK_STS_RESOURCE;
 
 	cmd->cmd_len = 10;
@@ -1468,9 +1508,15 @@ static blk_status_t sd_init_command(struct scsi_cmnd *cmd)
 static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 {
 	struct request *rq = scsi_cmd_to_rq(SCpnt);
+	struct scsi_device *sdp = SCpnt->device;
+	unsigned sector_size = sdp->sector_size;
 
-	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
-		mempool_free(rq->special_vec.bv_page, sd_page_pool);
+	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD) {
+		if (sector_size > PAGE_SIZE)
+			mempool_free(rq->special_vec.bv_page, sd_large_page_pool);
+		else
+			mempool_free(rq->special_vec.bv_page, sd_page_pool);
+	}
 }
 
 static bool sd_need_revalidate(struct gendisk *disk, struct scsi_disk *sdkp)
@@ -2870,10 +2916,7 @@ sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
 			  "assuming 512.\n");
 	}
 
-	if (sector_size != 512 &&
-	    sector_size != 1024 &&
-	    sector_size != 2048 &&
-	    sector_size != 4096) {
+	if (blk_validate_block_size(sector_size)) {
 		sd_printk(KERN_NOTICE, sdkp, "Unsupported sector size %d.\n",
 			  sector_size);
 		/*
@@ -4004,6 +4047,12 @@ static int sd_probe(struct scsi_device *sdp)
 	sdkp->max_medium_access_timeouts = SD_MAX_MEDIUM_TIMEOUTS;
 
 	sd_revalidate_disk(gd);
+	if (sdp->sector_size > PAGE_SIZE) {
+		if (sd_large_pool_create()) {
+			error = -ENOMEM;
+			goto out_free_index;
+		}
+	}
 
 	if (sdp->removable) {
 		gd->flags |= GENHD_FL_REMOVABLE;
@@ -4021,6 +4070,8 @@ static int sd_probe(struct scsi_device *sdp)
 	if (error) {
 		device_unregister(&sdkp->disk_dev);
 		put_disk(gd);
+		if (sdp->sector_size > PAGE_SIZE)
+			sd_large_pool_destroy();
 		goto out;
 	}
 
@@ -4182,6 +4233,9 @@ static void sd_remove(struct scsi_device *sdp)
 		sd_shutdown(sdp);
 
 	put_disk(sdkp->disk);
+
+	if (sdp->sector_size > PAGE_SIZE)
+		sd_large_pool_destroy();
 }
 
 static inline bool sd_do_start_stop(struct scsi_device *sdev, bool runtime)
@@ -4405,6 +4459,8 @@ static void __exit exit_sd(void)
 
 	scsi_unregister_driver(&sd_template);
 	mempool_destroy(sd_page_pool);
+	if (sd_large_page_pool)
+		mempool_destroy(sd_large_page_pool);
 
 	class_unregister(&sd_disk_class);
 
-- 
2.53.0



