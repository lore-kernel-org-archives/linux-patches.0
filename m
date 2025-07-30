Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD9C19D065;
	Wed, 30 Jul 2025 09:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868422; cv=none; b=lN5SZnh8Q25pdmwcHq2Q5lG6YLbXSerI/lfkWIKvuIda9PDps3pRpBroi6o5AasSnpixPuXqzAhaekLwpiMDDZCNCjFeMwfUvWivGY90r8ubjjJYw0FiVXgmt3s5XXuwEaJfbzzgM1rzMQbYGJJEi4fvHKRACRYEKf0N16x38AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868422; c=relaxed/simple;
	bh=NZPvdiOPiDoDSlELa9ovJjuWGKPZKtVJLIdjXt0o544=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxnmHpZBSG6PpFEs+M42lj2FIuUSvthXIz/ozt49hxtAY1KEmEBZ9mTtEFtf21NXJu9536n6fmiBYBRbHhXQlPFfJ5pQSaM65/6TKpuNpZieMAYRz58QPluTcX0WF0pW3rkxMLTyBmIuhRjMnjJ1hMaYv6VWYQBVJISbC6o4MeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rC/2mmLr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rC/2mmLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488E4C4CEE7;
	Wed, 30 Jul 2025 09:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868421;
	bh=NZPvdiOPiDoDSlELa9ovJjuWGKPZKtVJLIdjXt0o544=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rC/2mmLrreTQQO37ECLdXwUmZNnxWRj8xWiARfyHT73Qg0J/cDUjOPmzmxaNQTlrg
	 oRvvTbsgdSIVS+dFoCeavsKAiJOxlBj7C4UQ8ll2gWP0zQB05SkWhSrK4TttYW9XXR
	 QjvmPNUhsnmSAJSSjJz+piHxy1MtyAcjCjut8J/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Shixin <liushixin2@huawei.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	David Hildenbrand <david@redhat.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Mattew Wilcox <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nanyong Sun <sunnanyong@huawei.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jakub Acs <acsjakub@amazon.de>
Subject: [PATCH 6.6 58/76] mm: khugepaged: fix call hpage_collapse_scan_file() for anonymous vma
Date: Wed, 30 Jul 2025 11:35:51 +0200
Message-ID: <20250730093229.103714119@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Shixin <liushixin2@huawei.com>

commit f1897f2f08b28ae59476d8b73374b08f856973af upstream.

syzkaller reported such a BUG_ON():

 ------------[ cut here ]------------
 kernel BUG at mm/khugepaged.c:1835!
 Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
 ...
 CPU: 6 UID: 0 PID: 8009 Comm: syz.15.106 Kdump: loaded Tainted: G        W          6.13.0-rc6 #22
 Tainted: [W]=WARN
 Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
 pstate: 00400005 (nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : collapse_file+0xa44/0x1400
 lr : collapse_file+0x88/0x1400
 sp : ffff80008afe3a60
 ...
 Call trace:
  collapse_file+0xa44/0x1400 (P)
  hpage_collapse_scan_file+0x278/0x400
  madvise_collapse+0x1bc/0x678
  madvise_vma_behavior+0x32c/0x448
  madvise_walk_vmas.constprop.0+0xbc/0x140
  do_madvise.part.0+0xdc/0x2c8
  __arm64_sys_madvise+0x68/0x88
  invoke_syscall+0x50/0x120
  el0_svc_common.constprop.0+0xc8/0xf0
  do_el0_svc+0x24/0x38
  el0_svc+0x34/0x128
  el0t_64_sync_handler+0xc8/0xd0
  el0t_64_sync+0x190/0x198

This indicates that the pgoff is unaligned.  After analysis, I confirm the
vma is mapped to /dev/zero.  Such a vma certainly has vm_file, but it is
set to anonymous by mmap_zero().  So even if it's mmapped by 2m-unaligned,
it can pass the check in thp_vma_allowable_order() as it is an
anonymous-mmap, but then be collapsed as a file-mmap.

It seems the problem has existed for a long time, but actually, since we
have khugepaged_max_ptes_none check before, we will skip collapse it as it
is /dev/zero and so has no present page.  But commit d8ea7cc8547c limit
the check for only khugepaged, so the BUG_ON() can be triggered by
madvise_collapse().

Add vma_is_anonymous() check to make such vma be processed by
hpage_collapse_scan_pmd().

Link: https://lkml.kernel.org/r/20250111034511.2223353-1-liushixin2@huawei.com
Fixes: d8ea7cc8547c ("mm/khugepaged: add flag to predicate khugepaged-only behavior")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mattew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[acsjakub: backport, clean apply]
Signed-off-by: Jakub Acs <acsjakub@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/khugepaged.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2387,7 +2387,7 @@ skip:
 			VM_BUG_ON(khugepaged_scan.address < hstart ||
 				  khugepaged_scan.address + HPAGE_PMD_SIZE >
 				  hend);
-			if (IS_ENABLED(CONFIG_SHMEM) && vma->vm_file) {
+			if (IS_ENABLED(CONFIG_SHMEM) && !vma_is_anonymous(vma)) {
 				struct file *file = get_file(vma->vm_file);
 				pgoff_t pgoff = linear_page_index(vma,
 						khugepaged_scan.address);
@@ -2734,7 +2734,7 @@ int madvise_collapse(struct vm_area_stru
 		mmap_assert_locked(mm);
 		memset(cc->node_load, 0, sizeof(cc->node_load));
 		nodes_clear(cc->alloc_nmask);
-		if (IS_ENABLED(CONFIG_SHMEM) && vma->vm_file) {
+		if (IS_ENABLED(CONFIG_SHMEM) && !vma_is_anonymous(vma)) {
 			struct file *file = get_file(vma->vm_file);
 			pgoff_t pgoff = linear_page_index(vma, addr);
 


