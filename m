Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0D83C3C;
	Fri, 27 Sep 2024 12:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440372; cv=none; b=qM61gvwgxV9wTi6MKkbPGFaIkuU8zY+S1pdW0XiMKp8UDIumJDEQyQYNVlyNwHJjnjXtBQzVz0EScJpDabJz2t5q7rntshyEY8jrZnS7kCgDggW7/Kz3fNpLahXNMKIlCP+LFXhLffnUGDOqfuuWxntEc6Aqoa+zOb8/11JEFEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440372; c=relaxed/simple;
	bh=COtwkjH56TxVc1ce/sdypSd8A2fgzoEtRy1842LMKfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXh7+mnUZkPbwOX9GKuqfRe3PbUu+hmeo6jBY6rNmrY1LZHo0TW5aUJtifaAJmVkl+vBvmFJ5SsarekrYp3qUj/wc3ZrnhJ/zWm+e2ba10d8oeFwZO+Zr4Qi5RXQC7BmT3Q8i7j2WpvMMJKaZuXh0nJMeH0DzagEMxI/6ISYAr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=otvEHaZJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="otvEHaZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496D3C4CEC4;
	Fri, 27 Sep 2024 12:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440372;
	bh=COtwkjH56TxVc1ce/sdypSd8A2fgzoEtRy1842LMKfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=otvEHaZJ95/Y758GHM6Urd7JBHzci63eviyOe7XfcncCpiLdoB9STMaBNp0ratoRd
	 M56ttTYXVm0grq0DsV53HhRbJJX9aLXIPmjriTtGjWUuyhoy4XHG+/yC7RYC2ta+zC
	 NKPjeHhgI96EPpFHINWhSko1wyLoLrIjhfbv0DVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 58/73] xfs: journal geometry is not properly bounds checked
Date: Fri, 27 Sep 2024 14:24:09 +0200
Message-ID: <20240927121722.271995756@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit f1e1765aad7de7a8b8102044fc6a44684bc36180 ]

If the journal geometry results in a sector or log stripe unit
validation problem, it indicates that we cannot set the log up to
safely write to the the journal. In these cases, we must abort the
mount because the corruption needs external intervention to resolve.
Similarly, a journal that is too large cannot be written to safely,
either, so we shouldn't allow those geometries to mount, either.

If the log is too small, we risk having transaction reservations
overruning the available log space and the system hanging waiting
for space it can never provide. This is purely a runtime hang issue,
not a corruption issue as per the first cases listed above. We abort
mounts of the log is too small for V5 filesystems, but we must allow
v4 filesystems to mount because, historically, there was no log size
validity checking and so some systems may still be out there with
undersized logs.

The problem is that on V4 filesystems, when we discover a log
geometry problem, we skip all the remaining checks and then allow
the log to continue mounting. This mean that if one of the log size
checks fails, we skip the log stripe unit check. i.e. we allow the
mount because a "non-fatal" geometry is violated, and then fail to
check the hard fail geometries that should fail the mount.

Move all these fatal checks to the superblock verifier, and add a
new check for the two log sector size geometry variables having the
same values. This will prevent any attempt to mount a log that has
invalid or inconsistent geometries long before we attempt to mount
the log.

However, for the minimum log size checks, we can only do that once
we've setup up the log and calculated all the iclog sizes and
roundoffs. Hence this needs to remain in the log mount code after
the log has been initialised. It is also the only case where we
should allow a v4 filesystem to continue running, so leave that
handling in place, too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Notes:
    A new fix for the latest 6.1.y backport series just came in. Ran
    some tests on it as well and all looks good. Please include with
    the original set.

    Thanks,
    Leah

 fs/xfs/libxfs/xfs_sb.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_log.c       |   47 +++++++++++++----------------------------
 2 files changed, 70 insertions(+), 33 deletions(-)

