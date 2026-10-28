Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215517;
	b=GqJOaQ+OWxITeagYh2vShTJi7BTO9JqOP4zeAha6lw+iYOU/yxKNwYz2Y+EgBABe/Wi1
	 /wx2R0I8m+3m1JeqUf/jFkUiLT1/cxPpSTU+cLiBwsHT7Ex7LWsc8hZ+LsFLgQ51w1JRW
	 A7EdaMNx4B5UWg/KrURO6x++8g/avZtvqVhAN8f497XD8s9klZKwVmgR14ieCCVWdUgJC
	 xx61xo+XPLWFl728J3Q4h/hadu70EnfyKy1TknbKv9jGAacsM9MKnEdYIuckaKJfhw0aA
	 xd3Z4h0Lx28i6Kq6QmxtuY/ad9zJJx/oyftuNyGM5Nhq05rz6MYujB+cuiv2XA2fsEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8ziXnO/FMCQVA0m1nDr36Emi9z0r/tyD0R1OMiT5F+o=;
	b=MJAxty8WW+lfSc+X1KNzxXlW0YvSBufBS6Bnk5Lr0xUCDjIA2RN/uTShPiQZQaAdKqMl
	 H2gPJtKRrWKZ9Z9lbCQoPlr9xfPQcotYhi88915lPzTMpTvx6WESPMnGon3MCJUtLjgFe
	 xU7D2U5hH7hrMoTLAlKFBPijXMRsm+0nmg1Y76mFJlID3HAVzGdEPjVzJoMezrTo6pNsZ
	 6wnmCyLJIE1lrEi8wT4mOmmnheRDyuG8bTGnQcGzx+l/p22Q4+rZ0wbasBJgJYCskDQxc
	 a6N+5tXpcJAmcxabxrC5a1lzIpAkcV+5ZcXcgup5BUl7Pkd8t6BcaTyFeC9bhbYemhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FQ+CULNl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA46606A31D;
	Wed, 28 Oct 2026 19:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FQ+CULNl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916FB1F01825;
	Wed, 28 Oct 2026 19:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215517;
	bh=8ziXnO/FMCQVA0m1nDr36Emi9z0r/tyD0R1OMiT5F+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FQ+CULNl0a7rvXAZip/He0bls3Vt1FpC2nPg7KknMrUKxUKNti3rHX4bbkYrTK5Cb
	 nbEpbd3J8c80ep0iiGIXM0bsDa2j4SoVnMClCFBf6l4Od/n2atLlzfo5LSsEFLVJx7
	 TUCF3GchEnU4wkjDidO2SV/b1jL+kFadeG38cFyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1239/1887] bpf: Guard conntrack opts error writes
Date: Wed, 28 Oct 2026 17:55:35 +0100
Message-ID: <20261028170527.618534566@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>

[ Upstream commit 6f6183a39533d727deaa5061cadae6dd9e6744d0 ]

The conntrack lookup and allocation kfuncs take an opts pointer
together with an opts__sz argument. The verifier checks only the memory
range described by opts__sz, but the wrappers unconditionally write
opts->error whenever the internal lookup or allocation helper returns an
error.

For an invalid size smaller than the end of opts->error, that write can
land outside the verifier-checked range. Keep returning NULL for invalid
arguments, but only report the error through opts->error when the
supplied size includes the field.

This preserves error reporting for the supported 12-byte and 16-byte
layouts, and for other invalid sizes that still include opts->error.

Fixes: b4c2b9593a1c ("net/netfilter: Add unstable CT lookup helpers for XDP and TC-BPF")
Fixes: d7e79c97c00c ("net: netfilter: Add kfuncs to allocate and insert CT")
Signed-off-by: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
Link: https://lore.kernel.org/r/9535e781fe14449b1d4e9bbc3baa7566a93bf512.1781765747.git.chenyy23@mails.tsinghua.edu.cn
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_bpf.c | 39 +++++++++++---------------------
 1 file changed, 13 insertions(+), 26 deletions(-)

diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 816283f0aa593..88ab73db654ae 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -57,6 +57,15 @@ enum {
 	NF_BPF_CT_OPTS_SZ = 12,
 };
 
+static void *bpf_ct_opts_result(struct bpf_ct_opts *opts, u32 opts__sz, void *ret)
+{
+	if (!IS_ERR(ret))
+		return ret;
+	if (opts && opts__sz >= offsetofend(struct bpf_ct_opts, error))
+		opts->error = PTR_ERR(ret);
+	return NULL;
+}
+
 static int bpf_nf_ct_tuple_parse(struct bpf_sock_tuple *bpf_tuple,
 				 u32 tuple_len, u8 protonum, u8 dir,
 				 struct nf_conntrack_tuple *tuple)
@@ -261,13 +270,7 @@ bpf_xdp_ct_alloc(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
 
 	nfct = __bpf_nf_ct_alloc_entry(dev_net(ctx->rxq->dev), bpf_tuple, tuple__sz,
 				       opts, opts__sz, 10);
-	if (IS_ERR(nfct)) {
-		if (opts)
-			opts->error = PTR_ERR(nfct);
-		return NULL;
-	}
-
-	return (struct nf_conn___init *)nfct;
+	return (struct nf_conn___init *)bpf_ct_opts_result(opts, opts__sz, nfct);
 }
 
 /* bpf_xdp_ct_lookup - Lookup CT entry for the given tuple, and acquire a
@@ -296,12 +299,7 @@ bpf_xdp_ct_lookup(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
 
 	caller_net = dev_net(ctx->rxq->dev);
 	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, tuple__sz, opts, opts__sz);
-	if (IS_ERR(nfct)) {
-		if (opts)
-			opts->error = PTR_ERR(nfct);
-		return NULL;
-	}
-	return nfct;
+	return bpf_ct_opts_result(opts, opts__sz, nfct);
 }
 
 /* bpf_skb_ct_alloc - Allocate a new CT entry
@@ -329,13 +327,7 @@ bpf_skb_ct_alloc(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
 
 	net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
 	nfct = __bpf_nf_ct_alloc_entry(net, bpf_tuple, tuple__sz, opts, opts__sz, 10);
-	if (IS_ERR(nfct)) {
-		if (opts)
-			opts->error = PTR_ERR(nfct);
-		return NULL;
-	}
-
-	return (struct nf_conn___init *)nfct;
+	return (struct nf_conn___init *)bpf_ct_opts_result(opts, opts__sz, nfct);
 }
 
 /* bpf_skb_ct_lookup - Lookup CT entry for the given tuple, and acquire a
@@ -364,12 +356,7 @@ bpf_skb_ct_lookup(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
 
 	caller_net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
 	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, tuple__sz, opts, opts__sz);
-	if (IS_ERR(nfct)) {
-		if (opts)
-			opts->error = PTR_ERR(nfct);
-		return NULL;
-	}
-	return nfct;
+	return bpf_ct_opts_result(opts, opts__sz, nfct);
 }
 
 /* bpf_ct_insert_entry - Add the provided entry into a CT map
-- 
2.53.0



