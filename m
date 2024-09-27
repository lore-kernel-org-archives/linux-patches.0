Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2CE3C3C;
	Fri, 27 Sep 2024 12:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440364; cv=none; b=UrekZJ5xYqTWN+DrddA4fF2bP0lWBCMpwbS+3uUgKYVyzl0q8bHmGbUEYGpJ9hF+MTZAJ4hmHYbruo7OhqqEDt+fxGZe9SgdVWigrzlOL8EqDfIze3mKTZqdV11Y6Bng+TEAwVffAEUFcGjmC4HMTHQrHBKo1TmrS9qzLsMQXp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440364; c=relaxed/simple;
	bh=Ude5mYaAzgjbYQMB1PzSxcGaL4twJuA1C19JGBGOcA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KF0985fe1UBjagsNLyuZiIG/5CSJMbkGIdX0EjyTQw2/m1AoEwFlDUU/Ej5TuVRK8ro+aSzr3dhQgK1NluSKPKJ4bX+qDPQ9YARQ5EIsnCfkviV2ZZOfFfxBy4CEIUcS2OvIza68cVqbEWkCjs6dNRE+nnwS2qEm+xpE/NnRgLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGJqbyht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGJqbyht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF615C4CEC4;
	Fri, 27 Sep 2024 12:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440364;
	bh=Ude5mYaAzgjbYQMB1PzSxcGaL4twJuA1C19JGBGOcA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGJqbyhtAx8suDufd/bnmaXAK1+SFnH3ydHI6ueOAYZwkbCe9Vhwd2jwnviEY12gO
	 BLjtcS4t+KO3xjOsEM9SvkKq/FWUuWxEB+e1SA+MdvDxN026q20OUEMlym9rVSW9xU
	 YJhHYO0WMAy1qeW95mmSvsSfqwiP1zbjpy7E8dAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 55/73] xfs: make inode unlinked bucket recovery work with quotacheck
Date: Fri, 27 Sep 2024 14:24:06 +0200
Message-ID: <20240927121722.156026232@linuxfoundation.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 49813a21ed57895b73ec4ed3b99d4beec931496f ]

Teach quotacheck to reload the unlinked inode lists when walking the
inode table.  This requires extra state handling, since it's possible
that a reloaded inode will get inactivated before quotacheck tries to
scan it; in this case, we need to ensure that the reloaded inode does
not have dquots attached when it is freed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_attr_inactive.c |    1 -
 fs/xfs/xfs_inode.c         |   12 +++++++++---
 fs/xfs/xfs_inode.h         |    5 ++++-
 fs/xfs/xfs_mount.h         |   10 +++++++++-
 fs/xfs/xfs_qm.c            |    7 +++++++
 5 files changed, 29 insertions(+), 6 deletions(-)

--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -333,7 +333,6 @@ xfs_attr_inactive(
 	int			error = 0;
 
 	mp = dp->i_mount;
-	ASSERT(! XFS_NOT_DQATTACHED(mp, dp));
 
 	xfs_ilock(dp, lock_mode);
 	if (!xfs_inode_has_attr_fork(dp))
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1743,9 +1743,13 @@ xfs_inactive(
 	     ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0))
 		truncate = 1;
 
-	error = xfs_qm_dqattach(ip);
-	if (error)
-		goto out;
+	if (xfs_iflags_test(ip, XFS_IQUOTAUNCHECKED)) {
+		xfs_qm_dqdetach(ip);
+	} else {
+		error = xfs_qm_dqattach(ip);
+		if (error)
+			goto out;
+	}
 
 	if (S_ISLNK(VFS_I(ip)->i_mode))
 		error = xfs_inactive_symlink(ip);
@@ -1963,6 +1967,8 @@ xfs_iunlink_reload_next(
 	trace_xfs_iunlink_reload_next(next_ip);
 rele:
 	ASSERT(!(VFS_I(next_ip)->i_state & I_DONTCACHE));
+	if (xfs_is_quotacheck_running(mp) && next_ip)
+		xfs_iflags_set(next_ip, XFS_IQUOTAUNCHECKED);
 	xfs_irele(next_ip);
 	return error;
 }
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -344,6 +344,9 @@ static inline bool xfs_inode_has_large_e
  */
 #define XFS_INACTIVATING	(1 << 13)
 
