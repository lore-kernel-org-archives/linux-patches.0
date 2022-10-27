Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20773AD23
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEABC433C1;
	Thu, 27 Oct 2022 17:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890485;
	bh=F9GtqrPj2kB2LzqrkiZjLF0DvbFuZrybSzwvjkqZwnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JqyJaeZ8EfwvPh4dSN3uh1AWLS/1G8zbXe9ekHk1748qCeD2lP9B4NmahgtAeQoAF
	 sl7HWQFr8gIauRZkPBglRKOw74vTFdLy47XWkO/EjIG0EqfXLAo83GV8rIwgpqSqQJ
	 6KszA26Z6+Dr8VHb/V4XDvuSqZ7OAJ+vPIvuUIIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Foster <bfoster@redhat.com>,
	Allison Collins <allison.henderson@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 01/53] xfs: open code insert range extent split helper
Date: Thu, 27 Oct 2022 18:55:49 +0200
Message-Id: <20221027165049.873809195@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>
References: <20221027165049.817124510@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Brian Foster <bfoster@redhat.com>

commit b73df17e4c5ba977205253fb7ef54267717a3cba upstream.

The insert range operation currently splits the extent at the target
offset in a separate transaction and lock cycle from the one that
shifts extents. In preparation for reworking insert range into an
atomic operation, lift the code into the caller so it can be easily
condensed to a single rolling transaction and lock cycle and
eliminate the helper. No functional changes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   32 ++------------------------------
 fs/xfs/libxfs/xfs_bmap.h |    3 ++-
 fs/xfs/xfs_bmap_util.c   |   14 +++++++++++++-
 3 files changed, 17 insertions(+), 32 deletions(-)

--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5925,8 +5925,8 @@ del_cursor:
  * @split_fsb is a block where the extents is split.  If split_fsb lies in a
  * hole or the first block of extents, just return 0.
  */
-STATIC int
-xfs_bmap_split_extent_at(
+int
+xfs_bmap_split_extent(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	xfs_fileoff_t		split_fsb)
@@ -6037,34 +6037,6 @@ del_cursor:
 	return error;
 }
 
-int
-xfs_bmap_split_extent(
-	struct xfs_inode        *ip,
-	xfs_fileoff_t           split_fsb)
-{
-	struct xfs_mount        *mp = ip->i_mount;
-	struct xfs_trans        *tp;
-	int                     error;
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
-			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
-	if (error)
-		return error;
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-
-	error = xfs_bmap_split_extent_at(tp, ip, split_fsb);
-	if (error)
-		goto out;
-
-	return xfs_trans_commit(tp);
-
-out:
-	xfs_trans_cancel(tp);
-	return error;
-}
-
 /* Deferred mapping is only for real extents in the data fork. */
 static bool
 xfs_bmap_is_update_needed(
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -222,7 +222,8 @@ int	xfs_bmap_can_insert_extents(struct x
 int	xfs_bmap_insert_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
 		bool *done, xfs_fileoff_t stop_fsb);
-int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset);
+int	xfs_bmap_split_extent(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_fileoff_t split_offset);
 int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
 		xfs_fileoff_t off, xfs_filblks_t len, xfs_filblks_t prealloc,
 		struct xfs_bmbt_irec *got, struct xfs_iext_cursor *cur,
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1326,7 +1326,19 @@ xfs_insert_file_space(
 	 * is not the starting block of extent, we need to split the extent at
 	 * stop_fsb.
 	 */
-	error = xfs_bmap_split_extent(ip, stop_fsb);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
+			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
+	if (error)
+		return error;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+	error = xfs_bmap_split_extent(tp, ip, stop_fsb);
+	if (error)
+		goto out_trans_cancel;
+
+	error = xfs_trans_commit(tp);
 	if (error)
 		return error;
 


