Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBC9234977;
	Mon, 10 Mar 2025 17:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627467; cv=none; b=qAzY9uiWsVLrti7iZALszasyM3u5nAMeiyFNzwY6uGSdTOnghX+OvSRjRK/NdoEM1LijBdrFQOPbKC7o1M1t/FLvAjSPuVxadKUVs/rmajGp20SX5SsQFh7/rIB6bZVQFbxzZJeXv+CEVUJvYVRDVwhXyjgLLe/r3qLgjt91R6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627467; c=relaxed/simple;
	bh=SqagjyT6tbaAXNj6sgBvyLb4oMO/8/bjlsesdsm1l08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bua7iV18nf4oswda1dgR2pClaQgWwg4HJ2GGhIOxdGrffM923lszOKrPYSkeitWMazrkyyIDK9ij1nhowEu6K7WroZd718Uz+kH2Hrsj9u8VyGnjYGTzL1aTSunoEE+DOvH+aLaPBhFNzp6brFFL1KRf0tI9jG95yGoY2gFuHBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z9BYWWCA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z9BYWWCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B1CC4CEE5;
	Mon, 10 Mar 2025 17:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627466;
	bh=SqagjyT6tbaAXNj6sgBvyLb4oMO/8/bjlsesdsm1l08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z9BYWWCAu01SUDFVmJhi0DMAGNhVs/veGo/xQbU7GZjhPM15bemsOEssZoxiY57ov
	 jxzmB8uYJBlcU3iY/IvePhPMI5KzV/kgqE368dIy5mMNWkGfNoZ93ebgcOLSCHXH5v
	 ZSEqc/05t9fzf7EPjetSmlP//oUfbssKUtd1A7GA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Geffon <bgeffon@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Marek Maslanka <mmaslanka@google.com>,
	Hugh Dickins <hughd@google.com>,
	David Hildenbrand <david@redhat.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Matthew Wilcow (Oracle)" <willy@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 138/269] mm: fix finish_fault() handling for large folios
Date: Mon, 10 Mar 2025 18:04:51 +0100
Message-ID: <20250310170503.224222411@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Geffon <bgeffon@google.com>

commit 34b82f33cf3f03bc39e9a205a913d790e1520ade upstream.

When handling faults for anon shmem finish_fault() will attempt to install
ptes for the entire folio.  Unfortunately if it encounters a single
non-pte_none entry in that range it will bail, even if the pte that
triggered the fault is still pte_none.  When this situation happens the
fault will be retried endlessly never making forward progress.

This patch fixes this behavior and if it detects that a pte in the range
is not pte_none it will fall back to setting a single pte.

[bgeffon@google.com: tweak whitespace]
  Link: https://lkml.kernel.org/r/20250227133236.1296853-1-bgeffon@google.com
Link: https://lkml.kernel.org/r/20250226162341.915535-1-bgeffon@google.com
Fixes: 43e027e41423 ("mm: memory: extend finish_fault() to support large folio")
Signed-off-by: Brian Geffon <bgeffon@google.com>
Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: Marek Maslanka <mmaslanka@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5079,7 +5079,11 @@ vm_fault_t finish_fault(struct vm_fault
 	bool is_cow = (vmf->flags & FAULT_FLAG_WRITE) &&
 		      !(vma->vm_flags & VM_SHARED);
 	int type, nr_pages;
-	unsigned long addr = vmf->address;
+	unsigned long addr;
+	bool needs_fallback = false;
+
+fallback:
+	addr = vmf->address;
 
 	/* Did we COW the page? */
 	if (is_cow)
@@ -5118,7 +5122,8 @@ vm_fault_t finish_fault(struct vm_fault
 	 * approach also applies to non-anonymous-shmem faults to avoid
 	 * inflating the RSS of the process.
 	 */
-	if (!vma_is_anon_shmem(vma) || unlikely(userfaultfd_armed(vma))) {
+	if (!vma_is_anon_shmem(vma) || unlikely(userfaultfd_armed(vma)) ||
+	    unlikely(needs_fallback)) {
 		nr_pages = 1;
 	} else if (nr_pages > 1) {
 		pgoff_t idx = folio_page_idx(folio, page);
@@ -5154,9 +5159,9 @@ vm_fault_t finish_fault(struct vm_fault
 		ret = VM_FAULT_NOPAGE;
 		goto unlock;
 	} else if (nr_pages > 1 && !pte_range_none(vmf->pte, nr_pages)) {
-		update_mmu_tlb_range(vma, addr, vmf->pte, nr_pages);
-		ret = VM_FAULT_NOPAGE;
-		goto unlock;
+		needs_fallback = true;
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		goto fallback;
 	}
 
 	folio_ref_add(folio, nr_pages - 1);


