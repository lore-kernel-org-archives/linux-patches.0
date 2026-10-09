Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3810D4E2F2A;
	Fri,  9 Oct 2026 14:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555690; cv=none; b=jpnZB2UXPPBC3vI5llYY0vXwFg3jJ5u9vSkPTUBneYLIN09Q9uANlogmoVJ60ddlXV+RYSKpuqX205a+AtWGZd0EppXLQCsTUTV4fXgS+aA7lYuS8/sg4NL8fgOIKl2TE+gS+RwjFAdCVTYfpBQEv05NXxVrUJ13F2lHMenEhN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555690; c=relaxed/simple;
	bh=XrHAkCx2FljTIShwSe9eZb4h5WL8NXzlT/XJYqT5jhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4RIU0+jdwCVlH4D7MRkKKROx9OJ/zduKj4ZuOVqnnQ8KzxO2AXvgrGi+0coacSucqLfMdaumrra8w/abLWpu9n8HM0tnZ+f/0jpoy++Fh8blglsd1IjcnN0/ePj3xYV5WszAIQrvse7zgmfqTWfud5Xh4FCIn9RPfp/Y1yMn44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mACrB6vj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mACrB6vj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B4B1F00899;
	Fri,  9 Oct 2026 14:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555688;
	bh=kqEQEOwas5fvB7JKQl2diCOiJpAa3gYCx2kSAenc8jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mACrB6vjntaM5cVN2S8tZlSC2PWG/XFCTHISvhwnF19UTwhlV4hTUOSeCeyIW1Vw8
	 HPAQl2EgGbaNH58DyowpbNgb2MJR+514c52SQRdtS3Z8D0j5plulq6+ENogRc4viil
	 kHjydWEjz/auzKtyyevhuwDLujrxlXhb+mNLQxuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 7.2 049/428] netfs: clear post-EOF pagecache when extending a file via write
Date: Fri,  9 Oct 2026 16:06:26 +0200
Message-ID: <20261009140947.192433149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit 69bf14300b50631e7c2271289d347bbd1b19a06c upstream.

Fix netfs to erase the contents of a hole created after the EOF by an
ordinary write if dirty data has been previously left there by writes
through an mmapped region.  Neither the buffered nor the unbuffered/DIO
write path clears that stale pagecache.

Zero the tail of the folio straddling the EOF before an extending
write.  That is the only folio that can hold data written past the EOF
through an mmap, as pages wholly beyond the EOF can't be faulted in.
The folio is zeroed rather than dropped so a concurrent extending write
can't lose data.

Both write paths downgrade the i_rwsem to shared, so extending writes
can run concurrently and the i_size read by the caller may be stale by
the time the folio is locked.  Re-read i_size under the folio lock and
clamp the zeroed range up to it, so a racing write that already put
data into the folio isn't clobbered.

Wait for any writeback on the folio to finish before zeroing it so that
the pagecache isn't modified while it may still be read by the transport
during transmission.  Honour IOCB_NOWAIT by returning -EAGAIN rather
than blocking on the folio lock, on writeback, or in folio_mkclean()'s
rmap walk when the folio is mapped.

truncate_pagecache() can't be used here: it must be called with the
i_rwsem held exclusively, but these write paths only hold it shared,
and it would block unconditionally, breaking IOCB_NOWAIT.

Callers that hold i_rwsem exclusively for the whole resize (truncate,
setattr, fallocate, clone) exclude any genuine concurrent buffered
writer, so staleness can instead be decided from the folio's dirty
state, as pagecache_isize_extended() already does for filesystems that
serialise writes against truncate/setattr via a single i_rwsem.
Export netfs_clear_stale_post_isize() helper to handle such case.

The helper is required by the CIFS client to fix generic/363.

Closes: https://sashiko.dev/#/patchset/20260921230755.1133425-1-pc%40manguebit.org
Fixes: 938e13a73b24 ("netfs: Implement buffered write API")
Fixes: 153a9961b551 ("netfs: Implement unbuffered/DIO write support")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/filesystems/netfs_library.rst |   26 +++++++
 fs/netfs/buffered_write.c                   |    9 ++
 fs/netfs/direct_write.c                     |    9 ++
 fs/netfs/internal.h                         |    2 
 fs/netfs/misc.c                             |   99 ++++++++++++++++++++++++++++
 include/linux/netfs.h                       |    2 
 6 files changed, 147 insertions(+)

