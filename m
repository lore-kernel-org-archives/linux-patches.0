Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3A23BFAF7;
	Sat, 17 Oct 2026 17:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258396; cv=none; b=H8SNtf05CHNhnX8WW28oGgq8QdxidcmEZhE8PIJnxD8fbciOUouTjZOCkmrv9OK/Wd6mVQjj1Pa9LN0IpCWnTT8+etHdVNpcnisWprLDQbcbsNxG99+UaziQdnxln1rgr0kFf6ST4kNuviwhKfGaIH8shWd4OCcfW2HAgdqDjSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258396; c=relaxed/simple;
	bh=Pj+j1jPtrE8yHv+dzoEZgcVOdChb+ZyRQkaLocmU/nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mm/dNUod66Sa8V3tLBc1P3U2a1+LVK3muycBVaxy8Zkpb0P6ayTWTMuzWcpYVGkro2HKn7u+cm12oghUDUwPrj2SDUsncY3MMKRxZ2NA/sUOtRnMiuHjYUtUuRiZ7RwQwYp2K5zm9Fr37257td49cxr8zs38u7hV7lBAGLHn588=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1kce0dw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1kce0dw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A73E1F000C6;
	Sat, 17 Oct 2026 17:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258394;
	bh=vtxjwtLnnkWA9GYpgOMCes8CauZ5DVXrny0WJe8/ays=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r1kce0dw7Mnvc45JTZLtzlU3lL/4YB6cAVfNpe86YBIs5jxq+2N+ys/XeT71qoC8O
	 Twh6I4a78M+S/UGFHLQf8eJxeEPz53NbjmI9QCXnjjS4P+QTWYbFAQbmxxRxAuoUrb
	 bKvguagclYBOW5jxYL+SgJ+8iwwbMax6PNsu/sH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0843/1674] md: add new helpers to suspend/resume array
Date: Sat, 17 Oct 2026 17:51:55 +0200
Message-ID: <20261017160452.766100152@linuxfoundation.org>
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

[ Upstream commit 714d20150ed85811193ae07a494d91f9927c590f ]

Advantages for new apis:
 - reconfig_mutex is not required;
 - the weird logical that suspend array hold 'reconfig_mutex' for
   mddev_check_recovery() to update superblock is not needed;
 - the specail handling, 'pers->prepare_suspend', for raid456 is not
   needed;
 - It's safe to be called at any time once mddev is allocated, and it's
   designed to be used from slow path where array configuration is changed;
 - the new helpers is designed to be called before mddev_lock(), hence
   it support to be interrupted by user as well.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20231010151958.145896-5-yukuai1@huaweicloud.com
Stable-dep-of: 2cc583653bbe ("md: suspend array while updating raid_disks via sysfs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 102 +++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/md.h |   3 ++
 2 files changed, 103 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5e13891d85139..f4d9defee5d04 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -443,12 +443,22 @@ void mddev_suspend(struct mddev *mddev)
 			lockdep_is_held(&mddev->reconfig_mutex));
 
 	WARN_ON_ONCE(thread && current == thread->tsk);
-	if (mddev->suspended++)
+
+	/* can't concurrent with __mddev_suspend() and __mddev_resume() */
+	mutex_lock(&mddev->suspend_mutex);
+	if (mddev->suspended++) {
+		mutex_unlock(&mddev->suspend_mutex);
 		return;
+	}
+
 	wake_up(&mddev->sb_wait);
 	set_bit(MD_ALLOW_SB_UPDATE, &mddev->flags);
 	percpu_ref_kill(&mddev->active_io);
 
+	/*
+	 * TODO: cleanup 'pers->prepare_suspend after all callers are replaced
+	 * by __mddev_suspend().
+	 */
 	if (mddev->pers && mddev->pers->prepare_suspend)
 		mddev->pers->prepare_suspend(mddev);
 
@@ -458,14 +468,21 @@ void mddev_suspend(struct mddev *mddev)
 
 	/* restrict memory reclaim I/O during raid array is suspend */
 	mddev->noio_flag = memalloc_noio_save();
+
+	mutex_unlock(&mddev->suspend_mutex);
 }
 EXPORT_SYMBOL_GPL(mddev_suspend);
 
 void mddev_resume(struct mddev *mddev)
 {
 	lockdep_assert_held(&mddev->reconfig_mutex);
-	if (--mddev->suspended)
+
+	/* can't concurrent with __mddev_suspend() and __mddev_resume() */
+	mutex_lock(&mddev->suspend_mutex);
+	if (--mddev->suspended) {
+		mutex_unlock(&mddev->suspend_mutex);
 		return;
+	}
 
 	/* entred the memalloc scope from mddev_suspend() */
 	memalloc_noio_restore(mddev->noio_flag);
@@ -476,9 +493,89 @@ void mddev_resume(struct mddev *mddev)
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
 	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
+
+	mutex_unlock(&mddev->suspend_mutex);
 }
 EXPORT_SYMBOL_GPL(mddev_resume);
 
