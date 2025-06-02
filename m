Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBD4221F3E;
	Mon,  2 Jun 2025 14:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875325; cv=none; b=h6bhGtgN2u/4bcQQvfQ9NM2QeZYGpd4C+khwkp0K8jQIJzdQmD7yoz7kuq4Mygn16S5apjuxCmpFMk+pl4kdlijQlV7SnubOKjGwC+oaLaXMUDxv26XK4ihXTasFC1/EqfKC9GFS/ny1oACnQQYISvSaJItzYHzUWFH25ny6iKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875325; c=relaxed/simple;
	bh=8AtsrdtvGC6P77rTSx+r7B94Pm77wX38IE7mZPxsIgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvo3+U7W7kMCgbwYxXRbk7HwLd52URDn+VFX7NzAiE6cnwumnvlT/XZd/0NpaYzZdm0KUrVCOvZPxVbHP0sv7q8B0JavdfNvQX+YjpdXh7ddPfo5FSpzE8MnuE81A2NEy8uu8DwOzo5XI3s8x9wwNDNOFKnSPh1rde2K4tpei4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uSf0qnJ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uSf0qnJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7957CC4CEEB;
	Mon,  2 Jun 2025 14:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875325;
	bh=8AtsrdtvGC6P77rTSx+r7B94Pm77wX38IE7mZPxsIgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uSf0qnJ59+5uUbGt538siBLerDkRUZd98baSAP4MhvDJ/ZjFCPrAZLBMxRvq2gUUc
	 +XgiAOj/eCC1XVicWlsuIlR3bgON4ag0OAK6OFzfjekFCz42iVJTPqw1SZ8ZnBtuXh
	 goccRBLIg4Ri/grjKYWjhWb3phLSX4Z363luYZxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Shichangkuo <shi.changkuo@h3c.com>,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Heming Zhao <heming.zhao@suse.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Changwei Ge <gechangwei@live.cn>,
	Joel Becker <jlbec@evilplan.org>,
	Jun Piao <piaojun@huawei.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Mark Fasheh <mark@fasheh.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 068/270] ocfs2: stop quota recovery before disabling quotas
Date: Mon,  2 Jun 2025 15:45:53 +0200
Message-ID: <20250602134309.969462680@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit fcaf3b2683b05a9684acdebda706a12025a6927a upstream.

Currently quota recovery is synchronized with unmount using sb->s_umount
semaphore.  That is however prone to deadlocks because
flush_workqueue(osb->ocfs2_wq) called from umount code can wait for quota
recovery to complete while ocfs2_finish_quota_recovery() waits for
sb->s_umount semaphore.

Grabbing of sb->s_umount semaphore in ocfs2_finish_quota_recovery() is
only needed to protect that function from disabling of quotas from
ocfs2_dismount_volume().  Handle this problem by disabling quota recovery
early during unmount in ocfs2_dismount_volume() instead so that we can
drop acquisition of sb->s_umount from ocfs2_finish_quota_recovery().

Link: https://lkml.kernel.org/r/20250424134515.18933-6-jack@suse.cz
Fixes: 5f530de63cfc ("ocfs2: Use s_umount for quota recovery protection")
Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Shichangkuo <shi.changkuo@h3c.com>
Reported-by: Murad Masimov <m.masimov@mt-integration.ru>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Tested-by: Heming Zhao <heming.zhao@suse.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/journal.c     |   20 ++++++++++++++++++--
 fs/ocfs2/journal.h     |    1 +
 fs/ocfs2/ocfs2.h       |    6 ++++++
 fs/ocfs2/quota_local.c |    9 ++-------
 fs/ocfs2/super.c       |    3 +++
 5 files changed, 30 insertions(+), 9 deletions(-)

--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -229,6 +229,11 @@ out_lock:
 		flush_workqueue(osb->ocfs2_wq);
 }
 
+void ocfs2_recovery_disable_quota(struct ocfs2_super *osb)
+{
+	ocfs2_recovery_disable(osb, OCFS2_REC_QUOTA_WANT_DISABLE);
+}
+
 void ocfs2_recovery_exit(struct ocfs2_super *osb)
 {
 	struct ocfs2_recovery_map *rm;
@@ -1429,6 +1434,18 @@ static int __ocfs2_recovery_thread(void
 		}
 	}
 restart:
