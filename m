Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497474E5321;
	Fri,  9 Oct 2026 14:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555627; cv=none; b=DPYazytUjmdMgr8/IL6EpeZJs94DiOUWAf4NwgHo1bPZMTcJ965rm+Wzc2UXEb9QsV45AeN68pxWNTOBYEsr9+W9ISVo6UVsaT01tWpGEJ7IkF1cdSEf5prYE/xrN19ROBd4KP8Gzfci5e9OgJXYW7TsSxKtcwkj10taKYYoBDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555627; c=relaxed/simple;
	bh=ECwysZ4HCn7ZF3XV4/MrXXHuoNgorOG9mJ4mNYZvklA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TSuzIZfDZMIjhg6RjxJIA3PQ5UrXkdHYHyK5slWFxWOTOiZZ29UBz4FPyhCiNRW/Z28XO3CYCvCrjb8jrmwDcft6qwkFj9PCXJTREdgT+0e3ZSpkEv/sL+p3s8dDOId+C10CPxutHBPQJB8dSjiRWpk8e3fHgiPoB8mwMzlzScE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4LF6XrB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4LF6XrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA7B1F00893;
	Fri,  9 Oct 2026 14:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555620;
	bh=SZcUhno50gT4lg99JTlxhRvHHW6MX7VDbTgEdu+2Zao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a4LF6XrBoLFjPjwAmYdDy/7mPnaYxQdXKxLEJvGwl4xDZzAHWL5fC6ipD+QZCX+il
	 k3e6Itkeeb4sUt6pqDiwqO229mrqkQ+2q+HcvFyt52KOrDoCt4tanPYIJN+nZW7rTY
	 fRcXxFSvCjv0Pvqg/rmmnS+vTCShV1dV5owXFe/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Aohan Mei <henrymei@tencent.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7.2 038/428] netfilter: nft_flow_offload: drop flowtable reference on init error path
Date: Fri,  9 Oct 2026 16:06:15 +0200
Message-ID: <20261009140946.929433979@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aohan Mei <henrymei@tencent.com>

commit 747928b5d4ff8c8de55138a54c13980e4bb88578 upstream.

nft_flow_offload_init() bumps the flowtable use count with
nft_use_inc() before calling nf_ct_netns_get().  When the latter
fails, the error is returned as-is and the reference is leaked.

The upper layers do not balance it either: nf_tables_newexpr()
clears expr->ops when the expression init callback fails, so the
nft_expr_more() iteration in nft_rule_expr_deactivate() and
nf_tables_rule_destroy() stops right before the failed expression
and its ->destroy callback, which would drop the reference, never
runs.

Each failed rule addition therefore leaks one flowtable reference
and the flowtable can no longer be removed: NFT_MSG_DELFLOWTABLE
keeps reporting -EBUSY even though no rule references it.

Save the nf_ct_netns_get() return value and undo the nft_use_inc()
when it fails, restoring the inc/dec pairing within
nft_flow_offload_init() itself.

Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Cc: stable@vger.kernel.org
Assisted-by: CodeBuddy:Kimi-K3
Signed-off-by: Aohan Mei <henrymei@tencent.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_flow_offload.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -160,6 +160,7 @@ static int nft_flow_offload_init(const s
 	struct nft_flow_offload *priv = nft_expr_priv(expr);
 	u8 genmask = nft_genmask_next(ctx->net);
 	struct nft_flowtable *flowtable;
+	int err;
 
 	if (!tb[NFTA_FLOW_TABLE_NAME])
 		return -EINVAL;
@@ -174,7 +175,11 @@ static int nft_flow_offload_init(const s
 
 	priv->flowtable = flowtable;
 
-	return nf_ct_netns_get(ctx->net, ctx->family);
+	err = nf_ct_netns_get(ctx->net, ctx->family);
+	if (err < 0)
+		nft_use_dec(&flowtable->use);
+
+	return err;
 }
 
 static void nft_flow_offload_deactivate(const struct nft_ctx *ctx,


