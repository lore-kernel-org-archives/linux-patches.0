Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB271E8332;
	Tue, 17 Jun 2025 15:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175032; cv=none; b=RcaUq2T5D9AjHcUM1iA5czRubLTM2NRBhaEmM3T4kRY67Ko6kGYes9C78oQ2T1hSXoGZRvlFi1o0LjE2z0a6z9QEv/Flyizhm1oGf8HPFZ4sGZ4TF51cEmkN49Jn/cJRakB+3O7Ympd1rz2+C/k+RzKDMmX0lVYK1BuAAQ/kHs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175032; c=relaxed/simple;
	bh=pfkShT3ThsytSz7s0SmFqJw2jTpq63wtSpxLz+sP+Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GDzSuhXHITcHNvdj0Z+ZJv7sP1ETl8hXIAD0jMv2Iv/81iIuc+w76WNn4iv0i3UmPc9rudgjdJxgBQPGryB/2tNU0Uf5/UlfclH88HmlF0AOpqgpMDTp8KWZoHFSBnHa2WDjS0fXlxf+288VfSCRXfh5981xnRLb2fVhwagjeOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=po44tDIL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="po44tDIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D824C4CEF0;
	Tue, 17 Jun 2025 15:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175032;
	bh=pfkShT3ThsytSz7s0SmFqJw2jTpq63wtSpxLz+sP+Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=po44tDILEjgRYK6wjQEXpzBkq8hEBPAu1WcEqVJR2h4eW98MoGQHW7DRZcvhfxS/0
	 U12P+GvXDVz/lsK7ZcqNmOrc8d5LRGqduwyUBM4ipo1+GdyyN9zjutEj+hSDyumrXi
	 NcWK/MPsSWAwbM0kY7RRWO4JZwYVAC+K7Nva3PHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 137/356] netfilter: nf_tables: nft_fib_ipv6: fix VRF ipv4/ipv6 result discrepancy
Date: Tue, 17 Jun 2025 17:24:12 +0200
Message-ID: <20250617152343.746344644@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c9f1634b3838a..a89ce0fbfe4b1 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -158,6 +158,7 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 {
 	const struct nft_fib *priv = nft_expr_priv(expr);
 	int noff = skb_network_offset(pkt->skb);
+	const struct net_device *found = NULL;
 	const struct net_device *oif = NULL;
 	u32 *dest = &regs->data[priv->dreg];
 	struct ipv6hdr *iph, _iph;
@@ -202,11 +203,15 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
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



