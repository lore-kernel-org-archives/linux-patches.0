Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DDC1FB40
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D914C433CA;
	Fri, 21 Jul 2023 16:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956038;
	bh=3W1sTUrVi+HO0F5+oNYG2mM3TsVaxJzKUiVKSm+m96s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/dGfH42V0noVouaM/lhT6wNg0XRdAvQN/xvwGzaOmqBWzLv/OOTIJgrMDB24+eIb
	 44KmVh9A37SrwLnAF9pHX9XlXz54S+NwgBkznICqNv+Iui2dfGcQiPycyjCm1NCTDn
	 Ee33f0XPfR7BfZSv+B5AzkyPp4oB24xjREJ9wdck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d015b6c2fbb5c383bf08@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.4 112/292] f2fs: dont reset unchangable mount option in f2fs_remount()
Date: Fri, 21 Jul 2023 18:03:41 +0200
Message-ID: <20230721160533.636826195@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
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

commit 458c15dfbce62c35fefd9ca637b20a051309c9f1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/super.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2086,9 +2086,22 @@ static int f2fs_show_options(struct seq_
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
@@ -2118,23 +2131,16 @@ static void default_options(struct f2fs_
 	set_opt(sbi, INLINE_XATTR);
 	set_opt(sbi, INLINE_DATA);
 	set_opt(sbi, INLINE_DENTRY);
-	set_opt(sbi, READ_EXTENT_CACHE);
 	set_opt(sbi, NOHEAP);
-	clear_opt(sbi, DISABLE_CHECKPOINT);
 	set_opt(sbi, MERGE_CHECKPOINT);
 	F2FS_OPTION(sbi).unusable_cap = 0;
 	sbi->sb->s_flags |= SB_LAZYTIME;
 	if (!f2fs_is_readonly(sbi))
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
@@ -2306,7 +2312,7 @@ static int f2fs_remount(struct super_blo
 			clear_sbi_flag(sbi, SBI_NEED_SB_WRITE);
 	}
 
-	default_options(sbi);
+	default_options(sbi, true);
 
 	/* parse mount options */
 	err = parse_options(sb, data, true);
@@ -4357,7 +4363,7 @@ try_onemore:
 		sbi->s_chksum_seed = f2fs_chksum(sbi, ~0, raw_super->uuid,
 						sizeof(raw_super->uuid));
 
-	default_options(sbi);
+	default_options(sbi, false);
 	/* parse mount options */
 	options = kstrdup((const char *)data, GFP_KERNEL);
 	if (data && !options) {