+int __mddev_suspend(struct mddev *mddev, bool interruptible)
+{
+	int err = 0;
+
+	/*
+	 * hold reconfig_mutex to wait for normal io will deadlock, because
+	 * other context can't update super_block, and normal io can rely on
+	 * updating super_block.
+	 */
+	lockdep_assert_not_held(&mddev->reconfig_mutex);
+
+	if (interruptible)
+		err = mutex_lock_interruptible(&mddev->suspend_mutex);
+	else
+		mutex_lock(&mddev->suspend_mutex);
+	if (err)
+		return err;
+
+	if (mddev->suspended) {
+		WRITE_ONCE(mddev->suspended, mddev->suspended + 1);
+		mutex_unlock(&mddev->suspend_mutex);
+		return 0;
+	}
+
+	percpu_ref_kill(&mddev->active_io);
+	if (interruptible)
+		err = wait_event_interruptible(mddev->sb_wait,
+				percpu_ref_is_zero(&mddev->active_io));
+	else
+		wait_event(mddev->sb_wait,
+				percpu_ref_is_zero(&mddev->active_io));
+	if (err) {
+		percpu_ref_resurrect(&mddev->active_io);
+		mutex_unlock(&mddev->suspend_mutex);
+		return err;
+	}
+
+	/*
+	 * For raid456, io might be waiting for reshape to make progress,
+	 * allow new reshape to start while waiting for io to be done to
+	 * prevent deadlock.
+	 */
+	WRITE_ONCE(mddev->suspended, mddev->suspended + 1);
+
+	del_timer_sync(&mddev->safemode_timer);
+	/* restrict memory reclaim I/O during raid array is suspend */
+	mddev->noio_flag = memalloc_noio_save();
+
+	mutex_unlock(&mddev->suspend_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__mddev_suspend);
+
+void __mddev_resume(struct mddev *mddev)
+{
+	lockdep_assert_not_held(&mddev->reconfig_mutex);
+
+	mutex_lock(&mddev->suspend_mutex);
+	WRITE_ONCE(mddev->suspended, mddev->suspended - 1);
+	if (mddev->suspended) {
+		mutex_unlock(&mddev->suspend_mutex);
+		return;
+	}
+
+	/* entred the memalloc scope from __mddev_suspend() */
+	memalloc_noio_restore(mddev->noio_flag);
+
+	percpu_ref_resurrect(&mddev->active_io);
+	wake_up(&mddev->sb_wait);
+
+	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	md_wakeup_thread(mddev->thread);
+	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
+
+	mutex_unlock(&mddev->suspend_mutex);
+}
+EXPORT_SYMBOL_GPL(__mddev_resume);
+
 /*
  * Generic flush handling for md
  */
@@ -672,6 +769,7 @@ void mddev_init(struct mddev *mddev)
 	mutex_init(&mddev->open_mutex);
 	mutex_init(&mddev->reconfig_mutex);
 	mutex_init(&mddev->sync_mutex);
+	mutex_init(&mddev->suspend_mutex);
 	mutex_init(&mddev->bitmap_info.mutex);
 	INIT_LIST_HEAD(&mddev->disks);
 	INIT_LIST_HEAD(&mddev->all_mddevs);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 59f92aa48b37e..a487e5c0648b5 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -316,6 +316,7 @@ struct mddev {
 	unsigned long			sb_flags;
 
 	int				suspended;
+	struct mutex			suspend_mutex;
 	struct percpu_ref		active_io;
 	int				ro;
 	int				sysfs_active; /* set when sysfs deletes
@@ -822,6 +823,8 @@ extern void md_rdev_clear(struct md_rdev *rdev);
 extern void md_handle_request(struct mddev *mddev, struct bio *bio);
 extern void mddev_suspend(struct mddev *mddev);
 extern void mddev_resume(struct mddev *mddev);
+extern int __mddev_suspend(struct mddev *mddev, bool interruptible);
+extern void __mddev_resume(struct mddev *mddev);
 
 extern void md_reload_sb(struct mddev *mddev, int raid_disk);
 extern void md_update_sb(struct mddev *mddev, int force);
-- 
2.53.0



