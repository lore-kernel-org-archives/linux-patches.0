Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7591513792B;
	Tue, 18 Jun 2024 13:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716543; cv=none; b=VYNpY+qLKe2l8uf4/CkHkdXhfC9zA46qv6uah+mKJ8llCv2XrlRz+5koldlaNVgn92R/znh+zZ+Dm+A1YfRcQIDSaJnP4MsJcxE5t/jRJHMpf376ADMiS7tYXa/2kfikFyAOyFInKcQSFQ5pw6qLokg5EQ1+4klBlcXehz54qB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716543; c=relaxed/simple;
	bh=cMFe4tdih+DWLyXe+oJ+ZdUE4wxDpFJt4GneEIsaY/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EM2rqJDhVbVul4lH8YFJ7iB7US0uZz6SitumQRvRFYE+P/eJgsggBuSRe4DhbiT0JokA7sE6bwLN5YrgfRK9xpAFdIs+NvqtELc31hEWyTcD83P0Agagme5tewR1L5YUznnckVcGb842hdVMvqG0PHg3ClU6ejXnlC8XPiAr1Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FRhe3F2L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FRhe3F2L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F361AC3277B;
	Tue, 18 Jun 2024 13:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716543;
	bh=cMFe4tdih+DWLyXe+oJ+ZdUE4wxDpFJt4GneEIsaY/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FRhe3F2LdIoE0WqL4igSwQXtbUAlhbrcCErTH2ux+MNvsBO0hjGvBfbS7XoTiIXsD
	 ybBZezYzPsJmzcpFojh6fA3Me0PMGdtAV2PB9aVbmKckojQYj5xluqCNCDXCotWdiy
	 UsSXdIS27SwBC0TiA2hlTvUfTjMabjWaAs6w4R24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 679/770] filelock: add a new locks_inode_context accessor function
Date: Tue, 18 Jun 2024 14:38:52 +0200
Message-ID: <20240618123433.487647672@linuxfoundation.org>
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
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/locks.c         | 24 ++++++++++++------------
 include/linux/fs.h | 14 ++++++++++++++
 2 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 13a3ba97b73d1..b0753c8871fb2 100644
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
@@ -1674,7 +1674,7 @@ int __break_lease(struct inode *inode, unsigned int mode, unsigned int type)
 	new_fl->fl_flags = type;
 
 	/* typically we will check that ctx is non-NULL before calling */
-	ctx = smp_load_acquire(&inode->i_flctx);
+	ctx = locks_inode_context(inode);
 	if (!ctx) {
 		WARN_ON_ONCE(1);
 		goto free_lock;
@@ -1779,7 +1779,7 @@ void lease_get_mtime(struct inode *inode, struct timespec64 *time)
 	struct file_lock_context *ctx;
 	struct file_lock *fl;
 
-	ctx = smp_load_acquire(&inode->i_flctx);
+	ctx = locks_inode_context(inode);
 	if (ctx && !list_empty_careful(&ctx->flc_lease)) {
 		spin_lock(&ctx->flc_lock);
 		fl = list_first_entry_or_null(&ctx->flc_lease,
@@ -1825,7 +1825,7 @@ int fcntl_getlease(struct file *filp)
 	int type = F_UNLCK;
 	LIST_HEAD(dispose);
 
-	ctx = smp_load_acquire(&inode->i_flctx);
+	ctx = locks_inode_context(inode);
 	if (ctx && !list_empty_careful(&ctx->flc_lease)) {
 		percpu_down_read(&file_rwsem);
 		spin_lock(&ctx->flc_lock);
@@ -2014,7 +2014,7 @@ static int generic_delete_lease(struct file *filp, void *owner)
 	struct file_lock_context *ctx;
 	LIST_HEAD(dispose);
 
-	ctx = smp_load_acquire(&inode->i_flctx);
+	ctx = locks_inode_context(inode);
 	if (!ctx) {
 		trace_generic_delete_lease(inode, NULL);
 		return error;
@@ -2765,7 +2765,7 @@ void locks_remove_posix(struct file *filp, fl_owner_t owner)
 	 * posix_lock_file().  Another process could be setting a lock on this
 	 * file at the same time, but we wouldn't remove that lock anyway.
 	 */
-	ctx =  smp_load_acquire(&inode->i_flctx);
+	ctx = locks_inode_context(inode);
 	if (!ctx || list_empty(&ctx->flc_posix))
 		return;
 
@@ -2838,7 +2838,7 @@ void locks_remove_file(struct file *filp)
 {
 	struct file_lock_context *ctx;
 
-	ctx = smp_load_acquire(&locks_inode(filp)->i_flctx);
+	ctx = locks_inode_context(locks_inode(filp));
 	if (!ctx)
 		return;
 
@@ -2885,7 +2885,7 @@ bool vfs_inode_has_locks(struct inode *inode)
 	struct file_lock_context *ctx;
 	bool ret;
 
-	ctx = smp_load_acquire(&inode->i_flctx);
+	ctx = locks_inode_context(inode);
 	if (!ctx)
 		return false;
 
@@ -3030,7 +3030,7 @@ void show_fd_locks(struct seq_file *f,
 	struct file_lock_context *ctx;
 	int id = 0;
 
-	ctx = smp_load_acquire(&inode->i_flctx);
+	ctx = locks_inode_context(inode);
 	if (!ctx)
 		return;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7e7098bf2c57e..6a26ef54ac25d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1168,6 +1168,13 @@ extern void show_fd_locks(struct seq_file *f,
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
@@ -1313,6 +1320,13 @@ static inline bool locks_owner_has_blockers(struct file_lock_context *flctx,
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



