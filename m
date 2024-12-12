Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4974A22967A;
	Thu, 12 Dec 2024 16:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021848; cv=none; b=JvwbhXvRKbp4TrN1qQ6EF0A6WBlUq9O4kAJ3ORXQt7AHLMaG3gQOmKo3PSn4zqPkUXJ/DpYpVpjMROggHrKrg5Fr+Z4jqGkMoUscBBDloGtUnMEOd1uSsOkF6lNhmCKEBLVKsZvd6NeuiC1Qzh9CZnOY7bd8R9WMiDDicMhdars=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021848; c=relaxed/simple;
	bh=jHp742mg6rJW8jZlTpyPCEt5nSEVM/DAq93hTU5WF/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7DEC6rCRztjQAeQQSoPGHAjZof6IlAjlRckha9RrLcnxwsG1kar7YLD0+4sdQ08u3dqnyNX0JhjH30epWlLxP+am0UswQZ9n6pqLvxSWs5sJ3axCO3OuzOZ7GQX5W66MAuxUhfaD1SXQ+Dx92VcfNSg0zUn+0fXK4m4nQ3dUNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLPrzBkq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLPrzBkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C41C4CECE;
	Thu, 12 Dec 2024 16:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021848;
	bh=jHp742mg6rJW8jZlTpyPCEt5nSEVM/DAq93hTU5WF/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLPrzBkqkUAAcoHE5JYjcjmbTuME+OzWBQk+Zks8UlCercjU5Jwpi5UHpuOmGjqc1
	 OK6c0bzb17t3e2aifgP+BIR1AU+U6o6sR3uHVwpM60ndKp/M5Ss/Qg/gLVq/rWGCRZ
	 HtCzCy6kLrRr4B/SSyGyFpEWnLBR6maGxpSUi2ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Christoph Hellwig <hch@lst.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/565] brd: remove brd_devices_mutex mutex
Date: Thu, 12 Dec 2024 15:54:34 +0100
Message-ID: <20241212144314.610521563@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

[ Upstream commit 00358933f66c44d511368a57eb421e172447cfb9 ]

If brd_alloc() from brd_probe() is called before brd_alloc() from
brd_init() is called, module loading will fail with -EEXIST error.
To close this race, call __register_blkdev() just before leaving
brd_init().

Then, we can remove brd_devices_mutex mutex, for brd_device list
will no longer be accessed concurrently.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/6b074af7-c165-4fab-b7da-8270a4f6f6cd@i-love.sakura.ne.jp
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 826cc42adf44 ("brd: defer automatic disk creation until module initialization succeeds")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/brd.c | 73 +++++++++++++++++++--------------------------
 1 file changed, 30 insertions(+), 43 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 76ce6f766d55e..db816baca5567 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -362,7 +362,6 @@ __setup("ramdisk_size=", ramdisk_size);
  * (should share code eventually).
  */
 static LIST_HEAD(brd_devices);
-static DEFINE_MUTEX(brd_devices_mutex);
 static struct dentry *brd_debugfs_dir;
 
 static int brd_alloc(int i)
@@ -372,21 +371,14 @@ static int brd_alloc(int i)
 	char buf[DISK_NAME_LEN];
 	int err = -ENOMEM;
 
-	mutex_lock(&brd_devices_mutex);
-	list_for_each_entry(brd, &brd_devices, brd_list) {
-		if (brd->brd_number == i) {
-			mutex_unlock(&brd_devices_mutex);
+	list_for_each_entry(brd, &brd_devices, brd_list)
+		if (brd->brd_number == i)
 			return -EEXIST;
-		}
-	}
 	brd = kzalloc(sizeof(*brd), GFP_KERNEL);
-	if (!brd) {
-		mutex_unlock(&brd_devices_mutex);
+	if (!brd)
 		return -ENOMEM;
-	}
 	brd->brd_number		= i;
 	list_add_tail(&brd->brd_list, &brd_devices);
