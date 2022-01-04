Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8B22CB0
	for <patches@lists.linux.dev>; Tue,  4 Jan 2022 00:11:02 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AA1A31F3AC;
	Tue,  4 Jan 2022 00:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641255059; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DkAORBxl9OJ9ns4Jx6bvFCvDYPe0MqXzhPtu2uyCh7A=;
	b=cSCKkzaUjpNr9zYDIGAYARClzHGJFV071Y37TCsov0yVolx6ZK2VKC7zf6/RbA+XWRHKXF
	3aOww0uSXcBOl7Rv7dxA1f1qLEkAmRmKYz4l2j/QPoMaQZ9HNQtFL+V7nIE7OiaYjufMiU
	Yhe53nK6KS61pCbDvMKvVieS2XD52xk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641255059;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DkAORBxl9OJ9ns4Jx6bvFCvDYPe0MqXzhPtu2uyCh7A=;
	b=4KzqPRt6f1kAb0ZHlrvSiUJGfTuKSzsdcRA2HtzNbRbNlr3LVEfU4qT5HdQt1RM8siVol5
	c1YVSRGlE2JVkyAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7E1DB139D1;
	Tue,  4 Jan 2022 00:10:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id uIkxHpOQ02FEQwAAMHmgww
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
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v4 32/32] mm/slob: Remove unnecessary page_mapcount_reset() function call
Date: Tue,  4 Jan 2022 01:10:46 +0100
Message-Id: <20220104001046.12263-33-vbabka@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104001046.12263-1-vbabka@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1381; i=vbabka@suse.cz; h=from:subject; bh=4bmBjc2hup+DgMeh+mJcnbpGgKsqmASbibT+dn5k/oA=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBh05CFUUv6pwAbJaEzjeLNGm2z0bkmYU7PYKGqRT1C O3dg8LWJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYdOQhQAKCRDgIcpz8YmpEA9kB/ 4qpX8FNV38n805S8kXvh22PGhlAyaYbOzkTkQbRSUES9wz6mLtqSfr4eBcmlcJVVBzeZJZYf2VZ2ug QNOTnYaHvHgT+oUJ2jKFGbG7kWSqRKbR4aAgjhuLEUp1so8WydlP2nWhTQoG0NRDBjhyZE+eCiaBFH slpWg4b49DzR5jxlTeK7CDUhpHFcfqgOl3Ub4KbUlUKYtvy17q6gJcF4QSoHLzAtsXWmazbkUIs8WM fAtejXXvs6Qq/QKe5vqfmKjUw4lulcu4fCMj1ikU0aa1XiQz1HZLoUZnUFTzNWWVwxZVVMMhLDHV+c QWoEnSm6LvyczSTp++MVW3rIka5gWv
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: Hyeonggon Yoo <42.hyeyoo@gmail.com>

After commit f2452d14cdb3 ("mm/sl*b: Differentiate struct slab fields by
sl*b implementations"), we can reorder fields of struct slab depending
on slab allocator.

For now, page_mapcount_reset() is called because page->_mapcount and
slab->units have same offset. But this is not necessary for struct slab.
Use unused field for units instead.

Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Link: https://lore.kernel.org/r/20211212065241.GA886691@odroid
---
 mm/slab.h | 4 ++--
 mm/slob.c | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index ac8be7dab535..e10d0d4c9bfa 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -50,8 +50,8 @@ struct slab {
 	struct list_head slab_list;
 	void *__unused_1;
 	void *freelist;		/* first free block */
-	void *__unused_2;
-	int units;
+	long units;
+	unsigned int __unused_2;
 
 #else
 #error "Unexpected slab allocator configured"
diff --git a/mm/slob.c b/mm/slob.c
index 3c6cadbbc238..60c5842215f1 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -404,7 +404,6 @@ static void slob_free(void *block, int size)
 			clear_slob_page_free(sp);
 		spin_unlock_irqrestore(&slob_lock, flags);
 		__folio_clear_slab(slab_folio(sp));
-		page_mapcount_reset(slab_page(sp));
 		slob_free_pages(b, 0);
 		return;
 	}
-- 
2.34.1

