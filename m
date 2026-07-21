Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5314D46D2A1;
	Tue, 21 Jul 2026 19:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661064; cv=none; b=Zyl6MBpyx86N2oqCRXkMa0RYrhYJlp+CYy9/yztfCRcoKUbeP54tCNv3QbSjAptrQJ8gRfN7OBovTX8/+rduWmOeZMzKkuOTS4H64RCELAsYN7G/BW4IyRhWc7uw0Th/ID63nmVgGY7GXCIybP+tXUWEq2/Gm6GF9kFvyamoeic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661064; c=relaxed/simple;
	bh=6WNQXpferA6sHOz0ybD2+YncdVEdfZU3T9fG6+oFDwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=simCVsiP/apk/I6RDRzkT8UEyOoLneNDY0KdGXtplCRhBCgqr85u2e3GvJ5u/ElSL1tcxdV2x6KY6IIkvyfaeaI6PKfS90l0rB7pIchpa+57HxkdJTz5pLIeK5ltplyZLNiKjJf6a29xQzlykViWZBilNOWZmMcHr3tAwP1ePFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EmgROYXx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EmgROYXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF581F000E9;
	Tue, 21 Jul 2026 19:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661063;
	bh=+pB0h77+s8Eg6GbZHrL3D6b//Vc6Iz7d1QJrtpHIruk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EmgROYXx/W4LxB18cvcRoZrBDuMdGwaAb/8bVXgifgyU4YM65P02+FqNOWEXmozoJ
	 e57WxvevK09ceaxkcy0FhhPQhyuTwT5urLIFUKFmsokanhB/RMpTqovkA7FkNRgJnB
	 AbKR/wTilQ9QV8fleqMwHQuyQ7zYnNlL9UEbqT00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1217/2077] bpf: Guard conntrack opts error writes
Date: Tue, 21 Jul 2026 17:14:50 +0200
Message-ID: <20260721152621.520906028@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 40c261cd0af380..f98d1d4b42c3d6 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -65,6 +65,15 @@ enum {
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
@@ -297,12 +306,7 @@ bpf_xdp_ct_alloc(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
 
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
@@ -331,11 +335,7 @@ bpf_xdp_ct_lookup(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
 
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
@@ -363,12 +363,7 @@ bpf_skb_ct_alloc(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
 
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
@@ -397,11 +392,7 @@ bpf_skb_ct_lookup(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
 
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



