Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5552629F;
	Mon, 24 Feb 2025 14:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407817; cv=none; b=I5wYLMDxAQfItREZv+EIuYw7ATQSGLKq4BGPEKGhha6jB5m912xHa5yHG6KfHOTkMMXkXyxokEn3WfQFXsut4r+takBKx7fLkvfg9g8RQhhtLymZdtMyassMq7dJN8IHA6c65GJWiDPMx8k7pM4zXicK1RnnCmquyB0d2zp1nMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407817; c=relaxed/simple;
	bh=pHwjZ3EqvEbJ/RZ6P7pwPYLs2JUeaGzxxVxYltVLFXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWU/4EEVWKVLCl+E9gyew/fLp3ZNKUznCn5gWf8PuIs97SZkP8NxNJd4TKRCchvsRodTMQSC8Yi9hQFXt2s/hqJUH9tE+zFqP/D1ymBgWhh0DqjgFEJ2aIn3tc5bBpGREwVrDF7aPC0rWv7SXDVMOLIhafGl5XpdKwvv0X+v0Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJVvqWJY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJVvqWJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28AEC4CED6;
	Mon, 24 Feb 2025 14:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407816;
	bh=pHwjZ3EqvEbJ/RZ6P7pwPYLs2JUeaGzxxVxYltVLFXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJVvqWJYSLIGsMNRrs/BJcfYs1Se4B6WFyC5TYV5Lj5WpTy67aU6tql5tapi3eHhV
	 3eJVO5JnzQ0TU+bPmtu03TLW+69ReQ0ujags935hWzoCArjeFG0ndhVtP0aZ0UGFPl
	 UTU3rvqrjPsUX9CkjgSnGTCnEyj0EfvPfMncMvqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xfs-stable@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 018/140] xfs: pass the exact range to initialize to xfs_initialize_perag
Date: Mon, 24 Feb 2025 15:33:37 +0100
Message-ID: <20250224142603.721528519@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 82742f8c3f1a93787a05a00aca50c2a565231f84 upstream.

[backport: dependency of 6a18765b]

Currently only the new agcount is passed to xfs_initialize_perag, which
requires lookups of existing AGs to skip them and complicates error
handling.  Also pass the previous agcount so that the range that
xfs_initialize_perag operates on is exactly defined.  That way the
extra lookups can be avoided, and error handling can clean up the
exact range from the old count to the last added perag structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_ag.c   |   28 ++++++----------------------
 fs/xfs/libxfs/xfs_ag.h   |    5 +++--
 fs/xfs/xfs_fsops.c       |   18 ++++++++----------
 fs/xfs/xfs_log_recover.c |    5 +++--
 fs/xfs/xfs_mount.c       |    4 ++--
 5 files changed, 22 insertions(+), 38 deletions(-)

