Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE101D86FF;
	Tue, 11 Nov 2025 01:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825481; cv=none; b=sfTprOaCTcIPUmzl+bI2V2u4qw+LtE9N/8W9h9ExKobygQ7PeDgTddVUozI3hEqHt3AeEW4EMN89vclUsXXxrm1S6aotzuZld2IHDH34tFprfKGfayiHaKSdTE29xe4OslgMfWsEy+hAiC2jrQc9aH6N9klD32GYk8sDXp+4tAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825481; c=relaxed/simple;
	bh=MmnL5mh0YEt6IGBfEhx3Ey5zEwxi0nggaYa8X0KdNAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0mLx3Fw+d6LBGjulg72iQX7bIBybzT5Ndr0SwoilQViXUqQQmeD6PJx+OrLFgECgZre44Mv8jv30ddut5mHrwknC6hbbxpGX5CZQfFcnlfYyjE519ZjNi7th4pcYqRc22KWKT0C2SCCI6QtoW7XdPIkF795YpQ23bUWVNxawLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=quTPmy3J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="quTPmy3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8B0C19421;
	Tue, 11 Nov 2025 01:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825480;
	bh=MmnL5mh0YEt6IGBfEhx3Ey5zEwxi0nggaYa8X0KdNAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=quTPmy3JIiVVdsodiNY5F5tQ+gYqe9QZVWBnZUR4/3N1wNkPMeSPG+QxQ7mMBkhi5
	 by2qhxuOT+7LJ1C/CVww2c/QyrIanqTqBISAgx1ChXIhX098C4ktmiR5xJgaHHiRZX
	 RYf3hegl4DwhFHbI8Ifc9tc7BUESBdmjILyWB6x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.17 821/849] xfs: fix various problems in xfs_atomic_write_cow_iomap_begin
Date: Tue, 11 Nov 2025 09:46:31 +0900
Message-ID: <20251111004556.274824745@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 8d7bba1e8314013ecc817a91624104ceb9352ddc upstream.

I think there are several things wrong with this function:

A) xfs_bmapi_write can return a much larger unwritten mapping than what
   the caller asked for.  We convert part of that range to written, but
   return the entire written mapping to iomap even though that's
   inaccurate.

B) The arguments to xfs_reflink_convert_cow_locked are wrong -- an
   unwritten mapping could be *smaller* than the write range (or even
   the hole range).  In this case, we convert too much file range to
   written state because we then return a smaller mapping to iomap.

C) It doesn't handle delalloc mappings.  This I covered in the patch
   that I already sent to the list.

D) Reassigning count_fsb to handle the hole means that if the second
   cmap lookup attempt succeeds (due to racing with someone else) we
   trim the mapping more than is strictly necessary.  The changing
   meaning of count_fsb makes this harder to notice.

E) The tracepoint is kinda wrong because @length is mutated.  That makes
   it harder to chase the data flows through this function because you
   can't just grep on the pos/bytecount strings.

F) We don't actually check that the br_state = XFS_EXT_NORM assignment
   is accurate, i.e that the cow fork actually contains a written
   mapping for the range we're interested in

G) Somewhat inadequate documentation of why we need to xfs_trim_extent
   so aggressively in this function.

H) Not sure why xfs_iomap_end_fsb is used here, the vfs already clamped
   the write range to s_maxbytes.

Fix these issues, and then the atomic writes regressions in generic/760,
generic/617, generic/091, generic/263, and generic/521 all go away for
me.

Cc: stable@vger.kernel.org # v6.16
Fixes: bd1d2c21d5d249 ("xfs: add xfs_atomic_write_cow_iomap_begin()")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_iomap.c |   61 +++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 50 insertions(+), 11 deletions(-)

--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1082,6 +1082,29 @@ const struct iomap_ops xfs_zoned_direct_
 };
 #endif /* CONFIG_XFS_RT */
 
