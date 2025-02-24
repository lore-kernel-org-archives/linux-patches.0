Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B284254879;
	Mon, 24 Feb 2025 14:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407993; cv=none; b=Qr0OrKympAbh2ow6UbzkDkKaMh5l3zEgYi1xKTviXnIDJtiCwCCUY6vIj85v7+8NPinbJTcLwMMWQDxeBQv7amTzg/MJUsrFNxEoOX2ME8ZP/0uYpK3B2Sh7jDcBEc48pSVsaKIO0o2ohXFQWnb7KKCk9MrgdXbRaKCoeqrFIbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407993; c=relaxed/simple;
	bh=ZXia6OetJIBkA/Qam0WEFcnNGjyhE7To9j3JJHEmJIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mddj1JvyeEHRdIK/oFpT/7Tg4lkE7TAlmmnO1xEfB1S1aYfm8tNRN+3N/5UkugnERw4UBhIWeI1GonBn6YBEPwSr3DFzQc6uy8+3ZpotJfKwLvYmc5bmFidO5mTRvtXg8slV57w0hbo5xVOVnnY9+pViB9a9dVHZEA5Sj5dxU34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oP431Cib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oP431Cib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA2EC4CEE8;
	Mon, 24 Feb 2025 14:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407993;
	bh=ZXia6OetJIBkA/Qam0WEFcnNGjyhE7To9j3JJHEmJIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oP431CibsMkM7KNhIe7eISUhtsLRwUj9ryE3m3fmfO5J96brzR3R5vN+WP1myEhZU
	 QqeltS40+fylCqwHyRc0c+iimoDuPw5RtsPcpCiUDm3h3a3V7ttPFOhySq1tQOITs4
	 4dxNUUeaBOMFfkKit4xXv5Ga2dIq2wAHkV1CEt+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/140] xfs: report realtime block quota limits on realtime directories
Date: Mon, 24 Feb 2025 15:33:45 +0100
Message-ID: <20250224142604.033536001@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 9a17ebfea9d0c7e0bb7409dcf655bf982a5d6e52 ]

On the data device, calling statvfs on a projinherit directory results
in the block and avail counts being curtailed to the project quota block
limits, if any are set.  Do the same for realtime files or directories,
only use the project quota rt block limits.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 4b8d867ca6e2 ("xfs: don't over-report free space or inodes in statvfs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_qm_bhv.c | 18 ++++++++++++------
 fs/xfs/xfs_super.c  | 11 +++++------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index b77673dd05581..268a07218c777 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -19,18 +19,24 @@
 STATIC void
 xfs_fill_statvfs_from_dquot(
 	struct kstatfs		*statp,
+	struct xfs_inode	*ip,
 	struct xfs_dquot	*dqp)
 {
+	struct xfs_dquot_res	*blkres = &dqp->q_blk;
 	uint64_t		limit;
 
-	limit = dqp->q_blk.softlimit ?
-		dqp->q_blk.softlimit :
-		dqp->q_blk.hardlimit;
+	if (XFS_IS_REALTIME_MOUNT(ip->i_mount) &&
+	    (ip->i_diflags & (XFS_DIFLAG_RTINHERIT | XFS_DIFLAG_REALTIME)))
+		blkres = &dqp->q_rtb;
+
+	limit = blkres->softlimit ?
+		blkres->softlimit :
+		blkres->hardlimit;
 	if (limit && statp->f_blocks > limit) {
 		statp->f_blocks = limit;
 		statp->f_bfree = statp->f_bavail =
-			(statp->f_blocks > dqp->q_blk.reserved) ?
-			 (statp->f_blocks - dqp->q_blk.reserved) : 0;
+			(statp->f_blocks > blkres->reserved) ?
+			 (statp->f_blocks - blkres->reserved) : 0;
 	}
 
 	limit = dqp->q_ino.softlimit ?
@@ -61,7 +67,7 @@ xfs_qm_statvfs(
 	struct xfs_dquot	*dqp;
 
 	if (!xfs_qm_dqget(mp, ip->i_projid, XFS_DQTYPE_PROJ, false, &dqp)) {
-		xfs_fill_statvfs_from_dquot(statp, dqp);
+		xfs_fill_statvfs_from_dquot(statp, ip, dqp);
 		xfs_qm_dqput(dqp);
 	}
 }
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 13007b6bc9f33..a726fbba49e40 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -878,12 +878,6 @@ xfs_fs_statfs(
 	ffree = statp->f_files - (icount - ifree);
 	statp->f_ffree = max_t(int64_t, ffree, 0);
 
-
-	if ((ip->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
-	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))) ==
-			      (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))
-		xfs_qm_statvfs(ip, statp);
-
 	if (XFS_IS_REALTIME_MOUNT(mp) &&
 	    (ip->i_diflags & (XFS_DIFLAG_RTINHERIT | XFS_DIFLAG_REALTIME))) {
 		s64	freertx;
@@ -893,6 +887,11 @@ xfs_fs_statfs(
 		statp->f_bavail = statp->f_bfree = freertx * sbp->sb_rextsize;
 	}
 
+	if ((ip->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
+	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))) ==
+			      (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))
+		xfs_qm_statvfs(ip, statp);
+
 	return 0;
 }
 
-- 
2.39.5



