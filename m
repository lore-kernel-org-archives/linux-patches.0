Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1B51E1DC
	for <patches@lists.linux.dev>; Thu, 10 Aug 2023 16:36:41 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B89CB2187D;
	Thu, 10 Aug 2023 16:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1691685393; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cIe5o/xpdmWF4fStDltZQwKQCcPAraOzhHNBE1tj7sI=;
	b=jFDhujQK9jnwYC5KTNeGJCIlO2KBUw/XTV80/Sckd7ry6MpJADq8984Hcb/JcLyttdyOCc
	By0JjZpyPSMRUFs60gV0TZ5tiJmU656Gez67m2SNag97I5yOFGfQMRohSq16iolp/mFQ1E
	r7ASU8hfgP0p2GuDAsPTINkLoM6TUww=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1691685393;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cIe5o/xpdmWF4fStDltZQwKQCcPAraOzhHNBE1tj7sI=;
	b=PdU68wcF1isVbJVPgMJg1tS6L1fRdxB0QJp3XEvCF5yMZ3vLhenlySUtF9nHAX+uGFzMuT
	KyYySGhI6o/rPMDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8FB1C139D1;
	Thu, 10 Aug 2023 16:36:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id SCB6IhES1WSEPQAAMHmgww
	(envelope-from <vbabka@suse.cz>); Thu, 10 Aug 2023 16:36:33 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
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
Subject: [RFC v2 7/7] tools: Add SLUB percpu array functions for testing
Date: Thu, 10 Aug 2023 18:36:35 +0200
Message-ID: <20230810163627.6206-16-vbabka@suse.cz>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230810163627.6206-9-vbabka@suse.cz>
References: <20230810163627.6206-9-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Liam R. Howlett" <Liam.Howlett@oracle.com>

Support new percpu array functions to the test code so they can be used
in the maple tree testing.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 tools/include/linux/slab.h              |  4 ++++
 tools/testing/radix-tree/linux.c        | 14 ++++++++++++++
 tools/testing/radix-tree/linux/kernel.h |  1 +
 3 files changed, 19 insertions(+)

diff --git a/tools/include/linux/slab.h b/tools/include/linux/slab.h
index 311759ea25e9..1043f9c5ef4e 100644
--- a/tools/include/linux/slab.h
+++ b/tools/include/linux/slab.h
@@ -7,6 +7,7 @@
 
 #define SLAB_PANIC 2
 #define SLAB_RECLAIM_ACCOUNT    0x00020000UL            /* Objects are reclaimable */
+#define SLAB_NO_MERGE		0x01000000UL		/* Prevent merging with compatible kmem caches */
 
 #define kzalloc_node(size, flags, node) kmalloc(size, flags)
 
@@ -45,4 +46,7 @@ void kmem_cache_free_bulk(struct kmem_cache *cachep, size_t size, void **list);
 int kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t size,
 			  void **list);
 
+int kmem_cache_setup_percpu_array(struct kmem_cache *s, unsigned int count);
+int kmem_cache_prefill_percpu_array(struct kmem_cache *s, unsigned int count,
+		gfp_t gfp);
 #endif		/* _TOOLS_SLAB_H */
diff --git a/tools/testing/radix-tree/linux.c b/tools/testing/radix-tree/linux.c
index d587a558997f..cbe7937fdd5e 100644
--- a/tools/testing/radix-tree/linux.c
+++ b/tools/testing/radix-tree/linux.c
@@ -187,6 +187,20 @@ int kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t size,
 	return size;
 }
 
+int kmem_cache_setup_percpu_array(struct kmem_cache *s, unsigned int count)
+{
+	return 0;
+}
+
+int kmem_cache_prefill_percpu_array(struct kmem_cache *s, unsigned int count,
+		gfp_t gfp)
+{
+	if (count > s->non_kernel)
+		return s->non_kernel;
+
+	return count;
+}
+
 struct kmem_cache *
 kmem_cache_create(const char *name, unsigned int size, unsigned int align,
 		unsigned int flags, void (*ctor)(void *))
diff --git a/tools/testing/radix-tree/linux/kernel.h b/tools/testing/radix-tree/linux/kernel.h
index c5c9d05f29da..fc75018974de 100644
--- a/tools/testing/radix-tree/linux/kernel.h
+++ b/tools/testing/radix-tree/linux/kernel.h
@@ -15,6 +15,7 @@
 
 #define printk printf
 #define pr_err printk
+#define pr_warn printk
 #define pr_info printk
 #define pr_debug printk
 #define pr_cont printk
-- 
2.41.0

