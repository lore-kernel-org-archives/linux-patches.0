Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68392F2345;
	Tue, 17 Jun 2025 16:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176116; cv=none; b=ST0yY2WQJ4i0ZldEgUFoV8Pw2rSDL7dhxBohckfSx+nfjb4eBp0WmM00cuu+/44yiIIH4TjRTumnvCPcb0R/DNoIgUnd0E3uUtmdIkrQxmSPq0PgX8w9ONxBKzcKaITfmbPMKKxID4zoGegaj1CqGOSZhVzLGTZpaE0gshVWtdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176116; c=relaxed/simple;
	bh=H2chzB7e+IA0XII5vrWTUtIR9SPQTS9hZNi0afjpC8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzyPK48sld8FdgJDljbO7MQAcUJZhZhPR/NmR4MUjOeFCO6vuwzFC3tf+e/XdCWqQuY1H8IleQ+3hHGHscjP4vkGuT5Gyj2ggeo3jNbpdTpaBs2sQPAR3bzh0242+5u2wWtt4IbvekCHxlhoPzZjNYd7HgGY90Jd+aHli6L0Cww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pqak6zXK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pqak6zXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561EBC4CEE3;
	Tue, 17 Jun 2025 16:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176115;
	bh=H2chzB7e+IA0XII5vrWTUtIR9SPQTS9hZNi0afjpC8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pqak6zXKiVCi40npRcE+qkhb+h+KcE4pWm6HrFoK+vgksxD/7REvpvKAV/g2u5M+o
	 lBQufsdIG6GbXv4r018NT7ek7hi9QJauSzA9Eg7Et0D/P+y42MmuogSVTGRbBwxAtC
	 JovrGcJjaSijmMkvnIw2OdJ+H3QKA+I626zHhsug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 197/512] netfilter: nf_tables: nft_fib: consistent l3mdev handling
Date: Tue, 17 Jun 2025 17:22:43 +0200
Message-ID: <20250617152427.616709187@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 9a119669fb1924cd9658c16da39a5a585e129e50 ]

fib has two modes:
1. Obtain output device according to source or destination address
2. Obtain the type of the address, e.g. local, unicast, multicast.

'fib daddr type' should return 'local' if the address is configured
in this netns or unicast otherwise.

'fib daddr . iif type' should return 'local' if the address is configured
on the input interface or unicast otherwise, i.e. more restrictive.

However, if the interface is part of a VRF, then 'fib daddr type'
returns unicast even if the address is configured on the incoming
interface.

This is broken for both ipv4 and ipv6.

In the ipv4 case, inet_dev_addr_type must only be used if the
'iif' or 'oif' (strict mode) was requested.

Else inet_addr_type_dev_table() needs to be used and the correct
dev argument must be passed as well so the correct fib (vrf) table
is used.

In the ipv6 case, the bug is similar, without strict mode, dev is NULL
so .flowi6_l3mdev will be set to 0.

Add a new 'nft_fib_l3mdev_master_ifindex_rcu()' helper and use that
to init the .l3mdev structure member.

For ipv6, use it from nft_fib6_flowi_init() which gets called from
both the 'type' and the 'route' mode eval functions.

This provides consistent behaviour for all modes for both ipv4 and ipv6:
If strict matching is requested, the input respectively output device
of the netfilter hooks is used.

Otherwise, use skb->dev to obtain the l3mdev ifindex.

Without this, most type checks in updated nft_fib.sh selftest fail:

  FAIL: did not find veth0 . 10.9.9.1 . local in fibtype4
  FAIL: did not find veth0 . dead:1::1 . local in fibtype6
  FAIL: did not find veth0 . dead:9::1 . local in fibtype6
  FAIL: did not find tvrf . 10.0.1.1 . local in fibtype4
  FAIL: did not find tvrf . 10.9.9.1 . local in fibtype4
  FAIL: did not find tvrf . dead:1::1 . local in fibtype6
  FAIL: did not find tvrf . dead:9::1 . local in fibtype6
  FAIL: fib expression address types match (iif in vrf)

(fib errounously returns 'unicast' for all of them, even
 though all of these addresses are local to the vrf).

