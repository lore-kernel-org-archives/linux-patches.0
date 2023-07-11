Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3DF18C29
	for <patches@lists.linux.dev>; Tue, 11 Jul 2023 13:46:42 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4C55622194;
	Tue, 11 Jul 2023 13:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1689083195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tmUBux5e1ki7qsINZJpfH2z48bDyzUotuR1CpySUCaQ=;
	b=acou4bQDVy0hM/ezQGCbnhuyyCV9OLbnLgbSiZoPMwqDjzfAzSHDOEQJjm6aYd3JfDHlVj
	r0Fjy37Mqysf4/J2PoT1S7cvQ9QWZfg748Z2/30rFo/RHgBkBJZci40fZkmnVpjUCqi2ny
	KmklcGac+XrfSY+ck1hbZkSPX3VBgyY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1689083195;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tmUBux5e1ki7qsINZJpfH2z48bDyzUotuR1CpySUCaQ=;
	b=Zi00M2H/+Fsp5apSaRxx6+D9RGOqEN/LSG9K6C5JqftooNT+gO4g1U1LZpCEJeqiKToo7C
	UbXejMpQOCshQ7Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 10FBB13A63;
	Tue, 11 Jul 2023 13:46:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id iPqDAztdrWTSYwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Tue, 11 Jul 2023 13:46:35 +0000
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
	Matteo Rizzo <matteorizzo@google.com>,
	Jann Horn <jannh@google.com>,
	Andrey Konovalov <andreyknvl@google.com>,
	Marco Elver <elver@google.com>,
	Alexander Potapenko <glider@google.com>,
	kasan-dev@googlegroups.com,
	Kees Cook <keescook@chromium.org>,
	linux-hardening@vger.kernel.org,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 2/2] mm/slub: remove freelist_dereference()
Date: Tue, 11 Jul 2023 15:46:25 +0200
Message-ID: <20230711134623.12695-4-vbabka@suse.cz>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230711134623.12695-3-vbabka@suse.cz>
References: <20230711134623.12695-3-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

freelist_dereference() is a one-liner only used from get_freepointer().
Remove it and make get_freepointer() call freelist_ptr_decode()
directly to make the code easier to follow.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 07edad305512..c4556a5dab4b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -397,18 +397,14 @@ static inline void *freelist_ptr_decode(const struct kmem_cache *s,
 	return decoded;
 }
 
-/* Returns the freelist pointer recorded at location ptr_addr. */
-static inline void *freelist_dereference(const struct kmem_cache *s,
-					 void *ptr_addr)
-{
-	return freelist_ptr_decode(s, *(freeptr_t *)(ptr_addr),
-			    (unsigned long)ptr_addr);
-}
-
 static inline void *get_freepointer(struct kmem_cache *s, void *object)
 {
-	object = kasan_reset_tag(object);
-	return freelist_dereference(s, (freeptr_t *)(object + s->offset));
+	unsigned long ptr_addr;
+	freeptr_t p;
+
+	ptr_addr = ((unsigned long)kasan_reset_tag(object)) + s->offset;
+	p = *(freeptr_t *)(ptr_addr);
+	return freelist_ptr_decode(s, p, ptr_addr);
 }
 
 #ifndef CONFIG_SLUB_TINY
-- 
2.41.0

