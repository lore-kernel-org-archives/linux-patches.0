Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD311B3925;
	Wed, 17 Sep 2025 12:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113351; cv=none; b=qvO1JrqI/KFu2hqAd2jUdcO1+HyvE0vOWGaGUXr7h5YqSf6a9qoyoct/4HRFL7TpdTLT/mUJBknBKEcl/r+7Ub1gYus0NQVO2GQMUZsknfuYAPSSpTWjGVgh3dqjKDdtsA8FdRiCEzgqQxSUjESTuwTkMJ/em0b+PCUDrljCgtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113351; c=relaxed/simple;
	bh=xCMzzOjHQKQMIu/vejdYHDG+azu9Wi5N9xm9i3ZA9I8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYvwEX7PO9QTfAKgTSYkCvLEnSYqkvWrKJjkyjLWKXaanzJhjdMs8asDecXx1OVmg2MpmYIBJMJeqXBaaga72D3ldXaeiOtZYVazxgY88cu8VgfRLhhRDAhPFKKKjoPGOT7zI+HQZeMNlvsnwr2iJNKEW0Y2luhJQsiDKjYESNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWz5RJ4R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWz5RJ4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB61C4CEF0;
	Wed, 17 Sep 2025 12:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113351;
	bh=xCMzzOjHQKQMIu/vejdYHDG+azu9Wi5N9xm9i3ZA9I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWz5RJ4RvOKUTMOs8HGucXABogsdOv2Gz2fQ/FQBjXfgIMNhmf2K4SNAVvaNGuJ9f
	 wG0VrpTkjRF5TljwG8ZJHdyGhh+yoSAOLh0oNVLYjR2wAx7ICaviaiS4TK/Xxyu9ks
	 zjFhQPd/XS2sGIGsa+U88EJySswJn1edh2NbFkF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/140] fs/nfs/io: make nfs_start_io_*() killable
Date: Wed, 17 Sep 2025 14:33:24 +0200
Message-ID: <20250917123345.095341100@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f159cfc125adc..f32f8d7c9122b 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -472,8 +472,16 @@ ssize_t nfs_file_direct_read(struct kiocb *iocb, struct iov_iter *iter,
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
@@ -1031,7 +1039,14 @@ ssize_t nfs_file_direct_write(struct kiocb *iocb, struct iov_iter *iter,
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
index 153d25d4b810c..033feeab8c346 100644
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
@@ -669,7 +675,9 @@ ssize_t nfs_file_write(struct kiocb *iocb, struct iov_iter *from)
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
index 882d804089add..4860270f1be04 100644
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
@@ -516,11 +517,11 @@ extern const struct netfs_request_ops nfs_netfs_ops;
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



