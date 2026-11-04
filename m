Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827174;
	b=NcTi9iDM/FL/f92wDCmN2cTg2KrdMcAvyeEV0z9doSroRrcUqpe8QJR0J4KSeV0QHGWD
	 4Fe1x4EUC7E2bzt0X6QEMF2PlORP+aqbahBlIk2p3BfugTrTCW+3AkoxnupFhaTGa9ojV
	 E9nN6PnuwB9z9KBcVIbVAEdIQrJH2WOSiyBmyVwCLSXq2+RvuqEPbJK61q6+MMfJC3oSs
	 csEJ40rpZB+8ejx0FT9S9dOgBpqq30UQvfkckh5xAoBXQGoRcedPzfqLVqev9tBHe9oKS
	 4eCsxozlj6ttT4nh2CNMEW5N/qFL2YaU1WVSAUFqrO/Y05UXmAa7hl+MsoYDf2gF1+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QQiPQX9D5x8UF9T9cGNFz+PdDa49FkYHpGLrl3WKXo4=;
	b=CR8nWQH5IstnHspgCgtM1ZCfN1xF47xcNqqD7j3WBlH40glrOjs4f1eEgJtphqij2CMS
	 8fKac6fuXPMilPNyZUNOOb6Yoe08uB+A0qczdqV5RT9PHfU5Ls7yVKEDLIiDMVytEHHqk
	 ou9dbngXyPga4C4z1hgSgvtjhIcQNpzHomTOClQlqZyawryFZ/siUn9o/1Swh5D4q5eyW
	 COxOvPXpROBO3NPxf3NEDG3rleo7zGpSez3h8zkuvHuNnfD/hJB2jEAOUo2hTumzK/AsQ
	 /mO7hwKlzwtdFmsO9lbYcaCxGqBvJe/h/t48pISm10PR1if694m1oumEat7JvhSSs6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VHXVOwm9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A83C6074FA1;
	Wed,  4 Nov 2026 21:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VHXVOwm9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708FD1F00A02;
	Wed,  4 Nov 2026 21:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827169;
	bh=QQiPQX9D5x8UF9T9cGNFz+PdDa49FkYHpGLrl3WKXo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VHXVOwm9RZFV1sG+sdjsyeVtHlrpyiOajNWdu+V7YW4QOaWvJ338BsbCRVz4yfT41
	 IFbmpQdyHJk4h0RSbDhcrn7AHB4SGTXinsIKY236UUfqAGxdqtyapy4XmM7qQd6cFE
	 MIi7iqsSEqNy2kx2AxeKRb8ukttPhoR2wxYrsmuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vernon Yang <yanglincheng@kylinos.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Zach OKeefe <zokeefe@google.com>
Subject: [PATCH 7.3 236/547] mm: khugepaged: fix folio is used after folio_put/unlock()
Date: Wed,  4 Nov 2026 16:07:00 -0500
Message-ID: <20261104211044.868021283@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vernon Yang <yanglincheng@kylinos.cn>

commit 9010383e71e6ce75fcd3c8f87133c8ce6c0e6ab4 upstream.

On the rollback path, folio_put() has already dropped the last reference
of new_folio.  On the success path, new_folio is already unlocked and can
be freed concurrently.  The trace_mm_khugepaged_collapse_file() is left
with a dangling folio pointer.

So using the folio_pfn() before dropping the reference, closing
use-after-free window.

Link: https://lore.kernel.org/20260909025804.3233645-4-vernon2gm@gmail.com
Fixes: 4c9473e87e75 ("mm/khugepaged: add tracepoint to collapse_file()")
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/huge_memory.h |    6 +++---
 mm/khugepaged.c                    |    4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -211,10 +211,10 @@ TRACE_EVENT(mm_khugepaged_scan_file,
 );
 
 TRACE_EVENT(mm_khugepaged_collapse_file,
-	TP_PROTO(struct mm_struct *mm, struct folio *new_folio, pgoff_t index,
+	TP_PROTO(struct mm_struct *mm, unsigned long new_pfn, pgoff_t index,
 			unsigned long addr, bool is_shmem, struct file *file,
 			int nr, int result),
-	TP_ARGS(mm, new_folio, index, addr, is_shmem, file, nr, result),
+	TP_ARGS(mm, new_pfn, index, addr, is_shmem, file, nr, result),
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
 		__field(unsigned long, hpfn)
@@ -228,7 +228,7 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__entry->hpfn = new_folio ? folio_pfn(new_folio) : -1;
+		__entry->hpfn = new_pfn;
 		__entry->index = index;
 		__entry->addr = addr;
 		__entry->is_shmem = is_shmem;
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2245,6 +2245,7 @@ static enum scan_result collapse_file(st
 	struct address_space *mapping = file->f_mapping;
 	struct page *dst;
 	struct folio *folio, *tmp, *new_folio;
+	unsigned long new_pfn = -1;
 	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
@@ -2264,6 +2265,7 @@ static enum scan_result collapse_file(st
 	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out;
+	new_pfn = folio_pfn(new_folio);
 
 	mapping_set_update(&xas, mapping);
 
@@ -2667,7 +2669,7 @@ rollback:
 	folio_put(new_folio);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
-	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
+	trace_mm_khugepaged_collapse_file(mm, new_pfn, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
 	return result;
 }
 


