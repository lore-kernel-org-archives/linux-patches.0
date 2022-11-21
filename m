Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A541D6FB1
	for <patches@lists.linux.dev>; Mon, 21 Nov 2022 17:12:13 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D35E41F8B9;
	Mon, 21 Nov 2022 17:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1669050731; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i2JvvueNOyE9wh1FqFGLP1e7ObZGjB/Lqr6ycx9tY24=;
	b=oObh6wdNyZY9Dk99j4ViHgNh4V3x7QkVPcXKRIc1vMg0NknSGlK4nStjQ3MC9q31fDkn3g
	VEXegpinTx+uvpuiTMD7CV+Q/YH333P46dlA7hmutWR0nA0aglK+xwBz3QqoiZ+jV+mG0P
	0MNq2GbwWXP4QlFMuvb26vfpljrSZic=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1669050731;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i2JvvueNOyE9wh1FqFGLP1e7ObZGjB/Lqr6ycx9tY24=;
	b=leDY5l4B4sBPGcsiGjIniDoS7JrKHJETEOsEfHQjeMxhOfosw5yHw4fzoQ38mjrhMZxumR
	q2GPwRTyterJdTDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A6CDF13B03;
	Mon, 21 Nov 2022 17:12:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id SPMeKGuxe2MQeQAAMHmgww
	(envelope-from <vbabka@suse.cz>); Mon, 21 Nov 2022 17:12:11 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	patches@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 07/12] mm, slab: ignore SLAB_RECLAIM_ACCOUNT with CONFIG_SLUB_TINY
Date: Mon, 21 Nov 2022 18:11:57 +0100
Message-Id: <20221121171202.22080-8-vbabka@suse.cz>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221121171202.22080-1-vbabka@suse.cz>
References: <20221121171202.22080-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SLAB_RECLAIM_ACCOUNT caches allocate their slab pages with
__GFP_RECLAIMABLE and can help against fragmentation by grouping pages
by mobility, but on tiny systems mobility grouping is likely disabled
anyway and ignoring SLAB_RECLAIM_ACCOUNT might instead lead to merging
of caches that are made incompatible just by the flag.

Thus with CONFIG_SLUB_TINY, make SLAB_RECLAIM_ACCOUNT ineffective.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/slab.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 3ce9474c90ab..1cbbda03ad06 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -129,7 +129,11 @@
 
 /* The following flags affect the page allocator grouping pages by mobility */
 /* Objects are reclaimable */
+#ifndef CONFIG_SLUB_TINY
 #define SLAB_RECLAIM_ACCOUNT	((slab_flags_t __force)0x00020000U)
+#else
+#define SLAB_RECLAIM_ACCOUNT	0
+#endif
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
 
 /*
-- 
2.38.1

