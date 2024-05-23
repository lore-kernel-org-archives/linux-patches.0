Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3591814AD36;
	Thu, 23 May 2024 13:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470360; cv=none; b=FhDzM3oBs3tYyTYSGKs2os8YYMBzmHAGBHxV2QAJXNdYoBSry9k3y3KkmTSgfRXo5ufds2u1QcjALO9Hv3JfJPhOyyncel62G9TsCNJF5YgU19sb9PSi/94QggQiJEHog/yjRCECK27aWGnAH6hBZZMat6Af8YeIQCb2Z+Vd96g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470360; c=relaxed/simple;
	bh=DeVNXyER3vM85IiPX8KBsSPd06AXCdkdbgVFBEQqdgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ybgy88ZT26CPw5dqzwRZT87fKm6R89moNpyBI5vvUT7jGF/05t/enu7mHbrugQp7vYothgIurgEIL8HNILZzxa/ExP/J2e4SWebj8PjWaqYn/C83fQd1Lvlzt6cdDfMEIZt8aYXxmfKHK/xxp6aSVRCOB0938e3RYW3Cp6JLjhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wkF6XE+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkF6XE+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C69C32782;
	Thu, 23 May 2024 13:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470360;
	bh=DeVNXyER3vM85IiPX8KBsSPd06AXCdkdbgVFBEQqdgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wkF6XE+OEMi2QkEEXdHub8gTfst6aCCwh6186DWhkING5lgK4WVXkvbnNAuSmmRB+
	 gqbf38VSm9XlKf/MvHq75qlDIG8CPqGu7bWxMt+YOdefkJfle1XsFe21PXLAbEn2Zz
	 IS9QA2L0WgBrTeobRFxMOq8Agt6SLg9SU3LZa2bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 10/45] xfs: write page faults in iomap are not buffered writes
Date: Thu, 23 May 2024 15:13:01 +0200
Message-ID: <20240523130332.884192289@linuxfoundation.org>
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

[ Upstream commit 118e021b4b66f758f8e8f21dc0e5e0a4c721e69e ]

When we reserve a delalloc region in xfs_buffered_write_iomap_begin,
we mark the iomap as IOMAP_F_NEW so that the the write context
understands that it allocated the delalloc region.

If we then fail that buffered write, xfs_buffered_write_iomap_end()
checks for the IOMAP_F_NEW flag and if it is set, it punches out
the unused delalloc region that was allocated for the write.

The assumption this code makes is that all buffered write operations
that can allocate space are run under an exclusive lock (i_rwsem).
This is an invalid assumption: page faults in mmap()d regions call
through this same function pair to map the file range being faulted
and this runs only holding the inode->i_mapping->invalidate_lock in
shared mode.

IOWs, we can have races between page faults and write() calls that
fail the nested page cache write operation that result in data loss.
That is, the failing iomap_end call will punch out the data that
the other racing iomap iteration brought into the page cache. This
can be reproduced with generic/34[46] if we arbitrarily fail page
cache copy-in operations from write() syscalls.

Code analysis tells us that the iomap_page_mkwrite() function holds
the already instantiated and uptodate folio locked across the iomap
mapping iterations. Hence the folio cannot be removed from memory
whilst we are mapping the range it covers, and as such we do not
care if the mapping changes state underneath the iomap iteration
loop:

1. if the folio is not already dirty, there is no writeback races
   possible.
2. if we allocated the mapping (delalloc or unwritten), the folio
   cannot already be dirty. See #1.
3. If the folio is already dirty, it must be up to date. As we hold
   it locked, it cannot be reclaimed from memory. Hence we always
   have valid data in the page cache while iterating the mapping.
4. Valid data in the page cache can exist when the underlying
   mapping is DELALLOC, UNWRITTEN or WRITTEN. Having the mapping
   change from DELALLOC->UNWRITTEN or UNWRITTEN->WRITTEN does not
   change the data in the page - it only affects actions if we are
   initialising a new page. Hence #3 applies  and we don't care
   about these extent map transitions racing with
   iomap_page_mkwrite().
5. iomap_page_mkwrite() checks for page invalidation races
   (truncate, hole punch, etc) after it locks the folio. We also
   hold the mapping->invalidation_lock here, and hence the mapping
   cannot change due to extent removal operations while we are
   iterating the folio.

As such, filesystems that don't use bufferheads will never fail
the iomap_folio_mkwrite_iter() operation on the current mapping,
regardless of whether the iomap should be considered stale.

Further, the range we are asked to iterate is limited to the range
inside EOF that the folio spans. Hence, for XFS, we will only map
the exact range we are asked for, and we will only do speculative
preallocation with delalloc if we are mapping a hole at the EOF
page. The iterator will consume the entire range of the folio that
is within EOF, and anything beyond the EOF block cannot be accessed.
We never need to truncate this post-EOF speculative prealloc away in
the context of the iomap_page_mkwrite() iterator because if it
remains unused we'll remove it when the last reference to the inode
goes away.

Hence we don't actually need an .iomap_end() cleanup/error handling
path at all for iomap_page_mkwrite() for XFS. This means we can
separate the page fault processing from the complexity of the
.iomap_end() processing in the buffered write path. This also means
that the buffered write path will also be able to take the
mapping->invalidate_lock as necessary.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_file.c  |    2 +-
 fs/xfs/xfs_iomap.c |    9 +++++++++
 fs/xfs/xfs_iomap.h |    1 +
 3 files changed, 11 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1325,7 +1325,7 @@ __xfs_filemap_fault(
 		if (write_fault) {
 			xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 			ret = iomap_page_mkwrite(vmf,
-					&xfs_buffered_write_iomap_ops);
+					&xfs_page_mkwrite_iomap_ops);
 			xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 		} else {
 			ret = filemap_fault(vmf);
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1187,6 +1187,15 @@ const struct iomap_ops xfs_buffered_writ
 	.iomap_end		= xfs_buffered_write_iomap_end,
 };
 
+/*
+ * iomap_page_mkwrite() will never fail in a way that requires delalloc extents
+ * that it allocated to be revoked. Hence we do not need an .iomap_end method
+ * for this operation.
+ */
+const struct iomap_ops xfs_page_mkwrite_iomap_ops = {
+	.iomap_begin		= xfs_buffered_write_iomap_begin,
+};
+
 static int
 xfs_read_iomap_begin(
 	struct inode		*inode,
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -47,6 +47,7 @@ xfs_aligned_fsb_count(
 }
 
 extern const struct iomap_ops xfs_buffered_write_iomap_ops;
+extern const struct iomap_ops xfs_page_mkwrite_iomap_ops;
 extern const struct iomap_ops xfs_direct_write_iomap_ops;
 extern const struct iomap_ops xfs_read_iomap_ops;
 extern const struct iomap_ops xfs_seek_iomap_ops;


