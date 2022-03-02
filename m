Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AB33FFA
	for <patches@lists.linux.dev>; Wed,  2 Mar 2022 17:31:38 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 796F41F3A3;
	Wed,  2 Mar 2022 17:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1646242296; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r1N7lHefdQdRLrZdn0IGuF8+VmMNKPWirbLjcNDxaGY=;
	b=IDwyu0HRPpEDdX3qH4wxSuf3FbtkW1Sq3zxn73spk4TX9GhT7sboFX1MKRmUJf/VjurR3q
	h18ttIBZcoYyZaas0UDCc9F87KDQn17wA0zUPj53iZTIEAnyff6E+4l+LBCG6wFyi6naEP
	AX/eb9Xqo+YXAXPDlwjMDgLmEa6p5Eo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1646242296;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r1N7lHefdQdRLrZdn0IGuF8+VmMNKPWirbLjcNDxaGY=;
	b=aTf+RLXTMppbndGTrpCm9edJUqcEcfS5SqBs3R2NtOewR+I8RTE9HLYSpbcwrSVbOB56qo
	MFwg4DkR8mkP70Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3D91213A89;
	Wed,  2 Mar 2022 17:31:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id +Cz/DfipH2LPTAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 02 Mar 2022 17:31:36 +0000
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
	Faiyaz Mohammed <faiyazm@codeaurora.org>,
	Marco Elver <elver@google.com>,
	Mike Rapoport <rppt@linux.ibm.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Imran Khan <imran.f.khan@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v2 2/6] mm/slub: move struct track init out of set_track()
Date: Wed,  2 Mar 2022 18:31:18 +0100
Message-Id: <20220302173122.11939-3-vbabka@suse.cz>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220302173122.11939-1-vbabka@suse.cz>
References: <20220302173122.11939-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2040; h=from:subject; bh=5V02Ql5Wwt6ho1BAsi4n/qBKIm2FLxfXUIJYaK6h4Vs=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBiH6nmjmJgS1lZ546XQoaxj+A8/9t1bG5DvArQgDFu 1xtN6hKJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYh+p5gAKCRDgIcpz8YmpECZ9CA Co15DjumUXFzKv14uunJSKOZY7cWSOuXlRF6M8bUCvUOz9SQPLNEVYQ6NA99DDIQltLe8NcWBlkIL0 nMFZpxbLP754+v0Tb5apmx2f/ixA9Uh8ja/gUAQ/h7AnVyD50tXpZ3uW2cYcoDRuCQIqtu+k7QBAml neMcM5aglvuFzaXdfZhR8kO92sZEnzpBJDPn2XiV/tyn+2F1H6FOYv2GE+BD7Z83KjeIb0i4mqxrLQ eVGTEmQxMsN1Fe81Z8zyaqSQevtlivkIUqwEaEi4QZQsjo7XTkrtvtR22ZmdUYegp0qhmjjwesmCdn p/08XmwOt9k25L46Isho9OYs3qL04V
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
index 261474092e43..1fc451f4fe62 100644
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

