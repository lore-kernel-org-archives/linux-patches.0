Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AC83DDDBA;
	Tue, 16 Jun 2026 19:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636822; cv=none; b=n17usMQY+LqLd/7kzFnHbpnZrjMVqR6rjjG1Z3KfxFhPH9uYFsI56GWgPmUEAqT2hvnabe+mi0Sylb8G2gMbQfjMsc+1zRtHA7uCdOaU0bExZNvBNL9iOWa9EL9pvXjSsHWtqty1WD5g/AbWoLWJHtb/N/HNsEoTjO3Z8Hx5Jbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636822; c=relaxed/simple;
	bh=HGJXjwraJC9KMGuv5bFEk6klfgwfZ8M3AEsc54AiCwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgOOPDEZCuGDhfmPgzjkXIA6N7foYSEPA9LBGzEcoTXcwfMI9aro4HwTs1XKUS9f9/XzZ2Ssx6Sl826fw7Nlm/oje3P1i79PXFwpKBXNAfX7uNxSQ/B/Os4pA4hyZU706WWI4hN5dZbJn4IBe+Jgks7qa7+eO7nYqoNmfNLykxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2Lor8PK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2Lor8PK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23BF1F000E9;
	Tue, 16 Jun 2026 19:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636820;
	bh=IZWIFAhi04+PDfiBmGY93iJseu0xgH23C6g19Ql3HMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U2Lor8PKZpA8l0FPjsTdOXtMgA2jYpNSUL0JLgCxtPWIJVX0zl51cijkVexgKcPmT
	 teQOjIxc1qX0WwRaCb61jxbATa0AoxpVkooG6xrgOLUAxIOcvAi5//qqmtszVguG7S
	 ropaRbBlGuux6sewRGx/lMGSr+wjHi4P/3m7lZyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Davide Ornaghi <d.ornaghi97@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 311/342] netfilter: nft_fib: fix stale stack leak via the OIFNAME register
Date: Tue, 16 Jun 2026 20:30:07 +0530
Message-ID: <20260616145102.962575747@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davide Ornaghi <d.ornaghi97@gmail.com>

[ Upstream commit ab185e0c4fb82dfba6fb86f8271e06f931d9c64c ]

For NFT_FIB_RESULT_OIFNAME the destination register is declared with
len = IFNAMSIZ (four 32-bit registers), but on the lookup-fail,
RTN_LOCAL and oif-mismatch paths nft_fib{4,6}_eval() only writes one
register via "*dest = 0". The remaining three registers are left as
whatever was on the stack in nft_do_chain()'s struct nft_regs, and a
downstream expression that loads the register span can leak that
uninitialised kernel stack to userspace.

The NFTA_FIB_F_PRESENT existence check has the same shape: it is only
meaningful for NFT_FIB_RESULT_OIF, yet it was accepted for any result type
while the eval stores a single byte via nft_reg_store8(), leaving the rest
of the declared span stale.

Fix both:

 - replace the bare "*dest = 0" in the eval with nft_fib_store_result(),
   which strscpy_pad()s the whole IFNAMSIZ for OIFNAME (and is already
   used on the other early-return path), and

 - restrict NFTA_FIB_F_PRESENT to NFT_FIB_RESULT_OIF and declare its
   destination as a single u8, so the marked span matches the one byte
   the eval writes.

Fixes: f6d0cbcf09c5 ("netfilter: nf_tables: add fib expression")
Suggested-by: Florian Westphal <fw@strlen.de>
Cc: stable@vger.kernel.org
Signed-off-by: Davide Ornaghi <d.ornaghi97@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[ kept the tree's existing `ip6_route_lookup`/`rt6_info` machinery (missing `fib6_lookup` refactor) and changed only `*dest = 0;` to `nft_fib_store_result(dest, priv, NULL)` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/netfilter/nft_fib_ipv4.c |    2 +-
 net/ipv6/netfilter/nft_fib_ipv6.c |    2 +-
 net/netfilter/nft_fib.c           |    6 ++++++
 3 files changed, 8 insertions(+), 2 deletions(-)

--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -118,7 +118,7 @@ void nft_fib4_eval(const struct nft_expr
 		fl4.saddr = get_saddr(iph->daddr);
 	}
 
-	*dest = 0;
+	nft_fib_store_result(dest, priv, NULL);
 
 	if (fib_lookup(nft_net(pkt), &fl4, &res, FIB_LOOKUP_IGNORE_LINKSTATE))
 		return;
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -189,7 +189,7 @@ void nft_fib6_eval(const struct nft_expr
 		}
 	}
 
-	*dest = 0;
+	nft_fib_store_result(dest, priv, NULL);
 	rt = (void *)ip6_route_lookup(nft_net(pkt), &fl6, pkt->skb,
 				      lookup_flags);
 	if (rt->dst.error)
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -105,6 +105,12 @@ int nft_fib_init(const struct nft_ctx *c
 		return -EINVAL;
 	}
 
+	if (priv->flags & NFTA_FIB_F_PRESENT) {
+		if (priv->result != NFT_FIB_RESULT_OIF)
+			return -EINVAL;
+		len = sizeof(u8);
+	}
+
 	err = nft_parse_register_store(ctx, tb[NFTA_FIB_DREG], &priv->dreg,
 				       NULL, NFT_DATA_VALUE, len);
 	if (err < 0)


