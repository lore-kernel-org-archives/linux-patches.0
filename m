Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B240252903;
	Mon, 23 Jun 2025 13:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685931; cv=none; b=T+EhtoOQnvSAB+0T8oDZlPthWwhR/HXQDRxl6UKKyBBa+iMEaULfVCmJJ+8qQuqzX4M+4amGPHB1g/z585pxCQ/aXMyBtaEN/QPgsGTjOogssli7f0roWmjpiSmdihK8dcW+1ULwcf6U3orKQYZpazQP64C84hGr4jDAFfLimDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685931; c=relaxed/simple;
	bh=81C2I2CwLzEJ246D01X2IjUl1jXtEtr3i6WS1dmVFSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sm8gNv8PSIt/GLuZFGBYQtCV4HljEBGl+dl4OEWifWg/KwryoQw0E4FjAEz9Qy0gV+nWXQPcUCQa7z+q25M1BCV9wyfu1NZb8YhvbhXW//P/1E7OS514u9pPm8FYWnss3KDrul69/x+gboOc+GgxpdQjuRQcVU4IPM0ZZp4dJUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vPu0w52i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vPu0w52i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953DEC4CEEA;
	Mon, 23 Jun 2025 13:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685930;
	bh=81C2I2CwLzEJ246D01X2IjUl1jXtEtr3i6WS1dmVFSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vPu0w52iqHl+CWn6Qx0IKQIGxDwyJzvhE2x2BAbfGBZRdLryXx6YSUu7LcDHBvTKi
	 hE62DpQuEFf9TekGr3HFqY5P2DqpMaKVDx8niQp7gOO6i3M7cFoHxUADa89fqRtHGy
	 9nhjamDjd9GJGsdFZ+xylZxTFkn46qta3KxYXT6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/411] netfilter: nf_tables: nft_fib_ipv6: fix VRF ipv4/ipv6 result discrepancy
Date: Mon, 23 Jun 2025 15:03:27 +0200
Message-ID: <20250623130634.880682124@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1a08b00aa3213..b7e543d4d57be 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -154,6 +154,7 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 {
 	const struct nft_fib *priv = nft_expr_priv(expr);
 	int noff = skb_network_offset(pkt->skb);
+	const struct net_device *found = NULL;
 	const struct net_device *oif = NULL;
 	u32 *dest = &regs->data[priv->dreg];
 	struct ipv6hdr *iph, _iph;
@@ -198,11 +199,15 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
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



