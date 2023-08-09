Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57302174CA
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB54FC433C8;
	Wed,  9 Aug 2023 10:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578608;
	bh=ts0HoAKwS5L6WNsMqhyS/jSb8UGdVxG5F7XAFrVNKIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p2tQQTil/ZvXwQRMN4ixdqd59VoTaZZyA/adQV1AnqIc+Mi2IUYdWTvdJIcX7Ozia
	 sb+uCZACMe/PM+rS3u3joFpRT03QLSeaVijNscu+TdL7avLyPxDh9mTxnnaXptpqfV
	 addzQEWWwF5c13/r8EdfXXeRBX7wIPT8s2fEZO6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Yangtao Li <frank.li@vivo.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 120/127] f2fs: fix to set flush_merge opt and show noflush_merge
Date: Wed,  9 Aug 2023 12:41:47 +0200
Message-ID: <20230809103640.581982648@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>
References: <20230809103636.615294317@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit 967eaad1fed5f6335ea97a47d45214744dc57925 ]

Some minor modifications to flush_merge and related parameters:

  1.The FLUSH_MERGE opt is set by default only in non-ro mode.
  2.When ro and merge are set at the same time, an error is reported.
  3.Display noflush_merge mount opt.

Suggested-by: Chao Yu <chao@kernel.org>
Signed-off-by: Yangtao Li <frank.li@vivo.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 458c15dfbce6 ("f2fs: don't reset unchangable mount option in f2fs_remount()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index b6dad389fa144..36bb1c969e8bb 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1347,6 +1347,12 @@ static int parse_options(struct super_block *sb, char *options, bool is_remount)
 		return -EINVAL;
 	}
 
+	if ((f2fs_sb_has_readonly(sbi) || f2fs_readonly(sbi->sb)) &&
+		test_opt(sbi, FLUSH_MERGE)) {
+		f2fs_err(sbi, "FLUSH_MERGE not compatible with readonly mode");
+		return -EINVAL;
+	}
+
 	if (f2fs_sb_has_readonly(sbi) && !f2fs_readonly(sbi->sb)) {
 		f2fs_err(sbi, "Allow to mount readonly mode only");
 		return -EROFS;
@@ -1933,8 +1939,10 @@ static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
 		seq_puts(seq, ",inline_dentry");
 	else
 		seq_puts(seq, ",noinline_dentry");
-	if (!f2fs_readonly(sbi->sb) && test_opt(sbi, FLUSH_MERGE))
+	if (test_opt(sbi, FLUSH_MERGE))
 		seq_puts(seq, ",flush_merge");
+	else
+		seq_puts(seq, ",noflush_merge");
 	if (test_opt(sbi, NOBARRIER))
 		seq_puts(seq, ",nobarrier");
 	if (test_opt(sbi, FASTBOOT))
@@ -2063,7 +2071,8 @@ static void default_options(struct f2fs_sb_info *sbi)
 	set_opt(sbi, MERGE_CHECKPOINT);
 	F2FS_OPTION(sbi).unusable_cap = 0;
 	sbi->sb->s_flags |= SB_LAZYTIME;
-	set_opt(sbi, FLUSH_MERGE);
+	if (!f2fs_sb_has_readonly(sbi) && !f2fs_readonly(sbi->sb))
+		set_opt(sbi, FLUSH_MERGE);
 	if (f2fs_hw_support_discard(sbi) || f2fs_hw_should_discard(sbi))
 		set_opt(sbi, DISCARD);
 	if (f2fs_sb_has_blkzoned(sbi)) {
-- 
2.40.1



