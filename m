Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34AC37C118;
	Sat, 12 Sep 2026 11:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211366; cv=none; b=O1WF1Hnf3wDjPLnARMNMaQT2nf0udthKudJurEq9evYpJWv4anFVZYEHJ2l5fQFDhf5HItTZsgoycUqbfw3j3KO29nZ0/bqBQoYJakWrm8LKTlwbzrKArhqTRoBzRqgPUyzXVujT/VzwF8IqhV5sdadpA1o72MEmXH3vBcgQK7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211366; c=relaxed/simple;
	bh=m1y608Rkmr8sUlo+GaSV26T1Qu25tUSjreDVKNbkZVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvIF9CNLIMzN5O3Hm0e8ZJ0KlAMlgtcsG0n7plwijQq4yLSr1eGOoAauZ7piR8SETPeUPP0o2Di90YcZaByrAZTWp1aqfdd2RriRk6hYgPRRXr4S6YVDka+hnPy8wWguCTi0P/DcRfATvgvdU5JfaCm7uWS1dZ8gCxurIeQuyto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wYqZbrUU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wYqZbrUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8EA1F00898;
	Sat, 12 Sep 2026 11:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211364;
	bh=m0TZPi8C8taUNEjgzB9PlQknNOwUWM9RNOZNNDUIQKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wYqZbrUU9s+GhWz8a5tc/GaPFDQglVPTUXQOg+1mROLOZhfk6fSII+WfNHvBb54JL
	 wVgdIeiNBQtJpwITx6O9gaJ9f3fwUgVqU4pajpMlqC8LGnqICKrOyuo48t1tZRLyKA
	 NDzfeZMdvwwafAYuCMWV0414il1ltH9Uw0zAM4us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1216/1518] null_blk: free zones array on device power-off
Date: Sat, 12 Sep 2026 08:56:25 +0200
Message-ID: <20260912065651.000647172@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 2a6357a9b935a34f5508618fee8a7fffbf7722a8 ]

null_init_zoned_dev() allocates dev->zones when a zoned device is powered
on, but null_del_dev() never frees it on power-off; dev->zones is only
freed later in null_free_dev(), when the configfs directory is removed. If
the device is powered off and then on again, null_init_zoned_dev()
allocates a new array and overwrites the dev->zones pointer, leaking the
previous allocation each power cycle.

Free dev->zones in null_del_dev() via null_free_zoned_dev() to solve it.
And calling null_free_zoned_dev() in null_free_dev() is no longer necessary
because every caller already invokes null_del_dev() first: via
nullb_group_drop_item() before nullb_device_release(), in the
null_add_dev() error path of null_create_dev(), and in null_destroy_dev().
Remove the redundant call.

And take &lock around zone_cond_store() in the two store wrappers to
serialize dev->zones check-and-deref against its alloc/free, which already
run under &lock. The reason there was no problem before is that only
nullb_device_release() or null_exit() frees the dev->zones, which
guarantees that subsequent users won't access the configfs interface.

Fixes: ca4b2a011948 ("null_blk: add zone support")
Assisted-by: Claude-Code:GLM-5.2
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260725022509.714271-6-wozizhi@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 830cc0ac05e4f..a65e52f6b48cb 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -579,8 +579,13 @@ static ssize_t nullb_device_zone_readonly_store(struct config_item *item,
 						const char *page, size_t count)
 {
 	struct nullb_device *dev = to_nullb_device(item);
+	ssize_t ret;
+
+	mutex_lock(&lock);
+	ret = zone_cond_store(dev, page, count, BLK_ZONE_COND_READONLY);
+	mutex_unlock(&lock);
 
-	return zone_cond_store(dev, page, count, BLK_ZONE_COND_READONLY);
+	return ret;
 }
 CONFIGFS_ATTR_WO(nullb_device_, zone_readonly);
 
@@ -588,8 +593,13 @@ static ssize_t nullb_device_zone_offline_store(struct config_item *item,
 					       const char *page, size_t count)
 {
 	struct nullb_device *dev = to_nullb_device(item);
+	ssize_t ret;
 
-	return zone_cond_store(dev, page, count, BLK_ZONE_COND_OFFLINE);
+	mutex_lock(&lock);
+	ret = zone_cond_store(dev, page, count, BLK_ZONE_COND_OFFLINE);
+	mutex_unlock(&lock);
+
+	return ret;
 }
 CONFIGFS_ATTR_WO(nullb_device_, zone_offline);
 
@@ -836,7 +846,6 @@ static void null_free_dev(struct nullb_device *dev)
 	if (!dev)
 		return;
 
-	null_free_zoned_dev(dev);
 	badblocks_exit(&dev->badblocks);
 	kfree(dev);
 }
@@ -1777,6 +1786,7 @@ static void null_del_dev(struct nullb *nullb)
 	}
 
 	put_disk(nullb->disk);
+	null_free_zoned_dev(dev);
 	if (nullb->tag_set == &nullb->__tag_set)
 		blk_mq_free_tag_set(nullb->tag_set);
 	kfree(nullb->queues);
-- 
2.53.0



