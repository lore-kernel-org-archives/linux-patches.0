Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083D014A0A7;
	Tue, 18 Jun 2024 13:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715731; cv=none; b=KRRfG5n/WSz0TXcfTDgSkupWFCQqDVc/BUCrX9GAVwKdys3LAFSXSSDU3GQCzL1hZQPtKMp8J7Tiibg9lsFk4GZu00qjExpdRNIVWTrZcQ0E07pnY8+LXVm/QeZm/DJ1zkFZ3YhOlu2d2WJWEo/+hLYb3wR8fFYANT8mUDsPilc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715731; c=relaxed/simple;
	bh=mtVPsL6OH1d6jburqQJytuMfGQTPNHoxilwvqYOLDks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0KioZF46q/MVRBCNjQa1ntOGwDUxSlRBFra9KaBkbousZBiGQ+3ApNMXEIeiXHqlBJbSROCUHzyb1iKWjS9KDR0T4pPUaj2YSiWIf3YkCsMs7HB3v6RBN6RIkIWuo8HFaydAa34jjTPiv6owGKYfdCi1iBZBxawVKvc06oHMVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFmrse+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFmrse+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843FCC3277B;
	Tue, 18 Jun 2024 13:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715730;
	bh=mtVPsL6OH1d6jburqQJytuMfGQTPNHoxilwvqYOLDks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFmrse+0JIs7VhSvCITz/8rUZFjQmxvwtwfpjo207P2H35S+VRB6eyTdNOD/ySPak
	 S0wB/438u2lnvD7Ci1IvQiIQxuCigE5OM/UIXKRF/EEUYNxVzxVdTzL3se7W7oAFBJ
	 Dnln37iko1UUA1DZ7TithptazzdPRgjA3Ji01EDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 406/770] fsnotify: separate mark iterator type from object type enum
Date: Tue, 18 Jun 2024 14:34:19 +0200
Message-ID: <20240618123422.957180651@linuxfoundation.org>
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

[ Upstream commit 1c9007d62bea6fd164285314f7553f73e5308863 ]

They are two different types that use the same enum, so this confusing.

Use the object type to indicate the type of object mark is attached to
and the iter type to indicate the type of watch.

A group can have two different watches of the same object type (parent
and child watches) that match the same event.

Link: https://lore.kernel.org/r/20211129201537.1932819-3-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify.c    |  6 ++---
 fs/notify/fsnotify.c             | 18 +++++++-------
 fs/notify/mark.c                 |  4 ++--
 include/linux/fsnotify_backend.h | 41 ++++++++++++++++++++++----------
 4 files changed, 42 insertions(+), 27 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index b6091775aa6ef..652fe84cb8acd 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -299,7 +299,7 @@ static u32 fanotify_group_event_mask(struct fsnotify_group *group,
 			return 0;
 	}
 
