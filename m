Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F9338C2C0;
	Sat, 17 Oct 2026 17:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259228; cv=none; b=F40cUuaUxk5YcIDNo6kG/aUXT9LXJ80x+7+DTX6hNnTSzbS3UvannDfHgcuxidnl+M157vmSBI9bJK2mZdWyRjmlmRwy6jPd7fCjGUW6cJWJZ5qzuxYpBQdzeoFL9UpFudpPAodAjys9aZMZbWU8GJEjNGGJVN0t/h6hyZALI6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259228; c=relaxed/simple;
	bh=R0YGKtcT8up8FpJrpY0D/D39jk47SEFYJNVQgzK7vuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zwe3+6zs1QEDTaUueYRdA3YJvcoANOnEpIVDcv4Mx2ptncE4imKXDwWw9sAFxzEbs4mlA+xUSpgsFu1wqMtIu3XCVyhAEoyiNGa7FK+HohIeWAtq3Scznuz6N7e+0CyMGsMT+NaEDUuMzdfhClnPy7VsuwXw1+z4gqxa796OOi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6gHLDKe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6gHLDKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A381F000C4;
	Sat, 17 Oct 2026 17:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259227;
	bh=x+rgWZe3WwQ26T6LsGrOmGmgDWCsLmM89lVdMgCVMZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T6gHLDKejIIVXlsCdhttCY4omr02I7G06xnGikAX3bTQBwsFikS9g/cu3FtFjymlD
	 CT6r3hD/tqVFrYR3KqeXML/OV0qO2jxJZ817+llcN+/8YxAaftFVs+4PHD92sDJcwS
	 eFFMRfAG/y1ZAK/Bq/e+1qnF5Rn4hhUmK9Td7Ams=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1142/1674] bpf: Guard conntrack opts error writes
Date: Sat, 17 Oct 2026 17:56:54 +0200
Message-ID: <20261017160500.470315448@linuxfoundation.org>
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
index ba990086bbb08..ea74e299bddd1 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -58,6 +58,15 @@ enum {
 	NF_BPF_CT_OPTS_SZ = 12,
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
@@ -261,12 +270,7 @@ bpf_xdp_ct_alloc(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
 
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
@@ -298,11 +302,7 @@ bpf_xdp_ct_lookup(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
 
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
@@ -333,12 +333,7 @@ bpf_skb_ct_alloc(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
 
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
@@ -370,11 +365,7 @@ bpf_skb_ct_lookup(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
 
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



