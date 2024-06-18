Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CED153BD7;
	Tue, 18 Jun 2024 12:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715281; cv=none; b=By8FEZsJvf1latVgIneVHyr2tQUArVEw0oygMIoqcyhUh1qNLm8yDWOeMgG1NyG2vIKIP9+Y2DTV35n0ucQYgmKSsl7W6h9NryF+NUkMBI0m2+N9103jXz1QbfQlGkYRvzuhzaz8envmLNbsikkZBX2DwkGbtflhTy9hwC89WnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715281; c=relaxed/simple;
	bh=OLVy5qado8jLOvYdavBwF41rZgJrJJzKtcAf7lZExmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1u6YqoRhc/YL2Drt42X8NK1l2p9BhCW6IbhVyHbTittF7AL+81ELTq2B8k1GkaQTQJ1if3eTHfjrhW7Cp32t1b9pyluE/uOhpDwx3TPWR+GcH9OH0p44Dm/7MJZOg3cC5wxzKct+7dyqjmP8jAbwVJaiCTcyffaxC+oGeZUXH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PSqC5ycS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PSqC5ycS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EFAC3277B;
	Tue, 18 Jun 2024 12:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715280;
	bh=OLVy5qado8jLOvYdavBwF41rZgJrJJzKtcAf7lZExmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PSqC5ycSHvLCmdC8jCAy+hSZgpRtCD+xtIrPHf2oHriwO9HT9Jl2wLuUReb66WenW
	 +5zsYwMWdeW9ZhTEWKPofM0TdyOvD8Tec1WVHr6X0KktcEGlazQ56SKGXuUxMNxlDn
	 J+EVL+COKmq1U6Ljl5bYWLe2yujgK/sEeGYyLPr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 256/770] fanotify: support limited functionality for unprivileged users
Date: Tue, 18 Jun 2024 14:31:49 +0200
Message-ID: <20240618123417.157249008@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 7cea2a3c505e87a9d6afc78be4a7f7be636a73a7 ]

Add limited support for unprivileged fanotify groups.
An unprivileged users is not allowed to get an open file descriptor in
the event nor the process pid of another process.  An unprivileged user
cannot request permission events, cannot set mount/filesystem marks and
cannot request unlimited queue/marks.

This enables the limited functionality similar to inotify when watching a
set of files and directories for OPEN/ACCESS/MODIFY/CLOSE events, without
requiring SYS_CAP_ADMIN privileges.

The FAN_REPORT_DFID_NAME init flag, provide a method for an unprivileged
listener watching a set of directories (with FAN_EVENT_ON_CHILD) to monitor
all changes inside those directories.

This typically requires that the listener keeps a map of watched directory
fid to dirfd (O_PATH), where fid is obtained with name_to_handle_at()
before starting to watch for changes.

When getting an event, the reported fid of the parent should be resolved
to dirfd and fstatsat(2) with dirfd and name should be used to query the
state of the filesystem entry.

Link: https://lore.kernel.org/r/20210304112921.3996419-3-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 29 ++++++++++++++++++++++++--
 fs/notify/fdinfo.c                 |  3 ++-
 include/linux/fanotify.h           | 33 +++++++++++++++++++++++++-----
 3 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 74b4da6354e1c..842cccb4f7499 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -419,6 +419,14 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 	metadata.reserved = 0;
 	metadata.mask = event->mask & FANOTIFY_OUTGOING_EVENTS;
 	metadata.pid = pid_vnr(event->pid);
