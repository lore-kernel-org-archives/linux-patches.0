Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7E31272D5;
	Mon,  8 Apr 2024 13:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583830; cv=none; b=n5liEFWw2Oh6+MDq0JIp21Z/3GhBnKnW5/7CKywhGHuBua/IWF59WE4//97qCBxiyd2MFW5sSaPZ9Zo6SHgf9wE4IJy1p+EjMI/SyP2eoeS/YvZWYw2JuG+tEucPQK7ZHOtaw1I52KExKpwePeiOYiCgEE5HlzKT0esavbzLwpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583830; c=relaxed/simple;
	bh=td0bjIAfUhib8M8QvZ8En4XEJk2kAgJeUqYWIxL9ptk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q783ydnI6qBzfG5o6SnAHkSOlLXnqZxZVbywDUAjFZyL5bJ17rAcrLDDp7QQ9DQ6lZwRMcAUN1mFyv2nVgkbfBTIR4/woKuCL9A0B63YgLFYZPkrv1fqGpPVPi+RcuNsyTmJRrPbww61M32O0nmZVWmBUHgBZc3yaWs+NH85hl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vl7svvF1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vl7svvF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DE1C433F1;
	Mon,  8 Apr 2024 13:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583829;
	bh=td0bjIAfUhib8M8QvZ8En4XEJk2kAgJeUqYWIxL9ptk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vl7svvF1Rpdj4Ce7xlQavNzV53hiYL48EoXlt1q3FtsGyerNzfDPBqy6hHXi4ysJ6
	 Cg1DPS9gRHZZ5ivcxv0LJ4mzOPWBBtQfyIzVVPEFi9ohzNXgFA3nbn26rL58LD6Bdo
	 q2bjcLwMK1BQxSfkCiAnYPXhaf4xICvmRDhi8Z38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 293/690] fsnotify: create helpers for group mark_mutex lock
Date: Mon,  8 Apr 2024 14:52:39 +0200
Message-ID: <20240408125410.227179757@linuxfoundation.org>
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

[ Upstream commit 43b245a788e2d8f1bb742668a9bdace02fcb3e96 ]

Create helpers to take and release the group mark_mutex lock.

Define a flag FSNOTIFY_GROUP_NOFS in fsnotify_group that determines
if the mark_mutex lock is fs reclaim safe or not.  If not safe, the
lock helpers take the lock and disable direct fs reclaim.

In that case we annotate the mutex with a different lockdep class to
express to lockdep that an allocation of mark of an fs reclaim safe group
may take the group lock of another "NOFS" group to evict inodes.

For now, converted only the callers in common code and no backend
defines the NOFS flag.  It is intended to be set by fanotify for
evictable marks support.

Link: https://lore.kernel.org/r/20220422120327.3459282-7-amir73il@gmail.com
Suggested-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220321112310.vpr7oxro2xkz5llh@quack3.lan/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fdinfo.c               |  4 ++--
 fs/notify/group.c                | 11 +++++++++++
 fs/notify/mark.c                 | 24 +++++++++++-------------
 include/linux/fsnotify_backend.h | 28 ++++++++++++++++++++++++++++
 4 files changed, 52 insertions(+), 15 deletions(-)

diff --git a/fs/notify/fdinfo.c b/fs/notify/fdinfo.c
index 3451708fd035c..1f34c5c29fdbd 100644
--- a/fs/notify/fdinfo.c
+++ b/fs/notify/fdinfo.c
@@ -28,13 +28,13 @@ static void show_fdinfo(struct seq_file *m, struct file *f,
 	struct fsnotify_group *group = f->private_data;
 	struct fsnotify_mark *mark;
 
-	mutex_lock(&group->mark_mutex);
+	fsnotify_group_lock(group);
 	list_for_each_entry(mark, &group->marks_list, g_list) {
 		show(m, mark);
 		if (seq_has_overflowed(m))
 			break;
 	}
-	mutex_unlock(&group->mark_mutex);
+	fsnotify_group_unlock(group);
 }
 
 #if defined(CONFIG_EXPORTFS)
