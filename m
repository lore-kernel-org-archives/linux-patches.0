Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE8422301;
	Thu, 16 Jul 2026 13:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210068; cv=none; b=T8MbfyF4ko0mBogQ6KfsXX0Dur2lEr64r+y2F7XNczLl1UT0n4UMvF02TE1hrnbiT4/00gmSZ/D/ad1go9LjuIMh/ehRtSr6vwIQEFzYL+3jFGfWE6YORo95MY00oyaZQKamjE2H8JC8Ci4Bmbaw5J5WxZCK2W9J3kE7K+bQJHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210068; c=relaxed/simple;
	bh=ioymxUEP1LJTHr/E9zJRBD5fqVz02nz5fPSMgdV8WTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nr7GXmZRcBE+42roFS2ihg0lAa7lKzK2dbGOc5onugGeB92X2DIb0S2AcbdLc1UwiTtfx70gLWsUWjM0PginP50Se2wa2XZXGrw7ZkFiZhpXhE6SHTHJgbuZ+XZEj1ru58szTDh7VndEuazIQzRv0FfQLCpk+Yqi+v6SzdTSDOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idmT/l44; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idmT/l44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A613D1F000E9;
	Thu, 16 Jul 2026 13:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210067;
	bh=EzQmbvo7lxws0hhA6Ugj8LjL/iRfUE8CDUAwkSK4PrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idmT/l44R/ykno5mrN7zpBll7y5SitCQqexEH9XmYJ2Vll61k26+h9d3kumqdnMxR
	 9dK4t7tsVLTttzQRFcDgd1jd9LWmhQ9ECgLobSlDxrw369RO9a148r1+KaWY1LVYQz
	 +TJuZ1zA17OUMwwtFyS9fREG7vP6kByiAcdGDm08=
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
Subject: [PATCH 7.1 425/518] mm: page_ext: add count limit to page_ext_iter_next to prevent invalid PFN access
Date: Thu, 16 Jul 2026 15:31:33 +0200
Message-ID: <20260716133057.139505256@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -120,14 +120,18 @@ struct page_ext_iter {
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
@@ -138,19 +142,22 @@ static inline struct page_ext *page_ext_
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
@@ -183,9 +190,9 @@ static inline struct page_ext *page_ext_
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


