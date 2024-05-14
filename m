Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793482943F;
	Tue, 14 May 2024 11:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685723; cv=none; b=lBsDdlMlJp/3sp3QculiFvYD+9LcK1ZmI7XQ8lm+ea2TKiVX+RpNLxv8A0quiTl1wzfbM/87KQd/vffXyhBRt8kLV8UbG/jgj2y8o1O8sXq8InGc37bQs9ac0FBn4XEBSTADmO/sf/zbpgjBh8XYpTjOTQwAApKJoSsx+64DWAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685723; c=relaxed/simple;
	bh=0AsmcKHxPlQKh3yx5jom0vPeMT12dxLtXG3gfkTAXyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gApfzA0ZTb+z8Ve9NdEKiMfce3/tNQjoiNt428QPq7aEIWi7u1h4UEZxQ3CaKSle+BqPI3UfvMYosKRu4nmBLT/w6gt8NJ+RawH++4Z3qyeWkcPZzB+h4VKnyceyiOmi8l043zZS4qUUCjFlK40XHaqTHxYU8lcIVAHjsmv/8tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00AY8bjt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00AY8bjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CDEC2BD10;
	Tue, 14 May 2024 11:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685723;
	bh=0AsmcKHxPlQKh3yx5jom0vPeMT12dxLtXG3gfkTAXyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=00AY8bjtJHF+L7YnsVqyhIK1DvF8XhvIPklpKWmj3D19FvDtIMFHOHjabxlrG4FaU
	 1Pb8g++cfuMdkZq+T3fPyKRrpfprDCsGOEKaXLTPwMoQhSpJsNivGGYl7w19VfrHKO
	 klb9bM3lq8TmCZeNs7IbeJWx63DgVo21gXuOPfOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Gu <guwen@linux.alibaba.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 203/301] net/smc: fix neighbour and rtable leak in smc_ib_find_route()
Date: Tue, 14 May 2024 12:17:54 +0200
Message-ID: <20240514101039.924598825@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wen Gu <guwen@linux.alibaba.com>

[ Upstream commit 2ddc0dd7fec86ee53b8928a5cca5fbddd4fc7c06 ]

In smc_ib_find_route(), the neighbour found by neigh_lookup() and rtable
resolved by ip_route_output_flow() are not released or put before return.
It may cause the refcount leak, so fix it.

Link: https://lore.kernel.org/r/20240506015439.108739-1-guwen@linux.alibaba.com
Fixes: e5c4744cfb59 ("net/smc: add SMC-Rv2 connection establishment")
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Link: https://lore.kernel.org/r/20240507125331.2808-1-guwen@linux.alibaba.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_ib.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 89981dbe46c94..598ac9ead64b7 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -209,13 +209,18 @@ int smc_ib_find_route(struct net *net, __be32 saddr, __be32 daddr,
 	if (IS_ERR(rt))
 		goto out;
 	if (rt->rt_uses_gateway && rt->rt_gw_family != AF_INET)
-		goto out;
-	neigh = rt->dst.ops->neigh_lookup(&rt->dst, NULL, &fl4.daddr);
-	if (neigh) {
-		memcpy(nexthop_mac, neigh->ha, ETH_ALEN);
-		*uses_gateway = rt->rt_uses_gateway;
-		return 0;
-	}
+		goto out_rt;
+	neigh = dst_neigh_lookup(&rt->dst, &fl4.daddr);
+	if (!neigh)
+		goto out_rt;
+	memcpy(nexthop_mac, neigh->ha, ETH_ALEN);
+	*uses_gateway = rt->rt_uses_gateway;
+	neigh_release(neigh);
+	ip_rt_put(rt);
+	return 0;
+
+out_rt:
+	ip_rt_put(rt);
 out:
 	return -ENOENT;
 }
-- 
2.43.0



