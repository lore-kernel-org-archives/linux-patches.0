Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0C91B4C4E;
	Tue, 27 Aug 2024 15:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771012; cv=none; b=X/55Ugwwtxf1URzot8mNet3z6AnhOoRmQsiGSTe7sclHB+w/h2+zM2AMvZEf6RRqOnrIDCM29cIjVXxjkM/WfAsn1YlkRzCfAuMXkZzKwtHPuMG1HV9W/Nk9CvubkH4hzYEO3Lny+5TUe4eUyTfY+PUNjUO3PZDJDHDYSmHpw14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771012; c=relaxed/simple;
	bh=HscT6FzO6yqkdfVDb4caFwTuxDQrOaOF6kph0fIFn2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pM4AAhgPl10qb2O2RKjnlC9fBhViINw2i+K4eJmrZCTRQZCKXOOQgxmTmzTb0V1etcLZthBLY041Gj/afWR37tkwZlBSb/1/SbSnZbZgYTpl74Y7dR0O4CndaUrdZMv7h0AOEXr1xCWp7feXm/7vwgNbc2/5sQ2Ac4ORLNb1n00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IaGe13N0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IaGe13N0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D5AC61049;
	Tue, 27 Aug 2024 15:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771012;
	bh=HscT6FzO6yqkdfVDb4caFwTuxDQrOaOF6kph0fIFn2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IaGe13N0hM3xcc90HJ8p8GTuDMg6PsBgxqoKIOoa7aSLLkCBnxha/OCkI4qI67h6R
	 P5Zh8nuaWYlOx7IFts82TYToxLIRwhC35cllrE835l1tkA29Of3tl2IfiVXAtRtIRy
	 B8bkATFEaIDfd8NiRKhvlNquK9fxEVgRJP36jDSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zi Yan <ziy@nvidia.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Mel Gorman <mgorman@suse.de>,
	Yang Shi <shy828301@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 059/273] mm/numa: no task_numa_fault() call if PTE is changed
Date: Tue, 27 Aug 2024 16:36:23 +0200
Message-ID: <20240827143835.647803770@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zi Yan <ziy@nvidia.com>

commit 40b760cfd44566bca791c80e0720d70d75382b84 upstream.

When handling a numa page fault, task_numa_fault() should be called by a
process that restores the page table of the faulted folio to avoid
duplicated stats counting.  Commit b99a342d4f11 ("NUMA balancing: reduce
TLB flush via delaying mapping on hint page fault") restructured
do_numa_page() and did not avoid task_numa_fault() call in the second page
table check after a numa migration failure.  Fix it by making all
!pte_same() return immediately.

This issue can cause task_numa_fault() being called more than necessary
and lead to unexpected numa balancing results (It is hard to tell whether
the issue will cause positive or negative performance impact due to
duplicated numa fault counting).

Link: https://lkml.kernel.org/r/20240809145906.1513458-2-ziy@nvidia.com
Fixes: b99a342d4f11 ("NUMA balancing: reduce TLB flush via delaying mapping on hint page fault")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: "Huang, Ying" <ying.huang@intel.com>
Closes: https://lore.kernel.org/linux-mm/87zfqfw0yw.fsf@yhuang6-desk2.ccr.corp.intel.com/
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5155,7 +5155,7 @@ static vm_fault_t do_numa_page(struct vm
 
 	if (unlikely(!pte_same(old_pte, vmf->orig_pte))) {
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		goto out;
+		return 0;
 	}
 
 	pte = pte_modify(old_pte, vma->vm_page_prot);
@@ -5218,23 +5218,19 @@ static vm_fault_t do_numa_page(struct vm
 	if (!migrate_misplaced_folio(folio, vma, target_nid)) {
 		nid = target_nid;
 		flags |= TNF_MIGRATED;
-	} else {
-		flags |= TNF_MIGRATE_FAIL;
-		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
-					       vmf->address, &vmf->ptl);
-		if (unlikely(!vmf->pte))
-			goto out;
-		if (unlikely(!pte_same(ptep_get(vmf->pte), vmf->orig_pte))) {
-			pte_unmap_unlock(vmf->pte, vmf->ptl);
-			goto out;
-		}
-		goto out_map;
+		task_numa_fault(last_cpupid, nid, nr_pages, flags);
+		return 0;
 	}
 
-out:
-	if (nid != NUMA_NO_NODE)
-		task_numa_fault(last_cpupid, nid, nr_pages, flags);
-	return 0;
+	flags |= TNF_MIGRATE_FAIL;
+	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
+				       vmf->address, &vmf->ptl);
+	if (unlikely(!vmf->pte))
+		return 0;
+	if (unlikely(!pte_same(ptep_get(vmf->pte), vmf->orig_pte))) {
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		return 0;
+	}
 out_map:
 	/*
 	 * Make it present again, depending on how arch implements
@@ -5247,7 +5243,10 @@ out_map:
 		numa_rebuild_single_mapping(vmf, vma, vmf->address, vmf->pte,
 					    writable);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
-	goto out;
+
+	if (nid != NUMA_NO_NODE)
+		task_numa_fault(last_cpupid, nid, nr_pages, flags);
+	return 0;
 }
 
 static inline vm_fault_t create_huge_pmd(struct vm_fault *vmf)


