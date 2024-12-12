Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45F721B91D;
	Thu, 12 Dec 2024 15:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018845; cv=none; b=UKgG+hbFpzU0bROIEx5uknE85SuVvZ+DMgSz0P3agfUZODY+RRERrXQuvqTnHu1m/VBd6KQwvnZahIiCJsCIW8wtC+b5I9BgosLfEW8Ix1Ibn/vZPan0iCcmEdVMviXtk0vikmdSf7LcebE3yRykBKbKrqOfo+2yJQveMXNJZhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018845; c=relaxed/simple;
	bh=fAbQyqwAa8GY07Uj0d5Iec/7mA0CkzWlAVOWkUmVcCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zr7P1mRKN8YfrY4N4m06SjPMZ7YhwnsNXqmW6B1jcLXZZW19FL33W2j89BmGUBu2i1geBMKBdqnxIicI9zREh/dchD9GmAmkpkQyp7dX+2/BlgdeClF2KNPbR5GahvcX7J2HcSlAa1bSnV1jh208EPnFJt6OcMozqbUUwTRH51I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f1qgK8kD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f1qgK8kD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5CAC4CECE;
	Thu, 12 Dec 2024 15:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018845;
	bh=fAbQyqwAa8GY07Uj0d5Iec/7mA0CkzWlAVOWkUmVcCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f1qgK8kD0TzEi73L3qzUURzo4+4jSi6NWhNCNPkBsBoAQRWOC010GMU+l3XCQshQJ
	 omQYJHx8sN+J2D37MnNjsBLwWfNRLshbBbtJvOAazrTEmHjivSWXjxQYav0DvEMqgx
	 FYeshOzWQnk/lnS2sZXnU9RuDfFUNzrWukGK7yvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wupeng Ma <mawupeng1@huawei.com>,
	Yang Erkun <yangerkun@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/772] brd: defer automatic disk creation until module initialization succeeds
Date: Thu, 12 Dec 2024 15:49:54 +0100
Message-ID: <20241212144351.966933819@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Yang Erkun <yangerkun@huawei.com>

[ Upstream commit 826cc42adf44930a633d11a5993676d85ddb0842 ]

My colleague Wupeng found the following problems during fault injection:

BUG: unable to handle page fault for address: fffffbfff809d073
PGD 6e648067 P4D 123ec8067 PUD 123ec4067 PMD 100e38067 PTE 0
Oops: Oops: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 5 UID: 0 PID: 755 Comm: modprobe Not tainted 6.12.0-rc3+ #17
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.16.1-2.fc37 04/01/2014
RIP: 0010:__asan_load8+0x4c/0xa0
...
Call Trace:
 <TASK>
 blkdev_put_whole+0x41/0x70
 bdev_release+0x1a3/0x250
 blkdev_release+0x11/0x20
 __fput+0x1d7/0x4a0
 task_work_run+0xfc/0x180
 syscall_exit_to_user_mode+0x1de/0x1f0
 do_syscall_64+0x6b/0x170
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

loop_init() is calling loop_add() after __register_blkdev() succeeds and
is ignoring disk_add() failure from loop_add(), for loop_add() failure
is not fatal and successfully created disks are already visible to
bdev_open().

brd_init() is currently calling brd_alloc() before __register_blkdev()
succeeds and is releasing successfully created disks when brd_init()
returns an error. This can cause UAF for the latter two case:

case 1:
    T1:
modprobe brd
  brd_init
    brd_alloc(0) // success
      add_disk
        disk_scan_partitions
          bdev_file_open_by_dev // alloc file
          fput // won't free until back to userspace
    brd_alloc(1) // failed since mem alloc error inject
  // error path for modprobe will release code segment
  // back to userspace
  __fput
    blkdev_release
      bdev_release
        blkdev_put_whole
          bdev->bd_disk->fops->release // fops is freed now, UAF!

case 2:
    T1:                            T2:
modprobe brd
  brd_init
    brd_alloc(0) // success
                                   open(/dev/ram0)
    brd_alloc(1) // fail
  // error path for modprobe

                                   close(/dev/ram0)
                                   ...
                                   /* UAF! */
                                   bdev->bd_disk->fops->release

Fix this problem by following what loop_init() does. Besides,
reintroduce brd_devices_mutex to help serialize modifications to
brd_list.

