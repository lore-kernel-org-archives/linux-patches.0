Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778A646A5FB;
	Tue, 21 Jul 2026 15:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649269; cv=none; b=cMkVMKFl4nYs+jVjKcxJlLSC40sdXbJdh0I9/Q7uHKSaIlj6zwbu5Ez7fzcxCzSznE/KvNxwJlDMYdRPdOkQaeDtwIjH/wJgUtckIMVXcilfTOJ6YEETrScj+H23GrB1L1YliB4e+gt6OObOPj3eSV5JUizEJGYl7tHbJ38tEwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649269; c=relaxed/simple;
	bh=JB6GzZvGe8XxsrmjM860MVunBLIcZSDxwoQ2SFy+s8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJDXSiT1GMvdxDuWTKtUr3VWarJxQWkPuq2Avhzh/M8+71/JOBaQwbPgNdxV5IBWQONbkqjrRzxe98BNHcdqmxm2Gh2gFpXQ8jxmZ3tW2kO6+wwvkFFV1EPa/sXttW8IvfS46FUvL+7PWrK5C8IgVmMWLA57IQMvetNj6xm1tLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KRykucHV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KRykucHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78841F00A3A;
	Tue, 21 Jul 2026 15:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649268;
	bh=shs6jRigbq7G4ZYRWbR8id9FxyGNDUnH4+8Hb9c2xBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KRykucHVFIXiQe97iVeBmXfuFlSE3Q1ye+AyTTdq73m4ywhauiAQUZlRAaxBRUTWo
	 hEsBZDkIIGsE7trCMjbqFF5F07HFQRBxiePIgF6aLmxTr3GjKuGeJvgYFvscJV12um
	 7q8J479OUPd5BBPI9Q3w3subi00m7sO42xB1iH70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Miklos Szeredi <mszeredi@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0515/2077] kernfs: fix xattr race condition with multiple superblocks
Date: Tue, 21 Jul 2026 17:03:08 +0200
Message-ID: <20260721152604.957343106@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 6a07814ff643b5c8e1353d8c6229f52fde205cde ]

Multiple superblocks with different namespaces can share the same
kernfs_node when kernfs_test_super() finds a matching root but
different namespace. This means multiple inodes from different
superblocks can reference the same kernfs_node->iattr->xattrs
structure.

The VFS layer only holds per-inode locks during xattr operations,
which is insufficient to serialize concurrent xattr modifications on
the shared kernfs_node. This can lead to race conditions in
simple_xattr_set() where the lookup->replace/remove sequence is not
atomic with respect to operations from other superblocks.

Fix this by protecting xattr operations with the existing hashed
kernfs_locks->open_file_mutex[] array, which is already used to
protect per-node open file data. The hashed mutex array provides
scalable per-node serialization (scaled by CPU count, up to 1024 locks
on 32+ CPU systems) with zero memory overhead.

Changes:
- Rename open_file_mutex[] to node_mutex[] to reflect dual purpose
- Add kernfs_node_lock_ptr() and kernfs_node_lock() helpers
- Protect simple_xattr_set() calls in kernfs_xattr_set() and
  kernfs_vfs_user_xattr_set() with the hashed mutex
- Update file.c to use new helpers via compatibility wrappers
- Update documentation to explain the extended lock usage

