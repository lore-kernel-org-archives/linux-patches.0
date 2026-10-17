Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2D532FA18;
	Sat, 17 Oct 2026 17:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259222; cv=none; b=aofA0sNNgvM/TFN7spRJHOOYPwpRSXyZiow+Ev7By5C0Eww9fryEjR9l1wa5t9TXYFgjT80VwmdLZvAS/HEfhOoSl98H0Jpw/XkHYicNJxWCdSHByjDvUh+HIgIKI710WD9tn3ROC9nagrjkF5ltMl3qmKIhW1C+xSYK3yKGsOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259222; c=relaxed/simple;
	bh=tB5IMzquw4IKEKno1JB177ChwqHAr6sZIom8waTs4lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chh07cl7njkQpAp5zn/beUbQ4bTEnHt6FdNXsaptFuTftN+xMPR9sA9LJX+p7jk/xYa0+P5g6syqZd9tARKQa7oKdN5dzRT6am+yZvzPrMgONHiMFShG0NtVNuD8kDmlorXt2eUWe7h/xOweVgWXFk+cWpZjTw1X3R+w0WaHq/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J35fnIyl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J35fnIyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66161F000C4;
	Sat, 17 Oct 2026 17:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259221;
	bh=vjaOFU2i14jL/0F/ZT1UJHem77OseATjSET4OwVS7/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J35fnIyl5PlZlSOwceB/2WebuFhZo3VPW5LYB/4P8hWPEBVZ0L5YjFYSUNks2P3zc
	 gfPaZzolj9VkCzK6lezSSdmW4Zp/wCjvF0t/4+Q9NjI2pEPF0KvdMCC6QmgvBaqZvy
	 9KotzOkD8UyHp+c30QpmUvRu5whKGCyLcKjLfsc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	"Claude Sonnet 5.5" <noreply@anthropic.com>
Subject: [PATCH 6.6 1141/1674] bpf: net: netfilter: drop dead NULL checks
Date: Sat, 17 Oct 2026 17:56:53 +0200
Message-ID: <20261017160500.446261914@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit bddaf9adda72447061a52b328c2d4c64b327fa30 ]

bpf_xdp_ct_lookup() and bpf_skb_ct_lookup() receive bpf_tuple and opts
parameter that are expected to be not NULL for real usages (see doc
string above functions). They return an error if NULL is passed for opts
or tuple.

The verifier will now reject programs that pass NULL to these
parameters, the kfuns can assume that these are always valid pointer, so
drop the NULL checks for these parameters.

Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Link: https://lore.kernel.org/r/20260102180038.2708325-4-puranjay@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Drop only the dead opts NULL guards on the error path of the four kfunc
wrappers, and keep the NULL checks inside __bpf_nf_ct_alloc_entry().
Since the verifier-side change is not present here, a NULL opts is
instead rejected up front in each wrapper, so the unconditional
opts->error write cannot dereference NULL.

Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>
Stable-dep-of: 6f6183a39533 ("bpf: Guard conntrack opts error writes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_bpf.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index b21799d468d28..ba990086bbb08 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -256,11 +256,13 @@ bpf_xdp_ct_alloc(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
 	struct xdp_buff *ctx = (struct xdp_buff *)xdp_ctx;
 	struct nf_conn *nfct;
 
+	if (!opts)
+		return NULL;
+
 	nfct = __bpf_nf_ct_alloc_entry(dev_net(ctx->rxq->dev), bpf_tuple, tuple__sz,
 				       opts, opts__sz, 10);
 	if (IS_ERR(nfct)) {
-		if (opts)
-			opts->error = PTR_ERR(nfct);
+		opts->error = PTR_ERR(nfct);
 		return NULL;
 	}
 
@@ -291,11 +293,13 @@ bpf_xdp_ct_lookup(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
 	struct net *caller_net;
 	struct nf_conn *nfct;
 
+	if (!opts)
+		return NULL;
+
 	caller_net = dev_net(ctx->rxq->dev);
 	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, tuple__sz, opts, opts__sz);
 	if (IS_ERR(nfct)) {
-		if (opts)
-			opts->error = PTR_ERR(nfct);
+		opts->error = PTR_ERR(nfct);
 		return NULL;
 	}
 	return nfct;
@@ -324,11 +328,13 @@ bpf_skb_ct_alloc(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
 	struct nf_conn *nfct;
 	struct net *net;
 
+	if (!opts)
+		return NULL;
+
 	net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
 	nfct = __bpf_nf_ct_alloc_entry(net, bpf_tuple, tuple__sz, opts, opts__sz, 10);
 	if (IS_ERR(nfct)) {
-		if (opts)
-			opts->error = PTR_ERR(nfct);
+		opts->error = PTR_ERR(nfct);
 		return NULL;
 	}
 
@@ -359,11 +365,13 @@ bpf_skb_ct_lookup(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
 	struct net *caller_net;
 	struct nf_conn *nfct;
 
+	if (!opts)
+		return NULL;
+
 	caller_net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
 	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, tuple__sz, opts, opts__sz);
 	if (IS_ERR(nfct)) {
-		if (opts)
-			opts->error = PTR_ERR(nfct);
+		opts->error = PTR_ERR(nfct);
 		return NULL;
 	}
 	return nfct;
-- 
2.53.0



