Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA252ED86F;
	Tue, 17 Jun 2025 15:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175372; cv=none; b=o2t3P2IKdT8DGhhfarGqVpWNvuQqtR6OvzwVVB7ObY8iVkl0EiXnapLmb/cPAHJt62cXC5DItfRz/ZH3KvAOhy+o9/vnlaUwAH7zTTKwerRNu8M3yyGcldqSMxXnG/52zzGoUsBNRs7XHXqndfGYJIYCak+6fCpZXqdPWqPjqAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175372; c=relaxed/simple;
	bh=5Qz8QLgYUvBPCe6jhJsNIQDVF8pPf8GN4r/weuo1KhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJP0919ES6ahuu3Fdl03RZdRxFVxdzbOOfeXwOLsikx+715AYqx0vePf+qb4n12gFe9HVGpwRSZhJn7v4UznflLC93S4FQkc47FVZzmDLhN0dhyub2wbpRjl5QjQVy9kzJu+hMQk8JnYpTe9xrb0W7ndTKV6XHk7RnDGNoozWm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WxK8mrYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WxK8mrYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5C0C4CEE3;
	Tue, 17 Jun 2025 15:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175370;
	bh=5Qz8QLgYUvBPCe6jhJsNIQDVF8pPf8GN4r/weuo1KhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WxK8mrYu4AoBxaV7R5zKh6e0wz5J8JbF59IqtyiEIgCiTcxJccRh+f8xhCWZp8kjp
	 eT7iN24UNo/3QK9EBWkTS1UsuvxiUv7j1EfmdbXioMQ7LaF700EYIfvA/gMKr+DlNH
	 rxRo9AZ717mRatW9VlVgcklLmDL4b0uLYCKtck80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8b376a77b2f364097fbe@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 120/512] f2fs: fix to do sanity check on sbi->total_valid_block_count
Date: Tue, 17 Jun 2025 17:21:26 +0200
Message-ID: <20250617152424.448267983@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 05872a167c2cab80ef186ef23cc34a6776a1a30c ]

syzbot reported a f2fs bug as below:

------------[ cut here ]------------
kernel BUG at fs/f2fs/f2fs.h:2521!
RIP: 0010:dec_valid_block_count+0x3b2/0x3c0 fs/f2fs/f2fs.h:2521
Call Trace:
 f2fs_truncate_data_blocks_range+0xc8c/0x11a0 fs/f2fs/file.c:695
 truncate_dnode+0x417/0x740 fs/f2fs/node.c:973
 truncate_nodes+0x3ec/0xf50 fs/f2fs/node.c:1014
 f2fs_truncate_inode_blocks+0x8e3/0x1370 fs/f2fs/node.c:1197
 f2fs_do_truncate_blocks+0x840/0x12b0 fs/f2fs/file.c:810
 f2fs_truncate_blocks+0x10d/0x300 fs/f2fs/file.c:838
 f2fs_truncate+0x417/0x720 fs/f2fs/file.c:888
 f2fs_setattr+0xc4f/0x12f0 fs/f2fs/file.c:1112
 notify_change+0xbca/0xe90 fs/attr.c:552
 do_truncate+0x222/0x310 fs/open.c:65
 handle_truncate fs/namei.c:3466 [inline]
 do_open fs/namei.c:3849 [inline]
 path_openat+0x2e4f/0x35d0 fs/namei.c:4004
 do_filp_open+0x284/0x4e0 fs/namei.c:4031
 do_sys_openat2+0x12b/0x1d0 fs/open.c:1429
 do_sys_open fs/open.c:1444 [inline]
 __do_sys_creat fs/open.c:1522 [inline]
 __se_sys_creat fs/open.c:1516 [inline]
 __x64_sys_creat+0x124/0x170 fs/open.c:1516
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94

The reason is: in fuzzed image, sbi->total_valid_block_count is
inconsistent w/ mapped blocks indexed by inode, so, we should
not trigger panic for such case, instead, let's print log and
set fsck flag.

Fixes: 39a53e0ce0df ("f2fs: add superblock and major in-memory structure")
Reported-by: syzbot+8b376a77b2f364097fbe@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-f2fs-devel/67f3c0b2.050a0220.396535.0547.GAE@google.com
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 1c783c2e4902a..1219e37fa7ad3 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2508,8 +2508,14 @@ static inline void dec_valid_block_count(struct f2fs_sb_info *sbi,
 	blkcnt_t sectors = count << F2FS_LOG_SECTORS_PER_BLOCK;
 
 	spin_lock(&sbi->stat_lock);
-	f2fs_bug_on(sbi, sbi->total_valid_block_count < (block_t) count);
-	sbi->total_valid_block_count -= (block_t)count;
+	if (unlikely(sbi->total_valid_block_count < count)) {
+		f2fs_warn(sbi, "Inconsistent total_valid_block_count:%u, ino:%lu, count:%u",
+			  sbi->total_valid_block_count, inode->i_ino, count);
+		sbi->total_valid_block_count = 0;
+		set_sbi_flag(sbi, SBI_NEED_FSCK);
+	} else {
+		sbi->total_valid_block_count -= count;
+	}
 	if (sbi->reserved_blocks &&
 		sbi->current_reserved_blocks < sbi->reserved_blocks)
 		sbi->current_reserved_blocks = min(sbi->reserved_blocks,
-- 
2.39.5