Fixes: f6d0cbcf09c5 ("netfilter: nf_tables: add fib expression")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nft_fib.h   |  9 +++++++++
 net/ipv4/netfilter/nft_fib_ipv4.c | 11 +++++++++--
 net/ipv6/netfilter/nft_fib_ipv6.c |  4 +---
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nft_fib.h b/include/net/netfilter/nft_fib.h
index 6e202ed5e63f3..7370fba844efc 100644
--- a/include/net/netfilter/nft_fib.h
+++ b/include/net/netfilter/nft_fib.h
@@ -2,6 +2,7 @@
 #ifndef _NFT_FIB_H_
 #define _NFT_FIB_H_
 
+#include <net/l3mdev.h>
 #include <net/netfilter/nf_tables.h>
 
 struct nft_fib {
@@ -39,6 +40,14 @@ static inline bool nft_fib_can_skip(const struct nft_pktinfo *pkt)
 	return nft_fib_is_loopback(pkt->skb, indev);
 }
 
+static inline int nft_fib_l3mdev_master_ifindex_rcu(const struct nft_pktinfo *pkt,
+						    const struct net_device *iif)
+{
+	const struct net_device *dev = iif ? iif : pkt->skb->dev;
+
+	return l3mdev_master_ifindex_rcu(dev);
+}
+
 int nft_fib_dump(struct sk_buff *skb, const struct nft_expr *expr, bool reset);
 int nft_fib_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		 const struct nlattr * const tb[]);
diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index d25d717c121f0..f514eb52b8d4b 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -49,7 +49,12 @@ void nft_fib4_eval_type(const struct nft_expr *expr, struct nft_regs *regs,
 	else
 		addr = iph->saddr;
 
-	*dst = inet_dev_addr_type(nft_net(pkt), dev, addr);
+	if (priv->flags & (NFTA_FIB_F_IIF | NFTA_FIB_F_OIF)) {
+		*dst = inet_dev_addr_type(nft_net(pkt), dev, addr);
+		return;
+	}
+
+	*dst = inet_addr_type_dev_table(nft_net(pkt), pkt->skb->dev, addr);
 }
 EXPORT_SYMBOL_GPL(nft_fib4_eval_type);
 
@@ -64,8 +69,8 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	struct flowi4 fl4 = {
 		.flowi4_scope = RT_SCOPE_UNIVERSE,
 		.flowi4_iif = LOOPBACK_IFINDEX,
+		.flowi4_proto = pkt->tprot,
 		.flowi4_uid = sock_net_uid(nft_net(pkt), NULL),
-		.flowi4_l3mdev = l3mdev_master_ifindex_rcu(nft_in(pkt)),
 	};
 	const struct net_device *oif;
 	const struct net_device *found;
@@ -89,6 +94,8 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	else
 		oif = NULL;
 
+	fl4.flowi4_l3mdev = nft_fib_l3mdev_master_ifindex_rcu(pkt, oif);
+
 	iph = skb_header_pointer(pkt->skb, noff, sizeof(_iph), &_iph);
 	if (!iph) {
 		regs->verdict.code = NFT_BREAK;
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index f1f5640da6728..421036a3605b4 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -50,6 +50,7 @@ static int nft_fib6_flowi_init(struct flowi6 *fl6, const struct nft_fib *priv,
 		fl6->flowi6_mark = pkt->skb->mark;
 
 	fl6->flowlabel = (*(__be32 *)iph) & IPV6_FLOWINFO_MASK;
+	fl6->flowi6_l3mdev = nft_fib_l3mdev_master_ifindex_rcu(pkt, dev);
 
 	return lookup_flags;
 }
@@ -73,8 +74,6 @@ static u32 __nft_fib6_eval_type(const struct nft_fib *priv,
 	else if (priv->flags & NFTA_FIB_F_OIF)
 		dev = nft_out(pkt);
 
-	fl6.flowi6_l3mdev = l3mdev_master_ifindex_rcu(dev);
-
 	nft_fib6_flowi_init(&fl6, priv, pkt, dev, iph);
 
 	if (dev && nf_ipv6_chk_addr(nft_net(pkt), &fl6.daddr, dev, true))
@@ -166,7 +165,6 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		.flowi6_iif = LOOPBACK_IFINDEX,
 		.flowi6_proto = pkt->tprot,
 		.flowi6_uid = sock_net_uid(nft_net(pkt), NULL),
-		.flowi6_l3mdev = l3mdev_master_ifindex_rcu(nft_in(pkt)),
 	};
 	struct rt6_info *rt;
 	int lookup_flags;
-- 
2.39.5



