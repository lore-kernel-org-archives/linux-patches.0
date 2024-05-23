Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEA41E4B0;
	Thu, 23 May 2024 13:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470377; cv=none; b=lPox/Emj+AWDR7q3rfoq2uouJuV9o6jgK3drXM2nPruJj4AxvqW3V7Z9HBFdY4bCfkrJRIZ8x6iLm+XwmcDA78XB/thU/d/WOa46L5xjDEeXAhQNQR0zJK6nTc1V9L1jm3CZX20LOngt1u/zlbqpRvwVvURddvGHDLXIC4UWQ5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470377; c=relaxed/simple;
	bh=MPBTeuSfY8aTQOiRlD0FULTi2xUvqX0ba8rYBd38ztI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzcJuFZeml7d3Tl6TVPhoE+rKE2//4on8Smn9VMjF/uamuu5P1l5xCVZ4U7a4uhhCFLK7S5gq4J00jmXwHX9nhOko3Eca5Kg4co++a5aTizUi1i7chSXI4ORpj51RZnISeP7wJQYGfyzv6fOjnwwd2WfbdWzsCgi0J8TTMg8GsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CqtILJSe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CqtILJSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3A5C2BD10;
	Thu, 23 May 2024 13:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470377;
	bh=MPBTeuSfY8aTQOiRlD0FULTi2xUvqX0ba8rYBd38ztI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CqtILJSeZageyRFAeUZ+4Ee9hJLUoHTOL1VYv3xhHEOepgFVmHNwUYFrf3tPad3xF
	 FvwIM36NYO4Kv+F0VjsOJk9j/XnU9mzToU1OcuAPslY66rRAz75K3Bx5mgeHFv0wh0
	 OluxsrjPKha5sGQVqEyTV9GxBjc5SgXgYkIcmBts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 16/45] iomap: write iomap validity checks
Date: Thu, 23 May 2024 15:13:07 +0200
Message-ID: <20240523130333.104778685@linuxfoundation.org>
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

[ Upstream commit d7b64041164ca177170191d2ad775da074ab2926 ]

A recent multithreaded write data corruption has been uncovered in
the iomap write code. The core of the problem is partial folio
writes can be flushed to disk while a new racing write can map it
and fill the rest of the page:

writeback			new write

allocate blocks
  blocks are unwritten
submit IO
.....
				map blocks
				iomap indicates UNWRITTEN range
				loop {
				  lock folio
				  copyin data
.....
IO completes
  runs unwritten extent conv
    blocks are marked written
				  <iomap now stale>
				  get next folio
				}

Now add memory pressure such that memory reclaim evicts the
partially written folio that has already been written to disk.

When the new write finally gets to the last partial page of the new
write, it does not find it in cache, so it instantiates a new page,
sees the iomap is unwritten, and zeros the part of the page that
it does not have data from. This overwrites the data on disk that
was originally written.

The full description of the corruption mechanism can be found here:

https://lore.kernel.org/linux-xfs/20220817093627.GZ3600936@dread.disaster.area/

To solve this problem, we need to check whether the iomap is still
valid after we lock each folio during the write. We have to do it
after we lock the page so that we don't end up with state changes
occurring while we wait for the folio to be locked.

Hence we need a mechanism to be able to check that the cached iomap
is still valid (similar to what we already do in buffered
writeback), and we need a way for ->begin_write to back out and
tell the high level iomap iterator that we need to remap the
remaining write range.

The iomap needs to grow some storage for the validity cookie that
the filesystem provides to travel with the iomap. XFS, in
particular, also needs to know some more information about what the
iomap maps (attribute extents rather than file data extents) to for
the validity cookie to cover all the types of iomaps we might need
to validate.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/iomap/buffered-io.c |   29 ++++++++++++++++++++++++++++-
 fs/iomap/iter.c        |   19 ++++++++++++++++++-
 include/linux/iomap.h  |   43 +++++++++++++++++++++++++++++++++++--------
 3 files changed, 81 insertions(+), 10 deletions(-)

