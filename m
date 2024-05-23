Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC43A14A60D;
	Thu, 23 May 2024 13:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470368; cv=none; b=Q2IFldf4l1Ls1z+DTrFeXd9MXxWIl+FxwD28BBQ3bCBK0QVEVabOz1LE4s3hqQfaL2AUPhV1/lgDoj5X6UAQjqujinVib0s8NcUBCMzXD4cWgwNt4x10AmVP+a0lB6UBZRM9XmbBo9KDfCpeYM8T3W168/Todlw8+b7YsvKGA5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470368; c=relaxed/simple;
	bh=P85zy7sElETjaXHYQHVQtF7y/eE+/FQzZHtwH/UdagA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D87ICAMWXlfGv+xSCDyFWRbQ2awMZS5gAb7o0KN5MnmA8bsoR1kPAwjk/DaVn019Rv+KqcNLOMgz1MpiMINY+VBYM4uVxwvqRERpt9aHV6oP2Ra3uugDHqOAIYrWLQYATld2STNg3/Bp5cDpwAVnRiKYW3LuLktto/KCfqRHDX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJhrPn/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJhrPn/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C319C4AF12;
	Thu, 23 May 2024 13:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470368;
	bh=P85zy7sElETjaXHYQHVQtF7y/eE+/FQzZHtwH/UdagA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJhrPn/eSHlHwVNytbTEAYAbiD+6s3o/jc3zYbesHZ6JmjSCR9s2ObrHGFdEF0zFy
	 oPx6JMVd7OAP5IpML80y04HBHRPUrtkrsQXgKQWnWPoqbXO3EFDktu6AFxps+7Kl9L
	 TpVouiZvN0pG/39AeyeYS7ABn5liC79NhQG8+4f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 13/45] xfs,iomap: move delalloc punching to iomap
Date: Thu, 23 May 2024 15:13:04 +0200
Message-ID: <20240523130332.994623346@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
References: <20240523130332.496202557@linuxfoundation.org>
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

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 9c7babf94a0d686b552e53aded8d4703d1b8b92b ]

Because that's what Christoph wants for this error handling path
only XFS uses.

It requires a new iomap export for handling errors over delalloc
ranges. This is basically the XFS code as is stands, but even though
Christoph wants this as iomap funcitonality, we still have
to call it from the filesystem specific ->iomap_end callback, and
call into the iomap code with yet another filesystem specific
callback to punch the delalloc extent within the defined ranges.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/iomap/buffered-io.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_iomap.c     |   47 ++++++--------------------------------
 include/linux/iomap.h  |    4 +++
 3 files changed, 72 insertions(+), 39 deletions(-)

--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -827,6 +827,66 @@ iomap_file_buffered_write(struct kiocb *
 }
 EXPORT_SYMBOL_GPL(iomap_file_buffered_write);
 
+/*
+ * When a short write occurs, the filesystem may need to remove reserved space
+ * that was allocated in ->iomap_begin from it's ->iomap_end method. For
+ * filesystems that use delayed allocation, we need to punch out delalloc
+ * extents from the range that are not dirty in the page cache. As the write can
+ * race with page faults, there can be dirty pages over the delalloc extent
+ * outside the range of a short write but still within the delalloc extent
+ * allocated for this iomap.
+ *
+ * This function uses [start_byte, end_byte) intervals (i.e. open ended) to
+ * simplify range iterations, but converts them back to {offset,len} tuples for
+ * the punch callback.
+ */
+int iomap_file_buffered_write_punch_delalloc(struct inode *inode,
+		struct iomap *iomap, loff_t pos, loff_t length,
+		ssize_t written,
+		int (*punch)(struct inode *inode, loff_t pos, loff_t length))
+{
+	loff_t			start_byte;
+	loff_t			end_byte;
+	int			blocksize = i_blocksize(inode);
+	int			error = 0;
+
+	if (iomap->type != IOMAP_DELALLOC)
+		return 0;
+
+	/* If we didn't reserve the blocks, we're not allowed to punch them. */
+	if (!(iomap->flags & IOMAP_F_NEW))
+		return 0;
+
+	/*
+	 * start_byte refers to the first unused block after a short write. If
+	 * nothing was written, round offset down to point at the first block in
+	 * the range.
+	 */
+	if (unlikely(!written))
+		start_byte = round_down(pos, blocksize);
+	else
+		start_byte = round_up(pos + written, blocksize);
+	end_byte = round_up(pos + length, blocksize);
+
+	/* Nothing to do if we've written the entire delalloc extent */
+	if (start_byte >= end_byte)
+		return 0;
+
+	/*
+	 * Lock the mapping to avoid races with page faults re-instantiating
+	 * folios and dirtying them via ->page_mkwrite between the page cache
+	 * truncation and the delalloc extent removal. Failing to do this can
+	 * leave dirty pages with no space reservation in the cache.
+	 */
+	filemap_invalidate_lock(inode->i_mapping);
+	truncate_pagecache_range(inode, start_byte, end_byte - 1);
+	error = punch(inode, start_byte, end_byte - start_byte);
+	filemap_invalidate_unlock(inode->i_mapping);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(iomap_file_buffered_write_punch_delalloc);
+
 static loff_t iomap_unshare_iter(struct iomap_iter *iter)
 {
 	struct iomap *iomap = &iter->iomap;
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1123,12 +1123,12 @@ out_unlock:
 static int
 xfs_buffered_write_delalloc_punch(
 	struct inode		*inode,
-	loff_t			start_byte,
-	loff_t			end_byte)
+	loff_t			offset,
+	loff_t			length)
 {
 	struct xfs_mount	*mp = XFS_M(inode->i_sb);
-	xfs_fileoff_t		start_fsb = XFS_B_TO_FSBT(mp, start_byte);
-	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, end_byte);
+	xfs_fileoff_t		start_fsb = XFS_B_TO_FSBT(mp, offset);
+	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + length);
 
 	return xfs_bmap_punch_delalloc_range(XFS_I(inode), start_fsb,
 				end_fsb - start_fsb);
