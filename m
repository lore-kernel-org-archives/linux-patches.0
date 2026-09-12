Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2C0418A39;
	Sat, 12 Sep 2026 08:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202596; cv=none; b=NTiBUkz3G70r9WgCovLLnTq9kSQGzGvSPfiiP7sLGDGFCA9oLc/osEfFfs96yueWR2+ZorqM9hxcGKfApCmTOJl+v9iJIwBQ4k0do3nnz9N77EYRt+DVtSWS8YjdS7rZ26QNxlcRon587eEeijPBHm+sMl6Q2/xqqC6ZK3R33z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202596; c=relaxed/simple;
	bh=iTbBrKSADwPgcALW8pLWts+eFwQ4O+FOeVF7cP2adsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUAU7nN40rVhv3KVeueC95qre1JkmfUZUbn45p6BSGHWO36y7/7jK8wFHxMI2z9OQaSNMooVErTpQ0nCiri84q92L5GamGn+MH03+yc+7xy8WqUIS6cVK/BO69+fEVh1XmeZc+eU3dNJA17mNq9igahiUrLZZdYF4wXj1pm6quw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hr9E0aRi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hr9E0aRi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDEC1F000FF;
	Sat, 12 Sep 2026 08:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202594;
	bh=fliRtnhjubqsDsqLPzPPVTWWd/EteOsKdAy+PFJ48QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hr9E0aRiPZN5K67TWPOvHIrXJWmcbt+Dys8CXrMYwv9uLNOFZR1s/Q0eky8kAYtMi
	 mF9Z/UZtXQD1OOSH8mZfR+DsHbJxOqPogUDN7XITD5/gkQrphYALP7fmqF2m1uJUUH
	 t0T0iO/mtFy2MUG52cQd4r6eFCA0dxKikW73gbS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykola Marzhan <mykola@meshstor.io>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1192/1815] md/md-llbitmap: stop daemon timer rearm on destroy
Date: Sat, 12 Sep 2026 08:49:02 +0200
Message-ID: <20260912065716.994460418@linuxfoundation.org>
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
index 214f623c7e790..890276d9c66ef 100644
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
index 8e20a9c6fe27d..e0bc6c8c94592 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -789,6 +789,7 @@ static enum llbitmap_state llbitmap_state_machine(struct llbitmap *llbitmap,
 		if (state == BitNeedSync || state == BitNeedSyncUnwritten)
 			need_resync = !mddev->degraded;
 		else if (state == BitDirty &&
+			 !test_bit(BITMAP_SHUTDOWN, &llbitmap->flags) &&
 			 !timer_pending(&llbitmap->pending_timer))
 			mod_timer(&llbitmap->pending_timer,
 				  jiffies + mddev->bitmap_info.daemon_sleep * HZ);
@@ -981,7 +982,7 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 		else
 			mddev->bitmap_info.space = mddev->bitmap_info.default_space;
 	}
-	llbitmap->flags = le32_to_cpu(sb->state);
+	llbitmap->flags = le32_to_cpu(sb->state) & ~BIT(BITMAP_SHUTDOWN);
 	if (test_and_clear_bit(BITMAP_FIRST_USE, &llbitmap->flags)) {
 		ret = llbitmap_init(llbitmap);
 		goto out_put_page;
@@ -1037,6 +1038,9 @@ static void llbitmap_pending_timer_fn(struct timer_list *pending_timer)
 	struct llbitmap *llbitmap =
 		container_of(pending_timer, struct llbitmap, pending_timer);
 
+	if (test_bit(BITMAP_SHUTDOWN, &llbitmap->flags))
+		return;
+
 	if (work_busy(&llbitmap->daemon_work)) {
 		pr_warn("md/llbitmap: %s daemon_work not finished in %lu seconds\n",
 			mdname(llbitmap->mddev),
@@ -1057,6 +1061,9 @@ static void md_llbitmap_daemon_fn(struct work_struct *work)
 	bool restart;
 	int idx;
 
+	if (test_bit(BITMAP_SHUTDOWN, &llbitmap->flags))
+		return;
+
 	if (llbitmap->mddev->degraded)
 		return;
 retry:
@@ -1096,7 +1103,7 @@ static void md_llbitmap_daemon_fn(struct work_struct *work)
 		goto retry;
 
 	/* If some page is dirty but not expired, setup timer again */
-	if (restart)
+	if (restart && !test_bit(BITMAP_SHUTDOWN, &llbitmap->flags))
 		mod_timer(&llbitmap->pending_timer,
 			  jiffies + llbitmap->mddev->bitmap_info.daemon_sleep * HZ);
 }
@@ -1179,7 +1186,9 @@ static void llbitmap_destroy(struct mddev *mddev)
 
 	mutex_lock(&mddev->bitmap_info.mutex);
 
-	timer_delete_sync(&llbitmap->pending_timer);
+	set_bit(BITMAP_SHUTDOWN, &llbitmap->flags);
+	timer_shutdown_sync(&llbitmap->pending_timer);
+	cancel_work_sync(&llbitmap->daemon_work);
 	flush_workqueue(md_llbitmap_io_wq);
 	flush_workqueue(md_llbitmap_unplug_wq);
 
@@ -1518,7 +1527,7 @@ static void llbitmap_update_sb(void *data)
 
 	sb = kmap_local_page(sb_page);
 	sb->events = cpu_to_le64(mddev->events);
-	sb->state = cpu_to_le32(llbitmap->flags);
+	sb->state = cpu_to_le32(llbitmap->flags & ~BIT(BITMAP_SHUTDOWN));
 	sb->chunksize = cpu_to_le32(llbitmap->chunksize);
 	sb->sync_size = cpu_to_le64(mddev->resync_max_sectors);
 	sb->events_cleared = cpu_to_le64(llbitmap->events_cleared);
-- 
2.53.0



