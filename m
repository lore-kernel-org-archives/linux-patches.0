Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677061C26
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A0FC433D6;
	Wed, 23 Nov 2022 09:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194639;
	bh=GhXVaMMPq+UaqeaYn61W7XBXEWGHPVFdhdeY8zM2vTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ds6vyVWjCDyOvwJYRz7X7WFbOZ5h/3EBqXGl5g3KNHaEYovrLeQLuaTvBaa5JOBvU
	 CzDgtzcmQz8EueDOLqLJskgaT+uxqo7cSio/W0pmOOKLx89miI9hbK7CvNWjEu1pyY
	 7oiZOjB6mxUqZsNio2BNQ+1ps/MHHRlemVt4jpfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 002/156] xfs: rename xfs_bmap_is_real_extent to is_written_extent
Date: Wed, 23 Nov 2022 09:49:19 +0100
Message-Id: <20221123084557.926302292@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 877f58f53684f14ca3202640f70592bf44890924 upstream.

[ Slightly modify fs/xfs/libxfs/xfs_rtbitmap.c & fs/xfs/xfs_reflink.c to
  resolve merge conflict ]

The name of this predicate is a little misleading -- it decides if the
extent mapping is allocated and written.  Change the name to be more
direct, as we're going to add a new predicate in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.h     |    2 +-
 fs/xfs/libxfs/xfs_rtbitmap.c |    2 +-
 fs/xfs/xfs_reflink.c         |    8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -163,7 +163,7 @@ static inline int xfs_bmapi_whichfork(in
  * Return true if the extent is a real, allocated extent, or false if it is  a
  * delayed allocation, and unwritten extent or a hole.
  */
-static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
+static inline bool xfs_bmap_is_written_extent(struct xfs_bmbt_irec *irec)
 {
 	return irec->br_state != XFS_EXT_UNWRITTEN &&
 		irec->br_startblock != HOLESTARTBLOCK &&
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -70,7 +70,7 @@ xfs_rtbuf_get(
 	if (error)
 		return error;
 
-	if (nmap == 0 || !xfs_bmap_is_real_extent(&map)) {
+	if (nmap == 0 || !xfs_bmap_is_written_extent(&map)) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
 	}
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -181,7 +181,7 @@ xfs_reflink_trim_around_shared(
 	int			error = 0;
 
 	/* Holes, unwritten, and delalloc extents cannot be shared */
-	if (!xfs_is_cow_inode(ip) || !xfs_bmap_is_real_extent(irec)) {
+	if (!xfs_is_cow_inode(ip) || !xfs_bmap_is_written_extent(irec)) {
 		*shared = false;
 		return 0;
 	}
@@ -657,7 +657,7 @@ xfs_reflink_end_cow_extent(
 	 * preallocations can leak into the range we are called upon, and we
 	 * need to skip them.
 	 */
-	if (!xfs_bmap_is_real_extent(&got)) {
+	if (!xfs_bmap_is_written_extent(&got)) {
 		*end_fsb = del.br_startoff;
 		goto out_cancel;
 	}
@@ -998,7 +998,7 @@ xfs_reflink_remap_extent(
 	xfs_off_t		new_isize)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	bool			real_extent = xfs_bmap_is_real_extent(irec);
+	bool			real_extent = xfs_bmap_is_written_extent(irec);
 	struct xfs_trans	*tp;
 	unsigned int		resblks;
 	struct xfs_bmbt_irec	uirec;
@@ -1427,7 +1427,7 @@ xfs_reflink_dirty_extents(
 			goto out;
 		if (nmaps == 0)
 			break;
-		if (!xfs_bmap_is_real_extent(&map[0]))
+		if (!xfs_bmap_is_written_extent(&map[0]))
 			goto next;
 
 		map[1] = map[0];