Fixes: 7f9b348cb5e9 ("brd: convert to blk_alloc_disk/blk_cleanup_disk")
Reported-by: Wupeng Ma <mawupeng1@huawei.com>
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20241030034914.907829-1-yangerkun@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/brd.c | 66 ++++++++++++++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 22 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index a8a77a1efe1e3..b2c109f08808a 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -368,8 +368,40 @@ __setup("ramdisk_size=", ramdisk_size);
  * (should share code eventually).
  */
 static LIST_HEAD(brd_devices);
+static DEFINE_MUTEX(brd_devices_mutex);
 static struct dentry *brd_debugfs_dir;
 
+static struct brd_device *brd_find_or_alloc_device(int i)
+{
+	struct brd_device *brd;
+
+	mutex_lock(&brd_devices_mutex);
+	list_for_each_entry(brd, &brd_devices, brd_list) {
+		if (brd->brd_number == i) {
+			mutex_unlock(&brd_devices_mutex);
+			return ERR_PTR(-EEXIST);
+		}
+	}
+
+	brd = kzalloc(sizeof(*brd), GFP_KERNEL);
+	if (!brd) {
+		mutex_unlock(&brd_devices_mutex);
+		return ERR_PTR(-ENOMEM);
+	}
+	brd->brd_number	= i;
+	list_add_tail(&brd->brd_list, &brd_devices);
+	mutex_unlock(&brd_devices_mutex);
+	return brd;
+}
+
+static void brd_free_device(struct brd_device *brd)
+{
+	mutex_lock(&brd_devices_mutex);
+	list_del(&brd->brd_list);
+	mutex_unlock(&brd_devices_mutex);
+	kfree(brd);
+}
+
 static int brd_alloc(int i)
 {
 	struct brd_device *brd;
@@ -377,14 +409,9 @@ static int brd_alloc(int i)
 	char buf[DISK_NAME_LEN];
 	int err = -ENOMEM;
 
-	list_for_each_entry(brd, &brd_devices, brd_list)
-		if (brd->brd_number == i)
-			return -EEXIST;
-	brd = kzalloc(sizeof(*brd), GFP_KERNEL);
-	if (!brd)
-		return -ENOMEM;
-	brd->brd_number		= i;
-	list_add_tail(&brd->brd_list, &brd_devices);
+	brd = brd_find_or_alloc_device(i);
+	if (IS_ERR(brd))
+		return PTR_ERR(brd);
 
 	spin_lock_init(&brd->brd_lock);
 	INIT_RADIX_TREE(&brd->brd_pages, GFP_ATOMIC);
@@ -428,8 +455,7 @@ static int brd_alloc(int i)
 out_cleanup_disk:
 	put_disk(disk);
 out_free_dev:
-	list_del(&brd->brd_list);
-	kfree(brd);
+	brd_free_device(brd);
 	return err;
 }
 
@@ -448,8 +474,7 @@ static void brd_cleanup(void)
 		del_gendisk(brd->brd_disk);
 		put_disk(brd->brd_disk);
 		brd_free_pages(brd);
-		list_del(&brd->brd_list);
-		kfree(brd);
+		brd_free_device(brd);
 	}
 }
 
@@ -476,16 +501,6 @@ static int __init brd_init(void)
 {
 	int err, i;
 
-	brd_check_and_reset_par();
-
-	brd_debugfs_dir = debugfs_create_dir("ramdisk_pages", NULL);
-
-	for (i = 0; i < rd_nr; i++) {
-		err = brd_alloc(i);
-		if (err)
-			goto out_free;
-	}
-
 	/*
 	 * brd module now has a feature to instantiate underlying device
 	 * structure on-demand, provided that there is an access dev node.
@@ -501,11 +516,18 @@ static int __init brd_init(void)
 	 *	dynamically.
 	 */
 
+	brd_check_and_reset_par();
+
+	brd_debugfs_dir = debugfs_create_dir("ramdisk_pages", NULL);
+
 	if (__register_blkdev(RAMDISK_MAJOR, "ramdisk", brd_probe)) {
 		err = -EIO;
 		goto out_free;
 	}
 
+	for (i = 0; i < rd_nr; i++)
+		brd_alloc(i);
+
 	pr_info("brd: module loaded\n");
 	return 0;
 
-- 
2.43.0



