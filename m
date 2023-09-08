Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7E46ABB
	for <patches@lists.linux.dev>; Fri,  8 Sep 2023 14:59:29 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 065781FEFE;
	Fri,  8 Sep 2023 14:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1694184799; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9/ffVZ2jgkNFPV8v9GjIklo4R9arDXW9nEkTxNB0K6c=;
	b=KUyJUvRQS4gA2ke4GVINk61D6KwZrbVETPHCWg2keeQHFwJDBjRWoICJcRSmEkd1dxkjj5
	TweCBVVTjorbVIzvDPI61iMA74jg4u+dwy5WGvFONU/ZC9FZihSGpc9w87jcACXu3wiaDg
	SwKeICwK+C9hN+SMhocIUAFapCddKZ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1694184799;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9/ffVZ2jgkNFPV8v9GjIklo4R9arDXW9nEkTxNB0K6c=;
	b=fZHG/B1YFdRe43J1fIyQGYzL7Ak+D5TYIdHhViuuB1fMP+TMnern1sOdtMTiv+4XRfZu7K
	CUoHOR832W1ZyoDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D27E713357;
	Fri,  8 Sep 2023 14:53:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id SDC+Ml41+2QaBQAAMHmgww
	(envelope-from <vbabka@suse.cz>); Fri, 08 Sep 2023 14:53:18 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: David Rientjes <rientjes@google.com>,
	Christoph Lameter <cl@linux.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Jay Patel <jaypatel@linux.ibm.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Pekka Enberg <penberg@kernel.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	linux-mm@kvack.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 1/4] mm/slub: simplify the last resort slab order calculation
Date: Fri,  8 Sep 2023 16:53:04 +0200
Message-ID: <20230908145302.30320-7-vbabka@suse.cz>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230908145302.30320-6-vbabka@suse.cz>
References: <20230908145302.30320-6-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If calculate_order() can't fit even a single large object within
slub_max_order, it will try using the smallest necessary order that may
exceed slub_max_order but not MAX_ORDER.

Currently this is done with a call to calc_slab_order() which is
unecessary. We can simply use get_order(size). No functional change.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index f7940048138c..c6e694cb17b9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4193,7 +4193,7 @@ static inline int calculate_order(unsigned int size)
 	/*
 	 * Doh this slab cannot be placed using slub_max_order.
 	 */
-	order = calc_slab_order(size, 1, MAX_ORDER, 1);
+	order = get_order(size);
 	if (order <= MAX_ORDER)
 		return order;
 	return -ENOSYS;
-- 
2.42.0

