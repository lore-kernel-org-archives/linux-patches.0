Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E043195F0;
	Wed, 17 Sep 2025 12:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113665; cv=none; b=dlkVvmTnm0mG7e6mxxiSTppuE1r7N6BkmNiZ8zopz8Cpp4fmsgJAndV2EWG69g1QfYfBm9tDmrQK6uA0IfISklEX+7hgd3mxzYzo0KaOcOth6o316KP/mIciIuJLd83Ha9ZxdgTldDbKnKs+LcRuDtcjdAz9KkCRgnqoPyOGt8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113665; c=relaxed/simple;
	bh=hLwObk9iyG8bzmgyVWbIimZ78BQ16Kfk0ULsA/DdIpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVbMoVwxlFSA5bFddh/47FsP09ymR8U3IfRphQKHZIPk9thHrWMjFiwjMmLOWTEv6aTOY4zrZw+AW9irzokfLJ5ReHBl6mcHarpLlRLhLXo2CCifO+g7WmG1ma0qfQXlc0npTlv7fKvpZGfLGLjYWfM1pZsgvTzWjZ8qhLV+nMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nc2k5xaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nc2k5xaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07D2C4CEF5;
	Wed, 17 Sep 2025 12:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113665;
	bh=hLwObk9iyG8bzmgyVWbIimZ78BQ16Kfk0ULsA/DdIpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nc2k5xaTYIEuS4o/B7efPhA409cpTfD53kp+LkAc98880lP+t98snlL1LvJNQrEbT
	 XBj4nZ4vTUNcU7j98EYU9S+LqudJoJkDV6QD0Q5AnyPnkCySVAOMpYzAFfUrDzK/wG
	 pkZWojmYPSds3xijHM2hHfHzO/LYqiHLxm0NVRwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/101] fs/nfs/io: make nfs_start_io_*() killable
Date: Wed, 17 Sep 2025 14:33:59 +0200
Message-ID: <20250917123337.254854091@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit 38a125b31504f91bf6fdd3cfc3a3e9a721e6c97a ]

