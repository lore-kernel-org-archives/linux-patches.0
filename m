Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156F26FAD
	for <patches@lists.linux.dev>; Mon, 21 Nov 2022 17:12:13 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 46D35220D3;
	Mon, 21 Nov 2022 17:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1669050731; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AE6b9Ip1Jv26Xwgek6onVQxbl/nnvniL1XqPDrcyQQ0=;
	b=1/VTn6d3nJ/r68CevB7e+wCDMbxnR2MTtiL6t4eG83n1/xPF5FDa5TmLbvbToZhzqKsJsG
	l1H1iDYpN0lQy3MhKDXrvHx79gVP4a2M9w5yso/OsBylq5lk7y6JIffE9GuiS/e/MVuRij
	9KhvvDaOCrn9Ol6Lx7067yqcmG2QFS0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1669050731;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AE6b9Ip1Jv26Xwgek6onVQxbl/nnvniL1XqPDrcyQQ0=;
	b=bBKuH2Y7eX+L9HTCPMnlLbK53G+n/K2K3+rWDVILDjbkeZm8pOwpFzT1RXpbmwxlkx6vMn
	KbqVlik0Z4wWhlBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1AB361377F;
	Mon, 21 Nov 2022 17:12:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id EJ7dBWuxe2MQeQAAMHmgww
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
Subject: [PATCH 04/12] mm, slub: retain no free slabs on partial list with CONFIG_SLUB_TINY
Date: Mon, 21 Nov 2022 18:11:54 +0100
Message-Id: <20221121171202.22080-5-vbabka@suse.cz>
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

SLUB will leave a number of slabs on the partial list even if they are
empty, to avoid some slab freeing and reallocation. The goal of
CONFIG_SLUB_TINY is to minimize memory overhead, so set the limits to 0
for immediate slab page freeing.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index ab085aa2f1f0..917b79278bad 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -241,6 +241,7 @@ static inline bool kmem_cache_has_cpu_partial(struct kmem_cache *s)
 /* Enable to log cmpxchg failures */
 #undef SLUB_DEBUG_CMPXCHG
 
+#ifndef CONFIG_SLUB_TINY
 /*
  * Minimum number of partial slabs. These will be left on the partial
  * lists even if they are empty. kmem_cache_shrink may reclaim them.
@@ -253,6 +254,10 @@ static inline bool kmem_cache_has_cpu_partial(struct kmem_cache *s)
  * sort the partial list by the number of objects in use.
  */
 #define MAX_PARTIAL 10
+#else
+#define MIN_PARTIAL 0
+#define MAX_PARTIAL 0
+#endif
 
 #define DEBUG_DEFAULT_FLAGS (SLAB_CONSISTENCY_CHECKS | SLAB_RED_ZONE | \
 				SLAB_POISON | SLAB_STORE_USER)
-- 
2.38.1

