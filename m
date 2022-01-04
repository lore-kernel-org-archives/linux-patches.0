Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8502CA7
	for <patches@lists.linux.dev>; Tue,  4 Jan 2022 00:10:59 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 432071F38A;
	Tue,  4 Jan 2022 00:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641255055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nvmMQ1q2aFkmfTW9FqWbRrJooh6NtoO1HccX3fu8na8=;
	b=wTxp5GbJuWbkJ4kAa4ElEVxjHiVhqJkoCs4UwtzbzN1nj0C2FoKuETWSZqeDqavUvOTn/f
	OMeyyvg9e2at9ZV0vXJRSZ8v9UmTSP8umrCGu5rtLnnHklZp9vCui/9e4pHb45jFK9O49p
	O4aQBISlzGjWmo9fdFYy3GM14u7rRx0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641255055;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nvmMQ1q2aFkmfTW9FqWbRrJooh6NtoO1HccX3fu8na8=;
	b=eD2pOYMpx9WAQ44Y48k8jBsEgB8DbLqifAJMmvkVU060lH8eaC566QotGNplIiyYF6tBo/
	UH1gOA2/n2jVhKBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 18AF6139EE;
	Tue,  4 Jan 2022 00:10:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id eLt7BY+Q02FEQwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Tue, 04 Jan 2022 00:10:55 +0000
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
Subject: [PATCH v4 13/32] mm/slub: Convert print_page_info() to print_slab_info()
Date: Tue,  4 Jan 2022 01:10:27 +0100
Message-Id: <20220104001046.12263-14-vbabka@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104001046.12263-1-vbabka@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1889; i=vbabka@suse.cz; h=from:subject; bh=llHlCPj3A5AUCrwVfP4gr1PrGwvRUR4lalPZiA8JC1g=; b=owGbwMvMwMH4QPFU8cfOlQKMp9WSGBIvTyhR2HXEx/SNfX7bw5uvTy4zfCheEVbQ9INHR+pqaEji HKnZnYzGLAyMHAyyYoosvd6TGVeaPpbY5xF3BmYQKxPIFAYuTgGYiIMsB8NKzsMVlm3/lm5JfSnR5S qRzHJ6ra5njnanVNKPeb87du3d/XRuG09AwZveRazRYnWXHZ88u97wM0bAbu6kuW1yn9k3PA9rMfmo FtNnf/7IHtPkkg2dFrYZB7lUbindKlG4m6zR0cerqxIkXPRTwV1w+wLzvOdb/ibfixT2VdQ2dcj9fe Pp49vmNtvM6/77pMyvvT9ZLcn0iAiXo/x/P5V5/m55V45mdrKt6C/5nHjYwFPAgqt/yaWykBSFvMtF 4WYnlApy7jyatU+Tf5VpHlvZx8cG7T/ljrXHaFY6Fy1a/XXlpNuzTFvanLmrJX/Gntty+0OxpGqq4t O09kMMi30tBFrvPGQxqvedaZIKAA==
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Improve the type safety and prepare for further conversion. For flags
access, convert to folio internally.

[ vbabka@suse.cz: access flags via folio_flags() ]

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
---
 mm/slub.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 14550e7bee71..d3e9e322b4e2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -788,12 +788,13 @@ void print_tracking(struct kmem_cache *s, void *object)
 	print_track("Freed", get_track(s, object, TRACK_FREE), pr_time);
 }
 
-static void print_page_info(struct page *page)
+static void print_slab_info(const struct slab *slab)
 {
-	pr_err("Slab 0x%p objects=%u used=%u fp=0x%p flags=%pGp\n",
-	       page, page->objects, page->inuse, page->freelist,
-	       &page->flags);
+	struct folio *folio = (struct folio *)slab_folio(slab);
 
+	pr_err("Slab 0x%p objects=%u used=%u fp=0x%p flags=%pGp\n",
+	       slab, slab->objects, slab->inuse, slab->freelist,
+	       folio_flags(folio, 0));
 }
 
 static void slab_bug(struct kmem_cache *s, char *fmt, ...)
@@ -833,7 +834,7 @@ static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
 
 	print_tracking(s, p);
 
-	print_page_info(page);
+	print_slab_info(page_slab(page));
 
 	pr_err("Object 0x%p @offset=%tu fp=0x%p\n\n",
 	       p, p - addr, get_freepointer(s, p));
@@ -903,7 +904,7 @@ static __printf(3, 4) void slab_err(struct kmem_cache *s, struct page *page,
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
 	slab_bug(s, "%s", buf);
-	print_page_info(page);
+	print_slab_info(page_slab(page));
 	dump_stack();
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
-- 
2.34.1

