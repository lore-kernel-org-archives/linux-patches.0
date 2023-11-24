Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBC333CFD;
	Fri, 24 Nov 2023 18:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jmq569MR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DB2C433C7;
	Fri, 24 Nov 2023 18:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850122;
	bh=pRc+CJg/Wyodu/kBu3hLwTp6ohTXfeZ8iGun6DAl3Tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jmq569MRMy37dq7fK4roVa2NXO5JY5gWuPk/D01yvIcQrQaY6Jde+g5OFgXqMsK+l
	 jBTDd+lbFUt0DbDQeFAEh9PptRwnzadWIIbnxrlMutOcDYR1J6KQsiykylTVU8VjzA
	 ShU+m7RZJcaXIcZegn/PuwFWbQh3cQgITFPwvtps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	syzbot+d342e330a37b48c094b7@syzkaller.appspotmail.com
Subject: [PATCH 6.6 453/530] f2fs: split initial and dynamic conditions for extent_cache
Date: Fri, 24 Nov 2023 17:50:19 +0000
Message-ID: <20231124172041.872524053@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit f803982190f0265fd36cf84670aa6daefc2b0768 upstream.

Let's allocate the extent_cache tree without dynamic conditions to avoid a
missing condition causing a panic as below.

 # create a file w/ a compressed flag
 # disable the compression
 # panic while updating extent_cache

F2FS-fs (dm-64): Swapfile: last extent is not aligned to section
F2FS-fs (dm-64): Swapfile (3) is not align to section: 1) creat(), 2) ioctl(F2FS_IOC_SET_PIN_FILE), 3) fallocate(2097152 * N)
Adding 124996k swap on ./swap-file.  Priority:0 extents:2 across:17179494468k
==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_read_write out/common/include/linux/instrumented.h:101 [inline]
BUG: KASAN: null-ptr-deref in atomic_try_cmpxchg_acquire out/common/include/asm-generic/atomic-instrumented.h:705 [inline]
BUG: KASAN: null-ptr-deref in queued_write_lock out/common/include/asm-generic/qrwlock.h:92 [inline]
BUG: KASAN: null-ptr-deref in __raw_write_lock out/common/include/linux/rwlock_api_smp.h:211 [inline]
BUG: KASAN: null-ptr-deref in _raw_write_lock+0x5a/0x110 out/common/kernel/locking/spinlock.c:295
Write of size 4 at addr 0000000000000030 by task syz-executor154/3327

CPU: 0 PID: 3327 Comm: syz-executor154 Tainted: G           O      5.10.185 #1
Hardware name: emulation qemu-x86/qemu-x86, BIOS 2023.01-21885-gb3cc1cd24d 01/01/2023
Call Trace:
 __dump_stack out/common/lib/dump_stack.c:77 [inline]
 dump_stack_lvl+0x17e/0x1c4 out/common/lib/dump_stack.c:118
 __kasan_report+0x16c/0x260 out/common/mm/kasan/report.c:415
 kasan_report+0x51/0x70 out/common/mm/kasan/report.c:428
 kasan_check_range+0x2f3/0x340 out/common/mm/kasan/generic.c:186
 __kasan_check_write+0x14/0x20 out/common/mm/kasan/shadow.c:37
 instrument_atomic_read_write out/common/include/linux/instrumented.h:101 [inline]
 atomic_try_cmpxchg_acquire out/common/include/asm-generic/atomic-instrumented.h:705 [inline]
 queued_write_lock out/common/include/asm-generic/qrwlock.h:92 [inline]
 __raw_write_lock out/common/include/linux/rwlock_api_smp.h:211 [inline]
 _raw_write_lock+0x5a/0x110 out/common/kernel/locking/spinlock.c:295
 __drop_extent_tree+0xdf/0x2f0 out/common/fs/f2fs/extent_cache.c:1155
 f2fs_drop_extent_tree+0x17/0x30 out/common/fs/f2fs/extent_cache.c:1172
 f2fs_insert_range out/common/fs/f2fs/file.c:1600 [inline]
 f2fs_fallocate+0x19fd/0x1f40 out/common/fs/f2fs/file.c:1764
 vfs_fallocate+0x514/0x9b0 out/common/fs/open.c:310
 ksys_fallocate out/common/fs/open.c:333 [inline]
 __do_sys_fallocate out/common/fs/open.c:341 [inline]
 __se_sys_fallocate out/common/fs/open.c:339 [inline]
 __x64_sys_fallocate+0xb8/0x100 out/common/fs/open.c:339
 do_syscall_64+0x35/0x50 out/common/arch/x86/entry/common.c:46

Cc: stable@vger.kernel.org
Fixes: 72840cccc0a1 ("f2fs: allocate the extent_cache by default")
Reported-and-tested-by: syzbot+d342e330a37b48c094b7@syzkaller.appspotmail.com
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/extent_cache.c |   53 +++++++++++++++++++------------------------------
 1 file changed, 21 insertions(+), 32 deletions(-)

--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -74,40 +74,14 @@ static void __set_extent_info(struct ext
 	}
 }
 
-static bool __may_read_extent_tree(struct inode *inode)
-{
-	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
-
-	if (!test_opt(sbi, READ_EXTENT_CACHE))
-		return false;
-	if (is_inode_flag_set(inode, FI_NO_EXTENT))
-		return false;
-	if (is_inode_flag_set(inode, FI_COMPRESSED_FILE) &&
-			 !f2fs_sb_has_readonly(sbi))
-		return false;
-	return S_ISREG(inode->i_mode);
-}
-
-static bool __may_age_extent_tree(struct inode *inode)
-{
-	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
-
-	if (!test_opt(sbi, AGE_EXTENT_CACHE))
-		return false;
-	if (is_inode_flag_set(inode, FI_COMPRESSED_FILE))
-		return false;
-	if (file_is_cold(inode))
-		return false;
-
-	return S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode);
-}
-
 static bool __init_may_extent_tree(struct inode *inode, enum extent_type type)
 {
 	if (type == EX_READ)
-		return __may_read_extent_tree(inode);
-	else if (type == EX_BLOCK_AGE)
-		return __may_age_extent_tree(inode);
+		return test_opt(F2FS_I_SB(inode), READ_EXTENT_CACHE) &&
+			S_ISREG(inode->i_mode);
+	if (type == EX_BLOCK_AGE)
+		return test_opt(F2FS_I_SB(inode), AGE_EXTENT_CACHE) &&
+			(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode));
 	return false;
 }
 
@@ -120,7 +94,22 @@ static bool __may_extent_tree(struct ino
 	if (list_empty(&F2FS_I_SB(inode)->s_list))
 		return false;
 
-	return __init_may_extent_tree(inode, type);
+	if (!__init_may_extent_tree(inode, type))
+		return false;
+
+	if (type == EX_READ) {
+		if (is_inode_flag_set(inode, FI_NO_EXTENT))
+			return false;
+		if (is_inode_flag_set(inode, FI_COMPRESSED_FILE) &&
+				 !f2fs_sb_has_readonly(F2FS_I_SB(inode)))
+			return false;
+	} else if (type == EX_BLOCK_AGE) {
+		if (is_inode_flag_set(inode, FI_COMPRESSED_FILE))
+			return false;
+		if (file_is_cold(inode))
+			return false;
+	}
+	return true;
 }
 
 static void __try_update_largest_extent(struct extent_tree *et,


