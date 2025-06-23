Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F234C2F24;
	Mon, 23 Jun 2025 13:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684828; cv=none; b=iLP6Zoo6qg4GCzi/b8z9B5+CZTJucw6JLzLylZ+E3fr5QU2nKpkP9boUvb+tvFw7pGvI8p/6P77HLuGzEXHjy2saIPakrKUD45UarWl9ZOJ+2ljixN27+Ra+1aLLEQd9FKTwJN8PXLfB+wSlajMAl3HQLZVStcGb3aQxZ23r2F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684828; c=relaxed/simple;
	bh=KE17pWozH5UtL2SAPuJz7E6I2h+H1O1E59GVBPgIaQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkDIrM8NJcTeO0DJY7IFTaqw3Cm8mArZ0x8QXOhBdPqsKazRNliW305KqB+MuEiy3s+A5pAUchS+IYMAKPJ363huZXz/y/uTVNf4KTN/Y49+TyO0rZURurDnGbR5CFIkJMyKyxl+ZhaeaKgS89D4daur1y0ar76jxOU0OGmaTiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t36A8vAX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t36A8vAX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E5DC4CEEA;
	Mon, 23 Jun 2025 13:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684827;
	bh=KE17pWozH5UtL2SAPuJz7E6I2h+H1O1E59GVBPgIaQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t36A8vAXuTlLgMpkZhBp4VkjhmTjl9NCSmDkjjLLna6UJyoGqtU+2K8XSQwk5kZvQ
	 RUN1NYJ/qQjHKPQdejm7BHFvOqvS54z5gU86U6SXLGzFg2VkaoTSvJpyrVrkLS8mwD
	 A1S8+eYMYZaP9bHntUyEFtog7WjPcs4Gf9xlaw/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 036/222] netfilter: nf_tables: nft_fib_ipv6: fix VRF ipv4/ipv6 result discrepancy
Date: Mon, 23 Jun 2025 15:06:11 +0200
Message-ID: <20250623130612.984583073@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 8b53f46eb430fe5b42d485873b85331d2de2c469 ]

With a VRF, ipv4 and ipv6 FIB expression behave differently.

   fib daddr . iif oif

Will return the input interface name for ipv4, but the real device
for ipv6.  Example:

If VRF device name is tvrf and real (incoming) device is veth0.
First round is ok, both ipv4 and ipv6 will yield 'veth0'.

But in the second round (incoming device will be set to "tvrf"), ipv4
will yield "tvrf" whereas ipv6 returns "veth0" for the second round too.

This makes ipv6 behave like ipv4.

A followup patch will add a test case for this, without this change
it will fail with:
  get element inet t fibif6iif { tvrf . dead:1::99 . tvrf }
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  FAIL: did not find tvrf . dead:1::99 . tvrf in fibif6iif

Alternatively we could either not do anything at all or change
ipv4 to also return the lower/real device, however, nft (userspace)
doc says "iif: if fib lookup provides a route then check its output
interface is identical to the packets input interface." which is what
the nft fib ipv4 behaviour is.

Fixes: f6d0cbcf09c5 ("netfilter: nf_tables: add fib expression")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/netfilter/nft_fib_ipv6.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 03dbd16f9ad53..018f01efeca5a 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -143,6 +143,7 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 {
 	const struct nft_fib *priv = nft_expr_priv(expr);
 	int noff = skb_network_offset(pkt->skb);
+	const struct net_device *found = NULL;
 	const struct net_device *oif = NULL;
 	u32 *dest = &regs->data[priv->dreg];
 	struct ipv6hdr *iph, _iph;
@@ -182,11 +183,15 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	if (rt->rt6i_flags & (RTF_REJECT | RTF_ANYCAST | RTF_LOCAL))
 		goto put_rt_err;
 
-	if (oif && oif != rt->rt6i_idev->dev &&
-	    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) != oif->ifindex)
-		goto put_rt_err;
+	if (!oif) {
+		found = rt->rt6i_idev->dev;
+	} else {
+		if (oif == rt->rt6i_idev->dev ||
+		    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) == oif->ifindex)
+			found = oif;
+	}
 
-	nft_fib_store_result(dest, priv, rt->rt6i_idev->dev);
+	nft_fib_store_result(dest, priv, found);
  put_rt_err:
 	ip6_rt_put(rt);
 }
-- 
2.39.5



