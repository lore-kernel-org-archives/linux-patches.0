Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347F42CA0
	for <patches@lists.linux.dev>; Tue,  4 Jan 2022 00:10:55 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1A5A51F398;
	Tue,  4 Jan 2022 00:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641255053; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VGenZxbIzWqJRT7BwXJx8DfLEezxMwfPgk6ocPU0ZLw=;
	b=z1fNy53u7NtWbUJM0ZedKX9jKqeWtm68AZtcSFJ5sRZ+UDBWrDB0BgsjWCTNUCLENro5CJ
	GK8c1aAnNRFsFb2T/+rrk65eonn6oUz94O2i6FPsuievJCbEUxpiCbtJqntNwNW3W6e8Hs
	TMFIFcJEUVU4grh0reghzGTd813TgzM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641255053;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VGenZxbIzWqJRT7BwXJx8DfLEezxMwfPgk6ocPU0ZLw=;
	b=48EPfGBKNIBOPh9koC26uBa093cOR/DCL3J/J2v/F6zVyrkWwromyDFLLKREzvMfjuzLIw
	uCey7NS7g9s4abBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E1B13139D1;
	Tue,  4 Jan 2022 00:10:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id sKpzNoyQ02FEQwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Tue, 04 Jan 2022 00:10:52 +0000
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
Subject: [PATCH v4 02/32] mm/slab: Dissolve slab_map_pages() in its caller
Date: Tue,  4 Jan 2022 01:10:16 +0100
Message-Id: <20220104001046.12263-3-vbabka@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104001046.12263-1-vbabka@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1413; h=from:subject; bh=TaYP0W/ksXF1RIcypGHlvq2kGK0WcrSlt2ObOuzoH/M=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBh05BrHPXiz1vFXcRk9WmkgDNahrnlKiYWLP2DJZAI 7tbAxD2JATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYdOQawAKCRDgIcpz8YmpEE7qB/ 4j/wGaGHimeq7rhPJAT1+PVn5Br1Yhh6/r0hISQufhn3As6260lgV6aDc+NPYJJuIiBrTmCGuTwXgb VZxg10Xk8l17oJ/im7cUFAS4CHwkpKdDb6kOR/mFrJNNYOeroELnwegxPSiG5Rz3tpyYvcAS9oIDEZ u9wiQQxEInAFRRPb/02UZv2J8SfgXlpIi4yXcFOM7STm300zlrYh3ATADvbDFYahztKBpS4YJrbeyS D1zH8SIbgjQp6KC9oZq1iEa09XIax78C6jbM0TCt8c+EWAvsRBfJ7xlUNOh3vq8Kskvyi4EVC7vf2C pm/3rfff/k8d0zx36ABl0thqyERdny
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

The function no longer does what its name and comment suggests, and just
sets two struct page fields, which can be done directly in its sole
caller.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Roman Gushchin <guro@fb.com>
---
 mm/slab.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index ca4822f6b2b6..381875e23277 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2546,18 +2546,6 @@ static void slab_put_obj(struct kmem_cache *cachep,
 	set_free_obj(page, page->active, objnr);
 }
 
-/*
- * Map pages beginning at addr to the given cache and slab. This is required
- * for the slab allocator to be able to lookup the cache and slab of a
- * virtual address for kfree, ksize, and slab debugging.
- */
-static void slab_map_pages(struct kmem_cache *cache, struct page *page,
-			   void *freelist)
-{
-	page->slab_cache = cache;
-	page->freelist = freelist;
-}
-
 /*
  * Grow (by 1) the number of slabs within a cache.  This is called by
  * kmem_cache_alloc() when there are no active objs left in a cache.
@@ -2621,7 +2609,8 @@ static struct page *cache_grow_begin(struct kmem_cache *cachep,
 	if (OFF_SLAB(cachep) && !freelist)
 		goto opps1;
 
-	slab_map_pages(cachep, page, freelist);
+	page->slab_cache = cachep;
+	page->freelist = freelist;
 
 	cache_init_objs(cachep, page);
 
-- 
2.34.1