+	if (quota_enabled) {
+		mutex_lock(&osb->recovery_lock);
+		/* Confirm that recovery thread will no longer recover quotas */
+		if (osb->recovery_state == OCFS2_REC_QUOTA_WANT_DISABLE) {
+			osb->recovery_state = OCFS2_REC_QUOTA_DISABLED;
+			wake_up(&osb->recovery_event);
+		}
+		if (osb->recovery_state >= OCFS2_REC_QUOTA_DISABLED)
+			quota_enabled = 0;
+		mutex_unlock(&osb->recovery_lock);
+	}
+
 	status = ocfs2_super_lock(osb, 1);
 	if (status < 0) {
 		mlog_errno(status);
@@ -1532,8 +1549,7 @@ bail:
 
 	mutex_unlock(&osb->recovery_lock);
 
-	if (quota_enabled)
-		kfree(rm_quota);
+	kfree(rm_quota);
 
 	/* no one is callint kthread_stop() for us so the kthread() api
 	 * requires that we call do_exit().  And it isn't exported, but
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -150,6 +150,7 @@ void ocfs2_wait_for_recovery(struct ocfs
 
 int ocfs2_recovery_init(struct ocfs2_super *osb);
 void ocfs2_recovery_exit(struct ocfs2_super *osb);
+void ocfs2_recovery_disable_quota(struct ocfs2_super *osb);
 
 int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
 void ocfs2_free_replay_slots(struct ocfs2_super *osb);
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -288,6 +288,12 @@ enum ocfs2_mount_options
 
 enum ocfs2_recovery_state {
 	OCFS2_REC_ENABLED = 0,
+	OCFS2_REC_QUOTA_WANT_DISABLE,
+	/*
+	 * Must be OCFS2_REC_QUOTA_WANT_DISABLE + 1 for
+	 * ocfs2_recovery_disable_quota() to work.
+	 */
+	OCFS2_REC_QUOTA_DISABLED,
 	OCFS2_REC_WANT_DISABLE,
 	/*
 	 * Must be OCFS2_REC_WANT_DISABLE + 1 for ocfs2_recovery_exit() to work
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -453,8 +453,7 @@ out:
 
 /* Sync changes in local quota file into global quota file and
  * reinitialize local quota file.
- * The function expects local quota file to be already locked and
- * s_umount locked in shared mode. */
+ * The function expects local quota file to be already locked. */
 static int ocfs2_recover_local_quota_file(struct inode *lqinode,
 					  int type,
 					  struct ocfs2_quota_recovery *rec)
@@ -585,7 +584,6 @@ int ocfs2_finish_quota_recovery(struct o
 {
 	unsigned int ino[OCFS2_MAXQUOTAS] = { LOCAL_USER_QUOTA_SYSTEM_INODE,
 					      LOCAL_GROUP_QUOTA_SYSTEM_INODE };
-	struct super_block *sb = osb->sb;
 	struct ocfs2_local_disk_dqinfo *ldinfo;
 	struct buffer_head *bh;
 	handle_t *handle;
@@ -597,7 +595,6 @@ int ocfs2_finish_quota_recovery(struct o
 	printk(KERN_NOTICE "ocfs2: Finishing quota recovery on device (%s) for "
 	       "slot %u\n", osb->dev_str, slot_num);
 
-	down_read(&sb->s_umount);
 	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
 		if (list_empty(&(rec->r_list[type])))
 			continue;
@@ -674,7 +671,6 @@ out_put:
 			break;
 	}
 out:
-	up_read(&sb->s_umount);
 	kfree(rec);
 	return status;
 }
@@ -840,8 +836,7 @@ static int ocfs2_local_free_info(struct
 	ocfs2_release_local_quota_bitmaps(&oinfo->dqi_chunk);
 
 	/*
-	 * s_umount held in exclusive mode protects us against racing with
-	 * recovery thread...
+	 * ocfs2_dismount_volume() has already aborted quota recovery...
 	 */
 	if (oinfo->dqi_rec) {
 		ocfs2_free_quota_recovery(oinfo->dqi_rec);
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1876,6 +1876,9 @@ static void ocfs2_dismount_volume(struct
 	/* Orphan scan should be stopped as early as possible */
 	ocfs2_orphan_scan_stop(osb);
 
+	/* Stop quota recovery so that we can disable quotas */
+	ocfs2_recovery_disable_quota(osb);
+
 	ocfs2_disable_quotas(osb);
 
 	/* All dquots should be freed by now */


