Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4376423D2B1;
	Sat, 12 Sep 2026 13:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218530; cv=none; b=dDWoehMlTWRS0zI2QKRkx1qldna1//kr0t4VKm/BoZ0NPduinwFgU5sWRu6BLSTGowQ4pebUoRgVh7JKegMgZAUOgL70pUcq5bnTdGLPFrQpNAe3U/c+CLPFXSN4ly8rkRJde8HXRuocHL7VhExs+qh5cLBBTdEHL4Q/2WlXFSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218530; c=relaxed/simple;
	bh=lMamYZn/82G2Wi0E7S+kbJDGmb5gHrfGHkK4vLo4TAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GN118z3T23kP4mws3+YUbdnA7tLcWpHgCbFYQ4eudI6z/BBW8zx6eVvW8ojtuReGD1aQFR+SVd9lM8PeSmpTBRo8zEuOHZq8GC9h4ul37MDaJgRnt91jpFnZy4It2NDTDUZXr7ohf9wqNihbpu8mbLGTLYP+q0QG0kfvx7C1kK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XPPNKB8n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XPPNKB8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBCDD1F000FF;
	Sat, 12 Sep 2026 13:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218528;
	bh=mbUA1D+8ZSpKGN4USNQfcrDHoRQ1HxY7ANqTke7ZZy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XPPNKB8nceWBCMdMcvztZmW6lFlet6j9wQkSUlC8/2adQjBLyLQzIcDW/jQRESbW6
	 JD+4lpaqztoc1KSR1F8jBASwMR80nEchcImUGXXb+HWIgl/HQmd+fuOEvOyFQOvA94
	 Mobue7nDEHrDJP3HWwkmCZXXpaQVGJNCWVpjDVTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+643a6dd130546afdf1fb@syzkaller.appspotmail.com,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1156/1376] null_blk: serialize configfs attribute updates with device setup
Date: Sat, 12 Sep 2026 08:59:42 +0200
Message-ID: <20260912065633.318814527@linuxfoundation.org>
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
index 671bd6729fa7b..a0086307b4606 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -336,7 +336,15 @@ static ssize_t nullb_device_bool_attr_store(bool *val, const char *page,
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
@@ -376,6 +384,8 @@ static int nullb_update_nr_hw_queues(struct nullb_device *dev,
 	struct blk_mq_tag_set *set;
 	int ret, nr_hw_queues;
 
+	lockdep_assert_held(&lock);
+
 	if (!dev->nullb)
 		return 0;
 
@@ -2158,8 +2168,6 @@ static void __exit null_exit(void)
 
 	if (tag_set.ops)
 		blk_mq_free_tag_set(&tag_set);
-
-	mutex_destroy(&lock);
 }
 
 module_init(null_init);
-- 
2.53.0



