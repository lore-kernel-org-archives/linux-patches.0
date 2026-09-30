Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5BA372B5E;
	Wed, 30 Sep 2026 19:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795758; cv=none; b=gLbOCK8BGUrUI8Y2UQ7dYPfPs9SlVse/EoHY0WPfOr3y2ub1zSIcwk7Onn8CQL6rRLckgVbaZLWXaZEfWFpZjWlia5RNeTyyiOpInneCWw4FoX3T7Qc5d5fokv/xlqM5dqm5n3mQldA9aihPYF5+Zfg5U41pDcB7asc14CroZbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795758; c=relaxed/simple;
	bh=19sDRbNGArwjDWUjb/+XT99Z/GCrVpytzsk1H7Ehl+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qjHMK9nAnFut2NgrFKX3WyTXckoY6fKohzMRdlsTwLEOYTfVSUHeFE+YmtUiezB+fenq6uor0rsgmvtIMaYrwhWG6jJIuw8yeVRFK1LpnRbhx9KnS6DppO39zgJm3lE4DH2LxhwoMRAKUCHPDbcBlv2niorGW6A60UdAIe8aZYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MFuRWGtQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFuRWGtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE52B1F000FF;
	Wed, 30 Sep 2026 19:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795756;
	bh=HZM8KcJIB/UW0nqICbC4C0HPLP67OXUIGqdjhAi8MxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MFuRWGtQKYYimkPh1rlrC4bLCWpY1lU/hpjLU4L6sUHOsi1soFLyyFHJcL0MfQYAF
	 YSdYhvNUeBhJ3hkQ+BQcncn/dTQLr7Du++U2Xd6qnFeVULUq3AMR4WwAMqTWQIBkCG
	 sSAU2CLJuLe5CnkWAgTC11bnRMizzrc5+LNHq26k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 0674/1193] xfs: count escaped corruption errors in scrub stats
Date: Wed, 30 Sep 2026 17:22:38 +0200
Message-ID: <20260930152449.220892512@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Darrick J. Wong <djwong@kernel.org>

commit 4d0624679ae29b469016f1ce4714be58582ed06a upstream.

The main scrub code will quietly turn bubbled-up EFSCORRUPTED and
EFSBADCRC errors into corruption errors.  These aren't recorded in the
scrub stats code (says LOLLM) so do that now.

Cc: stable@vger.kernel.org # v6.6
Fixes: d7a74cad8f4513 ("xfs: track usage statistics of online fsck")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/scrub.c |    3 +--
 fs/xfs/scrub/stats.c |   28 +++++++++++++++++++---------
 fs/xfs/scrub/stats.h |    4 ++--
 3 files changed, 22 insertions(+), 13 deletions(-)

--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -588,8 +588,7 @@ out_nofix:
 out_teardown:
 	error = xchk_teardown(sc, error);
 out_sc:
-	if (error != -ENOENT)
-		xchk_stats_merge(mp, sm, &run);
+	xchk_stats_merge(mp, sm, error, &run);
 	kfree(sc);
 out:
 	trace_xchk_done(XFS_I(file_inode(file)), sm, error);
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -187,31 +187,37 @@ STATIC void
 xchk_stats_merge_one(
 	struct xchk_stats		*cs,
 	const struct xfs_scrub_metadata	*sm,
+	int				error,
 	const struct xchk_stats_run	*run)
 {
 	struct xchk_scrub_stats		*css;
+	unsigned int			sm_flags = sm->sm_flags;
 
 	if (sm->sm_type >= XFS_SCRUB_TYPE_NR) {
 		ASSERT(sm->sm_type < XFS_SCRUB_TYPE_NR);
 		return;
 	}
 
+	/* caller applies this same transformation after we return */
+	if (error == -EFSCORRUPTED || error == -EFSBADCRC)
+		sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+
 	css = &cs->cs_stats[sm->sm_type];
 	spin_lock(&css->css_lock);
 	css->invocations++;
-	if (!(sm->sm_flags & XFS_SCRUB_OFLAG_UNCLEAN))
+	if (!(sm_flags & XFS_SCRUB_OFLAG_UNCLEAN))
 		css->clean++;
-	if (sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+	if (sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		css->corrupt++;
-	if (sm->sm_flags & XFS_SCRUB_OFLAG_PREEN)
+	if (sm_flags & XFS_SCRUB_OFLAG_PREEN)
 		css->preen++;
-	if (sm->sm_flags & XFS_SCRUB_OFLAG_XFAIL)
+	if (sm_flags & XFS_SCRUB_OFLAG_XFAIL)
 		css->xfail++;
-	if (sm->sm_flags & XFS_SCRUB_OFLAG_XCORRUPT)
+	if (sm_flags & XFS_SCRUB_OFLAG_XCORRUPT)
 		css->xcorrupt++;
-	if (sm->sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE)
+	if (sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE)
 		css->incomplete++;
-	if (sm->sm_flags & XFS_SCRUB_OFLAG_WARNING)
+	if (sm_flags & XFS_SCRUB_OFLAG_WARNING)
 		css->warning++;
 	css->retries += run->retries;
 	css->checktime_us += howmany_64(run->scrub_ns, NSEC_PER_USEC);
@@ -229,10 +235,14 @@ void
 xchk_stats_merge(
 	struct xfs_mount		*mp,
 	const struct xfs_scrub_metadata	*sm,
+	int				error,
 	const struct xchk_stats_run	*run)
 {
-	xchk_stats_merge_one(&global_stats, sm, run);
-	xchk_stats_merge_one(mp->m_scrub_stats, sm, run);
+	if (error == -ENOENT)
+		return;
+
+	xchk_stats_merge_one(&global_stats, sm, error, run);
+	xchk_stats_merge_one(mp->m_scrub_stats, sm, error, run);
 }
 
 /* debugfs boilerplate */
--- a/fs/xfs/scrub/stats.h
+++ b/fs/xfs/scrub/stats.h
@@ -27,7 +27,7 @@ void xchk_stats_register(struct xchk_sta
 void xchk_stats_unregister(struct xchk_stats *cs);
 
 void xchk_stats_merge(struct xfs_mount *mp, const struct xfs_scrub_metadata *sm,
-		const struct xchk_stats_run *run);
+		int error, const struct xchk_stats_run *run);
 
 static inline u64 xchk_stats_now(void) { return ktime_get_ns(); }
 static inline u64 xchk_stats_elapsed_ns(u64 since)
@@ -53,7 +53,7 @@ static inline u64 xchk_stats_elapsed_ns(
 # define xchk_stats_unregister(cs)		((void)0)
 # define xchk_stats_now()			(0)
 # define xchk_stats_elapsed_ns(x)		(0 * (x))
-# define xchk_stats_merge(mp, sm, run)		((void)0)
+# define xchk_stats_merge(mp, sm, error, run)	((void)0)
 #endif /* CONFIG_XFS_ONLINE_SCRUB_STATS */
 
 #endif /* __XFS_SCRUB_STATS_H__ */