+	/*
+	 * For an unprivileged listener, event->pid can be used to identify the
+	 * events generated by the listener process itself, without disclosing
+	 * the pids of other processes.
+	 */
+	if (!capable(CAP_SYS_ADMIN) &&
+	    task_tgid(current) != event->pid)
+		metadata.pid = 0;
 
 	if (path && path->mnt && path->dentry) {
 		fd = create_fd(group, path, &f);
@@ -1036,8 +1044,16 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 	pr_debug("%s: flags=%x event_f_flags=%x\n",
 		 __func__, flags, event_f_flags);
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
+	if (!capable(CAP_SYS_ADMIN)) {
+		/*
+		 * An unprivileged user can setup an fanotify group with
+		 * limited functionality - an unprivileged group is limited to
+		 * notification events with file handles and it cannot use
+		 * unlimited queue/marks.
+		 */
+		if ((flags & FANOTIFY_ADMIN_INIT_FLAGS) || !fid_mode)
+			return -EPERM;
+	}
 
 #ifdef CONFIG_AUDITSYSCALL
 	if (flags & ~(FANOTIFY_INIT_FLAGS | FAN_ENABLE_AUDIT))
@@ -1306,6 +1322,15 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
 		goto fput_and_out;
 	group = f.file->private_data;
 
+	/*
+	 * An unprivileged user is not allowed to watch a mount point nor
+	 * a filesystem.
+	 */
+	ret = -EPERM;
+	if (!capable(CAP_SYS_ADMIN) &&
+	    mark_type != FAN_MARK_INODE)
+		goto fput_and_out;
+
 	/*
 	 * group->priority == FS_PRIO_0 == FAN_CLASS_NOTIF.  These are not
 	 * allowed to set permissions events.
diff --git a/fs/notify/fdinfo.c b/fs/notify/fdinfo.c
index 765b50aeadd28..85b112bd88511 100644
--- a/fs/notify/fdinfo.c
+++ b/fs/notify/fdinfo.c
@@ -137,7 +137,8 @@ void fanotify_show_fdinfo(struct seq_file *m, struct file *f)
 	struct fsnotify_group *group = f->private_data;
 
 	seq_printf(m, "fanotify flags:%x event-flags:%x\n",
-		   group->fanotify_data.flags, group->fanotify_data.f_flags);
+		   group->fanotify_data.flags,
+		   group->fanotify_data.f_flags);
 
 	show_fdinfo(m, f, fanotify_fdinfo);
 }
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 031a97d8369ae..bad41bcb25dfb 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -18,15 +18,38 @@ extern struct ctl_table fanotify_table[]; /* for sysctl */
  * these constant, the programs may break if re-compiled with new uapi headers
  * and then run on an old kernel.
  */
-#define FANOTIFY_CLASS_BITS	(FAN_CLASS_NOTIF | FAN_CLASS_CONTENT | \
+
+/* Group classes where permission events are allowed */
+#define FANOTIFY_PERM_CLASSES	(FAN_CLASS_CONTENT | \
 				 FAN_CLASS_PRE_CONTENT)
 
+#define FANOTIFY_CLASS_BITS	(FAN_CLASS_NOTIF | FANOTIFY_PERM_CLASSES)
+
 #define FANOTIFY_FID_BITS	(FAN_REPORT_FID | FAN_REPORT_DFID_NAME)
 
-#define FANOTIFY_INIT_FLAGS	(FANOTIFY_CLASS_BITS | FANOTIFY_FID_BITS | \
-				 FAN_REPORT_TID | \
-				 FAN_CLOEXEC | FAN_NONBLOCK | \
-				 FAN_UNLIMITED_QUEUE | FAN_UNLIMITED_MARKS)
+/*
+ * fanotify_init() flags that require CAP_SYS_ADMIN.
+ * We do not allow unprivileged groups to request permission events.
+ * We do not allow unprivileged groups to get other process pid in events.
+ * We do not allow unprivileged groups to use unlimited resources.
+ */
+#define FANOTIFY_ADMIN_INIT_FLAGS	(FANOTIFY_PERM_CLASSES | \
+					 FAN_REPORT_TID | \
+					 FAN_UNLIMITED_QUEUE | \
+					 FAN_UNLIMITED_MARKS)
+
+/*
+ * fanotify_init() flags that are allowed for user without CAP_SYS_ADMIN.
+ * FAN_CLASS_NOTIF is the only class we allow for unprivileged group.
+ * We do not allow unprivileged groups to get file descriptors in events,
+ * so one of the flags for reporting file handles is required.
+ */
+#define FANOTIFY_USER_INIT_FLAGS	(FAN_CLASS_NOTIF | \
+					 FANOTIFY_FID_BITS | \
+					 FAN_CLOEXEC | FAN_NONBLOCK)
+
+#define FANOTIFY_INIT_FLAGS	(FANOTIFY_ADMIN_INIT_FLAGS | \
+				 FANOTIFY_USER_INIT_FLAGS)
 
 #define FANOTIFY_MARK_TYPE_BITS	(FAN_MARK_INODE | FAN_MARK_MOUNT | \
 				 FAN_MARK_FILESYSTEM)
-- 
2.43.0



