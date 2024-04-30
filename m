Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8557D12D1FC;
	Tue, 30 Apr 2024 10:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474419; cv=none; b=u/3jKgj9lUqsnjNhem50IsuRVV0wENAkL3IsIRLE9k0XqV4KBri9SzSHmMuHTke/6g6yhZilkI/zfOIbxF3k+wh49+7JIAYfP89g06FudSttvdbWPG5QiQO2sSYnz2OVWof1cRvvFYRVa2s3IOaeG4mUb8jGdyMhTvgxuZe5sEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474419; c=relaxed/simple;
	bh=y4Ax/xzXKTciaY4SJR2CGX9K2sDufgnaAPXxfBYrI7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJCpK4m4+w87O5YsbvLBKc7/FSSYs99Z9Afrx0bM1Mc8NDfYIolkFiUu1Fbk57Iiodi25vKLEUKTp7IB2fYyhn80pUPOBDizxFPpADQb1fVbux4cgM7gsekyDZzAy7DkzQauivmglGJupGX/tPQPb63+kF/iFzmCbBwhceQRZak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xr8aMMVj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xr8aMMVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07491C2BBFC;
	Tue, 30 Apr 2024 10:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474419;
	bh=y4Ax/xzXKTciaY4SJR2CGX9K2sDufgnaAPXxfBYrI7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xr8aMMVjmxmlJMPgb70Vr/p/rGSgdfHHF2jp3+ZY4WijKRUbtAC9qt8tvMBNYmNA8
	 T1hgUcMiX6X4SSINT7B8qU4pWb0aKS3LieeqjuJjdMUa6EvsyqzSkeQA3JCXRA1pCq
	 gW58ANh5f7nmFz4fFQlKB6NTEOCw8XTzzc43fjAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaohe Lin <linmiaohe@huawei.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.8 152/228] mm/hugetlb: fix DEBUG_LOCKS_WARN_ON(1) when dissolve_free_hugetlb_folio()
Date: Tue, 30 Apr 2024 12:38:50 +0200
Message-ID: <20240430103108.193106524@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaohe Lin <linmiaohe@huawei.com>

commit 52ccdde16b6540abe43b6f8d8e1e1ec90b0983af upstream.

When I did memory failure tests recently, below warning occurs:

DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 8 PID: 1011 at kernel/locking/lockdep.c:232 __lock_acquire+0xccb/0x1ca0
Modules linked in: mce_inject hwpoison_inject
CPU: 8 PID: 1011 Comm: bash Kdump: loaded Not tainted 6.9.0-rc3-next-20240410-00012-gdb69f219f4be #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
RIP: 0010:__lock_acquire+0xccb/0x1ca0
RSP: 0018:ffffa7a1c7fe3bd0 EFLAGS: 00000082
RAX: 0000000000000000 RBX: eb851eb853975fcf RCX: ffffa1ce5fc1c9c8
RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffffa1ce5fc1c9c0
RBP: ffffa1c6865d3280 R08: ffffffffb0f570a8 R09: 0000000000009ffb
R10: 0000000000000286 R11: ffffffffb0f2ad50 R12: ffffa1c6865d3d10
R13: ffffa1c6865d3c70 R14: 0000000000000000 R15: 0000000000000004
FS:  00007ff9f32aa740(0000) GS:ffffa1ce5fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff9f3134ba0 CR3: 00000008484e4000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 lock_acquire+0xbe/0x2d0
 _raw_spin_lock_irqsave+0x3a/0x60
 hugepage_subpool_put_pages.part.0+0xe/0xc0
 free_huge_folio+0x253/0x3f0
 dissolve_free_huge_page+0x147/0x210
 __page_handle_poison+0x9/0x70
 memory_failure+0x4e6/0x8c0
 hard_offline_page_store+0x55/0xa0
 kernfs_fop_write_iter+0x12c/0x1d0
 vfs_write+0x380/0x540
 ksys_write+0x64/0xe0
 do_syscall_64+0xbc/0x1d0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff9f3114887
RSP: 002b:00007ffecbacb458 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000000000000000c RCX: 00007ff9f3114887
RDX: 000000000000000c RSI: 0000564494164e10 RDI: 0000000000000001
RBP: 0000564494164e10 R08: 00007ff9f31d1460 R09: 000000007fffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000000c
R13: 00007ff9f321b780 R14: 00007ff9f3217600 R15: 00007ff9f3216a00
 </TASK>
