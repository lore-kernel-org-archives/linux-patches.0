Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D492134C7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD1CC433C8;
	Mon, 26 Jun 2023 18:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803453;
	bh=1JqGeV6kElRZlVCIvRRf3ZwOaPV09NFY6jhEEsmBf9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Juh5d5GuDiio4wRYwNC1Q1XY9h7spTL0p0QfOsgN2VYBTzOJp8mXpHBfN3nLLlJhS
	 el/kSXV44cdu7je1DGpM2SVIWT/dCSRikBEvOlTo3nJq0FutEXKW+2ufgJ8VAxiQ+0
	 6YMXudkzOmo0TQUIchP9NEfTM6V2WbRvOE5t6kMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.3 059/199] mm/vmalloc: do not output a spurious warning when huge vmalloc() fails
Date: Mon, 26 Jun 2023 20:09:25 +0200
Message-ID: <20230626180808.156895582@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lorenzo Stoakes <lstoakes@gmail.com>

commit 95a301eefa82057571207edd06ea36218985a75e upstream.

In __vmalloc_area_node() we always warn_alloc() when an allocation
performed by vm_area_alloc_pages() fails unless it was due to a pending
fatal signal.

However, huge page allocations instigated either by vmalloc_huge() or
__vmalloc_node_range() (or a caller that invokes this like kvmalloc() or
kvmalloc_node()) always falls back to order-0 allocations if the huge page
allocation fails.

This renders the warning useless and noisy, especially as all callers
appear to be aware that this may fallback.  This has already resulted in
at least one bug report from a user who was confused by this (see link).

Therefore, simply update the code to only output this warning for order-0
pages when no fatal signal is pending.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1211410
Link: https://lkml.kernel.org/r/20230605201107.83298-1-lstoakes@gmail.com
Fixes: 80b1d8fdfad1 ("mm: vmalloc: correct use of __GFP_NOWARN mask in __vmalloc_area_node()")
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmalloc.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3046,11 +3046,20 @@ static void *__vmalloc_area_node(struct
 	 * allocation request, free them via vfree() if any.
 	 */
 	if (area->nr_pages != nr_small_pages) {
-		/* vm_area_alloc_pages() can also fail due to a fatal signal */
-		if (!fatal_signal_pending(current))
+		/*
+		 * vm_area_alloc_pages() can fail due to insufficient memory but
+		 * also:-
+		 *
+		 * - a pending fatal signal
+		 * - insufficient huge page-order pages
+		 *
+		 * Since we always retry allocations at order-0 in the huge page
+		 * case a warning for either is spurious.
+		 */
+		if (!fatal_signal_pending(current) && page_order == 0)
 			warn_alloc(gfp_mask, NULL,
-				"vmalloc error: size %lu, page order %u, failed to allocate pages",
-				area->nr_pages * PAGE_SIZE, page_order);
+				"vmalloc error: size %lu, failed to allocate pages",
+				area->nr_pages * PAGE_SIZE);
 		goto fail;
 	}
 


