Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A2DD2E5
	for <patches@lists.linux.dev>; Sat, 26 Aug 2023 15:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089EFC433C7;
	Sat, 26 Aug 2023 15:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693064889;
	bh=INjhEoLEmHwhO97Z3GhZntWFeey8jRxB32eTTmn/yQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tttfaDm+CPxRWk2V8sfWsN/Ya8ZObvTk10l7XWkYrNthjO51TAbw9FvoYP8FEZyg7
	 gRxnq85sBrL6SqHxixCZjlSeU3Ius9vtYH2TwG1rOi/Jb0VGe5f05OCPQbrxbKeJaJ
	 WYuCybQCV19KShiTzeLgT1nGQseJo6JIFU0GyqPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2/4] Revert "f2fs: dont reset unchangable mount option in f2fs_remount()"
Date: Sat, 26 Aug 2023 17:47:58 +0200
Message-ID: <20230826154625.567955938@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230826154625.450325166@linuxfoundation.org>
References: <20230826154625.450325166@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit e2fb24ce37caeaecff08af4e9967c8462624312b which is
commit 458c15dfbce62c35fefd9ca637b20a051309c9f1 upstream.

Something is currently broken in the f2fs code, Guenter has reported
boot problems with it for a few releases now, so revert the most recent
f2fs changes in the hope to get this back to a working filesystem.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/b392e1a8-b987-4993-bd45-035db9415a6e@roeck-us.net
Cc: Chao Yu <chao@kernel.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/super.c |   30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2040,22 +2040,9 @@ static int f2fs_show_options(struct seq_
 	return 0;
 }
 
-static void default_options(struct f2fs_sb_info *sbi, bool remount)
+static void default_options(struct f2fs_sb_info *sbi)
 {
 	/* init some FS parameters */
-	if (!remount) {
-		set_opt(sbi, READ_EXTENT_CACHE);
-		clear_opt(sbi, DISABLE_CHECKPOINT);
-
-		if (f2fs_hw_support_discard(sbi) || f2fs_hw_should_discard(sbi))
-			set_opt(sbi, DISCARD);
-
-		if (f2fs_sb_has_blkzoned(sbi))
-			F2FS_OPTION(sbi).discard_unit = DISCARD_UNIT_SECTION;
-		else
-			F2FS_OPTION(sbi).discard_unit = DISCARD_UNIT_BLOCK;
-	}
-
 	if (f2fs_sb_has_readonly(sbi))
 		F2FS_OPTION(sbi).active_logs = NR_CURSEG_RO_TYPE;
 	else
@@ -2078,16 +2065,23 @@ static void default_options(struct f2fs_
 	set_opt(sbi, INLINE_XATTR);
 	set_opt(sbi, INLINE_DATA);
 	set_opt(sbi, INLINE_DENTRY);
+	set_opt(sbi, READ_EXTENT_CACHE);
 	set_opt(sbi, NOHEAP);
+	clear_opt(sbi, DISABLE_CHECKPOINT);
 	set_opt(sbi, MERGE_CHECKPOINT);
 	F2FS_OPTION(sbi).unusable_cap = 0;
 	sbi->sb->s_flags |= SB_LAZYTIME;
 	if (!f2fs_sb_has_readonly(sbi) && !f2fs_readonly(sbi->sb))
 		set_opt(sbi, FLUSH_MERGE);
-	if (f2fs_sb_has_blkzoned(sbi))
+	if (f2fs_hw_support_discard(sbi) || f2fs_hw_should_discard(sbi))
+		set_opt(sbi, DISCARD);
+	if (f2fs_sb_has_blkzoned(sbi)) {
 		F2FS_OPTION(sbi).fs_mode = FS_MODE_LFS;
-	else
+		F2FS_OPTION(sbi).discard_unit = DISCARD_UNIT_SECTION;
+	} else {
 		F2FS_OPTION(sbi).fs_mode = FS_MODE_ADAPTIVE;
+		F2FS_OPTION(sbi).discard_unit = DISCARD_UNIT_BLOCK;
+	}
 
 #ifdef CONFIG_F2FS_FS_XATTR
 	set_opt(sbi, XATTR_USER);
@@ -2259,7 +2253,7 @@ static int f2fs_remount(struct super_blo
 			clear_sbi_flag(sbi, SBI_NEED_SB_WRITE);
 	}
 
-	default_options(sbi, true);
+	default_options(sbi);
 
 	/* parse mount options */
 	err = parse_options(sb, data, true);
@@ -4156,7 +4150,7 @@ try_onemore:
 		sbi->s_chksum_seed = f2fs_chksum(sbi, ~0, raw_super->uuid,
 						sizeof(raw_super->uuid));
 
-	default_options(sbi, false);
+	default_options(sbi);
 	/* parse mount options */
 	options = kstrdup((const char *)data, GFP_KERNEL);
 	if (data && !options) {


