Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC542C026C;
	Sat, 17 Oct 2026 16:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254449; cv=none; b=K4GK0nsESXwmMHDEUis0kQDgkGFOHFE7yTq7MVF6tDGiZJP6guke5mX6SU6QUXl//veOBZHXT9zuMYAaquYuezhjpgo6qpCQcJ2UaczujzoCqP0ZWqwuFLk0r8Rmu0NZON0Q0EzLYg0hLNrGK8TSzsgrQTTcSDqhimt7zi+Cih0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254449; c=relaxed/simple;
	bh=9AC3yclndo2xGvye1GZSlu1PRvYmJH/SPc4KUlnLSG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9mJ2qbcHDbA+oZxF9JnXlEez7mqKqvA+E/7bSGX/PX1xet+4MbmplxzsTwvzIPC089pC/DDpsFILhRNLGJ9rNuz/98OkbR0lCkff+4nSwknkhyzx+GjFghyDjWenXugkGWfw/JGRg2V3TQS5+S2oSU4601pV4sSNkkMt0ZOWq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6hGdI1z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6hGdI1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980F11F000C4;
	Sat, 17 Oct 2026 16:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254448;
	bh=fPvEsao4nDYTZ2SFQcHVoj6e5LNKWShiETPK4zscEoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K6hGdI1zRDLzemag1Ibfj8aKpfvytwPWArLAS3kS9CHcjRw5Yw6D3pM4H4ROit8fy
	 Bfm4vD007P9JjVVC859fQ5+dWboeWKURijs9mWjaGPfD5n236j4nqfWdToiav6xW+F
	 13j/NlJLfa6IP4PErBOQfcjeo2Msv4UMhZhHczGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 450/869] bpf: Guard conntrack opts error writes
Date: Sat, 17 Oct 2026 17:54:51 +0200
Message-ID: <20261017160048.679932719@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4a136fc3a9c0f..c91a935a01706 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -64,6 +64,15 @@ enum {
 	NF_BPF_CT_OPTS_SZ = 16,
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
@@ -298,13 +307,7 @@ bpf_xdp_ct_alloc(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
 
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
@@ -333,12 +336,7 @@ bpf_xdp_ct_lookup(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
 
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
@@ -366,13 +364,7 @@ bpf_skb_ct_alloc(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
 
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
@@ -401,12 +393,7 @@ bpf_skb_ct_lookup(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
 
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



