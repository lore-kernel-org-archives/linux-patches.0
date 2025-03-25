Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FB9265CBF;
	Tue, 25 Mar 2025 12:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905641; cv=none; b=MDwCY8aa9kyMgIz5SK714JOiYLQ7JHXtcLVoojzradrvY5AcvFS+Jx+eH4WP03iSEiU22MP+pr2DuF3/Ab2OwfSsdQpCWqRJbqnDG1Wx80xYqCL5xB+XCExkIVJ3IDfTvb+Nd87NK1LIXDdKxxK6prXGxab/+coYrAyor5FQP38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905641; c=relaxed/simple;
	bh=+5Gs/2niLoHgt44VnRqAPDw1Chicl7A5Td7aJe9HFMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k02w21ZglFLXqZUwkXpXNIoFeyC4KErC41sIEH+y5TZ3MLm79VDt2bCITTOFrvG/+g0V3tCtWwX/p4eI9EY9Wot5WzheVxAvf3MTMbIlHIqNElJHAihSwigtsIzn/hLj+rfEgEmvjb+puZIJzzndijRR6h6L7NaSiYcSDC+MbHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ma3QnF9j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ma3QnF9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB5AC4CEE9;
	Tue, 25 Mar 2025 12:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905641;
	bh=+5Gs/2niLoHgt44VnRqAPDw1Chicl7A5Td7aJe9HFMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ma3QnF9jpqksBTK750IAKh9TzJV6GLjHtXuvgivVoV96jfjDaUGeZk9Pr4rAmmSSr
	 4lS1rUsiMN1HPXoXxPrwgN68rOtr9HURWA5kl7358x32NEEzVnan+iaCbgmGavhe2Q
	 T9JuYsc/jPZrVm+0ZktVyPkRNMENz7X6bHj93Qus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 085/198] xfs: use deferred frees for btree block freeing
Date: Tue, 25 Mar 2025 08:20:47 -0400
Message-ID: <20250325122158.873586738@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit b742d7b4f0e03df25c2a772adcded35044b625ca ]

[ 6.1: resolved conflict in xfs_extfree_item.c ]

Btrees that aren't freespace management trees use the normal extent
allocation and freeing routines for their blocks. Hence when a btree
block is freed, a direct call to xfs_free_extent() is made and the
extent is immediately freed. This puts the entire free space
management btrees under this path, so we are stacking btrees on
btrees in the call stack. The inobt, finobt and refcount btrees
all do this.

However, the bmap btree does not do this - it calls
xfs_free_extent_later() to defer the extent free operation via an
XEFI and hence it gets processed in deferred operation processing
during the commit of the primary transaction (i.e. via intent
chaining).

We need to change xfs_free_extent() to behave in a non-blocking
manner so that we can avoid deadlocks with busy extents near ENOSPC
in transactions that free multiple extents. Inserting or removing a
record from a btree can cause a multi-level tree merge operation and
that will free multiple blocks from the btree in a single
transaction. i.e. we can call xfs_free_extent() multiple times, and
hence the btree manipulation transaction is vulnerable to this busy
extent deadlock vector.

To fix this, convert all the remaining callers of xfs_free_extent()
to use xfs_free_extent_later() to queue XEFIs and hence defer
processing of the extent frees to a context that can be safely
restarted if a deadlock condition is detected.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_ag.c             |    2 +-
 fs/xfs/libxfs/xfs_alloc.c          |    4 ++++
 fs/xfs/libxfs/xfs_alloc.h          |    8 +++++---
 fs/xfs/libxfs/xfs_bmap.c           |    8 +++++---
 fs/xfs/libxfs/xfs_bmap_btree.c     |    3 ++-
 fs/xfs/libxfs/xfs_ialloc.c         |    8 ++++----
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    3 +--
 fs/xfs/libxfs/xfs_refcount.c       |    9 ++++++---
 fs/xfs/libxfs/xfs_refcount_btree.c |    8 +-------
 fs/xfs/xfs_extfree_item.c          |    3 ++-
 fs/xfs/xfs_reflink.c               |    3 ++-
 11 files changed, 33 insertions(+), 26 deletions(-)

