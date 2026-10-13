Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8515E4F30F8;
	Tue, 13 Oct 2026 12:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893346; cv=none; b=NS0fDeRr8u14toFYToON7OH0TbCjEnjMZc53p6co3u7T1HnvU9O/1YKkBtiDB2U6D9hD0zBDHXK+P5bUtsRLOGjdcmbLhCOXLPwY7sAv2yxDTbNrKHHEv+ddIobWVmcs7GckGHDqhEOhkYil+HaVHN89Dtqf0kssHwmVrz1EoGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893346; c=relaxed/simple;
	bh=/SMW0FQbQbKLcjLo1FnnP50Van9k7d+E+9eZHPDPX5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHNDUNwTqRbbiGsAKUVTapgpb3bJR2igq9ATQlIyz/SedQplWJoENcuf+UYXaqaDeT9cIjBMdWB70xy9u4rSYCRFOjJrVD6G+WPUFP8zsILxJwC+1b3gTC3e1UdPx7PZrZi0/G/JwcNp55L8B7gO2dwQnff2kCvNeiVayerIfuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCmNUUaZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCmNUUaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5341F000FF;
	Tue, 13 Oct 2026 12:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893345;
	bh=0NG4pv7gYe1sEEZ+FxTu19z+L6eraKZ7KDzvjkaROyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wCmNUUaZT/rQdyUkSXFwjrtafuSuRS3EBIDWIkjM70d18OdlfNuAR1V2WhSzD7zT0
	 XwOBUV2wdxWRbHapNBQ0k3B1PlzRKJ0p84JFsTVPQnCelgarmz8FR197DmEBjKk0MW
	 8xi/fCzF5JkyskODqo3XciVPp+jutDf+dHnTr5Cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 194/621] gfs2: Asynchronous withdraw
Date: Tue, 13 Oct 2026 13:33:09 +0200
Message-ID: <20261013112925.466373294@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 9c4a3de6cd5b46aa743c460b86eb58fe5f93daec ]

So far, withdraws are carried out in the context of the calling task.
When another task tries to withdraw while a withdraw is already
underway, that task blocks as well.  Change that to carry out withdraws
asynchronously in workqueue context and don't block the task triggering
the withdraw anymore.

Fixes: syzbot+6b156e132970e550194c@syzkaller.appspotmail.com
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: da6f5bbc2e79 ("gfs2: fix memory leaks in gfs2_fill_super error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/incore.h     |  1 +
 fs/gfs2/ops_fstype.c |  2 ++
 fs/gfs2/super.c      |  2 +-
 fs/gfs2/util.c       | 55 +++++++++++++++++++++++++-------------------
 fs/gfs2/util.h       |  2 ++
 5 files changed, 37 insertions(+), 25 deletions(-)

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 5a0ea416cfdae..db0e72adb9996 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -716,6 +716,7 @@ struct gfs2_sbd {
 	struct gfs2_glock *sd_rename_gl;
 	struct gfs2_glock *sd_freeze_gl;
 	struct work_struct sd_freeze_work;
+	struct work_struct sd_withdraw_work;
 	wait_queue_head_t sd_kill_wait;
 	wait_queue_head_t sd_async_glock_wait;
 	atomic_t sd_glock_disposal;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index f748d320fa148..c42982bdd4b20 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1215,6 +1215,8 @@ static int gfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (error)
 		goto fail_debug;
 
+	INIT_WORK(&sdp->sd_withdraw_work, gfs2_withdraw_func);
+
 	error = init_locking(sdp, &mount_gh, DO);
 	if (error)
 		goto fail_lm;
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 7b5fcd78a3a1a..3985da448a41d 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -603,7 +603,7 @@ static void gfs2_put_super(struct super_block *sb)
 		gfs2_quota_cleanup(sdp);
 	}
 
-	WARN_ON(gfs2_withdrawing(sdp));
+	flush_work(&sdp->sd_withdraw_work);
 
 	/*  At this point, we're through modifying the disk  */
 
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 27fdcbce2d754..c454bea101dec 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -309,43 +309,50 @@ void gfs2_lm(struct gfs2_sbd *sdp, const char *fmt, ...)
 	va_end(args);
 }
 
