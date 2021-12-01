Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3AE2C9D
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:20 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3D9BF218B0;
	Wed,  1 Dec 2021 18:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382517; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sf8S0KINYvRzgGzjjnh3SThdSh212t4v961NUPPA8y0=;
	b=XZOQT+ZqVpxTbL5vFPFgH4FhhSHMUXEK6bUEgRVzCgHYuw862ErySFWcyywM+/TM01xkgR
	sO/EGqJAQ7KkToJrUi8xzqFjHwwLqCxIBe3NbCZgQnnJI+hdf3Mar1hWzIdC7oSkI30Z6G
	d9xAKBwOkIANQg9QnqEd7UhPhW1k5rA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382517;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sf8S0KINYvRzgGzjjnh3SThdSh212t4v961NUPPA8y0=;
	b=iMnVG2R7uNlMscu/I3lftMWhWM9ftcWxhhGZuV7h87xYKDIvPtUOsTHCoFlkB3geA2epHQ
	ycpPey+ybhr4QvAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1AF7713D9D;
	Wed,  1 Dec 2021 18:15:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id aAv6BbW7p2HPSAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 01 Dec 2021 18:15:17 +0000
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
Subject: [PATCH v2 12/33] mm/slub: Convert __slab_lock() and __slab_unlock() to struct slab
Date: Wed,  1 Dec 2021 19:14:49 +0100
Message-Id: <20211201181510.18784-13-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2107; h=from:subject; bh=Ms68WebZMas1qlieVdKtgoF7lKxfZIAM3TnSfQQ6bBE=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7t4c1fmWg96L3j4eoQMZtVIXK6zKj/dCOXn5UVe ba9HM9mJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7eAAKCRDgIcpz8YmpEGUyCA CvRhfLS72ellKRjmpFkYfCuFiIuYmrXDfkN3UNsyyuQozP6kbmaW3t9J1i4WJJtbvK/1Co2D4CjkMO o94cVAL71S/0vddGBaosldEZSczqXalc+R06dZxD5NTLfvvvp3Txm3AIV4DulcEfoHri5dcxw8msHQ AqsLsLj0H+ip6iYypaNPQ1Z9VOf5qpS6iPaEcSuMD6aHOm3w3Jly6TkwgU+tj2FySke5yhHcYbYRCR KYDCIQs/c/PH+I9Sx44uUWyjCKbCp/AHes3vGgkXVDfTrnq7HAD2RlhiI2JShTdk09+gEUgx51VmrZ SOay3GW6gwBkahnFhdTW7HVmfFLrnl
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

These functions operate on the PG_locked page flag, but make them accept
struct slab to encapsulate this implementation detail.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 2d9c1b3c9f37..2cbd2403005f 100644
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
2.33.1