Kernel panic - not syncing: kernel: panic_on_warn set ...
CPU: 8 PID: 1011 Comm: bash Kdump: loaded Not tainted 6.9.0-rc3-next-20240410-00012-gdb69f219f4be #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 panic+0x326/0x350
 check_panic_on_warn+0x4f/0x50
 __warn+0x98/0x190
 report_bug+0x18e/0x1a0
 handle_bug+0x3d/0x70
 exc_invalid_op+0x18/0x70
 asm_exc_invalid_op+0x1a/0x20
RIP: 0010:__lock_acquire+0xccb/0x1ca0
RSP: 0018:ffffa7a1c7fe3bd0 EFLAGS: 00000082
RAX: 0000000000000000 RBX: eb851eb853975fcf RCX: ffffa1ce5fc1c9c8
RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffffa1ce5fc1c9c0
RBP: ffffa1c6865d3280 R08: ffffffffb0f570a8 R09: 0000000000009ffb
R10: 0000000000000286 R11: ffffffffb0f2ad50 R12: ffffa1c6865d3d10
R13: ffffa1c6865d3c70 R14: 0000000000000000 R15: 0000000000000004
 lock_acquire+0xbe/0x2d0
 _raw_spin_lock_irqsave+0x3a/0x60
 hugepage_subpool_put_pages.part.0+0xe/0xc0
 free_huge_folio+0x253/0x3f0
 dissolve_free_huge_page+0x147/0x210
 __page_handle_poison+0x9/0x70
 memory_failure+0x4e6/0x8c0
 hard_offline_page_store+0x55/0xa0
 kernfs_fop_write_iter+0x12c/0x1d0
 vfs_write+0x380/0x540
 ksys_write+0x64/0xe0
 do_syscall_64+0xbc/0x1d0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff9f3114887
RSP: 002b:00007ffecbacb458 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000000000000000c RCX: 00007ff9f3114887
RDX: 000000000000000c RSI: 0000564494164e10 RDI: 0000000000000001
RBP: 0000564494164e10 R08: 00007ff9f31d1460 R09: 000000007fffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000000c
R13: 00007ff9f321b780 R14: 00007ff9f3217600 R15: 00007ff9f3216a00
 </TASK>

After git bisecting and digging into the code, I believe the root cause is
that _deferred_list field of folio is unioned with _hugetlb_subpool field.
In __update_and_free_hugetlb_folio(), folio->_deferred_list is
initialized leading to corrupted folio->_hugetlb_subpool when folio is
hugetlb.  Later free_huge_folio() will use _hugetlb_subpool and above
warning happens.

But it is assumed hugetlb flag must have been cleared when calling
folio_put() in update_and_free_hugetlb_folio().  This assumption is broken
due to below race:

CPU1					CPU2
dissolve_free_huge_page			update_and_free_pages_bulk
 update_and_free_hugetlb_folio		 hugetlb_vmemmap_restore_folios
					  folio_clear_hugetlb_vmemmap_optimized
  clear_flag = folio_test_hugetlb_vmemmap_optimized
  if (clear_flag) <-- False, it's already cleared.
   __folio_clear_hugetlb(folio) <-- Hugetlb is not cleared.
  folio_put
   free_huge_folio <-- free_the_page is expected.
					 list_for_each_entry()
					  __folio_clear_hugetlb <-- Too late.

Fix this issue by checking whether folio is hugetlb directly instead of
checking clear_flag to close the race window.

Link: https://lkml.kernel.org/r/20240419085819.1901645-1-linmiaohe@huawei.com
Fixes: 32c877191e02 ("hugetlb: do not clear hugetlb dtor until allocating vmemmap")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1780,7 +1780,7 @@ static void __update_and_free_hugetlb_fo
 	 * If vmemmap pages were allocated above, then we need to clear the
 	 * hugetlb destructor under the hugetlb lock.
 	 */
-	if (clear_dtor) {
+	if (folio_test_hugetlb(folio)) {
 		spin_lock_irq(&hugetlb_lock);
 		__clear_hugetlb_destructor(h, folio);
 		spin_unlock_irq(&hugetlb_lock);


