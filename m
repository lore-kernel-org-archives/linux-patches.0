Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAE21E1DA
	for <patches@lists.linux.dev>; Thu, 10 Aug 2023 16:36:40 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 302EE2187B;
	Thu, 10 Aug 2023 16:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1691685393; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=19h9QNSgdzIWywJanN9veEOMa6s1Xj+q+Cz0v3FP+f4=;
	b=vzqZq8M1QVHjJzcAciJEyysHegc4ljBQedRS1OxPDkK3CHjdyrBTf+D6vESZxsfkhbcdVL
	MIoyrdIPrePiMNwI+qW9AoKZpWA5gzajN/uBrziCUIySW9YuqYE3Yf3g2M13Ovrbehg/dr
	vI+tbRZzkrG3tO2oaTs0iBlNzeiRoys=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1691685393;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=19h9QNSgdzIWywJanN9veEOMa6s1Xj+q+Cz0v3FP+f4=;
	b=NWWqKFNbDZBln4sSAtj33wuORgNzUuDPhyE63EaKkKg3gsXILvYYR+v0b3lf9S97ya6XCE
	f5wjW2+XbXSXUoCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F1D3C138E0;
	Thu, 10 Aug 2023 16:36:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id IBVjOhAS1WSEPQAAMHmgww
	(envelope-from <vbabka@suse.cz>); Thu, 10 Aug 2023 16:36:32 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Pekka Enberg <penberg@kernel.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [RFC v2 4/7] maple_tree: avoid bulk alloc/free to use percpu array more
Date: Thu, 10 Aug 2023 18:36:32 +0200
Message-ID: <20230810163627.6206-13-vbabka@suse.cz>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230810163627.6206-9-vbabka@suse.cz>
References: <20230810163627.6206-9-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Using bulk alloc/free on a cache with percpu array should not be
necessary and the bulk alloc actually bypasses the array (the prefill
functionality currently relies on this).

The simplest change for now is just to convert the respective maple tree
wrappers to do a loop of normal alloc/free. We can optimize later
versions if needed.
---
 lib/maple_tree.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 1196d0a17f03..926bee7a274a 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -161,12 +161,20 @@ static inline struct maple_node *mt_alloc_one(gfp_t gfp)
 
 static inline int mt_alloc_bulk(gfp_t gfp, size_t size, void **nodes)
 {
-	return kmem_cache_alloc_bulk(maple_node_cache, gfp, size, nodes);
+	int i;
+
+	for (i = 0; i < size; i++) {
+		nodes[i] = kmem_cache_alloc(maple_node_cache, gfp);
+		if (!nodes[i])
+			break;
+	}
+	return i;
 }
 
 static inline void mt_free_bulk(size_t size, void __rcu **nodes)
 {
-	kmem_cache_free_bulk(maple_node_cache, size, (void **)nodes);
+	for (size_t i = 0; i < size; i++)
+		kmem_cache_free(maple_node_cache, nodes[i]);
 }
 
 static void mt_free_rcu(struct rcu_head *head)
-- 
2.41.0

