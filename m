Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040622C9C
	for <patches@lists.linux.dev>; Tue,  4 Jan 2022 00:10:54 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DF6BA1F397;
	Tue,  4 Jan 2022 00:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641255052; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UjwmNSDmEW/gEl8L53ZD20VA7yF94pX2Jnzs0mb2D5I=;
	b=aE0t1mz6zjZcQ9aU3B0XZTitsvDTNqku/wdZxP72gEtCUEPfBpSGeQlNtsu8BL8d6OGjX0
	018nlxOlsD8k5w2NF/YQ9Os4pDWb22L/jcc0tX9LHkCjh2zJpO14fxaJXd8PbJIEoNgo9G
	GSjVVw0kScdp+TPUqVpazPOIbBqLGBU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641255052;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UjwmNSDmEW/gEl8L53ZD20VA7yF94pX2Jnzs0mb2D5I=;
	b=eV5YfGhRR5xLNVEJFquyIWL71w2IjQebAosdMvLP1mHkmycnJMEciLgt856bBS3Rgh68FG
	YA2Mu/Ot/kTmWRCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B3382139EE;
	Tue,  4 Jan 2022 00:10:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id aCkRK4yQ02FEQwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Tue, 04 Jan 2022 00:10:52 +0000
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
Subject: [PATCH v4 01/32] mm: add virt_to_folio() and folio_address()
Date: Tue,  4 Jan 2022 01:10:15 +0100
Message-Id: <20220104001046.12263-2-vbabka@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104001046.12263-1-vbabka@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1229; h=from:subject; bh=TrQq/wP139J7sjIGWcZYuZJSMcfBZseWcvSXmOy2LHI=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBh05Bq/7Z6leC5nyGSJzVgoUkJLZj/WiEILgQXR8dL ZStXeZ6JATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYdOQagAKCRDgIcpz8YmpEIxPCA CskayEaZnnTzNOOB6k6ZsoeUX7GOnGyCjE2GjnJyXO4HEt7dsA5vGxqgvThpC5jqnwb+lhQYZ0JnmA 5uC/GTswm+7+it4DHF9cQkH5LCfdbj6z8nCLEFZTNOPF4J7DcdaEZ06Piqg63N4/Ltv6G1hvJnmyT0 N/GP7q4GaqriUxTGLHLJ2ivu9m2X23GE+Da5GDYsHRz1DqChODl4heNcyzkpmaDFPCkIVclL0UVYrA LMYZcA+M/3DtxsPV/1eSFiafCSSpsZBbHFEmGjHtR7hUbsh9XW7MQ3P1pzK3yBPCznm499MLQWeBNg UidQjQqcpDAfmATc8TiG1IvEAGXlgI
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

These two wrappers around their respective struct page variants will be
useful in the following patches.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Roman Gushchin <guro@fb.com>
---
 include/linux/mm.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a7e4a9e7d807..4a6cf22483da 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -863,6 +863,13 @@ static inline struct page *virt_to_head_page(const void *x)
 	return compound_head(page);
 }
 
+static inline struct folio *virt_to_folio(const void *x)
+{
+	struct page *page = virt_to_page(x);
+
+	return page_folio(page);
+}
+
 void __put_page(struct page *page);
 
 void put_pages_list(struct list_head *pages);
@@ -1753,6 +1760,11 @@ void page_address_init(void);
 #define page_address_init()  do { } while(0)
 #endif
 
+static inline void *folio_address(const struct folio *folio)
+{
+	return page_address(&folio->page);
+}
+
 extern void *page_rmapping(struct page *page);
 extern struct anon_vma *page_anon_vma(struct page *page);
 extern pgoff_t __page_file_index(struct page *page);
-- 
2.34.1

