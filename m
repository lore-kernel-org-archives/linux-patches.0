Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B372C80
	for <patches@lists.linux.dev>; Tue,  4 Jan 2022 00:10:58 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D98BB1F3A6;
	Tue,  4 Jan 2022 00:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641255054; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ti0XtQNDEFb9FNOSbsFX2bzVgBg9KmJFWTwvAWoPWBc=;
	b=fuIpOo9/YFofLTBTlPU8cXTK4kA45HSt/+U4iClwKoq1fYD8A1eHoF1Zsf5xfZF0UT+c1g
	hPn16zU0ZZuGi11ZqJrZZgoZQCgPVRDvuyyChOzKP2VrJHUYoqS6P7dCtpHnaO1GSBbw8j
	ddyf+VpeoDI4YEbmzJG02Y9HBHFahUw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641255054;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ti0XtQNDEFb9FNOSbsFX2bzVgBg9KmJFWTwvAWoPWBc=;
	b=SNRGJWz6XbPGyY+4/dPQoLxyAVIjSuUGW+FkJd8oi1VqgAFg9+h31EtMqlUMZNMl9UET2p
	WRegEM89+oPwbOAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B0065139EE;
	Tue,  4 Jan 2022 00:10:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 8OZOKo6Q02FEQwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Tue, 04 Jan 2022 00:10:54 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: Matthew Wilcox <willy@infradead.org>,
	Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>
Cc: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <guro@fb.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v4 11/32] mm/slub: Convert kfree() to use a struct slab
Date: Tue,  4 Jan 2022 01:10:25 +0100
Message-Id: <20220104001046.12263-12-vbabka@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104001046.12263-1-vbabka@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3326; i=vbabka@suse.cz; h=from:subject; bh=gRTOW5yY2S+1WrQd+/4SmwnODbqX7ErNoUooBPhbDHk=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBh05BzWmmiw2xIci3ux0FBkBRp6cj/AuL6TEckTAr8 xXXcx6+JATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYdOQcwAKCRDgIcpz8YmpEEy5CA C2Hm8rMN3ei+smKWB9BC39YhCPjO9R4+z0Vsreej7NonW3B+EBdexp2TPRMcCd/bJIOS/TUTUckuFd 3Di0oqPd19AjV63P4CMRCR5WA4CBVtiK6Uw4i3Tx0FPAceR/KWOvG4W/HGraewPXQLwa5CI5aWbi79 PB7QAGWC1YKEEtfUxnWkk7E3b+xMHkkUn+bidwpueo1reeDruRLtg6vPRzRfRPAlBKiLsucqnZa1t1 gRIkHf+LLHYAdu3usFhUy5Hv8j4Uqbon59nnx7aBYn3/FF/qDhnVgF2ck0zmNqfKwhXiJOy4sMu1R8 +r/aT0sS0jNvsqAdlbGogTEwezKiJH
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Convert kfree(), kmem_cache_free() and ___cache_free() to resolve object
addresses to struct slab, using folio as intermediate step where needed.
Keep passing the result as struct page for now in preparation for mass
conversion of internal functions.

[ vbabka@suse.cz: Use folio as intermediate step when checking for
  large kmalloc pages, and when freeing them - rename
  free_nonslab_page() to free_large_kmalloc() that takes struct folio ]

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a45b74d2712f..acf2608a57c5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3517,7 +3517,7 @@ static __always_inline void slab_free(struct kmem_cache *s, struct page *page,
 #ifdef CONFIG_KASAN_GENERIC
 void ___cache_free(struct kmem_cache *cache, void *x, unsigned long addr)
 {
-	do_slab_free(cache, virt_to_head_page(x), x, NULL, 1, addr);
+	do_slab_free(cache, slab_page(virt_to_slab(x)), x, NULL, 1, addr);
 }
 #endif
 
@@ -3527,7 +3527,7 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
 	if (!s)
 		return;
 	trace_kmem_cache_free(_RET_IP_, x, s->name);
-	slab_free(s, virt_to_head_page(x), x, NULL, 1, _RET_IP_);
+	slab_free(s, slab_page(virt_to_slab(x)), x, NULL, 1, _RET_IP_);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
@@ -3539,16 +3539,17 @@ struct detached_freelist {
 	struct kmem_cache *s;
 };
 
-static inline void free_nonslab_page(struct page *page, void *object)
+static inline void free_large_kmalloc(struct folio *folio, void *object)
 {
-	unsigned int order = compound_order(page);
+	unsigned int order = folio_order(folio);
 
-	if (WARN_ON_ONCE(!PageCompound(page)))
+	if (WARN_ON_ONCE(order == 0))
 		pr_warn_once("object pointer: 0x%p\n", object);
 
 	kfree_hook(object);
-	mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B, -(PAGE_SIZE << order));
-	__free_pages(page, order);
+	mod_lruvec_page_state(folio_page(folio, 0), NR_SLAB_UNRECLAIMABLE_B,
+			      -(PAGE_SIZE << order));
+	__free_pages(folio_page(folio, 0), order);
 }
 
 /*
@@ -3588,7 +3589,7 @@ int build_detached_freelist(struct kmem_cache *s, size_t size,
 	if (!s) {
 		/* Handle kalloc'ed objects */
 		if (unlikely(!folio_test_slab(folio))) {
-			free_nonslab_page(folio_page(folio, 0), object);
+			free_large_kmalloc(folio, object);
 			p[size] = NULL; /* mark object processed */
 			return size;
 		}
@@ -4547,7 +4548,8 @@ EXPORT_SYMBOL(__ksize);
 
 void kfree(const void *x)
 {
-	struct page *page;
+	struct folio *folio;
+	struct slab *slab;
 	void *object = (void *)x;
 
 	trace_kfree(_RET_IP_, x);
@@ -4555,12 +4557,13 @@ void kfree(const void *x)
 	if (unlikely(ZERO_OR_NULL_PTR(x)))
 		return;
 
-	page = virt_to_head_page(x);
-	if (unlikely(!PageSlab(page))) {
-		free_nonslab_page(page, object);
+	folio = virt_to_folio(x);
+	if (unlikely(!folio_test_slab(folio))) {
+		free_large_kmalloc(folio, object);
 		return;
 	}
-	slab_free(page->slab_cache, page, object, NULL, 1, _RET_IP_);
+	slab = folio_slab(folio);
+	slab_free(slab->slab_cache, slab_page(slab), object, NULL, 1, _RET_IP_);
 }
 EXPORT_SYMBOL(kfree);
 
-- 
2.34.1

