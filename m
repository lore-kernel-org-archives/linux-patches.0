Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A658E3A5E7D;
	Sat, 17 Oct 2026 17:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258273; cv=none; b=ZOxsCpjB+ECIIbixE+T7Bi7MffRnG/56edVkj1kLmz96F0k2Gmy2LT1qE0nzCfCK9HqpDcoNOnAhC03VxMaCd9LOa00BomSPZsZq3SruODNWiNOUTB+zr6pHTyqOH3BF3uHrCc53ISFdtAs9cenULuBKCU4dnt8hnsE6pU2fCRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258273; c=relaxed/simple;
	bh=7qWtpK+48pHEkMuRN558Rt34VC5Pky8zyjB181vflXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PV6sxQA8PXQhtne4xAuKXqjH+ItriPy+rYjHwZmNyZtQQ34N1WilOb/soE100r7BPQz56vpnHklI8bPGWc0S24W34FHNz3QkROqfLFW9elqrCXDOFIDwwqJ+GuTY2FbPcI9Wec9OKk22Kk8Ao9jn2cZcTebKv2erEKmYZZjqeEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0iSUGYI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0iSUGYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023321F000C4;
	Sat, 17 Oct 2026 17:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258271;
	bh=7mZQqz8onhLirxfWax5VICmztJlbC1KNpXsTNGo9RKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l0iSUGYIncrpOOpIF53V7IetkuTiUDMgaG1gFu1bFPIQke8q4rH/HZACGLfx3cBbN
	 aCo8nInY19qGmCSB/tntB51W0h+pQCkyLxLtVM6y9hMD0xZ1BBihiDN9TJGFV8vGp9
	 AwrTLH3TneQtCQBRGrNBJ1FQFn1RNSAyrCMDQgww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0828/1674] md: fix stopping sync thread
Date: Sat, 17 Oct 2026 17:51:40 +0200
Message-ID: <20261017160452.379518849@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit f52f5c71f3d4bb0992800139d2f35cf9f6f6e0ee ]

Currently sync thread is stopped from multiple contex:
 - idle_sync_thread
 - frozen_sync_thread
 - __md_stop_writes
 - md_set_readonly
 - do_md_stop

And there are some problems:
1) sync_work is flushed while reconfig_mutex is grabbed, this can
   deadlock because the work function will grab reconfig_mutex as well.
2) md_reap_sync_thread() can't be called directly while md_do_sync() is
   not finished yet, for example, commit 130443d60b1b ("md: refactor
   idle/frozen_sync_thread() to fix deadlock").
3) If MD_RECOVERY_RUNNING is not set, there is no need to stop
   sync_thread at all because sync_thread must not be registered.

Factor out a helper stop_sync_thread(), so that above contex will behave
the same. Fix 1) by flushing sync_work after reconfig_mutex is released,
before waiting for sync_thread to be done; Fix 2) bt letting daemon thread
to unregister sync_thread; Fix 3) by always checking MD_RECOVERY_RUNNING
first.

Fixes: db5e653d7c9f ("md: delay choosing sync action to md_start_sync()")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20231205094215.1824240-4-yukuai1@huaweicloud.com
Stable-dep-of: 0dc76205549b ("md: fix rcu protection in md_wakeup_thread")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 90 ++++++++++++++++++++-----------------------------
 1 file changed, 37 insertions(+), 53 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3c605ba3801aa..4b2acf648d767 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4832,25 +4832,29 @@ action_show(struct mddev *mddev, char *page)
 	return sprintf(page, "%s\n", type);
 }
 
-static void stop_sync_thread(struct mddev *mddev)
+/**
+ * stop_sync_thread() - wait for sync_thread to stop if it's running.
+ * @mddev:	the array.
+ * @locked:	if set, reconfig_mutex will still be held after this function
+ *		return; if not set, reconfig_mutex will be released after this
+ *		function return.
+ * @check_seq:	if set, only wait for curent running sync_thread to stop, noted
+ *		that new sync_thread can still start.
+ */
+static void stop_sync_thread(struct mddev *mddev, bool locked, bool check_seq)
 {
-	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
-		return;
+	int sync_seq;
 
-	if (mddev_lock(mddev))
-		return;
+	if (check_seq)
+		sync_seq = atomic_read(&mddev->sync_seq);
 
-	/*
-	 * Check again in case MD_RECOVERY_RUNNING is cleared before lock is
-	 * held.
-	 */
 	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
-		mddev_unlock(mddev);
+		if (!locked)
+			mddev_unlock(mddev);
 		return;
 	}
 
