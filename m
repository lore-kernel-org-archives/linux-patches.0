Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A292CA6
	for <patches@lists.linux.dev>; Tue,  4 Jan 2022 00:11:01 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7C8631F3A1;
	Tue,  4 Jan 2022 00:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641255059; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UizTnTN+7G/BHS2wZsmWzy7dIrTBPYl0VkFCBetvouA=;
	b=sR6r3SvVeZl3XvqCqfCABqQpMot7IWmgvE7XZaUHhos9ky1joBHuxVr/WDQRkRFbl+Kden
	vZGX5y6WqvljO+TXYKSiAFHYsUTz78U9boQpaNxR6fqbqxJ41KaPb6dToVljQa1VvNO5tT
	jr8caaijCJuJS0Tciv/Bwxvsz4tNI7s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641255059;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UizTnTN+7G/BHS2wZsmWzy7dIrTBPYl0VkFCBetvouA=;
	b=Gk79NO/JFq96kZfYCrqBYe7d02S8clSIKWTpR/whug5VRYx39oNoijKqb0O6EvrJ1ol8TH
	IsdfV8njg2hfkHAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 09352139EE;
	Tue,  4 Jan 2022 00:10:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id UF2IAZOQ02FEQwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Tue, 04 Jan 2022 00:10:59 +0000
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
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v4 31/32] bootmem: Use page->index instead of page->freelist
Date: Tue,  4 Jan 2022 01:10:45 +0100
Message-Id: <20220104001046.12263-32-vbabka@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104001046.12263-1-vbabka@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3140; i=vbabka@suse.cz; h=from:subject; bh=6GzVzvaGvCknexRKBXymCykgz3NpcRW3H7Lj58WadRM=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBh05CEl0cNGQUsQF+2vGU0lmv5VYN6QHBkBJBOfV+u fIcbGEiJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYdOQhAAKCRDgIcpz8YmpEMHaCA COtc0gFdEkzOgl9/aaScAgO4YcQ7ZH574wkgn24AHmRwe/eMaC82JkRnb8YNK21AMTEeZFaChusgEa 7D24istrSigzNzsyKfE3+vgVqixKdRQNZ1+p4Beo+KAUfVW/b4+Rs93Pdp7vrjeqRGUsIwJ9voPWQj knEVJ02D+spo81X+RxILyqNf4D4MHLbrX2CLrkINQR4L46t1AziHJVFkkBO3dRoCGaYKQ2Ks+bAQog JbAXinx8Xc1P+E/kZVHpAo1tEY6M5mbOkKROGCTLmjS1ggsWJBZ5Ojtq9LyX7TpbUhbiva43LnemLX IlpZL5gUeaxNjdcE3yf+1VUvKmx3Gp
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

page->freelist is for the use of slab.  Using page->index is the same
set of bits as page->freelist, and by using an integer instead of a
pointer, we can avoid casts.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
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
2.34.1

