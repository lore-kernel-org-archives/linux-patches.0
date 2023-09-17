Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238926FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CB0C433C7;
	Sun, 17 Sep 2023 20:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981141;
	bh=p26DkhKFJ81co0k2n3hA1EcFlHxbunOtbVuE5poYLZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zDqU8fl9K0qNnkG/6GOJMPw3x1TH4/rz54qEvSTPVRZh9hDpXFVBXE0KEdiMqMgZw
	 ESKL6MuXM6kmsPU/OBV+tbkjEj3O2RyWb9UOss5etN5p6JrJTtPWQ1d8NbpLJQ1ZYw
	 p5DB+oLETWz9HI716aIisQawYh/JPGvY8Kj9d9Gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Soheil Hassas Yeganeh <soheil@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Ajay Kaher <akaher@vmware.com>
Subject: [PATCH 6.1 054/219] net: factorize code in kmalloc_reserve()
Date: Sun, 17 Sep 2023 21:13:01 +0200
Message-ID: <20230917191042.960936698@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 5c0e820cbbbe2d1c4cea5cd2bfc1302c123436df upstream.

All kmalloc_reserve() callers have to make the same computation,
we can factorize them, to prepare following patch in the series.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[Ajay: Regenerated the patch for v6.1.y]
Signed-off-by: Ajay Kaher <akaher@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |   27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -424,17 +424,20 @@ EXPORT_SYMBOL(napi_build_skb);
  * may be used. Otherwise, the packet data may be discarded until enough
  * memory is free
  */
-static void *kmalloc_reserve(size_t size, gfp_t flags, int node,
+static void *kmalloc_reserve(unsigned int *size, gfp_t flags, int node,
 			     bool *pfmemalloc)
 {
-	void *obj;
 	bool ret_pfmemalloc = false;
+	unsigned int obj_size;
+	void *obj;
 
+	obj_size = SKB_HEAD_ALIGN(*size);
+	*size = obj_size = kmalloc_size_roundup(obj_size);
 	/*
 	 * Try a regular allocation, when that fails and we're not entitled
 	 * to the reserves, fail.
 	 */
-	obj = kmalloc_node_track_caller(size,
+	obj = kmalloc_node_track_caller(obj_size,
 					flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
 					node);
 	if (obj || !(gfp_pfmemalloc_allowed(flags)))
@@ -442,7 +445,7 @@ static void *kmalloc_reserve(size_t size
 
 	/* Try again but now we are using pfmemalloc reserves */
 	ret_pfmemalloc = true;
-	obj = kmalloc_node_track_caller(size, flags, node);
+	obj = kmalloc_node_track_caller(obj_size, flags, node);
 
 out:
 	if (pfmemalloc)
@@ -503,9 +506,7 @@ struct sk_buff *__alloc_skb(unsigned int
 	 * aligned memory blocks, unless SLUB/SLAB debug is enabled.
 	 * Both skb->head and skb_shared_info are cache line aligned.
 	 */
-	size = SKB_HEAD_ALIGN(size);
-	size = kmalloc_size_roundup(size);
-	data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
+	data = kmalloc_reserve(&size, gfp_mask, node, &pfmemalloc);
 	if (unlikely(!data))
 		goto nodata;
 	/* kmalloc_size_roundup() might give us more room than requested.
@@ -1832,9 +1833,7 @@ int pskb_expand_head(struct sk_buff *skb
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
 
-	size = SKB_HEAD_ALIGN(size);
-	size = kmalloc_size_roundup(size);
-	data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
+	data = kmalloc_reserve(&size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
 		goto nodata;
 	size = SKB_WITH_OVERHEAD(size);
@@ -6198,9 +6197,7 @@ static int pskb_carve_inside_header(stru
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
 
-	size = SKB_HEAD_ALIGN(size);
-	size = kmalloc_size_roundup(size);
-	data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
+	data = kmalloc_reserve(&size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
 		return -ENOMEM;
 	size = SKB_WITH_OVERHEAD(size);
@@ -6316,9 +6313,7 @@ static int pskb_carve_inside_nonlinear(s
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
 
-	size = SKB_HEAD_ALIGN(size);
-	size = kmalloc_size_roundup(size);
-	data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
+	data = kmalloc_reserve(&size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
 		return -ENOMEM;
 	size = SKB_WITH_OVERHEAD(size);


