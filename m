Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CFC2F12CE;
	Thu, 16 Jul 2026 14:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211374; cv=none; b=AP9roRdAYvxfhH6iRYjAKAHX2xVDSKML9AVX6TY221SM87y+Dt4p+B0TPM+o8iG7YGJNE6Ho+jWQC7hCQRtZrye7GZ8NT4OUEClvbnBZ99oC249inUk48H9TS7aiWj6sIzaJ47cMx3YS2h5kOezycKwph0d14UvOdmEEnc0fW8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211374; c=relaxed/simple;
	bh=cNcuEv+ep03CI5pWWfOG/ugTfVi3val6dkoquAO8Fl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qBDO3ah9uosbZLw0ozx29WU5juTOGUB5FfjQi1AbPhWiwBhI3lTWl9Y3pAk7sGxmbg2LY7JH+kXiKieXHfuIWaC4doYZa586QSrdKRSyUsY/PJjrhuA1DJ05yMY0EFq0AOM8HhfQRiJO8ykrXMES99lPXX7HvDPrKdYyzj8j1eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDbiRdOT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDbiRdOT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181821F000E9;
	Thu, 16 Jul 2026 14:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211372;
	bh=hy6gQbKJtlVzMzRgke9tGnhpCkZNmwKgFguiLbQiK3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wDbiRdOTzidecvWURLQ6KuqydemmnFmHHaKGr0VnKwEmTLWSbVS4SfdrbtmlsQCNt
	 OTPbnSf8waEAMRnPQEUOOaFehPZ1YSPS16a+Pa12wZhMs9X8YtexfTKd+2obKOBAPT
	 DYCUlWrbdnp2Gcx/igY0WOyFdXYlxIoZh+Dw7w3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ketan Kishore <ketan.kishore@oss.qualcomm.com>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 402/480] mm: page_ext: add count limit to page_ext_iter_next to prevent invalid PFN access
Date: Thu, 16 Jul 2026 15:32:29 +0200
Message-ID: <20260716133053.505664037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Ketan <ketan.kishore@oss.qualcomm.com>

commit ffd017237cfe99e6e5602ab14179b0e6878a0840 upstream.

The page_ext iteration API does not validate if the PFN still belongs to a
valid section while advancing the iterator.  When dynamically adding
memory in the hotplug path, it can lead to a NULL pointer dereference
during page_ext_lookup at the boundary of the last valid section when
iterator count equals __pgcount.

The for_each_page_ext() macro calls page_ext_iter_next() as its loop
increment.  for_each_page_ext() does a "__page_ext =
page_ext_iter_next(&__iter)" at the end.  This causes page_ext_iter_next()
to increment iter->index past __pgcount and call page_ext_lookup(start_pfn
+ __pgcount).  During memory hotplug (online), the PFN at start_pfn +
__pgcount may belong to a section that has not yet been initialized,
causing page_ext_lookup() to trigger a NULL pointer dereference.

[   14.555124][  T846] Call trace:
[   14.555125][  T846]  lookup_page_ext+0x6c/0x108 (P)
[   14.555127][  T846]  page_ext_lookup+0x30/0x3c
[   14.555129][  T846]  __reset_page_owner+0x11c/0x260
[   14.571201][  T846]  __free_pages_ok+0x5e8/0x8e0
[   14.571204][  T846]  __free_pages_core+0x78/0xf0
[   14.571206][  T846]  generic_online_page+0x14/0x24
[   14.597782][  T846]  online_pages+0x178/0x30c
[   14.597784][  T846]  memory_block_change_state+0x284/0x32c
[   14.597787][  T846]  memory_subsys_online+0x4c/0x64
[   14.597789][  T846]  device_online+0x88/0xb0
[   14.597791][  T846]  online_memory_block+0x30/0x40
[   14.597793][  T846]  walk_memory_blocks+0xac/0xe8
[   14.597794][  T846]  add_memory_resource+0x280/0x298
[   14.656161][  T846]  add_memory+0x60/0x98

Move the iteration boundary enforcement inside the iterator functions, so
callers cannot inadvertently access beyond the requested range.

Link: https://lore.kernel.org/20260623-page_ext-v3-1-a89799a5367c@oss.qualcomm.com
Fixes: 9039b9096ea2 ("mm: page_ext: add an iteration API for page extensions")
Signed-off-by: Ketan Kishore <ketan.kishore@oss.qualcomm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Luiz Capitulino <luizcap@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/page_ext.h |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/include/linux/page_ext.h
+++ b/include/linux/page_ext.h
@@ -119,14 +119,18 @@ struct page_ext_iter {
  * page_ext_iter_begin() - Prepare for iterating through page extensions.
  * @iter: page extension iterator.
  * @pfn: PFN of the page we're interested in.
+ * @count: maximum number of page extensions to return.
  *
  * Must be called with RCU read lock taken.
  *
  * Return: NULL if no page_ext exists for this page.
  */
 static inline struct page_ext *page_ext_iter_begin(struct page_ext_iter *iter,
-						unsigned long pfn)
+		unsigned long pfn, unsigned long count)
 {
+	if (!count)
+		return NULL;
+
 	iter->index = 0;
 	iter->start_pfn = pfn;
 	iter->page_ext = page_ext_lookup(pfn);
@@ -137,19 +141,22 @@ static inline struct page_ext *page_ext_
 /**
  * page_ext_iter_next() - Get next page extension
  * @iter: page extension iterator.
+ * @count: maximum number of page extensions to return.
  *
  * Must be called with RCU read lock taken.
  *
  * Return: NULL if no next page_ext exists.
  */
-static inline struct page_ext *page_ext_iter_next(struct page_ext_iter *iter)
+static inline struct page_ext *page_ext_iter_next(struct page_ext_iter *iter,
+		unsigned long count)
 {
 	unsigned long pfn;
 
 	if (WARN_ON_ONCE(!iter->page_ext))
 		return NULL;
 
-	iter->index++;
+	if (++iter->index >= count)
+		return NULL;
 	pfn = iter->start_pfn + iter->index;
 
 	if (page_ext_iter_next_fast_possible(pfn))
@@ -182,9 +189,9 @@ static inline struct page_ext *page_ext_
  * IMPORTANT: must be called with RCU read lock taken.
  */
 #define for_each_page_ext(__page, __pgcount, __page_ext, __iter) \
-	for (__page_ext = page_ext_iter_begin(&__iter, page_to_pfn(__page));\
-		__page_ext && __iter.index < __pgcount;          \
-		__page_ext = page_ext_iter_next(&__iter))
+	for (__page_ext = page_ext_iter_begin(&__iter, page_to_pfn(__page), __pgcount); \
+		__page_ext; \
+		__page_ext = page_ext_iter_next(&__iter, __pgcount))
 
 #else /* !CONFIG_PAGE_EXTENSION */
 struct page_ext;


