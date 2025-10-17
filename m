Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F764337110;
	Fri, 17 Oct 2025 15:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714230; cv=none; b=QUkb9UT+r+MU+rvT9xRGdUlNZ9G891wptssNMIVWWGU4cpxsZmgcfl3lEU70uLZD+YSU7cNKfrydXDHpTUtXf3p7tlrHZIV5s/Q/VBcXCC1uCD6T3E9z6B5+oXJu/NGnFymxyznGotJ9oPWItppRGFveoQUmTSL7sy7jeScnTB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714230; c=relaxed/simple;
	bh=kSJt0NmgcD83gljwgoYD8CU3aofV2RpjWvu9wxlMGp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WeDuddrKTf1qdgnoLvL9SFz+P4ljWSDDjVgmKfd5V9q1qpCH88iXg4qiPJ4pd4HzRwSqtsg9hrp+NtmzhT64OVj3L3TklAa/9++s/WW+MfZ8vgtqud1PHDh3hSMex+NDW0NgHy31fWA7NXqq4WsRjVO3N9x7qQy1lgAjqWh2Ykg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mynsShU6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mynsShU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A60DC4CEF9;
	Fri, 17 Oct 2025 15:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714230;
	bh=kSJt0NmgcD83gljwgoYD8CU3aofV2RpjWvu9wxlMGp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mynsShU6tEM0SZsIN8vI8y7yz64PYQ9cTYF1V+zpPDIIdJD5QfQPSDEVS0HLQrBlh
	 nDhz90FB0SfivpnWpe1Cpoh2V+eIY1GKkthbf9ciNDwJ03gvI48vJVvKozYtEJPwR8
	 kfbn+sIXdLcdLlikAlk9Fu+PQ1nz4iGRf7ZVv3pU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georg Pfuetzenreuter <georg.pfuetzenreuter@suse.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/277] netfilter: nft_objref: validate objref and objrefmap expressions
Date: Fri, 17 Oct 2025 16:51:20 +0200
Message-ID: <20251017145149.805747839@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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
index 8ee66a86c3bc7..1a62e384766a7 100644
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
 
@@ -197,6 +227,14 @@ static void nft_objref_map_destroy(const struct nft_ctx *ctx,
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
@@ -206,6 +244,7 @@ static const struct nft_expr_ops nft_objref_map_ops = {
 	.deactivate	= nft_objref_map_deactivate,
 	.destroy	= nft_objref_map_destroy,
 	.dump		= nft_objref_map_dump,
+	.validate	= nft_objref_map_validate,
 	.reduce		= NFT_REDUCE_READONLY,
 };
 
-- 
2.51.0



