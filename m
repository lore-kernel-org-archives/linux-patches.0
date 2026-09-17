Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9806F384CD5;
	Thu, 17 Sep 2026 18:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671259; cv=none; b=m1rG3zbAYBCl0fgiufXk74bkWC/O/QHVKPTo4ULPLbyl/UH7BGMS7aWJIJbSk17tOPMjt0MsnRFIlaL20ksjTIKtvPETNpu4XrmAz/fCc5bkyg353D+xvhc+f3cbFFUXzijkoxC6QLRwfPaFSJQjIbCpBakSin/yWvVm5M9jxbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671259; c=relaxed/simple;
	bh=dLZ9JCMSFm+vLW3ZA3VB13i3sBKAa1xrwOTFHVYKhTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMaM4pZbHAqprevRl9GW66KPQFsn8riv61ooxQ+SCm1rVtstpQBU7u59zcVCTYrImiioJ1yx/pTzQqrUIogfK/fg0+75tGNI5dugnGGjALdZ0gnUYvxHFke8Hxru+2TyzpEuU0wHg3e8OZ7e+mWBCNAqSSOOfp9DqWwmyk5Xaso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uSu3kwZn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uSu3kwZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2419E1F000FF;
	Thu, 17 Sep 2026 18:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671257;
	bh=aIobnfTI1K4m5k+Z7zsEoFARUZ1ZYGnAfjAebwiAmzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uSu3kwZnFhJstXKqQnSTWOAo4N+7MJhDY8YVGtUUYThPwxC+cd6Gk6LB9BS/s0u46
	 uLJyALGis+t/c6X65Gkq2TdqShlQsGQr19l6At4kDjJm3UR8eX3p5tFgZWaygVTbJ6
	 OBqLjTS87VuI3GW4zpEZnzVr1uc1NqBlOX9fqXsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0916/1102] xfs: count escaped corruption errors in scrub stats
Date: Thu, 17 Sep 2026 16:14:19 +0100
Message-ID: <20260917151603.618347935@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -705,8 +705,7 @@ out_nofix:
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
@@ -190,31 +190,37 @@ STATIC void
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
@@ -232,10 +238,14 @@ void
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


