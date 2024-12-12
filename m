Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7683013792B;
	Thu, 12 Dec 2024 17:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022947; cv=none; b=cw0bp0ogVNx3FaLOLNEot6hg5jli0hpQKYlvqIaBnZ6h7hvjVlvHvspAG6o8oj8+fEIt/KmmdBKVYx5Rgs5TeL3DG1XXv/ZTkpIxS0RG9SjXj1zxfhvi3bMIbg2jjGbiFwKF2VO3KR7ArQ9nNhQEC3E41dWJZb5Fp1K4RghMMbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022947; c=relaxed/simple;
	bh=1/HAYwbjMOVTOIXPgJdMI1H/mdGYXyAY8m53SEd/SMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9br5tASFDVPonmr8T9o8RCiYVcmxS6zZZrIRwWbrM8mbMwXpZTuFGsv6nHIreQAcBcyXdykZf6Q3BlMqd2zk1F16ujlBE+f3XrswBY8l8jzNGj+swET7KwRKn6sni0SuV+M+WzLvm+DaEhAcAxDYJ0+shHfE/aJqRXA2f6Sq74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EmiahxFw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EmiahxFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70D8C4CECE;
	Thu, 12 Dec 2024 17:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022947;
	bh=1/HAYwbjMOVTOIXPgJdMI1H/mdGYXyAY8m53SEd/SMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EmiahxFwCez7rVgg9YQ4uD09MMADWR4r1y6H2MINtPd+1yze97WyFQ+1Ns2iyz9t4
	 MaLSpC82N9ZWiDsKMeQc1W9Cqp614/H7QABs3FK1UL7TiIoqNI4mJOd0uF+hgz9cQL
	 aqjhMYbCc7ssG8/+Ii0vQoMwJmlCs5yeAWBEsbP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 376/565] xfs: fix log recovery when unknown rocompat bits are set
Date: Thu, 12 Dec 2024 15:59:31 +0100
Message-ID: <20241212144326.490898499@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 74ad4693b6473950e971b3dc525b5ee7570e05d0 ]

Log recovery has always run on read only mounts, even where the primary
superblock advertises unknown rocompat bits.  Due to a misunderstanding
between Eric and Darrick back in 2018, we accidentally changed the
superblock write verifier to shutdown the fs over that exact scenario.
As a result, the log cleaning that occurs at the end of the mounting
process fails if there are unknown rocompat bits set.

As we now allow writing of the superblock if there are unknown rocompat
bits set on a RO mount, we no longer want to turn off RO state to allow
log recovery to succeed on a RO mount.  Hence we also remove all the
(now unnecessary) RO state toggling from the log recovery path.

Fixes: 9e037cb7972f ("xfs: check for unknown v5 feature bits in superblock write verifier"
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Stable-dep-of: 652f03db897b ("xfs: remove unknown compat feature check in superblock write validation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c |  3 ++-
 fs/xfs/xfs_log.c       | 17 -----------------
 2 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 26dd9ceb44b42..f867da8128ca6 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -263,7 +263,8 @@ xfs_validate_sb_write(
 		return -EFSCORRUPTED;
 	}
 
-	if (xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
+	if (!xfs_is_readonly(mp) &&
+	    xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
 		xfs_alert(mp,
 "Corruption detected in superblock read-only compatible features (0x%x)!",
 			(sbp->sb_features_ro_compat &
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index eba295f666acc..be2f714d1553a 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -707,15 +707,7 @@ xfs_log_mount(
 	 * just worked.
 	 */
 	if (!xfs_has_norecovery(mp)) {
-		/*
-		 * log recovery ignores readonly state and so we need to clear
-		 * mount-based read only state so it can write to disk.
-		 */
-		bool	readonly = test_and_clear_bit(XFS_OPSTATE_READONLY,
-						&mp->m_opstate);
 		error = xlog_recover(log);
-		if (readonly)
-			set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
 		if (error) {
 			xfs_warn(mp, "log mount/recovery failed: error %d",
 				error);
@@ -764,7 +756,6 @@ xfs_log_mount_finish(
 	struct xfs_mount	*mp)
 {
 	struct xlog		*log = mp->m_log;
-	bool			readonly;
 	int			error = 0;
 
 	if (xfs_has_norecovery(mp)) {
@@ -772,12 +763,6 @@ xfs_log_mount_finish(
 		return 0;
 	}
 
-	/*
-	 * log recovery ignores readonly state and so we need to clear
-	 * mount-based read only state so it can write to disk.
-	 */
-	readonly = test_and_clear_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
-
 	/*
 	 * During the second phase of log recovery, we need iget and
 	 * iput to behave like they do for an active filesystem.
@@ -828,8 +813,6 @@ xfs_log_mount_finish(
 	xfs_buftarg_drain(mp->m_ddev_targp);
 
 	clear_bit(XLOG_RECOVERY_NEEDED, &log->l_opstate);
-	if (readonly)
-		set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
 
 	/* Make sure the log is dead if we're returning failure. */
 	ASSERT(!error || xlog_is_shutdown(log));
-- 
2.43.0



