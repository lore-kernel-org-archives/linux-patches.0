Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6014913A897;
	Thu, 23 May 2024 13:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470426; cv=none; b=E1eKncYkedOrr/U/uDzMT+NscjV0zueWse3FwykGQR7mAuh52bkMafMLcyFRoe7FjQqlnwj2lla4gO8y4CHy2dCSTI2QMMVG3j+HzJrASZ2EAPQ8a8QVzej1GNi+WsEEBP+cQuFaJL9ER316oCqFUJkZHTLF3Rvc1xJSSRk2qMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470426; c=relaxed/simple;
	bh=rII5Q+GpBteE68ax2eu2D395ibtDys12Sb46FxaYyXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMUb/qANeZV096h+LFYH1wIhrdnvQZZIOyEfqNX/R9j7Eu11QcDMat9D2cKn12+aCCzphhqNkNuSDO8AYvRVrnjt7F3WOIVE1HmLUDts8ubSAvc9SQCTSE/kVSnibyvP+6MrcPs9wxpsINBJPHJH17GX2HHW25+Pc1juDaia1LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AoG+cz3D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AoG+cz3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC863C32786;
	Thu, 23 May 2024 13:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470426;
	bh=rII5Q+GpBteE68ax2eu2D395ibtDys12Sb46FxaYyXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AoG+cz3DvsU+511XrgKkL5RxLTONwH/ThQRwu7HoT/XOYfivyycZ50KIx/3fS9nV3
	 D09WA66E+O+SPqk8DqfgyPFEY1kLVkpjWoRtChQnoNkVYpZexkmXVf6U5d7Zw13w9f
	 vHfn2LBmIvcu4uUzNoCL8d0VGMQt6NWz4cw/xOVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 31/45] xfs: fix log recovery when unknown rocompat bits are set
Date: Thu, 23 May 2024 15:13:22 +0200
Message-ID: <20240523130333.669646604@linuxfoundation.org>
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
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_sb.c |    3 ++-
 fs/xfs/xfs_log.c       |   17 -----------------
 2 files changed, 2 insertions(+), 18 deletions(-)

--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -266,7 +266,8 @@ xfs_validate_sb_write(
 		return -EFSCORRUPTED;
 	}
 
-	if (xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
+	if (!xfs_is_readonly(mp) &&
+	    xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
 		xfs_alert(mp,
 "Corruption detected in superblock read-only compatible features (0x%x)!",
 			(sbp->sb_features_ro_compat &
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -730,15 +730,7 @@ xfs_log_mount(
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
@@ -787,7 +779,6 @@ xfs_log_mount_finish(
 	struct xfs_mount	*mp)
 {
 	struct xlog		*log = mp->m_log;
-	bool			readonly;
 	int			error = 0;
 
 	if (xfs_has_norecovery(mp)) {
@@ -796,12 +787,6 @@ xfs_log_mount_finish(
 	}
 
 	/*
-	 * log recovery ignores readonly state and so we need to clear
-	 * mount-based read only state so it can write to disk.
-	 */
-	readonly = test_and_clear_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
-
-	/*
 	 * During the second phase of log recovery, we need iget and
 	 * iput to behave like they do for an active filesystem.
 	 * xfs_fs_drop_inode needs to be able to prevent the deletion
@@ -850,8 +835,6 @@ xfs_log_mount_finish(
 	xfs_buftarg_drain(mp->m_ddev_targp);
 
 	clear_bit(XLOG_RECOVERY_NEEDED, &log->l_opstate);
-	if (readonly)
-		set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
 
 	/* Make sure the log is dead if we're returning failure. */
 	ASSERT(!error || xlog_is_shutdown(log));


