Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457832CAC
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:22 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id ECD53218D5;
	Wed,  1 Dec 2021 18:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382518; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W2fRPmsPB5LxAUNMejsoLgDZCDH023bhJsBe2+9TQkg=;
	b=xocNJbAzEGzFv10Mqli9paUpd0iqTlLWTtdWd0KwbDGe3X3/hUAMQutjTQb7Zdx343r/7U
	Cp3ShevI5pv3GEt7Yk2xFSg0w2xQOyYOT0KbyQAH+wnwB80hlRL4X3jLvFFAJ+vWIfvQD8
	HZhePi8gbCSoRvdRqBlKYFGXZkmt8XA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382518;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W2fRPmsPB5LxAUNMejsoLgDZCDH023bhJsBe2+9TQkg=;
	b=NFPKzsxH3wpfWs4uJQekQJZfcqStGv5HulMhv0E6Na07sLbYkiprgN62IcMD5Vam3iTTG+
	0GmJTLblzh1pf9CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C9C3E14050;
	Wed,  1 Dec 2021 18:15:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id oF+dMLa7p2HPSAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 01 Dec 2021 18:15:18 +0000
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
Subject: [PATCH v2 21/33] mm/slab: Finish struct page to struct slab conversion
Date: Wed,  1 Dec 2021 19:14:58 +0100
Message-Id: <20211201181510.18784-22-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2668; h=from:subject; bh=20CMJsNmHf7llpkm0IkbVj9CDsYnAJam0AGjdnEvmck=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7uNnFWIMtfdJEVKJYgJJBvPuGRe3a0HEfKU6G2f UoCgyx+JATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7jQAKCRDgIcpz8YmpEJExCA CqWZZMl2avIj8qxF/3H+ulwB/0Bec86KhAKaOqH8ab2Wkods4mCD7mxhsf12FIgVUGO5IJ3fxdnGLC g9py/tiQ5OW6QnHEqIUjghTQsf3dOh0vh4Bqy2u8sQB1x7S9atJPTswuuN/sDu6CCOmW4aWhtbDgrg yNQXwAKGgxPoP25rxoaIx5JsYgewb6xLu5vXUCezOgODC6iuvX9kM0VW0hs+ePD5yNmt8VSV8+N9iY b8LI4cmSZU60vA7ZlbI/1wsVXzB74wTrhHCHOpOAzARVIUj9ZHAOf0eJsyxwrwHYM8yy6wwIVBGTiw uSgiXRXS2ilkPZ0rUmefWCFKsMgUSr
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

Change cache_free_alien() to use slab_nid(virt_to_slab()). Otherwise just
update of comments and some remaining variable names.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 970b3e13b4c1..f0447b087d02 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -793,16 +793,16 @@ static int __cache_free_alien(struct kmem_cache *cachep, void *objp,
 
 static inline int cache_free_alien(struct kmem_cache *cachep, void *objp)
 {
-	int page_node = page_to_nid(virt_to_page(objp));
+	int slab_node = slab_nid(virt_to_slab(objp));
 	int node = numa_mem_id();
 	/*
 	 * Make sure we are not freeing a object from another node to the array
 	 * cache on this cpu.
 	 */
-	if (likely(node == page_node))
+	if (likely(node == slab_node))
 		return 0;
 
-	return __cache_free_alien(cachep, objp, node, page_node);
+	return __cache_free_alien(cachep, objp, node, slab_node);
 }
 
 /*
@@ -1613,10 +1613,10 @@ static void slab_destroy_debugcheck(struct kmem_cache *cachep,
 /**
  * slab_destroy - destroy and release all objects in a slab
  * @cachep: cache pointer being destroyed
- * @page: page pointer being destroyed
+ * @slab: slab being destroyed
  *
- * Destroy all the objs in a slab page, and release the mem back to the system.
- * Before calling the slab page must have been unlinked from the cache. The
+ * Destroy all the objs in a slab, and release the mem back to the system.
+ * Before calling the slab must have been unlinked from the cache. The
  * kmem_cache_node ->list_lock is not held/needed.
  */
 static void slab_destroy(struct kmem_cache *cachep, struct slab *slab)
@@ -2560,7 +2560,7 @@ static struct slab *cache_grow_begin(struct kmem_cache *cachep,
 	void *freelist;
 	size_t offset;
 	gfp_t local_flags;
-	int page_node;
+	int slab_node;
 	struct kmem_cache_node *n;
 	struct slab *slab;
 
@@ -2586,8 +2586,8 @@ static struct slab *cache_grow_begin(struct kmem_cache *cachep,
 	if (!slab)
 		goto failed;
 
-	page_node = slab_nid(slab);
-	n = get_node(cachep, page_node);
+	slab_node = slab_nid(slab);
+	n = get_node(cachep, slab_node);
 
 	/* Get colour for the slab, and cal the next value. */
 	n->colour_next++;
@@ -2609,7 +2609,7 @@ static struct slab *cache_grow_begin(struct kmem_cache *cachep,
 
 	/* Get slab management. */
 	freelist = alloc_slabmgmt(cachep, slab, offset,
-			local_flags & ~GFP_CONSTRAINT_MASK, page_node);
+			local_flags & ~GFP_CONSTRAINT_MASK, slab_node);
 	if (OFF_SLAB(cachep) && !freelist)
 		goto opps1;
 
-- 
2.33.1

