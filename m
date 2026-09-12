Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99CB3749F6;
	Sat, 12 Sep 2026 09:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203827; cv=none; b=GC+cnX9uvwqTvo25aAFQ6xiPX9hZ+jZhPrUmfL8k6Bw5EnyEgEMqZb/xTjFVjEwkOn10izdHoLgEY/ZPUERBmnuDEZsNqa5voAVf3ed++cbuQEs2wgDBSe+/gRe20Xp2xaS5iTyO7XrhPPYmGALyTqmzNOKwL+P3fS5e8jmZ7YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203827; c=relaxed/simple;
	bh=y/OrW3EYwAlGaEl6c0vkQSM+vLsIpKSSi6SQckfm3FA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5pX9Si7MoAjewUpX6ess/5spM/7xcyQGA4gv/ZEE9Q/HbmgLfg5BBUgugHJWic0U2cPLQ4oTCWMOLudUGzy4ufDdblBvYvwS71yiD+gSVo+zE6mS3ABpeYpQNIoYTmVCGTTZ7jg+jk27hOvhSXyKAJchqdvWIZE0ylYFKcN7qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gUoLheza; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gUoLheza"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2007D1F000FF;
	Sat, 12 Sep 2026 09:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203825;
	bh=ObfbykBLC587XnHS+mYMENb6ulvfkhDJGa+fh7QzvOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gUoLhezaZ+9S7r7wWTadS+jHy4zKEJzqheVIGWSXI/y/PSYO5+1lxai0W12/JnkKy
	 bZ7LI3P3++zi+x22+qsLHw0oSLDMwAGgqF6VLLZiQgJY0brGC30YJxDnFbtzF8eqUZ
	 LiKYhLHF/Bg2mxET/fII/y94DvTX0T3qMG0s3/c0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+643a6dd130546afdf1fb@syzkaller.appspotmail.com,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1487/1815] null_blk: serialize configfs attribute updates with device setup
Date: Sat, 12 Sep 2026 08:53:57 +0200
Message-ID: <20260912065723.913758726@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 4e1f23f9c33c156be7e313b40695af5a3a834739 ]

The attribute store methods generated with NULLB_DEVICE_ATTR() refuse to
change the configuration of a live device by testing
NULLB_DEV_FL_CONFIGURED, but that flag is only set by
nullb_device_power_store() after null_add_dev() has returned, and the
store methods take no lock at all. configfs only serializes writes to
the same open file (buffer->mutex), so a write to any attribute can run
concurrently with null_add_dev() and change the device configuration
while it is being used.

null_add_dev() reads the configuration several times, e.g. dev->zoned is
read once to set up the queue limits and once to initialize the zone
resources:

  CPU0: echo 1 > nullb0/power         CPU1: echo 1 > nullb0/zoned
  nullb_device_power_store()
    mutex_lock(&lock)
    null_add_dev()
      if (dev->zoned) -> false
        /* no BLK_FEAT_ZONED */       nullb_device_zoned_store()
                                        test_bit(FL_CONFIGURED) -> 0
                                        dev->zoned = true
      blk_mq_alloc_disk()
        /* queue is not zoned */
      if (nullb->dev->zoned) -> true
        null_register_zoned_dev()
          blk_revalidate_disk_zones()

blk_revalidate_disk_zones() is then called for a queue that does not
have BLK_FEAT_ZONED set, which triggers its WARN_ON_ONCE() and fails the
device setup with -EIO:

  WARNING: CPU: 2 PID: 322 at block/blk-zoned.c:2357 blk_revalidate_disk_zones+0x4c/0x560

Clearing dev->zoned in the same window is worse: the queue is created
with BLK_FEAT_ZONED but the zone resources are never initialized, so
add_disk() succeeds for a zoned disk that has no zones. And a store that
lands after the last dev->zoned test leaves dev->zoned set while
dev->zones is still NULL, which null_process_zoned_cmd() dereferences on
the first write.

Fix this by taking the global lock, which nullb_device_power_store()
already holds across null_add_dev() and null_del_dev(), around both the
NULLB_DEV_FL_CONFIGURED test and the update of the device configuration.
The submit_queues and poll_queues apply callbacks are now called with
that lock held, so remove the locking they did themselves.

Since the store methods can run as soon as configfs_register_subsystem()
returns, that is, before null_init() gets to mutex_init(&lock), also
initialize the lock statically with DEFINE_MUTEX().

Fixes: 3bf2bd20734e ("nullb: add configfs interface")
Reported-by: syzbot+643a6dd130546afdf1fb@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-block/6a7d0b3f.ac361c09.22ff0a.004c.GAE@google.com/
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://patch.msgid.link/20260813141456.1625857-2-cassel@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 0db0ac65cf49e..4a9beec211b92 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -340,7 +340,15 @@ static ssize_t nullb_device_bool_attr_store(bool *val, const char *page,
 	return count;
 }
 
-/* The following macro should only be used with TYPE = {uint, ulong, bool}. */
+/*
+ * The following macro should only be used with TYPE = {uint, ulong, bool}.
+ *
+ * The device configuration is modified under the global lock to serialize
+ * attribute changes against null_add_dev() and null_del_dev(): without this,
+ * an attribute could be changed while null_add_dev() is running, that is,
+ * before NULLB_DEV_FL_CONFIGURED is set, which would let null_add_dev()
+ * observe inconsistent values for the device configuration.
+ */
 #define NULLB_DEVICE_ATTR(NAME, TYPE, APPLY)				\
 static ssize_t								\
 nullb_device_##NAME##_show(struct config_item *item, char *page)	\
@@ -380,6 +388,8 @@ static int nullb_update_nr_hw_queues(struct nullb_device *dev,
 	struct blk_mq_tag_set *set;
 	int ret, nr_hw_queues;
 
+	lockdep_assert_held(&lock);
+
 	if (!dev->nullb)
 		return 0;
 
@@ -2215,8 +2225,6 @@ static void __exit null_exit(void)
 
 	if (tag_set.ops)
 		blk_mq_free_tag_set(&tag_set);
-
-	mutex_destroy(&lock);
 }
 
 module_init(null_init);
-- 
2.53.0



