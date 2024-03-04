Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D977A70D;
	Mon,  4 Mar 2024 21:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588003; cv=none; b=JWYnghAyX5+xmKV53y7bafKRjdwKFeeh5vb2RpRB4yqGQ61qAaaGIKgIj7tGm3D+nv7rGZ9aazstRuOUg5MzkCvep6he/397ycJ2hMsrSrtecBATApyRU2TZhP9Sh7iFcDEQpUY5DzqI3qhmWvVTzm97Lm8L2b2M7peKBxfacNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588003; c=relaxed/simple;
	bh=4QrQWM5PCKXe4JHN379qQ2Ne6GltjuyEMK+HLEG1brw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVxkhh769W0W6OhvWLGRK1XTvaJOGONYGlxO9c3zx0pfsiz8PHFqN9HI9pfIvSQEk40yOmBJpda3lurYpcHOaWnzUXUvsBMa3lW/rKqeUG4RM/RlCOd1c/txY8y9FvysIurLZVHgWvOeIQu6m2Q1S+gbpjOdsn+v8jfhny/MBAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bowEzUZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bowEzUZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB93C433F1;
	Mon,  4 Mar 2024 21:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588003;
	bh=4QrQWM5PCKXe4JHN379qQ2Ne6GltjuyEMK+HLEG1brw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bowEzUZcMIAQ8AwKRJQ7PNUlgqacmwD16IYAECmnD37MEUFlQxyj4LFticS9I6C54
	 jnjYt52it+hi/vBnqDQEv8JzNu69skFZStrtSjjpKXYx6jLBHaC8rynh04/+TDR3xM
	 NNMYI0PrU6fz4FpHMiLDO4yAK5yGptUuherhbtZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Griege <jgriege@cloudflare.com>,
	Ignat Korchagin <ignat@cloudflare.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/25] netfilter: nf_tables: allow NFPROTO_INET in nft_(match/target)_validate()
Date: Mon,  4 Mar 2024 21:23:46 +0000
Message-ID: <20240304211536.087212391@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211535.741936181@linuxfoundation.org>
References: <20240304211535.741936181@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 2372f0bbb133d..fdce5012a4f3c 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -336,10 +336,20 @@ static int nft_target_validate(const struct nft_ctx *ctx,
 
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
@@ -584,10 +594,20 @@ static int nft_match_validate(const struct nft_ctx *ctx,
 
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



