Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7507E13792B;
	Thu, 12 Dec 2024 15:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018849; cv=none; b=IU+bkXmXx5gl96E9SRH/fmsZbe8RfYY2/vFfBrPmoBTiL2lU32B8QGgzBWACV6Aljf4RJjhwGNe0qOo4uRS3FhXut02Ckl9IC9IEapQi7ZdY0+O+goqFtRTIZF75mkODSyM5a/TBVmWQYPL7c5wD9INK36N94A+jgULmVCVoISA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018849; c=relaxed/simple;
	bh=S0LnPS29yS/LMUsuxastFUbz6XaC49zUclR3QGcxgMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NecjWOojRbh67Ab8WVWah3NWFYdeH5MmmlglhskQ+YDaMjZqzVe885wkmZbHkUCTyAEL88q5zkSiJ6EmVLo7aUu1X4PSMafKn7KoDmYgoX94sDGEI8bBZnVmTeC5KsiFoWtezJapzpwQcBKFVNV+4KsDAMP6BZVt2CpysRTanS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frC2CmVo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frC2CmVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD387C4CECE;
	Thu, 12 Dec 2024 15:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018849;
	bh=S0LnPS29yS/LMUsuxastFUbz6XaC49zUclR3QGcxgMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=frC2CmVoKcTLBzGdfuUTEQmaVe/ERbo4QwN2ctUCeUmye0UoDvcCzUJQyHMIVTOQO
	 jTK1pGDg256Giigg+Sv+0uLsjp/my6YiaDhoTboXboYTOzaIyK8CkBJJVsLaccUJgz
	 mLpghAy3uDxdHFHTQDDB2q6oYGDpugVcp/4xP6sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/772] ext4: make abort mount option handling standard
Date: Thu, 12 Dec 2024 15:49:55 +0100
Message-ID: <20241212144352.004707280@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit 22b8d707b07e6e06f50fe1d9ca8756e1f894eb0d ]

'abort' mount option is the only mount option that has special handling
and sets a bit in sbi->s_mount_flags. There is not strong reason for
that so just simplify the code and make 'abort' set a bit in
sbi->s_mount_opt2 as any other mount option. This simplifies the code
and will allow us to drop EXT4_MF_FS_ABORTED completely in the following
patch.

Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230616165109.21695-4-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 76486b104168 ("ext4: avoid remount errors with 'abort' mount option")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h  |  1 +
 fs/ext4/super.c | 16 ++--------------
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 72abb8d6caf75..faa889882e552 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1269,6 +1269,7 @@ struct ext4_inode_info {
 #define EXT4_MOUNT2_MB_OPTIMIZE_SCAN	0x00000080 /* Optimize group
 						    * scanning in mballoc
 						    */
+#define EXT4_MOUNT2_ABORT		0x00000100 /* Abort filesystem */
 
 #define clear_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt &= \
 						~EXT4_MOUNT_##opt
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 987d49e18dbe8..6df7735744ac3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1833,6 +1833,7 @@ static const struct mount_opts {
 	{Opt_fc_debug_force, EXT4_MOUNT2_JOURNAL_FAST_COMMIT,
 	 MOPT_SET | MOPT_2 | MOPT_EXT4_ONLY},
 #endif
+	{Opt_abort, EXT4_MOUNT2_ABORT, MOPT_SET | MOPT_2},
 	{Opt_err, 0, 0}
 };
 
@@ -1901,8 +1902,6 @@ struct ext4_fs_context {
 	unsigned int	mask_s_mount_opt;
 	unsigned int	vals_s_mount_opt2;
 	unsigned int	mask_s_mount_opt2;
-	unsigned long	vals_s_mount_flags;
-	unsigned long	mask_s_mount_flags;
 	unsigned int	opt_flags;	/* MOPT flags */
 	unsigned int	spec;
 	u32		s_max_batch_time;
@@ -2053,12 +2052,6 @@ EXT4_SET_CTX(mount_opt2);
 EXT4_CLEAR_CTX(mount_opt2);
 EXT4_TEST_CTX(mount_opt2);
 
-static inline void ctx_set_mount_flag(struct ext4_fs_context *ctx, int bit)
-{
-	set_bit(bit, &ctx->mask_s_mount_flags);
-	set_bit(bit, &ctx->vals_s_mount_flags);
-}
-
 static int ext4_parse_param(struct fs_context *fc, struct fs_parameter *param)
 {
 	struct ext4_fs_context *ctx = fc->fs_private;
@@ -2122,9 +2115,6 @@ static int ext4_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		ext4_msg(NULL, KERN_WARNING, "Ignoring removed %s option",
 			 param->key);
 		return 0;
-	case Opt_abort:
-		ctx_set_mount_flag(ctx, EXT4_MF_FS_ABORTED);
-		return 0;
 	case Opt_inlinecrypt:
 #ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
 		ctx_set_flags(ctx, SB_INLINECRYPT);
@@ -2789,8 +2779,6 @@ static void ext4_apply_options(struct fs_context *fc, struct super_block *sb)
 	sbi->s_mount_opt |= ctx->vals_s_mount_opt;
 	sbi->s_mount_opt2 &= ~ctx->mask_s_mount_opt2;
 	sbi->s_mount_opt2 |= ctx->vals_s_mount_opt2;
-	sbi->s_mount_flags &= ~ctx->mask_s_mount_flags;
-	sbi->s_mount_flags |= ctx->vals_s_mount_flags;
 	sb->s_flags &= ~ctx->mask_s_flags;
 	sb->s_flags |= ctx->vals_s_flags;
 
@@ -6445,7 +6433,7 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
 		goto restore_opts;
 	}
 
-	if (ext4_test_mount_flag(sb, EXT4_MF_FS_ABORTED))
+	if (test_opt2(sb, ABORT))
 		ext4_abort(sb, ESHUTDOWN, "Abort forced by user");
 
 	sb->s_flags = (sb->s_flags & ~SB_POSIXACL) |
-- 
2.43.0



