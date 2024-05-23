Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F3D14A605;
	Thu, 23 May 2024 13:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470383; cv=none; b=JOIKqxG8oGqx0wU+UYxMp+SKN09RtF5ySS9Qgfib6XVHgKE9fmW0eCTJM4fD5wRlsvhE0qLGTgDIlQ5JigXaB02ba9UMauuQY7RRoa4UQCJ4iT7iWv4htZutWQTkTw1xYhv6rvTzZwH+AFy2g4e8j0C+3hO/p0zmOqk2FzEynx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470383; c=relaxed/simple;
	bh=hdz4o+CDamjgLKKZE+49fJNUknFRGcmxg3VKH6BWGCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ooZWGUE7urKB/tMzRAq8XzM/SdbzjBx2/m8rqdA3seRqOhmF8Xj/FymbsTSd1YhZuAT+pZbOZVPENmKcHxQOlC8w8zHYT2BXu+OBAJo1FXnrjHzpAem4w8ibcy5e+dqMS6N5AAnC+KNrxePL5Jqpt1ngnfOxsmYlLiV30uAiuo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c/BchWFc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/BchWFc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EF5C2BD10;
	Thu, 23 May 2024 13:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470382;
	bh=hdz4o+CDamjgLKKZE+49fJNUknFRGcmxg3VKH6BWGCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/BchWFc8rvCrSIqgdzzzR3cousJJF2YKmaW5jRoQqn+erUo3RCZZg9L/+rDr5jmc
	 ccXrKhT0YyMiwj0btIK+MVc0IjM3DWQ0FjqJ9V9HbmfHq89K+dgdDH6THpLf6CQ/Nj
	 q2uXV1OmLYNcx5S2a3oLr36tmg4mYLQQxpzs9LWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 18/45] xfs: drop write error injection is unfixable, remove it
Date: Thu, 23 May 2024 15:13:09 +0200
Message-ID: <20240523130333.180855255@linuxfoundation.org>
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

[ Upstream commit 6e8af15ccdc4e138a5b529c1901a0013e1dcaa09 ]

With the changes to scan the page cache for dirty data to avoid data
corruptions from partial write cleanup racing with other page cache
operations, the drop writes error injection no longer works the same
way it used to and causes xfs/196 to fail. This is because xfs/196
writes to the file and populates the page cache before it turns on
the error injection and starts failing -overwrites-.

The result is that the original drop-writes code failed writes only
-after- overwriting the data in the cache, followed by invalidates
the cached data, then punching out the delalloc extent from under
that data.

On the surface, this looks fine. The problem is that page cache
invalidation *doesn't guarantee that it removes anything from the
page cache* and it doesn't change the dirty state of the folio. When
block size == page size and we do page aligned IO (as xfs/196 does)
everything happens to align perfectly and page cache invalidation
removes the single page folios that span the written data. Hence the
followup delalloc punch pass does not find cached data over that
range and it can punch the extent out.

IOWs, xfs/196 "works" for block size == page size with the new
code. I say "works", because it actually only works for the case
where IO is page aligned, and no data was read from disk before
writes occur. Because the moment we actually read data first, the
readahead code allocates multipage folios and suddenly the
invalidate code goes back to zeroing subfolio ranges without
changing dirty state.

Hence, with multipage folios in play, block size == page size is
functionally identical to block size < page size behaviour, and
drop-writes is manifestly broken w.r.t to this case. Invalidation of
a subfolio range doesn't result in the folio being removed from the
cache, just the range gets zeroed. Hence after we've sequentially
walked over a folio that we've dirtied (via write data) and then
invalidated, we end up with a dirty folio full of zeroed data.

And because the new code skips punching ranges that have dirty
folios covering them, we end up leaving the delalloc range intact
after failing all the writes. Hence failed writes now end up
writing zeroes to disk in the cases where invalidation zeroes folios
rather than removing them from cache.

This is a fundamental change of behaviour that is needed to avoid
the data corruption vectors that exist in the old write fail path,
and it renders the drop-writes injection non-functional and
unworkable as it stands.

As it is, I think the error injection is also now unnecessary, as
partial writes that need delalloc extent are going to be a lot more
common with stale iomap detection in place. Hence this patch removes
the drop-writes error injection completely. xfs/196 can remain for
testing kernels that don't have this data corruption fix, but those
that do will report:

xfs/196 3s ... [not run] XFS error injection drop_writes unknown on this kernel.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_errortag.h |   12 +++++-------
 fs/xfs/xfs_error.c           |   27 ++++++++++++++++++++-------
 fs/xfs/xfs_iomap.c           |    9 ---------
 3 files changed, 25 insertions(+), 23 deletions(-)

--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -40,13 +40,12 @@
 #define XFS_ERRTAG_REFCOUNT_FINISH_ONE			25
 #define XFS_ERRTAG_BMAP_FINISH_ONE			26
 #define XFS_ERRTAG_AG_RESV_CRITICAL			27
+
 /*
- * DEBUG mode instrumentation to test and/or trigger delayed allocation
- * block killing in the event of failed writes. When enabled, all
- * buffered writes are silenty dropped and handled as if they failed.
- * All delalloc blocks in the range of the write (including pre-existing
- * delalloc blocks!) are tossed as part of the write failure error
- * handling sequence.
+ * Drop-writes support removed because write error handling cannot trash
+ * pre-existing delalloc extents in any useful way anymore. We retain the
+ * definition so that we can reject it as an invalid value in
+ * xfs_errortag_valid().
  */
 #define XFS_ERRTAG_DROP_WRITES				28
 #define XFS_ERRTAG_LOG_BAD_CRC				29
