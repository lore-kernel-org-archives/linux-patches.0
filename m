Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEAD2D2491;
	Thu, 12 Mar 2026 20:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347153; cv=none; b=ATkwviq/wrOMRGGSvU6CXXMn/76Nicvl6AsRvp2hd/YLBQtX+JokLH2WjhX3fCQG2Kid3130svDN8+QClaxxtVjNRTjOUBKQAV8i+A27MIDbT0jb3Alm02gpoKSHb76ricXufaxGK0TOB0QhBVhynbBAAqI+aSNJgfgBJOaSO3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347153; c=relaxed/simple;
	bh=rR61WDTTHNF7HjDfVfY95g4wc/Wswn7u0c7IzTQA1wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1EoCHUaO2lzSMRqTmYYpkrxFSr7sVVk7jfWLXOgytLUNcE7tgqJ+bAT7zEIoVHHTB5zH/O8DB/XwzioRrySkRVc54To7ojHGQ1Bj7A7F5ge2xFm2W0vDH39nTxu4XBtQvmmCBUlwLKi5GIPgSzKIsCI9ZCwtYwBOAgGa6QNHuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0sAb6BMT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0sAb6BMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F4BC4CEF7;
	Thu, 12 Mar 2026 20:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347152;
	bh=rR61WDTTHNF7HjDfVfY95g4wc/Wswn7u0c7IzTQA1wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0sAb6BMTcGb2JWmofvqBahLwy/lW2lY278Ei8wxjW3hbOWlfC/vIMuXfqyQweqtOf
	 Ci206CF2SH4DW1bBY1NnHG/5VZSwEd+JoPfzadsn+9zSIBOwnOtaAM6Fik9Vf/DbSk
	 DGEewHPzKU8w9zlPJh7ktysMKq8zmtE1zyInPexM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 217/265] ipv6: fix NULL pointer deref in ip6_rt_get_dev_rcu()
Date: Thu, 12 Mar 2026 21:10:04 +0100
Message-ID: <20260312201026.160168000@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index aeac45af3a22a..0f741aa154faf 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1064,7 +1064,8 @@ static struct net_device *ip6_rt_get_dev_rcu(const struct fib6_result *res)
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



