Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDEE2494F0;
	Wed,  8 Apr 2026 18:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672714; cv=none; b=QkuHy9ybUS5JI1LNqXrkAhQzuZ2sKlMNN489aH/Prl9RQQvLyAR8hY2bpgV2y6D+HJIlZI83kYfqlC1A2/SLMKNHWbhLfw+fT/KCphgh9BFjyxerHFusj2wF6IO6SEhHRQ5kr3SUQFkf/LUKOF5xNF+eVF/EPGql3n14rSV1Gpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672714; c=relaxed/simple;
	bh=rSjvwX8l8dN8EVpghN1rEpgXDOA78g16N6zqgtZ8ZJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HymFkFKt1l1ARPK6+NhFApvNKXlE9jNt1FbDrWfmmxWLuz3Cn00K4QlWVTbmeHSp1ygKgwQle3aWt4t0SZ36mK1s0S4d1r2gihsS09DwbVPAn2U4OOEPQpS8NE8LA/sTedN849FKS7kgMusTyzCjMY/6J+LcgDhF1czm/PXGpiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q7hhxRvw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q7hhxRvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710E9C19421;
	Wed,  8 Apr 2026 18:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672713;
	bh=rSjvwX8l8dN8EVpghN1rEpgXDOA78g16N6zqgtZ8ZJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q7hhxRvwGIYf68Fpz1RtwWy1gnRTvJkFHbxCx9El/cB1N56juAe1aIIrC53B+9rVW
	 NWTrwMovR2TSTy4P9a5hlCbj3KB0mEuErjTHT+wnJBKfTsj0Qzr153q9wdMo3QaPtn
	 4pSct3Ok13dXq1TluFn++UcO5AOzCNkPXC/EHKRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaohe Lin <linmiaohe@huawei.com>,
	Thorvald Natvig <thorvald@google.com>,
	Jane Chu <jane.chu@oracle.com>,
	Christian Brauner <brauner@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oleg Nesterov <oleg@redhat.com>,
	Peng Zhang <zhangpeng.00@bytedance.com>,
	Tycho Andersen <tandersen@netflix.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?UTF-8?q?David=20Nystr=C3=B6m?= <david.nystrom@est.tech>,
	Tugrul Kukul <tugrul.kukul@est.tech>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/160] fork: defer linking file vma until vma is fully initialized
Date: Wed,  8 Apr 2026 20:03:21 +0200
Message-ID: <20260408175917.445234207@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit 35e351780fa9d8240dd6f7e4f245f9ea37e96c19 ]

Thorvald reported a WARNING [1]. And the root cause is below race:

 CPU 1					CPU 2
 fork					hugetlbfs_fallocate
  dup_mmap				 hugetlbfs_punch_hole
   i_mmap_lock_write(mapping);
   vma_interval_tree_insert_after -- Child vma is visible through i_mmap tree.
   i_mmap_unlock_write(mapping);
   hugetlb_dup_vma_private -- Clear vma_lock outside i_mmap_rwsem!
					 i_mmap_lock_write(mapping);
   					 hugetlb_vmdelete_list
					  vma_interval_tree_foreach
					   hugetlb_vma_trylock_write -- Vma_lock is cleared.
   tmp->vm_ops->open -- Alloc new vma_lock outside i_mmap_rwsem!
					   hugetlb_vma_unlock_write -- Vma_lock is assigned!!!
					 i_mmap_unlock_write(mapping);

hugetlb_dup_vma_private() and hugetlb_vm_op_open() are called outside
i_mmap_rwsem lock while vma lock can be used in the same time.  Fix this
by deferring linking file vma until vma is fully initialized.  Those vmas
should be initialized first before they can be used.

[tk: Adapted to 6.6 stable where vma_iter_bulk_store() can fail
(unlike mainline which uses __mt_dup() for pre-allocation).
Preserved error handling via goto fail_nomem_vmi_store. Previous
backport (cec11fa2eb512) was reverted (dd782da470761) due to
xfstests failures.]

Link: https://lkml.kernel.org/r/20240410091441.3539905-1-linmiaohe@huawei.com
Fixes: 8d9bfb260814 ("hugetlb: add vma based lock for pmd sharing")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reported-by: Thorvald Natvig <thorvald@google.com>
Closes: https://lore.kernel.org/linux-mm/20240129161735.6gmjsswx62o4pbja@revolver/T/ [1]
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Tycho Andersen <tandersen@netflix.com>
Cc: stable@vger.kernel.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Claude:claude-opus-4.6
Suggested-by: David Nyström <david.nystrom@est.tech>
Signed-off-by: Tugrul Kukul <tugrul.kukul@est.tech>
Acked-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fork.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index ce6f6e1e39057..5b60692b1a4ea 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -733,6 +733,21 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
 		} else if (anon_vma_fork(tmp, mpnt))
 			goto fail_nomem_anon_vma_fork;
 		vm_flags_clear(tmp, VM_LOCKED_MASK);
+		/*
+		 * Copy/update hugetlb private vma information.
+		 */
+		if (is_vm_hugetlb_page(tmp))
+			hugetlb_dup_vma_private(tmp);
+
+		/* Link the vma into the MT */
+		if (vma_iter_bulk_store(&vmi, tmp))
+			goto fail_nomem_vmi_store;
+
+		mm->map_count++;
+
+		if (tmp->vm_ops && tmp->vm_ops->open)
+			tmp->vm_ops->open(tmp);
+
 		file = tmp->vm_file;
 		if (file) {
 			struct address_space *mapping = file->f_mapping;
@@ -749,23 +764,9 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
 			i_mmap_unlock_write(mapping);
 		}
 
-		/*
-		 * Copy/update hugetlb private vma information.
-		 */
-		if (is_vm_hugetlb_page(tmp))
-			hugetlb_dup_vma_private(tmp);
-
-		/* Link the vma into the MT */
-		if (vma_iter_bulk_store(&vmi, tmp))
-			goto fail_nomem_vmi_store;
-
-		mm->map_count++;
 		if (!(tmp->vm_flags & VM_WIPEONFORK))
 			retval = copy_page_range(tmp, mpnt);
 
-		if (tmp->vm_ops && tmp->vm_ops->open)
-			tmp->vm_ops->open(tmp);
-
 		if (retval)
 			goto loop_out;
 	}
-- 
2.53.0