--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -907,7 +907,7 @@ xfs_ag_shrink_space(
 			goto resv_err;
 
 		err2 = __xfs_free_extent_later(*tpp, args.fsbno, delta, NULL,
-				true);
+				XFS_AG_RESV_NONE, true);
 		if (err2)
 			goto resv_err;
 
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2507,6 +2507,7 @@ xfs_defer_agfl_block(
 	xefi->xefi_startblock = fsbno;
 	xefi->xefi_blockcount = 1;
 	xefi->xefi_owner = oinfo->oi_owner;
+	xefi->xefi_agresv = XFS_AG_RESV_AGFL;
 
 	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
 
@@ -2524,6 +2525,7 @@ __xfs_free_extent_later(
 	xfs_fsblock_t			bno,
 	xfs_filblks_t			len,
 	const struct xfs_owner_info	*oinfo,
+	enum xfs_ag_resv_type		type,
 	bool				skip_discard)
 {
 	struct xfs_extent_free_item	*xefi;
@@ -2544,6 +2546,7 @@ __xfs_free_extent_later(
 	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
 #endif
 	ASSERT(xfs_extfree_item_cache != NULL);
+	ASSERT(type != XFS_AG_RESV_AGFL);
 
 	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, bno, len)))
 		return -EFSCORRUPTED;
@@ -2552,6 +2555,7 @@ __xfs_free_extent_later(
 			       GFP_KERNEL | __GFP_NOFAIL);
 	xefi->xefi_startblock = bno;
 	xefi->xefi_blockcount = (xfs_extlen_t)len;
+	xefi->xefi_agresv = type;
 	if (skip_discard)
 		xefi->xefi_flags |= XFS_EFI_SKIP_DISCARD;
 	if (oinfo) {
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -215,7 +215,7 @@ xfs_buf_to_agfl_bno(
 
 int __xfs_free_extent_later(struct xfs_trans *tp, xfs_fsblock_t bno,
 		xfs_filblks_t len, const struct xfs_owner_info *oinfo,
-		bool skip_discard);
+		enum xfs_ag_resv_type type, bool skip_discard);
 
 /*
  * List of extents to be free "later".
@@ -227,6 +227,7 @@ struct xfs_extent_free_item {
 	xfs_fsblock_t		xefi_startblock;/* starting fs block number */
 	xfs_extlen_t		xefi_blockcount;/* number of blocks in extent */
 	unsigned int		xefi_flags;
+	enum xfs_ag_resv_type	xefi_agresv;
 };
 
 #define XFS_EFI_SKIP_DISCARD	(1U << 0) /* don't issue discard */
@@ -238,9 +239,10 @@ xfs_free_extent_later(
 	struct xfs_trans		*tp,
 	xfs_fsblock_t			bno,
 	xfs_filblks_t			len,
-	const struct xfs_owner_info	*oinfo)
+	const struct xfs_owner_info	*oinfo,
+	enum xfs_ag_resv_type		type)
 {
-	return __xfs_free_extent_later(tp, bno, len, oinfo, false);
+	return __xfs_free_extent_later(tp, bno, len, oinfo, type, false);
 }
 
 
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -574,7 +574,8 @@ xfs_bmap_btree_to_extents(
 		return error;
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
-	error = xfs_free_extent_later(cur->bc_tp, cbno, 1, &oinfo);
+	error = xfs_free_extent_later(cur->bc_tp, cbno, 1, &oinfo,
+			XFS_AG_RESV_NONE);
 	if (error)
 		return error;
 
@@ -5208,8 +5209,9 @@ xfs_bmap_del_extent_real(
 		} else {
 			error = __xfs_free_extent_later(tp, del->br_startblock,
 					del->br_blockcount, NULL,
-					(bflags & XFS_BMAPI_NODISCARD) ||
-					del->br_state == XFS_EXT_UNWRITTEN);
+					XFS_AG_RESV_NONE,
+					((bflags & XFS_BMAPI_NODISCARD) ||
+					del->br_state == XFS_EXT_UNWRITTEN));
 			if (error)
 				goto done;
 		}
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -288,7 +288,8 @@ xfs_bmbt_free_block(
 	int			error;
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
-	error = xfs_free_extent_later(cur->bc_tp, fsbno, 1, &oinfo);
+	error = xfs_free_extent_later(cur->bc_tp, fsbno, 1, &oinfo,
+			XFS_AG_RESV_NONE);
 	if (error)
 		return error;
 
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1846,8 +1846,8 @@ xfs_difree_inode_chunk(
 		/* not sparse, calculate extent info directly */
 		return xfs_free_extent_later(tp,
 				XFS_AGB_TO_FSB(mp, agno, sagbno),
-				M_IGEO(mp)->ialloc_blks,
-				&XFS_RMAP_OINFO_INODES);
+				M_IGEO(mp)->ialloc_blks, &XFS_RMAP_OINFO_INODES,
+				XFS_AG_RESV_NONE);
 	}
 
 	/* holemask is only 16-bits (fits in an unsigned long) */