-	fsnotify_foreach_obj_type(type) {
+	fsnotify_foreach_iter_type(type) {
 		if (!fsnotify_iter_should_report_type(iter_info, type))
 			continue;
 		mark = iter_info->marks[type];
@@ -318,7 +318,7 @@ static u32 fanotify_group_event_mask(struct fsnotify_group *group,
 		 * If the event is on a child and this mark is on a parent not
 		 * watching children, don't send it!
 		 */
-		if (type == FSNOTIFY_OBJ_TYPE_PARENT &&
+		if (type == FSNOTIFY_ITER_TYPE_PARENT &&
 		    !(mark->mask & FS_EVENT_ON_CHILD))
 			continue;
 
@@ -746,7 +746,7 @@ static __kernel_fsid_t fanotify_get_fsid(struct fsnotify_iter_info *iter_info)
 	int type;
 	__kernel_fsid_t fsid = {};
 
-	fsnotify_foreach_obj_type(type) {
+	fsnotify_foreach_iter_type(type) {
 		struct fsnotify_mark_connector *conn;
 
 		if (!fsnotify_iter_should_report_type(iter_info, type))
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 4034ca566f95c..0c94457c625e2 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -330,7 +330,7 @@ static int send_to_group(__u32 mask, const void *data, int data_type,
 
 	/* clear ignored on inode modification */
 	if (mask & FS_MODIFY) {
-		fsnotify_foreach_obj_type(type) {
+		fsnotify_foreach_iter_type(type) {
 			if (!fsnotify_iter_should_report_type(iter_info, type))
 				continue;
 			mark = iter_info->marks[type];
@@ -340,7 +340,7 @@ static int send_to_group(__u32 mask, const void *data, int data_type,
 		}
 	}
 
-	fsnotify_foreach_obj_type(type) {
+	fsnotify_foreach_iter_type(type) {
 		if (!fsnotify_iter_should_report_type(iter_info, type))
 			continue;
 		mark = iter_info->marks[type];
@@ -405,7 +405,7 @@ static unsigned int fsnotify_iter_select_report_types(
 	int type;
 
 	/* Choose max prio group among groups of all queue heads */
-	fsnotify_foreach_obj_type(type) {
+	fsnotify_foreach_iter_type(type) {
 		mark = iter_info->marks[type];
 		if (mark &&
 		    fsnotify_compare_groups(max_prio_group, mark->group) > 0)
@@ -417,7 +417,7 @@ static unsigned int fsnotify_iter_select_report_types(
 
 	/* Set the report mask for marks from same group as max prio group */
 	iter_info->report_mask = 0;
-	fsnotify_foreach_obj_type(type) {
+	fsnotify_foreach_iter_type(type) {
 		mark = iter_info->marks[type];
 		if (mark &&
 		    fsnotify_compare_groups(max_prio_group, mark->group) == 0)
@@ -435,7 +435,7 @@ static void fsnotify_iter_next(struct fsnotify_iter_info *iter_info)
 {
 	int type;
 
-	fsnotify_foreach_obj_type(type) {
+	fsnotify_foreach_iter_type(type) {
 		if (fsnotify_iter_should_report_type(iter_info, type))
 			iter_info->marks[type] =
 				fsnotify_next_mark(iter_info->marks[type]);
@@ -519,18 +519,18 @@ int fsnotify(__u32 mask, const void *data, int data_type, struct inode *dir,
 
 	iter_info.srcu_idx = srcu_read_lock(&fsnotify_mark_srcu);
 
-	iter_info.marks[FSNOTIFY_OBJ_TYPE_SB] =
+	iter_info.marks[FSNOTIFY_ITER_TYPE_SB] =
 		fsnotify_first_mark(&sb->s_fsnotify_marks);
 	if (mnt) {
-		iter_info.marks[FSNOTIFY_OBJ_TYPE_VFSMOUNT] =
+		iter_info.marks[FSNOTIFY_ITER_TYPE_VFSMOUNT] =
 			fsnotify_first_mark(&mnt->mnt_fsnotify_marks);
 	}
 	if (inode) {
-		iter_info.marks[FSNOTIFY_OBJ_TYPE_INODE] =
+		iter_info.marks[FSNOTIFY_ITER_TYPE_INODE] =
 			fsnotify_first_mark(&inode->i_fsnotify_marks);
 	}
 	if (parent) {
-		iter_info.marks[FSNOTIFY_OBJ_TYPE_PARENT] =
+		iter_info.marks[FSNOTIFY_ITER_TYPE_PARENT] =
 			fsnotify_first_mark(&parent->i_fsnotify_marks);
 	}
 
diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 7c0946e16918a..b42629d2fc1c6 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -353,7 +353,7 @@ bool fsnotify_prepare_user_wait(struct fsnotify_iter_info *iter_info)
 {
 	int type;
 
-	fsnotify_foreach_obj_type(type) {
+	fsnotify_foreach_iter_type(type) {
 		/* This can fail if mark is being removed */
 		if (!fsnotify_get_mark_safe(iter_info->marks[type])) {
 			__release(&fsnotify_mark_srcu);
@@ -382,7 +382,7 @@ void fsnotify_finish_user_wait(struct fsnotify_iter_info *iter_info)
 	int type;
 
 	iter_info->srcu_idx = srcu_read_lock(&fsnotify_mark_srcu);
-	fsnotify_foreach_obj_type(type)
+	fsnotify_foreach_iter_type(type)
 		fsnotify_put_mark_wake(iter_info->marks[type]);
 }
 
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index b9c84b1dbcc8f..73739fee1710f 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -337,10 +337,25 @@ static inline struct fs_error_report *fsnotify_data_error_report(
 	}
 }
 
+/*
+ * Index to merged marks iterator array that correlates to a type of watch.
+ * The type of watched object can be deduced from the iterator type, but not
+ * the other way around, because an event can match different watched objects
+ * of the same object type.
+ * For example, both parent and child are watching an object of type inode.
+ */
+enum fsnotify_iter_type {
+	FSNOTIFY_ITER_TYPE_INODE,
+	FSNOTIFY_ITER_TYPE_VFSMOUNT,
+	FSNOTIFY_ITER_TYPE_SB,
+	FSNOTIFY_ITER_TYPE_PARENT,
+	FSNOTIFY_ITER_TYPE_COUNT
+};
+
+/* The type of object that a mark is attached to */
 enum fsnotify_obj_type {
 	FSNOTIFY_OBJ_TYPE_ANY = -1,
 	FSNOTIFY_OBJ_TYPE_INODE,
-	FSNOTIFY_OBJ_TYPE_PARENT,
 	FSNOTIFY_OBJ_TYPE_VFSMOUNT,
 	FSNOTIFY_OBJ_TYPE_SB,
 	FSNOTIFY_OBJ_TYPE_COUNT,
@@ -353,37 +368,37 @@ static inline bool fsnotify_valid_obj_type(unsigned int obj_type)
 }
 
 struct fsnotify_iter_info {
-	struct fsnotify_mark *marks[FSNOTIFY_OBJ_TYPE_COUNT];
+	struct fsnotify_mark *marks[FSNOTIFY_ITER_TYPE_COUNT];
 	unsigned int report_mask;
 	int srcu_idx;
 };
 
 static inline bool fsnotify_iter_should_report_type(
-		struct fsnotify_iter_info *iter_info, int type)
+		struct fsnotify_iter_info *iter_info, int iter_type)
 {
-	return (iter_info->report_mask & (1U << type));
+	return (iter_info->report_mask & (1U << iter_type));
 }
 
 static inline void fsnotify_iter_set_report_type(
-		struct fsnotify_iter_info *iter_info, int type)
+		struct fsnotify_iter_info *iter_info, int iter_type)
 {
-	iter_info->report_mask |= (1U << type);
+	iter_info->report_mask |= (1U << iter_type);
 }
 
 static inline void fsnotify_iter_set_report_type_mark(
-		struct fsnotify_iter_info *iter_info, int type,
+		struct fsnotify_iter_info *iter_info, int iter_type,
 		struct fsnotify_mark *mark)
 {
-	iter_info->marks[type] = mark;
-	iter_info->report_mask |= (1U << type);
+	iter_info->marks[iter_type] = mark;
+	iter_info->report_mask |= (1U << iter_type);
 }
 
 #define FSNOTIFY_ITER_FUNCS(name, NAME) \
 static inline struct fsnotify_mark *fsnotify_iter_##name##_mark( \
 		struct fsnotify_iter_info *iter_info) \
 { \
-	return (iter_info->report_mask & (1U << FSNOTIFY_OBJ_TYPE_##NAME)) ? \
-		iter_info->marks[FSNOTIFY_OBJ_TYPE_##NAME] : NULL; \
+	return (iter_info->report_mask & (1U << FSNOTIFY_ITER_TYPE_##NAME)) ? \
+		iter_info->marks[FSNOTIFY_ITER_TYPE_##NAME] : NULL; \
 }
 
 FSNOTIFY_ITER_FUNCS(inode, INODE)
@@ -391,8 +406,8 @@ FSNOTIFY_ITER_FUNCS(parent, PARENT)
 FSNOTIFY_ITER_FUNCS(vfsmount, VFSMOUNT)
 FSNOTIFY_ITER_FUNCS(sb, SB)
 
-#define fsnotify_foreach_obj_type(type) \
-	for (type = 0; type < FSNOTIFY_OBJ_TYPE_COUNT; type++)
+#define fsnotify_foreach_iter_type(type) \
+	for (type = 0; type < FSNOTIFY_ITER_TYPE_COUNT; type++)
 
 /*
  * fsnotify_connp_t is what we embed in objects which connector can be attached
-- 
2.43.0



