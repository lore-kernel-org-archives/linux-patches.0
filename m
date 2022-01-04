Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B90D2CA4
	for <patches@lists.linux.dev>; Tue,  4 Jan 2022 00:11:00 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 045E1212C0;
	Tue,  4 Jan 2022 00:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641255059; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0jEQi7Qw4iSUjxlNhie6l8ndlAqKAXE/bAoY0dFe9KM=;
	b=gEVwq+myZHF/ujZxLD2aABy5RENqDpWpyVDQ4BrI4IlSR5dxMNiNYXKnKooMkK3nNyIfXT
	a2OcMqNNUA3Av73Y4mn5LLxTrjS/jVrty0Hl2mjwDw1VNrYm6YW8k5Oy3aRzk9avGyExmO
	lXPIQRB4kiI7mTHW2Liv0iOtxjq2fdE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641255059;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0jEQi7Qw4iSUjxlNhie6l8ndlAqKAXE/bAoY0dFe9KM=;
	b=yDlSxYEw7NhitIanxzw/RjP0J0jt/fnkGM4gerBFoAaO+dFBmaSng56JrOSbkzvFCJAr7U
	BkCPfzho06XpgRCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C4F66139D1;
	Tue,  4 Jan 2022 00:10:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id gO9+L5KQ02FEQwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Tue, 04 Jan 2022 00:10:58 +0000
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
	Vlastimil Babka <vbabka@suse.cz>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v4 30/32] zsmalloc: Stop using slab fields in struct page
Date: Tue,  4 Jan 2022 01:10:44 +0100
Message-Id: <20220104001046.12263-31-vbabka@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104001046.12263-1-vbabka@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3369; i=vbabka@suse.cz; h=from:subject; bh=bl38F2X+BMj5bz7f2fPTl/KJ7hJeqBpd3OUw7Rfr7B8=; b=owGbwMvMwMH4QPFU8cfOlQKMp9WSGBIvT2i+UKPioZygM+9y67qrdeLtEYoahyZeZXIRr2N2Xzan pbW4k9GYhYGRg0FWTJGl13sy40rTxxL7POLOwAxiZQKZwsDFKQAT0X7P/j/8tY2qO8/fSoYg8bh7FV v2/DrctCHsUu/9uKe/ylbMStZsnJxswpWrGLTRK5b90aen+WLOd9VYnVzmSpUILSyVumcqNveUtdGy b1/MHvfzN7b+mV209fwshujqSn9T5/eKCRUOjPppb9YlRFsd+r2H0bL3dt8fRp8+JktR4cjwU+f/3N QKzRN7cIHpukBHYqvnjDk8oWUGKQXL6pl3aMyYeb48/v05gfSu0+4TX/xyLzTfO/NUmpuMxcM+A+58 kePqRlNtOjXniRaobDSJ35bK53fYL+zl7p2betcW2Sf07rcT2fT/zpwPNhXbV71dxeLfeTyb7dLWl0 UcIpFnmT9yZ9bueOP1xSzz73UHAA==
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

The ->freelist and ->units members of struct page are for the use of
slab only.  I'm not particularly familiar with zsmalloc, so generate the
same code by using page->index to store 'page' (page->index and
page->freelist are at the same offset in struct page).  This should be
cleaned up properly at some point by somebody who is familiar with
zsmalloc.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
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
2.34.1