@@ -1143,13 +1143,9 @@ xfs_buffered_write_iomap_end(
 	unsigned		flags,
 	struct iomap		*iomap)
 {
-	struct xfs_mount	*mp = XFS_M(inode->i_sb);
-	loff_t			start_byte;
-	loff_t			end_byte;
-	int			error = 0;
 
-	if (iomap->type != IOMAP_DELALLOC)
-		return 0;
+	struct xfs_mount	*mp = XFS_M(inode->i_sb);
+	int			error;
 
 	/*
 	 * Behave as if the write failed if drop writes is enabled. Set the NEW
@@ -1160,35 +1156,8 @@ xfs_buffered_write_iomap_end(
 		written = 0;
 	}
 
-	/* If we didn't reserve the blocks, we're not allowed to punch them. */
-	if (!(iomap->flags & IOMAP_F_NEW))
-		return 0;
-
-	/*
-	 * start_fsb refers to the first unused block after a short write. If
-	 * nothing was written, round offset down to point at the first block in
-	 * the range.
-	 */
-	if (unlikely(!written))
-		start_byte = round_down(offset, mp->m_sb.sb_blocksize);
-	else
-		start_byte = round_up(offset + written, mp->m_sb.sb_blocksize);
-	end_byte = round_up(offset + length, mp->m_sb.sb_blocksize);
-
-	/* Nothing to do if we've written the entire delalloc extent */
-	if (start_byte >= end_byte)
-		return 0;
-
-	/*
-	 * Lock the mapping to avoid races with page faults re-instantiating
-	 * folios and dirtying them via ->page_mkwrite between the page cache
-	 * truncation and the delalloc extent removal. Failing to do this can
-	 * leave dirty pages with no space reservation in the cache.
-	 */
-	filemap_invalidate_lock(inode->i_mapping);
-	truncate_pagecache_range(inode, start_byte, end_byte - 1);
-	error = xfs_buffered_write_delalloc_punch(inode, start_byte, end_byte);
-	filemap_invalidate_unlock(inode->i_mapping);
+	error = iomap_file_buffered_write_punch_delalloc(inode, iomap, offset,
+			length, written, &xfs_buffered_write_delalloc_punch);
 	if (error && !xfs_is_shutdown(mp)) {
 		xfs_alert(mp, "%s: unable to clean up ino 0x%llx",
 			__func__, XFS_I(inode)->i_ino);
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -226,6 +226,10 @@ static inline const struct iomap *iomap_
 
 ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
 		const struct iomap_ops *ops);
+int iomap_file_buffered_write_punch_delalloc(struct inode *inode,
+		struct iomap *iomap, loff_t pos, loff_t length, ssize_t written,
+		int (*punch)(struct inode *inode, loff_t pos, loff_t length));
+
 int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops);
 void iomap_readahead(struct readahead_control *, const struct iomap_ops *ops);
 bool iomap_is_partially_uptodate(struct folio *, size_t from, size_t count);