+/* Quotacheck is running but inode has not been added to quota counts. */
+#define XFS_IQUOTAUNCHECKED	(1 << 14)
+
 /* All inode state flags related to inode reclaim. */
 #define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
 				 XFS_IRECLAIM | \
@@ -358,7 +361,7 @@ static inline bool xfs_inode_has_large_e
 #define XFS_IRECLAIM_RESET_FLAGS	\
 	(XFS_IRECLAIMABLE | XFS_IRECLAIM | \
 	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED | XFS_NEED_INACTIVE | \
-	 XFS_INACTIVATING)
+	 XFS_INACTIVATING | XFS_IQUOTAUNCHECKED)
 
 /*
  * Flags for inode locking.
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -401,6 +401,8 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
 #define XFS_OPSTATE_WARNED_SHRINK	8
 /* Kernel has logged a warning about logged xattr updates being used. */
 #define XFS_OPSTATE_WARNED_LARP		9
+/* Mount time quotacheck is running */
+#define XFS_OPSTATE_QUOTACHECK_RUNNING	10
 
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
@@ -423,6 +425,11 @@ __XFS_IS_OPSTATE(inode32, INODE32)
 __XFS_IS_OPSTATE(readonly, READONLY)
 __XFS_IS_OPSTATE(inodegc_enabled, INODEGC_ENABLED)
 __XFS_IS_OPSTATE(blockgc_enabled, BLOCKGC_ENABLED)
+#ifdef CONFIG_XFS_QUOTA
+__XFS_IS_OPSTATE(quotacheck_running, QUOTACHECK_RUNNING)
+#else
+# define xfs_is_quotacheck_running(mp)	(false)
+#endif
 
 static inline bool
 xfs_should_warn(struct xfs_mount *mp, long nr)
@@ -440,7 +447,8 @@ xfs_should_warn(struct xfs_mount *mp, lo
 	{ (1UL << XFS_OPSTATE_BLOCKGC_ENABLED),		"blockgc" }, \
 	{ (1UL << XFS_OPSTATE_WARNED_SCRUB),		"wscrub" }, \
 	{ (1UL << XFS_OPSTATE_WARNED_SHRINK),		"wshrink" }, \
-	{ (1UL << XFS_OPSTATE_WARNED_LARP),		"wlarp" }
+	{ (1UL << XFS_OPSTATE_WARNED_LARP),		"wlarp" }, \
+	{ (1UL << XFS_OPSTATE_QUOTACHECK_RUNNING),	"quotacheck" }
 
 /*
  * Max and min values for mount-option defined I/O
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1160,6 +1160,10 @@ xfs_qm_dqusage_adjust(
 	if (error)
 		return error;
 
+	error = xfs_inode_reload_unlinked(ip);
+	if (error)
+		goto error0;
+
 	ASSERT(ip->i_delayed_blks == 0);
 
 	if (XFS_IS_REALTIME_INODE(ip)) {
@@ -1173,6 +1177,7 @@ xfs_qm_dqusage_adjust(
 	}
 
 	nblks = (xfs_qcnt_t)ip->i_nblocks - rtblks;
+	xfs_iflags_clear(ip, XFS_IQUOTAUNCHECKED);
 
 	/*
 	 * Add the (disk blocks and inode) resources occupied by this
@@ -1319,8 +1324,10 @@ xfs_qm_quotacheck(
 		flags |= XFS_PQUOTA_CHKD;
 	}
 
+	xfs_set_quotacheck_running(mp);
 	error = xfs_iwalk_threaded(mp, 0, 0, xfs_qm_dqusage_adjust, 0, true,
 			NULL);
+	xfs_clear_quotacheck_running(mp);
 
 	/*
 	 * On error, the inode walk may have partially populated the dquot


