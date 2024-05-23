Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1203414A4F0;
	Thu, 23 May 2024 13:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470412; cv=none; b=R8Ah/4QOa0bpbJTerApQsGzm4ql1ZH15I/kJPy9WQNXdDb2gCAiMDGezNnWgnF2DjwPyrUx0f3shU1/W1/Z+PRYuHY+xi2ksPuewNMxfeB5WPAITnMxQBGdOprZ9gJugDpOZ7r9/9MB2o0rWl7ISHpN5X/uhVy3rbSu+bxIUWto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470412; c=relaxed/simple;
	bh=XCowPjSTRuZNVOIKL3wIuVoRHjyQfm0hq4mLf6iBsKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AgGHp9Dz44CLPWUiG7VGtgcQ7teoaRTWHOc1QSSqZCyskEHfi4opJxb+k8KAxPwjj7CBNPN7XKTxC6za4NpYAByJzDoiH0fKNfWp/AOTT+1M2oLWZUw5VtxLb+6/c0dWmPWHSKAV3u/JM0C2Nj2Xclnt1SBXRPCpdHYPNJJCXls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZdwFL1fh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdwFL1fh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF37C32786;
	Thu, 23 May 2024 13:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470411;
	bh=XCowPjSTRuZNVOIKL3wIuVoRHjyQfm0hq4mLf6iBsKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZdwFL1fhhsFOWONBFoyCB4+C0/37TbVHTMmgxmL+iQzufs0SbjhOc5RBtwHErrT/g
	 nL+HemHHCTZYQQ7eaXaYH8+BFladGPllbgT1oYrDLYLTA5+HuWv0ElUVAwOZADFMCH
	 5FESO1OOJdAsmgpberPEBIXg8a2o1AClcg2NSt3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Xiao Yang <yangx.jy@fujitsu.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 27/45] xfs: hoist refcount record merge predicates
Date: Thu, 23 May 2024 15:13:18 +0200
Message-ID: <20240523130333.520491656@linuxfoundation.org>
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

[ Upstream commit 9d720a5a658f5135861773f26e927449bef93d61 ]

Hoist these multiline conditionals into separate static inline helpers
to improve readability and set the stage for corruption fixes that will
be introduced in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Xiao Yang <yangx.jy@fujitsu.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_refcount.c |  129 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 113 insertions(+), 16 deletions(-)

--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -815,11 +815,119 @@ out_error:
 /* Is this extent valid? */
 static inline bool
 xfs_refc_valid(
-	struct xfs_refcount_irec	*rc)
+	const struct xfs_refcount_irec	*rc)
 {
 	return rc->rc_startblock != NULLAGBLOCK;
 }
 
