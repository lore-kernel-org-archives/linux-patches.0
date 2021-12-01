Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E592CAE
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:22 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 64FB41FD5A;
	Wed,  1 Dec 2021 18:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382515; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/w5chhh8YYLvgltHSMyWQiSTAqtdsVsIZrIGmVlHmJ4=;
	b=2Z/iFC7lcZ5H+jnlUo2V94gheiV7g8JITLW+70TKM/Zelhuo6Nno96T85NNpfN945WxEW2
	utfhOV6Cn4Yw5bVvsvN48TcA0DKafXODGgozY+4m/7bFihGMbp7FRszEiCJBp/dvjiNLrr
	rvZxRIVwiLJFdOw4t3BecvRqU7Aa+BI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382515;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/w5chhh8YYLvgltHSMyWQiSTAqtdsVsIZrIGmVlHmJ4=;
	b=tycgaUmvkVUfLq8TBhn9TP+h65Uft6BAm3kHlfDNGGbxNIOYjjG5SkF6a3A405RCJs9d+G
	3puyrarRxqQjDpAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 40CB814050;
	Wed,  1 Dec 2021 18:15:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id YE3VDrO7p2HPSAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 01 Dec 2021 18:15:15 +0000
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
Subject: [PATCH v2 01/33] mm: add virt_to_folio() and folio_address()
Date: Wed,  1 Dec 2021 19:14:38 +0100
Message-Id: <20211201181510.18784-2-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1138; h=from:subject; bh=mhmYSV3mUW4peqzSqETX0O7Aw92jq0WStnXU/D0a9tI=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7tfayXTSar6TgpzBItBpEDWivg05JS4pV3TzbFh uYpJcBOJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7XwAKCRDgIcpz8YmpEKUdB/ 9U5iwTNrdCu9sy2Kc+wGl1Z5y+h9qUVEPwXCAXKelFoIQ4ryIvjoRkZp/brsFwhN4370dV64csin9o rQQFg1b+9+YgyYPCiqrkcA5eJiq0ikjyJblgnA6JlYM57HDuj+sL/uPrWGSNPvBNog1CkyrJ87B/sW 3nYwzH8m1BZYNbUBkZix+USYtYqDq0x9fcSMwhanbyc/m/5GWucXpf1kJGuhe9RtN2YxJHfXDRwxm3 Flp6TGa4LfyAar1dbKiJsKM7XQZo5goSfpu8ayXsmIe/XfxvjZ33deiMCm2ro6x347AGDjR6d21GH3 WhqPvj+fyx3ZHw0BIwL3rdtmwlWD9u
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

These two wrappers around their respective struct page variants will be useful
in the following patches.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
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
2.33.1

