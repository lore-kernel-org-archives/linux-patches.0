Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBB96A352;
	Mon,  8 Apr 2024 13:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584121; cv=none; b=AVwoXaLMS3XGuCc6bbp431AsBA+2BzJNHtXviOPZdh9//wGo+Hp49je0jawIQZFbao7Qpi/SfWe5eQ+6KvFnEUtx85DPnJF/bMJAwzR3Da9oKRaLr4bDS7MPKcTRMPazvkjoMzM08/Oj0nHs4mw4orzf48IH5Zwt8PgeTYCgIjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584121; c=relaxed/simple;
	bh=N6GcFTJJ2Gifxuv5nlSh5w2eADOLuh2SSLefHIOgzos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IopiH4SZUakio8haMR5t+7T7z9KOSdYswX+2SLGenuvL3yWIkeBKXbgyp67o5QGYx/GrheWnlf1NpRmRXgL+7qLe6DAIlpN4cHdBmcWcA30KOlBdwZtb2RIRi3NYpKbs6nk0zCcQIBMKv9g1VboOMTH+y54b7J/leNbLE9UY7R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tzk2Bl+K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tzk2Bl+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59A7C433F1;
	Mon,  8 Apr 2024 13:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584121;
	bh=N6GcFTJJ2Gifxuv5nlSh5w2eADOLuh2SSLefHIOgzos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tzk2Bl+KVBdb3fiqZD46F+bKgMGwc5d/vGvpvNLAjopbwrTWHH6P3MaxfyPW3l4U0
	 TD+cNBa6PA20Egdb90uvAgViA4V5QGV9DTOHKZNdVr3wbi7tOt8oCvAGe+87UBWtZM
	 VAmbPya+oSOT1e74yQ78Utit8U2ZJk4OF/tQ17t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 337/690] fanotify: prepare for setting event flags in ignore mask
Date: Mon,  8 Apr 2024 14:53:23 +0200
Message-ID: <20240408125411.822793698@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 31a371e419c885e0f137ce70395356ba8639dc52 ]

Setting flags FAN_ONDIR FAN_EVENT_ON_CHILD in ignore mask has no effect.
The FAN_EVENT_ON_CHILD flag in mask implicitly applies to ignore mask and
ignore mask is always implicitly applied to events on directories.

Define a mark flag that replaces this legacy behavior with logic of
applying the ignore mask according to event flags in ignore mask.

Implement the new logic to prepare for supporting an ignore mask that
ignores events on children and ignore mask that does not ignore events
on directories.

To emphasize the change in terminology, also rename ignored_mask mark
member to ignore_mask and use accessors to get only the effective
ignored events or the ignored events and flags.

This change in terminology finally aligns with the "ignore mask"
language in man pages and in most of the comments.