--- a/Documentation/filesystems/netfs_library.rst
+++ b/Documentation/filesystems/netfs_library.rst
@@ -451,6 +451,32 @@ one.
 The inode should be marked ``NETFS_ICTX_SINGLE_NO_UPLOAD`` if this API is to be
 used.  The writeback function requires the buffer to be of ITER_FOLIOQ type.
 
+Clearing Stale Post-EOF Pagecache
+---------------------------------
+
+When a file is extended, data left in the pagecache past the old EOF by a write
+through an mmap must not be exposed as file content.  Netfslib clears this on
+its own write paths, and exports a helper so a filesystem can do the same from
+a resize path (truncate, setattr, fallocate and the like) that holds the
+inode's ``i_rwsem`` exclusively across the whole resize::
+
+	void netfs_clear_stale_post_isize(struct inode *inode, uoff_t from,
+					  uoff_t to);
+
+This zeroes any such data within the ``[from, to)`` hole to be made, where
+@from is the old EOF and @to is the new one, and the caller must have already
+updated ``i_size`` to @to before calling it.  Only the folio straddling @from
+can hold data written past the EOF through an mmap, as pages wholly beyond the
+EOF can't be faulted in, so the zeroing is limited to that folio.  The folio is
+zeroed rather than dropped so that a concurrent extending write can't lose
+data.
+
+This overlaps with ``pagecache_isize_extended()`` but can't reuse it: that
+helper is keyed on a sub-page block size and is a no-op when the block size is
+``>= PAGE_SIZE`` (as on network filesystems), and it doesn't wait for
+writeback.  As both address the same problem, a change to one should probably
+be reflected in the other to keep them in sync.
+
 High-Level VM API
 ==================
 
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -469,6 +469,7 @@ ssize_t netfs_buffered_write_iter_locked
 					 struct netfs_group *netfs_group)
 {
 	struct file *file = iocb->ki_filp;
+	struct inode *inode = file_inode(file);
 	ssize_t ret;
 
 	trace_netfs_write_iter(iocb, from);
@@ -481,6 +482,14 @@ ssize_t netfs_buffered_write_iter_locked
 	if (ret)
 		return ret;
 
+	if (iocb->ki_pos > i_size_read(inode)) {
+		ret = netfs_clear_stale_pre_isize(inode, i_size_read(inode),
+						  iocb->ki_pos,
+						  iocb->ki_flags & IOCB_NOWAIT);
+		if (ret)
+			return ret;
+	}
+
 	return netfs_perform_write(iocb, from, netfs_group);
 }
 EXPORT_SYMBOL(netfs_buffered_write_iter_locked);
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -359,6 +359,15 @@ ssize_t netfs_unbuffered_write_iter(stru
 	ret = file_update_time(file);
 	if (ret < 0)
 		goto out;
+
+	if (iocb->ki_pos > i_size_read(inode)) {
+		ret = netfs_clear_stale_pre_isize(inode, i_size_read(inode),
+						  iocb->ki_pos,
+						  iocb->ki_flags & IOCB_NOWAIT);
+		if (ret < 0)
+			goto out;
+	}
+
 	if (iocb->ki_flags & IOCB_NOWAIT) {
 		/* We could block if there are any pages in the range. */
 		ret = -EAGAIN;
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -80,6 +80,8 @@ ssize_t netfs_wait_for_write(struct netf
 void netfs_wait_for_paused_read(struct netfs_io_request *rreq);
 void netfs_wait_for_paused_write(struct netfs_io_request *rreq);
 void netfs_wait_for_put_ra_refs(struct netfs_io_request *rreq);
+int netfs_clear_stale_pre_isize(struct inode *inode, uoff_t from,
+				uoff_t to, bool nowait);
 
 /*
  * objects.c
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/swap.h>
+#include <linux/rmap.h>
 #include "internal.h"
 
 /**
@@ -582,3 +583,101 @@ void netfs_wait_for_put_ra_refs(struct n
 	trace_netfs_rreq(rreq, netfs_rreq_trace_waited_put_ra_refs);
 	finish_wait(&rreq->waitq, &myself);
 }
+
+/**
+ * netfs_clear_stale_isize - Clear stale pagecache in a to-be-created hole
+ * @inode: The inode to act upon.
+ * @from: The base of the hole to be made.
+ * @to: The top of the hole to be made.
+ * @nowait: True to return -EAGAIN rather than block.
+ * @exclusive: True if the caller holds i_rwsem exclusively for the resize.
+ *
+ * Zero any data left in the pagecache within the [@from, @to) hole by a
+ * write through an mmap so that it isn't exposed as file content once the
+ * file is extended.  Only the uptodate folio straddling @from can hold such
+ * data as pages wholly beyond the EOF can't be faulted in, so the zeroing
+ * is limited to that folio.  The folio is zeroed rather than dropped so
+ * that a concurrent extending write can't lose data.
+ *
+ * If @exclusive is false, @from is re-read from i_size and used to clamp
+ * the zeroed range, for callers that may race with another writer also
+ * extending the file (eg. multiple buffered writes extending the same file
+ * under a shared i_rwsem).  If @exclusive is true, for callers that hold
+ * i_rwsem exclusively across the whole resize and have already updated
+ * i_size to @to, staleness is decided from the folio's dirty state instead:
+ * since no genuine concurrent buffered writer can be racing, a lockless
+ * stat() adopting a server-confirmed size mid-resize has no data behind it
+ * and never dirties the folio, so it can't fool this check into skipping
+ * the zeroing the way it could fool the @exclusive false clamp.
+ *
+ * pagecache_isize_extended() can't be reused here: it is keyed on a
+ * sub-page block size (a no-op when the block size is >= PAGE_SIZE, as on
+ * network filesystems), runs after i_size is updated, can't honour
+ * @nowait, and doesn't wait for writeback.  Keep the two in sync if either
+ * is changed.
+ *
+ * Return: 0 on success, or -EAGAIN if @nowait is set and the folio is
+ * mapped or under writeback and so can't be cleaned without blocking.
+ */
+static int netfs_clear_stale_isize(struct inode *inode, uoff_t from,
+				   uoff_t to, bool nowait, bool exclusive)
+{
+	struct address_space *mapping = inode->i_mapping;
+	fgf_t fgp = FGP_LOCK;
+	struct folio *folio;
+	int ret;
+
+	if (from >= to)
+		return 0;
+
+	if (nowait)
+		fgp |= FGP_NOWAIT;
+
+	folio = __filemap_get_folio(mapping, from >> PAGE_SHIFT, fgp, 0);
+	if (IS_ERR(folio))
+		return PTR_ERR(folio) == -EAGAIN ? -EAGAIN : 0;
+
+	ret = 0;
+	if (nowait && (folio_mapped(folio) || folio_test_writeback(folio))) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	folio_wait_writeback(folio);
+
+	if (folio_mkclean(folio))
+		folio_mark_dirty(folio);
+
+	if (folio_test_uptodate(folio) &&
+	    (!exclusive || folio_test_dirty(folio))) {
+		uoff_t fpos = folio_pos(folio);
+
+		if (!exclusive)
+			from = umax(from, i_size_read(inode));
+		if (from < to && from < fpos + folio_size(folio)) {
+			size_t end = umin(to - fpos, folio_size(folio));
+			size_t offset = from - fpos;
+
+			folio_zero_segment(folio, offset, end);
+		}
+	}
+out:
+	folio_unlock(folio);
+	folio_put(folio);
+	return ret;
+}
+
+/* Clear stale pagecache before an extending buffered/DIO write. */
+int netfs_clear_stale_pre_isize(struct inode *inode, uoff_t from,
+				uoff_t to, bool nowait)
+{
+	return netfs_clear_stale_isize(inode, from, to, nowait, false);
+}
+
+/* Clear stale pagecache when extending a file under an exclusive resize. */
+void netfs_clear_stale_post_isize(struct inode *inode, uoff_t from,
+				  uoff_t to)
+{
+	netfs_clear_stale_isize(inode, from, to, false, true);
+}
+EXPORT_SYMBOL(netfs_clear_stale_post_isize);
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -406,6 +406,8 @@ ssize_t netfs_unbuffered_write_iter(stru
 ssize_t netfs_unbuffered_write_iter_locked(struct kiocb *iocb, struct iov_iter *iter,
 					   struct netfs_group *netfs_group);
 ssize_t netfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from);
+void netfs_clear_stale_post_isize(struct inode *inode, uoff_t from,
+				  uoff_t to);
 
 /* Single, monolithic object read/write API. */
 void netfs_single_mark_inode_dirty(struct inode *inode);


