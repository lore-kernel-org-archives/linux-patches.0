Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54B4DDBC
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 10:28:36 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F36191FD83;
	Tue, 13 Jun 2023 10:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1686652109; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=EMHePs1faHT6iyB5lSxLCoJsx639PDQbw4C00e95wXg=;
	b=F5fPhSBfKnZ8R9XyblIDCqW8XJ9JEbYDManCJo9ZK9XECcqxpPMJlEd9SFpBJgjsMANLwX
	T3Lil5t/R42BBzMEOOyUttqmj9YRDHCCk5o1Y0cfsPwd2+brd4CKa7p7u5DZmmAaE2CCMX
	CEezipqJXD9nqpF+BH/fSa3MqhvEwKc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1686652109;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=EMHePs1faHT6iyB5lSxLCoJsx639PDQbw4C00e95wXg=;
	b=+PPBBfWl1DCFRirIRgtsqZQWJIDcrnftO/0rC0cYIe10gpL97/LGIgLC9npBEnPRm4foQ1
	cLNgEouTzYKy+HDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CB06613483;
	Tue, 13 Jun 2023 10:28:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id tYjRMMxEiGRWcwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Tue, 13 Jun 2023 10:28:28 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Pekka Enberg <penberg@kernel.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH] mm/slab_common: use SLAB_NO_MERGE instead of negative refcount
Date: Tue, 13 Jun 2023 12:28:21 +0200
Message-ID: <20230613102820.19153-2-vbabka@suse.cz>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When CONFIG_MEMCG_KMEM is enabled, we disable cache merging for
KMALLOC_NORMAL so they don't end up merged with a cache that uses ad-hoc
__GFP_ACCOUNT. This was implemented by setting refcount to -1, but now
we have a proper SLAB_NO_MERGE flag, so use that instead.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab_common.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 0e0a617eae7d..67caf0bc3194 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -878,17 +878,17 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type, slab_flags_t flags)
 		flags |= SLAB_CACHE_DMA;
 	}
 
-	kmalloc_caches[type][idx] = create_kmalloc_cache(
-					kmalloc_info[idx].name[type],
-					kmalloc_info[idx].size, flags, 0,
-					kmalloc_info[idx].size);
-
 	/*
 	 * If CONFIG_MEMCG_KMEM is enabled, disable cache merging for
 	 * KMALLOC_NORMAL caches.
 	 */
 	if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_NORMAL))
-		kmalloc_caches[type][idx]->refcount = -1;
+		flags |= SLAB_NO_MERGE;
+
+	kmalloc_caches[type][idx] = create_kmalloc_cache(
+					kmalloc_info[idx].name[type],
+					kmalloc_info[idx].size, flags, 0,
+					kmalloc_info[idx].size);
 }
 
 /*
-- 
2.41.0

