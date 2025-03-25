Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5410E26656F;
	Tue, 25 Mar 2025 12:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905636; cv=none; b=UqznmQdUHO+tz7CXagRgtDusy77KxlhLr9FNq6EVoEyRCUwKrMbye0Lkmd7oM/2VrpWnbUdngKUsDHU8guekf9Il1lHT5Vax6GI6nisDvP2V/YuRCOM5ZCIkZLMgMUlRVttv35krh+fHMBiJ7CPYnlHDeVGl3M7cwzZMr/Ejl1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905636; c=relaxed/simple;
	bh=m29PFHZDg3DQzkygNXFqSB8jiNoNyvZxMWls/hG3BFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fp++ZhDYH+y07COTcED7g//kZfpPyoxLXoRsbmPLvFVaSqnY/BeRPOLemTFNZeFK/p59cGKvtDCq5yC8VPTRI0+1zm1CvW5CT7yGJfVe2q2a7u3mERQp4/L/bgLTkeAOtY4warR8l7qOSkRRLaq5EMSbQaNIZKGNUz39o0iffQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yIIhXIYS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yIIhXIYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C1BC4CEE4;
	Tue, 25 Mar 2025 12:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905636;
	bh=m29PFHZDg3DQzkygNXFqSB8jiNoNyvZxMWls/hG3BFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yIIhXIYSknJpccHZxhs26+ufrtYVwcrNFJr91UDg5ss5fmbjvv4TtXXb/lF5zN5sB
	 jVGtdnSEqaOOkJni3fUM6vxadX61KOwawF9ohZG/olXI1WlAMIlSlI08n5IrZfrQkK
	 V2Ka1oOkWuTTSenWA6+oiYx/vw27SwWvYKz0oabw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 082/198] xfs: pass per-ag references to xfs_free_extent
Date: Tue, 25 Mar 2025 08:20:44 -0400
Message-ID: <20250325122158.794143491@linuxfoundation.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit b2ccab3199aa7cea9154d80ea2585312c5f6eba0 ]

Pass a reference to the per-AG structure to xfs_free_extent.  Most
callers already have one, so we can eliminate unnecessary lookups.  The
one exception to this is the EFI code, which the next patch will fix.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_ag.c             |    6 ++----
 fs/xfs/libxfs/xfs_alloc.c          |   15 +++++----------
 fs/xfs/libxfs/xfs_alloc.h          |    8 +++++---
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    7 +++++--
 fs/xfs/libxfs/xfs_refcount_btree.c |    5 +++--
 fs/xfs/scrub/repair.c              |    3 ++-
 fs/xfs/xfs_extfree_item.c          |    8 ++++++--
 7 files changed, 28 insertions(+), 24 deletions(-)

