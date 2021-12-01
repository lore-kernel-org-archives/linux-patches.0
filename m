Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A062CA4
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:24 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2EC4B218E1;
	Wed,  1 Dec 2021 18:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382520; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k9ZixtfM35tzxNogC9Q/Zjb3jw/3HxLVaAR2HEzD94w=;
	b=pHJqcViLFus8H+B3R7sMcv77cqlWRn7nMcYPxJqcCsyckfABolUU1WRrwKPmh477x1exxY
	mB76xzl4qQDgtxHX9eHOKKLebzDdfHdKTckgpewWrjumHLrHJi+XmYaUCXq76k4JzDqOIf
	PJ9BOERnAOFI/ns5Cb3r0u6R0X1KjWY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382520;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k9ZixtfM35tzxNogC9Q/Zjb3jw/3HxLVaAR2HEzD94w=;
	b=Y0qngyg7344Njp7pDNolPu2UCxwHX43d5Gdhf1NOa0UWH1dsjRFONG6/FGRjV39T9wfnuQ
	VahLwZDyC7g/U5Dw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 09AF514050;
	Wed,  1 Dec 2021 18:15:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 4ADSAbi7p2HPSAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 01 Dec 2021 18:15:20 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: Matthew Wilcox <willy@infradead.org>,
	Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>
Cc: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 27/33] zsmalloc: Stop using slab fields in struct page
Date: Wed,  1 Dec 2021 19:15:04 +0100
Message-Id: <20211201181510.18784-28-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3314; i=vbabka@suse.cz; h=from:subject; bh=8SuDkeW+Y9PZVFez1G0gmyr5ZITWgrIDjjaoMCRZfSM=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7udZNIGX2PL0DK79GP20slO6qqTJzMyvKUPAkqA Yu0ypNaJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7nQAKCRDgIcpz8YmpEOl8B/ 0anHTWLi8ZxwIoiv+zcRRwEvyq62a6UOIDOMCeP7SLIIt5OB3dmi9SnRwYPvm+11a/1maE3PGGxKsX W3tqpUN9Fj9n2bbuJPpPmF1yUT8lxeE1Yfs4RBnolORJmAjYUF5MhGFdgOOsmCep/l0NHY5qsaU6OJ jYkSioyR3nGbzYv+5RL5jRz6RBER9V91uTo8INbQoqA7SfLw90DlDMS3pqOI3GOGYAlwHgvknFEeP1 8wiG6gJ/gQD5Q/Es0CPhfgbiu0vhUtDlpxc8OGzkGMoo6t1IlnCM3PPVSvRBogQJNGYLQisY9+L1Y0 nhydCso5J1wCFBikf5DG7PjOeoWaoS
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

The ->freelist and ->units members of struct page are for the use of slab
only.  I'm not particularly familiar with zsmalloc, so generate the same
code by using page->index to store 'page' (page->index and page->freelist
are at the same offset in struct page).  This should be cleaned up
properly at some point by somebody who is familiar with zsmalloc.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 mm/zsmalloc.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index b897ce3b399a..0d3b65939016 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -17,10 +17,10 @@
  *
  * Usage of struct page fields:
  *	page->private: points to zspage
- *	page->freelist(index): links together all component pages of a zspage
+ *	page->index: links together all component pages of a zspage
  *		For the huge page, this is always 0, so we use this field
  *		to store handle.
- *	page->units: first object offset in a subpage of zspage
+ *	page->page_type: first object offset in a subpage of zspage
  *
  * Usage of struct page flags:
  *	PG_private: identifies the first component page
@@ -489,12 +489,12 @@ static inline struct page *get_first_page(struct zspage *zspage)
 
 static inline int get_first_obj_offset(struct page *page)
 {
-	return page->units;
+	return page->page_type;
 }
 
 static inline void set_first_obj_offset(struct page *page, int offset)
 {
-	page->units = offset;
+	page->page_type = offset;
 }
 
 static inline unsigned int get_freeobj(struct zspage *zspage)
@@ -827,7 +827,7 @@ static struct page *get_next_page(struct page *page)
 	if (unlikely(PageHugeObject(page)))
 		return NULL;
 
-	return page->freelist;
+	return (struct page *)page->index;
 }
 
 /**
@@ -901,7 +901,7 @@ static void reset_page(struct page *page)
 	set_page_private(page, 0);
 	page_mapcount_reset(page);
 	ClearPageHugeObject(page);
-	page->freelist = NULL;
+	page->index = 0;
 }
 
 static int trylock_zspage(struct zspage *zspage)
@@ -1027,7 +1027,7 @@ static void create_page_chain(struct size_class *class, struct zspage *zspage,
 
 	/*
 	 * Allocate individual pages and link them together as:
-	 * 1. all pages are linked together using page->freelist
+	 * 1. all pages are linked together using page->index
 	 * 2. each sub-page point to zspage using page->private
 	 *
 	 * we set PG_private to identify the first page (i.e. no other sub-page
@@ -1036,7 +1036,7 @@ static void create_page_chain(struct size_class *class, struct zspage *zspage,
 	for (i = 0; i < nr_pages; i++) {
 		page = pages[i];
 		set_page_private(page, (unsigned long)zspage);
-		page->freelist = NULL;
+		page->index = 0;
 		if (i == 0) {
 			zspage->first_page = page;
 			SetPagePrivate(page);
@@ -1044,7 +1044,7 @@ static void create_page_chain(struct size_class *class, struct zspage *zspage,
 					class->pages_per_zspage == 1))
 				SetPageHugeObject(page);
 		} else {
-			prev_page->freelist = page;
+			prev_page->index = (unsigned long)page;
 		}
 		prev_page = page;
 	}
-- 
2.33.1

