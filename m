Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E1C14A4EE;
	Tue, 23 Apr 2024 21:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908751; cv=none; b=RHzBMKQjboe3X6NM569CSYOORghoFIrQFWxFD8m51Z2iLtBqx4qXPHQZPyc44DVnqMcF3m5k7V0hy5XgNvLC6/BDkhXsXOaUPC3LOlzY0RqhkwNerKTSAphGuBb3WT2gHrAXbH+WQq7B40e2r+S9ngrNyELj5CTNWb5uOa6DMFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908751; c=relaxed/simple;
	bh=3KqcZfBa1r4VPdQqy3EH0Ou4EHcuJO32t4/gF5F9FJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhG0Mf5yPu21wJBBXRpYi46zzNKpf8+gvR/3iojFFV12cw0pns8xLTeDvYnQ0fG3edJduV6m0NIdDh2PiTC/k6jLOaRE6y9chpE1o+7dDnsPEra1e4C/f6kKOlq0pUP6vZpgLkUuyolhGd5jax0UrIdE8bNK7e++E3XEB0+FdRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9DE1+US; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9DE1+US"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274C7C3277B;
	Tue, 23 Apr 2024 21:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908751;
	bh=3KqcZfBa1r4VPdQqy3EH0Ou4EHcuJO32t4/gF5F9FJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9DE1+USXwRpMWb/uT3cqS9FoMtHP7zySLMGeUNgGQzSVCcwJlXu3a0mx6ypBB0+8
	 qIMgpg5JSiwKWJTC+KlLGg9iUK8ERNK+n8mO12XfceNc64ZdAdcmsClwsEhsMTk1Y2
	 0X6xMWBY9dUPbPncOI1xeWTOFMhg/r02yxROCquo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaohe Lin <linmiaohe@huawei.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jane Chu <jane.chu@oracle.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 126/141] mm/memory-failure: fix deadlock when hugetlb_optimize_vmemmap is enabled
Date: Tue, 23 Apr 2024 14:39:54 -0700
Message-ID: <20240423213857.298565951@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

From: Miaohe Lin <linmiaohe@huawei.com>

commit 1983184c22dd84a4d95a71e5c6775c2638557dc7 upstream.

When I did hard offline test with hugetlb pages, below deadlock occurs:

======================================================
WARNING: possible circular locking dependency detected
6.8.0-11409-gf6cef5f8c37f #1 Not tainted
------------------------------------------------------
bash/46904 is trying to acquire lock:
ffffffffabe68910 (cpu_hotplug_lock){++++}-{0:0}, at: static_key_slow_dec+0x16/0x60

but task is already holding lock:
ffffffffabf92ea8 (pcp_batch_high_lock){+.+.}-{3:3}, at: zone_pcp_disable+0x16/0x40

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (pcp_batch_high_lock){+.+.}-{3:3}:
       __mutex_lock+0x6c/0x770
       page_alloc_cpu_online+0x3c/0x70
       cpuhp_invoke_callback+0x397/0x5f0
       __cpuhp_invoke_callback_range+0x71/0xe0
       _cpu_up+0xeb/0x210
       cpu_up+0x91/0xe0
       cpuhp_bringup_mask+0x49/0xb0
       bringup_nonboot_cpus+0xb7/0xe0
       smp_init+0x25/0xa0
       kernel_init_freeable+0x15f/0x3e0
       kernel_init+0x15/0x1b0
       ret_from_fork+0x2f/0x50
       ret_from_fork_asm+0x1a/0x30

-> #0 (cpu_hotplug_lock){++++}-{0:0}:
       __lock_acquire+0x1298/0x1cd0
       lock_acquire+0xc0/0x2b0
       cpus_read_lock+0x2a/0xc0
       static_key_slow_dec+0x16/0x60
       __hugetlb_vmemmap_restore_folio+0x1b9/0x200
       dissolve_free_huge_page+0x211/0x260
       __page_handle_poison+0x45/0xc0
       memory_failure+0x65e/0xc70
       hard_offline_page_store+0x55/0xa0
       kernfs_fop_write_iter+0x12c/0x1d0
       vfs_write+0x387/0x550
       ksys_write+0x64/0xe0
       do_syscall_64+0xca/0x1e0
       entry_SYSCALL_64_after_hwframe+0x6d/0x75

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(pcp_batch_high_lock);
                               lock(cpu_hotplug_lock);
                               lock(pcp_batch_high_lock);
  rlock(cpu_hotplug_lock);

 *** DEADLOCK ***

