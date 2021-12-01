Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A7A2CA4
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:27 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EE5B51FE00;
	Wed,  1 Dec 2021 18:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382520; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XZjPNTGeYgeJU7BzAGxIgYnoqBmAt3jbNWLNHSCHwj8=;
	b=tFIyyHyXhefRcMZhzoPmf7dKmh0Lqk3fXjGe4oRb4rRLFF3hmx9VCSKnTwouT5jl3uNkMj
	HW3te9peW3oY8j8RTaOljIQG2reTkTlfru/6D/bICIkm69MvLQd5UQOWpFfS9pYK44bCNR
	JSq0E7L9ELoToAGcfX6nf/Ckyssrhew=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382520;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XZjPNTGeYgeJU7BzAGxIgYnoqBmAt3jbNWLNHSCHwj8=;
	b=uEE09zEvA3IQB94KFE2ThSsGe3tZeOOXI2cZEzFBVva5LdsWRuIe0Wk52UK+a9GzXhpCj7
	Mho9LeMTCRQijFAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BAE1214050;
	Wed,  1 Dec 2021 18:15:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id ILcZLbi7p2HPSAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 01 Dec 2021 18:15:20 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: Matthew Wilcox <willy@infradead.org>,
	Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>
Cc: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	Marco Elver <elver@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	kasan-dev@googlegroups.com
Subject: [PATCH v2 31/33] mm/sl*b: Differentiate struct slab fields by sl*b implementations
Date: Wed,  1 Dec 2021 19:15:08 +0100
Message-Id: <20211201181510.18784-32-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4577; h=from:subject; bh=VqBKrlF8E1KP8dUW3jPbmTVnQ1WbeBkExRZte4OfzrU=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7unZdUzLs0RNxbE/xmUdWJ810YKUGhGeSZfPW6o 7rs8ZZ2JATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7pwAKCRDgIcpz8YmpEIPsB/ 9/DvPvnX4saooYE2CjNL/WpfwKE9KVeMTAfr2tSHpcIbRGXVO4R5UjvNOGzrOfs15j2/BgmZ2zBqrM FcwzelfEE+fyPKRmfzCLhfNbrCGQY+1wP/p07yHmAuV/Qco3xyynOf0epe0HDPhXa2AljhKEflo+U/ lef6W9BycDdK1D8Bjka9VgpPbrTJsSiSn72/qpX2KPmYBvGM8xbw5LeiY1y4WuiLWJQQfaNwUAyURt zDpxfztinl2aDcm0yetB/cGl3RcXxYBwRbWiW4hUbo6bESX32RnCR297fo35LbADHhEuA9bVcOs2t5 jo1r/oPaVD5EClfgWhqm5bor1t37SQ
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

With a struct slab definition separate from struct page, we can go further and
define only fields that the chosen sl*b implementation uses. This means
everything between __page_flags and __page_refcount placeholders now depends on
the chosen CONFIG_SL*B. Some fields exist in all implementations (slab_list)
but can be part of a union in some, so it's simpler to repeat them than
complicate the definition with ifdefs even more.

The patch doesn't change physical offsets of the fields, although it could be
done later - for example it's now clear that tighter packing in SLOB could be
possible.

This should also prevent accidental use of fields that don't exist in given
implementation. Before this patch virt_to_cache() and and cache_from_obj() was
visible for SLOB (albeit not used), although it relies on the slab_cache field
that isn't set by SLOB. With this patch it's now a compile error, so these
functions are now hidden behind #ifndef CONFIG_SLOB.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Marco Elver <elver@google.com> # kfence
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: <kasan-dev@googlegroups.com>
---
 mm/kfence/core.c |  9 +++++----
 mm/slab.h        | 46 ++++++++++++++++++++++++++++++++++++----------
 2 files changed, 41 insertions(+), 14 deletions(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 4eb60cf5ff8b..46103a7628a6 100644
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
+#elif defined (CONFIG_SLAB)
+	slab->s_mem = addr;
+#endif
 
 	/* Memory initialization. */
 	for_each_canary(meta, set_canary_byte);
diff --git a/mm/slab.h b/mm/slab.h
index 2d50c099a222..8c5a8c005896 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -8,9 +8,24 @@
 /* Reuses the bits in struct page */
 struct slab {
 	unsigned long __page_flags;
+
+#if defined(CONFIG_SLAB)
+
+	union {
+		struct list_head slab_list;
+		struct rcu_head rcu_head;
+	};
+	struct kmem_cache *slab_cache;
+	void *freelist;	/* array of free object indexes */
+	void * s_mem;	/* first object */
+	unsigned int active;
+
+#elif defined(CONFIG_SLUB)
+
 	union {
 		struct list_head slab_list;
-		struct {	/* Partial pages */
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
+	void * __unused_1;
+	void *freelist;		/* first free block */
+	void * __unused_2;
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
@@ -47,7 +69,9 @@ struct slab {
 	static_assert(offsetof(struct page, pg) == offsetof(struct slab, sl))
 SLAB_MATCH(flags, __page_flags);
 SLAB_MATCH(compound_head, slab_list);	/* Ensure bit 0 is clear */
+#ifndef CONFIG_SLOB
 SLAB_MATCH(rcu_head, rcu_head);
+#endif
 SLAB_MATCH(_refcount, __page_refcount);
 #ifdef CONFIG_MEMCG
 SLAB_MATCH(memcg_data, memcg_data);
@@ -623,6 +647,7 @@ static inline void memcg_slab_free_hook(struct kmem_cache *s,
 }
 #endif /* CONFIG_MEMCG_KMEM */
 
+#ifndef CONFIG_SLOB
 static inline struct kmem_cache *virt_to_cache(const void *obj)
 {
 	struct slab *slab;
@@ -669,6 +694,7 @@ static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
 		print_tracking(cachep, x);
 	return cachep;
 }
+#endif /* CONFIG_SLOB */
 
 static inline size_t slab_ksize(const struct kmem_cache *s)
 {
-- 
2.33.1