@@ -1892,8 +1892,8 @@ xfs_difree_inode_chunk(
 		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
 		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
 		error = xfs_free_extent_later(tp,
-				XFS_AGB_TO_FSB(mp, agno, agbno),
-				contigblk, &XFS_RMAP_OINFO_INODES);
+				XFS_AGB_TO_FSB(mp, agno, agbno), contigblk,
+				&XFS_RMAP_OINFO_INODES, XFS_AG_RESV_NONE);
 		if (error)
 			return error;
 
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -160,8 +160,7 @@ __xfs_inobt_free_block(
 
 	xfs_inobt_mod_blockcount(cur, -1);
 	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp));
-	return xfs_free_extent(cur->bc_tp, cur->bc_ag.pag,
-			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno), 1,
+	return xfs_free_extent_later(cur->bc_tp, fsbno, 1,
 			&XFS_RMAP_OINFO_INOBT, resv);
 }
 
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1130,7 +1130,8 @@ xfs_refcount_adjust_extents(
 						cur->bc_ag.pag->pag_agno,
 						tmp.rc_startblock);
 				error = xfs_free_extent_later(cur->bc_tp, fsbno,
-						  tmp.rc_blockcount, NULL);
+						  tmp.rc_blockcount, NULL,
+						  XFS_AG_RESV_NONE);
 				if (error)
 					goto out_error;
 			}
@@ -1191,7 +1192,8 @@ xfs_refcount_adjust_extents(
 					cur->bc_ag.pag->pag_agno,
 					ext.rc_startblock);
 			error = xfs_free_extent_later(cur->bc_tp, fsbno,
-					ext.rc_blockcount, NULL);
+					ext.rc_blockcount, NULL,
+					XFS_AG_RESV_NONE);
 			if (error)
 				goto out_error;
 		}
@@ -1963,7 +1965,8 @@ xfs_refcount_recover_cow_leftovers(
 
 		/* Free the block. */
 		error = xfs_free_extent_later(tp, fsb,
-				rr->rr_rrec.rc_blockcount, NULL);
+				rr->rr_rrec.rc_blockcount, NULL,
+				XFS_AG_RESV_NONE);
 		if (error)
 			goto out_trans;
 
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -106,19 +106,13 @@ xfs_refcountbt_free_block(
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
-	int			error;
 
 	trace_xfs_refcountbt_free_block(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno), 1);
 	be32_add_cpu(&agf->agf_refcount_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
-	error = xfs_free_extent(cur->bc_tp, cur->bc_ag.pag,
-			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno), 1,
+	return xfs_free_extent_later(cur->bc_tp, fsbno, 1,
 			&XFS_RMAP_OINFO_REFC, XFS_AG_RESV_METADATA);
-	if (error)
-		return error;
-
-	return error;
 }
 
 STATIC int
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -369,7 +369,7 @@ xfs_trans_free_extent(
 
 	pag = xfs_perag_get(mp, agno);
 	error = __xfs_free_extent(tp, pag, agbno, xefi->xefi_blockcount,
-			&oinfo, XFS_AG_RESV_NONE,
+			&oinfo, xefi->xefi_agresv,
 			xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
 	xfs_perag_put(pag);
 
@@ -628,6 +628,7 @@ xfs_efi_item_recover(
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
 		struct xfs_extent_free_item	fake = {
 			.xefi_owner		= XFS_RMAP_OWN_UNKNOWN,
+			.xefi_agresv		= XFS_AG_RESV_NONE,
 		};
 		struct xfs_extent		*extp;
 
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -619,7 +619,8 @@ xfs_reflink_cancel_cow_blocks(
 					del.br_blockcount);
 
 			error = xfs_free_extent_later(*tpp, del.br_startblock,
-					  del.br_blockcount, NULL);
+					del.br_blockcount, NULL,
+					XFS_AG_RESV_NONE);
 			if (error)
 				break;
 


