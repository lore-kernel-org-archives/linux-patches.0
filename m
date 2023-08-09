Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD74174CA
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A31C433C7;
	Wed,  9 Aug 2023 10:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578610;
	bh=IbMvQDssz+gfA3rTNCfP6ZkB5lDDpkCYqkm6ACfUTU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QMFPkOdptgV1bsJk0IHjIseHDqrPmEg3tbZ3OxPK9Dr0m3FHQSRfauuoyFmOi/hmY
	 BmDjW/HfW3zWd9oFax1ul6cekOsg2uDepfKQ+EvAeAraiBVt4EheOVbLmU9bW7Ck2d
	 V8ScYSYPKGnRtYMNbK+5fLHQCZnCbSDGj/5LUeQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d015b6c2fbb5c383bf08@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/127] f2fs: dont reset unchangable mount option in f2fs_remount()
Date: Wed,  9 Aug 2023 12:41:48 +0200
Message-ID: <20230809103640.612110509@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 458c15dfbce62c35fefd9ca637b20a051309c9f1 ]

syzbot reports a bug as below:

general protection fault, probably for non-canonical address 0xdffffc0000000009: 0000 [#1] PREEMPT SMP KASAN
RIP: 0010:__lock_acquire+0x69/0x2000 kernel/locking/lockdep.c:4942
Call Trace:
 lock_acquire+0x1e3/0x520 kernel/locking/lockdep.c:5691
 __raw_write_lock include/linux/rwlock_api_smp.h:209 [inline]
 _raw_write_lock+0x2e/0x40 kernel/locking/spinlock.c:300
 __drop_extent_tree+0x3ac/0x660 fs/f2fs/extent_cache.c:1100
 f2fs_drop_extent_tree+0x17/0x30 fs/f2fs/extent_cache.c:1116
 f2fs_insert_range+0x2d5/0x3c0 fs/f2fs/file.c:1664
 f2fs_fallocate+0x4e4/0x6d0 fs/f2fs/file.c:1838
 vfs_fallocate+0x54b/0x6b0 fs/open.c:324
 ksys_fallocate fs/open.c:347 [inline]
 __do_sys_fallocate fs/open.c:355 [inline]
 __se_sys_fallocate fs/open.c:353 [inline]
 __x64_sys_fallocate+0xbd/0x100 fs/open.c:353
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The root cause is race condition as below:
- since it tries to remount rw filesystem, so that do_remount won't
call sb_prepare_remount_readonly to block fallocate, there may be race
condition in between remount and fallocate.
- in f2fs_remount(), default_options() will reset mount option to default
one, and then update it based on result of parse_options(), so there is
a hole which race condition can happen.

Thread A			Thread B
- f2fs_fill_super
 - parse_options
  - clear_opt(READ_EXTENT_CACHE)

- f2fs_remount
 - default_options
  - set_opt(READ_EXTENT_CACHE)
				- f2fs_fallocate
				 - f2fs_insert_range
				  - f2fs_drop_extent_tree
				   - __drop_extent_tree
				    - __may_extent_tree
				     - test_opt(READ_EXTENT_CACHE) return true
				    - write_lock(&et->lock) access NULL pointer
 - parse_options
  - clear_opt(READ_EXTENT_CACHE)

Cc: <stable@vger.kernel.org>
Reported-by: syzbot+d015b6c2fbb5c383bf08@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-f2fs-devel/20230522124203.3838360-1-chao@kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 36bb1c969e8bb..ff47aad636e5b 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2040,9 +2040,22 @@ static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
 	return 0;
 }
 
-static void default_options(struct f2fs_sb_info *sbi)
+static void default_options(struct f2fs_sb_info *sbi, bool remount)
 {
 	/* init some FS parameters */
+	if (!remount) {
+		set_opt(sbi, READ_EXTENT_CACHE);
+		clear_opt(sbi, DISABLE_CHECKPOINT);
+
+		if (f2fs_hw_support_discard(sbi) || f2fs_hw_should_discard(sbi))
+			set_opt(sbi, DISCARD);
+
+		if (f2fs_sb_has_blkzoned(sbi))
+			F2FS_OPTION(sbi).discard_unit = DISCARD_UNIT_SECTION;
+		else
+			F2FS_OPTION(sbi).discard_unit = DISCARD_UNIT_BLOCK;
+	}
+
 	if (f2fs_sb_has_readonly(sbi))
 		F2FS_OPTION(sbi).active_logs = NR_CURSEG_RO_TYPE;
 	else
@@ -2065,23 +2078,16 @@ static void default_options(struct f2fs_sb_info *sbi)
 	set_opt(sbi, INLINE_XATTR);
 	set_opt(sbi, INLINE_DATA);
 	set_opt(sbi, INLINE_DENTRY);
-	set_opt(sbi, READ_EXTENT_CACHE);
 	set_opt(sbi, NOHEAP);
-	clear_opt(sbi, DISABLE_CHECKPOINT);
 	set_opt(sbi, MERGE_CHECKPOINT);
 	F2FS_OPTION(sbi).unusable_cap = 0;
 	sbi->sb->s_flags |= SB_LAZYTIME;
 	if (!f2fs_sb_has_readonly(sbi) && !f2fs_readonly(sbi->sb))
 		set_opt(sbi, FLUSH_MERGE);
-	if (f2fs_hw_support_discard(sbi) || f2fs_hw_should_discard(sbi))
-		set_opt(sbi, DISCARD);
-	if (f2fs_sb_has_blkzoned(sbi)) {
+	if (f2fs_sb_has_blkzoned(sbi))
 		F2FS_OPTION(sbi).fs_mode = FS_MODE_LFS;
-		F2FS_OPTION(sbi).discard_unit = DISCARD_UNIT_SECTION;
-	} else {
+	else
 		F2FS_OPTION(sbi).fs_mode = FS_MODE_ADAPTIVE;
-		F2FS_OPTION(sbi).discard_unit = DISCARD_UNIT_BLOCK;
-	}
 
 #ifdef CONFIG_F2FS_FS_XATTR
 	set_opt(sbi, XATTR_USER);
@@ -2253,7 +2259,7 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 			clear_sbi_flag(sbi, SBI_NEED_SB_WRITE);
 	}
 
-	default_options(sbi);
+	default_options(sbi, true);
 
 	/* parse mount options */
 	err = parse_options(sb, data, true);
@@ -4150,7 +4156,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 		sbi->s_chksum_seed = f2fs_chksum(sbi, ~0, raw_super->uuid,
 						sizeof(raw_super->uuid));
 
-	default_options(sbi);
+	default_options(sbi, false);
 	/* parse mount options */
 	options = kstrdup((const char *)data, GFP_KERNEL);
 	if (data && !options) {
-- 
2.40.1



