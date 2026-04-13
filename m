Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EBB279DC2;
	Mon, 13 Apr 2026 16:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096315; cv=none; b=FGmj/wtOtSY9kCl4Xo+f0Gri3PRBHgZS3axSu/f1WdwQ6M72vaBuxA9QsTeZHulCuDSXdaoLxiQeiUizFDeWhbaa/3CatpeOJRbIYkOfZ303JHxSs14xrffVBodFC6E5/KjjAOyKQR3E7+ymvaeMDg/+j6tJ0dvAOcaQm/w0sHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096315; c=relaxed/simple;
	bh=XK5T++VibeKtS6u6KdXhFtEqfaaIeC/An95g6MJMs80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwF/PsN86x5mzfJBBGxsxIKVZLpq/vriksrqToQfeOZNgM1uF1G6ZYtS19UC/7RHBcSybRH7Jx3AwH2+B5sjhErWg8w1cmByQqOIzc/+OJyORn/DDVDw5wqgh7Lko+XTV8ici/Htji5px51Eil8qdwqSsra3PQZoZ1gA8UWwk4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eltdBKhD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eltdBKhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF6CC2BCAF;
	Mon, 13 Apr 2026 16:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096315;
	bh=XK5T++VibeKtS6u6KdXhFtEqfaaIeC/An95g6MJMs80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eltdBKhDryJNm6G+4r91Cj/F3qrXr/4nk455TMH0XB6cyQiYj1P+NX8ZvAuH+BaR/
	 0SX1CU3+uWaOIfjIqi2kW2HZhHb7loOC1Plr+PW3aaa1iLrgFQJPe+yGv5ZDOprDjz
	 012LB3++qqgvv0tQxyFJNrbGJ2xLll88D2OgXh9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.19 50/86] mm/vma: fix memory leak in __mmap_region()
Date: Mon, 13 Apr 2026 17:59:57 +0200
Message-ID: <20260413155733.436077701@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sechang Lim <rhkrqnwk98@gmail.com>

commit 894f99eb535edc4514f756818f3c4f688ba53a59 upstream.

commit 605f6586ecf7 ("mm/vma: do not leak memory when .mmap_prepare
swaps the file") handled the success path by skipping get_file() via
file_doesnt_need_get, but missed the error path.

When /dev/zero is mmap'd with MAP_SHARED, mmap_zero_prepare() calls
shmem_zero_setup_desc() which allocates a new shmem file to back the
mapping. If __mmap_new_vma() subsequently fails, this replacement
file is never fput()'d - the original is released by
ksys_mmap_pgoff(), but nobody releases the new one.

Add fput() for the swapped file in the error path.

Reproducible with fault injection.

FAULT_INJECTION: forcing a failure.
name failslab, interval 1, probability 0, space 0, times 1
CPU: 2 UID: 0 PID: 366 Comm: syz.7.14 Not tainted 7.0.0-rc6 #2 PREEMPT(full)
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x164/0x1f0
 should_fail_ex+0x525/0x650
 should_failslab+0xdf/0x140
 kmem_cache_alloc_noprof+0x78/0x630
 vm_area_alloc+0x24/0x160
 __mmap_region+0xf6b/0x2660
 mmap_region+0x2eb/0x3a0
 do_mmap+0xc79/0x1240
 vm_mmap_pgoff+0x252/0x4c0
 ksys_mmap_pgoff+0xf8/0x120
 __x64_sys_mmap+0x12a/0x190
 do_syscall_64+0xa9/0x580
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
 </TASK>

kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
BUG: memory leak
unreferenced object 0xffff8881118aca80 (size 360):
  comm "syz.7.14", pid 366, jiffies 4294913255
  hex dump (first 32 bytes):
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
    ff ff ff ff ff ff ff ff c0 28 4d ae ff ff ff ff  .........(M.....
  backtrace (crc db0f53bc):
    kmem_cache_alloc_noprof+0x3ab/0x630
    alloc_empty_file+0x5a/0x1e0
    alloc_file_pseudo+0x135/0x220
    __shmem_file_setup+0x274/0x420
    shmem_zero_setup_desc+0x9c/0x170
    mmap_zero_prepare+0x123/0x140
    __mmap_region+0xdda/0x2660
    mmap_region+0x2eb/0x3a0
    do_mmap+0xc79/0x1240
    vm_mmap_pgoff+0x252/0x4c0
    ksys_mmap_pgoff+0xf8/0x120
    __x64_sys_mmap+0x12a/0x190
    do_syscall_64+0xa9/0x580
    entry_SYSCALL_64_after_hwframe+0x76/0x7e

Found by syzkaller.

Link: https://lkml.kernel.org/r/20260331180811.1333348-1-rhkrqnwk98@gmail.com
Fixes: 605f6586ecf7 ("mm/vma: do not leak memory when .mmap_prepare swaps the file")
Signed-off-by: Sechang Lim <rhkrqnwk98@gmail.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vma.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2774,6 +2774,13 @@ unacct_error:
 	if (map.charged)
 		vm_unacct_memory(map.charged);
 abort_munmap:
+	/*
+	 * This indicates that .mmap_prepare has set a new file, differing from
+	 * desc->vm_file. But since we're aborting the operation, only the
+	 * original file will be cleaned up. Ensure we clean up both.
+	 */
+	if (map.file_doesnt_need_get)
+		fput(map.file);
 	vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
 	return error;
 }


