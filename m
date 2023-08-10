Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789F31FB4C
	for <patches@lists.linux.dev>; Thu, 10 Aug 2023 16:36:40 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F036821878;
	Thu, 10 Aug 2023 16:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1691685392; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a3DtkVdLGQHDYk90N/OXEPjHa8PNLxLzj/qp7wDJMuQ=;
	b=izuGpZjTDaa1X7FM+8xTm5XGp80s21t8mw95pR1CYB5uPp0dA8c+tZ0jgOTQBfSnlPUZXc
	vQiMiGKsA7yQKGOWxzUA/EX95/ge5PmBAW/5TI6OTaJmg4IENCoK0N2z6vsWBJv2ji8loT
	oEXgrJoEYRtt2UOfw5uspqh2z5YapbY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1691685392;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a3DtkVdLGQHDYk90N/OXEPjHa8PNLxLzj/qp7wDJMuQ=;
	b=p6eqWXON9YDd4m3Wr/OaVX58a9pQHfuB4SGI9tgsmckkAANRrz+0BOIX9nWMdm6L9jpBej
	SEImetYJhoV2wgAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C432F139D1;
	Thu, 10 Aug 2023 16:36:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id IMZJLxAS1WSEPQAAMHmgww
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
Subject: [RFC v2 3/7] maple_tree: use slub percpu array
Date: Thu, 10 Aug 2023 18:36:31 +0200
Message-ID: <20230810163627.6206-12-vbabka@suse.cz>
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

Just make sure the maple_node_cache has a percpu array of size 32.

Will break with CONFIG_SLAB.
---
 lib/maple_tree.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 4dd73cf936a6..1196d0a17f03 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -6180,9 +6180,16 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 
 void __init maple_tree_init(void)
 {
+	int ret;
+
 	maple_node_cache = kmem_cache_create("maple_node",
 			sizeof(struct maple_node), sizeof(struct maple_node),
-			SLAB_PANIC, NULL);
+			SLAB_PANIC | SLAB_NO_MERGE, NULL);
+
+	ret = kmem_cache_setup_percpu_array(maple_node_cache, 32);
+
+	if (ret)
+		pr_warn("error %d creating percpu_array for maple_node_cache\n", ret);
 }
 
 /**
-- 
2.41.0