5 locks held by bash/46904:
 #0: ffff98f6c3bb23f0 (sb_writers#5){.+.+}-{0:0}, at: ksys_write+0x64/0xe0
 #1: ffff98f6c328e488 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write_iter+0xf8/0x1d0
 #2: ffff98ef83b31890 (kn->active#113){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x100/0x1d0
 #3: ffffffffabf9db48 (mf_mutex){+.+.}-{3:3}, at: memory_failure+0x44/0xc70
 #4: ffffffffabf92ea8 (pcp_batch_high_lock){+.+.}-{3:3}, at: zone_pcp_disable+0x16/0x40

stack backtrace:
CPU: 10 PID: 46904 Comm: bash Kdump: loaded Not tainted 6.8.0-11409-gf6cef5f8c37f #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x68/0xa0
 check_noncircular+0x129/0x140
 __lock_acquire+0x1298/0x1cd0
 lock_acquire+0xc0/0x2b0
 cpus_read_lock+0x2a/0xc0
 static_key_slow_dec+0x16/0x60
 __hugetlb_vmemmap_restore_folio+0x1b9/0x200
 dissolve_free_huge_page+0x211/0x260
 __page_handle_poison+0x45/0xc0
 memory_failure+0x65e/0xc70
 hard_offline_page_store+0x55/0xa0
 kernfs_fop_write_iter+0x12c/0x1d0
 vfs_write+0x387/0x550
 ksys_write+0x64/0xe0
 do_syscall_64+0xca/0x1e0
 entry_SYSCALL_64_after_hwframe+0x6d/0x75
RIP: 0033:0x7fc862314887
Code: 10 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
RSP: 002b:00007fff19311268 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000000000000000c RCX: 00007fc862314887
RDX: 000000000000000c RSI: 000056405645fe10 RDI: 0000000000000001
RBP: 000056405645fe10 R08: 00007fc8623d1460 R09: 000000007fffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000000c
R13: 00007fc86241b780 R14: 00007fc862417600 R15: 00007fc862416a00

In short, below scene breaks the lock dependency chain:

 memory_failure
  __page_handle_poison
   zone_pcp_disable -- lock(pcp_batch_high_lock)
   dissolve_free_huge_page
    __hugetlb_vmemmap_restore_folio
     static_key_slow_dec
      cpus_read_lock -- rlock(cpu_hotplug_lock)

Fix this by calling drain_all_pages() instead.

This issue won't occur until commit a6b40850c442 ("mm: hugetlb: replace
hugetlb_free_vmemmap_enabled with a static_key").  As it introduced
rlock(cpu_hotplug_lock) in dissolve_free_huge_page() code path while
lock(pcp_batch_high_lock) is already in the __page_handle_poison().

[linmiaohe@huawei.com: extend comment per Oscar]
[akpm@linux-foundation.org: reflow block comment]
Link: https://lkml.kernel.org/r/20240407085456.2798193-1-linmiaohe@huawei.com
Fixes: a6b40850c442 ("mm: hugetlb: replace hugetlb_free_vmemmap_enabled with a static_key")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -84,11 +84,23 @@ static int __page_handle_poison(struct p
 {
 	int ret;
 
-	zone_pcp_disable(page_zone(page));
+	/*
+	 * zone_pcp_disable() can't be used here. It will
+	 * hold pcp_batch_high_lock and dissolve_free_huge_page() might hold
+	 * cpu_hotplug_lock via static_key_slow_dec() when hugetlb vmemmap
+	 * optimization is enabled. This will break current lock dependency
+	 * chain and leads to deadlock.
+	 * Disabling pcp before dissolving the page was a deterministic
+	 * approach because we made sure that those pages cannot end up in any
+	 * PCP list. Draining PCP lists expels those pages to the buddy system,
+	 * but nothing guarantees that those pages do not get back to a PCP
+	 * queue if we need to refill those.
+	 */
 	ret = dissolve_free_huge_page(page);
-	if (!ret)
+	if (!ret) {
+		drain_all_pages(page_zone(page));
 		ret = take_page_off_buddy(page);
-	zone_pcp_enable(page_zone(page));
+	}
 
 	return ret;
 }


