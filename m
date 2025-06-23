Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9302E222599;
	Mon, 23 Jun 2025 22:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717121; cv=none; b=fOnve6K1eMxBmWdMu9Q50vOtQb2Fo07nU370L6v/4ihlCj74uZnDTnFmHaxRWFDVuvat5QVbu31ApuOd/54iMv5Y2yeUV1CPbjMG/Gkji1gHX1D+/1gJlOEqyKAKUxa0M8CiBfyLauIgaft1dVXs8Yf0cYsRYVfGIPVsvqXfscY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717121; c=relaxed/simple;
	bh=G9dtbWEbSAkSB2hFrz456tRDksHhdfZl6iDoVK8HkyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyB3B9so54wh5vxFoUHKIzVwv4xWN/PCtrQE69fOke5atIPzTTHT7gHNZbmyaMCGxlgtIJeURGt3R1fttF2VTO7zbXV6/7ytKP9utPlcCuzSETfDB2rdlU/TKwLf7Ri41CQG6jPTxlUuwrpCymzWwgogpPNxltONXSNPeRuUcFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GkQdlhm+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GkQdlhm+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B374C4CEEA;
	Mon, 23 Jun 2025 22:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717121;
	bh=G9dtbWEbSAkSB2hFrz456tRDksHhdfZl6iDoVK8HkyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GkQdlhm+yJsfbITRGMDPkXAKbBdR25QtSheYXl437c04sKYZ4kWUsW9o7C0UGGu15
	 4XDcelGM6r85uCfq5FfxWA5GdTLW8njhn2OTDg+quR/IKbNkJNaz1hZFJJaJpPyQPF
	 sDNqfOgiVn3SDZ23Y462wG5E+5uNHw1Qh4iN5uKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.15 404/411] ext4: make abort mount option handling standard
Date: Mon, 23 Jun 2025 15:09:08 +0200
Message-ID: <20250623130643.851641431@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 22b8d707b07e6e06f50fe1d9ca8756e1f894eb0d upstream.

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
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/super.c |    6 ++----
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1255,6 +1255,7 @@ struct ext4_inode_info {
 #define EXT4_MOUNT2_MB_OPTIMIZE_SCAN	0x00000080 /* Optimize group
 						    * scanning in mballoc
 						    */
+#define EXT4_MOUNT2_ABORT		0x00000100 /* Abort filesystem */
 
 #define clear_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt &= \
 						~EXT4_MOUNT_##opt
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2023,6 +2023,7 @@ static const struct mount_opts {
 	 MOPT_SET | MOPT_2 | MOPT_EXT4_ONLY},
 	{Opt_fc_debug_max_replay, 0, MOPT_GTE0},
 #endif
+	{Opt_abort, EXT4_MOUNT2_ABORT, MOPT_SET | MOPT_2},
 	{Opt_err, 0, 0}
 };
 
@@ -2143,9 +2144,6 @@ static int handle_mount_opt(struct super
 	case Opt_removed:
 		ext4_msg(sb, KERN_WARNING, "Ignoring removed %s option", opt);
 		return 1;
-	case Opt_abort:
-		ext4_set_mount_flag(sb, EXT4_MF_FS_ABORTED);
-		return 1;
 	case Opt_i_version:
 		sb->s_flags |= SB_I_VERSION;
 		return 1;
@@ -5851,7 +5849,7 @@ static int ext4_remount(struct super_blo
 		goto restore_opts;
 	}
 
-	if (ext4_test_mount_flag(sb, EXT4_MF_FS_ABORTED))
+	if (test_opt2(sb, ABORT))
 		ext4_abort(sb, ESHUTDOWN, "Abort forced by user");
 
 	sb->s_flags = (sb->s_flags & ~SB_POSIXACL) |


