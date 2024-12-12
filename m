Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE764222D4B;
	Thu, 12 Dec 2024 16:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020159; cv=none; b=Qu3CfdXxI3ruZbRFAx29lPCTxYUM0YJPK292jawlHQQTi9ZhSvwL7VebMywL4YHi3SkvOqOhFBENOKm1vl7LjOTTPAefdnO6mhBIcKQ0s9Y9Hs+Hh7w6PI8318GgH4NzKFSSTtPT+WmUCIzi9ku4do4MYpVImiZlVCfT5DlNEd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020159; c=relaxed/simple;
	bh=Bj0xO6nSFJylT0MiJ/HupEsO5181rkaz/kYlvpAA3rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZc2GcFZAhR1x70Ne6qAdQ60WBvDzvZ9/SQpzhI7DpsqQUklAG2IvGoGxUohc907XH5m6EnRfhTCmuJSz1zk4w7LrSt1cjNZyCA7H94RqeldPsgzmZPGDfsuUlFh371b3HA8grXDfcgcA70smuhKHBA/Pm3t3OrZV5Re3Vl1FcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8By5Az5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8By5Az5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BA3C4CECE;
	Thu, 12 Dec 2024 16:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020158;
	bh=Bj0xO6nSFJylT0MiJ/HupEsO5181rkaz/kYlvpAA3rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8By5Az5sCHhnTGXxQ8u2o2RnsK5zJ+G46sa9GEgyriOipPPboEKLyDmImqEJebf3
	 gdbqZuSXrWmW0QXG23O/TMGQ7WmoetuCAjX44Vp97AQ0AqwKOEOjcq7m5uQIBCD7eV
	 RCHqjJtJDExajXPs1EGvJs3TYl0CeJJ8gzVhujgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 362/772] ext4: supress data-race warnings in ext4_free_inodes_{count,set}()
Date: Thu, 12 Dec 2024 15:55:07 +0100
Message-ID: <20241212144404.879552550@linuxfoundation.org>
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

From: Jeongjun Park <aha310510@gmail.com>

commit 902cc179c931a033cd7f4242353aa2733bf8524c upstream.

find_group_other() and find_group_orlov() read *_lo, *_hi with
ext4_free_inodes_count without additional locking. This can cause
data-race warning, but since the lock is held for most writes and free
inodes value is generally not a problem even if it is incorrect, it is
more appropriate to use READ_ONCE()/WRITE_ONCE() than to add locking.

==================================================================
BUG: KCSAN: data-race in ext4_free_inodes_count / ext4_free_inodes_set

write to 0xffff88810404300e of 2 bytes by task 6254 on cpu 1:
 ext4_free_inodes_set+0x1f/0x80 fs/ext4/super.c:405
 __ext4_new_inode+0x15ca/0x2200 fs/ext4/ialloc.c:1216
 ext4_symlink+0x242/0x5a0 fs/ext4/namei.c:3391
 vfs_symlink+0xca/0x1d0 fs/namei.c:4615
 do_symlinkat+0xe3/0x340 fs/namei.c:4641
 __do_sys_symlinkat fs/namei.c:4657 [inline]
 __se_sys_symlinkat fs/namei.c:4654 [inline]
 __x64_sys_symlinkat+0x5e/0x70 fs/namei.c:4654
 x64_sys_call+0x1dda/0x2d60 arch/x86/include/generated/asm/syscalls_64.h:267
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0x54/0x120 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

read to 0xffff88810404300e of 2 bytes by task 6257 on cpu 0:
 ext4_free_inodes_count+0x1c/0x80 fs/ext4/super.c:349
 find_group_other fs/ext4/ialloc.c:594 [inline]
 __ext4_new_inode+0x6ec/0x2200 fs/ext4/ialloc.c:1017
 ext4_symlink+0x242/0x5a0 fs/ext4/namei.c:3391
 vfs_symlink+0xca/0x1d0 fs/namei.c:4615
 do_symlinkat+0xe3/0x340 fs/namei.c:4641
 __do_sys_symlinkat fs/namei.c:4657 [inline]
 __se_sys_symlinkat fs/namei.c:4654 [inline]
 __x64_sys_symlinkat+0x5e/0x70 fs/namei.c:4654
 x64_sys_call+0x1dda/0x2d60 arch/x86/include/generated/asm/syscalls_64.h:267
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0x54/0x120 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Cc: stable@vger.kernel.org
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://patch.msgid.link/20241003125337.47283-1-aha310510@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -338,9 +338,9 @@ __u32 ext4_free_group_clusters(struct su
 __u32 ext4_free_inodes_count(struct super_block *sb,
 			      struct ext4_group_desc *bg)
 {
-	return le16_to_cpu(bg->bg_free_inodes_count_lo) |
+	return le16_to_cpu(READ_ONCE(bg->bg_free_inodes_count_lo)) |
 		(EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT ?
-		 (__u32)le16_to_cpu(bg->bg_free_inodes_count_hi) << 16 : 0);
+		 (__u32)le16_to_cpu(READ_ONCE(bg->bg_free_inodes_count_hi)) << 16 : 0);
 }
 
 __u32 ext4_used_dirs_count(struct super_block *sb,
@@ -394,9 +394,9 @@ void ext4_free_group_clusters_set(struct
 void ext4_free_inodes_set(struct super_block *sb,
 			  struct ext4_group_desc *bg, __u32 count)
 {
-	bg->bg_free_inodes_count_lo = cpu_to_le16((__u16)count);
+	WRITE_ONCE(bg->bg_free_inodes_count_lo, cpu_to_le16((__u16)count));
 	if (EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT)
-		bg->bg_free_inodes_count_hi = cpu_to_le16(count >> 16);
+		WRITE_ONCE(bg->bg_free_inodes_count_hi, cpu_to_le16(count >> 16));
 }
 
 void ext4_used_dirs_set(struct super_block *sb,


