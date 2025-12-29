Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD871DB125;
	Mon, 29 Dec 2025 16:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025602; cv=none; b=OTeHegR/oCClFDkxbbQdb5/VVDaH9x7IKtZybtGkTx1pVjdL9BlEFK7/zQrm9TN0fUjkIom4edN2Gc+kSJ1oD8rSAzSw0RT4ZDTNd1wwS23BNTLkxFga3q7/jFC/+RPozQa3tzSi1OdeGE8wKwCnl0O2rsLqlcGX+t+qqRaq0EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025602; c=relaxed/simple;
	bh=57YKwT4hX+2UE4X5357OshAUqniWcVVFBHHLMiHu0GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c89311CWwcgaWAsXJBBKefSoGE3yFqwRTu1SXA4e5q2V+c+RzP4YZUWtzq0KArKPt4xqV5TsKbsKH2R2GgUhqMduwTT1Y2haVN0xvB01UBpvTHec3Mx4PG8oX20XyocUmfMqJ+sDONryzwJ+2b60370aFm2ayQIq10B6hqKAEaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mgN9YHGC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mgN9YHGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53640C4CEF7;
	Mon, 29 Dec 2025 16:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025602;
	bh=57YKwT4hX+2UE4X5357OshAUqniWcVVFBHHLMiHu0GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mgN9YHGC7TZzMZKAKpqWnbsob0nJFCWYJz+hrlFkU6HZOo2zn2xEnHYTgrXDMVhc/
	 DGLUGgoVV7qxyGsZYtXHdDdCJ4ZH/UttlqjZphKcE4WEtcm/caPbimBuP2nL8cpByi
	 aH1GDIer5pAPFf7BywbnSxrYE2EBrzIx/hlC7qLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Lance Yang <lance.yang@linux.dev>,
	Dev Jain <dev.jain@arm.com>,
	Usama Arif <usamaarif642@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 270/430] mm/huge_memory: add pmd folio to ds_queue in do_huge_zero_wp_pmd()
Date: Mon, 29 Dec 2025 17:11:12 +0100
Message-ID: <20251229160734.286535112@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Wei Yang <richard.weiyang@gmail.com>

commit 2a1351cd4176ee1809b0900d386919d03b7652f8 upstream.

We add pmd folio into ds_queue on the first page fault in
__do_huge_pmd_anonymous_page(), so that we can split it in case of memory
pressure.  This should be the same for a pmd folio during wp page fault.

Commit 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault") miss to
add it to ds_queue, which means system may not reclaim enough memory in
case of memory pressure even the pmd folio is under used.

Move deferred_split_folio() into map_anon_folio_pmd() to make the pmd
folio installation consistent.

Link: https://lkml.kernel.org/r/20251008095453.18772-2-richard.weiyang@gmail.com
Fixes: 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1233,6 +1233,7 @@ static void map_anon_folio_pmd(struct fo
 	count_vm_event(THP_FAULT_ALLOC);
 	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
 	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
+	deferred_split_folio(folio, false);
 }
 
 static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
@@ -1273,7 +1274,6 @@ static vm_fault_t __do_huge_pmd_anonymou
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
 		map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
 		mm_inc_nr_ptes(vma->vm_mm);
-		deferred_split_folio(folio, false);
 		spin_unlock(vmf->ptl);
 	}
 


