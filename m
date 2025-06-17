Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C055C221550;
	Tue, 17 Jun 2025 16:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176386; cv=none; b=cUaph9KlFZTic4f3NK35xw2e9OGb5PLGo2Q+giePrVj3o7OafJtlp/lNiLo57mvmv7N02de9Bi5VBIgOjMd8Ch7T4iJDbNErQ/YRcxaa5VzcxzbDdn9U4hFIjcu/fccfK+Xhn0LnIjgpbVar/SkH5oJBPzhVRrx4Q1Pg1zgYl4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176386; c=relaxed/simple;
	bh=XgIbk0AmUyHVAvfJ80lBGY3EJzQPaYo6j5FiaBSi0aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=feb8GG9K/Q7AdiGPpzMAiumwLDAoENXbuYLVl59x3EokV0fS15OHcsqiU5922N1XBLwL9JA2+POWqeZq7ERYX0WYO5Sh50Q+S9x2/p87Zs2a9P3Mcme8uK7vCDYjyslYEJTXGFuiCJ/bUsvrV00gvdME1jrtBwkn2FuEfMD02c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hAdMWGHs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hAdMWGHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BB9C4CEE3;
	Tue, 17 Jun 2025 16:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176386;
	bh=XgIbk0AmUyHVAvfJ80lBGY3EJzQPaYo6j5FiaBSi0aI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hAdMWGHsjAcO/FyLP1xFIxFAKK/Q8wybO2aeBkgfZAcPPj1T6Ky3bxDkDkxybprGm
	 0yM0pZpKlxfaiuHYkf1uSXOL3j2dBPF7AVkrkTs4u3OinuCX0N66BQrvy76LjRIVXe
	 7/HpnPRIGONX2MzZqVu2Bt8GF52EeaKpVZSui958=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8b376a77b2f364097fbe@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 184/780] f2fs: fix to do sanity check on sbi->total_valid_block_count
Date: Tue, 17 Jun 2025 17:18:12 +0200
Message-ID: <20250617152458.972525956@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index f1576dc6ec679..6dcac5ab041c8 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2518,8 +2518,14 @@ static inline void dec_valid_block_count(struct f2fs_sb_info *sbi,
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



