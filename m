Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7018A6FAF
	for <patches@lists.linux.dev>; Mon, 21 Nov 2022 17:12:13 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A4DD21F8B5;
	Mon, 21 Nov 2022 17:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1669050731; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dwCHqKtNWwOZkhmH0ZzjrvRXVmU5GqeQoEQZzyxt9n8=;
	b=mzbdeZV88nwMJZERHp+MxXlxhLuB+ykt8joysBTSggmyh+1h/eKA6pjRb67jY7IJfiK3++
	TUSJ8ThVLF9cR87APpWHkMjZXkxns2qobBRdsatFT6Z8+B78H8pg+1e8yL7zdJriIJACeW
	SAQXkURnU8HJ5xEpv5MTvds2GD3FRgk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1669050731;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dwCHqKtNWwOZkhmH0ZzjrvRXVmU5GqeQoEQZzyxt9n8=;
	b=/Q1Dwl+GqymCzCwHjoL2MulHeNdgBKkXPw8jB4vzjZJWHTg7KKAC5SiHCtQa6lL5fIh770
	lcxE/2aEcQszx0Bw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 789241377F;
	Mon, 21 Nov 2022 17:12:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 2OHiHGuxe2MQeQAAMHmgww
	(envelope-from <vbabka@suse.cz>); Mon, 21 Nov 2022 17:12:11 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	patches@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 06/12] mm, slub: don't create kmalloc-rcl caches with CONFIG_SLUB_TINY
Date: Mon, 21 Nov 2022 18:11:56 +0100
Message-Id: <20221121171202.22080-7-vbabka@suse.cz>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221121171202.22080-1-vbabka@suse.cz>
References: <20221121171202.22080-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Distinguishing kmalloc(__GFP_RECLAIMABLE) can help against fragmentation
by grouping pages by mobility, but on tiny systems the extra memory
overhead of separate set of kmalloc-rcl caches will probably be worse,
and mobility grouping likely disabled anyway.

Thus with CONFIG_SLUB_TINY, don't create kmalloc-rcl caches and use the
regular ones.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/slab.h |  4 ++++
 mm/slab_common.c     | 10 ++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 45efc6c553b8..3ce9474c90ab 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -339,7 +339,11 @@ enum kmalloc_cache_type {
 #else
 	KMALLOC_CGROUP,
 #endif
+#ifndef CONFIG_SLUB_TINY
 	KMALLOC_RECLAIM,
+#else
+	KMALLOC_RECLAIM = KMALLOC_NORMAL,
+#endif
 #ifdef CONFIG_ZONE_DMA
 	KMALLOC_DMA,
 #endif
diff --git a/mm/slab_common.c b/mm/slab_common.c
index a8cb5de255fc..907d52963806 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -770,10 +770,16 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
 #define KMALLOC_CGROUP_NAME(sz)
 #endif
 
+#ifndef CONFIG_SLUB_TINY
+#define KMALLOC_RCL_NAME(sz)	.name[KMALLOC_RECLAIM] = "kmalloc-rcl-" #sz,
+#else
+#define KMALLOC_RCL_NAME(sz)
+#endif
+
 #define INIT_KMALLOC_INFO(__size, __short_size)			\
 {								\
 	.name[KMALLOC_NORMAL]  = "kmalloc-" #__short_size,	\
-	.name[KMALLOC_RECLAIM] = "kmalloc-rcl-" #__short_size,	\
+	KMALLOC_RCL_NAME(__short_size)				\
 	KMALLOC_CGROUP_NAME(__short_size)			\
 	KMALLOC_DMA_NAME(__short_size)				\
 	.size = __size,						\
@@ -859,7 +865,7 @@ void __init setup_kmalloc_cache_index_table(void)
 static void __init
 new_kmalloc_cache(int idx, enum kmalloc_cache_type type, slab_flags_t flags)
 {
-	if (type == KMALLOC_RECLAIM) {
+	if ((KMALLOC_RECLAIM != KMALLOC_NORMAL) && (type == KMALLOC_RECLAIM)) {
 		flags |= SLAB_RECLAIM_ACCOUNT;
 	} else if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_CGROUP)) {
 		if (mem_cgroup_kmem_disabled()) {
-- 
2.38.1

