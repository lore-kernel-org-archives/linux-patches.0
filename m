Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1E314A4E7;
	Tue, 17 Dec 2024 17:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456469; cv=none; b=uzGK9EhPfnOYZn/zV1vIZJ/iA+dgxQ7Qq9X0hsncnCDIKocVW11vMwdNBEsBaIlp3KbjyopB/ZvB413ukeV/Y0jBHihL+IyYtPT8xEHY5wYGdrEjFS+w9ZW6N28ojEWDNBH6cvHEgEm0ngAE67rVu19s81v7dCwY0hoY2Wz3DTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456469; c=relaxed/simple;
	bh=y0Pw70RI7C1ROkjHQxXMc8CfPzDuzipvpOsIKkCdEOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=br1rOK/+5/TyNIFfafJDLAKul30AJfCL7wDqFS5e6ulGHY922MOjbAjgHALR6v0OjE7pIQZzEy8qTIFQtV68Aut0grhuKhOLNkvBFzYC44pKNCu4JOlYtw7twydx5NQrT5GoCfHPpejj2yjBLWeihXiMSi+TWzQw5tsEZBQMJhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h1nT50Yi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h1nT50Yi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E725FC4CED3;
	Tue, 17 Dec 2024 17:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456469;
	bh=y0Pw70RI7C1ROkjHQxXMc8CfPzDuzipvpOsIKkCdEOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h1nT50YiYCF6ZVvBON7tA1W8rVig5gpOxrvCZ6cdrD2CvnDdFp15CXoHyL1BsDdBo
	 MqAR3955yjHW73drPNjSE63QC0oyoTi0uUWlOHK2x5cqCxOm167Pco10gxYvHyt34d
	 SXugfAdqU/qnjY0N2iNVCVlGOWIQh+NwgOZm177M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.12 070/172] xfs: return a 64-bit block count from xfs_btree_count_blocks
Date: Tue, 17 Dec 2024 18:07:06 +0100
Message-ID: <20241217170549.184457999@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit bd27c7bcdca25ce8067ebb94ded6ac1bd7b47317 upstream.

With the nrext64 feature enabled, it's possible for a data fork to have
2^48 extent mappings.  Even with a 64k fsblock size, that maps out to
a bmbt containing more than 2^32 blocks.  Therefore, this predicate must
return a u64 count to avoid an integer wraparound that will cause scrub
to do the wrong thing.

It's unlikely that any such filesystem currently exists, because the
incore bmbt would consume more than 64GB of kernel memory on its own,
and so far nobody except me has driven a filesystem that far, judging
from the lack of complaints.

Cc: <stable@vger.kernel.org> # v5.19
Fixes: df9ad5cc7a5240 ("xfs: Introduce macros to represent new maximum extent counts for data/attr forks")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_btree.c        |    4 ++--
 fs/xfs/libxfs/xfs_btree.h        |    2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c |    4 +++-
 fs/xfs/scrub/agheader.c          |    6 +++---
 fs/xfs/scrub/agheader_repair.c   |    6 +++---
 fs/xfs/scrub/fscounters.c        |    2 +-
 fs/xfs/scrub/ialloc.c            |    4 ++--
 fs/xfs/scrub/refcount.c          |    2 +-
 fs/xfs/xfs_bmap_util.c           |    2 +-
 9 files changed, 17 insertions(+), 15 deletions(-)