Fixes: b32c4a213698 ("xattr: add rhashtable-based simple_xattr infrastructure")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260601162454.2116375-1-mszeredi%40redhat.com
Assisted-by: Claude:claude-sonnet-4-5
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Link: https://patch.msgid.link/20260605135322.2632068-2-mszeredi@redhat.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/kernfs/file.c            | 13 +++----------
 fs/kernfs/inode.c           | 12 ++++++++++++
 fs/kernfs/kernfs-internal.h | 20 ++++++++++++++++++++
 fs/kernfs/mount.c           |  2 +-
 include/linux/kernfs.h      | 11 ++++++++---
 5 files changed, 44 insertions(+), 14 deletions(-)

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 1163aa76973849..8e0e90c933720b 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -40,22 +40,15 @@ struct kernfs_open_node {
 static DEFINE_SPINLOCK(kernfs_notify_lock);
 static struct kernfs_node *kernfs_notify_list = KERNFS_NOTIFY_EOL;
 
+/* Compatibility wrappers - use the common hashed node lock */
 static inline struct mutex *kernfs_open_file_mutex_ptr(struct kernfs_node *kn)
 {
-	int idx = hash_ptr(kn, NR_KERNFS_LOCK_BITS);
-
-	return &kernfs_locks->open_file_mutex[idx];
+	return kernfs_node_lock_ptr(kn);
 }
 
 static inline struct mutex *kernfs_open_file_mutex_lock(struct kernfs_node *kn)
 {
-	struct mutex *lock;
-
-	lock = kernfs_open_file_mutex_ptr(kn);
-
-	mutex_lock(lock);
-
-	return lock;
+	return kernfs_node_lock(kn);
 }
 
 /**
diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index 38b28aa7cd023f..e676737d9531a7 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -320,6 +320,15 @@ int kernfs_xattr_set(struct kernfs_node *kn, const char *name,
 	if (!attrs)
 		return -ENOMEM;
 
+	/*
+	 * Protect xattr modifications with the hashed per-node mutex.
+	 * Multiple superblocks (with different namespaces) can share the same
+	 * kernfs_node, so inode locking alone is insufficient. The hashed mutex
+	 * ensures serialization of concurrent xattr operations on the same node,
+	 * including the lazy allocation of the xattrs structure itself.
+	 */
+	CLASS(kernfs_node_lock, lock)(kn);
+
 	xattrs = simple_xattrs_lazy_alloc(&attrs->xattrs, value, flags);
 	if (IS_ERR_OR_NULL(xattrs))
 		return PTR_ERR(xattrs);
@@ -372,6 +381,9 @@ static int kernfs_vfs_user_xattr_set(const struct xattr_handler *handler,
 	if (!attrs)
 		return -ENOMEM;
 
+	/* See comment in kernfs_xattr_set() about locking. */
+	CLASS(kernfs_node_lock, lock)(kn);
+
 	xattrs = simple_xattrs_lazy_alloc(&attrs->xattrs, value, flags);
 	if (IS_ERR_OR_NULL(xattrs))
 		return PTR_ERR(xattrs);
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index 8d8912f50b054d..1dc6663553d1a5 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -211,4 +211,24 @@ extern const struct inode_operations kernfs_symlink_iops;
  * kernfs locks
  */
 extern struct kernfs_global_locks *kernfs_locks;
+
+/* Hashed mutex helpers - protect per-node data structures */
+static inline struct mutex *kernfs_node_lock_ptr(struct kernfs_node *kn)
+{
+	int idx = hash_ptr(kn, NR_KERNFS_LOCK_BITS);
+
+	return &kernfs_locks->node_mutex[idx];
+}
+
+static inline struct mutex *kernfs_node_lock(struct kernfs_node *kn)
+{
+	struct mutex *lock = kernfs_node_lock_ptr(kn);
+
+	mutex_lock(lock);
+	return lock;
+}
+
+DEFINE_CLASS(kernfs_node_lock, struct mutex *,
+	     mutex_unlock(_T), kernfs_node_lock(kn), struct kernfs_node *kn)
+
 #endif	/* __KERNFS_INTERNAL_H */
diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index 6e3217b6e4811a..f183a96778b9a2 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -446,7 +446,7 @@ static void __init kernfs_mutex_init(void)
 	int count;
 
 	for (count = 0; count < NR_KERNFS_LOCKS; count++)
-		mutex_init(&kernfs_locks->open_file_mutex[count]);
+		mutex_init(&kernfs_locks->node_mutex[count]);
 }
 
 static void __init kernfs_lock_init(void)
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index e21b2f7f4159fe..351a5101c86287 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -76,20 +76,25 @@ struct kernfs_iattrs;
  * kernfs_open_file.
  *
  * kernfs_open_files are chained at kernfs_open_node->files, which is
- * protected by kernfs_global_locks.open_file_mutex[i].
+ * protected by kernfs_global_locks.node_mutex[i].
  *
  * To reduce possible contention in sysfs access, arising due to single
- * locks, use an array of locks (e.g. open_file_mutex) and use kernfs_node
+ * locks, use an array of locks (e.g. node_mutex) and use kernfs_node
  * object address as hash keys to get the index of these locks.
  *
  * Hashed mutexes are safe to use here because operations using these don't
  * rely on global exclusion.
  *
+ * The hashed mutex array protects per-node data: the kernfs_open_node for
+ * open file management, and kernfs_node xattr operations (necessary because
+ * multiple superblocks with different namespaces can share the same
+ * kernfs_node, making per-inode locking insufficient).
+ *
  * In future we intend to replace other global locks with hashed ones as well.
  * kernfs_global_locks acts as a holder for all such hash tables.
  */
 struct kernfs_global_locks {
-	struct mutex open_file_mutex[NR_KERNFS_LOCKS];
+	struct mutex node_mutex[NR_KERNFS_LOCKS];
 };
 
 enum kernfs_node_type {
-- 
2.53.0



