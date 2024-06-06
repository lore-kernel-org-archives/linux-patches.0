Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA56219B3EF;
	Thu,  6 Jun 2024 14:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683063; cv=none; b=d2RBUpoKyYUKKkuc5sKepHwiybopg8njurWJB1hITSNcjT4HKI3BOxIl+Hw4mU6uFp+OWQhvWWsfK7Y1bkOhBqNGfJBFEvv60GyCUUbHDvdmF7HzeMqNnL96CrI+tJkGFFYIiKjElXdg/e94oqhymC3l3VqH7/7SlxHzY9vS7o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683063; c=relaxed/simple;
	bh=xwwFPVXUsAAgEfwIJ3bNNeBTBjaS9NK0Q7LPVu7dkFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4/tzGtZxY2+MpwlDVEsQ70Au87t7ZnE3+DE5/22ybF1DAlXTCDnVXJ7hrQF3LSiUr5T1iwwDtoM7sjfyI8diMnDuAhp8jOW0WoKJLpX2MZQNwKbQXJrEg3Jb5rayuSnBisXbY14z5pl8FFeM2sMt0TDB/9KNRmOi7XYC9DhriE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lxujwdsl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lxujwdsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E48C4AF1B;
	Thu,  6 Jun 2024 14:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683063;
	bh=xwwFPVXUsAAgEfwIJ3bNNeBTBjaS9NK0Q7LPVu7dkFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LxujwdsleuoX8EPg9Zg4qcqxVzSp5LH0UNxh4qI2ZuxDDxYDIJ2BKdR6cmqz2AZug
	 6MWpfA2Q/SA6Wr1xryRMdzYi2X+zw4wvHavwjsjctfbyW7R06+Eu3cGCdHin/6cfPK
	 BZ3Fuox+ymalqbsH88+g4hxOQdVoMgUMywMNT8GI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	Yi Zhang <yi.zhang@redhat.com>
Subject: [PATCH 6.9 275/374] null_blk: fix null-ptr-dereference while configuring power and submit_queues
Date: Thu,  6 Jun 2024 16:04:14 +0200
Message-ID: <20240606131701.115425110@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit a2db328b0839312c169eb42746ec46fc1ab53ed2 ]

Writing 'power' and 'submit_queues' concurrently will trigger kernel
panic:

Test script:

modprobe null_blk nr_devices=0
mkdir -p /sys/kernel/config/nullb/nullb0
while true; do echo 1 > submit_queues; echo 4 > submit_queues; done &
while true; do echo 1 > power; echo 0 > power; done

Test result:

