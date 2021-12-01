Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63A02CA4
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:20 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E4D9C218A8;
	Wed,  1 Dec 2021 18:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382516; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=58hfxBnYuwldOsS5RWPBlmkBh3kDaXQv2xFDmW4LndY=;
	b=n7Aolzg1ngl6J3WJTn7tfeV1zrjafRyiNC8W9St8QHyRGTPufwB5LNfzo9K8KianwcxUUN
	eCByQmVERil1dBcfH7FC8gq1dWQnLKMR19UkuSrYy8BRfW9QriLYN9bJJWbtaFSPjLBKE7
	qCe2VD/8LIgh0tt1ZAn3NJQHs5b7DmI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382516;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=58hfxBnYuwldOsS5RWPBlmkBh3kDaXQv2xFDmW4LndY=;
	b=SGYIASap+UQxfGOjK18SWyRWpMg/QwCkinBzlHx06/LVeGL/mhZs1oFr3uECgWdPo+Pxwg
	VEhvDhYLSj8qkfAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C142B13D9D;
	Wed,  1 Dec 2021 18:15:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 6MWWLrS7p2HPSAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 01 Dec 2021 18:15:16 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: Matthew Wilcox <willy@infradead.org>,
	Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>
Cc: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v2 10/33] mm/slub: Convert detached_freelist to use a struct slab
Date: Wed,  1 Dec 2021 19:14:47 +0100
Message-Id: <20211201181510.18784-11-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3747; i=vbabka@suse.cz; h=from:subject; bh=O8xdnfGnjh+DVAQGcXEOWgPRczsdJzoKygblRxlNB+s=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7tzg/mgthML8LjJOVCjvFddbzxDjhsfv+qvzBQR ydgUMweJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7cwAKCRDgIcpz8YmpEBBUB/ 9Oma5vnuxifv8h1Xevvyv2y3oePd5y8T7+aQNNLaJ2Fea1AtoHmTCmx3JcPpXlHVWjy5i2Jb7qnm3l y29ahDE+PR6/fK9Mq6hvTdECpuQQkogvXnjyzqokdX2EEMfSI+WMu4/5YotqqUhNGEfvPu48P6mrVP Xa/wWD3MwtG6cXDNQ7P09JeuBx5Tv8iOgdZVNfmoF82HYnLRx7G6IK5egOmkVT3ZHrYiQaw4H5sEd8 Vl7LMwyMsMAsaDHypRVTsCbKvSrVuIU2ecsWVnEODWFnTMnDIbqszzgpfx/z92I+VnIpewcgiJ4bbG 3FvjZqlSQhTLmpF8wgjyEIrBCN/s9B
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

This gives us a little bit of extra typesafety as we know that
nobody called virt_to_page() instead of virt_to_head_page().

[ vbabka@suse.cz: Use folio as intermediate step when filtering out
  large kmalloc pages ]

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 0d31274743d9..9bdb0a5d6ab2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3532,7 +3532,7 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
 EXPORT_SYMBOL(kmem_cache_free);
 
 struct detached_freelist {
-	struct page *page;
+	struct slab *slab;
 	void *tail;
 	void *freelist;
 	int cnt;
@@ -3554,8 +3554,8 @@ static inline void free_nonslab_page(struct page *page, void *object)
 /*
  * This function progressively scans the array with free objects (with
  * a limited look ahead) and extract objects belonging to the same
- * page.  It builds a detached freelist directly within the given
- * page/objects.  This can happen without any need for
+ * slab.  It builds a detached freelist directly within the given
+ * slab/objects.  This can happen without any need for
  * synchronization, because the objects are owned by running process.
  * The freelist is build up as a single linked list in the objects.
  * The idea is, that this detached freelist can then be bulk
@@ -3570,10 +3570,11 @@ int build_detached_freelist(struct kmem_cache *s, size_t size,
 	size_t first_skipped_index = 0;
 	int lookahead = 3;
 	void *object;
-	struct page *page;
+	struct folio *folio;
+	struct slab *slab;
 
 	/* Always re-init detached_freelist */
-	df->page = NULL;
+	df->slab = NULL;
 
 	do {
 		object = p[--size];
@@ -3583,17 +3584,19 @@ int build_detached_freelist(struct kmem_cache *s, size_t size,
 	if (!object)
 		return 0;
 
-	page = virt_to_head_page(object);
+	folio = virt_to_folio(object);
 	if (!s) {
 		/* Handle kalloc'ed objects */
-		if (unlikely(!PageSlab(page))) {
-			free_nonslab_page(page, object);
+		if (unlikely(!folio_test_slab(folio))) {
+			free_nonslab_page(folio_page(folio, 0), object);
 			p[size] = NULL; /* mark object processed */
 			return size;
 		}
 		/* Derive kmem_cache from object */
-		df->s = page->slab_cache;
+		slab = folio_slab(folio);
+		df->s = slab->slab_cache;
 	} else {
+		slab = folio_slab(folio);
 		df->s = cache_from_obj(s, object); /* Support for memcg */
 	}
 
@@ -3605,7 +3608,7 @@ int build_detached_freelist(struct kmem_cache *s, size_t size,
 	}
 
 	/* Start new detached freelist */
-	df->page = page;
+	df->slab = slab;
 	set_freepointer(df->s, object, NULL);
 	df->tail = object;
 	df->freelist = object;
@@ -3617,8 +3620,8 @@ int build_detached_freelist(struct kmem_cache *s, size_t size,
 		if (!object)
 			continue; /* Skip processed objects */
 
-		/* df->page is always set at this point */
-		if (df->page == virt_to_head_page(object)) {
+		/* df->slab is always set at this point */
+		if (df->slab == virt_to_slab(object)) {
 			/* Opportunity build freelist */
 			set_freepointer(df->s, object, df->freelist);
 			df->freelist = object;
@@ -3650,10 +3653,10 @@ void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
 		struct detached_freelist df;
 
 		size = build_detached_freelist(s, size, p, &df);
-		if (!df.page)
+		if (!df.slab)
 			continue;
 
-		slab_free(df.s, df.page, df.freelist, df.tail, df.cnt, _RET_IP_);
+		slab_free(df.s, slab_page(df.slab), df.freelist, df.tail, df.cnt, _RET_IP_);
 	} while (likely(size));
 }
 EXPORT_SYMBOL(kmem_cache_free_bulk);
-- 
2.33.1