-	if (work_pending(&mddev->sync_work))
-		flush_workqueue(md_misc_wq);
+	mddev_unlock(mddev);
 
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	/*
@@ -4858,21 +4862,28 @@ static void stop_sync_thread(struct mddev *mddev)
 	 * never happen
 	 */
 	md_wakeup_thread_directly(mddev->sync_thread);
+	if (work_pending(&mddev->sync_work))
+		flush_work(&mddev->sync_work);
 
-	mddev_unlock(mddev);
+	wait_event(resync_wait,
+		   !test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
+		   (check_seq && sync_seq != atomic_read(&mddev->sync_seq)));
+
+	if (locked)
+		mddev_lock_nointr(mddev);
 }
 
 static void idle_sync_thread(struct mddev *mddev)
 {
-	int sync_seq = atomic_read(&mddev->sync_seq);
-
 	mutex_lock(&mddev->sync_mutex);
 	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-	stop_sync_thread(mddev);
 
-	wait_event(resync_wait, sync_seq != atomic_read(&mddev->sync_seq) ||
-			!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery));
+	if (mddev_lock(mddev)) {
+		mutex_unlock(&mddev->sync_mutex);
+		return;
+	}
 
+	stop_sync_thread(mddev, false, true);
 	mutex_unlock(&mddev->sync_mutex);
 }
 
@@ -4880,11 +4891,13 @@ static void frozen_sync_thread(struct mddev *mddev)
 {
 	mutex_lock(&mddev->sync_mutex);
 	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-	stop_sync_thread(mddev);
 
-	wait_event(resync_wait, mddev->sync_thread == NULL &&
-			!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery));
+	if (mddev_lock(mddev)) {
+		mutex_unlock(&mddev->sync_mutex);
+		return;
+	}
 
+	stop_sync_thread(mddev, false, false);
 	mutex_unlock(&mddev->sync_mutex);
 }
 
@@ -6305,14 +6318,7 @@ static void md_clean(struct mddev *mddev)
 
 static void __md_stop_writes(struct mddev *mddev)
 {
-	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-	if (work_pending(&mddev->sync_work))
-		flush_workqueue(md_misc_wq);
-	if (mddev->sync_thread) {
-		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-		md_reap_sync_thread(mddev);
-	}
-
+	stop_sync_thread(mddev, true, false);
 	del_timer_sync(&mddev->safemode_timer);
 
 	if (mddev->pers && mddev->pers->quiesce) {
@@ -6406,18 +6412,8 @@ static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
 		set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 		md_wakeup_thread(mddev->thread);
 	}
-	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
-		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-
-	/*
-	 * Thread might be blocked waiting for metadata update which will now
-	 * never happen
-	 */
-	md_wakeup_thread_directly(mddev->sync_thread);
 
-	mddev_unlock(mddev);
-	wait_event(resync_wait, !test_bit(MD_RECOVERY_RUNNING,
-					  &mddev->recovery));
+	stop_sync_thread(mddev, false, false);
 	wait_event(mddev->sb_wait,
 		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
 	mddev_lock_nointr(mddev);
@@ -6471,20 +6467,8 @@ static int do_md_stop(struct mddev *mddev, int mode,
 		set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 		md_wakeup_thread(mddev->thread);
 	}
-	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
-		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 
-	/*
-	 * Thread might be blocked waiting for metadata update which will now
-	 * never happen
-	 */
-	md_wakeup_thread_directly(mddev->sync_thread);
-
-	mddev_unlock(mddev);
-	wait_event(resync_wait, (mddev->sync_thread == NULL &&
-				 !test_bit(MD_RECOVERY_RUNNING,
-					   &mddev->recovery)));
-	mddev_lock_nointr(mddev);
+	stop_sync_thread(mddev, true, false);
 
 	mutex_lock(&mddev->open_mutex);
 	if ((mddev->pers && atomic_read(&mddev->openers) > !!bdev) ||
-- 
2.53.0