--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -981,10 +981,8 @@ xfs_ag_extend_space(
 	if (error)
 		return error;
 
-	error = xfs_free_extent(tp, XFS_AGB_TO_FSB(pag->pag_mount, pag->pag_agno,
-					be32_to_cpu(agf->agf_length) - len),
-				len, &XFS_RMAP_OINFO_SKIP_UPDATE,
-				XFS_AG_RESV_NONE);
+	error = xfs_free_extent(tp, pag, be32_to_cpu(agf->agf_length) - len,
+			len, &XFS_RMAP_OINFO_SKIP_UPDATE, XFS_AG_RESV_NONE);
 	if (error)
 		return error;
 
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3447,7 +3447,8 @@ xfs_free_extent_fix_freelist(
 int
 __xfs_free_extent(
 	struct xfs_trans		*tp,
-	xfs_fsblock_t			bno,
+	struct xfs_perag		*pag,
+	xfs_agblock_t			agbno,
 	xfs_extlen_t			len,
 	const struct xfs_owner_info	*oinfo,
 	enum xfs_ag_resv_type		type,
@@ -3455,12 +3456,9 @@ __xfs_free_extent(
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_buf			*agbp;
-	xfs_agnumber_t			agno = XFS_FSB_TO_AGNO(mp, bno);
-	xfs_agblock_t			agbno = XFS_FSB_TO_AGBNO(mp, bno);
 	struct xfs_agf			*agf;
 	int				error;
 	unsigned int			busy_flags = 0;
-	struct xfs_perag		*pag;
 
 	ASSERT(len != 0);
 	ASSERT(type != XFS_AG_RESV_AGFL);
@@ -3469,10 +3467,9 @@ __xfs_free_extent(
 			XFS_ERRTAG_FREE_EXTENT))
 		return -EIO;
 
-	pag = xfs_perag_get(mp, agno);
 	error = xfs_free_extent_fix_freelist(tp, pag, &agbp);
 	if (error)
-		goto err;
+		return error;
 	agf = agbp->b_addr;
 
 	if (XFS_IS_CORRUPT(mp, agbno >= mp->m_sb.sb_agblocks)) {
@@ -3486,20 +3483,18 @@ __xfs_free_extent(
 		goto err_release;
 	}
 
-	error = xfs_free_ag_extent(tp, agbp, agno, agbno, len, oinfo, type);
+	error = xfs_free_ag_extent(tp, agbp, pag->pag_agno, agbno, len, oinfo,
+			type);
 	if (error)
 		goto err_release;
 
 	if (skip_discard)
 		busy_flags |= XFS_EXTENT_BUSY_SKIP_DISCARD;
 	xfs_extent_busy_insert(tp, pag, agbno, len, busy_flags);
-	xfs_perag_put(pag);
 	return 0;
 
 err_release:
 	xfs_trans_brelse(tp, agbp);
-err:
-	xfs_perag_put(pag);
 	return error;
 }
 
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -130,7 +130,8 @@ xfs_alloc_vextent(
 int				/* error */
 __xfs_free_extent(
 	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_fsblock_t		bno,	/* starting block number of extent */
+	struct xfs_perag	*pag,
+	xfs_agblock_t		agbno,
 	xfs_extlen_t		len,	/* length of extent */
 	const struct xfs_owner_info	*oinfo,	/* extent owner */
 	enum xfs_ag_resv_type	type,	/* block reservation type */
@@ -139,12 +140,13 @@ __xfs_free_extent(
 static inline int
 xfs_free_extent(
 	struct xfs_trans	*tp,
-	xfs_fsblock_t		bno,
+	struct xfs_perag	*pag,
+	xfs_agblock_t		agbno,
 	xfs_extlen_t		len,
 	const struct xfs_owner_info	*oinfo,
 	enum xfs_ag_resv_type	type)
 {
-	return __xfs_free_extent(tp, bno, len, oinfo, type, false);
+	return __xfs_free_extent(tp, pag, agbno, len, oinfo, type, false);
 }
 
 int				/* error */
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -156,9 +156,12 @@ __xfs_inobt_free_block(
 	struct xfs_buf		*bp,
 	enum xfs_ag_resv_type	resv)
 {
+	xfs_fsblock_t		fsbno;
+
 	xfs_inobt_mod_blockcount(cur, -1);
-	return xfs_free_extent(cur->bc_tp,
-			XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp)), 1,
+	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp));
+	return xfs_free_extent(cur->bc_tp, cur->bc_ag.pag,
+			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno), 1,
 			&XFS_RMAP_OINFO_INOBT, resv);
 }
 
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -112,8 +112,9 @@ xfs_refcountbt_free_block(
 			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno), 1);
 	be32_add_cpu(&agf->agf_refcount_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
-	error = xfs_free_extent(cur->bc_tp, fsbno, 1, &XFS_RMAP_OINFO_REFC,
-			XFS_AG_RESV_METADATA);
+	error = xfs_free_extent(cur->bc_tp, cur->bc_ag.pag,
+			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno), 1,
+			&XFS_RMAP_OINFO_REFC, XFS_AG_RESV_METADATA);
 	if (error)
 		return error;
 
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -582,7 +582,8 @@ xrep_reap_block(
 	else if (resv == XFS_AG_RESV_AGFL)
 		error = xrep_put_freelist(sc, agbno);
 	else
-		error = xfs_free_extent(sc->tp, fsbno, 1, oinfo, resv);
+		error = xfs_free_extent(sc->tp, sc->sa.pag, agbno, 1, oinfo,
+				resv);
 	if (agf_bp != sc->sa.agf_bp)
 		xfs_trans_brelse(sc->tp, agf_bp);
 	if (error)
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -350,6 +350,7 @@ xfs_trans_free_extent(
 	struct xfs_owner_info		oinfo = { };
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_extent		*extp;
+	struct xfs_perag		*pag;
 	uint				next_extent;
 	xfs_agnumber_t			agno = XFS_FSB_TO_AGNO(mp,
 							xefi->xefi_startblock);
@@ -366,9 +367,12 @@ xfs_trans_free_extent(
 	trace_xfs_bmap_free_deferred(tp->t_mountp, agno, 0, agbno,
 			xefi->xefi_blockcount);
 
-	error = __xfs_free_extent(tp, xefi->xefi_startblock,
-			xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE,
+	pag = xfs_perag_get(mp, agno);
+	error = __xfs_free_extent(tp, pag, agbno, xefi->xefi_blockcount,
+			&oinfo, XFS_AG_RESV_NONE,
 			xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
+	xfs_perag_put(pag);
+
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
 	 * transaction is aborted, which:


