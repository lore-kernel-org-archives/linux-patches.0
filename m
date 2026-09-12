Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60759357CFA;
	Sat, 12 Sep 2026 11:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211375; cv=none; b=rXCvWpvPExSshcNCLyxQAZUNHWnHdUZKXrv+qg7WEm+uoCJXkZo/eE86gPkrghHpN4tMpmQDTxM4mTA3ruUMMmCvO8kuXWRPlH9+7I/PJBlZdGswRZnEWVazICouQu19BKUmMQ04u/fG6XHnzIzwfvjEDUDt/vgrK6rWtc63hgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211375; c=relaxed/simple;
	bh=UOhr/BKQggOHvAf5TADudZD/w6P0DOIQHVUDzsu0wrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=um7MNgKSsY0P18mq6+gSszDGlrKxfh/7zekjc8CPQN0wAHDjWcwkGkeQ4e8IhgZMZg8WzmCtVxodq+zHf45sM8kIMOoZAQVosNLeqcCFwoZd/9xpajDH1bogB94f/kObU1W0JeR5zuGKloAbzYmiqo4mvdCpZgo//rxhhEYlqrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9DUN1Ih; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9DUN1Ih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1994C1F000FF;
	Sat, 12 Sep 2026 11:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211374;
	bh=Jd6i2aEvX+8AbgJd5MS+zjPDz2c3jLIaGy6TALjRRlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S9DUN1Ih4JYpClAV8ZLZ6MNYHRRcF0OFJSZnpHw9vLurWn/H490bqcXdHVs7cEn3V
	 j9Ku7/jRxkQq3nfbGedS5z9imwO6LFRa0am+gtjLVofE9Fcl5tR/sN15lJvDZhjM60
	 TCxKSg1eoe9+gZQuQEr5wVr1kbXK3hpsSsRIb7Yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Zizhi Wo <wozizhi@huawei.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1218/1518] null_blk: serialize configfs attribute stores with the lock
Date: Sat, 12 Sep 2026 08:56:27 +0200
Message-ID: <20260912065651.047822901@linuxfoundation.org>
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

[ Upstream commit 7e7fff51808237703a3a1df6dd5cae1dfd1db86d ]

The NULLB_DEVICE_ATTR _store takes no lock: apply_fn attributes
(submit_queues, poll_queues) get dev->NAME written again after apply_fn
returns, outside its lock; APPLY=NULL attributes are entirely lockless.
configfs only serializes stores per-open-file, so concurrent stores on
separate fds race.

For apply_fn attributes, once one store's apply_fn has reconfigured the
hardware, a second (losing) store can still overwrite dev->NAME
afterwards. This leaves dev->submit_queues out of sync with the live
queue count, which is later caught by the WARN_ON_ONCE() in
null_map_queues().

For !apply_fn attributes, power_store()'s null_add_dev() validates and
builds the device under "lock" but only sets CONFIGURED afterwards. A store
slipping in during this window can change a field mid-setup -- for example,
zone_nr_conv can be pushed above nr_zones after it has already been
clamped, leading to an out-of-bounds dev->zones[] access.

Take "lock" in the macro around the apply_fn call, the CONFIGURED test and
the field write, and move it out of nullb_apply_submit_queues()/
nullb_apply_poll_queues() so both paths are covered once. This serializes
stores with power_store's setup and with each other.

Fixes: 45919fbfe1c4 ("null_blk: Enable modifying 'submit_queues' after an instance has been configured")
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Link: https://patch.msgid.link/20260725022509.714271-10-wozizhi@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 50bc0b008b558..b3dd57ac9fff5 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -360,6 +360,7 @@ nullb_device_##NAME##_store(struct config_item *item, const char *page,	\
 	ret = nullb_device_##TYPE##_attr_store(&new_value, page, count);\
 	if (ret < 0)							\
 		return ret;						\
+	guard(mutex)(&lock);						\
 	if (apply_fn)							\
 		ret = apply_fn(dev, new_value);				\
 	else if (test_bit(NULLB_DEV_FL_CONFIGURED, &dev->flags)) 	\
@@ -430,25 +431,13 @@ static int nullb_update_nr_hw_queues(struct nullb_device *dev,
 static int nullb_apply_submit_queues(struct nullb_device *dev,
 				     unsigned int submit_queues)
 {
-	int ret;
-
-	mutex_lock(&lock);
-	ret = nullb_update_nr_hw_queues(dev, submit_queues, dev->poll_queues);
-	mutex_unlock(&lock);
-
-	return ret;
+	return nullb_update_nr_hw_queues(dev, submit_queues, dev->poll_queues);
 }
 
 static int nullb_apply_poll_queues(struct nullb_device *dev,
 				   unsigned int poll_queues)
 {
-	int ret;
-
-	mutex_lock(&lock);
-	ret = nullb_update_nr_hw_queues(dev, dev->submit_queues, poll_queues);
-	mutex_unlock(&lock);
-
-	return ret;
+	return nullb_update_nr_hw_queues(dev, dev->submit_queues, poll_queues);
 }
 
 NULLB_DEVICE_ATTR(size, ulong, NULL);
-- 
2.53.0



