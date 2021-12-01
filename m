Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCB62CA8
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:18 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 68F302177B;
	Wed,  1 Dec 2021 18:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382516; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rblro+TC1uDVBy3mod02KtqT/aFmx2uev/PD//fDNcw=;
	b=yDIOmFLbbM4dw8OZ6Z5qor/Js2UnwBzoWZSAfIlHYj9kKfyjXTQmoI+a8lCjwSJt5zuKzX
	4WTPWhE5KybediHELf08xzqDQugiBnF/eks8TRxmz5KzhUA4nvfnlwUrT241/0R7CXkAkV
	jbjPqj4w0Mz0sgLGwmi9845RaBg9304=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382516;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rblro+TC1uDVBy3mod02KtqT/aFmx2uev/PD//fDNcw=;
	b=2ZBqdQ++hDhpCMig1ecaaBmuxt432sLvuFEyHl2N6ALBBFurzP7VJ3ckT/o8xZTE78WJf0
	v0ZlKwTtGDgfdoBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 40C0914050;
	Wed,  1 Dec 2021 18:15:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 6EQtD7S7p2HPSAAAMHmgww
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
Subject: [PATCH v2 07/33] mm: Convert __ksize() to struct slab
Date: Wed,  1 Dec 2021 19:14:44 +0100
Message-Id: <20211201181510.18784-8-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2002; i=vbabka@suse.cz; h=from:subject; bh=eX+s7OU+yp43nrNz9lV9PAitVzSm6e7XjthT2EewhLk=; b=owGbwMvMwMH4QPFU8cfOlQKMp9WSGBKX785VuL/rRHdqzL6tC5QyBBhMAlqY9DJmiW4T77W6/Vrp +pG8TkZjFgZGDgZZMUWWXu/JjCtNH0vs84g7AzOIlQlkCgMXpwBMZIkF+z/zG0vlzRbcYrG8IpEz81 9xZImiS+OPCwvnOXyd9Loq8YaNbKq00Qph57bzS/1EsvwERMRet154c9P645252fMMVP/efyi6Y5k3 z29ezzIJQSVhBpkkaa3qdnGlw93rWFNe/dC5KbFj9WPWg0HC0y+/8f4lsFls+xuVzU/DD2/2X/rnVO 4s/4ee8iqpyzl+HpfTydGpDX1YbLwtrNrw/t3AWpnd0b6z7racbPPOthduyjnyr3uzXTf74j9+61oV 5vYclebicluy9n6bwWaX67fLeTQZZ/vrmgtWaJpqfM3wNpHb1HVTXdbP+UzJwS0xb+c5v8mUejzZX9 EhLt/S/NmDrwlB3kLxXzMEnETsAQ==
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

In SLUB, use folios, and struct slab to access slab_cache field.
In SLOB, use folios to properly resolve pointers beyond
PAGE_SIZE offset of the object.

[ vbabka@suse.cz: use folios, and only convert folio_test_slab() == true folios
  to struct slab ]

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slob.c |  8 ++++----
 mm/slub.c | 12 +++++-------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/mm/slob.c b/mm/slob.c
index 03deee1e6a94..c8a4290012a6 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -570,7 +570,7 @@ EXPORT_SYMBOL(kfree);
 /* can't use ksize for kmem_cache_alloc memory, only kmalloc */
 size_t __ksize(const void *block)
 {
-	struct page *sp;
+	struct folio *folio;
 	int align;
 	unsigned int *m;
 
@@ -578,9 +578,9 @@ size_t __ksize(const void *block)
 	if (unlikely(block == ZERO_SIZE_PTR))
 		return 0;
 
-	sp = virt_to_page(block);
-	if (unlikely(!PageSlab(sp)))
-		return page_size(sp);
+	folio = virt_to_folio(block);
+	if (unlikely(!folio_test_slab(folio)))
+		return folio_size(folio);
 
 	align = max_t(size_t, ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
 	m = (unsigned int *)(block - align);
diff --git a/mm/slub.c b/mm/slub.c
index 8b172de26c67..6ae7c63cedc0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4527,19 +4527,17 @@ void __check_heap_object(const void *ptr, unsigned long n, struct page *page,
 
 size_t __ksize(const void *object)
 {
-	struct page *page;
+	struct folio *folio;
 
 	if (unlikely(object == ZERO_SIZE_PTR))
 		return 0;
 
-	page = virt_to_head_page(object);
+	folio = virt_to_folio(object);
 
-	if (unlikely(!PageSlab(page))) {
-		WARN_ON(!PageCompound(page));
-		return page_size(page);
-	}
+	if (unlikely(!folio_test_slab(folio)))
+		return folio_size(folio);
 
-	return slab_ksize(page->slab_cache);
+	return slab_ksize(folio_slab(folio)->slab_cache);
 }
 EXPORT_SYMBOL(__ksize);
 
-- 
2.33.1

