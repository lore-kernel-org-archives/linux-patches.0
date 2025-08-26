Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A5420C001;
	Tue, 26 Aug 2025 11:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207619; cv=none; b=T0gwgUb6p3sBAx+SVEp9PhiBMFQiqq9UMisdgfF1qkgRHlHB72qBEdKTuowRj1+WpKk1r0jBHKlAanXFFlf0tmpZrAR6UsJEmW3JG9N/Z2Ih3X/1yGJv8Y5iyMunxCQO4xOG8MA/mLyhHE1dp0+iTGBjnAW7hpF1BsT1pynQpaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207619; c=relaxed/simple;
	bh=PMtdQoemG12pHtl2vBLEf5TOwzHoSGlbKFB2PQ6OQyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4Cg7jkcq+D8si6lVsNvT788NeIxyWObmT6qKDV9KQVTZWzmZ1wgeBCpa1xb8IScc9DVhcc61PjbXvwomvfR/4eYV+tAdWwXIoX0mXeZTrRhrrsxUCEjC/FWG4yEeEgBimHCSyT2Anrvsa4pKkBko4TztCnZJB6v+JTZ/8mwn/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/5k37Nu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/5k37Nu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5327BC4CEF1;
	Tue, 26 Aug 2025 11:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207619;
	bh=PMtdQoemG12pHtl2vBLEf5TOwzHoSGlbKFB2PQ6OQyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S/5k37NuFMmMtVVXZP0Sy8AA129EM4g4o+JcTT32jwVx4/PREB2Bgd4CDG6kRCTnD
	 nSTrOVuYIjYuFJ4gw7BOni7JglNKecfUSFwVMGwfqrnHl/HptlW2Ruc1khMMHefFuT
	 wYZ5cX/rD3XtYjxTrvJhnOm+kmwG65JUxZd2hPSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 222/457] xfs: decouple xfs_trans_alloc_empty from xfs_trans_alloc
Date: Tue, 26 Aug 2025 13:08:26 +0200
Message-ID: <20250826110942.853865634@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 83a80e95e797a2a6d14bf7983e5e6eecf8f5facb ]

xfs_trans_alloc_empty only shares the very basic transaction structure
allocation and initialization with xfs_trans_alloc.

Split out a new __xfs_trans_alloc helper for that and otherwise decouple
xfs_trans_alloc_empty from xfs_trans_alloc.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Stable-dep-of: d2845519b072 ("xfs: fully decouple XFS_IBULK* flags from XFS_IWALK* flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_trans.c |   52 ++++++++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 24 deletions(-)

--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -241,6 +241,28 @@ undo_blocks:
 	return error;
 }
 
+static struct xfs_trans *
+__xfs_trans_alloc(
+	struct xfs_mount	*mp,
+	uint			flags)
+{
+	struct xfs_trans	*tp;
+
+	ASSERT(!(flags & XFS_TRANS_RES_FDBLKS) || xfs_has_lazysbcount(mp));
+
+	tp = kmem_cache_zalloc(xfs_trans_cache, GFP_KERNEL | __GFP_NOFAIL);
+	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
+		sb_start_intwrite(mp->m_super);
+	xfs_trans_set_context(tp);
+	tp->t_flags = flags;
+	tp->t_mountp = mp;
+	INIT_LIST_HEAD(&tp->t_items);
+	INIT_LIST_HEAD(&tp->t_busy);
+	INIT_LIST_HEAD(&tp->t_dfops);
+	tp->t_highest_agno = NULLAGNUMBER;
+	return tp;
+}
+
 int
 xfs_trans_alloc(
 	struct xfs_mount	*mp,
@@ -254,33 +276,16 @@ xfs_trans_alloc(
 	bool			want_retry = true;
 	int			error;
 
+	ASSERT(resp->tr_logres > 0);
+
 	/*
 	 * Allocate the handle before we do our freeze accounting and setting up
 	 * GFP_NOFS allocation context so that we avoid lockdep false positives
 	 * by doing GFP_KERNEL allocations inside sb_start_intwrite().
 	 */
 retry:
-	tp = kmem_cache_zalloc(xfs_trans_cache, GFP_KERNEL | __GFP_NOFAIL);
-	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
-		sb_start_intwrite(mp->m_super);
-	xfs_trans_set_context(tp);
-
-	/*
-	 * Zero-reservation ("empty") transactions can't modify anything, so
-	 * they're allowed to run while we're frozen.
-	 */
-	WARN_ON(resp->tr_logres > 0 &&
-		mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
-	ASSERT(!(flags & XFS_TRANS_RES_FDBLKS) ||
-	       xfs_has_lazysbcount(mp));
-
-	tp->t_flags = flags;
-	tp->t_mountp = mp;
-	INIT_LIST_HEAD(&tp->t_items);
-	INIT_LIST_HEAD(&tp->t_busy);
-	INIT_LIST_HEAD(&tp->t_dfops);
-	tp->t_highest_agno = NULLAGNUMBER;
-
+	WARN_ON(mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
+	tp = __xfs_trans_alloc(mp, flags);
 	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
 	if (error == -ENOSPC && want_retry) {
 		xfs_trans_cancel(tp);
@@ -329,9 +334,8 @@ xfs_trans_alloc_empty(
 	struct xfs_mount		*mp,
 	struct xfs_trans		**tpp)
 {
-	struct xfs_trans_res		resv = {0};
-
-	return xfs_trans_alloc(mp, &resv, 0, 0, XFS_TRANS_NO_WRITECOUNT, tpp);
+	*tpp = __xfs_trans_alloc(mp, XFS_TRANS_NO_WRITECOUNT);
+	return 0;
 }
 
 /*


