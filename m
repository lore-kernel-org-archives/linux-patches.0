Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A755646EF62;
	Sat, 12 Sep 2026 10:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210279; cv=none; b=Km83YZm2r9La1UggKcGfLz6jB5CZIleVt/lSbdHvePgU2zPTae+6fz1ySAPa9EXRGfuTBM8/k2GhicHS0XiZvsIDg7SIMCbpIt//CliYcU6lPQ0cTVxULs5e1xXlYkatZTXtYTuipElx7rYdT3VS3nMO+wTODdRa+BFL8D2dBwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210279; c=relaxed/simple;
	bh=aVsXpLEnPlvBsDZHza9ufK8zxyis0efLuGjwik7XD1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XY3LCeR3zk0vxMtuL26IGC+atep4ZlyxJ7OGI+KHxrVLBS46tBi7rA7AdJxuNb4Ap0XxdCwvG1knfbdnsD7k8TTJBF6vEKjoXTEcjde7aq/6QmhktUQHAGd5/ZVOXu7IgIIi3GrKbOHCg3VXplCVko5v6Cmzf9s0ZxIgvEiqhwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWBydATO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWBydATO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608861F000FF;
	Sat, 12 Sep 2026 10:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210277;
	bh=PfYgDuGsPk9q41kknY3Uy6ot8REmjvQrZIe2fUTtqYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yWBydATOZep2nNclRtJ+WhKmavPB/gpOsT0jAhZ6WXc6eVj5E5yp86ch7PNSMLIav
	 4EKbveTiUtXjdwjhvKJytZgMzQMK53i9Y30IKsailHaBSIolPWfEVcNz4so6S2x340
	 i3k1Q2/jKedCawSFhDmFku+S8cCs975pEIuqZL5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykola Marzhan <mykola@meshstor.io>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0966/1518] md/md-llbitmap: stop daemon timer rearm on destroy
Date: Sat, 12 Sep 2026 08:52:15 +0200
Message-ID: <20260912065645.313233032@linuxfoundation.org>
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

From: Yu Kuai <yukuai@fygo.io>

[ Upstream commit 5553d64e01d9a995be6c3de38501c6dd4ceede3b ]

llbitmap_destroy() deletes pending_timer before flushing
md_llbitmap_io_wq. However, daemon_work can still be queued or running
after the timer has been deleted, and the daemon path can arm
pending_timer again when it finds dirty chunks that are not ready to
flush yet.

If that happens during teardown, pending_timer can remain armed after
llbitmap is freed and later dereference freed memory.

Add a BITMAP_SHUTDOWN bit to llbitmap->flags, set it before deleting
the timer, and make the timer and daemon paths stop queueing or rearming
work once teardown starts. Cancel daemon_work before flushing the shared
workqueue so no already queued daemon instance can race with the free.
Use timer_shutdown_sync() so a daemon instance that passed the shutdown
check before teardown cannot rearm the timer afterward.

BITMAP_SHUTDOWN is a runtime-only state. Mask it out when reading and
updating the llbitmap superblock so the shutdown state is never loaded
from disk or persisted to disk.

Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
Tested-by: Mykola Marzhan <mykola@meshstor.io>
Link: https://patch.msgid.link/20260802195038.164272-10-yukuai@kernel.org
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.h   |  1 +
 drivers/md/md-llbitmap.c | 17 +++++++++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index f46674bdfeb91..7535742982fc0 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -29,6 +29,7 @@ enum bitmap_state {
 	BITMAP_FIRST_USE   = 3, /* llbitmap is just created */
 	BITMAP_CLEAN       = 4, /* llbitmap is created with assume_clean */
 	BITMAP_DAEMON_BUSY = 5, /* llbitmap daemon is not finished after daemon_sleep */
+	BITMAP_SHUTDOWN    = 6, /* llbitmap is being destroyed */
 	BITMAP_HOSTENDIAN  =15,
 };
 
diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index b4738fe6e2463..5c60b26ad2468 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -662,6 +662,7 @@ static enum llbitmap_state llbitmap_state_machine(struct llbitmap *llbitmap,
 		if (state == BitNeedSync)
 			need_resync = !mddev->degraded;
 		else if (state == BitDirty &&
+			 !test_bit(BITMAP_SHUTDOWN, &llbitmap->flags) &&
 			 !timer_pending(&llbitmap->pending_timer))
 			mod_timer(&llbitmap->pending_timer,
 				  jiffies + mddev->bitmap_info.daemon_sleep * HZ);
@@ -854,7 +855,7 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 		else
 			mddev->bitmap_info.space = mddev->bitmap_info.default_space;
 	}
-	llbitmap->flags = le32_to_cpu(sb->state);
+	llbitmap->flags = le32_to_cpu(sb->state) & ~BIT(BITMAP_SHUTDOWN);
 	if (test_and_clear_bit(BITMAP_FIRST_USE, &llbitmap->flags)) {
 		ret = llbitmap_init(llbitmap);
 		goto out_put_page;
@@ -910,6 +911,9 @@ static void llbitmap_pending_timer_fn(struct timer_list *pending_timer)
 	struct llbitmap *llbitmap =
 		container_of(pending_timer, struct llbitmap, pending_timer);
 
+	if (test_bit(BITMAP_SHUTDOWN, &llbitmap->flags))
+		return;
+
 	if (work_busy(&llbitmap->daemon_work)) {
 		pr_warn("md/llbitmap: %s daemon_work not finished in %lu seconds\n",
 			mdname(llbitmap->mddev),
@@ -930,6 +934,9 @@ static void md_llbitmap_daemon_fn(struct work_struct *work)
 	bool restart;
 	int idx;
 
+	if (test_bit(BITMAP_SHUTDOWN, &llbitmap->flags))
+		return;
+
 	if (llbitmap->mddev->degraded)
 		return;
 retry:
@@ -969,7 +976,7 @@ static void md_llbitmap_daemon_fn(struct work_struct *work)
 		goto retry;
 
 	/* If some page is dirty but not expired, setup timer again */
-	if (restart)
+	if (restart && !test_bit(BITMAP_SHUTDOWN, &llbitmap->flags))
 		mod_timer(&llbitmap->pending_timer,
 			  jiffies + llbitmap->mddev->bitmap_info.daemon_sleep * HZ);
 }
@@ -1052,7 +1059,9 @@ static void llbitmap_destroy(struct mddev *mddev)
 
 	mutex_lock(&mddev->bitmap_info.mutex);
 
-	timer_delete_sync(&llbitmap->pending_timer);
+	set_bit(BITMAP_SHUTDOWN, &llbitmap->flags);
+	timer_shutdown_sync(&llbitmap->pending_timer);
+	cancel_work_sync(&llbitmap->daemon_work);
 	flush_workqueue(md_llbitmap_io_wq);
 	flush_workqueue(md_llbitmap_unplug_wq);
 
@@ -1376,7 +1385,7 @@ static void llbitmap_update_sb(void *data)
 
 	sb = kmap_local_page(sb_page);
 	sb->events = cpu_to_le64(mddev->events);
-	sb->state = cpu_to_le32(llbitmap->flags);
+	sb->state = cpu_to_le32(llbitmap->flags & ~BIT(BITMAP_SHUTDOWN));
 	sb->chunksize = cpu_to_le32(llbitmap->chunksize);
 	sb->sync_size = cpu_to_le64(mddev->resync_max_sectors);
 	sb->events_cleared = cpu_to_le64(llbitmap->events_cleared);
-- 
2.53.0



