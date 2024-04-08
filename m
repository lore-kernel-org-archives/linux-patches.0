Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C397C0A9;
	Mon,  8 Apr 2024 13:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584600; cv=none; b=gsg/YEMp186sCpIea16WBPvsQP1B5Xvjo1PhqLXmrl65AKcvMzOqHSkIH3lHw7DbXzex4eovO7T6MH0PtyzX3EJ9mBa8c5D5Hl43uoVYhYDhX8F5L2gGw6AgWb+MW3tiTcWAAks0X5ys8frHqm9p1YDxLTmrlHZ61f+3bvoGF/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584600; c=relaxed/simple;
	bh=21WdDhVt549/+0Gy9+mDe3/UbBk4SSIlfJXRqrQuXLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AnfvObB/FUn4ALjzKJvAALbDvJCdoxffo8cqDsRdvJBWqL0m8NK95MwVwGKckBy/hDOB9Md1uhPuEgGI5g9jNJZmUF/8/F1YDJPhivkWcr3fVxA2mlyh2NY4+4G63HwxxtlJSvfI+E2Iygo39APv0CFe2Xila71h2GwC3xjIZ1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VT4DDOk1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VT4DDOk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C71C43390;
	Mon,  8 Apr 2024 13:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584600;
	bh=21WdDhVt549/+0Gy9+mDe3/UbBk4SSIlfJXRqrQuXLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VT4DDOk11wNWICMjYUNYuay+1euOHdysOqyyiI0akyHjabCJD7Sn5Y2l6Lfkmjprc
	 T6vkVDLMZHfVCDauHyR5sXN69yFggsGzkdtMQLUuSdGgxFW1JSC5YPryNC0yy+1+kz
	 csFB2uLuFO7ZXPY/o4N5KarwxktDLGobAfRWn2s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 494/690] filelock: add a new locks_inode_context accessor function
Date: Mon,  8 Apr 2024 14:56:00 +0200
Message-ID: <20240408125417.531362312@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 401a8b8fd5acd51582b15238d72a8d0edd580e9f ]

There are a number of places in the kernel that are accessing the
inode->i_flctx field without smp_load_acquire. This is required to
ensure that the caller doesn't see a partially-initialized structure.

Add a new accessor function for it to make this clear and convert all of
the relevant accesses in locks.c to use it. Also, convert
locks_free_lock_context to use the helper as well instead of just doing
a "bare" assignment.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Stable-dep-of: 77c67530e1f9 ("nfsd: use locks_inode_context helper")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/locks.c         | 24 ++++++++++++------------
 include/linux/fs.h | 14 ++++++++++++++
 2 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 317c2ec17b943..77781b71bcaab 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -251,7 +251,7 @@ locks_get_lock_context(struct inode *inode, int type)
 	struct file_lock_context *ctx;
 
 	/* paired with cmpxchg() below */
-	ctx = smp_load_acquire(&inode->i_flctx);
+	ctx = locks_inode_context(inode);
 	if (likely(ctx) || type == F_UNLCK)
 		goto out;
 
@@ -270,7 +270,7 @@ locks_get_lock_context(struct inode *inode, int type)
 	 */
 	if (cmpxchg(&inode->i_flctx, NULL, ctx)) {
 		kmem_cache_free(flctx_cache, ctx);
-		ctx = smp_load_acquire(&inode->i_flctx);
+		ctx = locks_inode_context(inode);
 	}
 out:
 	trace_locks_get_lock_context(inode, type, ctx);
