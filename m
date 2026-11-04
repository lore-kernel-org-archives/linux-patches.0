Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828959;
	b=glHrbcgkXXOXdcPxOaJqvBiaBEClLxsr9q7E4635FUCi65fcd9CnyyQ0qZBBFuysS1Q/
	 ceY/9pu7/x5M2/EMo+y9PRmLGwMDmS0r8o0wf3KwPGP8rWpDNrTl9nzUMxuwC//lTcJtp
	 cSbSpYvEy8VVu0XCK+zFqNg3wRYgzuHwpXoBwQRnOBvYtpfI9QOH8Q+3nzB579COqcsc6
	 KkJZgBHbUlD2w/uQfHLmiGSHrgVA3u9rzMIDjz2Z0Zj+y+o7pQ9GWaDsHH8Vl2J/eFQKO
	 KBnJQef2Foi32VZKrKMiw9uw0jnHQBQLnGRu4GAAy5gVdHsf9lezzUt8+YiJaGb5MHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qYoYGedmB1lkZFVI2fjj1KajB5XHxaVSpKYmIfTuwmw=;
	b=bBN2VbNBRqpIJqUVCiFXnvasGlUURt2DjIH0PCVVZoKAtdOl5mQoIiP9HgnzkguhYwLd
	 hdA5hZlE/6As+NL+NX5oL0oRpjMFRa6wcPzFryKM0aH/IELWmrsakIOcU6Mr+WnMK0DIk
	 NsuLjK+izMFfRQtTZRv6djn63NICu43dYaCJ/fMxfK0jaHBBkEpRLZfGVruonixWBhMHb
	 M55XPfFtbYZ6lmRuRSinrtJDiYSFckfofjXau74zzaaZOYLLDOs7dwSbqu9fZgc6/ZGub
	 utThJAuCwAjPEwbbGFkcIzUr43cPIVIwRWTgw+aypUC9Gr9VhHxtm03tJy+dt0BGvfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rqwfb8uo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A72E607E4B9;
	Wed,  4 Nov 2026 21:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rqwfb8uo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19FAD1F000C1;
	Wed,  4 Nov 2026 21:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828958;
	bh=qYoYGedmB1lkZFVI2fjj1KajB5XHxaVSpKYmIfTuwmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rqwfb8uoMUUC08PhaaZRMq9tdlk1rwDjOMijQof0YLpz7BNsdNjtR7x/cO+YPvyFY
	 yT5n7T7Wsu1wkHvihBrhUHGoGiV6mALLro8SUKf1Ud2znSrUlOZ6LQeaHz3J/9sx8j
	 n8BHEuGOcaNQQWC9NnYU5FYMd8mR4bKlcmgvSXCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 303/547] xfs: fix missing xfs_qm_adjust_dqlimits call in quotacheck repair
Date: Wed,  4 Nov 2026 16:08:07 -0500
Message-ID: <20261104211046.816923658@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit da483b8a9c2c3e7b23655699680feb57a194000c upstream.

LOLLM noticed that everywhere else in the kernel, a call to
xfs_qm_adjust_dqlimits precedes every call to xfs_qm_adjust_dqtimers.
In particular, mount-time quotacheck does this, but online quotacheck
does not.

Looking at xfs_qm_adjust_dqlimits, that function is in charge of
conveying default limits to a dquot if that dquot's limits have been
zeroed.  That's quite possible in a repair, so we actually need to do
that.

However, there's a pre-existing pattern in the kernel -- for non-root
dquots, first we call xfs_qm_adjust_dqlimits to set the dquot's limits
to the defaults if they are zero, and then xfs_qm_adjust_dqtimers to
start grace periods if the dquot's usage is above the softlimit.  The
grace period decision cannot be made correctly if we forget to import
the default limits.

Therefore, let's combine both into a single xfs_qm_adjust_dqenforcement
helper that takes care of both pieces, which fixes quotacheck and makes
it hard to repeat this mistake.

Cc: stable@vger.kernel.org # v6.9
Fixes: 96ed2ae4a9b06b ("xfs: repair dquots based on live quotacheck results")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/quota_repair.c      |    5 +----
 fs/xfs/scrub/quotacheck_repair.c |    3 +--
 fs/xfs/xfs_dquot.c               |   20 +++++++++++++++-----
 fs/xfs/xfs_dquot.h               |    2 +-
 fs/xfs/xfs_qm.c                  |    6 +-----
 fs/xfs/xfs_trans_dquot.c         |    6 +-----
 6 files changed, 20 insertions(+), 22 deletions(-)

