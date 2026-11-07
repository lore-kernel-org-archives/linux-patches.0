Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063388;
	b=YQFW4A9+kdEjyjzNSwR+Y8iGoVc/vFH+v2EK5wibVnAKks89E+DBefMbwZKvloGzggiw
	 9X9UVrtNvamjFKOyBrVuviwKDFaPvvz2S4m3YsFg+Ziep6s/e8fWr0EK/gA1lRzDoc0Jd
	 MJ+564sZ5/SI9qtPSCRuNOvKCp1hMiisIr0F18vU6InZL1s/LuQzhFJ41aYUBkfnXrQIS
	 QSFbKP+7Tke7qN/Rmgmh1nYaf8KF+wFh4Z6pvlkqtDmVopTDM9WrA9MYkaoETTCCJh8IG
	 dRwuDxUkALNxvojpAd8eBUN/0OBph4tw3dG/NwG+MWmpqgTtPo/dG1MFl6ZRjPsUsqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NZXob3qba8FoozVmb3k/nzquyzd1CQgGikP5pQAzqG4=;
	b=jpdU+D+jjTodJajwqTXKo3Po5CCdjaQQp1cSuSznivQzH8sBNDQbJW0FdI0KBiHlZJkW
	 /efx/tskU4H5+ppUX4gkFBGbgqNCkcb/u+ZOrBvnEQ6oIv73T5OXanaKcWLsjQhEJQL36
	 yPOx4sHbi+FujZjr0dwZJ/UAQ7pt4sO5rxMXdBYwZa0EAF4aYD6HU5Zl7MNu9iCERLPMb
	 WnwmXA/H8VgsJJzec81cw7lN9jFlpSaMqyY3TlVuxVseCrUZFC6S+xLbqL1xBB5RQvhuQ
	 DWiudt2nrLpV3TSB2CEMwC2oEM376k5TZE9FPPFszGCejpH53Bk8tXTIiBTid4NTpEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tLo233vu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17D4606D810;
	Sat,  7 Nov 2026 14:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tLo233vu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8411F0089F;
	Sat,  7 Nov 2026 14:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063387;
	bh=NZXob3qba8FoozVmb3k/nzquyzd1CQgGikP5pQAzqG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tLo233vuxeLwgCuwERpxjT2OUeOrNYaLCiRykSKXKl4GMmg0V1GjekexHvcoqsTLw
	 rhgFAZoetCm5gQpF1u7Jj9etLL4KYf1F8+eaSn2JxwTR3t/6DUKL/BRXBeRStBOIzW
	 XXIaBbTins8rvS3iJY5MHezuy02WAaVYrX1b/iSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 522/869] f2fs: convert inline quota files when turning quota on
Date: Sat,  7 Nov 2026 08:53:24 -0500
Message-ID: <20261107134911.210018925@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit a85e09bd6cc80059b9e0ef5cd1467719aa3129a8 ]

With a block size larger than 4KB, the inline data area is large enough
to hold a freshly created quota file (quotacheck writes 6KB), so
aquota.user/aquota.group stay inline after quotaon. f2fs does not
expect quota files to be inline, and this causes two problems:

1. Quota file corruption. f2fs_write_single_data_page() sends quota
   inodes straight to f2fs_do_write_data_page(), which sees NULL_ADDR
   for index 0, treats the folio as truncated and drops it. Updates to
   the quota file are lost once the folio is reclaimed, so the quota
   tree reads stale data: chown/chgrp fail with EIO and quota entries
   of users disappear. For example, the kernel log shows:

     find_free_dqentry: Data block full but it shouldn't
     qtree_write_dquot: Error -5 occurred while creating quota

2. Deadlock. Writing a quota file past MAX_INLINE_DATA converts it from
   f2fs_write_begin() under f2fs_lock_op(). dquot_transfer() is called
   from f2fs_setattr() with f2fs_lock_op() already held, so chown/chgrp
   take cp_rwsem for read twice and hang, together with the checkpoint
   and every other writer, once a checkpoint waits for cp_rwsem in
   between (seen with generic/232).

Quota files only grow and there are at most MAXQUOTAS of them, so there
is no point in keeping them inline. Convert them in f2fs_quota_on() and
after dquot_quota_on_mount(), which keeps every block size on the same
path as 4KB blocks, where quota files never fit inline. Quota sysfiles
are created by mkfs with real blocks and are not affected.

Cc: stable@kernel.org
Fixes: d7e9a9037de2 ("f2fs: Support Block Size == Page Size")
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 74b12c1ef8211..146bd977bb591 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3171,15 +3171,42 @@ static qsize_t *f2fs_get_reserved_space(struct inode *inode)
 	return &F2FS_I(inode)->i_reserved_quota;
 }
 
+/*
+ * Quota files only grow and there are at most MAXQUOTAS of them, so there is
+ * no point in keeping them inline. Writeback of quota files does not handle
+ * inline data and would drop what was written to them.
+ */
+static int f2fs_quota_convert_inline(struct inode *inode)
+{
+	int err;
+
+	if (!f2fs_has_inline_data(inode))
+		return 0;
+
+	inode_lock(inode);
+	err = f2fs_convert_inline_inode(inode);
+	inode_unlock(inode);
+	return err;
+}
+
 static int f2fs_quota_on_mount(struct f2fs_sb_info *sbi, int type)
 {
+	int err;
+
 	if (is_set_ckpt_flags(sbi, CP_QUOTA_NEED_FSCK_FLAG)) {
 		f2fs_err(sbi, "quota sysfile may be corrupted, skip loading it");
 		return 0;
 	}
 
-	return dquot_quota_on_mount(sbi->sb, F2FS_OPTION(sbi).s_qf_names[type],
+	err = dquot_quota_on_mount(sbi->sb, F2FS_OPTION(sbi).s_qf_names[type],
 					F2FS_OPTION(sbi).s_jquota_fmt, type);
+	if (err)
+		return err;
+
+	err = f2fs_quota_convert_inline(sb_dqopt(sbi->sb)->files[type]);
+	if (err)
+		dquot_quota_off(sbi->sb, type);
+	return err;
 }
 
 int f2fs_enable_quota_files(struct f2fs_sb_info *sbi, bool rdonly)
@@ -3391,6 +3418,10 @@ static int f2fs_quota_on(struct super_block *sb, int type, int format_id,
 
 	inode = d_inode(path->dentry);
 
+	err = f2fs_quota_convert_inline(inode);
+	if (err)
+		goto out;
+
 	err = filemap_fdatawrite(inode->i_mapping);
 	if (err)
 		goto out;
-- 
2.53.0