--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -413,7 +413,6 @@ xfs_validate_sb_common(
 	    sbp->sb_inodelog < XFS_DINODE_MIN_LOG			||
 	    sbp->sb_inodelog > XFS_DINODE_MAX_LOG			||
 	    sbp->sb_inodesize != (1 << sbp->sb_inodelog)		||
-	    sbp->sb_logsunit > XLOG_MAX_RECORD_BSIZE			||
 	    sbp->sb_inopblock != howmany(sbp->sb_blocksize,sbp->sb_inodesize) ||
 	    XFS_FSB_TO_B(mp, sbp->sb_agblocks) < XFS_MIN_AG_BYTES	||
 	    XFS_FSB_TO_B(mp, sbp->sb_agblocks) > XFS_MAX_AG_BYTES	||
@@ -431,6 +430,61 @@ xfs_validate_sb_common(
 		return -EFSCORRUPTED;
 	}
 
+	/*
+	 * Logs that are too large are not supported at all. Reject them
+	 * outright. Logs that are too small are tolerated on v4 filesystems,
+	 * but we can only check that when mounting the log. Hence we skip
+	 * those checks here.
+	 */
+	if (sbp->sb_logblocks > XFS_MAX_LOG_BLOCKS) {
+		xfs_notice(mp,
+		"Log size 0x%x blocks too large, maximum size is 0x%llx blocks",
+			 sbp->sb_logblocks, XFS_MAX_LOG_BLOCKS);
+		return -EFSCORRUPTED;
+	}
+
+	if (XFS_FSB_TO_B(mp, sbp->sb_logblocks) > XFS_MAX_LOG_BYTES) {
+		xfs_warn(mp,
+		"log size 0x%llx bytes too large, maximum size is 0x%llx bytes",
+			 XFS_FSB_TO_B(mp, sbp->sb_logblocks),
+			 XFS_MAX_LOG_BYTES);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * Do not allow filesystems with corrupted log sector or stripe units to
+	 * be mounted. We cannot safely size the iclogs or write to the log if
+	 * the log stripe unit is not valid.
+	 */
+	if (sbp->sb_versionnum & XFS_SB_VERSION_SECTORBIT) {
+		if (sbp->sb_logsectsize != (1U << sbp->sb_logsectlog)) {
+			xfs_notice(mp,
+			"log sector size in bytes/log2 (0x%x/0x%x) must match",
+				sbp->sb_logsectsize, 1U << sbp->sb_logsectlog);
+			return -EFSCORRUPTED;
+		}
+	} else if (sbp->sb_logsectsize || sbp->sb_logsectlog) {
+		xfs_notice(mp,
+		"log sector size in bytes/log2 (0x%x/0x%x) are not zero",
+			sbp->sb_logsectsize, sbp->sb_logsectlog);
+		return -EFSCORRUPTED;
+	}
+
+	if (sbp->sb_logsunit > 1) {
+		if (sbp->sb_logsunit % sbp->sb_blocksize) {
+			xfs_notice(mp,
+		"log stripe unit 0x%x bytes must be a multiple of block size",
+				sbp->sb_logsunit);
+			return -EFSCORRUPTED;
+		}
+		if (sbp->sb_logsunit > XLOG_MAX_RECORD_BSIZE) {
+			xfs_notice(mp,
+		"log stripe unit 0x%x bytes over maximum size (0x%x bytes)",
+				sbp->sb_logsunit, XLOG_MAX_RECORD_BSIZE);
+			return -EFSCORRUPTED;
+		}
+	}
+
 	/* Validate the realtime geometry; stolen from xfs_repair */
 	if (sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE ||
 	    sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE) {
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -639,7 +639,6 @@ xfs_log_mount(
 	int		num_bblks)
 {
 	struct xlog	*log;
-	bool		fatal = xfs_has_crc(mp);
 	int		error = 0;
 	int		min_logfsbs;
 
@@ -661,53 +660,37 @@ xfs_log_mount(
 	mp->m_log = log;
 
 	/*
-	 * Validate the given log space and drop a critical message via syslog
-	 * if the log size is too small that would lead to some unexpected
-	 * situations in transaction log space reservation stage.
+	 * Now that we have set up the log and it's internal geometry
+	 * parameters, we can validate the given log space and drop a critical
+	 * message via syslog if the log size is too small. A log that is too
+	 * small can lead to unexpected situations in transaction log space
+	 * reservation stage. The superblock verifier has already validated all
+	 * the other log geometry constraints, so we don't have to check those
+	 * here.
 	 *
-	 * Note: we can't just reject the mount if the validation fails.  This
-	 * would mean that people would have to downgrade their kernel just to
-	 * remedy the situation as there is no way to grow the log (short of
-	 * black magic surgery with xfs_db).
+	 * Note: For v4 filesystems, we can't just reject the mount if the
+	 * validation fails.  This would mean that people would have to
+	 * downgrade their kernel just to remedy the situation as there is no
+	 * way to grow the log (short of black magic surgery with xfs_db).
 	 *
-	 * We can, however, reject mounts for CRC format filesystems, as the
+	 * We can, however, reject mounts for V5 format filesystems, as the
 	 * mkfs binary being used to make the filesystem should never create a
 	 * filesystem with a log that is too small.
 	 */
 	min_logfsbs = xfs_log_calc_minimum_size(mp);
-
 	if (mp->m_sb.sb_logblocks < min_logfsbs) {
 		xfs_warn(mp,
 		"Log size %d blocks too small, minimum size is %d blocks",
 			 mp->m_sb.sb_logblocks, min_logfsbs);
-		error = -EINVAL;
-	} else if (mp->m_sb.sb_logblocks > XFS_MAX_LOG_BLOCKS) {
-		xfs_warn(mp,
-		"Log size %d blocks too large, maximum size is %lld blocks",
-			 mp->m_sb.sb_logblocks, XFS_MAX_LOG_BLOCKS);
-		error = -EINVAL;
-	} else if (XFS_FSB_TO_B(mp, mp->m_sb.sb_logblocks) > XFS_MAX_LOG_BYTES) {
-		xfs_warn(mp,
-		"log size %lld bytes too large, maximum size is %lld bytes",
-			 XFS_FSB_TO_B(mp, mp->m_sb.sb_logblocks),
-			 XFS_MAX_LOG_BYTES);
-		error = -EINVAL;
-	} else if (mp->m_sb.sb_logsunit > 1 &&
-		   mp->m_sb.sb_logsunit % mp->m_sb.sb_blocksize) {
-		xfs_warn(mp,
-		"log stripe unit %u bytes must be a multiple of block size",
-			 mp->m_sb.sb_logsunit);
-		error = -EINVAL;
-		fatal = true;
-	}
-	if (error) {
+
 		/*
 		 * Log check errors are always fatal on v5; or whenever bad
 		 * metadata leads to a crash.
 		 */
-		if (fatal) {
+		if (xfs_has_crc(mp)) {
 			xfs_crit(mp, "AAIEEE! Log failed size checks. Abort!");
 			ASSERT(0);
+			error = -EINVAL;
 			goto out_free_log;
 		}
 		xfs_crit(mp, "Log size out of supported range.");


