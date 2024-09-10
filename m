Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87F8192D9D;
	Tue, 10 Sep 2024 10:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963160; cv=none; b=LMU3yuh53++bhuOXAdg0yJDk6NNmxpPT8wKcBWqAY81K3/6qj+RZlJ7hA63FRBJgY7aPw1inYdyxJvyf9I6v3pGwDzuM6aU7jMebSt0GuI1BO/5bs731UEfa8ufYrcYQRpr3c/EOtxul0rtBeYDk39MHdIRw+r3j4DiLqCIfBG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963160; c=relaxed/simple;
	bh=nEGrovzd/8APHaaWD1alTOfKOyIvYFMegYoRkPSWAOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fupMAm523AqmigcryIUIPAJq1+Yv/5IhfRsVcrMtl4LHiRn5/9NPgiqvZc5wEYPQDB95DzYVUxmKZ0TfxW5bDL/oknN6vlNI3fUFZwVqzwTGRvXdGCeehbDR8yLLUTeSgOR+oOR/o+INXnpINw2PvPoxavLXnGj38XUOYOxl/Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STZsXinB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STZsXinB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6634AC4CEC3;
	Tue, 10 Sep 2024 10:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963159;
	bh=nEGrovzd/8APHaaWD1alTOfKOyIvYFMegYoRkPSWAOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STZsXinB9QWknsD+UU6ascc2p6bTqqRo3rwJ4YxyA+I+xtXgTm2xCCfPTQM+FbG3D
	 TTb0IpAiGwY863UtlzlE1e3tlrIpKbNqv9KBrjHppMlLiSy7/mAXM80gACDYM3oRcN
	 XboYXdvtPOqk0+zlVlNeLOm3JVOAsE+CBqq+wv1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dharmendra Singh <dsingh@ddn.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/192] fuse: allow non-extending parallel direct writes on the same file
Date: Tue, 10 Sep 2024 11:32:59 +0200
Message-ID: <20240910092604.341975706@linuxfoundation.org>
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

From: Dharmendra Singh <dsingh@ddn.com>

[ Upstream commit 153524053bbb0d27bb2e0be36d1b46862e9ce74c ]

In general, as of now, in FUSE, direct writes on the same file are
serialized over inode lock i.e we hold inode lock for the full duration of
the write request.  I could not find in fuse code and git history a comment
which clearly explains why this exclusive lock is taken for direct writes.
Following might be the reasons for acquiring an exclusive lock but not be
limited to

 1) Our guess is some USER space fuse implementations might be relying on
    this lock for serialization.

 2) The lock protects against file read/write size races.

 3) Ruling out any issues arising from partial write failures.

This patch relaxes the exclusive lock for direct non-extending writes only.
File size extending writes might not need the lock either, but we are not
entirely sure if there is a risk to introduce any kind of regression.
Furthermore, benchmarking with fio does not show a difference between patch
versions that take on file size extension a) an exclusive lock and b) a
shared lock.

A possible example of an issue with i_size extending writes are write error
cases.  Some writes might succeed and others might fail for file system
internal reasons - for example ENOSPACE.  With parallel file size extending
writes it _might_ be difficult to revert the action of the failing write,
especially to restore the right i_size.

With these changes, we allow non-extending parallel direct writes on the
same file with the help of a flag called FOPEN_PARALLEL_DIRECT_WRITES.  If
this flag is set on the file (flag is passed from libfuse to fuse kernel as
part of file open/create), we do not take exclusive lock anymore, but
instead use a shared lock that allows non-extending writes to run in
parallel.  FUSE implementations which rely on this inode lock for
serialization can continue to do so and serialized direct writes are still
the default.  Implementations that do not do write serialization need to be
updated and need to set the FOPEN_PARALLEL_DIRECT_WRITES flag in their file
open/create reply.

On patch review there were concerns that network file systems (or vfs
multiple mounts of the same file system) might have issues with parallel
writes.  We believe this is not the case, as this is just a local lock,
which network file systems could not rely on anyway.  I.e. this lock is
just for local consistency.

