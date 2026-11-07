Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061574;
	b=KU8lYFp4RnRqq0lx0bUvsG+A038k/i2ozWzfricJ+6RmbCRsgDVcvACZVXZm3/ra1dSY
	 VpKQnpKVuS4KqDVDOn6wkHbq4RK9OT8s2+wttXZHfKDNxaPtlRwoFxJKIpe8n+4tXdy6z
	 vVrTRlO0tveSF9MvgWZXViF8akbAQ7zWp8df7QmxtfjWzrkmg2zMz2bb+Wb0uOKsWbZ0i
	 1gWytKHMZTZ7ApGZriGxssTDFdVMW9dPhvLreFWsk/Pe2ZWBcii1Sy0UZiUorsCnANCFa
	 RP7ATlyiVkue+Z1WkXwI4NGJQO65O8EkaXqMM0NvnCQFAbFhKM8a4d3vt2fSOOMhMdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G0EZudA3RjnRfBjs6AF4hK1IfOorzyX244Gws7hW5rY=;
	b=Q1Nig5QD3RSfHFDqtDeS15sgz3XgHoBdRbIQaclP1at0wrxgkGAfCxVVAKXcK/RcqNZO
	 Vx9pMZeCxvcicvhQ0wEPkKDDrQ2VdM1KZv60csQTeBsqab5F8/EBP9JV7UuZSCCXdceiA
	 bUEes0arEGTjQaI5I0nTQPk5OeIZoduCJi6ZJaH5zSB3aouxLRE7C7p7lsV8xA0Uxafut
	 P1A5LktDII+El7MsTjiPY2pI5k6+/PLPpbe1L7MZk0ngtN6GfyaRHAKxWsheQvogtOVMl
	 9Kk6NoJ5/PlAOVJqev7PN4cQ5BvGDh3lNmjlZBIah/YsDA+LtC9FiS96ho+Ng28KAfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qDcnm8b8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A265606A32D;
	Sat,  7 Nov 2026 14:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qDcnm8b8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4361F0089F;
	Sat,  7 Nov 2026 14:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061574;
	bh=G0EZudA3RjnRfBjs6AF4hK1IfOorzyX244Gws7hW5rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qDcnm8b8Rpr9lCg0zodtDV7arIIdcZJlUNl+g3Vzf5X0oON2Jmsri6LqjTFMu/VLZ
	 o2DmExVyjCgVvYsSPBnYz2G+iEuDz5q+2ENs1u+kRgmlF2e6Kopwb+lZSg1IXl/tnE
	 ZEeDESz15s7yj5jtfICdQrtep3tWM3GivV+LLyUA=
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
Subject: [PATCH 6.12 0651/1536] mm: khugepaged: fix folio is used after folio_put/unlock()
Date: Sat,  7 Nov 2026 08:44:27 -0500
Message-ID: <20261107135015.812602408@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1811,6 +1811,7 @@ static int collapse_file(struct mm_struc
 	struct address_space *mapping = file->f_mapping;
 	struct page *dst;
 	struct folio *folio, *tmp, *new_folio;
+	unsigned long new_pfn = -1;
 	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
@@ -1823,6 +1824,7 @@ static int collapse_file(struct mm_struc
 	result = alloc_charge_folio(&new_folio, mm, cc);
 	if (result != SCAN_SUCCEED)
 		goto out;
+	new_pfn = folio_pfn(new_folio);
 
 	mapping_set_update(&xas, mapping);
 
@@ -2242,7 +2244,7 @@ rollback:
 	folio_put(new_folio);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
-	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
+	trace_mm_khugepaged_collapse_file(mm, new_pfn, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
 	return result;
 }
 


