Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDA3179A3;
	Fri, 24 Apr 2026 13:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037872; cv=none; b=YDpuMA6qxj9uig480f8F1gJl9CmJppEz0T3EmnkYhB2dnO3HD/YuU5du3IkLHGkze6viDSKe/ayVt2WbDkoWyv4kWDwS39duaNVV30kiDwNyL+x6JiiBnVbjreKUyOsJxaINWJOaeMFL1iYZ9mqCbTAe4hQfFSR+g7MaWGL07uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037872; c=relaxed/simple;
	bh=B2WnzFakAgfklwZ3th8PIGbs8h54MSptbyKuy7mPrI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AiUz8murdqf229+hx6fZIPCKn3Zb9a2AAQfg2WnMD70TK2RH5WRF6sKz4uIUdopVkREEgPryJUV4WS7/LLl74rkfjjkJc9eaCuyQ7XoaqkQAa8hmUTnhx+ioV4jdldRfW9l2IVBmSX7svk6L/lHcXKtbApKsWcpR/HyRnKG+jYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RV/hhrAj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RV/hhrAj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53924C19425;
	Fri, 24 Apr 2026 13:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037872;
	bh=B2WnzFakAgfklwZ3th8PIGbs8h54MSptbyKuy7mPrI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RV/hhrAj7i3WBgB4YktTYVcRB1Y0ZS4oXW/s++2xhGGIBk/w1V340c1vZwFhYk9DO
	 dkKDQ8vxcRdfP0ftEC5/mY7LjHpn7hW8yUkEyp9xFYe/2v+Q3dDH+eSTW54Qo7GIVs
	 Lo4yz0CzjTH2toyO+Gd4tZm0UNV6SltsvMRM+2b0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonius <antonius@bluedragonsec.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/166] net: skb: fix cross-cache free of KFENCE-allocated skb head
Date: Fri, 24 Apr 2026 15:30:16 +0200
Message-ID: <20260424132554.073750137@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 0f42e3f4fe2a58394e37241d02d9ca6ab7b7d516 ]

SKB_SMALL_HEAD_CACHE_SIZE is intentionally set to a non-power-of-2
value (e.g. 704 on x86_64) to avoid collisions with generic kmalloc
bucket sizes. This ensures that skb_kfree_head() can reliably use
skb_end_offset to distinguish skb heads allocated from
skb_small_head_cache vs. generic kmalloc caches.

However, when KFENCE is enabled, kfence_ksize() returns the exact
requested allocation size instead of the slab bucket size. If a caller
(e.g. bpf_test_init) allocates skb head data via kzalloc() and the
requested size happens to equal SKB_SMALL_HEAD_CACHE_SIZE, then
slab_build_skb() -> ksize() returns that exact value. After subtracting
skb_shared_info overhead, skb_end_offset ends up matching
SKB_SMALL_HEAD_HEADROOM, causing skb_kfree_head() to incorrectly free
the object to skb_small_head_cache instead of back to the original
kmalloc cache, resulting in a slab cross-cache free:

  kmem_cache_free(skbuff_small_head): Wrong slab cache. Expected
  skbuff_small_head but got kmalloc-1k

Fix this by always calling kfree(head) in skb_kfree_head(). This keeps
the free path generic and avoids allocator-specific misclassification
for KFENCE objects.

Fixes: bf9f1baa279f ("net: add dedicated kmem_cache for typical/small skb->head")
Reported-by: Antonius <antonius@bluedragonsec.com>
Closes: https://lore.kernel.org/netdev/CAK8a0jxC5L5N7hq-DT2_NhUyjBxrPocoiDazzsBk4TGgT1r4-A@mail.gmail.com/
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260403014517.142550-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ adapted variable names ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 4c28954f915fa..c81ef99d39b04 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -943,10 +943,7 @@ static bool skb_pp_recycle(struct sk_buff *skb, void *data, bool napi_safe)
 
 static void skb_kfree_head(void *head, unsigned int end_offset)
 {
-	if (end_offset == SKB_SMALL_HEAD_HEADROOM)
-		kmem_cache_free(skb_small_head_cache, head);
-	else
-		kfree(head);
+	kfree(head);
 }
 
 static void skb_free_head(struct sk_buff *skb, bool napi_safe)
-- 
2.53.0



