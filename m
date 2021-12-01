Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6F12CB3
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:24 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 69EBC1FD61;
	Wed,  1 Dec 2021 18:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382517; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/cffam0/Cfj2BjqtfHUS37XDsk9qpJ6fpIcasEIOlOM=;
	b=vAdJ7CrLNQCAyGakq6MmL4aJyPLU3LWPynC1MPk+hokgMt6mCr/khyUzvEDC0cN1YVhVds
	v9t7NEVPH5dQLlYcSSplsltMPGJzikA321h691UgKlLcI7OIOplqJZTRlYqqB0riocCXiZ
	92+rOfz0X0Gz30TwzgRnNxT8NgdgwZ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382517;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/cffam0/Cfj2BjqtfHUS37XDsk9qpJ6fpIcasEIOlOM=;
	b=VLOpm+QQrtYvMH1+IcpCbmlynCkqJFHTjdHY1YfGwpt4PR85MIX6aOl8RyMDv9eMM/7ku5
	8yvqfzqYL1MrXADw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4140D14050;
	Wed,  1 Dec 2021 18:15:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id APojD7W7p2HPSAAAMHmgww
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
Subject: [PATCH v2 13/33] mm/slub: Convert print_page_info() to print_slab_info()
Date: Wed,  1 Dec 2021 19:14:50 +0100
Message-Id: <20211201181510.18784-14-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1796; i=vbabka@suse.cz; h=from:subject; bh=dM/j4MeUN9tPniCbCQTnqAsDsmqb9dlfi/A8pky4VTU=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7t6KcMe9afXi227VqxahdBawf4y5PTEl1vI3hzA sYL2nPmJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7egAKCRDgIcpz8YmpEBVdCA CogvL1qPclYG/vdsBuwvdblTSaqgaJFEpwg+Pvq3kCCwqqBrG+n3S3aqvXK6wpeXSYE/Cz1QYfiPtl HJvvac/ueWVZN0ByifWamQrpEkuLU/kQvabWu2zMWI4XnY0cVy/rdycgGhpglGovC7gueESc0IdTZh 7sq6xZ6I6qJeqfP8T28vRQuaZurqGZyLDVzIE875aWim2sJ8SBZfnRqAOTxFMzU9YCdp3LupWnI3oH 1qj1i4iKYPpLtROHx2fnpsn0wgQugyyJ5zCBIHoRjDDpb4C3Z2G4ZlmTK+bvnNPE07we6gmG4rlwV0 b4wi7zJ4828Hc0Bfu7ugM7JQJlOfi4
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Improve the type safety and prepare for further conversion. For flags
access, convert to folio internally.

[ vbabka@suse.cz: access flags via folio_flags() ]

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 2cbd2403005f..a4f7dafe0610 100644
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
2.33.1

