Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE2D3242AC;
	Thu, 12 Mar 2026 20:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347243; cv=none; b=Bzusy5Jvoe4hW/JlSyIBmXKfJLc9LxBcdoO4Uz3EJQp3RgzGW32oVuNQhiw49jfBrA0N9GYytt5o71fm4RhzDDFGaxStkWWGzFpTBagJCWdOr6XWbpZYN+d1064PdIp6yBHanG3gof0KxuCKeJE+bZWwm1nzbGdl7IC24wrxNoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347243; c=relaxed/simple;
	bh=K5ILxdVg2iS/PUs26BsLE3gUxhBQ8k3OPen8D8XAmXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkTI9qBLGQfUM+/M8q6kWu5hQymXSWH0PRCyT7gH1+/okaI1s+S94BYzeNVBBggEaxEosxdCrPozrdWshXgGJUUA2G/AL+Nu0gwmAbNCAYbmvJ1M+GyYGKVQPgav0QZuKjtJu7RzsA64oUTzcE2Pcew5yO1nQkEZyE8v5pWjadA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ug/UNAyG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ug/UNAyG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04962C4CEF7;
	Thu, 12 Mar 2026 20:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347242;
	bh=K5ILxdVg2iS/PUs26BsLE3gUxhBQ8k3OPen8D8XAmXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ug/UNAyG8rc5MZUP3WYtytVf0ZpWX64ZN4WSqAg6f1rNGFHXZLWtFGZg1QXA38r4M
	 TkURj+rO96Qye6IHKde5zybpi1O+DCU+RH1PvFo1aDcJRGGoFXFzMZ19hTnZe2WJv/
	 ilvz7rSYuUuP6QrtmQe362mlzSc75zEFTb13/y3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Shi <cshi008@fiu.edu>,
	Weidong Zhu <weizhu@fiu.edu>,
	Dave Tian <daveti@purdue.edu>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Sungwoo Kim <iam@sung-woo.kim>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 224/265] nvme: fix memory allocation in nvme_pr_read_keys()
Date: Thu, 12 Mar 2026 21:10:11 +0100
Message-ID: <20260312201026.417079103@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Sungwoo Kim <iam@sung-woo.kim>

[ Upstream commit c3320153769f05fd7fe9d840cb555dd3080ae424 ]

nvme_pr_read_keys() takes num_keys from userspace and uses it to
calculate the allocation size for rse via struct_size(). The upper
limit is PR_KEYS_MAX (64K).

A malicious or buggy userspace can pass a large num_keys value that
results in a 4MB allocation attempt at most, causing a warning in
the page allocator when the order exceeds MAX_PAGE_ORDER.

To fix this, use kvzalloc() instead of kzalloc().

This bug has the same reasoning and fix with the patch below:
https://lore.kernel.org/linux-block/20251212013510.3576091-1-kartikey406@gmail.com/

Warning log:
WARNING: mm/page_alloc.c:5216 at __alloc_frozen_pages_noprof+0x5aa/0x2300 mm/page_alloc.c:5216, CPU#1: syz-executor117/272
Modules linked in:
CPU: 1 UID: 0 PID: 272 Comm: syz-executor117 Not tainted 6.19.0 #1 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
RIP: 0010:__alloc_frozen_pages_noprof+0x5aa/0x2300 mm/page_alloc.c:5216
Code: ff 83 bd a8 fe ff ff 0a 0f 86 69 fb ff ff 0f b6 1d f9 f9 c4 04 80 fb 01 0f 87 3b 76 30 ff 83 e3 01 75 09 c6 05 e4 f9 c4 04 01 <0f> 0b 48 c7 85 70 fe ff ff 00 00 00 00 e9 8f fd ff ff 31 c0 e9 0d
RSP: 0018:ffffc90000fcf450 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 1ffff920001f9ea0
RDX: 0000000000000000 RSI: 000000000000000b RDI: 0000000000040dc0
RBP: ffffc90000fcf648 R08: ffff88800b6c3380 R09: 0000000000000001
R10: ffffc90000fcf840 R11: ffff88807ffad280 R12: 0000000000000000
R13: 0000000000040dc0 R14: 0000000000000001 R15: ffffc90000fcf620
FS:  0000555565db33c0(0000) GS:ffff8880be26c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000002000000c CR3: 0000000003b72000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 alloc_pages_mpol+0x236/0x4d0 mm/mempolicy.c:2486
 alloc_frozen_pages_noprof+0x149/0x180 mm/mempolicy.c:2557
 ___kmalloc_large_node+0x10c/0x140 mm/slub.c:5598
 __kmalloc_large_node_noprof+0x25/0xc0 mm/slub.c:5629
 __do_kmalloc_node mm/slub.c:5645 [inline]
 __kmalloc_noprof+0x483/0x6f0 mm/slub.c:5669
 kmalloc_noprof include/linux/slab.h:961 [inline]
 kzalloc_noprof include/linux/slab.h:1094 [inline]
 nvme_pr_read_keys+0x8f/0x4c0 drivers/nvme/host/pr.c:245
 blkdev_pr_read_keys block/ioctl.c:456 [inline]
 blkdev_common_ioctl+0x1b71/0x29b0 block/ioctl.c:730
 blkdev_ioctl+0x299/0x700 block/ioctl.c:786
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x1bf/0x220 fs/ioctl.c:583
 x64_sys_call+0x1280/0x21b0 mnt/fuzznvme_1/fuzznvme/linux-build/v6.19/./arch/x86/include/generated/asm/syscalls_64.h:17
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x71/0x330 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7fb893d3108d
Code: 28 c3 e8 46 1e 00 00 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffff61f2f38 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffff61f3138 RCX: 00007fb893d3108d
RDX: 0000000020000040 RSI: 00000000c01070ce RDI: 0000000000000003
RBP: 0000000000000001 R08: 0000000000000000 R09: 00007ffff61f3138
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffff61f3128 R14: 00007fb893dae530 R15: 0000000000000001
 </TASK>

Fixes: 5fd96a4e15de (nvme: Add pr_ops read_keys support)
Acked-by: Chao Shi <cshi008@fiu.edu>
Acked-by: Weidong Zhu <weizhu@fiu.edu>
Acked-by: Dave Tian <daveti@purdue.edu>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index d330916a3199d..e1d07f824b13c 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -214,7 +214,7 @@ static int nvme_pr_read_keys(struct block_device *bdev,
 	if (rse_len > U32_MAX)
 		return -EINVAL;
 
-	rse = kzalloc(rse_len, GFP_KERNEL);
+	rse = kvzalloc(rse_len, GFP_KERNEL);
 	if (!rse)
 		return -ENOMEM;
 
@@ -239,7 +239,7 @@ static int nvme_pr_read_keys(struct block_device *bdev,
 	}
 
 free_rse:
-	kfree(rse);
+	kvfree(rse);
 	return ret;
 }
 
-- 
2.51.0



