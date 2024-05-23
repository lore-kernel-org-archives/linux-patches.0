Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9767E13B7AE;
	Thu, 23 May 2024 13:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470414; cv=none; b=aYE8ultvnyt6e+shx/3jQGkzZ0XWvWJ6tO0qbWeiQGUkyhe5y/1j8cuXtOnAGoMDybAT0cG3xktfdj4Aj42aG0wxDVZOO8BFpGORhlpaWQVxRCNe//4bGemW6x3jLaBNgVBV6yLo6gDix6mKB1gsZpU8gw0z9aa4XRHFEOaCMQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470414; c=relaxed/simple;
	bh=vozqe5HJFExakPx4VYJs81NZXQ1p1+EkNDrstmecujg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYlv7O4XY9nkj5yMfch59Avf+Jo0+fs2A4lEN+4TdRE+4wtquOlhBjeyBLqoAoqnmHn9BbJ0XhjzsBNcxjVR3x7ptKogdqCgJ15xxTDrVBaPvS8tmmMUKQlN8fLQhFGVOfa1N6AASDPyY7JeaJhjYV6LiI4zJ7XKxhE9c83q3H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lyZIToNG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lyZIToNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221CAC2BD10;
	Thu, 23 May 2024 13:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470414;
	bh=vozqe5HJFExakPx4VYJs81NZXQ1p1+EkNDrstmecujg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lyZIToNGIGdn7ZB06EorcHB5rC6XB6YU0qvqDELbw243vp1rrOrhhm3CXZ9Qbt483
	 2myShi/hfvDDoGsj/a7iTFbiQxoCTe/2hTMpkLYL1+uTnRmq1Gh2QUiEbcVN34KNHx
	 MmOAogc0L34E8HPO5BxFT29X4VL2Kx1qBwATXa+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Xiao Yang <yangx.jy@fujitsu.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 28/45] xfs: estimate post-merge refcounts correctly
Date: Thu, 23 May 2024 15:13:19 +0200
Message-ID: <20240523130333.558568101@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
References: <20240523130332.496202557@linuxfoundation.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit b25d1984aa884fc91a73a5a407b9ac976d441e9b ]

Upon enabling fsdax + reflink for XFS, xfs/179 began to report refcount
metadata corruptions after being run.  Specifically, xfs_repair noticed
single-block refcount records that could be combined but had not been.

The root cause of this is improper MAXREFCOUNT edge case handling in
xfs_refcount_merge_extents.  When we're trying to find candidates for a
refcount btree record merge, we compute the refcount attribute of the
merged record, but we fail to account for the fact that once a record
hits rc_refcount == MAXREFCOUNT, it is pinned that way forever.  Hence
the computed refcount is wrong, and we fail to merge the extents.

Fix this by adjusting the merge predicates to compute the adjusted
refcount correctly.

Fixes: 3172725814f9 ("xfs: adjust refcount of an extent of blocks in refcount btree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Xiao Yang <yangx.jy@fujitsu.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_refcount.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -820,6 +820,17 @@ xfs_refc_valid(
 	return rc->rc_startblock != NULLAGBLOCK;
 }
 
+static inline xfs_nlink_t
+xfs_refc_merge_refcount(
+	const struct xfs_refcount_irec	*irec,
+	enum xfs_refc_adjust_op		adjust)
+{
+	/* Once a record hits MAXREFCOUNT, it is pinned there forever */
+	if (irec->rc_refcount == MAXREFCOUNT)
+		return MAXREFCOUNT;
+	return irec->rc_refcount + adjust;
+}
+
 static inline bool
 xfs_refc_want_merge_center(
 	const struct xfs_refcount_irec	*left,
@@ -831,6 +842,7 @@ xfs_refc_want_merge_center(
 	unsigned long long		*ulenp)
 {
 	unsigned long long		ulen = left->rc_blockcount;
+	xfs_nlink_t			new_refcount;
 
 	/*
 	 * To merge with a center record, both shoulder records must be
@@ -846,9 +858,10 @@ xfs_refc_want_merge_center(
 		return false;
 
 	/* The shoulder record refcounts must match the new refcount. */
-	if (left->rc_refcount != cleft->rc_refcount + adjust)
+	new_refcount = xfs_refc_merge_refcount(cleft, adjust);
+	if (left->rc_refcount != new_refcount)
 		return false;
-	if (right->rc_refcount != cleft->rc_refcount + adjust)
+	if (right->rc_refcount != new_refcount)
 		return false;
 
 	/*
@@ -871,6 +884,7 @@ xfs_refc_want_merge_left(
 	enum xfs_refc_adjust_op		adjust)
 {
 	unsigned long long		ulen = left->rc_blockcount;
+	xfs_nlink_t			new_refcount;
 
 	/*
 	 * For a left merge, the left shoulder record must be adjacent to the
@@ -881,7 +895,8 @@ xfs_refc_want_merge_left(
 		return false;
 
 	/* Left shoulder record refcount must match the new refcount. */
-	if (left->rc_refcount != cleft->rc_refcount + adjust)
+	new_refcount = xfs_refc_merge_refcount(cleft, adjust);
+	if (left->rc_refcount != new_refcount)
 		return false;
 
 	/*
@@ -903,6 +918,7 @@ xfs_refc_want_merge_right(
 	enum xfs_refc_adjust_op		adjust)
 {
 	unsigned long long		ulen = right->rc_blockcount;
+	xfs_nlink_t			new_refcount;
 
 	/*
 	 * For a right merge, the right shoulder record must be adjacent to the
@@ -913,7 +929,8 @@ xfs_refc_want_merge_right(
 		return false;
 
 	/* Right shoulder record refcount must match the new refcount. */
-	if (right->rc_refcount != cright->rc_refcount + adjust)
+	new_refcount = xfs_refc_merge_refcount(cright, adjust);
+	if (right->rc_refcount != new_refcount)
 		return false;
 
 	/*


