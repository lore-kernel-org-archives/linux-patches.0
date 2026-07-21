Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC4F44AB98;
	Tue, 21 Jul 2026 21:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670922; cv=none; b=mp1+pSnugZ2izNl1dBQizsR/mzRFosllTMKpGh+cse7V8ro2O8DWyF3wOHB1Ssud+cYaFX/HuvZjD85V0AXyl8rrqSlNABv76wPIcJQmIPk20AYibuP2go/WlfmjZoHvvwugoJD2Tz+C2FRNW1w6dMZtxCu2rwE9pCuOQBIqNqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670922; c=relaxed/simple;
	bh=4/x0N2zdIoLwErN/jRM8ktxk4r7m2nSrn2Jr+IYU5aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWm6D3FhPutj7kSleS6PAl/LhJ89RPqzdMHZu95slHSdDyiYhk6zL1kSXrizto2xuxdY+G7lEWuAnhaENNRZ3875f+Tjxye293ZPGE0x3H5FVIMGsO0H+lcLa7sSwrRae5hDFNKfnBWpTzbMHYbAUPSc60u9HjBt64fFoe7IxUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0+FYzxq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0+FYzxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F42371F00A3A;
	Tue, 21 Jul 2026 21:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670921;
	bh=iBBW//MfJ3EP2xY6n4HxP+zdqHv7LjvUYgBckLknZlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M0+FYzxq4Dok+O9spGeDSM5PBMRGqxJsN8XFMyjW/YC9FfzpQ5uWVu+Ye1kJoOQM9
	 i8Wit4Bhn2Ryq+jshLybQ1SHOoMVg5OHQJjHpfjnVwtId01Szf49wV6jaOGgoC9tzA
	 XZUuJQjcXzqmK8ag6g+2PT8kIkdoahtFYF1Zi1WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/843] block: Avoid mounting the bdev pseudo-filesystem in userspace
Date: Tue, 21 Jul 2026 17:14:29 +0200
Message-ID: <20260721152406.737546108@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Arefev <arefev@swemel.ru>

[ Upstream commit f73aa66dffcb8e61e78f01b56163ec16a15d06d2 ]

The bdev pseudo-filesystem is an internal kernel filesystem with which
userspace should not interfere. Unregister it so that userspace cannot
even attempt to mount it.

This fixes a bug [1] that occurs when attempting to access files,
because the system call move_mount() uses pointers declared in the
inode_operations structure, which for the bdev pseudo-filesystem
are always equal to 0. `inode->i_op = &empty_iops;`

[1]

 BUG: kernel NULL pointer dereference, address: 0000000000000000
 #PF: supervisor instruction fetch in kernel mode
 #PF: error_code(0x0010) - not-present page
 PGD 23380067 P4D 23380067 PUD 23381067 PMD 0
 Oops: 0010 [#1] PREEMPT SMP KASAN NOPTI
 CPU: 2 PID: 17125 Comm: syz-executor.0 Not tainted 6.1.155-syzkaller-00350-g84221fde2681 #0
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
 RIP: 0010:0x0

 Call Trace:
 <TASK>
 lookup_open.isra.0+0x700/0x1180 fs/namei.c:3460
 open_last_lookups fs/namei.c:3550 [inline]
 path_openat+0x953/0x2700 fs/namei.c:3780
 do_filp_open+0x1c5/0x410 fs/namei.c:3810
 do_sys_openat2+0x171/0x4d0 fs/open.c:1318
 do_sys_open fs/open.c:1334 [inline]
 __do_sys_openat fs/open.c:1350 [inline]
 __se_sys_openat fs/open.c:1345 [inline]
 __x64_sys_openat+0x13c/0x1f0 fs/open.c:1345
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x35/0x80 arch/x86/entry/common.c:81
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://lore.kernel.org/all/20131010004732.GJ13318@ZenIV.linux.org.uk/T/#
Cc: stable@vger.kernel.org
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260521072857.5078-1-arefev@swemel.ru
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bdev.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/block/bdev.c
+++ b/block/bdev.c
@@ -459,16 +459,12 @@ EXPORT_SYMBOL_GPL(blockdev_superblock);
 
 void __init bdev_cache_init(void)
 {
-	int err;
 	static struct vfsmount *bd_mnt;
 
 	bdev_cachep = kmem_cache_create("bdev_cache", sizeof(struct bdev_inode),
 			0, (SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
 				SLAB_MEM_SPREAD|SLAB_ACCOUNT|SLAB_PANIC),
 			init_once);
-	err = register_filesystem(&bd_type);
-	if (err)
-		panic("Cannot register bdev pseudo-fs");
 	bd_mnt = kern_mount(&bd_type);
 	if (IS_ERR(bd_mnt))
 		panic("Cannot create bdev pseudo-fs");