--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -5173,7 +5173,7 @@ xfs_btree_count_blocks_helper(
 	int			level,
 	void			*data)
 {
-	xfs_extlen_t		*blocks = data;
+	xfs_filblks_t		*blocks = data;
 	(*blocks)++;
 
 	return 0;
@@ -5183,7 +5183,7 @@ xfs_btree_count_blocks_helper(
 int
 xfs_btree_count_blocks(
 	struct xfs_btree_cur	*cur,
-	xfs_extlen_t		*blocks)
+	xfs_filblks_t		*blocks)
 {
 	*blocks = 0;
 	return xfs_btree_visit_blocks(cur, xfs_btree_count_blocks_helper,
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -485,7 +485,7 @@ typedef int (*xfs_btree_visit_blocks_fn)
 int xfs_btree_visit_blocks(struct xfs_btree_cur *cur,
 		xfs_btree_visit_blocks_fn fn, unsigned int flags, void *data);
 
-int xfs_btree_count_blocks(struct xfs_btree_cur *cur, xfs_extlen_t *blocks);
+int xfs_btree_count_blocks(struct xfs_btree_cur *cur, xfs_filblks_t *blocks);
 
 union xfs_btree_rec *xfs_btree_rec_addr(struct xfs_btree_cur *cur, int n,
 		struct xfs_btree_block *block);
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -743,6 +743,7 @@ xfs_finobt_count_blocks(
 {
 	struct xfs_buf		*agbp = NULL;
 	struct xfs_btree_cur	*cur;
+	xfs_filblks_t		blocks;
 	int			error;
 
 	error = xfs_ialloc_read_agi(pag, tp, 0, &agbp);
@@ -750,9 +751,10 @@ xfs_finobt_count_blocks(
 		return error;
 
 	cur = xfs_finobt_init_cursor(pag, tp, agbp);
-	error = xfs_btree_count_blocks(cur, tree_blocks);
+	error = xfs_btree_count_blocks(cur, &blocks);
 	xfs_btree_del_cursor(cur, error);
 	xfs_trans_brelse(tp, agbp);
+	*tree_blocks = blocks;
 
 	return error;
 }
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -434,7 +434,7 @@ xchk_agf_xref_btreeblks(
 {
 	struct xfs_agf		*agf = sc->sa.agf_bp->b_addr;
 	struct xfs_mount	*mp = sc->mp;
-	xfs_agblock_t		blocks;
+	xfs_filblks_t		blocks;
 	xfs_agblock_t		btreeblks;
 	int			error;
 
@@ -483,7 +483,7 @@ xchk_agf_xref_refcblks(
 	struct xfs_scrub	*sc)
 {
 	struct xfs_agf		*agf = sc->sa.agf_bp->b_addr;
-	xfs_agblock_t		blocks;
+	xfs_filblks_t		blocks;
 	int			error;
 
 	if (!sc->sa.refc_cur)
@@ -816,7 +816,7 @@ xchk_agi_xref_fiblocks(
 	struct xfs_scrub	*sc)
 {
 	struct xfs_agi		*agi = sc->sa.agi_bp->b_addr;
-	xfs_agblock_t		blocks;
+	xfs_filblks_t		blocks;
 	int			error = 0;
 
 	if (!xfs_has_inobtcounts(sc->mp))
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -256,7 +256,7 @@ xrep_agf_calc_from_btrees(
 	struct xfs_agf		*agf = agf_bp->b_addr;
 	struct xfs_mount	*mp = sc->mp;
 	xfs_agblock_t		btreeblks;
-	xfs_agblock_t		blocks;
+	xfs_filblks_t		blocks;
 	int			error;
 
 	/* Update the AGF counters from the bnobt. */
@@ -946,7 +946,7 @@ xrep_agi_calc_from_btrees(
 	if (error)
 		goto err;
 	if (xfs_has_inobtcounts(mp)) {
-		xfs_agblock_t	blocks;
+		xfs_filblks_t	blocks;
 
 		error = xfs_btree_count_blocks(cur, &blocks);
 		if (error)
@@ -959,7 +959,7 @@ xrep_agi_calc_from_btrees(
 	agi->agi_freecount = cpu_to_be32(freecount);
 
 	if (xfs_has_finobt(mp) && xfs_has_inobtcounts(mp)) {
-		xfs_agblock_t	blocks;
+		xfs_filblks_t	blocks;
 
 		cur = xfs_finobt_init_cursor(sc->sa.pag, sc->tp, agi_bp);
 		error = xfs_btree_count_blocks(cur, &blocks);
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -261,7 +261,7 @@ xchk_fscount_btreeblks(
 	struct xchk_fscounters	*fsc,
 	xfs_agnumber_t		agno)
 {
-	xfs_extlen_t		blocks;
+	xfs_filblks_t		blocks;
 	int			error;
 
 	error = xchk_ag_init_existing(sc, agno, &sc->sa);
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -652,8 +652,8 @@ xchk_iallocbt_xref_rmap_btreeblks(
 	struct xfs_scrub	*sc)
 {
 	xfs_filblks_t		blocks;
-	xfs_extlen_t		inobt_blocks = 0;
-	xfs_extlen_t		finobt_blocks = 0;
+	xfs_filblks_t		inobt_blocks = 0;
+	xfs_filblks_t		finobt_blocks = 0;
 	int			error;
 
 	if (!sc->sa.ino_cur || !sc->sa.rmap_cur ||
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -490,7 +490,7 @@ xchk_refcount_xref_rmap(
 	struct xfs_scrub	*sc,
 	xfs_filblks_t		cow_blocks)
 {
-	xfs_extlen_t		refcbt_blocks = 0;
+	xfs_filblks_t		refcbt_blocks = 0;
 	xfs_filblks_t		blocks;
 	int			error;
 
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -111,7 +111,7 @@ xfs_bmap_count_blocks(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_btree_cur	*cur;
-	xfs_extlen_t		btblocks = 0;
+	xfs_filblks_t		btblocks = 0;
 	int			error;
 
 	*nextents = 0;