This allows killing processes that wait for a lock when one process is
stuck waiting for the NFS server.  This aims to complete the coverage
of NFS operations being killable, like nfs_direct_wait() does, for
example.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: 9eb90f435415 ("NFS: Serialise O_DIRECT i/o and truncate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/direct.c   | 21 ++++++++++++++++++---
 fs/nfs/file.c     | 14 +++++++++++---
 fs/nfs/internal.h |  7 ++++---
 fs/nfs/io.c       | 44 +++++++++++++++++++++++++++++++++-----------
 4 files changed, 66 insertions(+), 20 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index a1ff4a4f5380e..4e53708dfcf43 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -469,8 +469,16 @@ ssize_t nfs_file_direct_read(struct kiocb *iocb, struct iov_iter *iter,
 	if (user_backed_iter(iter))
 		dreq->flags = NFS_ODIRECT_SHOULD_DIRTY;
 
-	if (!swap)
-		nfs_start_io_direct(inode);
+	if (!swap) {
+		result = nfs_start_io_direct(inode);
+		if (result) {
+			/* release the reference that would usually be
+			 * consumed by nfs_direct_read_schedule_iovec()
+			 */
+			nfs_direct_req_release(dreq);
+			goto out_release;
+		}
+	}
 
 	NFS_I(inode)->read_io += count;
 	requested = nfs_direct_read_schedule_iovec(dreq, iter, iocb->ki_pos);
@@ -1023,7 +1031,14 @@ ssize_t nfs_file_direct_write(struct kiocb *iocb, struct iov_iter *iter,
 		requested = nfs_direct_write_schedule_iovec(dreq, iter, pos,
 							    FLUSH_STABLE);
 	} else {
-		nfs_start_io_direct(inode);
+		result = nfs_start_io_direct(inode);
+		if (result) {
+			/* release the reference that would usually be
+			 * consumed by nfs_direct_write_schedule_iovec()
+			 */
+			nfs_direct_req_release(dreq);
+			goto out_release;
+		}
 
 		requested = nfs_direct_write_schedule_iovec(dreq, iter, pos,
 							    FLUSH_COND_STABLE);
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 003dda0018403..2f4db026f8d67 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -167,7 +167,10 @@ nfs_file_read(struct kiocb *iocb, struct iov_iter *to)
 		iocb->ki_filp,
 		iov_iter_count(to), (unsigned long) iocb->ki_pos);
 
-	nfs_start_io_read(inode);
+	result = nfs_start_io_read(inode);
+	if (result)
+		return result;
+
 	result = nfs_revalidate_mapping(inode, iocb->ki_filp->f_mapping);
 	if (!result) {
 		result = generic_file_read_iter(iocb, to);
@@ -188,7 +191,10 @@ nfs_file_splice_read(struct file *in, loff_t *ppos, struct pipe_inode_info *pipe
 
 	dprintk("NFS: splice_read(%pD2, %zu@%llu)\n", in, len, *ppos);
 
-	nfs_start_io_read(inode);
+	result = nfs_start_io_read(inode);
+	if (result)
+		return result;
+
 	result = nfs_revalidate_mapping(inode, in->f_mapping);
 	if (!result) {
 		result = filemap_splice_read(in, ppos, pipe, len, flags);
@@ -668,7 +674,9 @@ ssize_t nfs_file_write(struct kiocb *iocb, struct iov_iter *from)
 	nfs_clear_invalid_mapping(file->f_mapping);
 
 	since = filemap_sample_wb_err(file->f_mapping);
-	nfs_start_io_write(inode);
+	error = nfs_start_io_write(inode);
+	if (error)
+		return error;
 	result = generic_write_checks(iocb, from);
 	if (result > 0)
 		result = generic_perform_write(iocb, from);
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 4eea91d054b24..e78f43a137231 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -6,6 +6,7 @@
 #include "nfs4_fs.h"
 #include <linux/fs_context.h>
 #include <linux/security.h>
+#include <linux/compiler_attributes.h>
 #include <linux/crc32.h>
 #include <linux/sunrpc/addr.h>
 #include <linux/nfs_page.h>
@@ -461,11 +462,11 @@ extern const struct netfs_request_ops nfs_netfs_ops;
 #endif
 
 /* io.c */
-extern void nfs_start_io_read(struct inode *inode);
+extern __must_check int nfs_start_io_read(struct inode *inode);
 extern void nfs_end_io_read(struct inode *inode);
-extern void nfs_start_io_write(struct inode *inode);
+extern  __must_check int nfs_start_io_write(struct inode *inode);
 extern void nfs_end_io_write(struct inode *inode);
-extern void nfs_start_io_direct(struct inode *inode);
+extern __must_check int nfs_start_io_direct(struct inode *inode);
 extern void nfs_end_io_direct(struct inode *inode);
 
 static inline bool nfs_file_io_is_buffered(struct nfs_inode *nfsi)
diff --git a/fs/nfs/io.c b/fs/nfs/io.c
index b5551ed8f648b..3388faf2acb9f 100644
--- a/fs/nfs/io.c
+++ b/fs/nfs/io.c
@@ -39,19 +39,28 @@ static void nfs_block_o_direct(struct nfs_inode *nfsi, struct inode *inode)
  * Note that buffered writes and truncates both take a write lock on
  * inode->i_rwsem, meaning that those are serialised w.r.t. the reads.
  */
-void
+int
 nfs_start_io_read(struct inode *inode)
 {
 	struct nfs_inode *nfsi = NFS_I(inode);
+	int err;
+
 	/* Be an optimist! */
-	down_read(&inode->i_rwsem);
+	err = down_read_killable(&inode->i_rwsem);
+	if (err)
+		return err;
 	if (test_bit(NFS_INO_ODIRECT, &nfsi->flags) == 0)
-		return;
+		return 0;
 	up_read(&inode->i_rwsem);
+
 	/* Slow path.... */
-	down_write(&inode->i_rwsem);
+	err = down_write_killable(&inode->i_rwsem);
+	if (err)
+		return err;
 	nfs_block_o_direct(nfsi, inode);
 	downgrade_write(&inode->i_rwsem);
+
+	return 0;
 }
 
 /**
@@ -74,11 +83,15 @@ nfs_end_io_read(struct inode *inode)
  * Declare that a buffered read operation is about to start, and ensure
  * that we block all direct I/O.
  */
-void
+int
 nfs_start_io_write(struct inode *inode)
 {
-	down_write(&inode->i_rwsem);
-	nfs_block_o_direct(NFS_I(inode), inode);
+	int err;
+
+	err = down_write_killable(&inode->i_rwsem);
+	if (!err)
+		nfs_block_o_direct(NFS_I(inode), inode);
+	return err;
 }
 
 /**
@@ -119,19 +132,28 @@ static void nfs_block_buffered(struct nfs_inode *nfsi, struct inode *inode)
  * Note that buffered writes and truncates both take a write lock on
  * inode->i_rwsem, meaning that those are serialised w.r.t. O_DIRECT.
  */
-void
+int
 nfs_start_io_direct(struct inode *inode)
 {
 	struct nfs_inode *nfsi = NFS_I(inode);
+	int err;
+
 	/* Be an optimist! */
-	down_read(&inode->i_rwsem);
+	err = down_read_killable(&inode->i_rwsem);
+	if (err)
+		return err;
 	if (test_bit(NFS_INO_ODIRECT, &nfsi->flags) != 0)
-		return;
+		return 0;
 	up_read(&inode->i_rwsem);
+
 	/* Slow path.... */
-	down_write(&inode->i_rwsem);
+	err = down_write_killable(&inode->i_rwsem);
+	if (err)
+		return err;
 	nfs_block_buffered(nfsi, inode);
 	downgrade_write(&inode->i_rwsem);
+
+	return 0;
 }
 
 /**
-- 
2.51.0



