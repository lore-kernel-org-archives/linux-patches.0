Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EE61F3B96;
	Mon, 23 Jun 2025 21:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714480; cv=none; b=OfvdbZR8LfGdKMuTIfrPnSIj9V8dBsa1bDoTrUFerGucGagOcj51il690Ufq1Q2q+RKb5sEo+b11GbxHoSr2R1PZX00QnsGp9qA9+2tdoKSCaBtGXuQhRgJ92ACmci6ynFNLZN2iAkAYee23BK1CYDd6AaS1a4Y2r92D+hrevgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714480; c=relaxed/simple;
	bh=0in57aBrnqWrO9VACimuDAT7np8FvcuMWA47/BFY+oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfHgApw9u2Jw7wUHzd0La/w91zBWPC0CVMhXP3H3z3dYerF5t9a6Qhe6dQMqb1HM62j3KxPCc92LjBNxMDzIo4lLUghwtzul4SfZZz1qChVDuAPMZeudqOrj7efhFrqN4XDHM8drjbTb5wQ5apiPQDt3seLl1dKRi+kfOK7MOrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E4OdFE1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E4OdFE1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9A8C4CEEA;
	Mon, 23 Jun 2025 21:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714480;
	bh=0in57aBrnqWrO9VACimuDAT7np8FvcuMWA47/BFY+oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E4OdFE1ogdSbe66fsIdND4Da/suAcFVXGq9Z3UN+s1LG2FdkhNsXrmxraChgd4q59
	 PjWxiKiL4WGAVaWHscBi8a1WMjxnh411i4v11tQBVtEB8VxiGhX+vK1hLYBjR3yszB
	 CEs6zE/I99A//Or3zbdKedPFA5zfc1+JVCaTktF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 197/508] xfs: fix xfs_btree_query_range callers to initialize btree rec fully
Date: Mon, 23 Jun 2025 15:04:02 +0200
Message-ID: <20250623130650.116802940@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 75dc0345312221971903b2e28279b7e24b7dbb1b ]

Use struct initializers to ensure that the xfs_btree_irecs passed into
the query_range function are completely initialized.  No functional
changes, just closing some sloppy hygiene.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c    | 10 +++-------
 fs/xfs/libxfs/xfs_refcount.c | 13 +++++++------
 fs/xfs/libxfs/xfs_rmap.c     | 10 +++-------
 3 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index c08265f191368..cd5b197d70464 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3545,15 +3545,11 @@ xfs_alloc_query_range(
 	xfs_alloc_query_range_fn		fn,
 	void					*priv)
 {
-	union xfs_btree_irec			low_brec;
-	union xfs_btree_irec			high_brec;
-	struct xfs_alloc_query_range_info	query;
+	union xfs_btree_irec			low_brec = { .a = *low_rec };
+	union xfs_btree_irec			high_brec = { .a = *high_rec };
+	struct xfs_alloc_query_range_info	query = { .priv = priv, .fn = fn };
 
 	ASSERT(cur->bc_btnum == XFS_BTNUM_BNO);
-	low_brec.a = *low_rec;
-	high_brec.a = *high_rec;
-	query.priv = priv;
-	query.fn = fn;
 	return xfs_btree_query_range(cur, &low_brec, &high_brec,
 			xfs_alloc_query_range_helper, &query);
 }
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 4ec7a81dd3eff..7e16e76fd2e18 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1903,8 +1903,13 @@ xfs_refcount_recover_cow_leftovers(
 	struct xfs_buf			*agbp;
 	struct xfs_refcount_recovery	*rr, *n;
 	struct list_head		debris;
-	union xfs_btree_irec		low;
-	union xfs_btree_irec		high;
+	union xfs_btree_irec		low = {
+		.rc.rc_domain		= XFS_REFC_DOMAIN_COW,
+	};
+	union xfs_btree_irec		high = {
+		.rc.rc_domain		= XFS_REFC_DOMAIN_COW,
+		.rc.rc_startblock	= -1U,
+	};
 	xfs_fsblock_t			fsb;
 	int				error;
 
@@ -1935,10 +1940,6 @@ xfs_refcount_recover_cow_leftovers(
 	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, pag);
 
 	/* Find all the leftover CoW staging extents. */
-	memset(&low, 0, sizeof(low));
-	memset(&high, 0, sizeof(high));
-	low.rc.rc_domain = high.rc.rc_domain = XFS_REFC_DOMAIN_COW;
-	high.rc.rc_startblock = -1U;
 	error = xfs_btree_query_range(cur, &low, &high,
 			xfs_refcount_recover_extent, &debris);
 	xfs_btree_del_cursor(cur, error);
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index b56aca1e7c66c..95d3599561cea 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2337,14 +2337,10 @@ xfs_rmap_query_range(
 	xfs_rmap_query_range_fn			fn,
 	void					*priv)
 {
-	union xfs_btree_irec			low_brec;
-	union xfs_btree_irec			high_brec;
-	struct xfs_rmap_query_range_info	query;
+	union xfs_btree_irec			low_brec = { .r = *low_rec };
+	union xfs_btree_irec			high_brec = { .r = *high_rec };
+	struct xfs_rmap_query_range_info	query = { .priv = priv, .fn = fn };
 
-	low_brec.r = *low_rec;
-	high_brec.r = *high_rec;
-	query.priv = priv;
-	query.fn = fn;
 	return xfs_btree_query_range(cur, &low_brec, &high_brec,
 			xfs_rmap_query_range_helper, &query);
 }
-- 
2.39.5



