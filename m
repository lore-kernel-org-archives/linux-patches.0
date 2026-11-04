Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828945;
	b=434einTWTS6o4TV4hPHQLIEFRyV2GWUdqhkIumMjSwE+2Oed/IViO2wuhYDZHYQGsSFc
	 ssmlb7/ph7fqC6gjR+0wjUkDtmp8khVeq+qtHoGWH4JmICj6BWNyD6hDiHUK+vjXSqdgn
	 g+T2dlgWXVsbatyYlLu9GUdWCSG5hrsfeDYpFCMwp//caoWePHrZDn4szah+xEdZ02V63
	 FUnpjBl+voQ+TWenVVQ7zNFH9ZbGykuuNE1nPzgijcErycstBskPkZExSHX3S321x1B/S
	 8FN+RLOf9Ld0BMRMt0URM+8nBOcc8MWmgdYsLY1r34fgXOV182bDTO7edZFElEC8k4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hpTwHMJwbuc5zF4jc2NsuQGmeARRdCcdF6izqHsS1+8=;
	b=mdFslG2jFyVcofxQzidg6LXT/PUI4l/fQ1KIq8Sk5Ec6pAqC+SiBd4HEiz4bY3lBoB8v
	 2RfMjl1133wtSEIE9LyilCEHyGtw+ACgDQfosjDxpDtLNUT6+5tooPuByusNxuO1qESea
	 FG1hyCsJ5h3mrnifoZfTVYTys6xcp37GJFZgYmdGENqqYozKJsvFraF1AGcaXu1AMNK1D
	 52oSPkVUzAtofeCQYaqh/aV6yhFAAvfHMXo0nMnf8XA3pkieFXF4LQ2TOffqCqftMuPJt
	 twUFK9pjbz9Cxlc+W6bJguaQOUQnW0SeKOCAhwEhdj2j2Voiz+g1L1rPg577OyG1i7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SDH1fP2M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBDF607E49A;
	Wed,  4 Nov 2026 21:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SDH1fP2M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC871F00919;
	Wed,  4 Nov 2026 21:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828944;
	bh=hpTwHMJwbuc5zF4jc2NsuQGmeARRdCcdF6izqHsS1+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SDH1fP2MaVo/S/tH7bvkv9Y2VO2BK2UaRfgDl4wPX6mwBm9MzkfTu1teIMovOFZfL
	 G+HduPE8mPBTLM5cX5xC5xWB8u9MPigjODzvoKZQ1p/0Y5xC4vXinSTeB7ZbvWk84N
	 MEtbAefLQmROz66qTq3JvuULLqVjLfKLhygGJgLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 342/547] xfs: update quota flags on secondary supers when metadir enabled
Date: Wed,  4 Nov 2026 16:08:46 -0500
Message-ID: <20261104211047.961497508@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 9d9ea6e6cbc4cb1a36fb79f873d97e1ac2fe1a64 upstream.

xfs/085 exposes an interesting bug when metadir is enabled, quotas are
enabled via mount option, and the primary superblock crc fails
validation:

 Phase 1 - find and verify superblock...
 bad primary superblock - bad CRC in superblock !!!

 attempting to find secondary superblock...
 .found candidate secondary superblock...
 verified secondary superblock...
 quota accounting and enforcement flags lost

<snip>

 Phase 3 - for each AG...
         - scan and clear agi unlinked lists...
         - process known inodes and perform inode discovery...
         - agno = 0
         - agno = 1
         - agno = 2
 unexpected regular file inode 16908418 with metadata flag will zap
 cleared inode 16908418
 unexpected regular file inode 16908419 with metadata flag will zap
 cleared inode 16908419
 unexpected regular file inode 16908420 with metadata flag will zap
 cleared inode 16908420
         - agno = 3
         - process newly discovered inodes...

Quota files have been created, but xfs_repair thinks that quotas aren't
enabled and trashes the quota files.  Looking at the filesystem reveals
that the quota accounting flags were indeed persisted to the primary
superblock but not the secondary:

 # xfs_db -c 'sb 0' -c 'print qflags' -c 'sb 1' -c 'print qflags' /dev/sdf
 Metadata corruption detected at 0x561c68436080, inode 0x81 dinode
 xfs_db: Failed to load metadir root directory, error 117
 Metadata corruption detected at 0x561c683f7c80, xfs_agf block 0x1/0x200
 xfs_db: cannot init perag data (117). Continuing anyway.
 Metadata CRC error detected at 0x561c6844d1b5, xfs_sb block 0x0/0x200
 qflags = 0x7cf
 qflags = 0

