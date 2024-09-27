Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBFA1E507;
	Fri, 27 Sep 2024 12:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440381; cv=none; b=Elokll9yP2VhL3Q4BcIidjDsgVCdcSEQOoijWVini1SDS9/Zttjnp4CmlYhrHLgwBUWY+8n5z02uQeh0fpSNgF0wi2sNRwQFUuVIM5zE7RkwULLAm1sy+Y9Fda06SCFmD6kXEHVWccLiuouLZid1GO4ucCQNphH/L4x7+3nWRHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440381; c=relaxed/simple;
	bh=3TQLeqLtAnTVCaCq9fla1DXXC+f3Ys2Zpf944Q0UMDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkPJ2GhRLVbabfsujzkRMNW/IyAililc/KnR/OzgK6BWmecoatliVHVXePqZr7c4c01DmBdpGSA+cMwIwLoC15AP+cB+ZiWLYyxMXTrAOnLPnz3MDb4fhl0iBf80wM1ZTiJ54gh7JZnZyMCGo1diRAMNYRskFEfzRg93ijW1dAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0tdoLJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0tdoLJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93498C4CEC4;
	Fri, 27 Sep 2024 12:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440380;
	bh=3TQLeqLtAnTVCaCq9fla1DXXC+f3Ys2Zpf944Q0UMDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v0tdoLJf3jBnTK23FLDom/i5WZF1iE6k5Ylnb56L7mZZTXCR97ZYTR8QhPrMe0Rdu
	 ipbce4adrGqSzga/hLyWKZTBuOe719GP7HG8D8zLDgkXyb/88/3PVL5XuPzqY3WWpm
	 t/U2Pdt4gpT3AJmMBeudJZetfqN0lSebzQWmTEKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 36/73] xfs: fix low space alloc deadlock
Date: Fri, 27 Sep 2024 14:23:47 +0200
Message-ID: <20240927121721.380752328@linuxfoundation.org>
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

[ Upstream commit 1dd0510f6d4b85616a36aabb9be38389467122d9 ]

I've recently encountered an ABBA deadlock with g/476. The upcoming
changes seem to make this much easier to hit, but the underlying
problem is a pre-existing one.

Essentially, if we select an AG for allocation, then lock the AGF
and then fail to allocate for some reason (e.g. minimum length
requirements cannot be satisfied), then we drop out of the
allocation with the AGF still locked.

The caller then modifies the allocation constraints - usually
loosening them up - and tries again. This can result in trying to
access AGFs that are lower than the AGF we already have locked from
the failed attempt. e.g. the failed attempt skipped several AGs
before failing, so we have locks an AG higher than the start AG.
Retrying the allocation from the start AG then causes us to violate
AGF lock ordering and this can lead to deadlocks.

The deadlock exists even if allocation succeeds - we can do a
followup allocations in the same transaction for BMBT blocks that
aren't guaranteed to be in the same AG as the original, and can move
into higher AGs. Hence we really need to move the tp->t_firstblock
tracking down into xfs_alloc_vextent() where it can be set when we
exit with a locked AG.

xfs_alloc_vextent() can also check there if the requested
allocation falls within the allow range of AGs set by
tp->t_firstblock. If we can't allocate within the range set, we have
to fail the allocation. If we are allowed to to non-blocking AGF
locking, we can ignore the AG locking order limitations as we can
use try-locks for the first iteration over requested AG range.

This invalidates a set of post allocation asserts that check that
the allocation is always above tp->t_firstblock if it is set.
Because we can use try-locks to avoid the deadlock in some
circumstances, having a pre-existing locked AGF doesn't always
prevent allocation from lower order AGFs. Hence those ASSERTs need
to be removed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_alloc.c |   69 ++++++++++++++++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_bmap.c  |   14 ---------
 fs/xfs/xfs_trace.h        |    1 
 3 files changed, 58 insertions(+), 26 deletions(-)

