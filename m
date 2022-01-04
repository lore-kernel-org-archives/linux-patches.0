Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4E32CAE
	for <patches@lists.linux.dev>; Tue,  4 Jan 2022 00:11:01 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 697021F3A0;
	Tue,  4 Jan 2022 00:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641255058; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k1aP1H3gZub0Fj1TB2XSfEIIHHSvF+Is3iFZ5RrJTgo=;
	b=AUkRrizXz8k2/mXfhqQzMK43Jnyc1U0H0SCpHJclIjLKg8zuKUyIB5jerBL8U0jTOChjpb
	J8OLPhaTMNyqB/BDo/mEPfgCtRwAB3kYwzHcGPTQk24yuBY51njuT2O6J3a4jquXgkEwCk
	iH/DjHSTWMQmPmA7zzI+JacxK/C/sWQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641255058;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k1aP1H3gZub0Fj1TB2XSfEIIHHSvF+Is3iFZ5RrJTgo=;
	b=O1wL2eL5EL/VOD4US9V7uVuTWm812SNW3AHG86VzoOOgEdbVp9bwtjP65FBc6jxOJuBt6O
	DOp/KGhF4A1fKuAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2729B139EE;
	Tue,  4 Jan 2022 00:10:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id yPvnCJKQ02FEQwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Tue, 04 Jan 2022 00:10:58 +0000
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
	Vlastimil Babka <vbabka@suse.cz>,
	Marco Elver <elver@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	kasan-dev@googlegroups.com
Subject: [PATCH v4 27/32] mm/sl*b: Differentiate struct slab fields by sl*b implementations
Date: Tue,  4 Jan 2022 01:10:41 +0100
Message-Id: <20220104001046.12263-28-vbabka@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104001046.12263-1-vbabka@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4766; h=from:subject; bh=tzoD5++2YRy16vDKaIssaQ11l6KE3UqozYmvo9wnsUo=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBh05CBUaOSgvHFSWfYNQ4OVMfEVJdV8pJr0zGLPgk3 fR6keFaJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYdOQgQAKCRDgIcpz8YmpEBBuCA Cw7EXv/xlgmv/hcrOed+zE/fI/RI/FRRCDSDuMmcfvoYzDeKIjNV9sqyZWHgV865oHL3Fe7AbdSYZ+ BXrHvt3HfRuVnJproPRjZObTtCpxjGWFLxxyYQoLtcx02sMBejWxH4wdGSpyZzk2tZQS4lu/xjvOWs Un2Dd0ytGhdC2mdgM1iftxK03tsxDZdV26h64VQl8SYKQGilonMTDAyTas1f2bUfeRMhWowysCg1T5 bcbYbbCk51RDM9muuUPhjls+OSTLImgbKgaUj9YHClM4+Ltc33ZZHZcuc6Oqs55uZa8Tsl1wnc9sZ5 2GkVgj3yETuHGit/M8HQ3BbV8eLHMw
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

With a struct slab definition separate from struct page, we can go
further and define only fields that the chosen sl*b implementation uses.
This means everything between __page_flags and __page_refcount
placeholders now depends on the chosen CONFIG_SL*B. Some fields exist in
all implementations (slab_list) but can be part of a union in some, so
it's simpler to repeat them than complicate the definition with ifdefs
even more.

The patch doesn't change physical offsets of the fields, although it
could be done later - for example it's now clear that tighter packing in
SLOB could be possible.

This should also prevent accidental use of fields that don't exist in
given implementation. Before this patch virt_to_cache() and
cache_from_obj() were visible for SLOB (albeit not used), although they
rely on the slab_cache field that isn't set by SLOB. With this patch
it's now a compile error, so these functions are now hidden behind
an #ifndef CONFIG_SLOB.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Marco Elver <elver@google.com> # kfence
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: <kasan-dev@googlegroups.com>
---
 mm/kfence/core.c |  9 +++++----
 mm/slab.h        | 48 ++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 4eb60cf5ff8b..267dfde43b91 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -427,10 +427,11 @@ static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t g
 	/* Set required slab fields. */
 	slab = virt_to_slab((void *)meta->addr);
 	slab->slab_cache = cache;