On a metadir filesystem, quota state is supposed to persist across
mount cycles if the sysadmin doesn't provide any quota mount options.
Therefore, any time we update the quota flags on a metadir filesystem,
we should write the same change to the secondary supers so that
xfs_repair will find the quota data if it ever has to restore from a
secondary.

Cc: stable@vger.kernel.org # v6.13
Fixes: d5d9dd5b3026a8 ("xfs: persist quota flags with metadir")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_mount.c |    9 ++++++++-
 fs/xfs/xfs_qm.c    |   36 +++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_quota.h |    9 +++++++++
 3 files changed, 52 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -446,6 +446,8 @@ int
 xfs_mount_reset_sbqflags(
 	struct xfs_mount	*mp)
 {
+	int			error;
+
 	mp->m_qflags = 0;
 
 	/* It is OK to look at sb_qflags in the mount path without m_sb_lock. */
@@ -458,7 +460,12 @@ xfs_mount_reset_sbqflags(
 	if (!xfs_fs_writable(mp, SB_FREEZE_WRITE))
 		return 0;
 
-	return xfs_sync_sb(mp, false);
+	error = xfs_sync_sb(mp, false);
+	if (error)
+		return error;
+
+	xfs_qm_update_secondary_sb(mp);
+	return 0;
 }
 
 static const char *const xfs_free_pool_name[] = {
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -694,6 +694,32 @@ xfs_qm_create_metadir_qinos(
 }
 
 /*
+ * For metadir filesystems, quota flag state persists across mounts, so update
+ * secondary superblocks in case xfs_repair ever has to recover the primary
+ * from a secondary.  growfs also updates backup supers so lock against that.
+ * Note that the secondary backups are opportunistic, so we log but do not
+ * return write errors.
+ */
+void
+__xfs_qm_update_secondary_sb(
+	struct xfs_mount	*mp,
+	const char		*func)
+{
+	int			error;
+
+	if (!xfs_has_metadir(mp))
+		return;
+
+	mutex_lock(&mp->m_growlock);
+	error = xfs_update_secondary_sbs(mp);
+	mutex_unlock(&mp->m_growlock);
+
+	if (error)
+		xfs_alert(mp, "%s: Secondary super update failed, err=%d!",
+				func, error);
+}
+
+/*
  * Add QUOTABIT to sb_versionnum and initialize qflags in preparation for
  * creating quota files on a metadir filesystem.
  */
@@ -718,7 +744,12 @@ xfs_qm_prep_metadir_sb(
 	spin_unlock(&mp->m_sb_lock);
 	xfs_log_sb(tp);
 
-	return xfs_trans_commit(tp);
+	error = xfs_trans_commit(tp);
+	if (error)
+		return error;
+
+	xfs_qm_update_secondary_sb(mp);
+	return 0;
 }
 
 /*
@@ -1683,6 +1714,9 @@ xfs_qm_mount_quotas(
 			ASSERT(!(XFS_IS_QUOTA_ON(mp)));
 			xfs_alert(mp, "%s: Superblock update failed!",
 				__func__);
+		} else {
+			/* Primary update succeeded, try to write secondary */
+			xfs_qm_update_secondary_sb(mp);
 		}
 	}
 
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -151,6 +151,8 @@ void xfs_dqtrx_hook_setup(struct xfs_dqt
 		xfs_trans_mod_dquot((tp), (dqp), (field), (delta))
 # endif /* CONFIG_XFS_LIVE_HOOKS */
 
+void __xfs_qm_update_secondary_sb(struct xfs_mount *mp,
+		const char *func);
 #else
 static inline int
 xfs_qm_vop_dqalloc(struct xfs_inode *ip, kuid_t kuid, kgid_t kgid,
@@ -216,8 +218,15 @@ static inline int xfs_quota_reserve_blkr
 #  define xfs_dqtrx_hook_disable()		((void)0)
 # endif /* CONFIG_XFS_LIVE_HOOKS */
 
+static inline void __xfs_qm_update_secondary_sb(struct xfs_mount *mp,
+		const char *func)
+{
+}
 #endif /* CONFIG_XFS_QUOTA */
 
+#define xfs_qm_update_secondary_sb(mp) \
+	__xfs_qm_update_secondary_sb((mp), __func__)
+
 static inline void
 xfs_quota_unreserve_blkres(struct xfs_inode *ip, uint64_t blocks)
 {


