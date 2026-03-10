Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E8E423158;
	Tue, 10 Mar 2026 11:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142179; cv=none; b=dLGTDhGPCdZOxfFW+15xJA0GG4k0Lemi1TMNPvdQnWC7L5u655UpSjKpavculKUp/xDtwr3GWOrya8vRzjZ8HaxPv7H/vz/ZAKMiq2vU/fuA+lSmPgTgy4lgFjUDqiidfKKnbpY04pE4cFcPA/RpG7nI9DrwGVAWRFpBSYhb+Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142179; c=relaxed/simple;
	bh=15AX7ik4RWZl6tkEPWb/etPGqdHiZbLqMJdDI7m/DnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edrjGQ58jI+HYxHEkLjWc21JpZ7tIe+9mfALS1klmSpVbRTig0+OegQnOFKJ23jgw1ZEkVfxjnxsl2biyW/qmoIe3nj9FvHmmsvGEFiKxFamctI5qYHOu+0buqoyj4HP8tigPhMxvvrBMxEcj8ZWoAsQ6MLrK9HM7OYfltliwnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GQtH/hAd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GQtH/hAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBF1C19423;
	Tue, 10 Mar 2026 11:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142179;
	bh=15AX7ik4RWZl6tkEPWb/etPGqdHiZbLqMJdDI7m/DnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQtH/hAdj4cl35ReWwsusahKtz65XY5rWs/tmAJihSQ/VH2Y3R92LtCUAd1BZMEqU
	 ZzyYjApKyS/roNidfQ0GhvFQiJTDUJGrUGwK2oeHOendVLlqFeisLYlR1LgZw5L644
	 DPeXK3PrQNmZN+/tIkD9Q4R534YeKCtn0S1iAdBpPWgZ12oNDON5mm7CnEn7g9rmoE
	 vgcOtmWPBF9dSfBY127+nARkezXlNaT/QBQh3RFJ+LILNKuo175kBjPfjehNmaQnv6
	 VjwaXr+s0XxS1GyVRn9sDogFpJJ37DkV4F451DXQEtfxtPvN9zMaGIvXP5jyeeiQJY
	 y0QnSy9JWjv2A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 268/314] ipv6: fix NULL pointer deref in ip6_rt_get_dev_rcu()
Date: Tue, 10 Mar 2026 07:18:47 -0400
Message-ID: <6e39df68d536f761110db260044bf2592b50fda6.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 2ffb4f5c2ccb2fa1c049dd11899aee7967deef5a ]

l3mdev_master_dev_rcu() can return NULL when the slave device is being
un-slaved from a VRF. All other callers deal with this, but we lost
the fallback to loopback in ip6_rt_pcpu_alloc() -> ip6_rt_get_dev_rcu()
with commit 4832c30d5458 ("net: ipv6: put host and anycast routes on
device with address").

  KASAN: null-ptr-deref in range [0x0000000000000108-0x000000000000010f]
  RIP: 0010:ip6_rt_pcpu_alloc (net/ipv6/route.c:1418)
  Call Trace:
   ip6_pol_route (net/ipv6/route.c:2318)
   fib6_rule_lookup (net/ipv6/fib6_rules.c:115)
   ip6_route_output_flags (net/ipv6/route.c:2607)
   vrf_process_v6_outbound (drivers/net/vrf.c:437)

I was tempted to rework the un-slaving code to clear the flag first
and insert synchronize_rcu() before we remove the upper. But looks like
the explicit fallback to loopback_dev is an established pattern.
And I guess avoiding the synchronize_rcu() is nice, too.

Fixes: 4832c30d5458 ("net: ipv6: put host and anycast routes on device with address")
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20260301194548.927324-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index cd229974b7974..e7d90a28948a4 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1063,7 +1063,8 @@ static struct net_device *ip6_rt_get_dev_rcu(const struct fib6_result *res)
 		 */
 		if (netif_is_l3_slave(dev) &&
 		    !rt6_need_strict(&res->f6i->fib6_dst.addr))
-			dev = l3mdev_master_dev_rcu(dev);
+			dev = l3mdev_master_dev_rcu(dev) ? :
+			      dev_net(dev)->loopback_dev;
 		else if (!netif_is_l3_master(dev))
 			dev = dev_net(dev)->loopback_dev;
 		/* last case is netif_is_l3_master(dev) is true in which
-- 
2.51.0