@@ -95,7 +94,6 @@
 #define XFS_RANDOM_REFCOUNT_FINISH_ONE			1
 #define XFS_RANDOM_BMAP_FINISH_ONE			1
 #define XFS_RANDOM_AG_RESV_CRITICAL			4
-#define XFS_RANDOM_DROP_WRITES				1
 #define XFS_RANDOM_LOG_BAD_CRC				1
 #define XFS_RANDOM_LOG_ITEM_PIN				1
 #define XFS_RANDOM_BUF_LRU_REF				2
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -46,7 +46,7 @@ static unsigned int xfs_errortag_random_
 	XFS_RANDOM_REFCOUNT_FINISH_ONE,
 	XFS_RANDOM_BMAP_FINISH_ONE,
 	XFS_RANDOM_AG_RESV_CRITICAL,
-	XFS_RANDOM_DROP_WRITES,
+	0, /* XFS_RANDOM_DROP_WRITES has been removed */
 	XFS_RANDOM_LOG_BAD_CRC,
 	XFS_RANDOM_LOG_ITEM_PIN,
 	XFS_RANDOM_BUF_LRU_REF,
@@ -162,7 +162,6 @@ XFS_ERRORTAG_ATTR_RW(refcount_continue_u
 XFS_ERRORTAG_ATTR_RW(refcount_finish_one,	XFS_ERRTAG_REFCOUNT_FINISH_ONE);
 XFS_ERRORTAG_ATTR_RW(bmap_finish_one,	XFS_ERRTAG_BMAP_FINISH_ONE);
 XFS_ERRORTAG_ATTR_RW(ag_resv_critical,	XFS_ERRTAG_AG_RESV_CRITICAL);
-XFS_ERRORTAG_ATTR_RW(drop_writes,	XFS_ERRTAG_DROP_WRITES);
 XFS_ERRORTAG_ATTR_RW(log_bad_crc,	XFS_ERRTAG_LOG_BAD_CRC);
 XFS_ERRORTAG_ATTR_RW(log_item_pin,	XFS_ERRTAG_LOG_ITEM_PIN);
 XFS_ERRORTAG_ATTR_RW(buf_lru_ref,	XFS_ERRTAG_BUF_LRU_REF);
@@ -206,7 +205,6 @@ static struct attribute *xfs_errortag_at
 	XFS_ERRORTAG_ATTR_LIST(refcount_finish_one),
 	XFS_ERRORTAG_ATTR_LIST(bmap_finish_one),
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_critical),
-	XFS_ERRORTAG_ATTR_LIST(drop_writes),
 	XFS_ERRORTAG_ATTR_LIST(log_bad_crc),
 	XFS_ERRORTAG_ATTR_LIST(log_item_pin),
 	XFS_ERRORTAG_ATTR_LIST(buf_lru_ref),
@@ -256,6 +254,19 @@ xfs_errortag_del(
 	kmem_free(mp->m_errortag);
 }
 
+static bool
+xfs_errortag_valid(
+	unsigned int		error_tag)
+{
+	if (error_tag >= XFS_ERRTAG_MAX)
+		return false;
+
+	/* Error out removed injection types */
+	if (error_tag == XFS_ERRTAG_DROP_WRITES)
+		return false;
+	return true;
+}
+
 bool
 xfs_errortag_test(
 	struct xfs_mount	*mp,
@@ -277,7 +288,9 @@ xfs_errortag_test(
 	if (!mp->m_errortag)
 		return false;
 
-	ASSERT(error_tag < XFS_ERRTAG_MAX);
+	if (!xfs_errortag_valid(error_tag))
+		return false;
+
 	randfactor = mp->m_errortag[error_tag];
 	if (!randfactor || prandom_u32_max(randfactor))
 		return false;
@@ -293,7 +306,7 @@ xfs_errortag_get(
 	struct xfs_mount	*mp,
 	unsigned int		error_tag)
 {
-	if (error_tag >= XFS_ERRTAG_MAX)
+	if (!xfs_errortag_valid(error_tag))
 		return -EINVAL;
 
 	return mp->m_errortag[error_tag];
@@ -305,7 +318,7 @@ xfs_errortag_set(
 	unsigned int		error_tag,
 	unsigned int		tag_value)
 {
-	if (error_tag >= XFS_ERRTAG_MAX)
+	if (!xfs_errortag_valid(error_tag))
 		return -EINVAL;
 
 	mp->m_errortag[error_tag] = tag_value;
@@ -319,7 +332,7 @@ xfs_errortag_add(
 {
 	BUILD_BUG_ON(ARRAY_SIZE(xfs_errortag_random_default) != XFS_ERRTAG_MAX);
 
-	if (error_tag >= XFS_ERRTAG_MAX)
+	if (!xfs_errortag_valid(error_tag))
 		return -EINVAL;
 
 	return xfs_errortag_set(mp, error_tag,
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1190,15 +1190,6 @@ xfs_buffered_write_iomap_end(
 	struct xfs_mount	*mp = XFS_M(inode->i_sb);
 	int			error;
 
-	/*
-	 * Behave as if the write failed if drop writes is enabled. Set the NEW
-	 * flag to force delalloc cleanup.
-	 */
-	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_DROP_WRITES)) {
-		iomap->flags |= IOMAP_F_NEW;
-		written = 0;
-	}
-
 	error = iomap_file_buffered_write_punch_delalloc(inode, iomap, offset,
 			length, written, &xfs_buffered_write_delalloc_punch);
 	if (error && !xfs_is_shutdown(mp)) {


