Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0DF926AC1;
	Sun,  1 Sep 2024 17:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210397; cv=none; b=aThTkuDvnZFxZNJuInRPc3k59/7cbhvLCdMfgLTATiJ7KIF+RlC1UfB9WezcbhmiYvQ4frODtHtuYYAjrgSva7U3JxUyL4uwpBKJv1ez9ODQr8L1p4EYgABXvGiUW1NCIEKQ0+LQlkgfHctk7dyBjgZ3sRXCu9GwBkWKz4AKgKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210397; c=relaxed/simple;
	bh=/c8Cd7v5mzTjwq108SUYXf+i+ncrhZOkOTpkpRiWGjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbT4UDYZ5RXnF+khLT9wBgXO4pOBs8pjE6tALgW7KgLkzru1wNydwRWmwSxZHP/qrRXtTekIkyoLhZKHph1pJvZJqjYlgpV035+d9DTlPEP78JtSHpHOcXyAN/Ozl/CD4s/tZv4ptd8gTpx9TQBNr+XjM5goANaHWAQxfoiTtVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BG8jZD2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BG8jZD2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166A3C4CEC3;
	Sun,  1 Sep 2024 17:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210397;
	bh=/c8Cd7v5mzTjwq108SUYXf+i+ncrhZOkOTpkpRiWGjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BG8jZD2+QRyo/U3PpxPGT85XtxYMpZiekSOtiy4GgCEdfCZXa8tdHd454rAh9IfpQ
	 SoXfy/6PW3U1GAIl+98CLpmO4t5mSUjHWFT69ykdW1Y8FRnjsoZwgkCNZ3+KRo8AzD
	 U6rU+5eiFedU8+/qZGssgeX1dJD5aKW2wc0FMaeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Huang, Ying" <ying.huang@intel.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Mel Gorman <mgorman@suse.de>,
	Yang Shi <shy828301@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 170/215] mm/numa: no task_numa_fault() call if PMD is changed
Date: Sun,  1 Sep 2024 18:18:02 +0200
Message-ID: <20240901160829.788225429@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zi Yan <ziy@nvidia.com>

commit fd8c35a92910f4829b7c99841f39b1b952c259d5 upstream.

When handling a numa page fault, task_numa_fault() should be called by a
process that restores the page table of the faulted folio to avoid
duplicated stats counting.  Commit c5b5a3dd2c1f ("mm: thp: refactor NUMA
fault handling") restructured do_huge_pmd_numa_page() and did not avoid
task_numa_fault() call in the second page table check after a numa
migration failure.  Fix it by making all !pmd_same() return immediately.

This issue can cause task_numa_fault() being called more than necessary
and lead to unexpected numa balancing results (It is hard to tell whether
the issue will cause positive or negative performance impact due to
duplicated numa fault counting).

Link: https://lkml.kernel.org/r/20240809145906.1513458-3-ziy@nvidia.com
Fixes: c5b5a3dd2c1f ("mm: thp: refactor NUMA fault handling")
Reported-by: "Huang, Ying" <ying.huang@intel.com>
Closes: https://lore.kernel.org/linux-mm/87zfqfw0yw.fsf@yhuang6-desk2.ccr.corp.intel.com/
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1437,7 +1437,7 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
 	if (unlikely(!pmd_same(oldpmd, *vmf->pmd))) {
 		spin_unlock(vmf->ptl);
-		goto out;
+		return 0;
 	}
 
 	pmd = pmd_modify(oldpmd, vma->vm_page_prot);
@@ -1465,23 +1465,16 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	if (migrated) {
 		flags |= TNF_MIGRATED;
 		page_nid = target_nid;
-	} else {
-		flags |= TNF_MIGRATE_FAIL;
-		vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
-		if (unlikely(!pmd_same(oldpmd, *vmf->pmd))) {
-			spin_unlock(vmf->ptl);
-			goto out;
-		}
-		goto out_map;
+		task_numa_fault(last_cpupid, page_nid, HPAGE_PMD_NR, flags);
+		return 0;
 	}
 
-out:
-	if (page_nid != NUMA_NO_NODE)
-		task_numa_fault(last_cpupid, page_nid, HPAGE_PMD_NR,
-				flags);
-
-	return 0;
-
+	flags |= TNF_MIGRATE_FAIL;
+	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
+	if (unlikely(!pmd_same(oldpmd, *vmf->pmd))) {
+		spin_unlock(vmf->ptl);
+		return 0;
+	}
 out_map:
 	/* Restore the PMD */
 	pmd = pmd_modify(oldpmd, vma->vm_page_prot);
@@ -1491,7 +1484,10 @@ out_map:
 	set_pmd_at(vma->vm_mm, haddr, vmf->pmd, pmd);
 	update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
 	spin_unlock(vmf->ptl);
-	goto out;
+
+	if (page_nid != NUMA_NO_NODE)
+		task_numa_fault(last_cpupid, page_nid, HPAGE_PMD_NR, flags);
+	return 0;
 }
 
 /*


