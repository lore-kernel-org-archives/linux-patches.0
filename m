Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591322;
	b=ewCm19U3c9pYwvEt0mkbkFgHeVz4skH8ko/j+wy0QoNawaaIEw/zHQUrN4Mq69Eenzjg
	 qjcd1lHN5KfOJM9LAfzJ5ZMV4qVHY0oT5Pg+uTHt1HCbUu1hkXhqxH1N7REI/bkZXnysj
	 7J3hq07WMU7jImv472X8dOIEf3hZZOf5wvGXVjQWJWFvimu974uS3glv76q2UfykC83I8
	 ukTBWdl5IFBebki7a+qfBE25pZT0zgbbnTUz3oIKSevOFYHhrdgtu1RO/dNLdkqQvie/g
	 vVAOu3HM6L4olHpy7DAeSI/2K6Bsx279GtPmxycLT3Ks8xlp8zBG/Au1qbl98w2e7Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=14sl+PLLT+11HPc3jC3Nydzccm9ZWqkNnoDVIoSlDLM=;
	b=nJrUS+Y+KSpWhQY2hBmfI6i9bzCnZ0T4iaQgjZ4B6EmsY1D9a42CIlgLTh7mA9ETTUDI
	 Gfset2Ha3wJ7vUZYjBOsgJy46+cXrHu7wsneJiz166QpJn3xnwWuvZn955rRuVJ1F+HSt
	 UORyt0KmxECV1RUL538WqXwbtf069JggAZ0Z+dIRDXhGorz7o/FFyCFV/kSpTBG5toAih
	 Ip7iqV8/FuuxDb+O7t4GR5RPdaz2mKMquJ/CBpKy0CyM5FDJRWerQNWTa6EAVzKH+/qoJ
	 pY9C1qNF9nZ4vN1MJCibZkR3PCZ6JgsKxV7wFus5ZCSwLFNeInZlLnL8HiXr2IBl7jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eTAIYiIs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA5C606B204;
	Fri, 13 Nov 2026 17:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eTAIYiIs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D9B1F000C4;
	Fri, 13 Nov 2026 17:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591321;
	bh=14sl+PLLT+11HPc3jC3Nydzccm9ZWqkNnoDVIoSlDLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eTAIYiIsu6y4uUrP/s5jzXgrLNofoTZtMhYvVRJy5lp8z3RlN6F/8aJbh/R79OX78
	 LY6yB2IPSf2WSNJz4ZCeQRrFBq/1Zghgs9PTBZloXFdGJozj3wk2eb5QPPjYZK+ZAQ
	 t8O0tAs3pncpX8blrxR0prO1Vyayd4mUEulNZyb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	SeongJae Park <sj@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 435/670] mm/page_alloc: reject unreasonable folio/compound page sizes in alloc_contig_range_noprof()
Date: Fri, 13 Nov 2026 10:49:59 -0500
Message-ID: <20261113153826.557469438@linuxfoundation.org>
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

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 0bf2edf041dcb0b304a8dbda8c699771d5a245d2 ]

Let's reject them early, which in turn makes folio_alloc_gigantic() reject
them properly.

To avoid converting from order to nr_pages, let's just add MAX_FOLIO_ORDER
and calculate MAX_FOLIO_NR_PAGES based on that.

While at it, let's just make the order a "const unsigned order".

Link: https://lkml.kernel.org/r/20250901150359.867252-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 4c767c5dd9bc ("mm/page_isolation: guard compound_order() against racing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mm.h |  6 ++++--
 mm/page_alloc.c    | 10 +++++++++-
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1728dc3356089..f05962963e28d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2058,11 +2058,13 @@ static inline long folio_nr_pages(const struct folio *folio)
 
 /* Only hugetlbfs can allocate folios larger than MAX_ORDER */
 #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
-#define MAX_FOLIO_NR_PAGES	(1UL << PUD_ORDER)
+#define MAX_FOLIO_ORDER		PUD_ORDER
 #else
-#define MAX_FOLIO_NR_PAGES	MAX_ORDER_NR_PAGES
+#define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
 #endif
 
+#define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
+
 /*
  * compound_nr() returns the number of pages in this potentially compound
  * page.  compound_nr() can be called on a tail page, and is defined to
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 063c2a359a1e1..869296e43349e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6685,6 +6685,7 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
 int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 		       unsigned migratetype, gfp_t gfp_mask)
 {
+	const unsigned int order = ilog2(end - start);
 	unsigned long outer_start, outer_end;
 	int ret = 0;
 
@@ -6699,6 +6700,14 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 	};
 	INIT_LIST_HEAD(&cc.migratepages);
 
+	/*
+	 * In contrast to the buddy, we allow for orders here that exceed
+	 * MAX_PAGE_ORDER, so we must manually make sure that we are not
+	 * exceeding the maximum folio order.
+	 */
+	if (WARN_ON_ONCE((gfp_mask & __GFP_COMP) && order > MAX_FOLIO_ORDER))
+		return -EINVAL;
+
 	gfp_mask = current_gfp_context(gfp_mask);
 	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
 		return -EINVAL;
@@ -6796,7 +6805,6 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 			free_contig_range(end, outer_end - end);
 	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
 		struct page *head = pfn_to_page(start);
-		int order = ilog2(end - start);
 
 		check_new_pages(head, order);
 		prep_new_page(head, order, gfp_mask, 0);
-- 
2.53.0



