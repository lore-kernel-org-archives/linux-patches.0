Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624787;
	b=rU91N2cM6t8GAvkEtEwpS909h4UPX1+zfsY7kcmYHTEBxINTuSeAxID2147k0CRF0jOT
	 +pTM8lf4SIdNya8YRYtZ+PoI4pMLfVtsJFBYEHB4lG+xBoyTJjxss/PnmTRisdLlxWg+a
	 SeeWJ3uchFj/BqeF9oRfbiivP/PZpQssfxp6RdM4LfsfqnzPIuDCoEcmlaPXyrwS8PHPQ
	 QpfNl9mjqAS//bziD91d8thQi+zxzX2lfSMdi50RitXjhbMNhA+8i98J9WYuVg6msCVGe
	 p1nTdWjjZBPX5bKjgt0ie3jQqyB5sJ8A+UD+goqAAXfO0o/BEkr1KTScMuVLxhhnYWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M2k9g1RgBqkpYnM+8CHkUm8vrk4BSdCeFyUJdfDslyY=;
	b=oC201029CbWWA8oVy1MwCXISINWTRbblWhturZGB2yUF0ypmOAVFnfm3IkR7d7JC+sDX
	 rYeCZNfAXc3EqUK15VQQjZLfF301NkEsUYp8T61XdCWzRy92xGIFAoch7nQXMYt54YyGE
	 H4r2NfXPCnHXKo3qSsDblOUigET1QzQku1UZxeFVsnxd6KsiDbI3DRGxOHAArHg6zfCqG
	 776hpI5oLLaqxjcRXx7UrINgSLTGDPwhXcz9liuJnXGx3QTS1I5TNGQL8Kespkq//GyB2
	 D9HXfSFZ6ZFXxdfl0Kgd9bkmtgsmK5lMNPhcTpLfyW1ScQQL6uEiEUuVhzqBD6QpooQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HHiq7wjE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251F1606A332;
	Wed, 25 Nov 2026 16:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HHiq7wjE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7359D1F000C0;
	Wed, 25 Nov 2026 16:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624787;
	bh=M2k9g1RgBqkpYnM+8CHkUm8vrk4BSdCeFyUJdfDslyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HHiq7wjEaPGhbqDKGfAk0asC0vDoRVQBP4YZM6GpQdQJwB8ScUSwQG44sbKJ2pmbb
	 R9CgvCBD8zR47olThQvC0oVEmnu2LVUkchF/v7H0i0TWNfDCTzacet8D6ONRAcAtk6
	 zTPMKx5AOyQF2bIlWPSqopqn1RWMOXP1kWc/2SmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 306/816] net: skbuff: preserve fclone lifetime when freeing stolen heads
Date: Wed, 25 Nov 2026 15:30:54 +0100
Message-ID: <20261125143856.285000416@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 86706ffa990ecd46a4326f8eecbccbbd60a6cb8d ]

skb_morph() can give an skb from skbuff_fclone_cache a page-fragment
head without changing its fclone tag. IPv4 reassembly can produce such
an skb, which can subsequently reach the GRO stolen-head path.

napi_skb_free_stolen_head() puts the shell into the ordinary NAPI skb
cache without dropping its fclone_ref. If the embedded companion is
still live, KASAN poisons it along with the original, and later cache
reuse or eviction can overwrite or free the allocation underneath it.
A mirrored batman-adv DAT packet retained in a plug qdisc reproduces a
KASAN use-after-free in plug_dequeue().

Use kfree_skbmem() for fclones in napi_skb_free_stolen_head(), retaining
NAPI caching for ordinary skb heads. Also use kfree_skbmem() in
kfree_skb_partial(), whose stolen-head branch has the same assumption
about the allocation cache. This releases the shell according to its
allocation kind and preserves any live companion without freeing the
data that has been transferred to the receiving skb.

Fixes: f450d539c05a ("skbuff: introduce {,__}napi_build_skb() which reuses NAPI cache heads")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Link: https://patch.msgid.link/20261030042329.74461-1-kylebot@openai.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index fb95a9c627b61..a203cc89d33fa 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1488,6 +1488,10 @@ void napi_skb_free_stolen_head(struct sk_buff *skb)
 		skb_orphan(skb);
 		skb->slow_gro = 0;
 	}
+	if (skb->fclone != SKB_FCLONE_UNAVAILABLE) {
+		kfree_skbmem(skb);
+		return;
+	}
 	napi_skb_cache_put(skb);
 }
 
@@ -6056,7 +6060,7 @@ void kfree_skb_partial(struct sk_buff *skb, bool head_stolen)
 {
 	if (head_stolen) {
 		skb_release_head_state(skb);
-		kmem_cache_free(net_hotdata.skbuff_cache, skb);
+		kfree_skbmem(skb);
 	} else {
 		__kfree_skb(skb);
 	}
-- 
2.53.0



