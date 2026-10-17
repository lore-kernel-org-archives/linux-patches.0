Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1ED3A2540;
	Sat, 17 Oct 2026 18:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260176; cv=none; b=l5SYMJW0r3s4Eu2h2FMJsMsoSi2SNmDLOCyY7t1FXX7oow4tLZ35C+hCd79Jm+aZHVCb1qHuCn01GshTGqFvoNZZAQZ3MxgdteARsnQSdy+63184gdy+CYnAwMHlXazJ2soQMMTs+14mz3q4vk1A0N6V4843ZPNzzWIUf65ev2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260176; c=relaxed/simple;
	bh=Tli8UQ6ZbXui90ZjY4cZVzyeo2jqutRPHg+Fv45pSeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIxu6esbYxFAvwFAFvvL+l9e+qfu3w3OzF6wZnhA+Tjv1p3HSdXOi//209kXNsQ7teYwRKHqEO9PN/ASshca4mKvtr3iRBSM3piLgQTNSAfjksdQROEzab/IaQbhvBURzmsJ2x+ZnsgKYLnL4N7FrBcjuD6V6+tqob6wjXAhjCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kWrpIMlv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kWrpIMlv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518421F000C4;
	Sat, 17 Oct 2026 18:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260174;
	bh=rg+Q5mIOYI3NYI7qswJJMcPT5Hzeg6qoUhsmelIlGAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kWrpIMlv2Kuw23sG6aye1Yqas+P9jUowCvn+3iTZr9xLbOhqUVDW0roqH5QJCpeFz
	 b6EnoXevx/6+6eq5ARjdXCqTVowAcyGmzY+GZETEWuidLfzfIIzhSr9t74OWev6IDz
	 BasJAJR0i7LB8wie636GftS4QA75oXA/U63CwAZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1407/1674] null_blk: free zones array on device power-off
Date: Sat, 17 Oct 2026 18:01:19 +0200
Message-ID: <20261017160507.295024618@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a011ae2055d0c..243565d47eb59 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -552,8 +552,13 @@ static ssize_t nullb_device_zone_readonly_store(struct config_item *item,
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
 
@@ -561,8 +566,13 @@ static ssize_t nullb_device_zone_offline_store(struct config_item *item,
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
 
@@ -785,7 +795,6 @@ static void null_free_dev(struct nullb_device *dev)
 	if (!dev)
 		return;
 
-	null_free_zoned_dev(dev);
 	badblocks_exit(&dev->badblocks);
 	kfree(dev);
 }
@@ -1870,6 +1879,7 @@ static void null_del_dev(struct nullb *nullb)
 	}
 
 	put_disk(nullb->disk);
+	null_free_zoned_dev(dev);
 	if (dev->queue_mode == NULL_Q_MQ &&
 	    nullb->tag_set == &nullb->__tag_set)
 		blk_mq_free_tag_set(nullb->tag_set);
-- 
2.53.0



