Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B604207F;
	Wed,  6 Nov 2024 12:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896238; cv=none; b=Fga6RlbEA/Sj2BDtPeJ3w5s22qJQuq2ypa35xkAhNYyHa4ldR/qQelKF52PwK4p3dkovNTqFb1NGkFYngXw2LIaC7iLSKz3tpWdmcg0onvB/EPOfQ/z2R3WR1fggCNrCnDnELD6OYoiBp79OgLhOLCmYgcMBulAnLnq7TSLHeUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896238; c=relaxed/simple;
	bh=nZozHv7ZeYkCMCrf/wXTZ45bUEw43D83rwfTypTstIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDRMII7MkGWJO18YrxXHYSKJocQH6EcpJ9TMCpPiS3b2GY1XjvG4tUV6v137gBJ7+4v89UmDJzUowEFvmSN7XJKcGd/I8pGK+6Ss7Z3wIoln1+ib7DKdsBMEf2pmZ4pyi2p74asehEDGyIpobGpiJ+FR8hIMY0m7DE0dAYdF/oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qqKzbdfq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qqKzbdfq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EB4C4CECD;
	Wed,  6 Nov 2024 12:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896238;
	bh=nZozHv7ZeYkCMCrf/wXTZ45bUEw43D83rwfTypTstIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qqKzbdfqqY4qyUNt25fHhdPWpnPB+2GB8g1kRIioWdgd4AkFC403syb7Lwzf6lH5u
	 u1QrnZtYAgUAdxpdbx/2FBJM8S+XbaiJScusaOZDwLEh27X1SbwsQzeffkbiJE4HDY
	 DAPtkH6K9L9T2z4E0c6RPHLIdGYwH0jfKV+fZsio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	syzbot <syzkaller@googlegroup.com>,
	Hugh Dickins <hughd@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 136/245] mm: shmem: fix data-race in shmem_getattr()
Date: Wed,  6 Nov 2024 13:03:09 +0100
Message-ID: <20241106120322.576608394@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongjun Park <aha310510@gmail.com>

commit d949d1d14fa281ace388b1de978e8f2cd52875cf upstream.

I got the following KCSAN report during syzbot testing:

==================================================================
BUG: KCSAN: data-race in generic_fillattr / inode_set_ctime_current

write to 0xffff888102eb3260 of 4 bytes by task 6565 on cpu 1:
 inode_set_ctime_to_ts include/linux/fs.h:1638 [inline]
 inode_set_ctime_current+0x169/0x1d0 fs/inode.c:2626
 shmem_mknod+0x117/0x180 mm/shmem.c:3443
 shmem_create+0x34/0x40 mm/shmem.c:3497
 lookup_open fs/namei.c:3578 [inline]
 open_last_lookups fs/namei.c:3647 [inline]
 path_openat+0xdbc/0x1f00 fs/namei.c:3883
 do_filp_open+0xf7/0x200 fs/namei.c:3913
 do_sys_openat2+0xab/0x120 fs/open.c:1416
 do_sys_open fs/open.c:1431 [inline]
 __do_sys_openat fs/open.c:1447 [inline]
 __se_sys_openat fs/open.c:1442 [inline]
 __x64_sys_openat+0xf3/0x120 fs/open.c:1442
 x64_sys_call+0x1025/0x2d60 arch/x86/include/generated/asm/syscalls_64.h:258
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0x54/0x120 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

read to 0xffff888102eb3260 of 4 bytes by task 3498 on cpu 0:
 inode_get_ctime_nsec include/linux/fs.h:1623 [inline]
 inode_get_ctime include/linux/fs.h:1629 [inline]
 generic_fillattr+0x1dd/0x2f0 fs/stat.c:62
 shmem_getattr+0x17b/0x200 mm/shmem.c:1157
 vfs_getattr_nosec fs/stat.c:166 [inline]
 vfs_getattr+0x19b/0x1e0 fs/stat.c:207
 vfs_statx_path fs/stat.c:251 [inline]
 vfs_statx+0x134/0x2f0 fs/stat.c:315
 vfs_fstatat+0xec/0x110 fs/stat.c:341
 __do_sys_newfstatat fs/stat.c:505 [inline]
 __se_sys_newfstatat+0x58/0x260 fs/stat.c:499
 __x64_sys_newfstatat+0x55/0x70 fs/stat.c:499
 x64_sys_call+0x141f/0x2d60 arch/x86/include/generated/asm/syscalls_64.h:263
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0x54/0x120 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

value changed: 0x2755ae53 -> 0x27ee44d3

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 UID: 0 PID: 3498 Comm: udevd Not tainted 6.11.0-rc6-syzkaller-00326-gd1f2d51b711a-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
==================================================================

When calling generic_fillattr(), if you don't hold read lock, data-race
will occur in inode member variables, which can cause unexpected
behavior.

Since there is no special protection when shmem_getattr() calls
generic_fillattr(), data-race occurs by functions such as shmem_unlink()
or shmem_mknod(). This can cause unexpected results, so commenting it out
is not enough.

Therefore, when calling generic_fillattr() from shmem_getattr(), it is
appropriate to protect the inode using inode_lock_shared() and
inode_unlock_shared() to prevent data-race.

Link: https://lkml.kernel.org/r/20240909123558.70229-1-aha310510@gmail.com
Fixes: 44a30220bc0a ("shmem: recalculate file inode when fstat")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Reported-by: syzbot <syzkaller@googlegroup.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1163,7 +1163,9 @@ static int shmem_getattr(struct mnt_idma
 	stat->attributes_mask |= (STATX_ATTR_APPEND |
 			STATX_ATTR_IMMUTABLE |
 			STATX_ATTR_NODUMP);
+	inode_lock_shared(inode);
 	generic_fillattr(idmap, request_mask, inode, stat);
+	inode_unlock_shared(inode);
 
 	if (shmem_huge_global_enabled(inode, 0, false, NULL, 0))
 		stat->blksize = HPAGE_PMD_SIZE;


