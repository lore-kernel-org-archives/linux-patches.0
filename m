Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7332CA7
	for <patches@lists.linux.dev>; Tue,  4 Jan 2022 00:10:55 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DD6E91F3A1;
	Tue,  4 Jan 2022 00:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641255053; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9ucz68YrQoEIC7O03FAue2Lqf/roYcRbwpB07eOP9jg=;
	b=aeujSNcQ7ViUEnX/iZTMGxJTCZduUNX7LzgHaRzLGXT3dOS79DwASA8QVTYU5fU9Xw1yrH
	RH0p9t13+TejXton7C8gCFlin+ZBiy+b114AoUnwY9q5GP0kUbodCJVxcrTjgY+vXCyibF
	7YPft6ZjJBDZsg7ypaVMCW1mVfWVX+U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641255053;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9ucz68YrQoEIC7O03FAue2Lqf/roYcRbwpB07eOP9jg=;
	b=Z6OuG6CwTtaU0Iw1IYzf3bvhwO/346Df6BaL5acMnoLsoGD2LlwvpPZLyM5/+DR8dFp6iS
	kO4PM3Q7Po5D1yDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B3D0F139D1;
	Tue,  4 Jan 2022 00:10:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id AJ1GK42Q02FEQwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Tue, 04 Jan 2022 00:10:53 +0000
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
Subject: [PATCH v4 06/32] mm: Convert virt_to_cache() to use struct slab
Date: Tue,  4 Jan 2022 01:10:20 +0100
Message-Id: <20220104001046.12263-7-vbabka@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104001046.12263-1-vbabka@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1062; i=vbabka@suse.cz; h=from:subject; bh=Aia3RauLIqzXzz1QEEPYY04L5FJzmPzuA7MgAEz50Uc=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBh05Bu5dafiS5suXbovkwseUCib88Mf1s66+m6CjnW tzu+eimJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYdOQbgAKCRDgIcpz8YmpEMmKB/ sFRXmQ3RtLfhUNRrgp7aWtvV41A/YYVpBdLCCzl5WphPnmJy9TaA/wkxizK3imKvl5O2WCLfXfmePa iQWrIf2Bviq9a4AXwxDKmaeHF8nwzhq6IkSVN2kppKK4IyYx9TMPDeZoOnU0l/lBTZ0h6fFE/MDH5T A1IZ9HXBhiVaSmaTJ+3GCGzyVv5bDOlcaYLsqW1oTbVFCFZokfx1xZP14XP9PhNwamGduC5L4y2X3r LrHUHEyCtsS3vYlTzikuTxkDh+NXqTmC8jwXuQbEYdxUfoObRV1m8PCG+In6N8IMhSD1aU1s4rgZjM 906fMuhbCof8ycLwoCLNnCXrsWl5wg
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

This function is entirely self-contained, so can be converted from page
to slab.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Roman Gushchin <guro@fb.com>
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
2.34.1

