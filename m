Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E27127B69;
	Tue, 14 May 2024 11:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686520; cv=none; b=kwCkoHgtbBRRMGj48SPrkO6i17EJGus2wN35eqKnsTjo/gvpQPoYs2WlXjxB5aERxg/xFpTFvYkM8ODkpjvAKcyVe+rJVPQTI72kstlFXw+qa9wfpuSEUrkP/Nj+OodAAsWfelZs0gVPSGE2ZGknIKLRQqqVjIWb2/9Wl7V0aB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686520; c=relaxed/simple;
	bh=YHQQV+R9UQCh6yUFfN5Nl2EFz3dI6peBcYNcoI0mCcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fznnAQ9o02KwOYk3Y20Xehw+2eq/XC/g5PCFbU6UwoFJiSx02ohXz7tw7s80MtH93wKZT4x9TTy4DSTv2ctw1X4rksc898zgpwWzWRr8GO0+Uusvb0aJ7nRXIKFyKrZdTMWgsY2QW7UJq27FAIhrDtoMar9Dqj6bNYU6fYwDc5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zQkp+7r2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zQkp+7r2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E74C2BD10;
	Tue, 14 May 2024 11:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686520;
	bh=YHQQV+R9UQCh6yUFfN5Nl2EFz3dI6peBcYNcoI0mCcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zQkp+7r2MGfVc1nTS2ECmfjzRXWLDKthjb6cpF7WY7Ch2mLttuaYPvG5zDszzMNu7
	 s+6MsPkF8cdaP/dAHym0Q1S55PiAUrO59EC3B3AhCAcFw0uzM7eup7NN5nfaky6So8
	 9LfzcedRuLhVfWlLn0Smaq0O4cJjSzRvJhVYJrik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Gu <guwen@linux.alibaba.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 166/236] net/smc: fix neighbour and rtable leak in smc_ib_find_route()
Date: Tue, 14 May 2024 12:18:48 +0200
Message-ID: <20240514101026.660840775@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ace8611735321..6de53431629ca 100644
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



