Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8F726656F;
	Tue, 25 Mar 2025 12:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905634; cv=none; b=mFHThmiOCWs56URnXwbQf0AnXoeYc6+dEC0VuzM2UltmI0K9eQU63TPec3/JmAjHm7pbDsb/eRhyO56PNTrgjmQrGFAUMlqhIpIKp9ixXnEa8RTPa2lXiEXGjMP74gWnm28bBD1O7uidU3LesrMrpSIggSGjyaOhOecI8ROJ9t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905634; c=relaxed/simple;
	bh=Z7pjzGwBZDwfaCE4UlNO+64QaCr3AFdTIjzb4dEddrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHw0aVYRTDfcYVK+mRiWV+efjox2cvNUBR8tRNDBBnts/6WObcy7AmQmyxu335JaU7VGWggQRfs/ZPsdOV2dMlTQE6azfI4X9oa/INrD1hhebCnnonu/0GbsFjOwnvzdwSjoJZ9vzGEaP9SG+laJaVk8DUKQacNLQS87D1XfJDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iRuxr4yi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iRuxr4yi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBC6C4CEE4;
	Tue, 25 Mar 2025 12:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905634;
	bh=Z7pjzGwBZDwfaCE4UlNO+64QaCr3AFdTIjzb4dEddrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iRuxr4yi9ik/vfZEcuImtHANUK+GgQ3Anvz88NAWr8+wSO9GSiMW/4nv7WCfO5VsN
	 3orr/pqEnn8j/GUE0fgAWBQtX5UaSjRztveXTGMGH0mXqakXqFvH088GMck0TJpUEr
	 LTK9U9hOE7qXGhRheLzrn9yfS6IjmbBdBQ+tHU0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 081/198] xfs: pass the xfs_bmbt_irec directly through the log intent code
Date: Tue, 25 Mar 2025 08:20:43 -0400
Message-ID: <20250325122158.767076334@linuxfoundation.org>
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

[ Upstream commit ddccb81b26ec021ae1f3366aa996cc4c68dd75ce ]

Instead of repeatedly boxing and unboxing the incore extent mapping
structure as it passes through the BUI code, pass the pointer directly
through.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   32 ++++++++----------
 fs/xfs/libxfs/xfs_bmap.h |    5 --
 fs/xfs/xfs_bmap_item.c   |   81 +++++++++++++++++------------------------------
 3 files changed, 46 insertions(+), 72 deletions(-)

--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6119,39 +6119,37 @@ xfs_bmap_unmap_extent(
 int
 xfs_bmap_finish_one(
 	struct xfs_trans		*tp,
-	struct xfs_inode		*ip,
-	enum xfs_bmap_intent_type	type,
-	int				whichfork,
-	xfs_fileoff_t			startoff,
-	xfs_fsblock_t			startblock,
-	xfs_filblks_t			*blockcount,
-	xfs_exntst_t			state)
+	struct xfs_bmap_intent		*bi)
 {
+	struct xfs_bmbt_irec		*bmap = &bi->bi_bmap;
 	int				error = 0;
 
 	ASSERT(tp->t_firstblock == NULLFSBLOCK);
 
 	trace_xfs_bmap_deferred(tp->t_mountp,
-			XFS_FSB_TO_AGNO(tp->t_mountp, startblock), type,
-			XFS_FSB_TO_AGBNO(tp->t_mountp, startblock),
-			ip->i_ino, whichfork, startoff, *blockcount, state);
+			XFS_FSB_TO_AGNO(tp->t_mountp, bmap->br_startblock),
+			bi->bi_type,
+			XFS_FSB_TO_AGBNO(tp->t_mountp, bmap->br_startblock),
+			bi->bi_owner->i_ino, bi->bi_whichfork,
+			bmap->br_startoff, bmap->br_blockcount,
+			bmap->br_state);
 
