Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE097C0B0;
	Mon,  8 Apr 2024 13:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583812; cv=none; b=qzFja9eFjZyDeDS9q6n0uT8h5B/+dgLks0eF6Pif04kxIqd2D0f2Jr3VDqRB+s+2ZttFsGYQ6pCMN354FtarqbKN0x1/1bFPYyjoN7zHuYQlUZHHjffJmATPdhoOIpnR6znN/4YCMtC9co4V2jxJ5ZOoc4uTZNhHsyUel7HCgsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583812; c=relaxed/simple;
	bh=uaBD3UkWurr9dQ2Qf97MeL8bJ8z/T+jw6zW1J0kSys0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1Gq4KhbnLoLDV+0PZMNBJd6OZ3QQtcvc2Yv2O8z3gs74v0PKwW8dpE3ajNzyelgPCwN4XSfEiVVpz8la0HbhDDqzvqHT5MQnRjGaKIvmjmthEEMqeaRGb8YPQBgTuwyeuvC5s0KuVmdTDnHdwC7jDvJpwC0PjlqEhG1G1OBhts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X8ybLF6L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X8ybLF6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23463C433F1;
	Mon,  8 Apr 2024 13:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583812;
	bh=uaBD3UkWurr9dQ2Qf97MeL8bJ8z/T+jw6zW1J0kSys0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X8ybLF6LrBIL4BC3gs/KvArPCj3yrxfb/OnsgM4r59LGZKxAHh73pPl4EoZdbfVl0
	 0v35mUjGMHyXG8PWkVNiiFnNfyay+Sbl6vTq7DOVpUtkNa0sjFmEWq1m4Gou+hlxmn
	 lcMpa1UDZXKZ+s+Giv6KbQD4Rgf7xzCW2AsBmtpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 291/690] fsnotify: pass flags argument to fsnotify_alloc_group()
Date: Mon,  8 Apr 2024 14:52:37 +0200
Message-ID: <20240408125410.143737855@linuxfoundation.org>
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
index 429ae485ebbbe..97ca256a76323 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -671,7 +671,8 @@ nfsd_file_cache_init(void)
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
index 336ccec2abed3..f23326be0d371 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1351,7 +1351,8 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
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
index fdce87902b382..0d8e1bead23ea 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -648,7 +648,8 @@ static struct fsnotify_group *inotify_new_group(unsigned int max_events)
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
index 7a506b65e8630..8dee00959eb3d 100644
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
index 2cd7b5694422d..18ab4575ae009 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -1073,7 +1073,7 @@ static int __init audit_tree_init(void)
 
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



