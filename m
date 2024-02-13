Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080025FF19;
	Tue, 13 Feb 2024 17:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845238; cv=none; b=WOL/UFHJTPkYEjSu+wz1uj+BY7H0T6iYFcglRX82NXQl4L2ELhEh1QHySbpYgR3KX1FYHUhHVdNIymd39cd2P8Wyb24QvZy+xxP9WTEZmeH/xrl8IUNpg396XKZBlnCtI5LbHNtQyNqupnv5eJt10wJB2mWHkwQl4GizkASQnCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845238; c=relaxed/simple;
	bh=S1KFbAp3ocWHr6a32XFIEvDpb4a7KWFn761OJWkixLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWCGnr7q7EicLDBBc3vIHFbBww0+8Bsxaz6ZI3JZ0ozNt8PTKxR0SqbTQ9mcMG1FFBy1oHpAbZl6tftz6DUJmYbVqCUnr4JziD91oNLKlpb1F1grMfsjZjp/9lodZiwkajEDIhNtKT1O3qhbDf4d/qjJ61DCSu9w/oCMXpllYLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLcNmpX6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLcNmpX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115FCC433F1;
	Tue, 13 Feb 2024 17:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845237;
	bh=S1KFbAp3ocWHr6a32XFIEvDpb4a7KWFn761OJWkixLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLcNmpX6DhXFdH/8ank08E8FckQbwo81JTfjgQHQZrkohWi61Yd3XRdW73AcXq15v
	 NyKXIH+T51IJe+UPoLTjcV4qHC4hASoL7iVLDwpP8/5F+DIANQrUsdEL5ai5Z6Y9dy
	 LTWeGzW89t0t655CqW9mBvHnilwsF/U/QRS0bAQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/121] xfs: make sure maxlen is still congruent with prod when rounding down
Date: Tue, 13 Feb 2024 18:20:32 +0100
Message-ID: <20240213171853.650236500@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit f6a2dae2a1f52ea23f649c02615d073beba4cc35 upstream.

In commit 2a6ca4baed62, we tried to fix an overflow problem in the
realtime allocator that was caused by an overly large maxlen value
causing xfs_rtcheck_range to run off the end of the realtime bitmap.
Unfortunately, there is a subtle bug here -- maxlen (and minlen) both
have to be aligned with @prod, but @prod can be larger than 1 if the
user has set an extent size hint on the file, and that extent size hint
is larger than the realtime extent size.

If the rt free space extents are not aligned to this file's extszhint
because other files without extent size hints allocated space (or the
number of rt extents is similarly not aligned), then it's possible that
maxlen after clamping to sb_rextents will no longer be aligned to prod.
The allocation will succeed just fine, but we still trip the assertion.

Fix the problem by reducing maxlen by any misalignment with prod.  While
we're at it, split the assertions into two so that we can tell which
value had the bad alignment.

Fixes: 2a6ca4baed62 ("xfs: make sure the rt allocator doesn't run off the end")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 31fd65b3aaa9..0e4e2df08aed 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -211,6 +211,23 @@ xfs_rtallocate_range(
 	return error;
 }
 
+/*
+ * Make sure we don't run off the end of the rt volume.  Be careful that
+ * adjusting maxlen downwards doesn't cause us to fail the alignment checks.
+ */
+static inline xfs_extlen_t
+xfs_rtallocate_clamp_len(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		startrtx,
+	xfs_extlen_t		rtxlen,
+	xfs_extlen_t		prod)
+{
+	xfs_extlen_t		ret;
+
+	ret = min(mp->m_sb.sb_rextents, startrtx + rtxlen) - startrtx;
+	return rounddown(ret, prod);
+}
+
 /*
  * Attempt to allocate an extent minlen<=len<=maxlen starting from
  * bitmap block bbno.  If we don't get maxlen then use prod to trim
@@ -248,7 +265,7 @@ xfs_rtallocate_extent_block(
 	     i <= end;
 	     i++) {
 		/* Make sure we don't scan off the end of the rt volume. */
-		maxlen = min(mp->m_sb.sb_rextents, i + maxlen) - i;
+		maxlen = xfs_rtallocate_clamp_len(mp, i, maxlen, prod);
 
 		/*
 		 * See if there's a free extent of maxlen starting at i.
@@ -355,7 +372,8 @@ xfs_rtallocate_extent_exact(
 	int		isfree;		/* extent is free */
 	xfs_rtblock_t	next;		/* next block to try (dummy) */
 
-	ASSERT(minlen % prod == 0 && maxlen % prod == 0);
+	ASSERT(minlen % prod == 0);
+	ASSERT(maxlen % prod == 0);
 	/*
 	 * Check if the range in question (for maxlen) is free.
 	 */
@@ -438,7 +456,9 @@ xfs_rtallocate_extent_near(
 	xfs_rtblock_t	n;		/* next block to try */
 	xfs_rtblock_t	r;		/* result block */
 
-	ASSERT(minlen % prod == 0 && maxlen % prod == 0);
+	ASSERT(minlen % prod == 0);
+	ASSERT(maxlen % prod == 0);
+
 	/*
 	 * If the block number given is off the end, silently set it to
 	 * the last block.
@@ -447,7 +467,7 @@ xfs_rtallocate_extent_near(
 		bno = mp->m_sb.sb_rextents - 1;
 
 	/* Make sure we don't run off the end of the rt volume. */
-	maxlen = min(mp->m_sb.sb_rextents, bno + maxlen) - bno;
+	maxlen = xfs_rtallocate_clamp_len(mp, bno, maxlen, prod);
 	if (maxlen < minlen) {
 		*rtblock = NULLRTBLOCK;
 		return 0;
@@ -638,7 +658,8 @@ xfs_rtallocate_extent_size(
 	xfs_rtblock_t	r;		/* result block number */
 	xfs_suminfo_t	sum;		/* summary information for extents */
 
-	ASSERT(minlen % prod == 0 && maxlen % prod == 0);
+	ASSERT(minlen % prod == 0);
+	ASSERT(maxlen % prod == 0);
 	ASSERT(maxlen != 0);
 
 	/*
-- 
2.43.0



