Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B1B15C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589CCC433C1;
	Mon,  5 Dec 2022 19:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670267956;
	bh=fnsxHxIIsY0+x5eodmWF8fyX0v1jGu2jQT0brXaeNlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dxeAnZkpsZ0uJxrwCak/oFQmzJZcY227Ho7U/ShpJz6/HJfVFXqjT1W0DczO0Q+Kv
	 carVDUarc+L9R5GXZrl7AqlitLbBsq61I9G7pGqtVFhBw0ziJ1QGVjPnjzND7A/oYS
	 Z7EDOWibjCrjo2AoSjv5A0kkUEWXcutngp1Hk2aI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1e9af9185d8850e2c2fa@syzkaller.appspotmail.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Eric Dumazet <edumazet@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 008/105] af_key: Fix send_acquire race with pfkey_register
Date: Mon,  5 Dec 2022 20:08:40 +0100
Message-Id: <20221205190803.387074568@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 7f57f8165cb6d2c206e2b9ada53b9e2d6d8af42f ]

The function pfkey_send_acquire may race with pfkey_register
(which could even be in a different name space).  This may result
in a buffer overrun.

Allocating the maximum amount of memory that could be used prevents
this.

Reported-by: syzbot+1e9af9185d8850e2c2fa@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/key/af_key.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 337c6bc8211e..976b67089ac1 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2915,7 +2915,7 @@ static int count_ah_combs(const struct xfrm_tmpl *t)
 			break;
 		if (!aalg->pfkey_supported)
 			continue;
-		if (aalg_tmpl_set(t, aalg) && aalg->available)
+		if (aalg_tmpl_set(t, aalg))
 			sz += sizeof(struct sadb_comb);
 	}
 	return sz + sizeof(struct sadb_prop);
@@ -2933,7 +2933,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 		if (!ealg->pfkey_supported)
 			continue;
 
-		if (!(ealg_tmpl_set(t, ealg) && ealg->available))
+		if (!(ealg_tmpl_set(t, ealg)))
 			continue;
 
 		for (k = 1; ; k++) {
@@ -2944,16 +2944,17 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 			if (!aalg->pfkey_supported)
 				continue;
 
-			if (aalg_tmpl_set(t, aalg) && aalg->available)
+			if (aalg_tmpl_set(t, aalg))
 				sz += sizeof(struct sadb_comb);
 		}
 	}
 	return sz + sizeof(struct sadb_prop);
 }
 
-static void dump_ah_combs(struct sk_buff *skb, const struct xfrm_tmpl *t)
+static int dump_ah_combs(struct sk_buff *skb, const struct xfrm_tmpl *t)
 {
 	struct sadb_prop *p;
+	int sz = 0;
 	int i;
 
 	p = skb_put(skb, sizeof(struct sadb_prop));
@@ -2981,13 +2982,17 @@ static void dump_ah_combs(struct sk_buff *skb, const struct xfrm_tmpl *t)
 			c->sadb_comb_soft_addtime = 20*60*60;
 			c->sadb_comb_hard_usetime = 8*60*60;
 			c->sadb_comb_soft_usetime = 7*60*60;
+			sz += sizeof(*c);
 		}
 	}
+
+	return sz + sizeof(*p);
 }
 
-static void dump_esp_combs(struct sk_buff *skb, const struct xfrm_tmpl *t)
+static int dump_esp_combs(struct sk_buff *skb, const struct xfrm_tmpl *t)
 {
 	struct sadb_prop *p;
+	int sz = 0;
 	int i, k;
 
 	p = skb_put(skb, sizeof(struct sadb_prop));
@@ -3029,8 +3034,11 @@ static void dump_esp_combs(struct sk_buff *skb, const struct xfrm_tmpl *t)
 			c->sadb_comb_soft_addtime = 20*60*60;
 			c->sadb_comb_hard_usetime = 8*60*60;
 			c->sadb_comb_soft_usetime = 7*60*60;
+			sz += sizeof(*c);
 		}
 	}
+
+	return sz + sizeof(*p);
 }
 
 static int key_notify_policy_expire(struct xfrm_policy *xp, const struct km_event *c)
@@ -3160,6 +3168,7 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
 	struct sadb_x_sec_ctx *sec_ctx;
 	struct xfrm_sec_ctx *xfrm_ctx;
 	int ctx_size = 0;
+	int alg_size = 0;
 
 	sockaddr_size = pfkey_sockaddr_size(x->props.family);
 	if (!sockaddr_size)
@@ -3171,16 +3180,16 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
 		sizeof(struct sadb_x_policy);
 
 	if (x->id.proto == IPPROTO_AH)
-		size += count_ah_combs(t);
+		alg_size = count_ah_combs(t);
 	else if (x->id.proto == IPPROTO_ESP)
-		size += count_esp_combs(t);
+		alg_size = count_esp_combs(t);
 
 	if ((xfrm_ctx = x->security)) {
 		ctx_size = PFKEY_ALIGN8(xfrm_ctx->ctx_len);
 		size +=  sizeof(struct sadb_x_sec_ctx) + ctx_size;
 	}
 
-	skb =  alloc_skb(size + 16, GFP_ATOMIC);
+	skb =  alloc_skb(size + alg_size + 16, GFP_ATOMIC);
 	if (skb == NULL)
 		return -ENOMEM;
 
@@ -3234,10 +3243,13 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
 	pol->sadb_x_policy_priority = xp->priority;
 
 	/* Set sadb_comb's. */
+	alg_size = 0;
 	if (x->id.proto == IPPROTO_AH)
-		dump_ah_combs(skb, t);
+		alg_size = dump_ah_combs(skb, t);
 	else if (x->id.proto == IPPROTO_ESP)
-		dump_esp_combs(skb, t);
+		alg_size = dump_esp_combs(skb, t);
+
+	hdr->sadb_msg_len += alg_size / 8;
 
 	/* security context */
 	if (xfrm_ctx) {
-- 
2.35.1