-	if (WARN_ON_ONCE(whichfork != XFS_DATA_FORK))
+	if (WARN_ON_ONCE(bi->bi_whichfork != XFS_DATA_FORK))
 		return -EFSCORRUPTED;
 
 	if (XFS_TEST_ERROR(false, tp->t_mountp,
 			XFS_ERRTAG_BMAP_FINISH_ONE))
 		return -EIO;
 
-	switch (type) {
+	switch (bi->bi_type) {
 	case XFS_BMAP_MAP:
-		error = xfs_bmapi_remap(tp, ip, startoff, *blockcount,
-				startblock, 0);
-		*blockcount = 0;
+		error = xfs_bmapi_remap(tp, bi->bi_owner, bmap->br_startoff,
+				bmap->br_blockcount, bmap->br_startblock, 0);
+		bmap->br_blockcount = 0;
 		break;
 	case XFS_BMAP_UNMAP:
-		error = __xfs_bunmapi(tp, ip, startoff, blockcount,
-				XFS_BMAPI_REMAP, 1);
+		error = __xfs_bunmapi(tp, bi->bi_owner, bmap->br_startoff,
+				&bmap->br_blockcount, XFS_BMAPI_REMAP, 1);
 		break;
 	default:
 		ASSERT(0);
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -236,10 +236,7 @@ struct xfs_bmap_intent {
 	struct xfs_bmbt_irec			bi_bmap;
 };
 
-int	xfs_bmap_finish_one(struct xfs_trans *tp, struct xfs_inode *ip,
-		enum xfs_bmap_intent_type type, int whichfork,
-		xfs_fileoff_t startoff, xfs_fsblock_t startblock,
-		xfs_filblks_t *blockcount, xfs_exntst_t state);
+int	xfs_bmap_finish_one(struct xfs_trans *tp, struct xfs_bmap_intent *bi);
 void	xfs_bmap_map_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 		struct xfs_bmbt_irec *imap);
 void	xfs_bmap_unmap_extent(struct xfs_trans *tp, struct xfs_inode *ip,
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -246,18 +246,11 @@ static int
 xfs_trans_log_finish_bmap_update(
 	struct xfs_trans		*tp,
 	struct xfs_bud_log_item		*budp,
-	enum xfs_bmap_intent_type	type,
-	struct xfs_inode		*ip,
-	int				whichfork,
-	xfs_fileoff_t			startoff,
-	xfs_fsblock_t			startblock,
-	xfs_filblks_t			*blockcount,
-	xfs_exntst_t			state)
+	struct xfs_bmap_intent		*bi)
 {
 	int				error;
 
-	error = xfs_bmap_finish_one(tp, ip, type, whichfork, startoff,
-			startblock, blockcount, state);
+	error = xfs_bmap_finish_one(tp, bi);
 
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
@@ -378,25 +371,17 @@ xfs_bmap_update_finish_item(
 	struct list_head		*item,
 	struct xfs_btree_cur		**state)
 {
-	struct xfs_bmap_intent		*bmap;
-	xfs_filblks_t			count;
+	struct xfs_bmap_intent		*bi;
 	int				error;
 
-	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
-	count = bmap->bi_bmap.br_blockcount;
-	error = xfs_trans_log_finish_bmap_update(tp, BUD_ITEM(done),
-			bmap->bi_type,
-			bmap->bi_owner, bmap->bi_whichfork,
-			bmap->bi_bmap.br_startoff,
-			bmap->bi_bmap.br_startblock,
-			&count,
-			bmap->bi_bmap.br_state);
-	if (!error && count > 0) {
-		ASSERT(bmap->bi_type == XFS_BMAP_UNMAP);
-		bmap->bi_bmap.br_blockcount = count;
+	bi = container_of(item, struct xfs_bmap_intent, bi_list);
+
+	error = xfs_trans_log_finish_bmap_update(tp, BUD_ITEM(done), bi);
+	if (!error && bi->bi_bmap.br_blockcount > 0) {
+		ASSERT(bi->bi_type == XFS_BMAP_UNMAP);
 		return -EAGAIN;
 	}
-	kmem_cache_free(xfs_bmap_intent_cache, bmap);
+	kmem_cache_free(xfs_bmap_intent_cache, bi);
 	return error;
 }
 
@@ -471,17 +456,13 @@ xfs_bui_item_recover(
 	struct xfs_log_item		*lip,
 	struct list_head		*capture_list)
 {
-	struct xfs_bmbt_irec		irec;
+	struct xfs_bmap_intent		fake = { };
 	struct xfs_bui_log_item		*buip = BUI_ITEM(lip);
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip = NULL;
 	struct xfs_mount		*mp = lip->li_log->l_mp;
-	struct xfs_map_extent		*bmap;
+	struct xfs_map_extent		*map;
 	struct xfs_bud_log_item		*budp;
-	xfs_filblks_t			count;
-	xfs_exntst_t			state;
-	unsigned int			bui_type;
-	int				whichfork;
 	int				iext_delta;
 	int				error = 0;
 
@@ -491,14 +472,12 @@ xfs_bui_item_recover(
 		return -EFSCORRUPTED;
 	}
 
-	bmap = &buip->bui_format.bui_extents[0];
-	state = (bmap->me_flags & XFS_BMAP_EXTENT_UNWRITTEN) ?
-			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
-	whichfork = (bmap->me_flags & XFS_BMAP_EXTENT_ATTR_FORK) ?
+	map = &buip->bui_format.bui_extents[0];
+	fake.bi_whichfork = (map->me_flags & XFS_BMAP_EXTENT_ATTR_FORK) ?
 			XFS_ATTR_FORK : XFS_DATA_FORK;
-	bui_type = bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK;
+	fake.bi_type = map->me_flags & XFS_BMAP_EXTENT_TYPE_MASK;
 
-	error = xlog_recover_iget(mp, bmap->me_owner, &ip);
+	error = xlog_recover_iget(mp, map->me_owner, &ip);
 	if (error)
 		return error;
 
@@ -512,34 +491,34 @@ xfs_bui_item_recover(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	if (bui_type == XFS_BMAP_MAP)
+	if (fake.bi_type == XFS_BMAP_MAP)
 		iext_delta = XFS_IEXT_ADD_NOSPLIT_CNT;
 	else
 		iext_delta = XFS_IEXT_PUNCH_HOLE_CNT;
 
-	error = xfs_iext_count_may_overflow(ip, whichfork, iext_delta);
+	error = xfs_iext_count_may_overflow(ip, fake.bi_whichfork, iext_delta);
 	if (error == -EFBIG)
 		error = xfs_iext_count_upgrade(tp, ip, iext_delta);
 	if (error)
 		goto err_cancel;
 
-	count = bmap->me_len;
-	error = xfs_trans_log_finish_bmap_update(tp, budp, bui_type, ip,
-			whichfork, bmap->me_startoff, bmap->me_startblock,
-			&count, state);
+	fake.bi_owner = ip;
+	fake.bi_bmap.br_startblock = map->me_startblock;
+	fake.bi_bmap.br_startoff = map->me_startoff;
+	fake.bi_bmap.br_blockcount = map->me_len;
+	fake.bi_bmap.br_state = (map->me_flags & XFS_BMAP_EXTENT_UNWRITTEN) ?
+			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
+
+	error = xfs_trans_log_finish_bmap_update(tp, budp, &fake);
 	if (error == -EFSCORRUPTED)
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bmap,
-				sizeof(*bmap));
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, map,
+				sizeof(*map));
 	if (error)
 		goto err_cancel;
 
-	if (count > 0) {
-		ASSERT(bui_type == XFS_BMAP_UNMAP);
-		irec.br_startblock = bmap->me_startblock;
-		irec.br_blockcount = count;
-		irec.br_startoff = bmap->me_startoff;
-		irec.br_state = state;
-		xfs_bmap_unmap_extent(tp, ip, &irec);
+	if (fake.bi_bmap.br_blockcount > 0) {
+		ASSERT(fake.bi_type == XFS_BMAP_UNMAP);
+		xfs_bmap_unmap_extent(tp, ip, &fake.bi_bmap);
 	}
 
 	/*


