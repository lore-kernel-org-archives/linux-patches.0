Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591130;
	b=TZLzJWyHhkCR+mIPsNBOtAMetPy3pEORdqQunH+vnoEpCCXYjhpBqqA+kegwnPgmNx1k
	 8Ia9bqUupyR4W8yGf/vHxNhvFMBcjWFgH5+thPVhBlmJ0O1VQWmsxQxXJCibkUA7LKbeb
	 XuGXnj6RXlC30AH36IRketC4BKNE4xwqhcbGUmQqOrnGRz80hOi38oXllKj1/6u9DItFx
	 1oXVJLaxjlQGZqfQhV7NG2i9ccnZFPiU5N9csugQlihA/LAnOQeFk4u2qUcKiov2PQ4tK
	 WwlevYhHg2HZjO06bB2NmBPE02kx2SGPzQ4zvlJelkWIusbfLRgofa1PaMLg/Mbm0yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w2HwfE5AfCKUQCBVEc5A0xrTM2i/jgZ4WeJ0jAIkCWM=;
	b=VvykhrwRLEMR4xi25nAAqB5pRI+je/xH7Dw5n302pPScVMD86YIsScD8DXlnoaOQC3qV
	 tpZi4o2sdPovGgsDxkGy+nXZ6+o9oU799xXHz1RhsrHdXdmbDJPUrbq5f4LOwDPA+FCvO
	 qmxr3TmiQGk26LR271EkuZDTgShYX6ljx138/tR99i7Cuyiz3aH4BGVsC1g966yhRlUUJ
	 1WHyCL7TLCFISGAO6TQNApHHkYxdhZgJFo29iuLrIxncshJ0AbaiuVCw25YV1wSjFQjR4
	 Y6uik1h17IDw97waluiJr8vYdn0VXkiOwFAVYzcdDxmItv9VDQUCkYwoOnflYpTkIhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R5mzrTzv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BF6606BD0F;
	Fri, 13 Nov 2026 17:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R5mzrTzv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572801F000C4;
	Fri, 13 Nov 2026 17:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591130;
	bh=w2HwfE5AfCKUQCBVEc5A0xrTM2i/jgZ4WeJ0jAIkCWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R5mzrTzvdMyoZyqKHQIkndSs68Z5QpyXnk7ZwxufhNhEmyRaWg04PSQr54G/PRiE+
	 PBEiD1u7geDaBsc15IYKeNj4FVKQzeJYtDON0C5XtoafnGHxGuy05kmT8dGRlrNix5
	 q123NPWLgkrwLmChPaelLDCC9pio7Vdl27QIfz5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 277/670] mm/page_alloc: mark pages freed by __free_pages_core() as not tagged
Date: Fri, 13 Nov 2026 10:47:21 -0500
Message-ID: <20261113153821.276170142@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

[ Upstream commit b6732c6d43139ea56de8bc62e87ace8543ef784f ]

Onlining hotplugged memory (e.g., a dev_dax device bound to kmem) with
CONFIG_MEM_ALLOC_PROFILING_DEBUG triggers:

  alloc_tag was not set
  WARNING: ./include/linux/alloc_tag.h:166 at __pgalloc_tag_sub+0x1fc/0x254
  Call trace:
   __pgalloc_tag_sub+0x1fc/0x254 (P)
   __free_pages_ok+0x14c/0x6ac
   __free_pages_core+0xa8/0x188
   generic_online_page+0x14/0x20
   online_pages+0x220/0x3b0
   memory_subsys_online+0xfc/0x198
   device_online+0x58/0xe0
   state_store+0xf0/0xf8

Pages entering the buddy through __free_pages_core() have never been
allocated, so their allocation tag references are NULL.  The free path,
__free_pages_prepare() -> pgalloc_tag_sub(), expects a valid tag or a
CODETAG_EMPTY mark and warns otherwise.  Paths feeding never-allocated
pages into the buddy are therefore expected to mark them with
clear_page_tag_ref() first, like init_cma_reserved_pageblock() and
free_reserved_pages() do; of __free_pages_core()'s callers only
memblock_free_pages() clears the tag ref itself, and the hotplug
onlining path was missed.

Since all __free_pages_core() callers free never-allocated pages, mark the
head page as not tagged in __free_pages_core() itself instead of relying on
each caller, and drop the now-redundant clearing from
memblock_free_pages().

Link: https://lore.kernel.org/20261022122752.74774-1-zenghui.yu@linux.dev
Fixes: dcfe378c81f7 ("lib: introduce support for page allocation tagging")
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mm_init.c    | 2 --
 mm/page_alloc.c | 3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 77f5f62628b71..f024ab7ae363d 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2481,8 +2481,6 @@ void __init memblock_free_pages(struct page *page, unsigned long pfn,
 		return;
 	}
 
-	/* pages were reserved and not allocated */
-	clear_page_tag_ref(page);
 	__free_pages_core(page, order, MEMINIT_EARLY);
 }
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a649f0245e3bf..480579d7d59e4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1355,6 +1355,9 @@ void __meminit __free_pages_core(struct page *page, unsigned int order,
 		atomic_long_add(nr_pages, &page_zone(page)->managed_pages);
 	}
 
+	/* pages were never allocated */
+	clear_page_tag_ref(page);
+
 	if (page_contains_unaccepted(page, order)) {
 		if (order == MAX_PAGE_ORDER && __free_unaccepted(page))
 			return;
-- 
2.53.0