+#ifdef DEBUG
+static void
+xfs_check_atomic_cow_conversion(
+	struct xfs_inode		*ip,
+	xfs_fileoff_t			offset_fsb,
+	xfs_filblks_t			count_fsb,
+	const struct xfs_bmbt_irec	*cmap)
+{
+	struct xfs_iext_cursor		icur;
+	struct xfs_bmbt_irec		cmap2 = { };
+
+	if (xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &cmap2))
+		xfs_trim_extent(&cmap2, offset_fsb, count_fsb);
+
+	ASSERT(cmap2.br_startoff == cmap->br_startoff);
+	ASSERT(cmap2.br_blockcount == cmap->br_blockcount);
+	ASSERT(cmap2.br_startblock == cmap->br_startblock);
+	ASSERT(cmap2.br_state == cmap->br_state);
+}
+#else
+# define xfs_check_atomic_cow_conversion(...)	((void)0)
+#endif
+
 static int
 xfs_atomic_write_cow_iomap_begin(
 	struct inode		*inode,
@@ -1093,9 +1116,10 @@ xfs_atomic_write_cow_iomap_begin(
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
-	const xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
-	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, offset, length);
-	xfs_filblks_t		count_fsb = end_fsb - offset_fsb;
+	const xfs_fileoff_t	offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	const xfs_fileoff_t	end_fsb = XFS_B_TO_FSB(mp, offset + length);
+	const xfs_filblks_t	count_fsb = end_fsb - offset_fsb;
+	xfs_filblks_t		hole_count_fsb;
 	int			nmaps = 1;
 	xfs_filblks_t		resaligned;
 	struct xfs_bmbt_irec	cmap;
@@ -1134,14 +1158,20 @@ retry:
 	if (cmap.br_startoff <= offset_fsb) {
 		if (isnullstartblock(cmap.br_startblock))
 			goto convert_delay;
+
+		/*
+		 * cmap could extend outside the write range due to previous
+		 * speculative preallocations.  We must trim cmap to the write
+		 * range because the cow fork treats written mappings to mean
+		 * "write in progress".
+		 */
 		xfs_trim_extent(&cmap, offset_fsb, count_fsb);
 		goto found;
 	}
 
-	end_fsb = cmap.br_startoff;
-	count_fsb = end_fsb - offset_fsb;
+	hole_count_fsb = cmap.br_startoff - offset_fsb;
 
-	resaligned = xfs_aligned_fsb_count(offset_fsb, count_fsb,
+	resaligned = xfs_aligned_fsb_count(offset_fsb, hole_count_fsb,
 			xfs_get_cowextsz_hint(ip));
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
@@ -1177,7 +1207,7 @@ retry:
 	 * atomic writes to that same range will be aligned (and don't require
 	 * this COW-based method).
 	 */
-	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
+	error = xfs_bmapi_write(tp, ip, offset_fsb, hole_count_fsb,
 			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC |
 			XFS_BMAPI_EXTSZALIGN, 0, &cmap, &nmaps);
 	if (error) {
@@ -1190,17 +1220,26 @@ retry:
 	if (error)
 		goto out_unlock;
 
+	/*
+	 * cmap could map more blocks than the range we passed into bmapi_write
+	 * because of EXTSZALIGN or adjacent pre-existing unwritten mappings
+	 * that were merged.  Trim cmap to the original write range so that we
+	 * don't convert more than we were asked to do for this write.
+	 */
+	xfs_trim_extent(&cmap, offset_fsb, count_fsb);
+
 found:
 	if (cmap.br_state != XFS_EXT_NORM) {
-		error = xfs_reflink_convert_cow_locked(ip, offset_fsb,
-				count_fsb);
+		error = xfs_reflink_convert_cow_locked(ip, cmap.br_startoff,
+				cmap.br_blockcount);
 		if (error)
 			goto out_unlock;
 		cmap.br_state = XFS_EXT_NORM;
+		xfs_check_atomic_cow_conversion(ip, offset_fsb, count_fsb,
+				&cmap);
 	}
 
-	length = XFS_FSB_TO_B(mp, cmap.br_startoff + cmap.br_blockcount);
-	trace_xfs_iomap_found(ip, offset, length - offset, XFS_COW_FORK, &cmap);
+	trace_xfs_iomap_found(ip, offset, length, XFS_COW_FORK, &cmap);
 	seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);