+static inline bool
+xfs_refc_want_merge_center(
+	const struct xfs_refcount_irec	*left,
+	const struct xfs_refcount_irec	*cleft,
+	const struct xfs_refcount_irec	*cright,
+	const struct xfs_refcount_irec	*right,
+	bool				cleft_is_cright,
+	enum xfs_refc_adjust_op		adjust,
+	unsigned long long		*ulenp)
+{
+	unsigned long long		ulen = left->rc_blockcount;
+
+	/*
+	 * To merge with a center record, both shoulder records must be
+	 * adjacent to the record we want to adjust.  This is only true if
+	 * find_left and find_right made all four records valid.
+	 */
+	if (!xfs_refc_valid(left)  || !xfs_refc_valid(right) ||
+	    !xfs_refc_valid(cleft) || !xfs_refc_valid(cright))
+		return false;
+
+	/* There must only be one record for the entire range. */
+	if (!cleft_is_cright)
+		return false;
+
+	/* The shoulder record refcounts must match the new refcount. */
+	if (left->rc_refcount != cleft->rc_refcount + adjust)
+		return false;
+	if (right->rc_refcount != cleft->rc_refcount + adjust)
+		return false;
+
+	/*
+	 * The new record cannot exceed the max length.  ulen is a ULL as the
+	 * individual record block counts can be up to (u32 - 1) in length
+	 * hence we need to catch u32 addition overflows here.
+	 */
+	ulen += cleft->rc_blockcount + right->rc_blockcount;
+	if (ulen >= MAXREFCEXTLEN)
+		return false;
+
+	*ulenp = ulen;
+	return true;
+}
+
+static inline bool
+xfs_refc_want_merge_left(
+	const struct xfs_refcount_irec	*left,
+	const struct xfs_refcount_irec	*cleft,
+	enum xfs_refc_adjust_op		adjust)
+{
+	unsigned long long		ulen = left->rc_blockcount;
+
+	/*
+	 * For a left merge, the left shoulder record must be adjacent to the
+	 * start of the range.  If this is true, find_left made left and cleft
+	 * contain valid contents.
+	 */
+	if (!xfs_refc_valid(left) || !xfs_refc_valid(cleft))
+		return false;
+
+	/* Left shoulder record refcount must match the new refcount. */
+	if (left->rc_refcount != cleft->rc_refcount + adjust)
+		return false;
+
+	/*
+	 * The new record cannot exceed the max length.  ulen is a ULL as the
+	 * individual record block counts can be up to (u32 - 1) in length
+	 * hence we need to catch u32 addition overflows here.
+	 */
+	ulen += cleft->rc_blockcount;
+	if (ulen >= MAXREFCEXTLEN)
+		return false;
+
+	return true;
+}
+
+static inline bool
+xfs_refc_want_merge_right(
+	const struct xfs_refcount_irec	*cright,
+	const struct xfs_refcount_irec	*right,
+	enum xfs_refc_adjust_op		adjust)
+{
+	unsigned long long		ulen = right->rc_blockcount;
+
+	/*
+	 * For a right merge, the right shoulder record must be adjacent to the
+	 * end of the range.  If this is true, find_right made cright and right
+	 * contain valid contents.
+	 */
+	if (!xfs_refc_valid(right) || !xfs_refc_valid(cright))
+		return false;
+
+	/* Right shoulder record refcount must match the new refcount. */
+	if (right->rc_refcount != cright->rc_refcount + adjust)
+		return false;
+
+	/*
+	 * The new record cannot exceed the max length.  ulen is a ULL as the
+	 * individual record block counts can be up to (u32 - 1) in length
+	 * hence we need to catch u32 addition overflows here.
+	 */
+	ulen += cright->rc_blockcount;
+	if (ulen >= MAXREFCEXTLEN)
+		return false;
+
+	return true;
+}
+
 /*
  * Try to merge with any extents on the boundaries of the adjustment range.
  */
@@ -861,23 +969,15 @@ xfs_refcount_merge_extents(
 		 (cleft.rc_blockcount == cright.rc_blockcount);
 
 	/* Try to merge left, cleft, and right.  cleft must == cright. */
-	ulen = (unsigned long long)left.rc_blockcount + cleft.rc_blockcount +
-			right.rc_blockcount;
-	if (xfs_refc_valid(&left) && xfs_refc_valid(&right) &&
-	    xfs_refc_valid(&cleft) && xfs_refc_valid(&cright) && cequal &&
-	    left.rc_refcount == cleft.rc_refcount + adjust &&
-	    right.rc_refcount == cleft.rc_refcount + adjust &&
-	    ulen < MAXREFCEXTLEN) {
+	if (xfs_refc_want_merge_center(&left, &cleft, &cright, &right, cequal,
+				adjust, &ulen)) {
 		*shape_changed = true;
 		return xfs_refcount_merge_center_extents(cur, &left, &cleft,
 				&right, ulen, aglen);
 	}
 
 	/* Try to merge left and cleft. */
-	ulen = (unsigned long long)left.rc_blockcount + cleft.rc_blockcount;
-	if (xfs_refc_valid(&left) && xfs_refc_valid(&cleft) &&
-	    left.rc_refcount == cleft.rc_refcount + adjust &&
-	    ulen < MAXREFCEXTLEN) {
+	if (xfs_refc_want_merge_left(&left, &cleft, adjust)) {
 		*shape_changed = true;
 		error = xfs_refcount_merge_left_extent(cur, &left, &cleft,
 				agbno, aglen);
@@ -893,10 +993,7 @@ xfs_refcount_merge_extents(
 	}
 
 	/* Try to merge cright and right. */
-	ulen = (unsigned long long)right.rc_blockcount + cright.rc_blockcount;
-	if (xfs_refc_valid(&right) && xfs_refc_valid(&cright) &&
-	    right.rc_refcount == cright.rc_refcount + adjust &&
-	    ulen < MAXREFCEXTLEN) {
+	if (xfs_refc_want_merge_right(&cright, &right, adjust)) {
 		*shape_changed = true;
 		return xfs_refcount_merge_right_extent(cur, &right, &cright,
 				aglen);


