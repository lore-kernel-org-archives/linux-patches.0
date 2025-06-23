Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA664315A;
	Mon, 23 Jun 2025 21:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715055; cv=none; b=n6TAvBVJeRMmPhfGfHPA8a0kA6DyGbPZ7xlFGuYKSEYteqhqA6QMTU9c9dOPymJT6GaujQMPcGFYoaSmq+TMI3QnYhgxOJ26VDIr42E0FG+L6SN9BT9IcPlgx2cDO6Q+ndEFLGGfJbd1AkS8T/1YiNPpeR9sEY7mrK4dM0QPdak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715055; c=relaxed/simple;
	bh=DbEFIL4uTrOUZMsOL9a8bzLV3DVpmWMNB6zzJLg69oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndhfTb1mVdFnayxbkbjHoupLBls2M55ARcL1EumN/PSHH+TVLWnyy7HvsQmdmeYH/uX4Em993CqS+eZ78LU2eC2LhJRAzNumOJlfttqViqK5CsliOVcm/4GXT+bsTwIjUrtOl9I3klXZxOVx/sSPeq4+21O4TsaQb4li1NsHU5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q27A927N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q27A927N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459ABC4CEEA;
	Mon, 23 Jun 2025 21:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715055;
	bh=DbEFIL4uTrOUZMsOL9a8bzLV3DVpmWMNB6zzJLg69oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q27A927N2QuwPPW7rpVpwzVoQ+Z6eMshXXW+GjKkBeKzTfhFDh2S7Pq1wiFkdlPVz
	 PMyirC5otVTQcIwNbx6TI9AbQBn5V17dhZwPJ51zrgPZZy3Wgh7980HhBw6HrV9xt2
	 XJNaSJFtkZ5gmJtv4ZQoMkteGu/FnmDi0k1hBMV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 212/508] xfs: take m_growlock when running growfsrt
Date: Mon, 23 Jun 2025 15:04:17 +0200
Message-ID: <20250623130650.480634658@linuxfoundation.org>
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

[ Upstream commit 16e1fbdce9c8d084863fd63cdaff8fb2a54e2f88 ]

Take the grow lock when we're expanding the realtime volume, like we do
for the other growfs calls.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 5cf1e91f4c205..149fcfc485d89 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -953,34 +953,39 @@ xfs_growfs_rt(
 	/* Needs to have been mounted with an rt device. */
 	if (!XFS_IS_REALTIME_MOUNT(mp))
 		return -EINVAL;
+
+	if (!mutex_trylock(&mp->m_growlock))
+		return -EWOULDBLOCK;
 	/*
 	 * Mount should fail if the rt bitmap/summary files don't load, but
 	 * we'll check anyway.
 	 */
+	error = -EINVAL;
 	if (!mp->m_rbmip || !mp->m_rsumip)
-		return -EINVAL;
+		goto out_unlock;
 
 	/* Shrink not supported. */
 	if (in->newblocks <= sbp->sb_rblocks)
-		return -EINVAL;
+		goto out_unlock;
 
 	/* Can only change rt extent size when adding rt volume. */
 	if (sbp->sb_rblocks > 0 && in->extsize != sbp->sb_rextsize)
-		return -EINVAL;
+		goto out_unlock;
 
 	/* Range check the extent size. */
 	if (XFS_FSB_TO_B(mp, in->extsize) > XFS_MAX_RTEXTSIZE ||
 	    XFS_FSB_TO_B(mp, in->extsize) < XFS_MIN_RTEXTSIZE)
-		return -EINVAL;
+		goto out_unlock;
 
 	/* Unsupported realtime features. */
+	error = -EOPNOTSUPP;
 	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp) || xfs_has_quota(mp))
-		return -EOPNOTSUPP;
+		goto out_unlock;
 
 	nrblocks = in->newblocks;
 	error = xfs_sb_validate_fsb_count(sbp, nrblocks);
 	if (error)
-		return error;
+		goto out_unlock;
 	/*
 	 * Read in the last block of the device, make sure it exists.
 	 */
@@ -988,7 +993,7 @@ xfs_growfs_rt(
 				XFS_FSB_TO_BB(mp, nrblocks - 1),
 				XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
 	if (error)
-		return error;
+		goto out_unlock;
 	xfs_buf_relse(bp);
 
 	/*
@@ -996,8 +1001,10 @@ xfs_growfs_rt(
 	 */
 	nrextents = nrblocks;
 	do_div(nrextents, in->extsize);
-	if (!xfs_validate_rtextents(nrextents))
-		return -EINVAL;
+	if (!xfs_validate_rtextents(nrextents)) {
+		error = -EINVAL;
+		goto out_unlock;
+	}
 	nrbmblocks = howmany_64(nrextents, NBBY * sbp->sb_blocksize);
 	nrextslog = xfs_compute_rextslog(nrextents);
 	nrsumlevels = nrextslog + 1;
@@ -1009,8 +1016,11 @@ xfs_growfs_rt(
 	 * the log.  This prevents us from getting a log overflow,
 	 * since we'll log basically the whole summary file at once.
 	 */
-	if (nrsumblocks > (mp->m_sb.sb_logblocks >> 1))
-		return -EINVAL;
+	if (nrsumblocks > (mp->m_sb.sb_logblocks >> 1)) {
+		error = -EINVAL;
+		goto out_unlock;
+	}
+
 	/*
 	 * Get the old block counts for bitmap and summary inodes.
 	 * These can't change since other growfs callers are locked out.
@@ -1022,10 +1032,10 @@ xfs_growfs_rt(
 	 */
 	error = xfs_growfs_rt_alloc(mp, rbmblocks, nrbmblocks, mp->m_rbmip);
 	if (error)
-		return error;
+		goto out_unlock;
 	error = xfs_growfs_rt_alloc(mp, rsumblocks, nrsumblocks, mp->m_rsumip);
 	if (error)
-		return error;
+		goto out_unlock;
 
 	rsum_cache = mp->m_rsum_cache;
 	if (nrbmblocks != sbp->sb_rbmblocks)
@@ -1190,6 +1200,8 @@ xfs_growfs_rt(
 		}
 	}
 
+out_unlock:
+	mutex_unlock(&mp->m_growlock);
 	return error;
 }
 
-- 
2.39.5



