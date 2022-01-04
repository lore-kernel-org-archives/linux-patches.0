Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A28A2C80
	for <patches@lists.linux.dev>; Tue,  4 Jan 2022 00:10:56 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 16720212B5;
	Tue,  4 Jan 2022 00:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641255055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5ScjTvk1Sfc9heHqQ/sk78bm5dZH+BwBlSuUIMAeQzY=;
	b=fJaR7w5ADG7lH8d90jefVvvKyA3zPziFrf9nJOd2U4LiiRMFVQl2au5Z9k7JQsLM/Y9xF3
	qC8YgTTr2faOodJiq+rcbeqHMb50zsN8Sx9HHh54edbGrNUdQHp+ybgtWK8kxy8QupD8zw
	v8gyQ0Q8MQ/Qo36wG93+mwrFazI0NWU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641255055;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5ScjTvk1Sfc9heHqQ/sk78bm5dZH+BwBlSuUIMAeQzY=;
	b=BxvQXRIooPzAIhZ6EU01P1hjviVQS548YMscIlM4h7sDoHHTCjDyDJz23UxULXZGEnRAI6
	MGigPbzvk84ajNAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DCD45139D1;
	Tue,  4 Jan 2022 00:10:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id mG9FNY6Q02FEQwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Tue, 04 Jan 2022 00:10:54 +0000
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
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v4 12/32] mm/slub: Convert __slab_lock() and __slab_unlock() to struct slab
Date: Tue,  4 Jan 2022 01:10:26 +0100
Message-Id: <20220104001046.12263-13-vbabka@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104001046.12263-1-vbabka@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2150; h=from:subject; bh=JrJB+ETBsa311o521h1tS+zFMP6D6xhR8x1cTL40jSs=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBh05BzPWYvBltCXxo/iEdV2gJyng67JpUf6SbWlbFb +h7IeJiJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYdOQcwAKCRDgIcpz8YmpEHEcB/ kBmTc9aXgTgBjk/DD10Eodn32Pa+IophDibgcNfYRH+KQqPtOONcrV7YHE+SRRvWe+PifK5nUTD2sM O0PGMoTqCV3UaHxYZvIb5O5lhdAXuUzVhI27Tf+fZ3wTYX1lcglrmE1zPGtYxPOXiimqi5nrGYbshF RCq/0wHkE4hL0yuWL7dogKMh8TvFAgv5IhgQNh6aR74CvMpGLX/d3go/SW4o+tzWNNCbFMeqoh9C4Q wNAZ3xc+9jvxkD9IesunCFoIuBMysn5KwVOhau2QM2qLYlTITjq0x+W4kAWInM9uTzIONB7kGexVmy XbkL/vT2ZHXNJtMV2zxGwyW9nJNiMz
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

These functions operate on the PG_locked page flag, but make them accept
struct slab to encapsulate this implementation detail.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Roman Gushchin <guro@fb.com>
---
 mm/slub.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index acf2608a57c5..14550e7bee71 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -440,14 +440,18 @@ slub_set_cpu_partial(struct kmem_cache *s, unsigned int nr_objects)
 /*
  * Per slab locking using the pagelock
  */
-static __always_inline void __slab_lock(struct page *page)
+static __always_inline void __slab_lock(struct slab *slab)
 {
+	struct page *page = slab_page(slab);
+
 	VM_BUG_ON_PAGE(PageTail(page), page);
 	bit_spin_lock(PG_locked, &page->flags);
 }
 
-static __always_inline void __slab_unlock(struct page *page)
+static __always_inline void __slab_unlock(struct slab *slab)
 {
+	struct page *page = slab_page(slab);
+
 	VM_BUG_ON_PAGE(PageTail(page), page);
 	__bit_spin_unlock(PG_locked, &page->flags);
 }
@@ -456,12 +460,12 @@ static __always_inline void slab_lock(struct page *page, unsigned long *flags)
 {
 	if (IS_ENABLED(CONFIG_PREEMPT_RT))
 		local_irq_save(*flags);
-	__slab_lock(page);
+	__slab_lock(page_slab(page));
 }
 
 static __always_inline void slab_unlock(struct page *page, unsigned long *flags)
 {
-	__slab_unlock(page);
+	__slab_unlock(page_slab(page));
 	if (IS_ENABLED(CONFIG_PREEMPT_RT))
 		local_irq_restore(*flags);
 }
@@ -530,16 +534,16 @@ static inline bool cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
 		unsigned long flags;
 
 		local_irq_save(flags);
-		__slab_lock(page);
+		__slab_lock(page_slab(page));
 		if (page->freelist == freelist_old &&
 					page->counters == counters_old) {
 			page->freelist = freelist_new;
 			page->counters = counters_new;
-			__slab_unlock(page);
+			__slab_unlock(page_slab(page));
 			local_irq_restore(flags);
 			return true;
 		}
-		__slab_unlock(page);
+		__slab_unlock(page_slab(page));
 		local_irq_restore(flags);
 	}
 
-- 
2.34.1

