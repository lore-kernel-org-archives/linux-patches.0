Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2405A183CC3;
	Mon, 18 Aug 2025 14:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526153; cv=none; b=rJYPwaLMXHXFf8U4WbXX1FSLD3vOy1p4QJBLvQmUSMcXs514wCACdGOclFB5Wk13dfh0CXU3ku8PO+h5kY5M9vgqELXJJUKgIgzajplsnx4NFFvhoT3P2Mybx624swAIL8m/4drmcL3aLCHYtbzzUUupcZqq6DtrSVyqO6jPbhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526153; c=relaxed/simple;
	bh=cLyz8mcOvvmnWTG814yIn8k0UHWmbPvgewc8N2aQbOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CuLTRADw+9Tlf2OCZToEG4EewSDsRE8Nw2r9JRaFZRRbsd3ZZlw78vXOPb+S0HFLN811KAU4JJzZFEAglPozxcCvuf4q38UTQOUdrJ9MndwSq05PdZKpFT6WZQd4i26S2e5qRrhjrj76GvAO/1WLMTCyWifg+CapCE57+DPMQzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZwLkAwry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZwLkAwry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F85DC4CEEB;
	Mon, 18 Aug 2025 14:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526152;
	bh=cLyz8mcOvvmnWTG814yIn8k0UHWmbPvgewc8N2aQbOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZwLkAwryL2DnQAYTQ6tw+3pAiXKHqaJPNobWqERiw2myxqBcuuJM0VdftgYUm8jJf
	 keByTUyNQQngbRc75E7QSx0NmNFWQNOt1aD56RV1mJ/M4oNaWKa/g6S1FG7AdxIAf8
	 cWCV+iwSOXMHoPSpgptoZ7y6fTSjR2PfCTtJ4Pfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Zheng Qixing <zhengqixing@huawei.com>,
	Ming Lei <ming.lei@redhat.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 473/570] block: fix kobject double initialization in add_disk
Date: Mon, 18 Aug 2025 14:47:40 +0200
Message-ID: <20250818124524.109670473@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Qixing <zhengqixing@huawei.com>

[ Upstream commit 343dc5423bfe876c12bb80c56f5e44286e442a07 ]

Device-mapper can call add_disk() multiple times for the same gendisk
due to its two-phase creation process (dm create + dm load). This leads
to kobject double initialization errors when the underlying iSCSI devices
become temporarily unavailable and then reappear.

However, if the first add_disk() call fails and is retried, the queue_kobj
gets initialized twice, causing:

kobject: kobject (ffff88810c27bb90): tried to init an initialized object,
something is seriously wrong.
 Call Trace:
  <TASK>
  dump_stack_lvl+0x5b/0x80
  kobject_init.cold+0x43/0x51
  blk_register_queue+0x46/0x280
  add_disk_fwnode+0xb5/0x280
  dm_setup_md_queue+0x194/0x1c0
  table_load+0x297/0x2d0
  ctl_ioctl+0x2a2/0x480
  dm_ctl_ioctl+0xe/0x20
  __x64_sys_ioctl+0xc7/0x110
  do_syscall_64+0x72/0x390
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fix this by separating kobject initialization from sysfs registration:
 - Initialize queue_kobj early during gendisk allocation
 - add_disk() only adds the already-initialized kobject to sysfs
 - del_gendisk() removes from sysfs but doesn't destroy the kobject
 - Final cleanup happens when the disk is released

Fixes: 2bd85221a625 ("block: untangle request_queue refcounting from sysfs")
Reported-by: Li Lingfeng <lilingfeng3@huawei.com>
Closes: https://lore.kernel.org/all/83591d0b-2467-433c-bce0-5581298eb161@huawei.com/
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Link: https://lore.kernel.org/r/20250808053609.3237836-1-zhengqixing@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-sysfs.c | 12 +++++-------
 block/blk.h       |  1 +
 block/genhd.c     |  2 ++
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index c611444480b3..de39746de18b 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -821,7 +821,7 @@ static void blk_queue_release(struct kobject *kobj)
 	/* nothing to do here, all data is associated with the parent gendisk */
 }
 
-static const struct kobj_type blk_queue_ktype = {
+const struct kobj_type blk_queue_ktype = {
 	.default_groups = blk_queue_attr_groups,
 	.sysfs_ops	= &queue_sysfs_ops,
 	.release	= blk_queue_release,
@@ -849,15 +849,14 @@ int blk_register_queue(struct gendisk *disk)
 	struct request_queue *q = disk->queue;
 	int ret;
 
-	kobject_init(&disk->queue_kobj, &blk_queue_ktype);
 	ret = kobject_add(&disk->queue_kobj, &disk_to_dev(disk)->kobj, "queue");
 	if (ret < 0)
-		goto out_put_queue_kobj;
+		return ret;
 
 	if (queue_is_mq(q)) {
 		ret = blk_mq_sysfs_register(disk);
 		if (ret)
-			goto out_put_queue_kobj;
+			goto out_del_queue_kobj;
 	}
 	mutex_lock(&q->sysfs_lock);
 
@@ -908,8 +907,8 @@ int blk_register_queue(struct gendisk *disk)
 	mutex_unlock(&q->sysfs_lock);
 	if (queue_is_mq(q))
 		blk_mq_sysfs_unregister(disk);
-out_put_queue_kobj:
-	kobject_put(&disk->queue_kobj);
+out_del_queue_kobj:
+	kobject_del(&disk->queue_kobj);
 	return ret;
 }
 
@@ -960,5 +959,4 @@ void blk_unregister_queue(struct gendisk *disk)
 		elevator_set_none(q);
 
 	blk_debugfs_remove(disk);
-	kobject_put(&disk->queue_kobj);
 }
diff --git a/block/blk.h b/block/blk.h
index fae7653a941f..4746a7704856 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -19,6 +19,7 @@ struct elevator_type;
 /* Max future timer expiry for timeouts */
 #define BLK_MAX_TIMEOUT		(5 * HZ)
 
+extern const struct kobj_type blk_queue_ktype;
 extern struct dentry *blk_debugfs_root;
 
 struct blk_flush_queue {
diff --git a/block/genhd.c b/block/genhd.c
index c26733f6324b..9bbc38d12792 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1303,6 +1303,7 @@ static void disk_release(struct device *dev)
 	disk_free_zone_resources(disk);
 	xa_destroy(&disk->part_tbl);
 
+	kobject_put(&disk->queue_kobj);
 	disk->queue->disk = NULL;
 	blk_put_queue(disk->queue);
 
@@ -1486,6 +1487,7 @@ struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
 	INIT_LIST_HEAD(&disk->slave_bdevs);
 #endif
 	mutex_init(&disk->rqos_state_mutex);
+	kobject_init(&disk->queue_kobj, &blk_queue_ktype);
 	return disk;
 
 out_erase_part0:
-- 
2.50.1