--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -579,7 +579,7 @@ static int iomap_write_begin_inline(cons
 	return iomap_read_inline_data(iter, folio);
 }
 
-static int iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
+static int iomap_write_begin(struct iomap_iter *iter, loff_t pos,
 		size_t len, struct folio **foliop)
 {
 	const struct iomap_page_ops *page_ops = iter->iomap.page_ops;
@@ -613,6 +613,27 @@ static int iomap_write_begin(const struc
 		status = (iter->flags & IOMAP_NOWAIT) ? -EAGAIN : -ENOMEM;
 		goto out_no_page;
 	}
+
+	/*
+	 * Now we have a locked folio, before we do anything with it we need to
+	 * check that the iomap we have cached is not stale. The inode extent
+	 * mapping can change due to concurrent IO in flight (e.g.
+	 * IOMAP_UNWRITTEN state can change and memory reclaim could have
+	 * reclaimed a previously partially written page at this index after IO
+	 * completion before this write reaches this file offset) and hence we
+	 * could do the wrong thing here (zero a page range incorrectly or fail
+	 * to zero) and corrupt data.
+	 */
+	if (page_ops && page_ops->iomap_valid) {
+		bool iomap_valid = page_ops->iomap_valid(iter->inode,
+							&iter->iomap);
+		if (!iomap_valid) {
+			iter->iomap.flags |= IOMAP_F_STALE;
+			status = 0;
+			goto out_unlock;
+		}
+	}
+
 	if (pos + len > folio_pos(folio) + folio_size(folio))
 		len = folio_pos(folio) + folio_size(folio) - pos;
 
@@ -768,6 +789,8 @@ again:
 		status = iomap_write_begin(iter, pos, bytes, &folio);
 		if (unlikely(status))
 			break;
+		if (iter->iomap.flags & IOMAP_F_STALE)
+			break;
 
 		page = folio_file_page(folio, pos >> PAGE_SHIFT);
 		if (mapping_writably_mapped(mapping))
@@ -1076,6 +1099,8 @@ static loff_t iomap_unshare_iter(struct
 		status = iomap_write_begin(iter, pos, bytes, &folio);
 		if (unlikely(status))
 			return status;
+		if (iter->iomap.flags & IOMAP_F_STALE)
+			break;
 
 		status = iomap_write_end(iter, pos, bytes, bytes, folio);
 		if (WARN_ON_ONCE(status == 0))
@@ -1131,6 +1156,8 @@ static loff_t iomap_zero_iter(struct iom
 		status = iomap_write_begin(iter, pos, bytes, &folio);
 		if (status)
 			return status;
+		if (iter->iomap.flags & IOMAP_F_STALE)
+			break;
 
 		offset = offset_in_folio(folio, pos);
 		if (bytes > folio_size(folio) - offset)
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -7,12 +7,28 @@
 #include <linux/iomap.h>
 #include "trace.h"
 
+/*
+ * Advance to the next range we need to map.
+ *
+ * If the iomap is marked IOMAP_F_STALE, it means the existing map was not fully
+ * processed - it was aborted because the extent the iomap spanned may have been
+ * changed during the operation. In this case, the iteration behaviour is to
+ * remap the unprocessed range of the iter, and that means we may need to remap
+ * even when we've made no progress (i.e. iter->processed = 0). Hence the
+ * "finished iterating" case needs to distinguish between
+ * (processed = 0) meaning we are done and (processed = 0 && stale) meaning we
+ * need to remap the entire remaining range.
+ */
 static inline int iomap_iter_advance(struct iomap_iter *iter)
 {
+	bool stale = iter->iomap.flags & IOMAP_F_STALE;
+
 	/* handle the previous iteration (if any) */
 	if (iter->iomap.length) {
-		if (iter->processed <= 0)
+		if (iter->processed < 0)
 			return iter->processed;
+		if (!iter->processed && !stale)
+			return 0;
 		if (WARN_ON_ONCE(iter->processed > iomap_length(iter)))
 			return -EIO;
 		iter->pos += iter->processed;
@@ -33,6 +49,7 @@ static inline void iomap_iter_done(struc
 	WARN_ON_ONCE(iter->iomap.offset > iter->pos);
 	WARN_ON_ONCE(iter->iomap.length == 0);
 	WARN_ON_ONCE(iter->iomap.offset + iter->iomap.length <= iter->pos);
+	WARN_ON_ONCE(iter->iomap.flags & IOMAP_F_STALE);
 
 	trace_iomap_iter_dstmap(iter->inode, &iter->iomap);
 	if (iter->srcmap.type != IOMAP_HOLE)
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -49,26 +49,35 @@ struct vm_fault;
  *
  * IOMAP_F_BUFFER_HEAD indicates that the file system requires the use of
  * buffer heads for this mapping.
+ *
+ * IOMAP_F_XATTR indicates that the iomap is for an extended attribute extent
+ * rather than a file data extent.
  */
-#define IOMAP_F_NEW		0x01
-#define IOMAP_F_DIRTY		0x02
-#define IOMAP_F_SHARED		0x04
-#define IOMAP_F_MERGED		0x08
-#define IOMAP_F_BUFFER_HEAD	0x10
-#define IOMAP_F_ZONE_APPEND	0x20
+#define IOMAP_F_NEW		(1U << 0)
+#define IOMAP_F_DIRTY		(1U << 1)
+#define IOMAP_F_SHARED		(1U << 2)
+#define IOMAP_F_MERGED		(1U << 3)
+#define IOMAP_F_BUFFER_HEAD	(1U << 4)
+#define IOMAP_F_ZONE_APPEND	(1U << 5)
+#define IOMAP_F_XATTR		(1U << 6)
 
 /*
  * Flags set by the core iomap code during operations:
  *
  * IOMAP_F_SIZE_CHANGED indicates to the iomap_end method that the file size
  * has changed as the result of this write operation.
+ *
+ * IOMAP_F_STALE indicates that the iomap is not valid any longer and the file
+ * range it covers needs to be remapped by the high level before the operation
+ * can proceed.
  */
-#define IOMAP_F_SIZE_CHANGED	0x100
+#define IOMAP_F_SIZE_CHANGED	(1U << 8)
+#define IOMAP_F_STALE		(1U << 9)
 
 /*
  * Flags from 0x1000 up are for file system specific usage:
  */
-#define IOMAP_F_PRIVATE		0x1000
+#define IOMAP_F_PRIVATE		(1U << 12)
 
 
 /*
@@ -89,6 +98,7 @@ struct iomap {
 	void			*inline_data;
 	void			*private; /* filesystem private */
 	const struct iomap_page_ops *page_ops;
+	u64			validity_cookie; /* used with .iomap_valid() */
 };
 
 static inline sector_t iomap_sector(const struct iomap *iomap, loff_t pos)
@@ -128,6 +138,23 @@ struct iomap_page_ops {
 	int (*page_prepare)(struct inode *inode, loff_t pos, unsigned len);
 	void (*page_done)(struct inode *inode, loff_t pos, unsigned copied,
 			struct page *page);
+
+	/*
+	 * Check that the cached iomap still maps correctly to the filesystem's
+	 * internal extent map. FS internal extent maps can change while iomap
+	 * is iterating a cached iomap, so this hook allows iomap to detect that
+	 * the iomap needs to be refreshed during a long running write
+	 * operation.
+	 *
+	 * The filesystem can store internal state (e.g. a sequence number) in
+	 * iomap->validity_cookie when the iomap is first mapped to be able to
+	 * detect changes between mapping time and whenever .iomap_valid() is
+	 * called.
+	 *
+	 * This is called with the folio over the specified file position held
+	 * locked by the iomap code.
+	 */
+	bool (*iomap_valid)(struct inode *inode, const struct iomap *iomap);
 };
 
 /*


