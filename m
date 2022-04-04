Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4466B2F47
	for <patches@lists.linux.dev>; Mon,  4 Apr 2022 16:41:28 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 52825210FC;
	Mon,  4 Apr 2022 16:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1649090480; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iaE2YvQWImFfSU0vpFQAVEvFm93nlCxWB9zb2gu0sPw=;
	b=Aq4DwyFirzDpf643d6LaNTryRKgg7O+NS/BhX6awzui5v67ahbF167x2uJ4IVhlqqB1Qhi
	I546Ma+WaIhbgy0P6wzM9k3qdJHuuc4qMYKDuWzkGSApqOUr5eG9GjQnQnEfJqldefGCdX
	0n/qQKfOFnFxjqL/wSYI4V4vxsTBTy0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1649090480;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iaE2YvQWImFfSU0vpFQAVEvFm93nlCxWB9zb2gu0sPw=;
	b=eK5U25dTPANluiZzRfIbMte9s4p29IJQoGQ84fGRIy3pMoj0hICHeDPHIVww0a44zz0/Yp
	aIy7jm9OOTEOSADg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 228CB12FC5;
	Mon,  4 Apr 2022 16:41:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id wOviB7AfS2LjfAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Mon, 04 Apr 2022 16:41:20 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: David Rientjes <rientjes@google.com>,
	Christoph Lameter <cl@linux.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Oliver Glitta <glittao@gmail.com>,
	Marco Elver <elver@google.com>,
	Mike Rapoport <rppt@linux.ibm.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Imran Khan <imran.f.khan@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v3 2/6] mm/slub: move struct track init out of set_track()
Date: Mon,  4 Apr 2022 18:41:08 +0200
Message-Id: <20220404164112.18372-3-vbabka@suse.cz>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404164112.18372-1-vbabka@suse.cz>
References: <20220404164112.18372-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2040; h=from:subject; bh=zs3eo+rtqVSox6il95y1GSalLVpmki26s9979QfrOMU=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBiSx+kjPN+TrSQnc6TZ653XW3JCx/kwZAczK0EOz/c Ron6iIiJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYksfpAAKCRDgIcpz8YmpEG23B/ 9nhTJhIIp33l1sFVO1vFJMQhAgm86MyxIu8FsrjB2606GdpWRVtTw2z5YRfxr9SPAT+ReeGrYbV2jH nRw1BKaEn2uaI7dmtMJbS8A02vJdQ81IYbuog734gHEBPcnwHGknA3EWHFvfoB+FuEWvVj8eYVTePg koaBMTKgjQf6C0oUAob9QxCeZNMZxFRYMyPk2BYwHsYT9cCKcq6URNkfdXkWZQn9BQaSvQDkwS90Vm 2BQDZOmCZkevFucPzODgaZ/2gBDNw6L0TUnwn3B8Fx3rrfyVFyDUB4K04DudJn1hy2SdwNvCOay3LY ejOVai4fUxxfY4gg4sqxTUB8XJXgxh
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

set_track() either zeroes out the struct track or fills it, depending on
the addr parameter. This is unnecessary as there's only one place that
calls it for the initialization - init_tracking(). We can simply do the
zeroing there, with a single memset() that covers both TRACK_ALLOC and
TRACK_FREE as they are adjacent.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-and-tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
---
 mm/slub.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 74d92aa4a3a2..cd4fd0159911 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -729,34 +729,32 @@ static void set_track(struct kmem_cache *s, void *object,
 {
 	struct track *p = get_track(s, object, alloc);
 
-	if (addr) {
 #ifdef CONFIG_STACKTRACE
-		unsigned int nr_entries;
+	unsigned int nr_entries;
 
-		metadata_access_enable();
-		nr_entries = stack_trace_save(kasan_reset_tag(p->addrs),
-					      TRACK_ADDRS_COUNT, 3);
-		metadata_access_disable();
+	metadata_access_enable();
+	nr_entries = stack_trace_save(kasan_reset_tag(p->addrs),
+				      TRACK_ADDRS_COUNT, 3);
+	metadata_access_disable();
 
-		if (nr_entries < TRACK_ADDRS_COUNT)
-			p->addrs[nr_entries] = 0;
+	if (nr_entries < TRACK_ADDRS_COUNT)
+		p->addrs[nr_entries] = 0;
 #endif
-		p->addr = addr;
-		p->cpu = smp_processor_id();
-		p->pid = current->pid;
-		p->when = jiffies;
-	} else {
-		memset(p, 0, sizeof(struct track));
-	}
+	p->addr = addr;
+	p->cpu = smp_processor_id();
+	p->pid = current->pid;
+	p->when = jiffies;
 }
 
 static void init_tracking(struct kmem_cache *s, void *object)
 {
+	struct track *p;
+
 	if (!(s->flags & SLAB_STORE_USER))
 		return;
 
-	set_track(s, object, TRACK_FREE, 0UL);
-	set_track(s, object, TRACK_ALLOC, 0UL);
+	p = get_track(s, object, TRACK_ALLOC);
+	memset(p, 0, 2*sizeof(struct track));
 }
 
 static void print_track(const char *s, struct track *t, unsigned long pr_time)
-- 
2.35.1

