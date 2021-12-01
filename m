Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6302CA8
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:20 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 17607218A9;
	Wed,  1 Dec 2021 18:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382517; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kZxMyj6Wp8HA56QwK3f0tcjB2n7iq+1Of+4MuQIlFE8=;
	b=ZzPI8nUDggoCYrIrBCiVNqqJyxnDcsUU2840V+/OqeTwr9bVRfV9nhd5js9If5IUHDLAJ+
	Q9xMSPX6PPsUBaihtOJGGfUCUnKJ1Q59s14riSFYCTTYmdOfY5YS2dkk758w6ARHQs1nGv
	0ptlglcQOYdQgfyMeGV8VE6PDDwndYM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382517;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kZxMyj6Wp8HA56QwK3f0tcjB2n7iq+1Of+4MuQIlFE8=;
	b=Z56jISVIqoRA/EaTNYJMD4n4zO1d6Rtb3+K/57kxN2goH84pRtg/HafIlZDrtbhzJ4QzSY
	ZXnYsc9tkgaBhnCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E940214050;
	Wed,  1 Dec 2021 18:15:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id WI9nOLS7p2HPSAAAMHmgww
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
Subject: [PATCH v2 11/33] mm/slub: Convert kfree() to use a struct slab
Date: Wed,  1 Dec 2021 19:14:48 +0100
Message-Id: <20211201181510.18784-12-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2119; i=vbabka@suse.cz; h=from:subject; bh=MtR80ZILh+jqjffo/Kbuxz56SWHzzZyNMAh7fcGLzpk=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7t2hlVDUcX4WrIhp6ivzBG7+xn8yk3HfpPz9NXA 4rv1bRKJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7dgAKCRDgIcpz8YmpEKrgB/ wL5Qj23adTLhJRPSmKsNy+ZqU2ckI5jc7W2bfxAApMUPlGwMxfv1t1hKBey3aLL+W2RB/4fV7Ac+fX UjtWNsOr0wosh+1RorYwnb8YgSmYPA7Aacw2UM0CgFI8DUxwis8/TY+Bdp58zJxYLRUziV/UrVQxpC 5EMbpqJ0uBuKgejt08aD/fDvwkbIFrXcpJMZ1Yw9u7puB9Tj3cPKm+65Od1N5sEi4iPnGNkcgSVNi7 IdvfKi59+BV6x6sdf2k1tKiRJW0m8Ze3rECK+u1n/NrPGqfc2YrVntH1+8zhY16fqHRURaZ/CuiqTT t/B4m5POJuVATR9I3vyq1qxCIR1kiA
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Convert kfree(), kmem_cache_free() and ___cache_free() to resolve object
addresses to struct slab, using folio as intermediate step where needed. Keep
passing the result as struct page for now in preparation for mass conversion of
internal functions.

[ vbabka@suse.cz: Use folio as intermediate step when checking for
  large kmalloc pages ]

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 9bdb0a5d6ab2..2d9c1b3c9f37 100644
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
 
@@ -4546,7 +4546,8 @@ EXPORT_SYMBOL(__ksize);
 
 void kfree(const void *x)
 {
-	struct page *page;
+	struct folio *folio;
+	struct slab *slab;
 	void *object = (void *)x;
 
 	trace_kfree(_RET_IP_, x);
@@ -4554,12 +4555,13 @@ void kfree(const void *x)
 	if (unlikely(ZERO_OR_NULL_PTR(x)))
 		return;
 
-	page = virt_to_head_page(x);
-	if (unlikely(!PageSlab(page))) {
-		free_nonslab_page(page, object);
+	folio = virt_to_folio(x);
+	if (unlikely(!folio_test_slab(folio))) {
+		free_nonslab_page(folio_page(folio, 0), object);
 		return;
 	}
-	slab_free(page->slab_cache, page, object, NULL, 1, _RET_IP_);
+	slab = folio_slab(folio);
+	slab_free(slab->slab_cache, slab_page(slab), object, NULL, 1, _RET_IP_);
 }
 EXPORT_SYMBOL(kfree);
 
-- 
2.33.1

