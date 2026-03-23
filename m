Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FF83AF66C;
	Mon, 23 Mar 2026 14:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274477; cv=none; b=E9dONEPg5j8XwgtzRF/w0pjGL0hgRB/0jKXFWEu6lZnPFkjF+hQvcPtDIcnnx8Z4K+nHlQQFe0eLeOllg0qCsQi6JxUnSbE2vpA39Gwp3eFw3r1+50FhaunEtwDjy1wihDXA0oi7CISObtvEOnhdQlmcjbTQkl8H3cR9C1gkmg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274477; c=relaxed/simple;
	bh=lTos2n9a38JTffA+z10mKyzV0THPbTILnFv5Y6p0Z8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXaoEqjEkT6O0jhS8ULztpwF8vsSAqSPWw3Qw+UXMNEIAOFylRoQQ7xZ1raGPUM4M+uNxrT8CyK6SmriiLkaufZ4TeEesrlqYFLcHAXwVofHf4+gdt5eNdgl7Ic+obbNxZoadwkFe8hqjJJYt7p2qMzfznYTAgxhueX0WrTNrNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jbSJQ6Fb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jbSJQ6Fb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF9DC4CEF7;
	Mon, 23 Mar 2026 14:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274477;
	bh=lTos2n9a38JTffA+z10mKyzV0THPbTILnFv5Y6p0Z8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jbSJQ6Fb17R4YkdylbZY9fRdRZ24kKOSJNKbQsKDDSrXDr8aBIYtVo3yDmsd0yGxY
	 8F5Ndly+NNWzxSWrktS6orkOtECwyDIJ/e2GWdS7xw2sWLUtu31n46WbWZf8bYeQfB
	 uHiD4jAREyYxepy0bsn9g3o6GHL4ceTGEjV0miSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Down <chris@chrisdown.name>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 010/212] mm/huge_memory: fix use of NULL folio in move_pages_huge_pmd()
Date: Mon, 23 Mar 2026 14:43:51 +0100
Message-ID: <20260323134504.095447970@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Chris Down <chris@chrisdown.name>

commit fae654083bfa409bb2244f390232e2be47f05bfc upstream.

move_pages_huge_pmd() handles UFFDIO_MOVE for both normal THPs and huge
zero pages.  For the huge zero page path, src_folio is explicitly set to
NULL, and is used as a sentinel to skip folio operations like lock and
rmap.

In the huge zero page branch, src_folio is NULL, so folio_mk_pmd(NULL,
pgprot) passes NULL through folio_pfn() and page_to_pfn().  With
SPARSEMEM_VMEMMAP this silently produces a bogus PFN, installing a PMD
pointing to non-existent physical memory.  On other memory models it is a
NULL dereference.

Use page_folio(src_page) to obtain the valid huge zero folio from the
page, which was obtained from pmd_page() and remains valid throughout.

After commit d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge
zero folio special"), moved huge zero PMDs must remain special so
vm_normal_page_pmd() continues to treat them as special mappings.

move_pages_huge_pmd() currently reconstructs the destination PMD in the
huge zero page branch, which drops PMD state such as pmd_special() on
architectures with CONFIG_ARCH_HAS_PTE_SPECIAL.  As a result,
vm_normal_page_pmd() can treat the moved huge zero PMD as a normal page
and corrupt its refcount.

Instead of reconstructing the PMD from the folio, derive the destination
entry from src_pmdval after pmdp_huge_clear_flush(), then handle the PMD
metadata the same way move_huge_pmd() does for moved entries by marking it
soft-dirty and clearing uffd-wp.

Link: https://lkml.kernel.org/r/a1e787dd-b911-474d-8570-f37685357d86@lucifer.local
Fixes: e3981db444a0 ("mm: add folio_mk_pmd()")
Signed-off-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2639,7 +2639,8 @@ int move_pages_huge_pmd(struct mm_struct
 		_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
 	} else {
 		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
-		_dst_pmd = folio_mk_pmd(src_folio, dst_vma->vm_page_prot);
+		_dst_pmd = move_soft_dirty_pmd(src_pmdval);
+		_dst_pmd = clear_uffd_wp_pmd(_dst_pmd);
 	}
 	set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);
 