--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3164,10 +3164,13 @@ xfs_alloc_vextent(
 	xfs_alloctype_t		type;	/* input allocation type */
 	int			bump_rotor = 0;
 	xfs_agnumber_t		rotorstep = xfs_rotorstep; /* inode32 agf stepper */
+	xfs_agnumber_t		minimum_agno = 0;
 
 	mp = args->mp;
 	type = args->otype = args->type;
 	args->agbno = NULLAGBLOCK;
+	if (args->tp->t_firstblock != NULLFSBLOCK)
+		minimum_agno = XFS_FSB_TO_AGNO(mp, args->tp->t_firstblock);
 	/*
 	 * Just fix this up, for the case where the last a.g. is shorter
 	 * (or there's only one a.g.) and the caller couldn't easily figure
@@ -3201,6 +3204,13 @@ xfs_alloc_vextent(
 		 */
 		args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
 		args->pag = xfs_perag_get(mp, args->agno);
+
+		if (minimum_agno > args->agno) {
+			trace_xfs_alloc_vextent_skip_deadlock(args);
+			error = 0;
+			break;
+		}
+
 		error = xfs_alloc_fix_freelist(args, 0);
 		if (error) {
 			trace_xfs_alloc_vextent_nofix(args);
@@ -3232,6 +3242,8 @@ xfs_alloc_vextent(
 	case XFS_ALLOCTYPE_FIRST_AG:
 		/*
 		 * Rotate through the allocation groups looking for a winner.
+		 * If we are blocking, we must obey minimum_agno contraints for
+		 * avoiding ABBA deadlocks on AGF locking.
 		 */
 		if (type == XFS_ALLOCTYPE_FIRST_AG) {
 			/*
@@ -3239,7 +3251,7 @@ xfs_alloc_vextent(
 			 */
 			args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
 			args->type = XFS_ALLOCTYPE_THIS_AG;
-			sagno = 0;
+			sagno = minimum_agno;
 			flags = 0;
 		} else {
 			/*
@@ -3248,6 +3260,7 @@ xfs_alloc_vextent(
 			args->agno = sagno = XFS_FSB_TO_AGNO(mp, args->fsbno);
 			flags = XFS_ALLOC_FLAG_TRYLOCK;
 		}
+
 		/*
 		 * Loop over allocation groups twice; first time with
 		 * trylock set, second time without.
@@ -3276,19 +3289,21 @@ xfs_alloc_vextent(
 			if (args->agno == sagno &&
 			    type == XFS_ALLOCTYPE_START_BNO)
 				args->type = XFS_ALLOCTYPE_THIS_AG;
+
 			/*
-			* For the first allocation, we can try any AG to get
-			* space.  However, if we already have allocated a
-			* block, we don't want to try AGs whose number is below
-			* sagno. Otherwise, we may end up with out-of-order
-			* locking of AGF, which might cause deadlock.
-			*/
+			 * If we are try-locking, we can't deadlock on AGF
+			 * locks, so we can wrap all the way back to the first
+			 * AG. Otherwise, wrap back to the start AG so we can't
+			 * deadlock, and let the end of scan handler decide what
+			 * to do next.
+			 */
 			if (++(args->agno) == mp->m_sb.sb_agcount) {
-				if (args->tp->t_firstblock != NULLFSBLOCK)
-					args->agno = sagno;
-				else
+				if (flags & XFS_ALLOC_FLAG_TRYLOCK)
 					args->agno = 0;
+				else
+					args->agno = sagno;
 			}
+
 			/*
 			 * Reached the starting a.g., must either be done
 			 * or switch to non-trylock mode.
@@ -3300,7 +3315,14 @@ xfs_alloc_vextent(
 					break;
 				}
 
+				/*
+				 * Blocking pass next, so we must obey minimum
+				 * agno constraints to avoid ABBA AGF deadlocks.
+				 */
 				flags = 0;
+				if (minimum_agno > sagno)
+					sagno = minimum_agno;
+
 				if (type == XFS_ALLOCTYPE_START_BNO) {
 					args->agbno = XFS_FSB_TO_AGBNO(mp,
 						args->fsbno);
@@ -3322,9 +3344,9 @@ xfs_alloc_vextent(
 		ASSERT(0);
 		/* NOTREACHED */
 	}
-	if (args->agbno == NULLAGBLOCK)
+	if (args->agbno == NULLAGBLOCK) {
 		args->fsbno = NULLFSBLOCK;
-	else {
+	} else {
 		args->fsbno = XFS_AGB_TO_FSB(mp, args->agno, args->agbno);
 #ifdef DEBUG
 		ASSERT(args->len >= args->minlen);
@@ -3335,6 +3357,29 @@ xfs_alloc_vextent(
 #endif
 
 	}
+
+	/*
+	 * We end up here with a locked AGF. If we failed, the caller is likely
+	 * going to try to allocate again with different parameters, and that
+	 * can widen the AGs that are searched for free space. If we have to do
+	 * BMBT block allocation, we have to do a new allocation.
+	 *
+	 * Hence leaving this function with the AGF locked opens up potential
+	 * ABBA AGF deadlocks because a future allocation attempt in this
+	 * transaction may attempt to lock a lower number AGF.
+	 *
+	 * We can't release the AGF until the transaction is commited, so at
+	 * this point we must update the "firstblock" tracker to point at this
+	 * AG if the tracker is empty or points to a lower AG. This allows the
+	 * next allocation attempt to be modified appropriately to avoid
+	 * deadlocks.
+	 */
+	if (args->agbp &&
+	    (args->tp->t_firstblock == NULLFSBLOCK ||
+	     args->pag->pag_agno > minimum_agno)) {
+		args->tp->t_firstblock = XFS_AGB_TO_FSB(mp,
+					args->pag->pag_agno, 0);
+	}
 	xfs_perag_put(args->pag);
 	return 0;
 error0:
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3413,21 +3413,7 @@ xfs_bmap_process_allocated_extent(
 	xfs_fileoff_t		orig_offset,
 	xfs_extlen_t		orig_length)
 {
-	int			nullfb;
-
-	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
-
-	/*
-	 * check the allocation happened at the same or higher AG than
-	 * the first block that was allocated.
-	 */
-	ASSERT(nullfb ||
-		XFS_FSB_TO_AGNO(args->mp, ap->tp->t_firstblock) <=
-		XFS_FSB_TO_AGNO(args->mp, args->fsbno));
-
 	ap->blkno = args->fsbno;
-	if (nullfb)
-		ap->tp->t_firstblock = args->fsbno;
 	ap->length = args->len;
 	/*
 	 * If the extent size hint is active, we tried to round the
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1877,6 +1877,7 @@ DEFINE_ALLOC_EVENT(xfs_alloc_small_noten
 DEFINE_ALLOC_EVENT(xfs_alloc_small_done);
 DEFINE_ALLOC_EVENT(xfs_alloc_small_error);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_badargs);
+DEFINE_ALLOC_EVENT(xfs_alloc_vextent_skip_deadlock);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_nofix);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_noagbp);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_loopfailed);