@@ -323,7 +323,7 @@ locks_check_ctx_file_list(struct file *filp, struct list_head *list,
 void
 locks_free_lock_context(struct inode *inode)
 {
-	struct file_lock_context *ctx = inode->i_flctx;
+	struct file_lock_context *ctx = locks_inode_context(inode);
 
 	if (unlikely(ctx)) {
 		locks_check_ctx_lists(inode);
@@ -985,7 +985,7 @@ posix_test_lock(struct file *filp, struct file_lock *fl)
 	void *owner;
 	void (*func)(void);
 
-	ctx = smp_load_acquire(&inode->i_flctx);
+	ctx = locks_inode_context(inode);
 	if (!ctx || list_empty_careful(&ctx->flc_posix)) {
 		fl->fl_type = F_UNLCK;
 		return;
@@ -1577,7 +1577,7 @@ int __break_lease(struct inode *inode, unsigned int mode, unsigned int type)
 	new_fl->fl_flags = type;
 
 	/* typically we will check that ctx is non-NULL before calling */
-	ctx = smp_load_acquire(&inode->i_flctx);
+	ctx = locks_inode_context(inode);
 	if (!ctx) {
 		WARN_ON_ONCE(1);
 		goto free_lock;
@@ -1682,7 +1682,7 @@ void lease_get_mtime(struct inode *inode, struct timespec64 *time)
 	struct file_lock_context *ctx;
 	struct file_lock *fl;
 
-	ctx = smp_load_acquire(&inode->i_flctx);
+	ctx = locks_inode_context(inode);
 	if (ctx && !list_empty_careful(&ctx->flc_lease)) {
 		spin_lock(&ctx->flc_lock);
 		fl = list_first_entry_or_null(&ctx->flc_lease,
@@ -1728,7 +1728,7 @@ int fcntl_getlease(struct file *filp)
 	int type = F_UNLCK;
 	LIST_HEAD(dispose);
 
-	ctx = smp_load_acquire(&inode->i_flctx);
+	ctx = locks_inode_context(inode);
 	if (ctx && !list_empty_careful(&ctx->flc_lease)) {
 		percpu_down_read(&file_rwsem);
 		spin_lock(&ctx->flc_lock);
@@ -1917,7 +1917,7 @@ static int generic_delete_lease(struct file *filp, void *owner)
 	struct file_lock_context *ctx;
 	LIST_HEAD(dispose);
 
-	ctx = smp_load_acquire(&inode->i_flctx);
+	ctx = locks_inode_context(inode);
 	if (!ctx) {
 		trace_generic_delete_lease(inode, NULL);
 		return error;
@@ -2651,7 +2651,7 @@ void locks_remove_posix(struct file *filp, fl_owner_t owner)
 	 * posix_lock_file().  Another process could be setting a lock on this
 	 * file at the same time, but we wouldn't remove that lock anyway.
 	 */
-	ctx =  smp_load_acquire(&inode->i_flctx);
+	ctx = locks_inode_context(inode);
 	if (!ctx || list_empty(&ctx->flc_posix))
 		return;
 
@@ -2724,7 +2724,7 @@ void locks_remove_file(struct file *filp)
 {
 	struct file_lock_context *ctx;
 
-	ctx = smp_load_acquire(&locks_inode(filp)->i_flctx);
+	ctx = locks_inode_context(locks_inode(filp));
 	if (!ctx)
 		return;
 
@@ -2771,7 +2771,7 @@ bool vfs_inode_has_locks(struct inode *inode)
 	struct file_lock_context *ctx;
 	bool ret;
 
-	ctx = smp_load_acquire(&inode->i_flctx);
+	ctx = locks_inode_context(inode);
 	if (!ctx)
 		return false;
 
@@ -2962,7 +2962,7 @@ void show_fd_locks(struct seq_file *f,
 	struct file_lock_context *ctx;
 	int id = 0;
 
-	ctx = smp_load_acquire(&inode->i_flctx);
+	ctx = locks_inode_context(inode);
 	if (!ctx)
 		return;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ef5a04d626953..61e86502fe65e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1217,6 +1217,13 @@ extern void show_fd_locks(struct seq_file *f,
 			 struct file *filp, struct files_struct *files);
 extern bool locks_owner_has_blockers(struct file_lock_context *flctx,
 			fl_owner_t owner);
+
+static inline struct file_lock_context *
+locks_inode_context(const struct inode *inode)
+{
+	return smp_load_acquire(&inode->i_flctx);
+}
+
 #else /* !CONFIG_FILE_LOCKING */
 static inline int fcntl_getlk(struct file *file, unsigned int cmd,
 			      struct flock __user *user)
@@ -1362,6 +1369,13 @@ static inline bool locks_owner_has_blockers(struct file_lock_context *flctx,
 {
 	return false;
 }
+
+static inline struct file_lock_context *
+locks_inode_context(const struct inode *inode)
+{
+	return NULL;
+}
+
 #endif /* !CONFIG_FILE_LOCKING */
 
 static inline struct inode *file_inode(const struct file *f)
-- 
2.43.0



