Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020911;
	b=nNM2YtWo+E0x+T32vkBbrAdFAaC3zfamqXhp3Vt5JOR/AFv+2WRPWpzV7kpvy2E4sjSZ
	 x+jue0qGrPurlCL1cRIkobaQbkO6nt6TCrA+mNoMXeGBlf48i4nvbveVOxqUfAUKyyDhO
	 8D8C5K39dpzxwfO33aPQihZaPXKpl4DpLiFiYxkTB472sRMUy8OaAw1arb0cqON/eNoV9
	 VXI9Je0y41NWjM5140DCMk6xVsfr9U0bugWv2GhZ8s1RVRYOHC8dbypgExWVHVUiQRae/
	 X/UU1Vm+SlNtmdv9iPduOE3nDvTGx7WH5Tqk1h9Lqb1mBnauQs/v0m3hXPi8Y+R18Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020911;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IN5NNPD8Rn+hoqubWXuh63CBUWKT5phbilu1Wbfc48Y=;
	b=r6Tn0npuB7HczM6tDRoshOu8JLNH+15tUsSQQ9Wf8NYrozzCHcAI//2cziRLfISuZmKV
	 na//oDCdr02pP25CVZ6ijwRAOewFhhp91bjSlpnZCAQ2KpWj7XWlk4Xr9i3njWp6eGXAR
	 BGfefBj2tnVlP4cKDWd9vOIv1AvF4cBtmdiCTBpWqrVq846JP+v7BCoavxVahhqeX5n5U
	 XsKiLvEPI2IiEggnHL34qu+dhHtUjrasB/1qH3Qq1igQeltOJfPC3lidBop1k0R05ybhl
	 Vs7jeZiLxqd8PiTJT84iWSpATZi59PInDwMAY9fkjCVWGrcZSLalnVTVYkBYYYjpTDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="a/ELhAb6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA210606A31C;
	Wed, 18 Nov 2026 16:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a/ELhAb6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1511F000C4;
	Wed, 18 Nov 2026 16:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020911;
	bh=IN5NNPD8Rn+hoqubWXuh63CBUWKT5phbilu1Wbfc48Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/ELhAb6P1FBD2B52dkP4D+tyTYhHDd1NXT6vSSzT+gGn5jem74fsXbt/NEozP1AB
	 n0EH4jBJZwNrQ8thexqzoIA8qa5ISre59gHdt4pAt1lBCY9Rvxmco5DTY5ilaw1T/0
	 OAi1SEd1eAaIhvaDfTnOBVkcjyFLhY4vVvbgSDI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2120/2651] netfilter: nft_compat: restrict raw table targets/matches
Date: Wed, 18 Nov 2026 15:56:00 +0100
Message-ID: <20261118150402.244889227@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit ac364eb4d6d747b15df17e5fc9e442c318afaaac ]

xt targets and matches declaring .table = "raw" (CT, NOTRACK) rely on
only ever running in the legacy raw table's prerouting/output chains,
ahead of conntrack. nft_compat_chain_validate_dependency() already
enforces this kind of correspondence for "nat" by requiring the chain
type to actually be NAT, but did nothing for "raw": a rule wrapping
the CT target could be loaded into any hook and any priority via
nft_compat, including after the real conntrack hook has already run.

The CT target attaches a conntrack template to the skb when none is
set yet.

Require that a "raw" table dependency actually matches what xtables
enforces via the implict/builtin table dependency.

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Assisted-by: LLM
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_compat.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 63864b9282590..88ddaf47f5879 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -14,6 +14,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/nf_tables_compat.h>
 #include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
@@ -45,6 +46,20 @@ static int nft_compat_chain_validate_dependency(const struct nft_ctx *ctx,
 			type = NFT_CHAIN_T_NAT;
 		if (basechain->type->type != type)
 			return -EINVAL;
+	} else if (strcmp(tablename, "raw") == 0) {
+		/* iptables-nft emulates the legacy raw table, which only
+		 * ever has prerouting/output chains at this exact priority.
+		 */
+		if (ctx->family != NFPROTO_IPV4 &&
+		    ctx->family != NFPROTO_IPV6)
+			return -EINVAL;
+
+		if (basechain->ops.hooknum != NF_INET_PRE_ROUTING &&
+		    basechain->ops.hooknum != NF_INET_LOCAL_OUT)
+			return -EINVAL;
+
+		if (basechain->ops.priority != NF_IP_PRI_RAW)
+			return -EINVAL;
 	}
 
 	return 0;
-- 
2.53.0



