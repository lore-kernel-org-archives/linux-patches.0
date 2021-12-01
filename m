Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C902CA4
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:17 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3DDDD21763;
	Wed,  1 Dec 2021 18:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382516; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2huBtd78dgIMu/REbqCFf2aOU3Hf2qAQZoDVbiYptxA=;
	b=VFZi564XHkimtWnAETlR3UDS7AzMp+gVToDvguCEyPUeO4liBMiuJ5rTck6mQM5uGTpXrX
	sDArKwTuA3/T+xnZ0JCYL4pPRqRvRfCNkY5Zo8euLi55JDhXCU9GQ5yG7AEtAcl1Ub7Wji
	7A6OxRGj+g3nzL79N4maRvYiApVMIDU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382516;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2huBtd78dgIMu/REbqCFf2aOU3Hf2qAQZoDVbiYptxA=;
	b=T62aNIrOXBKrK18MCmWJs1YxwuNfo3MtTr+nSHMSYl2qB1U1OGLNUm9GNOOnJE9sj7do17
	1u74fv2ORdsBwXBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1B13A13D9D;
	Wed,  1 Dec 2021 18:15:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id IOcBBrS7p2HPSAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 01 Dec 2021 18:15:16 +0000
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
Subject: [PATCH v2 06/33] mm: Convert virt_to_cache() to use struct slab
Date: Wed,  1 Dec 2021 19:14:43 +0100
Message-Id: <20211201181510.18784-7-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=971; i=vbabka@suse.cz; h=from:subject; bh=VZU2uieaWuqFt5d/ZKEkgSWeVL6DLIe/z3yNXrPL7fY=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7tqDNUCA3VM++k6m7bOU+APqk4pvifXwyvNdi36 ZpvYBe+JATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7agAKCRDgIcpz8YmpEJsJB/ 9sgRBNhe7UIwRNrB5VVGUXHQO1lndiItwKB8GXZBsHvrvX/B5EpGYMPDhigPVsoUHpDK1JqJg/c7QY ULwCunSwYUDP2AmoNIeYaypBIA+/Ie5gFSQDYAR+yMR5NhZ+jZp6WjkVsv8G/dI7y6Sq7WGcf1fQPb aUqQGmf4rQa0guan64GhApnHafFQAUa0Bt6eu7B5ri9/4biN1r0tuZ62j1Ay3lVirMFCR6qz4WTLah bPYPPq1BsSU35zHEmwKyqQYhuZn17JN2OYrM2rdJg73zCbwjcUxi93d4luPK810imWqv6EdEog6SSt Ow/EsIe/y+0jx8Tp3Y/DB9n+KPT6cJ
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

This function is entirely self-contained, so can be converted from
page to slab.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index dd3f72fddff6..1408ada9ff72 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -574,13 +574,13 @@ static inline void memcg_slab_free_hook(struct kmem_cache *s,
 
 static inline struct kmem_cache *virt_to_cache(const void *obj)
 {
-	struct page *page;
+	struct slab *slab;
 
-	page = virt_to_head_page(obj);
-	if (WARN_ONCE(!PageSlab(page), "%s: Object is not a Slab page!\n",
+	slab = virt_to_slab(obj);
+	if (WARN_ONCE(!slab, "%s: Object is not a Slab page!\n",
 					__func__))
 		return NULL;
-	return page->slab_cache;
+	return slab->slab_cache;
 }
 
 static __always_inline void account_slab(struct slab *slab, int order,
-- 
2.33.1

