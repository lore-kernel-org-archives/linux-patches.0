Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622286;
	b=jGbtLYpEYilmt0jKOemZFitGzCtUqH7yIpdZSVXuvNmtucklbzZWYAchSX4aKe4OFrlb
	 DZGYWW/2Dtlw6NDwUf2kD4OULyz/WfZHoaICI3bEKU1XDrHxicLqnrBNXcqJXOWJwuHzu
	 O9ei6EBcYhVBakc8EaH/GZs4zrhoDTjwosrP19aOd21yzZWWtmhO5IN2uWLof6UqLbQ/R
	 eHZPKVmC3aGMh8uo34kzFXQjNqCQ5hp6pQR4Rb04/qhX/PPC0ueXfOnzNWV/jE+NR2xGE
	 +wLVVoOophxARSw4z/KEr34F8cQKe8L4CVNa1pRwdRGDB5ogq67uOVtEliEx49SflVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MYDWDVU2DferyjkKvVvk7d8pQ7UAkqUXRwaWY2niR1c=;
	b=2yWURdLf1517IqM56yG3zhoqyQJXSOz7f2TazScBDfLPC9c6cDwZlB/q5kHZ/QgbBc/0
	 fNvDS83BgxnxuIQPpFht/YjjFpzVeXkYRMtef2e+nmpF41XzJ/EH7epbVvTExvfVCa03s
	 9xV/eCyySmYuJve8+Rs3peVKqNOxPwIo9rjd0unTWAlvVwC9EcLf6fce7U51cbcXhr8KT
	 hxvL0nn1aAwnmasjLrIjQloDBUwGUGsYAnwaL0Q+mTFROym38tPqYTjLE15JenDlr9Zly
	 i26prjsoVXXoddbL384/Gpu/cAkRBgCgxTRBNBGeVxmSFuNK44RwfWtKDhbmEUvUIAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e48WvUWT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FB2606A31E;
	Wed, 25 Nov 2026 15:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e48WvUWT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC821F000C6;
	Wed, 25 Nov 2026 15:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622285;
	bh=MYDWDVU2DferyjkKvVvk7d8pQ7UAkqUXRwaWY2niR1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e48WvUWT+4SZidW3oblg6MXYKWkj/jV3BrEOernsRSoZSmmwfrltwKGNrcq22OJlx
	 4jPGFUB4t1pwvs22VphWO3UqeLwdTK3SYRGlR89qSGM7+49aNVJDZufkrvHPOFb7GE
	 IUBaSASmDqsynUrRHd7sodDEDAWQcUkPBO08lRMs=
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
Subject: [PATCH 6.18 487/990] mm: khugepaged: fix folio is used after pte_unmap_unlock()
Date: Wed, 25 Nov 2026 15:30:54 +0100
Message-ID: <20261125143833.500928369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Dropped the SCAN_PAGE_LAZYFREE hunk and applied the failed_pfn changes to hpage_collapse_scan_pmd(), the older name and body of collapse_scan_pmd(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/huge_memory.h | 6 +++---
 mm/khugepaged.c                    | 9 ++++++++-
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 1464d45c90abf..6b2e08f4a6be6 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -54,10 +54,10 @@ SCAN_STATUS
 
 TRACE_EVENT(mm_khugepaged_scan_pmd,
 
-	TP_PROTO(struct mm_struct *mm, struct folio *folio,
+	TP_PROTO(struct mm_struct *mm, unsigned long pfn,
 		 int referenced, int none_or_zero, int status, int unmapped),
 
-	TP_ARGS(mm, folio, referenced, none_or_zero, status, unmapped),
+	TP_ARGS(mm, pfn, referenced, none_or_zero, status, unmapped),
 
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
@@ -70,7 +70,7 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__entry->pfn = folio ? folio_pfn(folio) : -1;
+		__entry->pfn = pfn;
 		__entry->referenced = referenced;
 		__entry->none_or_zero = none_or_zero;
 		__entry->status = status;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 7ca1772c5aa8b..1acef234d22cb 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1254,6 +1254,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 	int none_or_zero = 0, shared = 0;
 	struct page *page = NULL;
 	struct folio *folio = NULL;
+	unsigned long failed_pfn = -1;
 	unsigned long addr;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
@@ -1330,6 +1331,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 
 		if (!folio_test_anon(folio)) {
 			result = SCAN_PAGE_ANON;
+			failed_pfn = folio_pfn(folio);
 			goto out_unmap;
 		}
 
@@ -1342,6 +1344,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 			if (cc->is_khugepaged &&
 			    shared > khugepaged_max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
+				failed_pfn = folio_pfn(folio);
 				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
 				goto out_unmap;
 			}
@@ -1356,15 +1359,18 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
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
 
@@ -1380,6 +1386,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 		 */
 		if (folio_expected_ref_count(folio) != folio_ref_count(folio)) {
 			result = SCAN_PAGE_COUNT;
+			failed_pfn = folio_pfn(folio);
 			goto out_unmap;
 		}
 
@@ -1409,7 +1416,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 		*mmap_locked = false;
 	}
 out:
-	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
+	trace_mm_khugepaged_scan_pmd(mm, failed_pfn, referenced,
 				     none_or_zero, result, unmapped);
 	return result;
 }
-- 
2.53.0



