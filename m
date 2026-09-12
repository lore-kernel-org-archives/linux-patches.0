Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DDD2BDC0E;
	Sat, 12 Sep 2026 13:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218490; cv=none; b=UPBddDZs7CzvFK1BAGX5nLPEFYggOB/K4hRJVpgjiD2SMrK6GELrkH4exJuPwsGhfEdBW+fPmwL1hU25sw7E1VE3+y07E1knkEGSSYqOaj/1MqCAFA06Mf9KPMMYX8tRA/CYwvGVodabKOvaikpTQvBz0hooX8T/CHXO7gLe240=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218490; c=relaxed/simple;
	bh=UaG0Lk9cODbAEPndrLxwc9DjX+Ei8vgAuiRr2MAopgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZE6fTETsgIzasH/KhUcp44Gnug7RP2uLpLWBYmfU+gIMpV1c4LSHLRYiTM25ZYZoEsYAakB9gGc02Zv9MBWyi6F9bRfE5NWH2aN1w6Yc84hdadZ5ak6yncAqe0yyjHpbjejv29wBkJyW+nnJH4lvIdqgU5AjVfmic0oUprmiC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KhYYfY2d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KhYYfY2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9012B1F000FF;
	Sat, 12 Sep 2026 13:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218488;
	bh=jGmolWxwCBVUwwB1eK52Rg34ZG5Bi+vneq88vvK+nLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KhYYfY2dnWf6gfnO4UvtxaPNdC0FiFrojHLG0Iu4pVIVOGOy1FBDkSn5J4gaQM3yY
	 umrSdi8sbL+Vs/Ld23k0NXusIwpOqkueZK7MbXX6ZN5apP88QB/bZ+UHprHKml1xSi
	 TeNm6Z3Em4kAk1uSoJ8I/2+D18ebfdRF/ooOGr+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1153/1376] null_blk: free zones array on device power-off
Date: Sat, 12 Sep 2026 08:59:39 +0200
Message-ID: <20260912065633.252466699@linuxfoundation.org>
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
index bde38a4696fef..cf8b3283c48e8 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -572,8 +572,13 @@ static ssize_t nullb_device_zone_readonly_store(struct config_item *item,
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
 
@@ -581,8 +586,13 @@ static ssize_t nullb_device_zone_offline_store(struct config_item *item,
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
 
@@ -812,7 +822,6 @@ static void null_free_dev(struct nullb_device *dev)
 	if (!dev)
 		return;
 
-	null_free_zoned_dev(dev);
 	badblocks_exit(&dev->badblocks);
 	kfree(dev);
 }
@@ -1721,6 +1730,7 @@ static void null_del_dev(struct nullb *nullb)
 	}
 
 	put_disk(nullb->disk);
+	null_free_zoned_dev(dev);
 	if (nullb->tag_set == &nullb->__tag_set)
 		blk_mq_free_tag_set(nullb->tag_set);
 	kfree(nullb->queues);
-- 
2.53.0



