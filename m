Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223022CA8
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:23 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A30DF218D9;
	Wed,  1 Dec 2021 18:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382519; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/8AMLYvdpfTtBdZFcpvfDY+08zMPxrszJpq3L8Y4IkI=;
	b=A5ZDyy0DwEtkKOY46fXuMpzX2K2K0tBwv5pfKgjPDfS5uJQBYE6peA00kbLIymsJaUaiyc
	qpTUe2h4+IHgKzRbNvn4bYS7H7S2zXgfTpywD9tdHoPq/LY76Z9hibYtzPigIfp/MTvXJC
	IjRq0pl4uwJJiT8dLplok49BDtwsIX0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382519;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/8AMLYvdpfTtBdZFcpvfDY+08zMPxrszJpq3L8Y4IkI=;
	b=y5yHBIwhkjmyPET4XTB/DaXSQ4QvlltquSEF2FiOUsqCDpWZXpQDodCvcXdG5oaIgvKamy
	S27kuahzkhAvKDDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 804C613D9D;
	Wed,  1 Dec 2021 18:15:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id aBO2Hre7p2HPSAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 01 Dec 2021 18:15:19 +0000
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
Subject: [PATCH v2 24/33] mm/slob: Convert SLOB to use struct slab
Date: Wed,  1 Dec 2021 19:15:01 +0100
Message-Id: <20211201181510.18784-25-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3794; i=vbabka@suse.cz; h=from:subject; bh=xa214YLDtbNUR9XtnN+78HMPqwWCI0KceeNn5J2llgk=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7uUM5ZvyXBhOt83ZAlKuo/T27s4yLaQth/3ox1G pQRJuYuJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7lAAKCRDgIcpz8YmpEHXrB/ 9PQLY2NBX4I6k6ddxtLuVK8Ut9r4hMykmlMZKoNRWJWoKNvjulpU1s/2JwOOVxy0iDzArEVL83pR9R pjZ9RSAm5eXXodJnAlRzKF8/dn3MWM74eJNhZqjx4oGDtZvdm9c7ajg8RuIxthzFyM3TxB/eDHdpJu uf8zfEjWvwr8boxkXXtgcHJjdPD9Vefis6K2v+s91T+MNu1H9tNZG+NPNLEUQyuaJUGI8/+crTPQyj o3elbbiPYjjZcC0P/eLiqTKzH3banYY/IoZVU6/kR+C6SqjMJNxsAQ3ploBm/nLWiLOBBI1WFAMPZb vSVk6tF1XVmLfSlPSDcCOn/15pI6ux
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Use struct slab throughout the slob allocator.

[ vbabka@suse.cz: don't introduce wrappers for PageSlobFree in mm/slab.h just
  for the single callers being wrappers in mm/slob.c ]

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slob.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/mm/slob.c b/mm/slob.c
index d2d15e7f191c..d3512bcc3141 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -105,21 +105,21 @@ static LIST_HEAD(free_slob_large);
 /*
  * slob_page_free: true for pages on free_slob_pages list.
  */
-static inline int slob_page_free(struct page *sp)
+static inline int slob_page_free(struct slab *slab)
 {
-	return PageSlobFree(sp);
+	return PageSlobFree(slab_page(slab));
 }
 
-static void set_slob_page_free(struct page *sp, struct list_head *list)
+static void set_slob_page_free(struct slab *slab, struct list_head *list)
 {
-	list_add(&sp->slab_list, list);
-	__SetPageSlobFree(sp);
+	list_add(&slab->slab_list, list);
+	__SetPageSlobFree(slab_page(slab));
 }
 
-static inline void clear_slob_page_free(struct page *sp)
+static inline void clear_slob_page_free(struct slab *slab)
 {
-	list_del(&sp->slab_list);
-	__ClearPageSlobFree(sp);
+	list_del(&slab->slab_list);
+	__ClearPageSlobFree(slab_page(slab));
 }
 
 #define SLOB_UNIT sizeof(slob_t)
@@ -234,7 +234,7 @@ static void slob_free_pages(void *b, int order)
  *         freelist, in this case @page_removed_from_list will be set to
  *         true (set to false otherwise).
  */
-static void *slob_page_alloc(struct page *sp, size_t size, int align,
+static void *slob_page_alloc(struct slab *sp, size_t size, int align,
 			      int align_offset, bool *page_removed_from_list)
 {
 	slob_t *prev, *cur, *aligned = NULL;
@@ -301,7 +301,7 @@ static void *slob_page_alloc(struct page *sp, size_t size, int align,
 static void *slob_alloc(size_t size, gfp_t gfp, int align, int node,
 							int align_offset)
 {
-	struct page *sp;
+	struct slab *sp;
 	struct list_head *slob_list;
 	slob_t *b = NULL;
 	unsigned long flags;
@@ -323,7 +323,7 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align, int node,
 		 * If there's a node specification, search for a partial
 		 * page with a matching node id in the freelist.
 		 */
-		if (node != NUMA_NO_NODE && page_to_nid(sp) != node)
+		if (node != NUMA_NO_NODE && slab_nid(sp) != node)
 			continue;
 #endif
 		/* Enough room on this page? */
@@ -358,8 +358,8 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align, int node,
 		b = slob_new_pages(gfp & ~__GFP_ZERO, 0, node);
 		if (!b)
 			return NULL;
-		sp = virt_to_page(b);
-		__SetPageSlab(sp);
+		sp = virt_to_slab(b);
+		__SetPageSlab(slab_page(sp));
 
 		spin_lock_irqsave(&slob_lock, flags);
 		sp->units = SLOB_UNITS(PAGE_SIZE);
@@ -381,7 +381,7 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align, int node,
  */
 static void slob_free(void *block, int size)
 {
-	struct page *sp;
+	struct slab *sp;
 	slob_t *prev, *next, *b = (slob_t *)block;
 	slobidx_t units;
 	unsigned long flags;
@@ -391,7 +391,7 @@ static void slob_free(void *block, int size)
 		return;
 	BUG_ON(!size);
 
-	sp = virt_to_page(block);
+	sp = virt_to_slab(block);
 	units = SLOB_UNITS(size);
 
 	spin_lock_irqsave(&slob_lock, flags);
@@ -401,8 +401,8 @@ static void slob_free(void *block, int size)
 		if (slob_page_free(sp))
 			clear_slob_page_free(sp);
 		spin_unlock_irqrestore(&slob_lock, flags);
-		__ClearPageSlab(sp);
-		page_mapcount_reset(sp);
+		__ClearPageSlab(slab_page(sp));
+		page_mapcount_reset(slab_page(sp));
 		slob_free_pages(b, 0);
 		return;
 	}
-- 
2.33.1

