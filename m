Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B84261B70;
	Tue, 17 Feb 2026 20:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361687; cv=none; b=ZcVNNWFSd2djxqO9l08P/hNLVA9aEPCSfhco/Ni0ov/p7/6Jq6F9RQtlWuecVjTpM/8QWigjMNpXZzLOtcEcaD9p48b+Dg3FmL/SlQO+UZyCLpHb9iNQUo6sOz8JWFzySB2d+qBZNVk9ZdMZ3YS4ccCNIxoZkma7+L8y0bK4ZQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361687; c=relaxed/simple;
	bh=jamRYiENhsiSj+NPjiVDWuY3UajRzBh9tjUR9yvd/KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qEK52o1swiloN931icCn0/0Fqp+J4Q+1gQ7AVrq2di5yzbJ9VPNQSYTq2nh7N0VJdm7bfCEDRDrTk31vnHxQq6zdj/v7mfUpvp+ObnnYEL0UmDQd/R58BheXO5cjcDwh3p3l2tyUq19A0poUGpZfSRtSTRIcnVZrUPsHWiyv7H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjvuaF+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjvuaF+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898F9C4CEF7;
	Tue, 17 Feb 2026 20:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361687;
	bh=jamRYiENhsiSj+NPjiVDWuY3UajRzBh9tjUR9yvd/KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjvuaF+OQoFxOPw1WryVd7Kfk7L5MbwdM8pI7wHPFlSc6UgMUcLaOjAlIDWylz5xz
	 q1Em5GDXZWB4fgWaYtq2+BcYWZsAe4RXWrKt/NpCZ1NqxN46mLHTIxW1fGJQretmZS
	 6ifBNScV+Vc/70Hj54fJWScqO4xGgXJjPbgDARzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jane Chu <jane.chu@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	Jann Horn <jannh@google.com>,
	Liu Shixin <liushixin2@huawei.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 6.12 26/42] mm/hugetlb: fix copy_hugetlb_page_range() to use ->pt_share_count
Date: Tue, 17 Feb 2026 21:32:17 +0100
Message-ID: <20260217200006.999572486@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>
References: <20260217200005.998240758@linuxfoundation.org>
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

From: Jane Chu <jane.chu@oracle.com>

commit 14967a9c7d247841b0312c48dcf8cd29e55a4cc8 upstream.

commit 59d9094df3d79 ("mm: hugetlb: independent PMD page table shared
count") introduced ->pt_share_count dedicated to hugetlb PMD share count
tracking, but omitted fixing copy_hugetlb_page_range(), leaving the
function relying on page_count() for tracking that no longer works.

When lazy page table copy for hugetlb is disabled, that is, revert commit
bcd51a3c679d ("hugetlb: lazy page table copies in fork()") fork()'ing with
hugetlb PMD sharing quickly lockup -

[  239.446559] watchdog: BUG: soft lockup - CPU#75 stuck for 27s!
[  239.446611] RIP: 0010:native_queued_spin_lock_slowpath+0x7e/0x2e0
[  239.446631] Call Trace:
[  239.446633]  <TASK>
[  239.446636]  _raw_spin_lock+0x3f/0x60
[  239.446639]  copy_hugetlb_page_range+0x258/0xb50
[  239.446645]  copy_page_range+0x22b/0x2c0
[  239.446651]  dup_mmap+0x3e2/0x770
[  239.446654]  dup_mm.constprop.0+0x5e/0x230
[  239.446657]  copy_process+0xd17/0x1760
[  239.446660]  kernel_clone+0xc0/0x3e0
[  239.446661]  __do_sys_clone+0x65/0xa0
[  239.446664]  do_syscall_64+0x82/0x930
[  239.446668]  ? count_memcg_events+0xd2/0x190
[  239.446671]  ? syscall_trace_enter+0x14e/0x1f0
[  239.446676]  ? syscall_exit_work+0x118/0x150
[  239.446677]  ? arch_exit_to_user_mode_prepare.constprop.0+0x9/0xb0
[  239.446681]  ? clear_bhb_loop+0x30/0x80
[  239.446684]  ? clear_bhb_loop+0x30/0x80
[  239.446686]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

There are two options to resolve the potential latent issue:
  1. warn against PMD sharing in copy_hugetlb_page_range(),
  2. fix it.
This patch opts for the second option.
While at it, simplify the comment, the details are not actually relevant
anymore.

Link: https://lkml.kernel.org/r/20250916004520.1604530-1-jane.chu@oracle.com
Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm_types.h |    5 +++++
 mm/hugetlb.c             |   15 +++++----------
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -540,6 +540,11 @@ static inline int ptdesc_pmd_pts_count(s
 {
 	return atomic_read(&ptdesc->pt_share_count);
 }
+
+static inline bool ptdesc_pmd_is_shared(struct ptdesc *ptdesc)
+{
+	return !!ptdesc_pmd_pts_count(ptdesc);
+}
 #else
 static inline void ptdesc_pmd_pts_init(struct ptdesc *ptdesc)
 {
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5258,18 +5258,13 @@ int copy_hugetlb_page_range(struct mm_st
 			break;
 		}
 
-		/*
-		 * If the pagetables are shared don't copy or take references.
-		 *
-		 * dst_pte == src_pte is the common case of src/dest sharing.
-		 * However, src could have 'unshared' and dst shares with
-		 * another vma. So page_count of ptep page is checked instead
-		 * to reliably determine whether pte is shared.
-		 */
-		if (page_count(virt_to_page(dst_pte)) > 1) {
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
+		/* If the pagetables are shared, there is nothing to do */
+		if (ptdesc_pmd_is_shared(virt_to_ptdesc(dst_pte))) {
 			addr |= last_addr_mask;
 			continue;
 		}
+#endif
 
 		dst_ptl = huge_pte_lock(h, dst, dst_pte);
 		src_ptl = huge_pte_lockptr(h, src, src_pte);
@@ -7270,7 +7265,7 @@ int huge_pmd_unshare(struct mm_struct *m
 	hugetlb_vma_assert_locked(vma);
 	if (sz != PMD_SIZE)
 		return 0;
-	if (!ptdesc_pmd_pts_count(virt_to_ptdesc(ptep)))
+	if (!ptdesc_pmd_is_shared(virt_to_ptdesc(ptep)))
 		return 0;
 
 	pud_clear(pud);


