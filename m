Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58ED063B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA20EC433D2;
	Mon, 20 Feb 2023 13:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900935;
	bh=b933uSUCoOik2IkDp5DeHXO2VvvYctMvwIOh4fjTYgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=biCqxDNzbdvGckooJLP7UP6mvtNLVgb/0tOwEJtAvlStjOupXT3MNr2ILlgrIVPk/
	 jIcpx6/yQQ6q801KIZg3GHKMGqKJ5m56HtBwTC0ZvHafTue9oxDrlriubi6GQ+F2Qt
	 HA7gtsXGyFmI0ugIO1+9bG5lCwtaR4RbIYcdRswk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Chandan Babu R <chandanrlinux@gmail.com>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 123/156] xfs: ensure inobt record walks always make forward progress
Date: Mon, 20 Feb 2023 14:36:07 +0100
Message-Id: <20230220133607.709941685@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
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

commit 27c14b5daa82861220d6fa6e27b51f05f21ffaa7 upstream.

[ In xfs_iwalk_ag(), Replace a call to XFS_IS_CORRUPT() with a call to
  ASSERT() ]

The aim of the inode btree record iterator function is to call a
callback on every record in the btree.  To avoid having to tear down and
recreate the inode btree cursor around every callback, it caches a
certain number of records in a memory buffer.  After each batch of
callback invocations, we have to perform a btree lookup to find the
next record after where we left off.

However, if the keys of the inode btree are corrupt, the lookup might
put us in the wrong part of the inode btree, causing the walk function
to loop forever.  Therefore, we add extra cursor tracking to make sure
that we never go backwards neither when performing the lookup nor when
jumping to the next inobt record.  This also fixes an off by one error
where upon resume the lookup should have been for the inode /after/ the
point at which we stopped.

Found by fuzzing xfs/460 with keys[2].startino = ones causing bulkstat
and quotacheck to hang.

Fixes: a211432c27ff ("xfs: create simplified inode walk function")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_iwalk.c |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -55,6 +55,9 @@ struct xfs_iwalk_ag {
 	/* Where do we start the traversal? */
 	xfs_ino_t			startino;
 
+	/* What was the last inode number we saw when iterating the inobt? */
+	xfs_ino_t			lastino;
+
 	/* Array of inobt records we cache. */
 	struct xfs_inobt_rec_incore	*recs;
 
@@ -300,6 +303,9 @@ xfs_iwalk_ag_start(
 		return error;
 	XFS_WANT_CORRUPTED_RETURN(mp, *has_more == 1);
 
+	iwag->lastino = XFS_AGINO_TO_INO(mp, agno,
+				irec->ir_startino + XFS_INODES_PER_CHUNK - 1);
+
 	/*
 	 * If the LE lookup yielded an inobt record before the cursor position,
 	 * skip it and see if there's another one after it.
@@ -346,15 +352,17 @@ xfs_iwalk_run_callbacks(
 	struct xfs_mount		*mp = iwag->mp;
 	struct xfs_trans		*tp = iwag->tp;
 	struct xfs_inobt_rec_incore	*irec;
-	xfs_agino_t			restart;
+	xfs_agino_t			next_agino;
 	int				error;
 
+	next_agino = XFS_INO_TO_AGINO(mp, iwag->lastino) + 1;
+
 	ASSERT(iwag->nr_recs > 0);
 
 	/* Delete cursor but remember the last record we cached... */
 	xfs_iwalk_del_inobt(tp, curpp, agi_bpp, 0);
 	irec = &iwag->recs[iwag->nr_recs - 1];
-	restart = irec->ir_startino + XFS_INODES_PER_CHUNK - 1;
+	ASSERT(next_agino == irec->ir_startino + XFS_INODES_PER_CHUNK);
 
 	error = xfs_iwalk_ag_recs(iwag);
 	if (error)
@@ -371,7 +379,7 @@ xfs_iwalk_run_callbacks(
 	if (error)
 		return error;
 
-	return xfs_inobt_lookup(*curpp, restart, XFS_LOOKUP_GE, has_more);
+	return xfs_inobt_lookup(*curpp, next_agino, XFS_LOOKUP_GE, has_more);
 }
 
 /* Walk all inodes in a single AG, from @iwag->startino to the end of the AG. */
@@ -395,6 +403,7 @@ xfs_iwalk_ag(
 
 	while (!error && has_more) {
 		struct xfs_inobt_rec_incore	*irec;
+		xfs_ino_t			rec_fsino;
 
 		cond_resched();
 		if (xfs_pwork_want_abort(&iwag->pwork))
@@ -406,6 +415,15 @@ xfs_iwalk_ag(
 		if (error || !has_more)
 			break;
 
+		/* Make sure that we always move forward. */
+		rec_fsino = XFS_AGINO_TO_INO(mp, agno, irec->ir_startino);
+		if (iwag->lastino != NULLFSINO && iwag->lastino >= rec_fsino) {
+			ASSERT(iwag->lastino < rec_fsino);
+			error = -EFSCORRUPTED;
+			goto out;
+		}
+		iwag->lastino = rec_fsino + XFS_INODES_PER_CHUNK - 1;
+
 		/* No allocated inodes in this chunk; skip it. */
 		if (iwag->skip_empty && irec->ir_freecount == irec->ir_count) {
 			error = xfs_btree_increment(cur, 0, &has_more);
@@ -534,6 +552,7 @@ xfs_iwalk(
 		.trim_start	= 1,
 		.skip_empty	= 1,
 		.pwork		= XFS_PWORK_SINGLE_THREADED,
+		.lastino	= NULLFSINO,
 	};
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
 	int			error;
@@ -622,6 +641,7 @@ xfs_iwalk_threaded(
 		iwag->data = data;
 		iwag->startino = startino;
 		iwag->sz_recs = xfs_iwalk_prefetch(inode_records);
+		iwag->lastino = NULLFSINO;
 		xfs_pwork_queue(&pctl, &iwag->pwork);
 		startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
 		if (flags & XFS_INOBT_WALK_SAME_AG)
@@ -695,6 +715,7 @@ xfs_inobt_walk(
 		.startino	= startino,
 		.sz_recs	= xfs_inobt_walk_prefetch(inobt_records),
 		.pwork		= XFS_PWORK_SINGLE_THREADED,
+		.lastino	= NULLFSINO,
 	};
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
 	int			error;


