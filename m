Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FC7DDBF
	for <patches@lists.linux.dev>; Tue,  8 Aug 2023 09:53:54 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BB09221C21;
	Tue,  8 Aug 2023 09:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1691488432; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X+E0unmCYoA/5q96uLhFby2/QU/JbMexzKmCXmErmbw=;
	b=JuHIK5yA07vWudODvORFefuFMGecT3WRUyFcG8HubBRT64OpJEFUdDEl52fFQ6gz4H90kv
	ISXwJNf7MbV3Wd1UHDOlLh6ux3vyjmJtY8aOpXZlfV2j0fAloFWTumEgSdimGKJIpjMF0J
	glyqRd0MduDW1F5GfTB24ayFXh4xtUo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1691488432;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X+E0unmCYoA/5q96uLhFby2/QU/JbMexzKmCXmErmbw=;
	b=8lR8OBOOUrNsZP5iXkEKBSPRcGaYP8iGo6k7WS/5Qv5TNNAqaGgIxraAPd11BDjhyHllGM
	Q5rHU4gmYa6PUnDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8F110139E9;
	Tue,  8 Aug 2023 09:53:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id +FJRIrAQ0mSBJQAAMHmgww
	(envelope-from <vbabka@suse.cz>); Tue, 08 Aug 2023 09:53:52 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Pekka Enberg <penberg@kernel.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [RFC v1 1/5] mm, slub: fix bulk alloc and free stats
Date: Tue,  8 Aug 2023 11:53:44 +0200
Message-ID: <20230808095342.12637-8-vbabka@suse.cz>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230808095342.12637-7-vbabka@suse.cz>
References: <20230808095342.12637-7-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The SLUB sysfs stats enabled CONFIG_SLUB_STATS have two deficiencies
identified wrt bulk alloc/free operations:

- Bulk allocations from cpu freelist are not counted. Add the
  ALLOC_FASTPATH counter there.

- Bulk fastpath freeing will count a list of multiple objects with a
  single FREE_FASTPATH inc. Add a stat_add() variant to count them all.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index e3b5d5c0eb3a..a9437d48840c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -341,6 +341,14 @@ static inline void stat(const struct kmem_cache *s, enum stat_item si)
 #endif
 }
 
+static inline void stat_add(const struct kmem_cache *s, enum stat_item si, int v)
+{
+#ifdef CONFIG_SLUB_STATS
+	raw_cpu_add(s->cpu_slab->stat[si], v);
+#endif
+}
+
+
 /*
  * Tracks for which NUMA nodes we have kmem_cache_nodes allocated.
  * Corresponds to node_state[N_NORMAL_MEMORY], but can temporarily
@@ -3776,7 +3784,7 @@ static __always_inline void do_slab_free(struct kmem_cache *s,
 
 		local_unlock(&s->cpu_slab->lock);
 	}
-	stat(s, FREE_FASTPATH);
+	stat_add(s, FREE_FASTPATH, cnt);
 }
 #else /* CONFIG_SLUB_TINY */
 static void do_slab_free(struct kmem_cache *s,
@@ -3978,6 +3986,7 @@ static inline int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
 		c->freelist = get_freepointer(s, object);
 		p[i] = object;
 		maybe_wipe_obj_freeptr(s, p[i]);
+		stat(s, ALLOC_FASTPATH);
 	}
 	c->tid = next_tid(c->tid);
 	local_unlock_irqrestore(&s->cpu_slab->lock, irqflags);
-- 
2.41.0