-	if (IS_ENABLED(CONFIG_SLUB))
-		slab->objects = 1;
-	if (IS_ENABLED(CONFIG_SLAB))
-		slab->s_mem = addr;
+#if defined(CONFIG_SLUB)
+	slab->objects = 1;
+#elif defined(CONFIG_SLAB)
+	slab->s_mem = addr;
+#endif
 
 	/* Memory initialization. */
 	for_each_canary(meta, set_canary_byte);
diff --git a/mm/slab.h b/mm/slab.h
index 36e0022d8267..b8da249f44f9 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -8,9 +8,24 @@
 /* Reuses the bits in struct page */
 struct slab {
 	unsigned long __page_flags;
+
+#if defined(CONFIG_SLAB)
+
 	union {
 		struct list_head slab_list;
-		struct {	/* Partial pages */
+		struct rcu_head rcu_head;
+	};
+	struct kmem_cache *slab_cache;
+	void *freelist;	/* array of free object indexes */
+	void *s_mem;	/* first object */
+	unsigned int active;
+
+#elif defined(CONFIG_SLUB)
+
+	union {
+		struct list_head slab_list;
+		struct rcu_head rcu_head;
+		struct {
 			struct slab *next;
 #ifdef CONFIG_64BIT
 			int slabs;	/* Nr of slabs left */
@@ -18,25 +33,32 @@ struct slab {
 			short int slabs;
 #endif
 		};
-		struct rcu_head rcu_head;
 	};
-	struct kmem_cache *slab_cache; /* not slob */
+	struct kmem_cache *slab_cache;
 	/* Double-word boundary */
 	void *freelist;		/* first free object */
 	union {
-		void *s_mem;	/* slab: first object */
-		unsigned long counters;		/* SLUB */
-		struct {			/* SLUB */
+		unsigned long counters;
+		struct {
 			unsigned inuse:16;
 			unsigned objects:15;
 			unsigned frozen:1;
 		};
 	};
+	unsigned int __unused;
+
+#elif defined(CONFIG_SLOB)
+
+	struct list_head slab_list;
+	void *__unused_1;
+	void *freelist;		/* first free block */
+	void *__unused_2;
+	int units;
+
+#else
+#error "Unexpected slab allocator configured"
+#endif
 
-	union {
-		unsigned int active;		/* SLAB */
-		int units;			/* SLOB */
-	};
 	atomic_t __page_refcount;
 #ifdef CONFIG_MEMCG
 	unsigned long memcg_data;
@@ -48,10 +70,14 @@ struct slab {
 SLAB_MATCH(flags, __page_flags);
 SLAB_MATCH(compound_head, slab_list);	/* Ensure bit 0 is clear */
 SLAB_MATCH(slab_list, slab_list);
+#ifndef CONFIG_SLOB
 SLAB_MATCH(rcu_head, rcu_head);
 SLAB_MATCH(slab_cache, slab_cache);
+#endif
+#ifdef CONFIG_SLAB
 SLAB_MATCH(s_mem, s_mem);
 SLAB_MATCH(active, active);
+#endif
 SLAB_MATCH(_refcount, __page_refcount);
 #ifdef CONFIG_MEMCG
 SLAB_MATCH(memcg_data, memcg_data);
@@ -602,6 +628,7 @@ static inline void memcg_slab_free_hook(struct kmem_cache *s,
 }
 #endif /* CONFIG_MEMCG_KMEM */
 
+#ifndef CONFIG_SLOB
 static inline struct kmem_cache *virt_to_cache(const void *obj)
 {
 	struct slab *slab;
@@ -648,6 +675,7 @@ static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
 		print_tracking(cachep, x);
 	return cachep;
 }
+#endif /* CONFIG_SLOB */
 
 static inline size_t slab_ksize(const struct kmem_cache *s)
 {
-- 
2.34.1

