Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9153B7752;
	Thu, 17 Sep 2026 18:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671479; cv=none; b=ey92xT5Lrzg2tg50TjVvP3xChQA4PPweGC2H2eKGhRDHQkGWe/eQKQaZOe/KKtMpNNs7ZwkAbzu+DoOHQQ3pKx8zx8BOwmFhg/H7uj3rMUFWRDdTL+/FuJtVyWtzp7fL29pQrVLGol/r8gNQa02VLb213A++j4QBhGoOBIkvrlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671479; c=relaxed/simple;
	bh=SnOou30AzxHzebVkeTve+/yRKvaAlKad/uC62h20MPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMpfqmNRLojKIoVs2VjVpyuNc35NawMsHXcAby/YFHxrfBZWg6+Bb2jr6qBBIRHFErkJ+o6QKtXlZrsIA+1vNZ/dQkJkroZd9FXXFcYj2yJL2lJmeXfxDjPB9eB10WFzu3ULaPzYVIAZctT1/34qrchWTE4FZHCF7vZPoLp2Ax4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BeGXgGr9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BeGXgGr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B37E1F00893;
	Thu, 17 Sep 2026 18:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671477;
	bh=lPmhEqwjUJ2c25zusLuX4oA7PeSJa5A5L9r0v/myViQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BeGXgGr9giUvDBDOukGbTPPLLMm4T++van9GUAGfdE+MooR6aSoDU17KS1/Vw4/bP
	 CTjftvdd4FdbMAqkfjT4v0lvzX9l/0hTmyYVpZP0dt5VedMPPmS50BncUa4pwlSoLR
	 8VznkkubtYcBftbyQHHKDgurREpsZpcGmvjvrffs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Andy Lutomirks^H^Hski <luto@kernel.org>,
	Borislav Betkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jann Horn <jannh@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Lance Yang <ioworker0@gmail.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcow (Oracle)" <willy@infradead.org>,
	Michal Koutn <mkoutny@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	tejun heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zefan Li <lizefan.x@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0989/1102] mm: move _pincount in folio to page[2] on 32bit
Date: Thu, 17 Sep 2026 16:15:32 +0100
Message-ID: <20260917151605.540407984@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 31a31da8a6187f1e5448ec73222e01d7d3fed4aa ]

Let's free up some space on 32bit in page[1] by moving the _pincount to
page[2].

For order-1 folios (never anon folios!) on 32bit, we will now also use the
GUP_PIN_COUNTING_BIAS approach.  A fully-mapped order-1 folio requires 2
references.  With GUP_PIN_COUNTING_BIAS being 1024, we'd detect such
folios as "maybe pinned" with 512 full mappings, instead of 1024 for
order-0.  As anon folios are out of the picture (which are the most
relevant users of checking for pinnings on *mapped* pages) and we are
talking about 32bit, this is not expected to cause any trouble.

In __dump_page(), copy one additional folio page if we detect a folio with
an order > 1, so we can dump the pincount on order > 1 folios reliably.

Note that THPs on 32bit are not particularly common (and we don't care too
much about performance), but we want to keep it working reliably, because
likely we want to use large folios there as well in the future,
independent of PMD leaf support.

Once we dynamically allocate "struct folio", fortunately the 32bit
specifics will likely go away again; even small folios could then have a
pincount and folio_has_pincount() would essentially always return "true".

Link: https://lkml.kernel.org/r/20250303163014.1128035-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andy Lutomirks^H^Hski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michal Koutn <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: tejun heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[ sashal: Reduced backport -- upstream 31a31da8a6187 touches 6 file(s), this
  backport carries 1. Not backported here:
  include/linux/mm_types.h
  mm/debug.c
  mm/gup.c
  mm/internal.h
  mm/page_alloc.c
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: 078e1a0fc41a ("mm/gup: fix always draining LRU caches in collect_longterm_unpinnable_folios()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1905,6 +1905,8 @@ static inline struct folio *pfn_folio(un
 	return page_folio(pfn_to_page(pfn));
 }
 
+#define folio_has_pincount(folio) folio_test_large(folio)
+
 /**
  * folio_maybe_dma_pinned - Report if a folio may be pinned for DMA.
  * @folio: The folio.