--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -360,27 +360,16 @@ xfs_free_unused_perag_range(
 int
 xfs_initialize_perag(
 	struct xfs_mount	*mp,
-	xfs_agnumber_t		agcount,
+	xfs_agnumber_t		old_agcount,
+	xfs_agnumber_t		new_agcount,
 	xfs_rfsblock_t		dblocks,
 	xfs_agnumber_t		*maxagi)
 {
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		index;
-	xfs_agnumber_t		first_initialised = NULLAGNUMBER;
 	int			error;
 
-	/*
-	 * Walk the current per-ag tree so we don't try to initialise AGs
-	 * that already exist (growfs case). Allocate and insert all the
-	 * AGs we don't find ready for initialisation.
-	 */
-	for (index = 0; index < agcount; index++) {
-		pag = xfs_perag_get(mp, index);
-		if (pag) {
-			xfs_perag_put(pag);
-			continue;
-		}
-
+	for (index = old_agcount; index < new_agcount; index++) {
 		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
 		if (!pag) {
 			error = -ENOMEM;
@@ -425,21 +414,17 @@ xfs_initialize_perag(
 		/* Active ref owned by mount indicates AG is online. */
 		atomic_set(&pag->pag_active_ref, 1);
 
-		/* first new pag is fully initialized */
-		if (first_initialised == NULLAGNUMBER)
-			first_initialised = index;
-
 		/*
 		 * Pre-calculated geometry
 		 */
-		pag->block_count = __xfs_ag_block_count(mp, index, agcount,
+		pag->block_count = __xfs_ag_block_count(mp, index, new_agcount,
 				dblocks);
 		pag->min_block = XFS_AGFL_BLOCK(mp);
 		__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
 				&pag->agino_max);
 	}
 
-	index = xfs_set_inode_alloc(mp, agcount);
+	index = xfs_set_inode_alloc(mp, new_agcount);
 
 	if (maxagi)
 		*maxagi = index;
@@ -455,8 +440,7 @@ out_remove_pag:
 out_free_pag:
 	kmem_free(pag);
 out_unwind_new_pags:
-	/* unwind any prior newly initialized pags */
-	xfs_free_unused_perag_range(mp, first_initialised, agcount);
+	xfs_free_unused_perag_range(mp, old_agcount, index);
 	return error;
 }
 
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -135,8 +135,9 @@ __XFS_AG_OPSTATE(agfl_needs_reset, AGFL_
 
 void xfs_free_unused_perag_range(struct xfs_mount *mp, xfs_agnumber_t agstart,
 			xfs_agnumber_t agend);
-int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t agcount,
-			xfs_rfsblock_t dcount, xfs_agnumber_t *maxagi);
+int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t old_agcount,
+		xfs_agnumber_t agcount, xfs_rfsblock_t dcount,
+		xfs_agnumber_t *maxagi);
 int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
 void xfs_free_perag(struct xfs_mount *mp);
 
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -87,6 +87,7 @@ xfs_growfs_data_private(
 	struct xfs_mount	*mp,		/* mount point for filesystem */
 	struct xfs_growfs_data	*in)		/* growfs data input struct */
 {
+	xfs_agnumber_t		oagcount = mp->m_sb.sb_agcount;
 	struct xfs_buf		*bp;
 	int			error;
 	xfs_agnumber_t		nagcount;
@@ -94,7 +95,6 @@ xfs_growfs_data_private(
 	xfs_rfsblock_t		nb, nb_div, nb_mod;
 	int64_t			delta;
 	bool			lastag_extended = false;
-	xfs_agnumber_t		oagcount;
 	struct xfs_trans	*tp;
 	struct aghdr_init_data	id = {};
 	struct xfs_perag	*last_pag;
@@ -138,16 +138,14 @@ xfs_growfs_data_private(
 	if (delta == 0)
 		return 0;
 
-	oagcount = mp->m_sb.sb_agcount;
-	/* allocate the new per-ag structures */
-	if (nagcount > oagcount) {
-		error = xfs_initialize_perag(mp, nagcount, nb, &nagimax);
-		if (error)
-			return error;
-	} else if (nagcount < oagcount) {
-		/* TODO: shrinking the entire AGs hasn't yet completed */
+	/* TODO: shrinking the entire AGs hasn't yet completed */
+	if (nagcount < oagcount)
 		return -EINVAL;
-	}
+
+	/* allocate the new per-ag structures */
+	error = xfs_initialize_perag(mp, oagcount, nagcount, nb, &nagimax);
+	if (error)
+		return error;
 
 	if (delta > 0)
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3317,6 +3317,7 @@ xlog_do_recover(
 	struct xfs_mount	*mp = log->l_mp;
 	struct xfs_buf		*bp = mp->m_sb_bp;
 	struct xfs_sb		*sbp = &mp->m_sb;
+	xfs_agnumber_t		orig_agcount = sbp->sb_agcount;
 	int			error;
 
 	trace_xfs_log_recover(log, head_blk, tail_blk);
@@ -3365,8 +3366,8 @@ xlog_do_recover(
 	/* re-initialise in-core superblock and geometry structures */
 	mp->m_features |= xfs_sb_version_to_features(sbp);
 	xfs_reinit_percpu_counters(mp);
-	error = xfs_initialize_perag(mp, sbp->sb_agcount, sbp->sb_dblocks,
-			&mp->m_maxagi);
+	error = xfs_initialize_perag(mp, orig_agcount, sbp->sb_agcount,
+			sbp->sb_dblocks, &mp->m_maxagi);
 	if (error) {
 		xfs_warn(mp, "Failed post-recovery per-ag init: %d", error);
 		return error;
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -797,8 +797,8 @@ xfs_mountfs(
 	/*
 	 * Allocate and initialize the per-ag data.
 	 */
-	error = xfs_initialize_perag(mp, sbp->sb_agcount, mp->m_sb.sb_dblocks,
-			&mp->m_maxagi);
+	error = xfs_initialize_perag(mp, 0, sbp->sb_agcount,
+			mp->m_sb.sb_dblocks, &mp->m_maxagi);
 	if (error) {
 		xfs_warn(mp, "Failed per-ag init: %d", error);
 		goto out_free_dir;


