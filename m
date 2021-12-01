Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49E42CB4
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:24 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 669E4218ED;
	Wed,  1 Dec 2021 18:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382520; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HDHk28IYG3nPE8FSGbkg+IPCxoRF+ZUHe+rhMS6Hszk=;
	b=CgBdqQui2C/i/zrSfqU0YbaqMrFntGRcMw0kgmwkLwSy3hYRIPBkmoOoxbzfN5VpmnIaGV
	JMDd+kb7W2uvfvJPhBKvMh5D/GXwJ8+BAGHpbViw8zo6z8E13M3lZgd7RpDW98IDOOSCif
	regw+Psj2N828l1t8rgV5ioFcvnSKSE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382520;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HDHk28IYG3nPE8FSGbkg+IPCxoRF+ZUHe+rhMS6Hszk=;
	b=IdaaFVfox+7Dl73DGQmqDgPZUTiC4t50MrmHEvdR4KpDhlVDJcuogzlncX7bIoyaOB01i1
	xryhoGaVmuliXVAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 32ADD13D9D;
	Wed,  1 Dec 2021 18:15:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id iJvLC7i7p2HPSAAAMHmgww
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
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2 28/33] bootmem: Use page->index instead of page->freelist
Date: Wed,  1 Dec 2021 19:15:05 +0100
Message-Id: <20211201181510.18784-29-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3092; i=vbabka@suse.cz; h=from:subject; bh=bKqqOHqIBO4fd73/dn9hB1Rvxk7MmLjJHMNETUZo9WA=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7ugVVXW5uJqO2Hu5Z8+5B4FLOBGfRIiRw/AvvtG 19WY/RKJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7oAAKCRDgIcpz8YmpEMFzB/ sEdc93SIwIzlJWLU2+DSoWSd58/CagnhPxz7bM9hzaCuNaRqtLEOyLt1v4jAmkLezpi8Hbi/H3yO7j IHfOprZ8UR9+38EcPUOpJSZkzMYXfb2E8zgEn/+hp9pu2J3uWt1OzGyIH6buI415+oIHalN4Pn7xdN oEzIcaVv/q0/ADv2mAq4uMf688zdNLeadAUx+wpUP614K8ipN0kBR7KDrzWSnwk/QsHtvjS9xfLlv8 y8Bu2F0u5p63NFPIEOIqlYcPZ8tHAqUiONxRGQoca1DR7MHBKKKRZFGFDsWpcuoLFEI6rhnmsG/G2N ulBJYFDJLkaUQZGzkwTmcpUIAkeXun
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

page->freelist is for the use of slab.  Using page->index is the same
set of bits as page->freelist, and by using an integer instead of a
pointer, we can avoid casts.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: <x86@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/mm/init_64.c        | 2 +-
 include/linux/bootmem_info.h | 2 +-
 mm/bootmem_info.c            | 7 +++----
 mm/sparse.c                  | 2 +-
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 36098226a957..96d34ebb20a9 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -981,7 +981,7 @@ static void __meminit free_pagetable(struct page *page, int order)
 	if (PageReserved(page)) {
 		__ClearPageReserved(page);
 
-		magic = (unsigned long)page->freelist;
+		magic = page->index;
 		if (magic == SECTION_INFO || magic == MIX_SECTION_INFO) {
 			while (nr_pages--)
 				put_page_bootmem(page++);
diff --git a/include/linux/bootmem_info.h b/include/linux/bootmem_info.h
index 2bc8b1f69c93..cc35d010fa94 100644
--- a/include/linux/bootmem_info.h
+++ b/include/linux/bootmem_info.h
@@ -30,7 +30,7 @@ void put_page_bootmem(struct page *page);
  */
 static inline void free_bootmem_page(struct page *page)
 {
-	unsigned long magic = (unsigned long)page->freelist;
+	unsigned long magic = page->index;
 
 	/*
 	 * The reserve_bootmem_region sets the reserved flag on bootmem
diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
index f03f42f426f6..f18a631e7479 100644
--- a/mm/bootmem_info.c
+++ b/mm/bootmem_info.c
@@ -15,7 +15,7 @@
 
 void get_page_bootmem(unsigned long info, struct page *page, unsigned long type)
 {
-	page->freelist = (void *)type;
+	page->index = type;
 	SetPagePrivate(page);
 	set_page_private(page, info);
 	page_ref_inc(page);
@@ -23,14 +23,13 @@ void get_page_bootmem(unsigned long info, struct page *page, unsigned long type)
 
 void put_page_bootmem(struct page *page)
 {
-	unsigned long type;
+	unsigned long type = page->index;
 
-	type = (unsigned long) page->freelist;
 	BUG_ON(type < MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE ||
 	       type > MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE);
 
 	if (page_ref_dec_return(page) == 1) {
-		page->freelist = NULL;
+		page->index = 0;
 		ClearPagePrivate(page);
 		set_page_private(page, 0);
 		INIT_LIST_HEAD(&page->lru);
diff --git a/mm/sparse.c b/mm/sparse.c
index e5c84b0cf0c9..d21c6e5910d0 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -722,7 +722,7 @@ static void free_map_bootmem(struct page *memmap)
 		>> PAGE_SHIFT;
 
 	for (i = 0; i < nr_pages; i++, page++) {
-		magic = (unsigned long) page->freelist;
+		magic = page->index;
 
 		BUG_ON(magic == NODE_INFO);
 
-- 
2.33.1

