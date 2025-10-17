Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8B62F12DC;
	Fri, 17 Oct 2025 15:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713686; cv=none; b=HHc5baJqvvET23t7VHhMEJylf3bew2MkW+frjIM/oyZMSsM6bO79okSUpYnu7pzcPUFdgbOTCUuN/B/SsfKrUhqvHfbG37puSBkf7VAV4Am9wh41z9BkO81YOa/HQ3oEmOrQSSJ+3ctvtC2PARLz4oMVNv1UGpS4tOHJbIYgpes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713686; c=relaxed/simple;
	bh=ffG2V3IA8UoUQiiB3ZJJsfWGNOHOD/V92sAe2ST+eNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLNQgbnKeT0ZeNLF9l9LgBm/u4ktpL1v8XXaVaioqn/yeFOYq8XhIctw+ab08r5uanguN/4tHRmooJqSRvgRYTSKYyU6ObbndsNzYyf3iI/CXJZ22xXHlhGKWGNC7O2xpkn9KYuX6Jz6u7AGXJ2FTfuGPR9bB+j0hfdMSUdsxZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0g7Y7ON; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0g7Y7ON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08732C4CEE7;
	Fri, 17 Oct 2025 15:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713684;
	bh=ffG2V3IA8UoUQiiB3ZJJsfWGNOHOD/V92sAe2ST+eNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0g7Y7ONIrWncl5427b78T+eS0SlSYc33W1e6/8M+Af9S6PUNHx7h1Q8ksceI3fjv
	 MSpaZbFZ5MZD3ElvOyf9/j6JpFDZBzBqVDc6hvKyWYK46BuqtfyXvWMnHjOtqhB/jv
	 HD7KPK9aMSn++lB93fr+jKUlDZbrGSvvYri6Kbn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georg Pfuetzenreuter <georg.pfuetzenreuter@suse.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/201] netfilter: nft_objref: validate objref and objrefmap expressions
Date: Fri, 17 Oct 2025 16:51:51 +0200
Message-ID: <20251017145136.583903050@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit f359b809d54c6e3dd1d039b97e0b68390b0e53e4 ]

Referencing a synproxy stateful object from OUTPUT hook causes kernel
crash due to infinite recursive calls:

BUG: TASK stack guard page was hit at 000000008bda5b8c (stack is 000000003ab1c4a5..00000000494d8b12)
[...]
Call Trace:
 __find_rr_leaf+0x99/0x230
 fib6_table_lookup+0x13b/0x2d0
 ip6_pol_route+0xa4/0x400
 fib6_rule_lookup+0x156/0x240
 ip6_route_output_flags+0xc6/0x150
 __nf_ip6_route+0x23/0x50
 synproxy_send_tcp_ipv6+0x106/0x200
 synproxy_send_client_synack_ipv6+0x1aa/0x1f0
 nft_synproxy_do_eval+0x263/0x310
 nft_do_chain+0x5a8/0x5f0 [nf_tables
 nft_do_chain_inet+0x98/0x110
 nf_hook_slow+0x43/0xc0
 __ip6_local_out+0xf0/0x170
 ip6_local_out+0x17/0x70
 synproxy_send_tcp_ipv6+0x1a2/0x200
 synproxy_send_client_synack_ipv6+0x1aa/0x1f0
[...]

Implement objref and objrefmap expression validate functions.

Currently, only NFT_OBJECT_SYNPROXY object type requires validation.
This will also handle a jump to a chain using a synproxy object from the
OUTPUT hook.

Now when trying to reference a synproxy object in the OUTPUT hook, nft
will produce the following error:

synproxy_crash.nft: Error: Could not process rule: Operation not supported
  synproxy name mysynproxy
  ^^^^^^^^^^^^^^^^^^^^^^^^

Fixes: ee394f96ad75 ("netfilter: nft_synproxy: add synproxy stateful object support")
Reported-by: Georg Pfuetzenreuter <georg.pfuetzenreuter@suse.com>
Closes: https://bugzilla.suse.com/1250237
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_objref.c | 39 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 509011b1ef597..08a27433e2f5f 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -22,6 +22,35 @@ void nft_objref_eval(const struct nft_expr *expr,
 	obj->ops->eval(obj, regs, pkt);
 }
 
+static int nft_objref_validate_obj_type(const struct nft_ctx *ctx, u32 type)
+{
+	unsigned int hooks;
+
+	switch (type) {
+	case NFT_OBJECT_SYNPROXY:
+		if (ctx->family != NFPROTO_IPV4 &&
+		    ctx->family != NFPROTO_IPV6 &&
+		    ctx->family != NFPROTO_INET)
+			return -EOPNOTSUPP;
+
+		hooks = (1 << NF_INET_LOCAL_IN) | (1 << NF_INET_FORWARD);
+
+		return nft_chain_validate_hooks(ctx->chain, hooks);
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int nft_objref_validate(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr)
+{
+	struct nft_object *obj = nft_objref_priv(expr);
+
+	return nft_objref_validate_obj_type(ctx, obj->ops->type->type);
+}
+
 static int nft_objref_init(const struct nft_ctx *ctx,
 			   const struct nft_expr *expr,
 			   const struct nlattr * const tb[])
@@ -93,6 +122,7 @@ static const struct nft_expr_ops nft_objref_ops = {
 	.activate	= nft_objref_activate,
 	.deactivate	= nft_objref_deactivate,
 	.dump		= nft_objref_dump,
+	.validate	= nft_objref_validate,
 	.reduce		= NFT_REDUCE_READONLY,
 };
 
@@ -198,6 +228,14 @@ static void nft_objref_map_destroy(const struct nft_ctx *ctx,
 	nf_tables_destroy_set(ctx, priv->set);
 }
 
+static int nft_objref_map_validate(const struct nft_ctx *ctx,
+				   const struct nft_expr *expr)
+{
+	const struct nft_objref_map *priv = nft_expr_priv(expr);
+
+	return nft_objref_validate_obj_type(ctx, priv->set->objtype);
+}
+
 static const struct nft_expr_ops nft_objref_map_ops = {
 	.type		= &nft_objref_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_objref_map)),
@@ -207,6 +245,7 @@ static const struct nft_expr_ops nft_objref_map_ops = {
 	.deactivate	= nft_objref_map_deactivate,
 	.destroy	= nft_objref_map_destroy,
 	.dump		= nft_objref_map_dump,
+	.validate	= nft_objref_map_validate,
 	.reduce		= NFT_REDUCE_READONLY,
 };
 
-- 
2.51.0



