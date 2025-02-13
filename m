Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38ED51DDC33;
	Thu, 13 Feb 2025 14:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458509; cv=none; b=SVRTeu7q7WOIt8C9qcJHtSCtanwaGMYaj4wsdAmxU5RSMq80r/2Sc4CjYXgxXojikFUn1rQFhivyTwQ81s8xkqmI2SJ8CQdCnvOZnO8s5TFZ8twlCNirsxarUZ6DdXPe8jjQGog/RKJ1CiVcVX0MZRQjPc5I+ZXaaojXcCLPbNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458509; c=relaxed/simple;
	bh=7NE6MSFI90vWjoyGOcDPyiAb3sqv1KiL/nAvNVjQ5E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZaijsR/asMBjhcluHB8TeW3Hka03IClcS8cl61u+fdROGwHngNXPMOaGuDyAfFt/pvx/c6AalTHH82pbH9178Zjh9c/WTwkBVlNzPGbbnFCPodwaUMtfN5wEPj+sp5N6hZI/lKNXjUDdjn1dZR5ecQHnLRpk+ROQGscppYSAAfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xs65oSV1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xs65oSV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A99EC4CED1;
	Thu, 13 Feb 2025 14:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458509;
	bh=7NE6MSFI90vWjoyGOcDPyiAb3sqv1KiL/nAvNVjQ5E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xs65oSV1Fn3fHmdl8VWm2eD1aJJbiLp21wBw3+EXuaxvXOO3DA2opMkQx+NCiSnt0
	 /a5TZ//rNguIzn+chhfw/ABrvLrmvIWt/f6XPNRd9UIxRJYjU1qY+6DDgoZYOGujOH
	 2Jfraov+mynYehSmWQx+QYVVdpbWA3DMpi8ModHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.12 403/422] xfs: convert quotacheck to attach dquot buffers
Date: Thu, 13 Feb 2025 15:29:12 +0100
Message-ID: <20250213142452.104363118@linuxfoundation.org>
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

commit ca378189fdfa890a4f0622f85ee41b710bbac271 upstream

Now that we've converted the dquot logging machinery to attach the dquot
buffer to the li_buf pointer so that the AIL dqflush doesn't have to
allocate or read buffers in a reclaim path, do the same for the
quotacheck code so that the reclaim shrinker dqflush call doesn't have
to do that either.

Cc: <stable@vger.kernel.org> # v6.12
Fixes: 903edea6c53f09 ("mm: warn about illegal __GFP_NOFAIL usage in a more appropriate location and manner")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_dquot.c |    9 +++------
 fs/xfs/xfs_dquot.h |    2 --
 fs/xfs/xfs_qm.c    |   18 +++++++++++++-----
 3 files changed, 16 insertions(+), 13 deletions(-)


--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1278,11 +1278,10 @@ xfs_qm_dqflush_check(
  * Requires dquot flush lock, will clear the dirty flag, delete the quota log
  * item from the AIL, and shut down the system if something goes wrong.
  */
-int
+static int
 xfs_dquot_read_buf(
 	struct xfs_trans	*tp,
 	struct xfs_dquot	*dqp,
-	xfs_buf_flags_t		xbf_flags,
 	struct xfs_buf		**bpp)
 {
 	struct xfs_mount	*mp = dqp->q_mount;
@@ -1290,10 +1289,8 @@ xfs_dquot_read_buf(
 	int			error;
 
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, dqp->q_blkno,
-				   mp->m_quotainfo->qi_dqchunklen, xbf_flags,
+				   mp->m_quotainfo->qi_dqchunklen, 0,
 				   &bp, &xfs_dquot_buf_ops);
-	if (error == -EAGAIN)
-		return error;
 	if (xfs_metadata_is_sick(error))
 		xfs_dquot_mark_sick(dqp);
 	if (error)
@@ -1327,7 +1324,7 @@ xfs_dquot_attach_buf(
 		struct xfs_buf	*bp = NULL;
 
 		spin_unlock(&qlip->qli_lock);
-		error = xfs_dquot_read_buf(tp, dqp, 0, &bp);
+		error = xfs_dquot_read_buf(tp, dqp, &bp);
 		if (error)
 			return error;
 
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -204,8 +204,6 @@ void xfs_dquot_to_disk(struct xfs_disk_d
 #define XFS_DQ_IS_DIRTY(dqp)	((dqp)->q_flags & XFS_DQFLAG_DIRTY)
 
 void		xfs_qm_dqdestroy(struct xfs_dquot *dqp);
-int		xfs_dquot_read_buf(struct xfs_trans *tp, struct xfs_dquot *dqp,
-				xfs_buf_flags_t flags, struct xfs_buf **bpp);
 int		xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf *bp);
 void		xfs_qm_dqunpin_wait(struct xfs_dquot *dqp);
 void		xfs_qm_adjust_dqtimers(struct xfs_dquot *d);
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -146,13 +146,13 @@ xfs_qm_dqpurge(
 		 * We don't care about getting disk errors here. We need
 		 * to purge this dquot anyway, so we go ahead regardless.
 		 */
-		error = xfs_dquot_read_buf(NULL, dqp, XBF_TRYLOCK, &bp);
+		error = xfs_dquot_use_attached_buf(dqp, &bp);
 		if (error == -EAGAIN) {
 			xfs_dqfunlock(dqp);
 			dqp->q_flags &= ~XFS_DQFLAG_FREEING;
 			goto out_unlock;
 		}
-		if (error)
+		if (!bp)
 			goto out_funlock;
 
 		/*
@@ -474,8 +474,8 @@ xfs_qm_dquot_isolate(
 		/* we have to drop the LRU lock to flush the dquot */
 		spin_unlock(lru_lock);
 
-		error = xfs_dquot_read_buf(NULL, dqp, XBF_TRYLOCK, &bp);
-		if (error) {
+		error = xfs_dquot_use_attached_buf(dqp, &bp);
+		if (!bp || error == -EAGAIN) {
 			xfs_dqfunlock(dqp);
 			goto out_unlock_dirty;
 		}
@@ -1132,6 +1132,10 @@ xfs_qm_quotacheck_dqadjust(
 		return error;
 	}
 
+	error = xfs_dquot_attach_buf(NULL, dqp);
+	if (error)
+		return error;
+
 	trace_xfs_dqadjust(dqp);
 
 	/*
@@ -1311,9 +1315,13 @@ xfs_qm_flush_one(
 		goto out_unlock;
 	}
 
-	error = xfs_dquot_read_buf(NULL, dqp, XBF_TRYLOCK, &bp);
+	error = xfs_dquot_use_attached_buf(dqp, &bp);
 	if (error)
 		goto out_unlock;
+	if (!bp) {
+		error = -EFSCORRUPTED;
+		goto out_unlock;
+	}
 
 	error = xfs_qm_dqflush(dqp, bp);
 	if (!error)