--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -248,10 +248,7 @@ xrep_quota_item(
 
 	dq->q_flags |= XFS_DQFLAG_DIRTY;
 	xfs_trans_dqjoin(sc->tp, dq);
-	if (dq->q_id) {
-		xfs_qm_adjust_dqlimits(dq);
-		xfs_qm_adjust_dqtimers(dq);
-	}
+	xfs_qm_adjust_dqenforcement(dq);
 	xfs_trans_log_dquot(sc->tp, dq);
 	return xfs_trans_roll(&sc->tp);
 
--- a/fs/xfs/scrub/quotacheck_repair.c
+++ b/fs/xfs/scrub/quotacheck_repair.c
@@ -110,8 +110,7 @@ xqcheck_commit_dquot(
 
 	/* Commit the dirty dquot to disk. */
 	dq->q_flags |= XFS_DQFLAG_DIRTY;
-	if (dq->q_id)
-		xfs_qm_adjust_dqtimers(dq);
+	xfs_qm_adjust_dqenforcement(dq);
 	xfs_trans_log_dquot(xqc->sc->tp, dq);
 	return xrep_trans_commit(xqc->sc);
 
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -115,18 +115,15 @@ xfs_qm_dqdestroy(
  * We overwrite the dquot limits only if they are zero and this
  * is not the root dquot.
  */
-void
+static void
 xfs_qm_adjust_dqlimits(
 	struct xfs_dquot	*dq)
 {
 	struct xfs_mount	*mp = dq->q_mount;
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	struct xfs_def_quota	*defq;
+	struct xfs_def_quota	*defq = xfs_get_defquota(q, xfs_dquot_type(dq));
 	int			prealloc = 0;
 
-	ASSERT(dq->q_id);
-	defq = xfs_get_defquota(q, xfs_dquot_type(dq));
-
 	if (!dq->q_blk.softlimit) {
 		dq->q_blk.softlimit = defq->blk.soft;
 		prealloc = 1;
@@ -223,6 +220,19 @@ xfs_qm_adjust_dqtimers(
 	xfs_qm_adjust_res_timer(dq->q_mount, &dq->q_rtb, &defq->rtb);
 }
 
+/* Adjust enforcement limits and timers after a change in usage. */
+void
+xfs_qm_adjust_dqenforcement(
+	struct xfs_dquot	*dq)
+{
+	if (dq->q_id == 0)
+		return;
+
+	xfs_qm_adjust_dqlimits(dq);
+	xfs_qm_adjust_dqtimers(dq);
+	dq->q_flags |= XFS_DQFLAG_DIRTY;
+}
+
 /*
  * initialize a buffer full of dquots and log the whole thing
  */
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -205,7 +205,7 @@ void		xfs_qm_dqdestroy(struct xfs_dquot
 int		xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf *bp);
 void		xfs_qm_dqunpin_wait(struct xfs_dquot *dqp);
 void		xfs_qm_adjust_dqtimers(struct xfs_dquot *d);
-void		xfs_qm_adjust_dqlimits(struct xfs_dquot *d);
+void		xfs_qm_adjust_dqenforcement(struct xfs_dquot *d);
 xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip,
 				xfs_dqtype_t type);
 int		xfs_qm_dqget(struct xfs_mount *mp, xfs_dqid_t id,
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1294,11 +1294,7 @@ xfs_qm_quotacheck_dqadjust(
 	 *
 	 * There are no timers for the default values set in the root dquot.
 	 */
-	if (dqp->q_id) {
-		xfs_qm_adjust_dqlimits(dqp);
-		xfs_qm_adjust_dqtimers(dqp);
-	}
-
+	xfs_qm_adjust_dqenforcement(dqp);
 	dqp->q_flags |= XFS_DQFLAG_DIRTY;
 out_unlock:
 	mutex_unlock(&dqp->q_qlock);
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -566,11 +566,7 @@ xfs_trans_apply_dquot_deltas(
 			 * Get any default limits in use.
 			 * Start/reset the timer(s) if needed.
 			 */
-			if (dqp->q_id) {
-				xfs_qm_adjust_dqlimits(dqp);
-				xfs_qm_adjust_dqtimers(dqp);
-			}
-
+			xfs_qm_adjust_dqenforcement(dqp);
 			dqp->q_flags |= XFS_DQFLAG_DIRTY;
 			/*
 			 * add this to the list of items to get logged


