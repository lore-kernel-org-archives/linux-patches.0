Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B469EDF53
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21541C4339E;
	Mon, 15 May 2023 16:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169365;
	bh=ouwMvcH+VsTtVEYHIhnWbS4p4FypHfr2IGXUgt5NoT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8/NGIeQaUZZl7UIhrMHV2LqrVTEjnLEPX6D01ebbiffMEOkv6OyleTTGZhqn3cvm
	 rfrQuQCOnidGC/hXjhvuK9/Nxt0zxltFqs9ALSiJBtu/mFcZk1tjl34NnadgJhT9Vd
	 TfAtdV9BDPEgzDELAUKu9zOLI8g5IntX7/a7wq2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Xin Long <lucien.xin@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Coco Li <lixiaoyan@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 035/246] tcp: fix skb_copy_ubufs() vs BIG TCP
Date: Mon, 15 May 2023 18:24:07 +0200
Message-Id: <20230515161723.652680315@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7e692df3933628d974acb9f5b334d2b3e885e2a6 ]

David Ahern reported crashes in skb_copy_ubufs() caused by TCP tx zerocopy
using hugepages, and skb length bigger than ~68 KB.

skb_copy_ubufs() assumed it could copy all payload using up to
MAX_SKB_FRAGS order-0 pages.

This assumption broke when BIG TCP was able to put up to 512 KB per skb.

We did not hit this bug at Google because we use CONFIG_MAX_SKB_FRAGS=45
and limit gso_max_size to 180000.

A solution is to use higher order pages if needed.

v2: add missing __GFP_COMP, or we leak memory.

Fixes: 7c4e983c4f3c ("net: allow gso_max_size to exceed 65536")
Reported-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/netdev/c70000f6-baa4-4a05-46d0-4b3e0dc1ccc8@gmail.com/T/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Xin Long <lucien.xin@gmail.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Coco Li <lixiaoyan@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2f9bb98170ab0..14bb41aafee30 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1705,7 +1705,7 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mask)
 {
 	int num_frags = skb_shinfo(skb)->nr_frags;
 	struct page *page, *head = NULL;
-	int i, new_frags;
+	int i, order, psize, new_frags;
 	u32 d_off;
 
 	if (skb_shared(skb) || skb_unclone(skb, gfp_mask))
@@ -1714,9 +1714,17 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mask)
 	if (!num_frags)
 		goto release;
 
-	new_frags = (__skb_pagelen(skb) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	/* We might have to allocate high order pages, so compute what minimum
+	 * page order is needed.
+	 */
+	order = 0;
+	while ((PAGE_SIZE << order) * MAX_SKB_FRAGS < __skb_pagelen(skb))
+		order++;
+	psize = (PAGE_SIZE << order);
+
+	new_frags = (__skb_pagelen(skb) + psize - 1) >> (PAGE_SHIFT + order);
 	for (i = 0; i < new_frags; i++) {
-		page = alloc_page(gfp_mask);
+		page = alloc_pages(gfp_mask | __GFP_COMP, order);
 		if (!page) {
 			while (head) {
 				struct page *next = (struct page *)page_private(head);
@@ -1743,11 +1751,11 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mask)
 			vaddr = kmap_atomic(p);
 
 			while (done < p_len) {
-				if (d_off == PAGE_SIZE) {
+				if (d_off == psize) {
 					d_off = 0;
 					page = (struct page *)page_private(page);
 				}
-				copy = min_t(u32, PAGE_SIZE - d_off, p_len - done);
+				copy = min_t(u32, psize - d_off, p_len - done);
 				memcpy(page_address(page) + d_off,
 				       vaddr + p_off + done, copy);
 				done += copy;
@@ -1763,7 +1771,7 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mask)
 
 	/* skb frags point to kernel buffers */
 	for (i = 0; i < new_frags - 1; i++) {
-		__skb_fill_page_desc(skb, i, head, 0, PAGE_SIZE);
+		__skb_fill_page_desc(skb, i, head, 0, psize);
 		head = (struct page *)page_private(head);
 	}
 	__skb_fill_page_desc(skb, new_frags - 1, head, 0, d_off);
-- 
2.39.2



