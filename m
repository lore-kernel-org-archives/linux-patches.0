Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624983;
	b=QFncvxPXXlYTEOgBJPkcQq2S6Tc9sVhX/6JVx6uTgmF2dFCV7/QsMQoYWSQbpheXXZQK
	 68VH0RCzcRZ2IAYToKp6EvnXqsRjoMt3sEeiV+ATwlfi4HzJEa08vo6jREepAnjhuT+C1
	 sEKSg/HtVdIMlY+VI+92KD8EiFj3sMoQEZsZaUPBLxdom0ekF8h7XmNI1letHNdcK0u5L
	 A+WtVKRTUuutrrnIj4jdUmaF/qPVGutZPorpY/UspdJr7b+fVz8W51C7tqv04o7VxYGgv
	 5Z1UfLMq+LtUhtGXOXqPzifGjaDKhrH0tY7SmnIK52smUNZW3lVSMbfvQ7JpR3Oq8eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624983;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GEMxaliut1juZnenfb8Kqq9V5cFPwKRRe43Qb7kM1MQ=;
	b=DolwpSMNVEuyXYDvzTyHTws8wHIto3d2QLOK69gWtk84VJANtZq/5IHircmY8W7do2nc
	 g7KdGOTDIrxAS0abH333wCd+gst785S1V08SDMA6H7LRt4sYEF4/uXTlai+Ec+9VO7jfE
	 zmES65Jbw5ovhUuOP++PEX4vcgnzm+7jdzQHhpkNwV6lkOF4s3hV0L+/Gh3YSpFVM5uMP
	 GVYQG0eht/JRefPIIcP4S30yjliOysb+urjMc5Jl3vmox3vgQtc8kxmY3aNaf2p5c/znY
	 0oYLMjG1x3ea+t0SNZv8vJHDWAtqniJBB2UoOzbWPP72eKvclCCoryej1XxAxnMLD9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PhWzSZEb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CDD606A31E;
	Wed, 25 Nov 2026 16:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PhWzSZEb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234181F000C6;
	Wed, 25 Nov 2026 16:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624983;
	bh=GEMxaliut1juZnenfb8Kqq9V5cFPwKRRe43Qb7kM1MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PhWzSZEbJyW58tWaCZNEVw2ZOzni5S2lxG1Uj3YFW5DB+9Dw9I1byQlK7mTwFmc8N
	 UNNY/jhhZPvgQcHLq0YxJQWfeE+/RbbnReC3HnO33RaOpwkpKREcPqPQfaqoUlRDAH
	 YydnWHiOwnyGidt68CznpDfH8eWl/KLWeOJtYAlM=
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
	Zach OKeefe <zokeefe@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 366/816] mm: khugepaged: fix folio is used after pte_unmap_unlock()
Date: Wed, 25 Nov 2026 15:31:54 +0100
Message-ID: <20261125143857.669259299@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vernon Yang <yanglincheng@kylinos.cn>

[ Upstream commit ba2f1f92ddfabd340c9248fd2380104f717ee8b1 ]

After the page table lock has dropped, the folio can be freed
concurrently.  The trace_mm_khugepaged_scan_pmd() is left with a dangling
folio pointer.

So using the folio_pfn() before dropping the page table lock, closing
use-after-free window.

And other pre-existing bug, When the `for (i = 0; i < HPAGE_PMD_NR; i++)`
iteration to terminate and the folio operation preceding is normal, but
pfn will be incorrect.  so we really only trace the PFN if it really was
problematic.

Link: https://lore.kernel.org/20260909025804.3233645-3-vernon2gm@gmail.com
Fixes: 7d2eba0557c1 ("mm: add tracepoint for scanning pages")
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
[ sashal: Replaced the &folio->page argument with a failed_pfn set at each folio failure site, using older helper names and keeping the tracepoint's extra writable argument, and dropped the lazyfree hunk. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/huge_memory.h | 6 +++---
 mm/khugepaged.c                    | 9 ++++++++-
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 8f63af61c3ccb..7fd5c30c713e1 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -55,10 +55,10 @@ SCAN_STATUS
 
 TRACE_EVENT(mm_khugepaged_scan_pmd,
 
-	TP_PROTO(struct mm_struct *mm, struct page *page, bool writable,
+	TP_PROTO(struct mm_struct *mm, unsigned long pfn, bool writable,
 		 int referenced, int none_or_zero, int status, int unmapped),
 
-	TP_ARGS(mm, page, writable, referenced, none_or_zero, status, unmapped),
+	TP_ARGS(mm, pfn, writable, referenced, none_or_zero, status, unmapped),
 
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
@@ -72,7 +72,7 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__entry->pfn = page ? page_to_pfn(page) : -1;
+		__entry->pfn = pfn;
 		__entry->writable = writable;
 		__entry->referenced = referenced;
 		__entry->none_or_zero = none_or_zero;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index ea94f66cd0377..8649ea2772c36 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1265,6 +1265,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 	int none_or_zero = 0, shared = 0;
 	struct page *page = NULL;
 	struct folio *folio = NULL;
+	unsigned long failed_pfn = -1;
 	unsigned long _address;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
@@ -1344,6 +1345,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 
 		if (!folio_test_anon(folio)) {
 			result = SCAN_PAGE_ANON;
+			failed_pfn = folio_pfn(folio);
 			goto out_unmap;
 		}
 
@@ -1358,6 +1360,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 			if (cc->is_khugepaged &&
 			    shared > khugepaged_max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
+				failed_pfn = folio_pfn(folio);
 				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
 				goto out_unmap;
 			}
@@ -1372,15 +1375,18 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 		node = folio_nid(folio);
 		if (hpage_collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
+			failed_pfn = folio_pfn(folio);
 			goto out_unmap;
 		}
 		cc->node_load[node]++;
 		if (!folio_test_lru(folio)) {
 			result = SCAN_PAGE_LRU;
+			failed_pfn = folio_pfn(folio);
 			goto out_unmap;
 		}
 		if (folio_test_locked(folio)) {
 			result = SCAN_PAGE_LOCK;
+			failed_pfn = folio_pfn(folio);
 			goto out_unmap;
 		}
 
@@ -1396,6 +1402,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 		 */
 		if (!is_refcount_suitable(folio)) {
 			result = SCAN_PAGE_COUNT;
+			failed_pfn = folio_pfn(folio);
 			goto out_unmap;
 		}
 
@@ -1427,7 +1434,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 		*mmap_locked = false;
 	}
 out:
-	trace_mm_khugepaged_scan_pmd(mm, &folio->page, writable, referenced,
+	trace_mm_khugepaged_scan_pmd(mm, failed_pfn, writable, referenced,
 				     none_or_zero, result, unmapped);
 	return result;
 }
-- 
2.53.0



