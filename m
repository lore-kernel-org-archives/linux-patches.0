Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF0014658C;
	Thu, 13 Feb 2025 14:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458444; cv=none; b=IFxfH4eIPZSlIE4RvZABYBND7YrdGbqLN4zEdP+x07ufrKtoc8gxdq3N+tiSI8RSHzVyeR3J8HuJzAZGrZFQjPDT0NN58b1eaAQvI5yS6rkp9kXjYvxYgGM2IY10ypp/JURn5Sk28ex0ZBfuopMbGtvdfshfD1Gll4F9SrN6aPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458444; c=relaxed/simple;
	bh=sw0xRRw1PRR1vR8wVB99MaCZruPLPPZYT0fhj4BQTWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUfTbrLwE2qEWrYQ/fLpZxCzdmF+D0yE2vAsaDzEWh9/IrR88GZ9NjE5BsD/5VMOJvoA8oKzZBlBKRhI4Z4UwGjznk6wYdiUAYBWiKOejlb53PcnMpQhQoTtCkPuox6GFfhgTgzc5JxaIhqwA9VSV0EG/Klt+kC8Pcif9nV83lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MX8BDT5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MX8BDT5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660C6C4CED1;
	Thu, 13 Feb 2025 14:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458443;
	bh=sw0xRRw1PRR1vR8wVB99MaCZruPLPPZYT0fhj4BQTWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MX8BDT5p/0CB0Ae9thmlAgKeOZ7GrZCtdzp871/dVxauxnfldFJiApmvWqpDMvAbX
	 kmxHZdRsRwN5O/caEuuvPt4H2hWTabbVdrUv8Fm2Vwl5OJ8MtftSQ8bpKXPbWlTUIG
	 2gHNGoj8UoU8GsDtytQMacg51/5dLd6NLlJiqpMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.12 400/422] xfs: separate dquot buffer reads from xfs_dqflush
Date: Thu, 13 Feb 2025 15:29:09 +0100
Message-ID: <20250213142451.984653733@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit a40fe30868ba433ac08376e30132400bec067583 upstream

The first step towards holding the dquot buffer in the li_buf instead of
reading it in the AIL is to separate the part that reads the buffer from
the actual flush code.  There should be no functional changes.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_dquot.c      |   57 +++++++++++++++++++++++++++++++-----------------
 fs/xfs/xfs_dquot.h      |    4 ++-
 fs/xfs/xfs_dquot_item.c |   20 +++++++++++++---
 fs/xfs/xfs_qm.c         |   37 +++++++++++++++++++++++++------
 4 files changed, 86 insertions(+), 32 deletions(-)


--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1233,6 +1233,42 @@ xfs_qm_dqflush_check(
 }
 
 /*
+ * Get the buffer containing the on-disk dquot.
+ *
+ * Requires dquot flush lock, will clear the dirty flag, delete the quota log
+ * item from the AIL, and shut down the system if something goes wrong.
+ */
+int
+xfs_dquot_read_buf(
+	struct xfs_trans	*tp,
+	struct xfs_dquot	*dqp,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_mount	*mp = dqp->q_mount;
+	struct xfs_buf		*bp = NULL;
+	int			error;
+
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, dqp->q_blkno,
+				   mp->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK,
+				   &bp, &xfs_dquot_buf_ops);
+	if (error == -EAGAIN)
+		return error;
+	if (xfs_metadata_is_sick(error))
+		xfs_dquot_mark_sick(dqp);
+	if (error)
+		goto out_abort;
+
+	*bpp = bp;
+	return 0;
+
+out_abort:
+	dqp->q_flags &= ~XFS_DQFLAG_DIRTY;
+	xfs_trans_ail_delete(&dqp->q_logitem.qli_item, 0);
+	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+	return error;
+}
+
+/*
  * Write a modified dquot to disk.
  * The dquot must be locked and the flush lock too taken by caller.
  * The flush lock will not be unlocked until the dquot reaches the disk,
@@ -1243,11 +1279,10 @@ xfs_qm_dqflush_check(
 int
 xfs_qm_dqflush(
 	struct xfs_dquot	*dqp,
-	struct xfs_buf		**bpp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = dqp->q_mount;
 	struct xfs_log_item	*lip = &dqp->q_logitem.qli_item;
-	struct xfs_buf		*bp;
 	struct xfs_dqblk	*dqblk;
 	xfs_failaddr_t		fa;
 	int			error;
@@ -1257,28 +1292,12 @@ xfs_qm_dqflush(
 
 	trace_xfs_dqflush(dqp);
 
-	*bpp = NULL;
-
 	xfs_qm_dqunpin_wait(dqp);
 
-	/*
-	 * Get the buffer containing the on-disk dquot
-	 */
-	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
-				   mp->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK,
-				   &bp, &xfs_dquot_buf_ops);
-	if (error == -EAGAIN)
-		goto out_unlock;
-	if (xfs_metadata_is_sick(error))
-		xfs_dquot_mark_sick(dqp);
-	if (error)
-		goto out_abort;
-
 	fa = xfs_qm_dqflush_check(dqp);
 	if (fa) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
 				dqp->q_id, fa);
