Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EEE2CA8
	for <patches@lists.linux.dev>; Tue,  4 Jan 2022 00:10:55 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1CE51212BA;
	Tue,  4 Jan 2022 00:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641255054; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A2ALFvvwPHg5q5L1G4b54hCspNPgzG67Kf3ruAG8aF0=;
	b=s7vtdU1sFVhtkHFFOTwudZFbY+e/jPcoYGxn1h+L4jaCTNKfYq3eWHuuYERdfcWpAAvHcW
	XWNjVSimboPvNf7qpuiRdhFlROw2A1Cfu1uR/AlkZQyinZGOWIg2mUASeSDK2DUjKio1PH
	O2UKbXBPda9Lu3Wnuxwmwn/QCt5KS9E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641255054;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A2ALFvvwPHg5q5L1G4b54hCspNPgzG67Kf3ruAG8aF0=;
	b=pN0mABrCDKq8GPrfrOH10mx8i322nlGj08kGv94Rc84oiFpNTSYdSCytZHnPE4Iu4dXi5W
	MUIMn+PY7/rf3pAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E195A139EE;
	Tue,  4 Jan 2022 00:10:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id uNh5No2Q02FEQwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Tue, 04 Jan 2022 00:10:53 +0000
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
Subject: [PATCH v4 07/32] mm: Convert __ksize() to struct slab
Date: Tue,  4 Jan 2022 01:10:21 +0100
Message-Id: <20220104001046.12263-8-vbabka@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104001046.12263-1-vbabka@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2093; i=vbabka@suse.cz; h=from:subject; bh=JVSehMFnzLnatRzND2uRu3Se3hBq6rrfZ0i62qRrKAA=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBh05BvZgQufd9NgTSCczy5Ahfm0Wvb2DaE0pomaH2v N3Oo932JATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYdOQbwAKCRDgIcpz8YmpELQ6B/ wKbaV1+W8nnnNrzIMAAbAlFkkx8mQZBEhtoTInFg7l4mae5SbGQ0n+9cgm/mP+yqEcFTrs3m0GR55u kp2iLXl7DpIJ/jCNfC/r+Tyhp3V711DKocNDx01KSOr64nMBRz+c++D29yKvpjVfJfFE4SPNZrQrl/ Fnvz4Uxl5O4yXZ0BVQtXA9YhfV7fssFTsFFO4vdON+kyOYmM8Q5xWBLGem4eY6Eez+dAqhWnkW7syl TLRx2gLa3OnxMvLRekQftOEXf4pHRU1Yg0lq6q3zoJm3ocwmnjfdR/6jEtWbEPaK799YGcdFeDfEgr dYpaOAJEOsJZ+4o27Ns+t1tabbW0jh
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

In SLUB, use folios, and struct slab to access slab_cache field.
In SLOB, use folios to properly resolve pointers beyond
PAGE_SIZE offset of the object.

[ vbabka@suse.cz: use folios, and only convert folio_test_slab() == true
  folios to struct slab ]

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Roman Gushchin <guro@fb.com>
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
index c94fb4b4d655..269e10d341a8 100644
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
2.34.1

