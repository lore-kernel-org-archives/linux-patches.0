Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524B824E4C3;
	Thu,  2 Jul 2026 16:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011329; cv=none; b=F7DvIY1Dg5ko1TuQUqca1AiX7aSa33wgXJYFkUdWGc9gkMGUIo2Xe4TWomoCHnyNO1Wx7IcrBXHLXNfLikLRHYLa85cht02hTspvd6AmijaX6ER3j5944Po3y9AKRta8h2A5PnC9SJy1VR+AtKUhEPAQjy9sYzbIUj1nhPL+Tc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011329; c=relaxed/simple;
	bh=4YJkYxT9l1j9oAxSBj+f7y4OAMxB5QtmG8gp/3mFRfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kbpdZZoqWyPxs0AZjh97GpJ+sGW4r8yXWfTvzkAYls8Ci+Zc2o3p+G/TpGSbCyYicdsf2XznMwqGHbP1Yx7ERnLDl/aEZnfs6Ut+Og0wXhdxddgGBUfFnntj1v2VVUSW5g9cI6BSiVQxCVxLy6uEtbtEU+2GLC/KiGXS1/oKjDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/nVQcYY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/nVQcYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89BC1F000E9;
	Thu,  2 Jul 2026 16:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011328;
	bh=fZnPjjJOKk/Hg3bYOA089yQMGJqYcc4bqw+VFAxHaVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S/nVQcYYr+6B7RscyxI9J6XbsUV3eH2ldVXGB0YkuzWLuphGrXjghDLcpS59DhYsJ
	 zDl2oV8Uu7mBgiOtbrwoQHGD8P2noDtNrdN+wVI4Wl3cHgWwVtTEen0oT2IhHrW6uO
	 wkAzzFQfJFihZOwsXAml+beTNL002q63c2v4atmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 067/108] block: Avoid mounting the bdev pseudo-filesystem in userspace
Date: Thu,  2 Jul 2026 18:21:04 +0200
Message-ID: <20260702155113.499036806@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Arefev <arefev@swemel.ru>

commit f73aa66dffcb8e61e78f01b56163ec16a15d06d2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bdev.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/block/bdev.c
+++ b/block/bdev.c
@@ -438,15 +438,10 @@ EXPORT_SYMBOL_GPL(blockdev_superblock);
 
 void __init bdev_cache_init(void)
 {
-	int err;
-
 	bdev_cachep = kmem_cache_create("bdev_cache", sizeof(struct bdev_inode),
 			0, (SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
 				SLAB_ACCOUNT|SLAB_PANIC),
 			init_once);
-	err = register_filesystem(&bd_type);
-	if (err)
-		panic("Cannot register bdev pseudo-fs");
 	blockdev_mnt = kern_mount(&bd_type);
 	if (IS_ERR(blockdev_mnt))
 		panic("Cannot create bdev pseudo-fs");


