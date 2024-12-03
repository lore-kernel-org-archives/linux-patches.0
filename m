Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CD61F666B;
	Tue,  3 Dec 2024 14:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237756; cv=none; b=r1hj95frss45FEZZ8tKf97+6REtCpWi0yI7kjvBrN/A5s2wRnBhwFOe0BCp/PNPcj5BZfpqtRl78B5iAQ7ndJtvmgzqSEr9Gss4cD52smkWKO/B4GGFiq5nC9arGXKGdjKisJi4H+pnLWke4MBblScVADoHmRDKSkZoOHSHoKII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237756; c=relaxed/simple;
	bh=Wfz+lK2DOabvCw94zDQzoSBOhSPRLHvDe+cbZMSs0cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AncLi2HC0JYel/t28CwRkvRFkdbyev3HcVAHO1w6W/4fsXwMGh4WF8E7m4k2r3U883rC7H9FiPs7fpZnNyb2VB6+mWKDK+1KNW1pBZ3axfy2qJGc1fqvKbEJmAVqH5ycLn1lO1eNtDStUBja3QDbw9QiIUifFDqxaeSa67mpdig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jthdyRDR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jthdyRDR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F95AC4CECF;
	Tue,  3 Dec 2024 14:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237756;
	bh=Wfz+lK2DOabvCw94zDQzoSBOhSPRLHvDe+cbZMSs0cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jthdyRDR00gXj+xWgwqn81s19qwIjv2h2RWr1gtUMdA7Hj+QhE4WpFmwnAXaQb7sE
	 1fV6LJhBENRI7BBp8f/Ntz8AdzSBT1TOQj9p99y/31kq9pGXJghBkBuyqIRDanx20P
	 o8ma/ugusrIww241wrFa7XsJ102NbZiOXBmQy65Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wupeng Ma <mawupeng1@huawei.com>,
	Yang Erkun <yangerkun@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 061/817] brd: defer automatic disk creation until module initialization succeeds
Date: Tue,  3 Dec 2024 15:33:53 +0100
Message-ID: <20241203143958.065296320@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 2fd1ed1017481..5a95671d81515 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -316,8 +316,40 @@ __setup("ramdisk_size=", ramdisk_size);
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
@@ -340,14 +372,9 @@ static int brd_alloc(int i)
 					  BLK_FEAT_NOWAIT,
 	};
 
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
 
 	xa_init(&brd->brd_pages);
 
@@ -378,8 +405,7 @@ static int brd_alloc(int i)
 out_cleanup_disk:
 	put_disk(disk);
 out_free_dev:
-	list_del(&brd->brd_list);
-	kfree(brd);
+	brd_free_device(brd);
 	return err;
 }
 
@@ -398,8 +424,7 @@ static void brd_cleanup(void)
 		del_gendisk(brd->brd_disk);
 		put_disk(brd->brd_disk);
 		brd_free_pages(brd);
-		list_del(&brd->brd_list);
-		kfree(brd);
+		brd_free_device(brd);
 	}
 }
 
@@ -426,16 +451,6 @@ static int __init brd_init(void)
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
@@ -451,11 +466,18 @@ static int __init brd_init(void)
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



