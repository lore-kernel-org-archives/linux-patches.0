Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8D91EB5A;
	Mon,  4 Mar 2024 21:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588994; cv=none; b=iFYFSv1AUWp2HYSf5QhaJwRDmpXwiXwvRNLTEQ0O5penZLm3onvspwa2JOSvM1Qqu8QFo20iWe8w7tNjLGVmtbN+/YslTSEm0/QAyUitmOXBiriD0SJsmLQirr9tgoo7ce8N5TJl8qUIwDr5iWOqU7HMXbHrf5wsSDRLDFBzLvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588994; c=relaxed/simple;
	bh=C+0gaTUP7OET8uzvKqjVONICOajlnwP6vWgFmqtIpUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITBQOKT40JrUYhI/3Zbo9rFZGfs0VTvGxXrhdAsoJnuFRULeC7vtUHtL01V5g39DW49BbdD6uPAKPx4b9sPvpvUPdzPHLYttHpR2tbViyJwSAy+r1qLQIJ6Ge78J7wcIDYO99urWmClC8AQ6Bj2VGgvZI4yzW2J4WvH7kM50Vgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RC3C1zt9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RC3C1zt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53A1C433F1;
	Mon,  4 Mar 2024 21:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588994;
	bh=C+0gaTUP7OET8uzvKqjVONICOajlnwP6vWgFmqtIpUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RC3C1zt9P6GOzlMmvtrlxZRPQJxctT3keX6bzhfziMgH2rJR73uh/I8l+3mx6y+2z
	 dT1/WnXUaUwJXCeMQHB++ya4rhhdjbSwnQ5Ba9ZzLPAPQ3ynKtfiZ3sx6vgR7KQRhH
	 Vq5jZcEzqB8MDkazyLVrXEz9WgchFBNN2/X+MgY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 161/215] filelock: add a new locks_inode_context accessor function
Date: Mon,  4 Mar 2024 21:23:44 +0000
Message-ID: <20240304211602.093712575@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/locks.c         |   24 ++++++++++++------------
 include/linux/fs.h |   14 ++++++++++++++
 2 files changed, 26 insertions(+), 12 deletions(-)

--- a/fs/locks.c
+++ b/fs/locks.c
@@ -175,7 +175,7 @@ locks_get_lock_context(struct inode *ino
 	struct file_lock_context *ctx;
 
 	/* paired with cmpxchg() below */
-	ctx = smp_load_acquire(&inode->i_flctx);
+	ctx = locks_inode_context(inode);
 	if (likely(ctx) || type == F_UNLCK)
 		goto out;
 
@@ -194,7 +194,7 @@ locks_get_lock_context(struct inode *ino
 	 */
 	if (cmpxchg(&inode->i_flctx, NULL, ctx)) {
 		kmem_cache_free(flctx_cache, ctx);
-		ctx = smp_load_acquire(&inode->i_flctx);
+		ctx = locks_inode_context(inode);
 	}
 out:
 	trace_locks_get_lock_context(inode, type, ctx);
@@ -247,7 +247,7 @@ locks_check_ctx_file_list(struct file *f
 void
 locks_free_lock_context(struct inode *inode)
 {
-	struct file_lock_context *ctx = inode->i_flctx;
+	struct file_lock_context *ctx = locks_inode_context(inode);
 
 	if (unlikely(ctx)) {
 		locks_check_ctx_lists(inode);
@@ -891,7 +891,7 @@ posix_test_lock(struct file *filp, struc
 	void *owner;
 	void (*func)(void);
 
-	ctx = smp_load_acquire(&inode->i_flctx);
+	ctx = locks_inode_context(inode);
 	if (!ctx || list_empty_careful(&ctx->flc_posix)) {
 		fl->fl_type = F_UNLCK;
 		return;
@@ -1483,7 +1483,7 @@ int __break_lease(struct inode *inode, u
 	new_fl->fl_flags = type;
 
 	/* typically we will check that ctx is non-NULL before calling */
-	ctx = smp_load_acquire(&inode->i_flctx);
+	ctx = locks_inode_context(inode);
 	if (!ctx) {
 		WARN_ON_ONCE(1);
 		goto free_lock;
@@ -1588,7 +1588,7 @@ void lease_get_mtime(struct inode *inode
 	struct file_lock_context *ctx;
 	struct file_lock *fl;
 
-	ctx = smp_load_acquire(&inode->i_flctx);
+	ctx = locks_inode_context(inode);
 	if (ctx && !list_empty_careful(&ctx->flc_lease)) {
 		spin_lock(&ctx->flc_lock);
 		fl = list_first_entry_or_null(&ctx->flc_lease,
@@ -1634,7 +1634,7 @@ int fcntl_getlease(struct file *filp)
 	int type = F_UNLCK;
 	LIST_HEAD(dispose);
 
-	ctx = smp_load_acquire(&inode->i_flctx);
+	ctx = locks_inode_context(inode);
 	if (ctx && !list_empty_careful(&ctx->flc_lease)) {
 		percpu_down_read(&file_rwsem);
 		spin_lock(&ctx->flc_lock);
@@ -1823,7 +1823,7 @@ static int generic_delete_lease(struct f
 	struct file_lock_context *ctx;
 	LIST_HEAD(dispose);
 
-	ctx = smp_load_acquire(&inode->i_flctx);
+	ctx = locks_inode_context(inode);
 	if (!ctx) {
 		trace_generic_delete_lease(inode, NULL);
 		return error;
@@ -2562,7 +2562,7 @@ void locks_remove_posix(struct file *fil
 	 * posix_lock_file().  Another process could be setting a lock on this
 	 * file at the same time, but we wouldn't remove that lock anyway.
 	 */
-	ctx =  smp_load_acquire(&inode->i_flctx);
+	ctx = locks_inode_context(inode);
 	if (!ctx || list_empty(&ctx->flc_posix))
 		return;
 
@@ -2635,7 +2635,7 @@ void locks_remove_file(struct file *filp
 {
 	struct file_lock_context *ctx;
 
-	ctx = smp_load_acquire(&locks_inode(filp)->i_flctx);
+	ctx = locks_inode_context(locks_inode(filp));
 	if (!ctx)
 		return;
 
@@ -2682,7 +2682,7 @@ bool vfs_inode_has_locks(struct inode *i
 	struct file_lock_context *ctx;
 	bool ret;
 
-	ctx = smp_load_acquire(&inode->i_flctx);
+	ctx = locks_inode_context(inode);
 	if (!ctx)
 		return false;
 
@@ -2863,7 +2863,7 @@ void show_fd_locks(struct seq_file *f,
 	struct file_lock_context *ctx;
 	int id = 0;
 
-	ctx = smp_load_acquire(&inode->i_flctx);
+	ctx = locks_inode_context(inode);
 	if (!ctx)
 		return;
 
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1189,6 +1189,13 @@ extern void show_fd_locks(struct seq_fil
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
@@ -1334,6 +1341,13 @@ static inline bool locks_owner_has_block
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


