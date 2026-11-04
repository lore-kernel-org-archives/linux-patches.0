Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831480;
	b=j6Zr30hwRV1p7PkYenszI8P8OHZedq9JaqB1VGleOfqaUmftxrCsr5rk3OrpVlqxZHc2
	 KjUgpoXHUEgppBoDkM4d9ocgrd9CYnjjsHH77Sprbv7Sl9fgXXLZU53N8O2jy0abcTQ3g
	 r6YqUp9zZskSKxL1RscU596cqrGx3d9EoVeW1iQN33VXIssC0gYipR4ps4sJw/spT/mOr
	 iVcMaTi8JvuV+3xoTxdON+GRffxw7bVphulNfzlSLWMEbHak8YQV0AJVFb/SYW7DROVSx
	 OrvZsV12RdzC4wwECttfyKzqbTnaC5VKAeQdla7inSvOYtKkhV2Kkbtqnb3ERNB9AVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/zU9WXM02FD0rFQ0g4buGmzoeZg+rnW3Op4tbb8NXrA=;
	b=2S5e9XQFiR+3M/0andv07/kt1cEETNCIJ13NhzduSdh6LdBluTsUJd+ll8GRIt3oHt3B
	 mjOzefqeFSrnwkGFRGJxVjs0mTP37bOd9p/nwOIeSVK3a+GFwXdgcmhGD/m1ilrHHvcAZ
	 XSDu0KQZLTydZuRaIs6pou7HgOsUZDNzlq3zrKyGLb0+GmmBw4oByTPEoCVwMlIf/yoN/
	 qfUYwOjW7ghbI3/tQkH4t/imJMhsor+R2BwtEbgDuWlbq0tZZ3k0XkVzAAObZQ2SZtrNs
	 6S4sA6SV8pZghbBk7Ta7SyfCxHNH0a2cTzUntE0Ifj7SdhMG37lYB2XM6vJGPWrgq1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gpQJOItY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB96606AC2A;
	Wed,  4 Nov 2026 22:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gpQJOItY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB4B1F000C1;
	Wed,  4 Nov 2026 22:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831480;
	bh=/zU9WXM02FD0rFQ0g4buGmzoeZg+rnW3Op4tbb8NXrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gpQJOItYM5rYdpa+wlF3tjU/xKFp3OUB0VqHbveTfwAmU1Xs4pollSBFmJFOiGX2B
	 nvdwSWI1s4YpPcl7DlbcDky+gDysnTMymqPXN8gQvNy78fVQTfgJvBXPSoG2mkmTG9
	 tm2IsTe08pODwuhDrsdGMPBSYs8b29jl56mN1PxI=
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
Subject: [PATCH 6.18 0730/1005] mm: khugepaged: fix folio is used after folio_put/unlock()
Date: Wed,  4 Nov 2026 16:07:43 -0500
Message-ID: <20261104211103.945832493@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -200,10 +200,10 @@ TRACE_EVENT(mm_khugepaged_scan_file,
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
@@ -217,7 +217,7 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__entry->hpfn = new_folio ? folio_pfn(new_folio) : -1;
+		__entry->hpfn = new_pfn;
 		__entry->index = index;
 		__entry->addr = addr;
 		__entry->is_shmem = is_shmem;
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1861,6 +1861,7 @@ static int collapse_file(struct mm_struc
 	struct address_space *mapping = file->f_mapping;
 	struct page *dst;
 	struct folio *folio, *tmp, *new_folio;
+	unsigned long new_pfn = -1;
 	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
@@ -1873,6 +1874,7 @@ static int collapse_file(struct mm_struc
 	result = alloc_charge_folio(&new_folio, mm, cc);
 	if (result != SCAN_SUCCEED)
 		goto out;
+	new_pfn = folio_pfn(new_folio);
 
 	mapping_set_update(&xas, mapping);
 
@@ -2292,7 +2294,7 @@ rollback:
 	folio_put(new_folio);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
-	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
+	trace_mm_khugepaged_collapse_file(mm, new_pfn, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
 	return result;
 }
 


