Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DB31C6AB;
	Mon,  4 Mar 2024 21:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589267; cv=none; b=u8LmAwjzwQGpY2HmfuohkSFLyWayqyvzckwHhiTpIItjMrs9hE7axPm4OXwXV8iVBhlu98ZJHlKPKRSCeSaVDP+gqDMxbMIi6YKgF372sA/i32su55q/lJ2S/CGzrJO5V9HL5eWtuG/5SaQFrQScsT4C76Z9Xns+j/CcpOhMWlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589267; c=relaxed/simple;
	bh=E7qrYiv44a5T1ulPLIm9XZiLcVJkf2fg+OPrxoIOFSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kv0MN7X6bii3Bka1eKaTY8265qIrI6budFBKn0ka2OGNOAY+BBl4AQR+RFejTLZy8YSJf2AEKkLosu00ZpySfjgSopea+SRnE8i7N+l4NhJ5B+JtuPvIg/9tWeeo2WfR4qXK9O/ziQn7o+xDXw56kouenBqx8Nf4RjEMUIpZdNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AquDrmaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AquDrmaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61B2C433F1;
	Mon,  4 Mar 2024 21:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589267;
	bh=E7qrYiv44a5T1ulPLIm9XZiLcVJkf2fg+OPrxoIOFSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AquDrmazARDjOj2tCbj+BmWmUoXUbHNK5Qt/jdToAH3SPgWoc2JB0hlExwegAiR15
	 tdI6sB33xA5aDdqL7+NnYkPtg1lj3Getl8KmuyJ1O6mBQWq4/PG+YJ3A7ku0vcgHnV
	 2Nh0Uhr824TTaDd0NS422zruzh6IuMT+xWdA7gXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Griege <jgriege@cloudflare.com>,
	Ignat Korchagin <ignat@cloudflare.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 19/84] netfilter: nf_tables: allow NFPROTO_INET in nft_(match/target)_validate()
Date: Mon,  4 Mar 2024 21:23:52 +0000
Message-ID: <20240304211542.970334452@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ignat Korchagin <ignat@cloudflare.com>

[ Upstream commit 7e0f122c65912740327e4c54472acaa5f85868cb ]

Commit d0009effa886 ("netfilter: nf_tables: validate NFPROTO_* family") added
some validation of NFPROTO_* families in the nft_compat module, but it broke
the ability to use legacy iptables modules in dual-stack nftables.

While with legacy iptables one had to independently manage IPv4 and IPv6
tables, with nftables it is possible to have dual-stack tables sharing the
rules. Moreover, it was possible to use rules based on legacy iptables
match/target modules in dual-stack nftables.

As an example, the program from [2] creates an INET dual-stack family table
using an xt_bpf based rule, which looks like the following (the actual output
was generated with a patched nft tool as the current nft tool does not parse
dual stack tables with legacy match rules, so consider it for illustrative
purposes only):

table inet testfw {
  chain input {
    type filter hook prerouting priority filter; policy accept;
    bytecode counter packets 0 bytes 0 accept
  }
}

After d0009effa886 ("netfilter: nf_tables: validate NFPROTO_* family") we get
EOPNOTSUPP for the above program.

Fix this by allowing NFPROTO_INET for nft_(match/target)_validate(), but also
restrict the functions to classic iptables hooks.

Changes in v3:
  * clarify that upstream nft will not display such configuration properly and
    that the output was generated with a patched nft tool
  * remove example program from commit description and link to it instead
  * no code changes otherwise

Changes in v2:
  * restrict nft_(match/target)_validate() to classic iptables hooks
  * rewrite example program to use unmodified libnftnl

Fixes: d0009effa886 ("netfilter: nf_tables: validate NFPROTO_* family")
Link: https://lore.kernel.org/all/Zc1PfoWN38UuFJRI@calendula/T/#mc947262582c90fec044c7a3398cc92fac7afea72 [1]
Link: https://lore.kernel.org/all/20240220145509.53357-1-ignat@cloudflare.com/ [2]
Reported-by: Jordan Griege <jgriege@cloudflare.com>
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_compat.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 64a2a5f195896..aee046e00bfaf 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -358,10 +358,20 @@ static int nft_target_validate(const struct nft_ctx *ctx,
 
 	if (ctx->family != NFPROTO_IPV4 &&
 	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_INET &&
 	    ctx->family != NFPROTO_BRIDGE &&
 	    ctx->family != NFPROTO_ARP)
 		return -EOPNOTSUPP;
 
+	ret = nft_chain_validate_hooks(ctx->chain,
+				       (1 << NF_INET_PRE_ROUTING) |
+				       (1 << NF_INET_LOCAL_IN) |
+				       (1 << NF_INET_FORWARD) |
+				       (1 << NF_INET_LOCAL_OUT) |
+				       (1 << NF_INET_POST_ROUTING));
+	if (ret)
+		return ret;
+
 	if (nft_is_base_chain(ctx->chain)) {
 		const struct nft_base_chain *basechain =
 						nft_base_chain(ctx->chain);
@@ -607,10 +617,20 @@ static int nft_match_validate(const struct nft_ctx *ctx,
 
 	if (ctx->family != NFPROTO_IPV4 &&
 	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_INET &&
 	    ctx->family != NFPROTO_BRIDGE &&
 	    ctx->family != NFPROTO_ARP)
 		return -EOPNOTSUPP;
 
+	ret = nft_chain_validate_hooks(ctx->chain,
+				       (1 << NF_INET_PRE_ROUTING) |
+				       (1 << NF_INET_LOCAL_IN) |
+				       (1 << NF_INET_FORWARD) |
+				       (1 << NF_INET_LOCAL_OUT) |
+				       (1 << NF_INET_POST_ROUTING));
+	if (ret)
+		return ret;
+
 	if (nft_is_base_chain(ctx->chain)) {
 		const struct nft_base_chain *basechain =
 						nft_base_chain(ctx->chain);
-- 
2.43.0