Signed-off-by: Dharmendra Singh <dsingh@ddn.com>
Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: 3002240d1649 ("fuse: fix memory leak in fuse_create_open")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c            | 43 ++++++++++++++++++++++++++++++++++++---
 include/uapi/linux/fuse.h |  3 +++
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index e6ec4338a9c5..0df1311afb87 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1563,14 +1563,47 @@ static ssize_t fuse_direct_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	return res;
 }
 
+static bool fuse_direct_write_extending_i_size(struct kiocb *iocb,
+					       struct iov_iter *iter)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+
+	return iocb->ki_pos + iov_iter_count(iter) > i_size_read(inode);
+}
+
 static ssize_t fuse_direct_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
+	struct file *file = iocb->ki_filp;
+	struct fuse_file *ff = file->private_data;
 	struct fuse_io_priv io = FUSE_IO_PRIV_SYNC(iocb);
 	ssize_t res;
+	bool exclusive_lock =
+		!(ff->open_flags & FOPEN_PARALLEL_DIRECT_WRITES) ||
+		iocb->ki_flags & IOCB_APPEND ||
+		fuse_direct_write_extending_i_size(iocb, from);
+
+	/*
+	 * Take exclusive lock if
+	 * - Parallel direct writes are disabled - a user space decision
+	 * - Parallel direct writes are enabled and i_size is being extended.
+	 *   This might not be needed at all, but needs further investigation.
+	 */
+	if (exclusive_lock)
+		inode_lock(inode);
+	else {
+		inode_lock_shared(inode);
+
+		/* A race with truncate might have come up as the decision for
+		 * the lock type was done without holding the lock, check again.
+		 */
+		if (fuse_direct_write_extending_i_size(iocb, from)) {
+			inode_unlock_shared(inode);
+			inode_lock(inode);
+			exclusive_lock = true;
+		}
+	}
 
-	/* Don't allow parallel writes to the same file */
-	inode_lock(inode);
 	res = generic_write_checks(iocb, from);
 	if (res > 0) {
 		if (!is_sync_kiocb(iocb) && iocb->ki_flags & IOCB_DIRECT) {
@@ -1581,7 +1614,10 @@ static ssize_t fuse_direct_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			fuse_write_update_attr(inode, iocb->ki_pos, res);
 		}
 	}
-	inode_unlock(inode);
+	if (exclusive_lock)
+		inode_unlock(inode);
+	else
+		inode_unlock_shared(inode);
 
 	return res;
 }
@@ -2937,6 +2973,7 @@ fuse_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 
 	if (iov_iter_rw(iter) == WRITE) {
 		fuse_write_update_attr(inode, pos, ret);
+		/* For extending writes we already hold exclusive lock */
 		if (ret < 0 && offset + count > i_size)
 			fuse_do_truncate(file);
 	}
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 39cfb343faa8..e3c54109bae9 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -200,6 +200,7 @@
  *
  *  7.38
  *  - add FUSE_EXPIRE_ONLY flag to fuse_notify_inval_entry
+ *  - add FOPEN_PARALLEL_DIRECT_WRITES
  */
 
 #ifndef _LINUX_FUSE_H
@@ -307,6 +308,7 @@ struct fuse_file_lock {
  * FOPEN_CACHE_DIR: allow caching this directory
  * FOPEN_STREAM: the file is stream-like (no file position at all)
  * FOPEN_NOFLUSH: don't flush data cache on close (unless FUSE_WRITEBACK_CACHE)
+ * FOPEN_PARALLEL_DIRECT_WRITES: Allow concurrent direct writes on the same inode
  */
 #define FOPEN_DIRECT_IO		(1 << 0)
 #define FOPEN_KEEP_CACHE	(1 << 1)
@@ -314,6 +316,7 @@ struct fuse_file_lock {
 #define FOPEN_CACHE_DIR		(1 << 3)
 #define FOPEN_STREAM		(1 << 4)
 #define FOPEN_NOFLUSH		(1 << 5)
+#define FOPEN_PARALLEL_DIRECT_WRITES	(1 << 6)
 
 /**
  * INIT request/reply flags
-- 
2.43.0