BUG: kernel NULL pointer dereference, address: 0000000000000148
Oops: 0000 [#1] PREEMPT SMP
RIP: 0010:__lock_acquire+0x41d/0x28f0
Call Trace:
 <TASK>
 lock_acquire+0x121/0x450
 down_write+0x5f/0x1d0
 simple_recursive_removal+0x12f/0x5c0
 blk_mq_debugfs_unregister_hctxs+0x7c/0x100
 blk_mq_update_nr_hw_queues+0x4a3/0x720
 nullb_update_nr_hw_queues+0x71/0xf0 [null_blk]
 nullb_device_submit_queues_store+0x79/0xf0 [null_blk]
 configfs_write_iter+0x119/0x1e0
 vfs_write+0x326/0x730
 ksys_write+0x74/0x150

This is because del_gendisk() can concurrent with
blk_mq_update_nr_hw_queues():

nullb_device_power_store	nullb_apply_submit_queues
 null_del_dev
 del_gendisk
				 nullb_update_nr_hw_queues
				  if (!dev->nullb)
				  // still set while gendisk is deleted
				   return 0
				  blk_mq_update_nr_hw_queues
 dev->nullb = NULL

Fix this problem by resuing the global mutex to protect
nullb_device_power_store() and nullb_update_nr_hw_queues() from configfs.

Fixes: 45919fbfe1c4 ("null_blk: Enable modifying 'submit_queues' after an instance has been configured")
Reported-and-tested-by: Yi Zhang <yi.zhang@redhat.com>
Closes: https://lore.kernel.org/all/CAHj4cs9LgsHLnjg8z06LQ3Pr5cax-+Ps+xT7AP7TPnEjStuwZA@mail.gmail.com/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Link: https://lore.kernel.org/r/20240523153934.1937851-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 40 +++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 14ffda1ffe6c3..3b3fd093b0044 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -404,13 +404,25 @@ static int nullb_update_nr_hw_queues(struct nullb_device *dev,
 static int nullb_apply_submit_queues(struct nullb_device *dev,
 				     unsigned int submit_queues)
 {
-	return nullb_update_nr_hw_queues(dev, submit_queues, dev->poll_queues);
+	int ret;
+
+	mutex_lock(&lock);
+	ret = nullb_update_nr_hw_queues(dev, submit_queues, dev->poll_queues);
+	mutex_unlock(&lock);
+
+	return ret;
 }
 
 static int nullb_apply_poll_queues(struct nullb_device *dev,
 				   unsigned int poll_queues)
 {
-	return nullb_update_nr_hw_queues(dev, dev->submit_queues, poll_queues);
+	int ret;
+
+	mutex_lock(&lock);
+	ret = nullb_update_nr_hw_queues(dev, dev->submit_queues, poll_queues);
+	mutex_unlock(&lock);
+
+	return ret;
 }
 
 NULLB_DEVICE_ATTR(size, ulong, NULL);
@@ -457,28 +469,31 @@ static ssize_t nullb_device_power_store(struct config_item *item,
 	if (ret < 0)
 		return ret;
 
+	ret = count;
+	mutex_lock(&lock);
 	if (!dev->power && newp) {
 		if (test_and_set_bit(NULLB_DEV_FL_UP, &dev->flags))
-			return count;
+			goto out;
+
 		ret = null_add_dev(dev);
 		if (ret) {
 			clear_bit(NULLB_DEV_FL_UP, &dev->flags);
-			return ret;
+			goto out;
 		}
 
 		set_bit(NULLB_DEV_FL_CONFIGURED, &dev->flags);
 		dev->power = newp;
 	} else if (dev->power && !newp) {
 		if (test_and_clear_bit(NULLB_DEV_FL_UP, &dev->flags)) {
-			mutex_lock(&lock);
 			dev->power = newp;
 			null_del_dev(dev->nullb);
-			mutex_unlock(&lock);
 		}
 		clear_bit(NULLB_DEV_FL_CONFIGURED, &dev->flags);
 	}
 
-	return count;
+out:
+	mutex_unlock(&lock);
+	return ret;
 }
 
 CONFIGFS_ATTR(nullb_device_, power);
@@ -1918,15 +1933,12 @@ static int null_add_dev(struct nullb_device *dev)
 	nullb->q->queuedata = nullb;
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, nullb->q);
 
-	mutex_lock(&lock);
 	rv = ida_alloc(&nullb_indexes, GFP_KERNEL);
-	if (rv < 0) {
-		mutex_unlock(&lock);
+	if (rv < 0)
 		goto out_cleanup_disk;
-	}
+
 	nullb->index = rv;
 	dev->index = rv;
-	mutex_unlock(&lock);
 
 	if (config_item_name(&dev->group.cg_item)) {
 		/* Use configfs dir name as the device name */
@@ -1955,9 +1967,7 @@ static int null_add_dev(struct nullb_device *dev)
 	if (rv)
 		goto out_ida_free;
 
-	mutex_lock(&lock);
 	list_add_tail(&nullb->list, &nullb_list);
-	mutex_unlock(&lock);
 
 	pr_info("disk %s created\n", nullb->disk_name);
 
@@ -2006,7 +2016,9 @@ static int null_create_dev(void)
 	if (!dev)
 		return -ENOMEM;
 
+	mutex_lock(&lock);
 	ret = null_add_dev(dev);
+	mutex_unlock(&lock);
 	if (ret) {
 		null_free_dev(dev);
 		return ret;
-- 
2.43.0



