Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693712C9D
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:23 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8A7F41FD5D;
	Wed,  1 Dec 2021 18:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382515; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jn+6GPK2k/C9lWYc6NViZGzCjYmx5JN3u87TgpqX4L4=;
	b=prNEptaCL7Q0PiDy624UVC6pmGBQsFZ1YnK8rz+Eg2d5F2hOjyIvp77KPxtxiZOrNUGHNi
	0ZQ4baYPgqk46tXDaklBqOLtIzKfV1HzTSvcjwcHLU6qxYwlFQtjpyLZQPHKoO+uu47OcB
	cR4l/cq19ptpMmL4twhqlJENVg+BB1Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382515;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jn+6GPK2k/C9lWYc6NViZGzCjYmx5JN3u87TgpqX4L4=;
	b=m3IWFCG4o0841ptrWa7o1uvLXQhknrwHKA+pPAoao47LBFl9vA6SzrmOvWAhVq/jWKzrji
	Hbm7mOGbaBSk6cAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 675DC13D9D;
	Wed,  1 Dec 2021 18:15:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id iC6kGLO7p2HPSAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 01 Dec 2021 18:15:15 +0000
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
Subject: [PATCH v2 02/33] mm/slab: Dissolve slab_map_pages() in its caller
Date: Wed,  1 Dec 2021 19:14:39 +0100
Message-Id: <20211201181510.18784-3-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1369; h=from:subject; bh=s5BHDQ9ShCOrZi/zSAN4+X2nIjPUcPGwiH3G+H994yM=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7thRziLLb6Ja0Y/nOtgnRGInrbvGjtjE84g+JJT VS7r0jGJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7YQAKCRDgIcpz8YmpENNYB/ 4nCqz5Ga4+Hq6FPPILdawUJHmKxyW/Mdv+HUDn1IYLddfeUA9JvPt8SzedC+c9+cg6z8I+txDaGaRR M5jfOW0QJoWXtR9xBQPFKyHyrO6oM0tHxXPL9vHPW+VXVtLfzzaeJnut3Qzni+loRZVwRjgcuZD3vk 9AHnLyVePAhYLPaw+owVdP4MwTiV3nJTznkfwWBIGI1/s0HkL9Mjca2bSMHLKCRfpf4GS02sMyVIWM HW/FjzIQC7EfX1GuWfB7zNsv6Os79UQxuxwsrNiyzqAB1JJHB09ekJvqKDVPYd7ugkWBZjrsClf56k +9tPX9lo/UYnBo/ISKCP2GhgOzW1JS
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

The function no longer does what its name and comment suggests, and just sets
two struct page fields, which can be done directly in its sole caller.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
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
2.33.1