-		xfs_buf_relse(bp);
 		xfs_dquot_mark_sick(dqp);
 		error = -EFSCORRUPTED;
 		goto out_abort;
@@ -1328,14 +1347,12 @@ xfs_qm_dqflush(
 	}
 
 	trace_xfs_dqflush_done(dqp);
-	*bpp = bp;
 	return 0;
 
 out_abort:
 	dqp->q_flags &= ~XFS_DQFLAG_DIRTY;
 	xfs_trans_ail_delete(lip, 0);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-out_unlock:
 	xfs_dqfunlock(dqp);
 	return error;
 }
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -204,7 +204,9 @@ void xfs_dquot_to_disk(struct xfs_disk_d
 #define XFS_DQ_IS_DIRTY(dqp)	((dqp)->q_flags & XFS_DQFLAG_DIRTY)
 
 void		xfs_qm_dqdestroy(struct xfs_dquot *dqp);
-int		xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf **bpp);
+int		xfs_dquot_read_buf(struct xfs_trans *tp, struct xfs_dquot *dqp,
+				struct xfs_buf **bpp);
+int		xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf *bp);
 void		xfs_qm_dqunpin_wait(struct xfs_dquot *dqp);
 void		xfs_qm_adjust_dqtimers(struct xfs_dquot *d);
 void		xfs_qm_adjust_dqlimits(struct xfs_dquot *d);
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -155,14 +155,26 @@ xfs_qm_dquot_logitem_push(
 
 	spin_unlock(&lip->li_ailp->ail_lock);
 
-	error = xfs_qm_dqflush(dqp, &bp);
+	error = xfs_dquot_read_buf(NULL, dqp, &bp);
+	if (error) {
+		if (error == -EAGAIN)
+			rval = XFS_ITEM_LOCKED;
+		xfs_dqfunlock(dqp);
+		goto out_relock_ail;
+	}
+
+	/*
+	 * dqflush completes dqflock on error, and the delwri ioend does it on
+	 * success.
+	 */
+	error = xfs_qm_dqflush(dqp, bp);
 	if (!error) {
 		if (!xfs_buf_delwri_queue(bp, buffer_list))
 			rval = XFS_ITEM_FLUSHING;
-		xfs_buf_relse(bp);
-	} else if (error == -EAGAIN)
-		rval = XFS_ITEM_LOCKED;
+	}
+	xfs_buf_relse(bp);
 
+out_relock_ail:
 	spin_lock(&lip->li_ailp->ail_lock);
 out_unlock:
 	xfs_dqunlock(dqp);
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -146,17 +146,28 @@ xfs_qm_dqpurge(
 		 * We don't care about getting disk errors here. We need
 		 * to purge this dquot anyway, so we go ahead regardless.
 		 */
-		error = xfs_qm_dqflush(dqp, &bp);
+		error = xfs_dquot_read_buf(NULL, dqp, &bp);
+		if (error == -EAGAIN) {
+			xfs_dqfunlock(dqp);
+			dqp->q_flags &= ~XFS_DQFLAG_FREEING;
+			goto out_unlock;
+		}
+		if (error)
+			goto out_funlock;
+
+		/*
+		 * dqflush completes dqflock on error, and the bwrite ioend
+		 * does it on success.
+		 */
+		error = xfs_qm_dqflush(dqp, bp);
 		if (!error) {
 			error = xfs_bwrite(bp);
 			xfs_buf_relse(bp);
-		} else if (error == -EAGAIN) {
-			dqp->q_flags &= ~XFS_DQFLAG_FREEING;
-			goto out_unlock;
 		}
 		xfs_dqflock(dqp);
 	}
 
+out_funlock:
 	ASSERT(atomic_read(&dqp->q_pincount) == 0);
 	ASSERT(xlog_is_shutdown(dqp->q_logitem.qli_item.li_log) ||
 		!test_bit(XFS_LI_IN_AIL, &dqp->q_logitem.qli_item.li_flags));
@@ -462,7 +473,17 @@ xfs_qm_dquot_isolate(
 		/* we have to drop the LRU lock to flush the dquot */
 		spin_unlock(lru_lock);
 
-		error = xfs_qm_dqflush(dqp, &bp);
+		error = xfs_dquot_read_buf(NULL, dqp, &bp);
+		if (error) {
+			xfs_dqfunlock(dqp);
+			goto out_unlock_dirty;
+		}
+
+		/*
+		 * dqflush completes dqflock on error, and the delwri ioend
+		 * does it on success.
+		 */
+		error = xfs_qm_dqflush(dqp, bp);
 		if (error)
 			goto out_unlock_dirty;
 
@@ -1287,11 +1308,13 @@ xfs_qm_flush_one(
 		goto out_unlock;
 	}
 
-	error = xfs_qm_dqflush(dqp, &bp);
+	error = xfs_dquot_read_buf(NULL, dqp, &bp);
 	if (error)
 		goto out_unlock;
 
-	xfs_buf_delwri_queue(bp, buffer_list);
+	error = xfs_qm_dqflush(dqp, bp);
+	if (!error)
+		xfs_buf_delwri_queue(bp, buffer_list);
 	xfs_buf_relse(bp);
 out_unlock:
 	xfs_dqunlock(dqp);


