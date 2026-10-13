Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B334FE2F5;
	Tue, 13 Oct 2026 12:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893632; cv=none; b=NGv+s1H6wsHYeP3sJYEnPGj593fQnm5cHTFOfBANaFnW/gUZ9gMmQlfBTMksS9S7rLqb5iH8kiEvvPJTZ5isp4qjYuJoyy2wAmdBke11lHgplvNN9Sc9vM09JenkupUb7MkBjOkdBo+6t3hJqGnwcLMGWar5gwm03jav+Xpj9XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893632; c=relaxed/simple;
	bh=7Wa2atA4nKBRzHb8MOR/1F6/GmFJ9sjuiy61cBYQybs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kq8wuiSOAcSPPh9YzlymWGhlp0AOaSOhT8MLoHCzDkEUcGaNkXG/TiwAPxH9PhLDC1ch2c9bSbnoChAF9t8E4RdFFyn3quADZOjJ7YG2T66MG63hZEOQibZW0Ho6tO2W8hMIHfcug4PyVrynbe9Na+ls6h3GTRokPnlgPqXB240=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QnYXChOa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QnYXChOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCEF1F000FF;
	Tue, 13 Oct 2026 12:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893630;
	bh=fq2n4emiwjYujx0xzTzgFjHgKBUIc3CmfbsJ1FM6yNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QnYXChOaMXTObWdo6f+Lwl+DgFa+s6ihx2gZEOFck9Vx1LbFqDfXRKNXWrqDzsVhn
	 t54+wmwtX3cy8phtjAiw7WtGwS2Z3MWdGrFK7vWaIcZ+iUSIa6FgjOEShku8tJROJY
	 oDTdWS2dDlpl2MEOsfElAShiVegsTD55AvVDn81Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 288/621] bpf: Guard conntrack opts error writes
Date: Tue, 13 Oct 2026 13:34:43 +0200
Message-ID: <20261013112927.695126209@linuxfoundation.org>
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
 net/netfilter/nf_conntrack_bpf.c | 35 ++++++++++++--------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index dc5d02c6e832d..16c3729485376 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -64,6 +64,15 @@ enum {
 	NF_BPF_CT_OPTS_SZ = 16,
 };
 
+static void *bpf_ct_opts_result(struct bpf_ct_opts *opts, u32 opts__sz, void *ret)
+{
+	if (!IS_ERR(ret))
+		return ret;
+	if (opts__sz >= offsetofend(struct bpf_ct_opts, error))
+		opts->error = PTR_ERR(ret);
+	return NULL;
+}
+
 static int bpf_nf_ct_tuple_parse(struct bpf_sock_tuple *bpf_tuple,
 				 u32 tuple_len, u8 protonum, u8 dir,
 				 struct nf_conntrack_tuple *tuple)
@@ -296,12 +305,7 @@ bpf_xdp_ct_alloc(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
 
 	nfct = __bpf_nf_ct_alloc_entry(dev_net(ctx->rxq->dev), bpf_tuple, tuple__sz,
 				       opts, opts__sz, 10);
-	if (IS_ERR(nfct)) {
-		opts->error = PTR_ERR(nfct);
-		return NULL;
-	}
-
-	return (struct nf_conn___init *)nfct;
+	return (struct nf_conn___init *)bpf_ct_opts_result(opts, opts__sz, nfct);
 }
 
 /* bpf_xdp_ct_lookup - Lookup CT entry for the given tuple, and acquire a
@@ -330,11 +334,7 @@ bpf_xdp_ct_lookup(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
 
 	caller_net = dev_net(ctx->rxq->dev);
 	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, tuple__sz, opts, opts__sz);
-	if (IS_ERR(nfct)) {
-		opts->error = PTR_ERR(nfct);
-		return NULL;
-	}
-	return nfct;
+	return bpf_ct_opts_result(opts, opts__sz, nfct);
 }
 
 /* bpf_skb_ct_alloc - Allocate a new CT entry
@@ -362,12 +362,7 @@ bpf_skb_ct_alloc(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
 
 	net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
 	nfct = __bpf_nf_ct_alloc_entry(net, bpf_tuple, tuple__sz, opts, opts__sz, 10);
-	if (IS_ERR(nfct)) {
-		opts->error = PTR_ERR(nfct);
-		return NULL;
-	}
-
-	return (struct nf_conn___init *)nfct;
+	return (struct nf_conn___init *)bpf_ct_opts_result(opts, opts__sz, nfct);
 }
 
 /* bpf_skb_ct_lookup - Lookup CT entry for the given tuple, and acquire a
@@ -396,11 +391,7 @@ bpf_skb_ct_lookup(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
 
 	caller_net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
 	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, tuple__sz, opts, opts__sz);
-	if (IS_ERR(nfct)) {
-		opts->error = PTR_ERR(nfct);
-		return NULL;
-	}
-	return nfct;
+	return bpf_ct_opts_result(opts, opts__sz, nfct);
 }
 
 /* bpf_ct_insert_entry - Add the provided entry into a CT map
-- 
2.53.0