diff --git a/fs/notify/group.c b/fs/notify/group.c
index 18446b7b0d495..1de6631a3925e 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -115,6 +115,7 @@ static struct fsnotify_group *__fsnotify_alloc_group(
 				const struct fsnotify_ops *ops,
 				int flags, gfp_t gfp)
 {
+	static struct lock_class_key nofs_marks_lock;
 	struct fsnotify_group *group;
 
 	group = kzalloc(sizeof(struct fsnotify_group), gfp);
@@ -135,6 +136,16 @@ static struct fsnotify_group *__fsnotify_alloc_group(
 
 	group->ops = ops;
 	group->flags = flags;
+	/*
+	 * For most backends, eviction of inode with a mark is not expected,
+	 * because marks hold a refcount on the inode against eviction.
+	 *
+	 * Use a different lockdep class for groups that support evictable
+	 * inode marks, because with evictable marks, mark_mutex is NOT
+	 * fs-reclaim safe - the mutex is taken when evicting inodes.
+	 */
+	if (flags & FSNOTIFY_GROUP_NOFS)
+		lockdep_set_class(&group->mark_mutex, &nofs_marks_lock);
 
 	return group;
 }
diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 1fb246ea61752..982ca2f20ff5d 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -398,9 +398,7 @@ void fsnotify_finish_user_wait(struct fsnotify_iter_info *iter_info)
  */
 void fsnotify_detach_mark(struct fsnotify_mark *mark)
 {
-	struct fsnotify_group *group = mark->group;
-
-	WARN_ON_ONCE(!mutex_is_locked(&group->mark_mutex));
+	fsnotify_group_assert_locked(mark->group);
 	WARN_ON_ONCE(!srcu_read_lock_held(&fsnotify_mark_srcu) &&
 		     refcount_read(&mark->refcnt) < 1 +
 			!!(mark->flags & FSNOTIFY_MARK_FLAG_ATTACHED));
@@ -452,9 +450,9 @@ void fsnotify_free_mark(struct fsnotify_mark *mark)
 void fsnotify_destroy_mark(struct fsnotify_mark *mark,
 			   struct fsnotify_group *group)
 {
-	mutex_lock(&group->mark_mutex);
+	fsnotify_group_lock(group);
 	fsnotify_detach_mark(mark);
-	mutex_unlock(&group->mark_mutex);
+	fsnotify_group_unlock(group);
 	fsnotify_free_mark(mark);
 }
 EXPORT_SYMBOL_GPL(fsnotify_destroy_mark);
@@ -673,7 +671,7 @@ int fsnotify_add_mark_locked(struct fsnotify_mark *mark,
 	struct fsnotify_group *group = mark->group;
 	int ret = 0;
 
-	BUG_ON(!mutex_is_locked(&group->mark_mutex));
+	fsnotify_group_assert_locked(group);
 
 	/*
 	 * LOCKING ORDER!!!!
@@ -714,9 +712,9 @@ int fsnotify_add_mark(struct fsnotify_mark *mark, fsnotify_connp_t *connp,
 	int ret;
 	struct fsnotify_group *group = mark->group;
 
-	mutex_lock(&group->mark_mutex);
+	fsnotify_group_lock(group);
 	ret = fsnotify_add_mark_locked(mark, connp, obj_type, add_flags, fsid);
-	mutex_unlock(&group->mark_mutex);
+	fsnotify_group_unlock(group);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(fsnotify_add_mark);
@@ -770,24 +768,24 @@ void fsnotify_clear_marks_by_group(struct fsnotify_group *group,
 	 * move marks to free to to_free list in one go and then free marks in
 	 * to_free list one by one.
 	 */
-	mutex_lock(&group->mark_mutex);
+	fsnotify_group_lock(group);
 	list_for_each_entry_safe(mark, lmark, &group->marks_list, g_list) {
 		if (mark->connector->type == obj_type)
 			list_move(&mark->g_list, &to_free);
 	}
-	mutex_unlock(&group->mark_mutex);
+	fsnotify_group_unlock(group);
 
 clear:
 	while (1) {
-		mutex_lock(&group->mark_mutex);
+		fsnotify_group_lock(group);
 		if (list_empty(head)) {
-			mutex_unlock(&group->mark_mutex);
+			fsnotify_group_unlock(group);
 			break;
 		}
 		mark = list_first_entry(head, struct fsnotify_mark, g_list);
 		fsnotify_get_mark(mark);
 		fsnotify_detach_mark(mark);
-		mutex_unlock(&group->mark_mutex);
+		fsnotify_group_unlock(group);
 		fsnotify_free_mark(mark);
 		fsnotify_put_mark(mark);
 	}
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index dd440e6ff5285..d62111e832440 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -20,6 +20,7 @@
 #include <linux/user_namespace.h>
 #include <linux/refcount.h>
 #include <linux/mempool.h>
+#include <linux/sched/mm.h>
 
 /*
  * IN_* from inotfy.h lines up EXACTLY with FS_*, this is so we can easily
@@ -212,7 +213,9 @@ struct fsnotify_group {
 
 #define FSNOTIFY_GROUP_USER	0x01 /* user allocated group */
 #define FSNOTIFY_GROUP_DUPS	0x02 /* allow multiple marks per object */
+#define FSNOTIFY_GROUP_NOFS	0x04 /* group lock is not direct reclaim safe */
 	int flags;
+	unsigned int owner_flags;	/* stored flags of mark_mutex owner */
 
 	/* stores all fastpath marks assoc with this group so they can be cleaned on unregister */
 	struct mutex mark_mutex;	/* protect marks_list */
@@ -254,6 +257,31 @@ struct fsnotify_group {
 	};
 };
 
+/*
+ * These helpers are used to prevent deadlock when reclaiming inodes with
+ * evictable marks of the same group that is allocating a new mark.
+ */
+static inline void fsnotify_group_lock(struct fsnotify_group *group)
+{
+	mutex_lock(&group->mark_mutex);
+	if (group->flags & FSNOTIFY_GROUP_NOFS)
+		group->owner_flags = memalloc_nofs_save();
+}
+
+static inline void fsnotify_group_unlock(struct fsnotify_group *group)
+{
+	if (group->flags & FSNOTIFY_GROUP_NOFS)
+		memalloc_nofs_restore(group->owner_flags);
+	mutex_unlock(&group->mark_mutex);
+}
+
+static inline void fsnotify_group_assert_locked(struct fsnotify_group *group)
+{
+	WARN_ON_ONCE(!mutex_is_locked(&group->mark_mutex));
+	if (group->flags & FSNOTIFY_GROUP_NOFS)
+		WARN_ON_ONCE(!(current->flags & PF_MEMALLOC_NOFS));
+}
+
 /* When calling fsnotify tell it if the data is a path or inode */
 enum fsnotify_data_type {
 	FSNOTIFY_EVENT_NONE,
-- 
2.43.0



