Received: from n169-110.mail.139.com (n169-110.mail.139.com [120.232.169.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E220342CA2
	for <patches@lists.linux.dev>; Wed,  4 Mar 2026 05:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772603775; cv=none; b=CLPbURwmwnYIN4wm7dIDx/cxWlIvf3oh7PqcJSuLc4HpuYOD+t4NUvDXtMUTiqSpKzxqSjhbvV2P4thtvnZA7qN0sNVqnmSZxjFeyyjrT41nwI8zNWQtcE4DgU3l9axOsUHyI3PYm6TOP9B4Fs35h0E7VQ5swNEhtATthXQpJR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772603775; c=relaxed/simple;
	bh=RERDU0kupy1mzuigYZrGNTxQEUs2twFXLeDd5M2jrAg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mneqeBweL91n4XWRzvJMWp+fU5iKRqPtZb/Jg3M/70QZNrlWE6RK8luQsf9q8I1512AJwg3bIBxsA53nHxfPBtl+O0o2OG9Zy8QMKnUa1PuPzP0YfJoEOMv8TH27qIdH2QE/T5eP7/s53v2Ug3D87YQVmyH6CNVvMvDkzA+5K68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=e7UCsD2M; arc=none smtp.client-ip=120.232.169.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="e7UCsD2M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=e7UCsD2MOD4MMoPDrRgpNNek75SzEkuS7iI4o+kPYHSbp8bYm9ClPK9x2WHHYIml0jskhPTdazl46
	 3rspptUfDpLxPtmx5JIoPHcwIBMKmpBtbcEvFHxR8y2uEFs9LQWlZ81Hu68DX0Buyp+UMw0+cxTgCg
	 YFskyGjzNXlc5glg=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-06-12084 (RichMail) with SMTP id 2f3469a7c96a766-00770;
	Wed, 04 Mar 2026 13:55:58 +0800 (CST)
X-RM-TRANSID:2f3469a7c96a766-00770
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	chao@kernel.org
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	jaegeuk@kernel.org,
	daehojeong@google.com,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 6.6.y] f2fs: zone: fix to avoid inconsistence in between SIT and SSA
Date: Wed,  4 Mar 2026 13:55:56 +0800
Message-Id: <20260304055556.2595295-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
[ Minor conflict resolved. ]
Signed-off-by: Li hongliang <1468888505@139.com>
---
 fs/f2fs/gc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 8122135bb1ff..791b29ed6e47 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2005,6 +2005,9 @@ int f2fs_gc_range(struct f2fs_sb_info *sbi,
 			.iroot = RADIX_TREE_INIT(gc_list.iroot, GFP_NOFS),
 		};
 
+		if (IS_CURSEC(sbi, GET_SEC_FROM_SEG(sbi, segno)))
+			continue;
+
 		do_garbage_collect(sbi, segno, &gc_list, FG_GC,
 						dry_run_sections == 0);
 		put_gc_inode(&gc_list);
-- 
2.34.1