-	mutex_unlock(&brd_devices_mutex);
 
 	spin_lock_init(&brd->brd_lock);
 	INIT_RADIX_TREE(&brd->brd_pages, GFP_ATOMIC);
@@ -431,9 +423,7 @@ static int brd_alloc(int i)
 out_cleanup_disk:
 	blk_cleanup_disk(disk);
 out_free_dev:
-	mutex_lock(&brd_devices_mutex);
 	list_del(&brd->brd_list);
-	mutex_unlock(&brd_devices_mutex);
 	kfree(brd);
 	return err;
 }
@@ -443,15 +433,19 @@ static void brd_probe(dev_t dev)
 	brd_alloc(MINOR(dev) / max_part);
 }
 
-static void brd_del_one(struct brd_device *brd)
+static void brd_cleanup(void)
 {
-	del_gendisk(brd->brd_disk);
-	blk_cleanup_disk(brd->brd_disk);
-	brd_free_pages(brd);
-	mutex_lock(&brd_devices_mutex);
-	list_del(&brd->brd_list);
-	mutex_unlock(&brd_devices_mutex);
-	kfree(brd);
+	struct brd_device *brd, *next;
+
+	debugfs_remove_recursive(brd_debugfs_dir);
+
+	list_for_each_entry_safe(brd, next, &brd_devices, brd_list) {
+		del_gendisk(brd->brd_disk);
+		blk_cleanup_disk(brd->brd_disk);
+		brd_free_pages(brd);
+		list_del(&brd->brd_list);
+		kfree(brd);
+	}
 }
 
 static inline void brd_check_and_reset_par(void)
@@ -475,9 +469,18 @@ static inline void brd_check_and_reset_par(void)
 
 static int __init brd_init(void)
 {
-	struct brd_device *brd, *next;
 	int err, i;
 
+	brd_check_and_reset_par();
+
+	brd_debugfs_dir = debugfs_create_dir("ramdisk_pages", NULL);
+
+	for (i = 0; i < rd_nr; i++) {
+		err = brd_alloc(i);
+		if (err)
+			goto out_free;
+	}
+
 	/*
 	 * brd module now has a feature to instantiate underlying device
 	 * structure on-demand, provided that there is an access dev node.
@@ -493,28 +496,16 @@ static int __init brd_init(void)
 	 *	dynamically.
 	 */
 
-	if (__register_blkdev(RAMDISK_MAJOR, "ramdisk", brd_probe))
-		return -EIO;
-
-	brd_check_and_reset_par();
-
-	brd_debugfs_dir = debugfs_create_dir("ramdisk_pages", NULL);
-
-	for (i = 0; i < rd_nr; i++) {
-		err = brd_alloc(i);
-		if (err)
-			goto out_free;
+	if (__register_blkdev(RAMDISK_MAJOR, "ramdisk", brd_probe)) {
+		err = -EIO;
+		goto out_free;
 	}
 
 	pr_info("brd: module loaded\n");
 	return 0;
 
 out_free:
-	unregister_blkdev(RAMDISK_MAJOR, "ramdisk");
-	debugfs_remove_recursive(brd_debugfs_dir);
-
-	list_for_each_entry_safe(brd, next, &brd_devices, brd_list)
-		brd_del_one(brd);
+	brd_cleanup();
 
 	pr_info("brd: module NOT loaded !!!\n");
 	return err;
@@ -522,13 +513,9 @@ static int __init brd_init(void)
 
 static void __exit brd_exit(void)
 {
-	struct brd_device *brd, *next;
 
 	unregister_blkdev(RAMDISK_MAJOR, "ramdisk");
-	debugfs_remove_recursive(brd_debugfs_dir);
-
-	list_for_each_entry_safe(brd, next, &brd_devices, brd_list)
-		brd_del_one(brd);
+	brd_cleanup();
 
 	pr_info("brd: module unloaded\n");
 }
-- 
2.43.0



