Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE2813C660;
	Tue, 18 Jun 2024 13:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715985; cv=none; b=LkvuFxuVePs0oWGz59CQ8zOUQMMsgPnvhT4v+kXltiEMVG9q8dEawnrt/0dVm7dKep30RWaudnnVTvJ3mhOg2WArAVCQ6IJwX37EJA3n9/s+at7Od73y8HmUuEgBCvUnTHaFTf34OV3OYub1h8AFfSfEO76wE3Ab7z9ut6ycnQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715985; c=relaxed/simple;
	bh=0PjwwsyItYC6i9fznwK8YV7T+dFgjTrUYv0vNrfQym4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTiTv8Vx4zu07QHCaiopa+nZGfYE15exr6xryCnLg8eb3s8XlfAUgEGQBWOUkiNbJGhxjC9S/TpzDFfOfrAJHBXSLcR/ERm5BU5nEMZl0DI6YLv+rZhB/tlwzsbTj4dY6QiS8hgsG9Q7noaQpZ+84vN4iVJxKzkbzqt2kZpFkcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVUF46Dn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVUF46Dn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414DDC3277B;
	Tue, 18 Jun 2024 13:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715985;
	bh=0PjwwsyItYC6i9fznwK8YV7T+dFgjTrUYv0vNrfQym4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gVUF46DnF3QhcDvemxFyxi5wmnq9Uh8FpdWGbG91BFxXSJ6tmL+X5XTyeJFklvXhY
	 ZHegfvp9h6qZJd8fmh+ZW/HV6DY6nfNrmPnB1JDRW3flKKM70P1fhJ0waa0UL6kq6x
	 imly+kzyu/kUxZebwqZiKZE7TmZ9YctIn8gibkcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 494/770] fsnotify: pass flags argument to fsnotify_alloc_group()
Date: Tue, 18 Jun 2024 14:35:47 +0200
Message-ID: <20240618123426.384316840@linuxfoundation.org>
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

[ Upstream commit 867a448d587e7fa845bceaf4ee1c632448f2a9fa ]

Add flags argument to fsnotify_alloc_group(), define and use the flag
FSNOTIFY_GROUP_USER in inotify and fanotify instead of the helper
fsnotify_alloc_user_group() to indicate user allocation.

Although the flag FSNOTIFY_GROUP_USER is currently not used after group
allocation, we store the flags argument in the group struct for future
use of other group flags.

Link: https://lore.kernel.org/r/20220422120327.3459282-5-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c                |  3 ++-
 fs/notify/dnotify/dnotify.c        |  2 +-
 fs/notify/fanotify/fanotify_user.c |  3 ++-
 fs/notify/group.c                  | 21 +++++++++------------
 fs/notify/inotify/inotify_user.c   |  3 ++-
 include/linux/fsnotify_backend.h   |  8 ++++++--
 kernel/audit_fsnotify.c            |  3 ++-
 kernel/audit_tree.c                |  2 +-
 kernel/audit_watch.c               |  2 +-
 9 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 8f7ed5dbb0031..7ae2b6611fb29 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -677,7 +677,8 @@ nfsd_file_cache_init(void)
 		goto out_shrinker;
 	}
 
-	nfsd_file_fsnotify_group = fsnotify_alloc_group(&nfsd_file_fsnotify_ops);
+	nfsd_file_fsnotify_group = fsnotify_alloc_group(&nfsd_file_fsnotify_ops,
+							0);
 	if (IS_ERR(nfsd_file_fsnotify_group)) {
 		pr_err("nfsd: unable to create fsnotify group: %ld\n",
 			PTR_ERR(nfsd_file_fsnotify_group));
diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index d5ebebb034ffe..6c586802c50e6 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -383,7 +383,7 @@ static int __init dnotify_init(void)
 					  SLAB_PANIC|SLAB_ACCOUNT);
 	dnotify_mark_cache = KMEM_CACHE(dnotify_mark, SLAB_PANIC|SLAB_ACCOUNT);
 
-	dnotify_group = fsnotify_alloc_group(&dnotify_fsnotify_ops);
+	dnotify_group = fsnotify_alloc_group(&dnotify_fsnotify_ops, 0);
 	if (IS_ERR(dnotify_group))
 		panic("unable to allocate fsnotify group for dnotify\n");
 	return 0;
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 921ee7b08580d..731bd7f64e018 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1343,7 +1343,8 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 		f_flags |= O_NONBLOCK;
 
 	/* fsnotify_alloc_group takes a ref.  Dropped in fanotify_release */
-	group = fsnotify_alloc_user_group(&fanotify_fsnotify_ops);
+	group = fsnotify_alloc_group(&fanotify_fsnotify_ops,
+				     FSNOTIFY_GROUP_USER);
 	if (IS_ERR(group)) {
 		return PTR_ERR(group);
 	}
