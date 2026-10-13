Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBAF4F68A9;
	Tue, 13 Oct 2026 12:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893625; cv=none; b=eeMqi/tt0olNe9z0s+7gSLOkzb2ZK6886uYsvtnvh2mcj9t3D7Hf6nv/k6r0y2wkhx6bU6FBE1e9SUDqsFoejixyxPJ9Be1rJPqPces8M0GhzvxUAToeRFkNZZgFkKKn2O4s/L1/Ha9HXUIMnh0ES0w/tNkT7tIaaJM4KcIm6+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893625; c=relaxed/simple;
	bh=Jm5FPya0jdYFJZo3sjeHi9qTcc4gXlDFhGoNKrLh++g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwAujbW5n5jx2o+ju3BxR98xrlXiUvZBA3aHrJOpw5l1V1UbRmMPsURD9KWJ3YVKsj0fiZ49SasXe7vPrtwO0WLTJxb9AeWjLEh+4vyXfzwekDmK6N2iLhYzwk1mhVnft6hM0PW0ExpVw2r5IEyRBGQKM6vgvBevZdDWyhXcSnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rluQ1/OU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rluQ1/OU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3CB1F000FF;
	Tue, 13 Oct 2026 12:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893624;
	bh=rEqdQ+dnajbjn4n0PbWDW+wksR3MiokJd87zdUCvErg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rluQ1/OUcIxHKSR+jHWdo2aUzE83dDZVsyxZAgguSRj2elRzjPj9JlAl3TJLY64NU
	 Dit6Oj+pBEJDVWwwGY1kSHVLQSX1IJOWwU2z3/X2vOJYjp7Rba1U3+YmVgBehjS7Nh
	 3KUQ5l0Lk0gdG40rtNthb81vPlV1LRwToql9u4HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 287/621] bpf: net: netfilter: drop dead NULL checks
Date: Tue, 13 Oct 2026 13:34:42 +0200
Message-ID: <20261013112927.671080530@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 6f6183a39533 ("bpf: Guard conntrack opts error writes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_bpf.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 4a136fc3a9c0f..dc5d02c6e832d 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -114,8 +114,6 @@ __bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
 	struct nf_conn *ct;
 	int err;
 
-	if (!opts || !bpf_tuple)
-		return ERR_PTR(-EINVAL);
 	if (!(opts_len == NF_BPF_CT_OPTS_SZ || opts_len == 12))
 		return ERR_PTR(-EINVAL);
 	if (opts_len == NF_BPF_CT_OPTS_SZ) {
@@ -299,8 +297,7 @@ bpf_xdp_ct_alloc(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
 	nfct = __bpf_nf_ct_alloc_entry(dev_net(ctx->rxq->dev), bpf_tuple, tuple__sz,
 				       opts, opts__sz, 10);
 	if (IS_ERR(nfct)) {
-		if (opts)
-			opts->error = PTR_ERR(nfct);
+		opts->error = PTR_ERR(nfct);
 		return NULL;
 	}
 
@@ -334,8 +331,7 @@ bpf_xdp_ct_lookup(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
 	caller_net = dev_net(ctx->rxq->dev);
 	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, tuple__sz, opts, opts__sz);
 	if (IS_ERR(nfct)) {
-		if (opts)
-			opts->error = PTR_ERR(nfct);
+		opts->error = PTR_ERR(nfct);
 		return NULL;
 	}
 	return nfct;
@@ -367,8 +363,7 @@ bpf_skb_ct_alloc(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
 	net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
 	nfct = __bpf_nf_ct_alloc_entry(net, bpf_tuple, tuple__sz, opts, opts__sz, 10);
 	if (IS_ERR(nfct)) {
-		if (opts)
-			opts->error = PTR_ERR(nfct);
+		opts->error = PTR_ERR(nfct);
 		return NULL;
 	}
 
@@ -402,8 +397,7 @@ bpf_skb_ct_lookup(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
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



