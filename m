Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035725;
	b=RxP0WsnJqhseX4xN2PwebuXW6uSPKNoSKdi2NxmlExQjfBbjKXaq+sMHk9Lz5y36wlam
	 uQLg3BSKh66ZnRpVpz+3qM7QOj7qJJ0XQ8LuhiFh1lhsiHDjq6uJ2e0bEM6Z9r41uxHVv
	 DyBQVz8vBKGpkB9VXrxFn0Qb2EvMQ2G5l0IzfljKteMZTYhpeiuHcAO3lsBtKy7kmurLu
	 WifW032ivatTYIifrYSdf5UNLHTeXaue0sr9RYLN20/YnEJeOhG1aUHOcLMAVWt1oa/iG
	 1rdXWX8MZmDb2FB9j6XNXGfys1nooD7E0DnLLgE1si9XK+MV49dogmcOSXpuJsuWlxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IajOHWnD05k3g9Ng2qrx8x7hYL9j5h3fAhdq1jjQ8Jc=;
	b=X42E8ZPrXP/x0lRfwzTjI0KJPxd5rA/pT/M9BueIF+IoHd6WOJGnAJT8DPYpavXCQ3S/
	 RZjgMmFxh48GMBdNN+E1N9zdtH9rZMPoGt/frf4lWzhiRE9fcS77ewKfuA9fRQUe5XWch
	 RX2jXS9YfkuAWCJac++XLK/Lm9QymoFjOTP+GOfMg26lE6Bb4sXQCCxLtTo7XNy1p0wyn
	 E32fUqha6aau4MdJtUyUj+UXkHn8j3B6p90UvfD7Asz1oWMp3p/ifrbcmC3Qn4efgl8zX
	 Wol4tJjK94B0jHPVfMAruv1OgpWch1kU3+HbYf9cV+WhxUolu1XBDUMHol40RDzw8SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tssKqZyM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0C7606A33F;
	Wed, 18 Nov 2026 21:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tssKqZyM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930A31F000C4;
	Wed, 18 Nov 2026 21:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035725;
	bh=IajOHWnD05k3g9Ng2qrx8x7hYL9j5h3fAhdq1jjQ8Jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tssKqZyMmAPXUuoxGBeFOtM9pniUsbUH2ETJveVSIc5SG22/SOfYXrvqro6zxfhVh
	 KCG0k6u6Q8M1W/fghBcFBTfnHH8uIESBJlrSSc49jSe70mlKqN6wqKypwQMvKJ53aq
	 vz6Y6dgic1XFoVpTuu+LM3HraWId6Vz1Seqhoijo=
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
Subject: [PATCH 6.6 0788/3318] mm: khugepaged: fix folio is used after folio_put/unlock()
Date: Wed, 18 Nov 2026 15:23:30 +0100
Message-ID: <20261118150342.509138358@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vernon Yang <yanglincheng@kylinos.cn>

[ Upstream commit 9010383e71e6ce75fcd3c8f87133c8ce6c0e6ab4 ]

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
[ sashal: adjusted collapse_file() declaration context to preserve struct page *tmp instead of struct folio *tmp ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/huge_memory.h | 6 +++---
 mm/khugepaged.c                    | 4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 0c57ef317e311..bf5dcc388f327 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -207,10 +207,10 @@ TRACE_EVENT(mm_khugepaged_scan_file,
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
@@ -224,7 +224,7 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__entry->hpfn = new_folio ? folio_pfn(new_folio) : -1;
+		__entry->hpfn = new_pfn;
 		__entry->index = index;
 		__entry->addr = addr;
 		__entry->is_shmem = is_shmem;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 84a64e2033d22..c0a3d09cfd976 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1788,6 +1788,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	struct page *page;
 	struct page *tmp, *dst;
 	struct folio *folio, *new_folio;
+	unsigned long new_pfn = -1;
 	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
@@ -1800,6 +1801,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	result = alloc_charge_folio(&new_folio, mm, cc);
 	if (result != SCAN_SUCCEED)
 		goto out;
+	new_pfn = folio_pfn(new_folio);
 
 	mapping_set_update(&xas, mapping);
 
@@ -2207,7 +2209,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	folio_put(new_folio);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
-	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
+	trace_mm_khugepaged_collapse_file(mm, new_pfn, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
 	return result;
 }
 
-- 
2.53.0