-void gfs2_withdraw(struct gfs2_sbd *sdp)
+void gfs2_withdraw_func(struct work_struct *work)
 {
+	struct gfs2_sbd *sdp = container_of(work, struct gfs2_sbd, sd_withdraw_work);
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
 	const struct lm_lockops *lm = ls->ls_ops;
 
+	if (test_bit(SDF_KILL, &sdp->sd_flags))
+		return;
+
+	BUG_ON(sdp->sd_args.ar_debug);
+
+	signal_our_withdraw(sdp);
+
+	kobject_uevent(&sdp->sd_kobj, KOBJ_OFFLINE);
+
+	if (!strcmp(sdp->sd_lockstruct.ls_ops->lm_proto_name, "lock_dlm"))
+		wait_for_completion(&sdp->sd_wdack);
+
+	if (lm->lm_unmount)
+		lm->lm_unmount(sdp, false);
+	fs_err(sdp, "file system withdrawn\n");
+	clear_bit(SDF_WITHDRAW_IN_PROG, &sdp->sd_flags);
+}
+
+void gfs2_withdraw(struct gfs2_sbd *sdp)
+{
 	if (sdp->sd_args.ar_errors == GFS2_ERRORS_WITHDRAW) {
 		unsigned long old = READ_ONCE(sdp->sd_flags), new;
 
 		do {
-			if (old & BIT(SDF_WITHDRAWN)) {
-				wait_on_bit(&sdp->sd_flags,
-					    SDF_WITHDRAW_IN_PROG,
-					    TASK_UNINTERRUPTIBLE);
+			if (old & BIT(SDF_WITHDRAWN))
 				return;
-			}
 			new = old | BIT(SDF_WITHDRAWN) | BIT(SDF_WITHDRAW_IN_PROG);
 		} while (unlikely(!try_cmpxchg(&sdp->sd_flags, &old, new)));
 
-		fs_err(sdp, "about to withdraw this file system\n");
-		BUG_ON(sdp->sd_args.ar_debug);
-
-		signal_our_withdraw(sdp);
-
-		kobject_uevent(&sdp->sd_kobj, KOBJ_OFFLINE);
-
-		if (!strcmp(sdp->sd_lockstruct.ls_ops->lm_proto_name, "lock_dlm"))
-			wait_for_completion(&sdp->sd_wdack);
-
-		if (lm->lm_unmount) {
-			fs_err(sdp, "telling LM to unmount\n");
-			lm->lm_unmount(sdp, false);
-		}
-		fs_err(sdp, "File system withdrawn\n");
 		dump_stack();
-		clear_bit(SDF_WITHDRAW_IN_PROG, &sdp->sd_flags);
-		smp_mb__after_atomic();
-		wake_up_bit(&sdp->sd_flags, SDF_WITHDRAW_IN_PROG);
+		/*
+		 * There is no need to withdraw when the superblock hasn't been
+		 * fully initialized, yet.
+		 */
+		if (!(sdp->sd_vfs->s_flags & SB_BORN))
+			return;
+		fs_err(sdp, "about to withdraw this file system\n");
+		schedule_work(&sdp->sd_withdraw_work);
 	}
 
 	if (sdp->sd_args.ar_errors == GFS2_ERRORS_PANIC)
diff --git a/fs/gfs2/util.h b/fs/gfs2/util.h
index da0373b1e82b9..f424ef2523c43 100644
--- a/fs/gfs2/util.h
+++ b/fs/gfs2/util.h
@@ -232,6 +232,8 @@ gfs2_tune_get_i(&(sdp)->sd_tune, &(sdp)->sd_tune.field)
 
 __printf(2, 3)
 void gfs2_lm(struct gfs2_sbd *sdp, const char *fmt, ...);
+
+void gfs2_withdraw_func(struct work_struct *work);
 void gfs2_withdraw(struct gfs2_sbd *sdp);
 
 #endif /* __UTIL_DOT_H__ */
-- 
2.53.0



