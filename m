Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9BF2CAF
	for <patches@lists.linux.dev>; Tue,  4 Jan 2022 00:11:01 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C28A41F3AB;
	Tue,  4 Jan 2022 00:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641255058; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ht0n9p2pCeOge5Mzq1bWzoCpt8zfS9QEh0IeqT/nkIk=;
	b=i82qMw144vx7y8ym9aF3luWXziPiX4BI0ZwGCZcw6XMN2ZRCtNuR8yW47N5X+11XjIvQU7
	h57gESyTaejwmn6nZlmORpzVDeWm52bJo025rcQxhyB3BxEw9lk4dBTLgwxSrm47By+X1a
	bpiKhU0Z4gLRdLP7r1yv2HMs+eXlTtA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641255058;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ht0n9p2pCeOge5Mzq1bWzoCpt8zfS9QEh0IeqT/nkIk=;
	b=1N8UL86AQArnFzAZJKOiZh59stUKm9rP5fHVHqJYZSgLyF0XmawiXDwXkfO0BkKoJXTRBx
	aP1rDRplemVEBJCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9A2A1139EE;
	Tue,  4 Jan 2022 00:10:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id qCwQJZKQ02FEQwAAMHmgww
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
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v4 29/32] mm/slub: Define struct slab fields for CONFIG_SLUB_CPU_PARTIAL only when enabled
Date: Tue,  4 Jan 2022 01:10:43 +0100
Message-Id: <20220104001046.12263-30-vbabka@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104001046.12263-1-vbabka@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2420; h=from:subject; bh=j3xoBT34DCarlz/GMl3e6asupXBOQM4dCmkib4lGaR0=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBh05CCFrb+KuFwzFQ+bmHVznWpgqDx7aboRjno/K/h sk5pREaJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYdOQggAKCRDgIcpz8YmpEIgpB/ 4htE7W7aIl/yrIxq7V9F8N6Us/tvtME6T0Z7Zbenq5r5qfr4szFvGRuSQRG/QGqxhp0t9VKzjEzLMK +MumWge0ooFwIlFXDAK1eUSfWVordsGJ2b9FmqpOmr6BG2DLfIFFRvkzAGPH3rOoQ1nHmKOcSOK1vS KuMJg8R7vHRXO47MEOesqU3uspWZ5kAwVBHk7Nw1x0QpF6z+tcH+mCr7IW0/AwE6lkllKf+N1NanFB A6DkDV1mTOBsr3Z0+HFF8dbDMhIVhkypdwkmAWXXvLGshuPqWkJL1maysF86o70aa8BwXh3kcvU/TC ESGiRQ5Ha9CVY53v9zfj7wKRm6UE44
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

The fields 'next' and 'slabs' are only used when CONFIG_SLUB_CPU_PARTIAL
is enabled. We can put their definition to #ifdef to prevent accidental
use when disabled.

Currenlty show_slab_objects() and slabs_cpu_partial_show() contain code
accessing the slabs field that's effectively dead with
CONFIG_SLUB_CPU_PARTIAL=n through the wrappers slub_percpu_partial() and
slub_percpu_partial_read_once(), but to prevent a compile error, we need
to hide all this code behind #ifdef.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
---
 mm/slab.h | 2 ++
 mm/slub.c | 8 ++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 362832f465e6..ac8be7dab535 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -25,10 +25,12 @@ struct slab {
 	union {
 		struct list_head slab_list;
 		struct rcu_head rcu_head;
+#ifdef CONFIG_SLUB_CPU_PARTIAL
 		struct {
 			struct slab *next;
 			int slabs;	/* Nr of slabs left */
 		};
+#endif
 	};
 	struct kmem_cache *slab_cache;
 	/* Double-word boundary */
diff --git a/mm/slub.c b/mm/slub.c
index d08ba1025aae..261474092e43 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5258,6 +5258,7 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
 			total += x;
 			nodes[node] += x;
 
+#ifdef CONFIG_SLUB_CPU_PARTIAL
 			slab = slub_percpu_partial_read_once(c);
 			if (slab) {
 				node = slab_nid(slab);
@@ -5270,6 +5271,7 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
 				total += x;
 				nodes[node] += x;
 			}
+#endif
 		}
 	}
 
@@ -5469,9 +5471,10 @@ static ssize_t slabs_cpu_partial_show(struct kmem_cache *s, char *buf)
 {
 	int objects = 0;
 	int slabs = 0;
-	int cpu;
+	int cpu __maybe_unused;
 	int len = 0;
 
+#ifdef CONFIG_SLUB_CPU_PARTIAL
 	for_each_online_cpu(cpu) {
 		struct slab *slab;
 
@@ -5480,12 +5483,13 @@ static ssize_t slabs_cpu_partial_show(struct kmem_cache *s, char *buf)
 		if (slab)
 			slabs += slab->slabs;
 	}
+#endif
 
 	/* Approximate half-full slabs, see slub_set_cpu_partial() */
 	objects = (slabs * oo_objects(s->oo)) / 2;
 	len += sysfs_emit_at(buf, len, "%d(%d)", objects, slabs);
 
-#ifdef CONFIG_SMP
+#if defined(CONFIG_SLUB_CPU_PARTIAL) && defined(CONFIG_SMP)
 	for_each_online_cpu(cpu) {
 		struct slab *slab;
 
-- 
2.34.1

