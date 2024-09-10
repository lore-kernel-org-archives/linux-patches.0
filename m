Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511B518C025;
	Tue, 10 Sep 2024 10:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963157; cv=none; b=kNnMN6flKmLM4lqfd20FzmKG0drlTXG4W40s/X4feLPO8+zNkSr5FJpp0QVio+SD269qWvW4u0diSxylo8X1bf1VqKkBRzkhXpyDNTbz9QDdnn08IUXuk9bo/mSTFGAZfApqXmr7oj9rBW/gsVt3TRGYp1Xi69tNsUH9voVJdns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963157; c=relaxed/simple;
	bh=VNDKIEnWPeKRf+mW6atqeQHzVi7ZSdht0lDvFQm15qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmA+wTgxCFi7ktMXCFauXDyKzK+twcdaF842ruAf4JUR0wBv+4heyLeyipDOJabpm9fgik8asS32Y31n6jcq0M70EghRfBR7IFpblKuHitfXrBmjZq2JheDiMoPVitr2hCMnqOnSckrjBAgwRr0998nlmHhWzBZcZiKZpO1pi/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cE7AJ5mM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cE7AJ5mM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A21EC4CEC3;
	Tue, 10 Sep 2024 10:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963156;
	bh=VNDKIEnWPeKRf+mW6atqeQHzVi7ZSdht0lDvFQm15qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cE7AJ5mMLnhA0f5eGrjZZqFJW/22PsdyhSPg3jjuzvnFyq/XyOpBhjt/9kpw6II/7
	 OvhkNtY6MEyB6FDKdjT2rrYsXp1xGtSQTSUQKibe2o+sOmyOjb7C8rW0/7nZju+zoU
	 nuBCwQNrfSceIWZ5Hpfa9DxBoCy9UYTqe5xEdx54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakob Blomer <jblomer@cern.ch>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 154/192] fuse: add "expire only" mode to FUSE_NOTIFY_INVAL_ENTRY
Date: Tue, 10 Sep 2024 11:32:58 +0200
Message-ID: <20240910092604.306065821@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 4f8d37020e1fd0bf6ee9381ba918135ef3712efd ]

Add a flag to entry expiration that lets the filesystem expire a dentry
without kicking it out from the cache immediately.

This makes a difference for overmounted dentries, where plain invalidation
would detach all submounts before dropping the dentry from the cache.  If
only expiry is set on the dentry, then any overmounts are left alone and
until ->d_revalidate() is called.

Note: ->d_revalidate() is not called for the case of following a submount,
so invalidation will only be triggered for the non-overmounted case.  The
dentry could also be mounted in a different mount instance, in which case
any submounts will still be detached.

Suggested-by: Jakob Blomer <jblomer@cern.ch>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: 3002240d1649 ("fuse: fix memory leak in fuse_create_open")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dev.c             |  4 ++--
 fs/fuse/dir.c             |  6 ++++--
 fs/fuse/fuse_i.h          |  2 +-
 include/uapi/linux/fuse.h | 13 +++++++++++--
 4 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 96a717f73ce3..61bef919c042 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1498,7 +1498,7 @@ static int fuse_notify_inval_entry(struct fuse_conn *fc, unsigned int size,
 	buf[outarg.namelen] = 0;
 
 	down_read(&fc->killsb);
-	err = fuse_reverse_inval_entry(fc, outarg.parent, 0, &name);
+	err = fuse_reverse_inval_entry(fc, outarg.parent, 0, &name, outarg.flags);
 	up_read(&fc->killsb);
 	kfree(buf);
 	return err;
@@ -1546,7 +1546,7 @@ static int fuse_notify_delete(struct fuse_conn *fc, unsigned int size,
 	buf[outarg.namelen] = 0;
 
 	down_read(&fc->killsb);
-	err = fuse_reverse_inval_entry(fc, outarg.parent, outarg.child, &name);
+	err = fuse_reverse_inval_entry(fc, outarg.parent, outarg.child, &name, 0);
 	up_read(&fc->killsb);
 	kfree(buf);
 	return err;
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 936a24b646ce..8474003aa54d 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1174,7 +1174,7 @@ int fuse_update_attributes(struct inode *inode, struct file *file, u32 mask)
 }
 
 int fuse_reverse_inval_entry(struct fuse_conn *fc, u64 parent_nodeid,
-			     u64 child_nodeid, struct qstr *name)
+			     u64 child_nodeid, struct qstr *name, u32 flags)
 {
 	int err = -ENOTDIR;
 	struct inode *parent;
@@ -1201,7 +1201,9 @@ int fuse_reverse_inval_entry(struct fuse_conn *fc, u64 parent_nodeid,
 		goto unlock;
 
 	fuse_dir_changed(parent);
-	fuse_invalidate_entry(entry);
+	if (!(flags & FUSE_EXPIRE_ONLY))
+		d_invalidate(entry);
+	fuse_invalidate_entry_cache(entry);
 
 	if (child_nodeid != 0 && d_really_is_positive(entry)) {
 		inode_lock(d_inode(entry));
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 66c2a9999468..cb464e5b171a 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1235,7 +1235,7 @@ int fuse_reverse_inval_inode(struct fuse_conn *fc, u64 nodeid,
  * then the dentry is unhashed (d_delete()).
  */
 int fuse_reverse_inval_entry(struct fuse_conn *fc, u64 parent_nodeid,
-			     u64 child_nodeid, struct qstr *name);
+			     u64 child_nodeid, struct qstr *name, u32 flags);
 
 int fuse_do_open(struct fuse_mount *fm, u64 nodeid, struct file *file,
 		 bool isdir);
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 76ee8f9e024a..39cfb343faa8 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -197,6 +197,9 @@
  *
  *  7.37
  *  - add FUSE_TMPFILE
+ *
+ *  7.38
+ *  - add FUSE_EXPIRE_ONLY flag to fuse_notify_inval_entry
  */
 
 #ifndef _LINUX_FUSE_H
@@ -232,7 +235,7 @@
 #define FUSE_KERNEL_VERSION 7
 
 /** Minor version number of this interface */
-#define FUSE_KERNEL_MINOR_VERSION 37
+#define FUSE_KERNEL_MINOR_VERSION 38
 
 /** The node ID of the root inode */
 #define FUSE_ROOT_ID 1
@@ -491,6 +494,12 @@ struct fuse_file_lock {
  */
 #define FUSE_SETXATTR_ACL_KILL_SGID	(1 << 0)
 
+/**
+ * notify_inval_entry flags
+ * FUSE_EXPIRE_ONLY
+ */
+#define FUSE_EXPIRE_ONLY		(1 << 0)
+
 enum fuse_opcode {
 	FUSE_LOOKUP		= 1,
 	FUSE_FORGET		= 2,  /* no reply */
@@ -919,7 +928,7 @@ struct fuse_notify_inval_inode_out {
 struct fuse_notify_inval_entry_out {
 	uint64_t	parent;
 	uint32_t	namelen;
-	uint32_t	padding;
+	uint32_t	flags;
 };
 
 struct fuse_notify_delete_out {
-- 
2.43.0