Link: https://lore.kernel.org/r/20220629144210.2983229-2-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify.c      | 19 ++++---
 fs/notify/fanotify/fanotify_user.c | 21 ++++---
 fs/notify/fdinfo.c                 |  6 +-
 fs/notify/fsnotify.c               | 21 ++++---
 include/linux/fsnotify_backend.h   | 89 ++++++++++++++++++++++++++++--
 5 files changed, 121 insertions(+), 35 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 4f897e1095470..cd7d09a569fff 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -295,12 +295,13 @@ static u32 fanotify_group_event_mask(struct fsnotify_group *group,
 				     const void *data, int data_type,
 				     struct inode *dir)
 {
-	__u32 marks_mask = 0, marks_ignored_mask = 0;
+	__u32 marks_mask = 0, marks_ignore_mask = 0;
 	__u32 test_mask, user_mask = FANOTIFY_OUTGOING_EVENTS |
 				     FANOTIFY_EVENT_FLAGS;
 	const struct path *path = fsnotify_data_path(data, data_type);
 	unsigned int fid_mode = FAN_GROUP_FLAG(group, FANOTIFY_FID_BITS);
 	struct fsnotify_mark *mark;
+	bool ondir = event_mask & FAN_ONDIR;
 	int type;
 
 	pr_debug("%s: report_mask=%x mask=%x data=%p data_type=%d\n",
@@ -315,19 +316,21 @@ static u32 fanotify_group_event_mask(struct fsnotify_group *group,
 			return 0;
 	} else if (!(fid_mode & FAN_REPORT_FID)) {
 		/* Do we have a directory inode to report? */
-		if (!dir && !(event_mask & FS_ISDIR))
+		if (!dir && !ondir)
 			return 0;
 	}
 
 	fsnotify_foreach_iter_mark_type(iter_info, mark, type) {
-		/* Apply ignore mask regardless of mark's ISDIR flag */
-		marks_ignored_mask |= mark->ignored_mask;
+		/*
+		 * Apply ignore mask depending on event flags in ignore mask.
+		 */
+		marks_ignore_mask |=
+			fsnotify_effective_ignore_mask(mark, ondir, type);
 
 		/*
-		 * If the event is on dir and this mark doesn't care about
-		 * events on dir, don't send it!
+		 * Send the event depending on event flags in mark mask.
 		 */
-		if (event_mask & FS_ISDIR && !(mark->mask & FS_ISDIR))
+		if (!fsnotify_mask_applicable(mark->mask, ondir, type))
 			continue;
 
 		marks_mask |= mark->mask;
@@ -336,7 +339,7 @@ static u32 fanotify_group_event_mask(struct fsnotify_group *group,
 		*match_mask |= 1U << type;
 	}
 
-	test_mask = event_mask & marks_mask & ~marks_ignored_mask;
+	test_mask = event_mask & marks_mask & ~marks_ignore_mask;
 
 	/*
 	 * For dirent modification events (create/delete/move) that do not carry
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 433c89fdcf0cd..9367216263cab 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1008,7 +1008,7 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
 	if (!(flags & FAN_MARK_IGNORED_MASK)) {
 		fsn_mark->mask &= ~mask;
 	} else {
-		fsn_mark->ignored_mask &= ~mask;
+		fsn_mark->ignore_mask &= ~mask;
 	}
 	newmask = fsnotify_calc_mask(fsn_mark);
 	/*
@@ -1017,7 +1017,7 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
 	 * changes to the mask.
 	 * Destroy mark when only umask bits remain.
 	 */
-	*destroy = !((fsn_mark->mask | fsn_mark->ignored_mask) & ~umask);
+	*destroy = !((fsn_mark->mask | fsn_mark->ignore_mask) & ~umask);
 	spin_unlock(&fsn_mark->lock);
 
 	return oldmask & ~newmask;
@@ -1086,7 +1086,7 @@ static bool fanotify_mark_update_flags(struct fsnotify_mark *fsn_mark,
 	/*
 	 * Setting FAN_MARK_IGNORED_SURV_MODIFY for the first time may lead to
 	 * the removal of the FS_MODIFY bit in calculated mask if it was set
-	 * because of an ignored mask that is now going to survive FS_MODIFY.
+	 * because of an ignore mask that is now going to survive FS_MODIFY.
 	 */
 	if ((fan_flags & FAN_MARK_IGNORED_MASK) &&
 	    (fan_flags & FAN_MARK_IGNORED_SURV_MODIFY) &&
@@ -1119,7 +1119,7 @@ static bool fanotify_mark_add_to_mask(struct fsnotify_mark *fsn_mark,
 	if (!(fan_flags & FAN_MARK_IGNORED_MASK))
 		fsn_mark->mask |= mask;
 	else
-		fsn_mark->ignored_mask |= mask;
+		fsn_mark->ignore_mask |= mask;
 
 	recalc = fsnotify_calc_mask(fsn_mark) &
 		~fsnotify_conn_mask(fsn_mark->connector);
@@ -1257,7 +1257,7 @@ static int fanotify_add_inode_mark(struct fsnotify_group *group,
 
 	/*
 	 * If some other task has this inode open for write we should not add
-	 * an ignored mark, unless that ignored mark is supposed to survive
+	 * an ignore mask, unless that ignore mask is supposed to survive
 	 * modification changes anyway.
 	 */
 	if ((flags & FAN_MARK_IGNORED_MASK) &&
@@ -1567,7 +1567,7 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
 	__kernel_fsid_t __fsid, *fsid = NULL;
 	u32 valid_mask = FANOTIFY_EVENTS | FANOTIFY_EVENT_FLAGS;
 	unsigned int mark_type = flags & FANOTIFY_MARK_TYPE_BITS;
-	bool ignored = flags & FAN_MARK_IGNORED_MASK;
+	bool ignore = flags & FAN_MARK_IGNORED_MASK;
 	unsigned int obj_type, fid_mode;
 	u32 umask = 0;
 	int ret;
@@ -1616,8 +1616,11 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
 	if (mask & ~valid_mask)
 		return -EINVAL;
 
-	/* Event flags (ONDIR, ON_CHILD) are meaningless in ignored mask */
-	if (ignored)
+	/*
+	 * Event flags (FAN_ONDIR, FAN_EVENT_ON_CHILD) have no effect with
+	 * FAN_MARK_IGNORED_MASK.
+	 */
+	if (ignore)
 		mask &= ~FANOTIFY_EVENT_FLAGS;
 
 	f = fdget(fanotify_fd);
@@ -1731,7 +1734,7 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
 		 * events with parent/name info for non-directory.
 		 */
 		if ((fid_mode & FAN_REPORT_DIR_FID) &&
-		    (flags & FAN_MARK_ADD) && !ignored)
+		    (flags & FAN_MARK_ADD) && !ignore)
 			mask |= FAN_EVENT_ON_CHILD;
 	}
 
diff --git a/fs/notify/fdinfo.c b/fs/notify/fdinfo.c
index 59fb40abe33d3..55081ae3a6ec0 100644
--- a/fs/notify/fdinfo.c
+++ b/fs/notify/fdinfo.c
@@ -113,7 +113,7 @@ static void fanotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
 			return;
 		seq_printf(m, "fanotify ino:%lx sdev:%x mflags:%x mask:%x ignored_mask:%x ",
 			   inode->i_ino, inode->i_sb->s_dev,
-			   mflags, mark->mask, mark->ignored_mask);
+			   mflags, mark->mask, mark->ignore_mask);
 		show_mark_fhandle(m, inode);
 		seq_putc(m, '\n');
 		iput(inode);
@@ -121,12 +121,12 @@ static void fanotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
 		struct mount *mnt = fsnotify_conn_mount(mark->connector);
 
 		seq_printf(m, "fanotify mnt_id:%x mflags:%x mask:%x ignored_mask:%x\n",
-			   mnt->mnt_id, mflags, mark->mask, mark->ignored_mask);
+			   mnt->mnt_id, mflags, mark->mask, mark->ignore_mask);
 	} else if (mark->connector->type == FSNOTIFY_OBJ_TYPE_SB) {
 		struct super_block *sb = fsnotify_conn_sb(mark->connector);
 
 		seq_printf(m, "fanotify sdev:%x mflags:%x mask:%x ignored_mask:%x\n",
-			   sb->s_dev, mflags, mark->mask, mark->ignored_mask);
+			   sb->s_dev, mflags, mark->mask, mark->ignore_mask);
 	}
 }
 
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 0b3e74935cb4f..8687562df2e37 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -324,7 +324,8 @@ static int send_to_group(__u32 mask, const void *data, int data_type,
 	struct fsnotify_group *group = NULL;
 	__u32 test_mask = (mask & ALL_FSNOTIFY_EVENTS);
 	__u32 marks_mask = 0;
-	__u32 marks_ignored_mask = 0;
+	__u32 marks_ignore_mask = 0;
+	bool is_dir = mask & FS_ISDIR;
 	struct fsnotify_mark *mark;
 	int type;
 
@@ -336,7 +337,7 @@ static int send_to_group(__u32 mask, const void *data, int data_type,
 		fsnotify_foreach_iter_mark_type(iter_info, mark, type) {
 			if (!(mark->flags &
 			      FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY))
-				mark->ignored_mask = 0;
+				mark->ignore_mask = 0;
 		}
 	}
 
@@ -344,14 +345,15 @@ static int send_to_group(__u32 mask, const void *data, int data_type,
 	fsnotify_foreach_iter_mark_type(iter_info, mark, type) {
 		group = mark->group;
 		marks_mask |= mark->mask;
-		marks_ignored_mask |= mark->ignored_mask;
+		marks_ignore_mask |=
+			fsnotify_effective_ignore_mask(mark, is_dir, type);
 	}
 
-	pr_debug("%s: group=%p mask=%x marks_mask=%x marks_ignored_mask=%x data=%p data_type=%d dir=%p cookie=%d\n",
-		 __func__, group, mask, marks_mask, marks_ignored_mask,
+	pr_debug("%s: group=%p mask=%x marks_mask=%x marks_ignore_mask=%x data=%p data_type=%d dir=%p cookie=%d\n",
+		 __func__, group, mask, marks_mask, marks_ignore_mask,
 		 data, data_type, dir, cookie);
 
-	if (!(test_mask & marks_mask & ~marks_ignored_mask))
+	if (!(test_mask & marks_mask & ~marks_ignore_mask))
 		return 0;
 
 	if (group->ops->handle_event) {
@@ -423,7 +425,8 @@ static bool fsnotify_iter_select_report_types(
 			 * But is *this mark* watching children?
 			 */
 			if (type == FSNOTIFY_ITER_TYPE_PARENT &&
-			    !(mark->mask & FS_EVENT_ON_CHILD))
+			    !(mark->mask & FS_EVENT_ON_CHILD) &&
+			    !(fsnotify_ignore_mask(mark) & FS_EVENT_ON_CHILD))
 				continue;
 
 			fsnotify_iter_set_report_type(iter_info, type);
@@ -532,8 +535,8 @@ int fsnotify(__u32 mask, const void *data, int data_type, struct inode *dir,
 
 
 	/*
-	 * If this is a modify event we may need to clear some ignored masks.
-	 * In that case, the object with ignored masks will have the FS_MODIFY
+	 * If this is a modify event we may need to clear some ignore masks.
+	 * In that case, the object with ignore masks will have the FS_MODIFY
 	 * event in its mask.
 	 * Otherwise, return if none of the marks care about this type of event.
 	 */
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 9560734759fa6..d7d96c806bff2 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -518,8 +518,8 @@ struct fsnotify_mark {
 	struct hlist_node obj_list;
 	/* Head of list of marks for an object [mark ref] */
 	struct fsnotify_mark_connector *connector;
-	/* Events types to ignore [mark->lock, group->mark_mutex] */
-	__u32 ignored_mask;
+	/* Events types and flags to ignore [mark->lock, group->mark_mutex] */
+	__u32 ignore_mask;
 	/* General fsnotify mark flags */
 #define FSNOTIFY_MARK_FLAG_ALIVE		0x0001
 #define FSNOTIFY_MARK_FLAG_ATTACHED		0x0002
@@ -529,6 +529,7 @@ struct fsnotify_mark {
 	/* fanotify mark flags */
 #define FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY	0x0100
 #define FSNOTIFY_MARK_FLAG_NO_IREF		0x0200
+#define FSNOTIFY_MARK_FLAG_HAS_IGNORE_FLAGS	0x0400
 	unsigned int flags;		/* flags [mark->lock] */
 };
 
@@ -655,15 +656,91 @@ extern void fsnotify_remove_queued_event(struct fsnotify_group *group,
 
 /* functions used to manipulate the marks attached to inodes */
 
-/* Get mask for calculating object interest taking ignored mask into account */
+/*
+ * Canonical "ignore mask" including event flags.
+ *
+ * Note the subtle semantic difference from the legacy ->ignored_mask.
+ * ->ignored_mask traditionally only meant which events should be ignored,
+ * while ->ignore_mask also includes flags regarding the type of objects on
+ * which events should be ignored.
+ */
+static inline __u32 fsnotify_ignore_mask(struct fsnotify_mark *mark)
+{
+	__u32 ignore_mask = mark->ignore_mask;
+
+	/* The event flags in ignore mask take effect */
+	if (mark->flags & FSNOTIFY_MARK_FLAG_HAS_IGNORE_FLAGS)
+		return ignore_mask;
+
+	/*
+	 * Legacy behavior:
+	 * - Always ignore events on dir
+	 * - Ignore events on child if parent is watching children
+	 */
+	ignore_mask |= FS_ISDIR;
+	ignore_mask &= ~FS_EVENT_ON_CHILD;
+	ignore_mask |= mark->mask & FS_EVENT_ON_CHILD;
+
+	return ignore_mask;
+}
+
+/* Legacy ignored_mask - only event types to ignore */
+static inline __u32 fsnotify_ignored_events(struct fsnotify_mark *mark)
+{
+	return mark->ignore_mask & ALL_FSNOTIFY_EVENTS;
+}
+
+/*
+ * Check if mask (or ignore mask) should be applied depending if victim is a
+ * directory and whether it is reported to a watching parent.
+ */
+static inline bool fsnotify_mask_applicable(__u32 mask, bool is_dir,
+					    int iter_type)
+{
+	/* Should mask be applied to a directory? */
+	if (is_dir && !(mask & FS_ISDIR))
+		return false;
+
+	/* Should mask be applied to a child? */
+	if (iter_type == FSNOTIFY_ITER_TYPE_PARENT &&
+	    !(mask & FS_EVENT_ON_CHILD))
+		return false;
+
+	return true;
+}
+
+/*
+ * Effective ignore mask taking into account if event victim is a
+ * directory and whether it is reported to a watching parent.
+ */
+static inline __u32 fsnotify_effective_ignore_mask(struct fsnotify_mark *mark,
+						   bool is_dir, int iter_type)
+{
+	__u32 ignore_mask = fsnotify_ignored_events(mark);
+
+	if (!ignore_mask)
+		return 0;
+
+	/* For non-dir and non-child, no need to consult the event flags */
+	if (!is_dir && iter_type != FSNOTIFY_ITER_TYPE_PARENT)
+		return ignore_mask;
+
+	ignore_mask = fsnotify_ignore_mask(mark);
+	if (!fsnotify_mask_applicable(ignore_mask, is_dir, iter_type))
+		return 0;
+
+	return ignore_mask & ALL_FSNOTIFY_EVENTS;
+}
+
+/* Get mask for calculating object interest taking ignore mask into account */
 static inline __u32 fsnotify_calc_mask(struct fsnotify_mark *mark)
 {
 	__u32 mask = mark->mask;
 
-	if (!mark->ignored_mask)
+	if (!fsnotify_ignored_events(mark))
 		return mask;
 
-	/* Interest in FS_MODIFY may be needed for clearing ignored mask */
+	/* Interest in FS_MODIFY may be needed for clearing ignore mask */
 	if (!(mark->flags & FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY))
 		mask |= FS_MODIFY;
 
@@ -671,7 +748,7 @@ static inline __u32 fsnotify_calc_mask(struct fsnotify_mark *mark)
 	 * If mark is interested in ignoring events on children, the object must
 	 * show interest in those events for fsnotify_parent() to notice it.
 	 */
-	return mask | (mark->ignored_mask & ALL_FSNOTIFY_EVENTS);
+	return mask | mark->ignore_mask;
 }
 
 /* Get mask of events for a list of marks */
-- 
2.43.0



