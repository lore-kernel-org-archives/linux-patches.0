Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621986;
	b=Lu2nY509QAlgx/JgvS+ZrSy9EJT8nJPfX14h/BsPp0Sr/m0IspLfV6jtfiHaKkEF2xnA
	 CRsh9mmmzb+TKV5CpBSW9Ir/cBFjCrGuy6bmVC3BOi71CcASLeVssepHFhPpCRUkk2uke
	 qWJzevtQDQiZ51RTL04qmfpwtsnFvQ6PO3b7NJi+owrv92TwNkRpHcIya5fX7gWx0U055
	 0HohAVRbI4357tvbON6ZOEpzeGGBeXiQZ+Z2e33lrrEhoGY5jFTY0nKyzIe455j2LE6X4
	 RRvlRQwmMUwkDZUdy62v3FT0w87ZDB+0Sw44JR5o2Uf7MptcHCRAvpZfZ5icp9Elb+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621986;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sdfg7LNhlqktNotx/lRTxdKflC1RLK9mdAYHc2A8UwA=;
	b=fZNeegIJuzbmdJNWMtOgYFa10PbiUJktpijbtBs/iheUFQ3FCqRn6J1vlbo7JwJ77XPo
	 ZberenslA9/U2DStGKllSUAINteF14zTCKOwFk3vmgNioQLG0QYncnkQ7+UxkfPonzGMB
	 fk7JMdJyiaTOG7LOZCVa+ACd+sOdOFTyuDioBbj15vNqZdqLhJoA0fPzDie2k6cm2Vp+b
	 /O+zXAzzgvsRWpxREZ3rNNotxMs/e+qpmTfwfdx6AKO+a3pOptnFQtyiG7DgKKRFTm1Gq
	 lBC8mcLFPajAsSEBeV7mXxD6Ea4ip1Xrql0q55UNbcoKPporP00losLJ/FAXX3Du4LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G6v8kWq8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2302606A321;
	Wed, 25 Nov 2026 15:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G6v8kWq8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3311A1F000C0;
	Wed, 25 Nov 2026 15:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621985;
	bh=sdfg7LNhlqktNotx/lRTxdKflC1RLK9mdAYHc2A8UwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G6v8kWq8ODnIIDdPPs+M/ZcTFNemgh4QdPJQEoD0+fQuBavDY1gKuRXuy/DEH0rEn
	 J9MeKfPJHl09cbOpIdE5C4AEBkKPor9DXOuaCUsWTJ2v+pCXesSG+vNtTiL2x1ttjk
	 UYOobXKUYWhoo80tYq3cdX6HkAuwEbx86OG0BU1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 392/990] net: skbuff: preserve fclone lifetime when freeing stolen heads
Date: Wed, 25 Nov 2026 15:29:19 +0100
Message-ID: <20261125143831.279288025@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f1b0045667124..de69f89086513 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1458,6 +1458,10 @@ void napi_skb_free_stolen_head(struct sk_buff *skb)
 		skb_orphan(skb);
 		skb->slow_gro = 0;
 	}
+	if (skb->fclone != SKB_FCLONE_UNAVAILABLE) {
+		kfree_skbmem(skb);
+		return;
+	}
 	napi_skb_cache_put(skb);
 }
 
@@ -6126,7 +6130,7 @@ void kfree_skb_partial(struct sk_buff *skb, bool head_stolen)
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



