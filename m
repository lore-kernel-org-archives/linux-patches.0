Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9103C18453A;
	Fri, 27 Sep 2024 12:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440386; cv=none; b=jgF062D/+To4dBFLtQt+lB586bnjM9HBxPYdO8q214z1S9Qxo6oMv2O7VnAZHIK4pRMKbuqchY4gRi3W4UrFai/9SZGJs8H3rjIIGg2F2Tcm50hTaaNXBSJ36HOBDAfKlTeWgz01QlmRCS+35n1SOj6P+Pmy/ekcgl3o0r4sqmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440386; c=relaxed/simple;
	bh=Ne400X+2CQrPzZ4tLV4a3rRkTpvJ8p35LUI3Xe4bIqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBOGV6K2JPH3pz9sFMyt1aY0EQFZiKwNkvxRDBUnSoj/2YJr+XV/DFPBoNa3OG5AmkGPrfMybiF9Qn0hKTX0Qxqtwrey9TJzHw87SkLEngUQFaz/h2E8u/CRObxH374a7p4wnzGgPVLEvjCSZimQDfz8oIBXD+WZ4LyE2sOKcO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wn/H+30C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wn/H+30C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3EFC4CEC4;
	Fri, 27 Sep 2024 12:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440386;
	bh=Ne400X+2CQrPzZ4tLV4a3rRkTpvJ8p35LUI3Xe4bIqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wn/H+30CxSQpymzFa+oi8SQ8arTcYHcQHesBQXa5vOstUQsQLEnMRzBp9SRWh2cxR
	 N0DL+OE5+c63jIeVrodef59mQeIENWI4A1W96IA82gO9GCEmp9okH6YO2wS6QfcTb9
	 ujnS7mQnlP6faffuNwYbB9apmBhfSaqllEey7IO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 38/73] xfs: block reservation too large for minleft allocation
Date: Fri, 27 Sep 2024 14:23:49 +0200
Message-ID: <20240927121721.469292951@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

[ Upstream commit d5753847b216db0e553e8065aa825cfe497ad143 ]

When we enter xfs_bmbt_alloc_block() without having first allocated
a data extent (i.e. tp->t_firstblock == NULLFSBLOCK) because we
are doing something like unwritten extent conversion, the transaction
block reservation is used as the minleft value.

This works for operations like unwritten extent conversion, but it
assumes that the block reservation is only for a BMBT split. THis is
not always true, and sometimes results in larger than necessary
minleft values being set. We only actually need enough space for a
btree split, something we already handle correctly in
xfs_bmapi_write() via the xfs_bmapi_minleft() calculation.

We should use xfs_bmapi_minleft() in xfs_bmbt_alloc_block() to
calculate the number of blocks a BMBT split on this inode is going to
require, not use the transaction block reservation that contains the
maximum number of blocks this transaction may consume in it...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.c       |    2 +-
 fs/xfs/libxfs/xfs_bmap.h       |    2 ++
 fs/xfs/libxfs/xfs_bmap_btree.c |   19 +++++++++----------
 3 files changed, 12 insertions(+), 11 deletions(-)

--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4242,7 +4242,7 @@ xfs_bmapi_convert_unwritten(
 	return 0;
 }
 
-static inline xfs_extlen_t
+xfs_extlen_t
 xfs_bmapi_minleft(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -220,6 +220,8 @@ int	xfs_bmap_add_extent_unwritten_real(s
 		struct xfs_inode *ip, int whichfork,
 		struct xfs_iext_cursor *icur, struct xfs_btree_cur **curp,
 		struct xfs_bmbt_irec *new, int *logflagsp);
+xfs_extlen_t xfs_bmapi_minleft(struct xfs_trans *tp, struct xfs_inode *ip,
+		int fork);
 
 enum xfs_bmap_intent_type {
 	XFS_BMAP_MAP = 1,
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -213,18 +213,16 @@ xfs_bmbt_alloc_block(
 	if (args.fsbno == NULLFSBLOCK) {
 		args.fsbno = be64_to_cpu(start->l);
 		args.type = XFS_ALLOCTYPE_START_BNO;
+
 		/*
-		 * Make sure there is sufficient room left in the AG to
-		 * complete a full tree split for an extent insert.  If
-		 * we are converting the middle part of an extent then
-		 * we may need space for two tree splits.
-		 *
-		 * We are relying on the caller to make the correct block
-		 * reservation for this operation to succeed.  If the
-		 * reservation amount is insufficient then we may fail a
-		 * block allocation here and corrupt the filesystem.
+		 * If we are coming here from something like unwritten extent
+		 * conversion, there has been no data extent allocation already
+		 * done, so we have to ensure that we attempt to locate the
+		 * entire set of bmbt allocations in the same AG, as
+		 * xfs_bmapi_write() would have reserved.
 		 */
-		args.minleft = args.tp->t_blk_res;
+		args.minleft = xfs_bmapi_minleft(cur->bc_tp, cur->bc_ino.ip,
+						cur->bc_ino.whichfork);
 	} else if (cur->bc_tp->t_flags & XFS_TRANS_LOWMODE) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 	} else {
@@ -248,6 +246,7 @@ xfs_bmbt_alloc_block(
 		 * successful activate the lowspace algorithm.
 		 */
 		args.fsbno = 0;
+		args.minleft = 0;
 		args.type = XFS_ALLOCTYPE_FIRST_AG;
 		error = xfs_alloc_vextent(&args);
 		if (error)