diff --git a/fs/notify/group.c b/fs/notify/group.c
index b7d4d64f87c29..18446b7b0d495 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -112,7 +112,8 @@ void fsnotify_put_group(struct fsnotify_group *group)
 EXPORT_SYMBOL_GPL(fsnotify_put_group);
 
 static struct fsnotify_group *__fsnotify_alloc_group(
-				const struct fsnotify_ops *ops, gfp_t gfp)
+				const struct fsnotify_ops *ops,
+				int flags, gfp_t gfp)
 {
 	struct fsnotify_group *group;
 
@@ -133,6 +134,7 @@ static struct fsnotify_group *__fsnotify_alloc_group(
 	INIT_LIST_HEAD(&group->marks_list);
 
 	group->ops = ops;
+	group->flags = flags;
 
 	return group;
 }
@@ -140,20 +142,15 @@ static struct fsnotify_group *__fsnotify_alloc_group(
 /*
  * Create a new fsnotify_group and hold a reference for the group returned.
  */
-struct fsnotify_group *fsnotify_alloc_group(const struct fsnotify_ops *ops)
+struct fsnotify_group *fsnotify_alloc_group(const struct fsnotify_ops *ops,
+					    int flags)
 {
-	return __fsnotify_alloc_group(ops, GFP_KERNEL);
-}
-EXPORT_SYMBOL_GPL(fsnotify_alloc_group);
+	gfp_t gfp = (flags & FSNOTIFY_GROUP_USER) ? GFP_KERNEL_ACCOUNT :
+						    GFP_KERNEL;
 
-/*
- * Create a new fsnotify_group and hold a reference for the group returned.
- */
-struct fsnotify_group *fsnotify_alloc_user_group(const struct fsnotify_ops *ops)
-{
-	return __fsnotify_alloc_group(ops, GFP_KERNEL_ACCOUNT);
+	return __fsnotify_alloc_group(ops, flags, gfp);
 }
-EXPORT_SYMBOL_GPL(fsnotify_alloc_user_group);
+EXPORT_SYMBOL_GPL(fsnotify_alloc_group);
 
 int fsnotify_fasync(int fd, struct file *file, int on)
 {
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 861147e574581..9e1cf8392385a 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -643,7 +643,8 @@ static struct fsnotify_group *inotify_new_group(unsigned int max_events)
 	struct fsnotify_group *group;
 	struct inotify_event_info *oevent;
 
-	group = fsnotify_alloc_user_group(&inotify_fsnotify_ops);
+	group = fsnotify_alloc_group(&inotify_fsnotify_ops,
+				     FSNOTIFY_GROUP_USER);
 	if (IS_ERR(group))
 		return group;
 
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index b1c72edd97845..f0bf557af0091 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -210,6 +210,9 @@ struct fsnotify_group {
 	unsigned int priority;
 	bool shutdown;		/* group is being shut down, don't queue more events */
 
+#define FSNOTIFY_GROUP_USER	0x01 /* user allocated group */
+	int flags;
+
 	/* stores all fastpath marks assoc with this group so they can be cleaned on unregister */
 	struct mutex mark_mutex;	/* protect marks_list */
 	atomic_t user_waits;		/* Number of tasks waiting for user
@@ -543,8 +546,9 @@ static inline void fsnotify_update_flags(struct dentry *dentry)
 /* called from fsnotify listeners, such as fanotify or dnotify */
 
 /* create a new group */
-extern struct fsnotify_group *fsnotify_alloc_group(const struct fsnotify_ops *ops);
-extern struct fsnotify_group *fsnotify_alloc_user_group(const struct fsnotify_ops *ops);
+extern struct fsnotify_group *fsnotify_alloc_group(
+				const struct fsnotify_ops *ops,
+				int flags);
 /* get reference to a group */
 extern void fsnotify_get_group(struct fsnotify_group *group);
 /* drop reference on a group from fsnotify_alloc_group */
diff --git a/kernel/audit_fsnotify.c b/kernel/audit_fsnotify.c
index 76a5925b4e18d..31f43b1475404 100644
--- a/kernel/audit_fsnotify.c
+++ b/kernel/audit_fsnotify.c
@@ -182,7 +182,8 @@ static const struct fsnotify_ops audit_mark_fsnotify_ops = {
 
 static int __init audit_fsnotify_init(void)
 {
-	audit_fsnotify_group = fsnotify_alloc_group(&audit_mark_fsnotify_ops);
+	audit_fsnotify_group = fsnotify_alloc_group(&audit_mark_fsnotify_ops,
+						    0);
 	if (IS_ERR(audit_fsnotify_group)) {
 		audit_fsnotify_group = NULL;
 		audit_panic("cannot create audit fsnotify group");
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 39241207ec044..0c35879bbf7c3 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -1077,7 +1077,7 @@ static int __init audit_tree_init(void)
 
 	audit_tree_mark_cachep = KMEM_CACHE(audit_tree_mark, SLAB_PANIC);
 
-	audit_tree_group = fsnotify_alloc_group(&audit_tree_ops);
+	audit_tree_group = fsnotify_alloc_group(&audit_tree_ops, 0);
 	if (IS_ERR(audit_tree_group))
 		audit_panic("cannot initialize fsnotify group for rectree watches");
 
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index fd7b30a2d9a4b..5cf22fe301493 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -492,7 +492,7 @@ static const struct fsnotify_ops audit_watch_fsnotify_ops = {
 
 static int __init audit_watch_init(void)
 {
-	audit_watch_group = fsnotify_alloc_group(&audit_watch_fsnotify_ops);
+	audit_watch_group = fsnotify_alloc_group(&audit_watch_fsnotify_ops, 0);
 	if (IS_ERR(audit_watch_group)) {
 		audit_watch_group = NULL;
 		audit_panic("cannot create audit fsnotify group");
-- 
2.43.0



