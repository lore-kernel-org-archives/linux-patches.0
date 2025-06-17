Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292A72ED15A;
	Tue, 17 Jun 2025 15:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175313; cv=none; b=oLhvJLRcyPI38NTnkUC+2dFk85wjgVztm/dMPZTCpYbNykillbRePwGXQRm0AKmuvKxM/COIBIgFlSDmCIV2LxWOnH/NLQjkQ6spx7fyNUPf3UsKSxwTOjfGjknMt4uIMN4wVATGEjM/3t2MjgdLCTzC4lAJHYm/LzPbKuYj8Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175313; c=relaxed/simple;
	bh=FabUC/bgOxEB0m3dbTZ6T5uqv6VBNlULRnyPnV9V3aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIgBJya0sreU7q3852eL2RsU8AV+22y4bj+Ox316mVeCcP5IOMRZAkoE1BM+C0+GosvA9wBp1n3SE+f2UB+1rS6cnN4SVP+LvEBSutCdlcp4g5BzvfpSMJfzOhAdHCQssKg3ltHki9dMQ/E5I+V77WSn6jYV5aNTm18zpToMn5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hybTIzYf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hybTIzYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811ADC4CEE3;
	Tue, 17 Jun 2025 15:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175313;
	bh=FabUC/bgOxEB0m3dbTZ6T5uqv6VBNlULRnyPnV9V3aI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hybTIzYfGV8sBSQiscBdUgHaGekZWwJQSk4t7N7kjNpGKu/1E5Wk2wHKOnP0IVM8v
	 ERCE5QhBdhrKmo61yNpNsJh06KK4X9nRmTr5m0t/axYqbNQ4kCzZiuVunr0FQsx2sp
	 BzAe7Dn40GzCK6DNOYgTBcgI/rTnXUpz8H3efNew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 114/512] f2fs: zone: fix to avoid inconsistence in between SIT and SSA
Date: Tue, 17 Jun 2025 17:21:20 +0200
Message-ID: <20250617152424.205648354@linuxfoundation.org>
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

[ Upstream commit 773704c1ef96a8b70d0d186ab725f50548de82c4 ]

w/ below testcase, it will cause inconsistence in between SIT and SSA.

create_null_blk 512 2 1024 1024
mkfs.f2fs -m /dev/nullb0
mount /dev/nullb0 /mnt/f2fs/
touch /mnt/f2fs/file
f2fs_io pinfile set /mnt/f2fs/file
fallocate -l 4GiB /mnt/f2fs/file

F2FS-fs (nullb0): Inconsistent segment (0) type [1, 0] in SSA and SIT
CPU: 5 UID: 0 PID: 2398 Comm: fallocate Tainted: G           O       6.13.0-rc1 #84
Tainted: [O]=OOT_MODULE
Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
Call Trace:
 <TASK>
 dump_stack_lvl+0xb3/0xd0
 dump_stack+0x14/0x20
 f2fs_handle_critical_error+0x18c/0x220 [f2fs]
 f2fs_stop_checkpoint+0x38/0x50 [f2fs]
 do_garbage_collect+0x674/0x6e0 [f2fs]
 f2fs_gc_range+0x12b/0x230 [f2fs]
 f2fs_allocate_pinning_section+0x5c/0x150 [f2fs]
 f2fs_expand_inode_data+0x1cc/0x3c0 [f2fs]
 f2fs_fallocate+0x3c3/0x410 [f2fs]
 vfs_fallocate+0x15f/0x4b0
 __x64_sys_fallocate+0x4a/0x80
 x64_sys_call+0x15e8/0x1b80
 do_syscall_64+0x68/0x130
 entry_SYSCALL_64_after_hwframe+0x67/0x6f
RIP: 0033:0x7f9dba5197ca
F2FS-fs (nullb0): Stopped filesystem due to reason: 4

The reason is f2fs_gc_range() may try to migrate block in curseg, however,
its SSA block is not uptodate due to the last summary block data is still
in cache of curseg.

In this patch, we add a condition in f2fs_gc_range() to check whether
section is opened or not, and skip block migration for opened section.

Fixes: 9703d69d9d15 ("f2fs: support file pinning for zoned devices")
Reviewed-by: Daeho Jeong <daehojeong@google.com>
Cc: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index e0469316c7cd4..cd56c0e66657b 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2072,6 +2072,9 @@ int f2fs_gc_range(struct f2fs_sb_info *sbi,
 			.iroot = RADIX_TREE_INIT(gc_list.iroot, GFP_NOFS),
 		};
 
+		if (IS_CURSEC(sbi, GET_SEC_FROM_SEG(sbi, segno)))
+			continue;
+
 		do_garbage_collect(sbi, segno, &gc_list, FG_GC, true, false);
 		put_gc_inode(&gc_list);
 
-- 
2.39.5



