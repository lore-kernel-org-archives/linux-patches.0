Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACE7389108;
	Tue, 10 Mar 2026 11:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141254; cv=none; b=ZI8GSghzB8Cmgka3oYIUy10g0UBWdqpQlNn874+9Ch3sBIxYbotK5AIOT529dP9ULzAYNkY8/P+URedvdKXtIlW1BCalYs2HAM2i8ZULGcsngUILepmL/tdqz7TKJ82WvwIpw0H3soQRK2vCdxdR9Cm6PRq0/n6sQyW14DInMps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141254; c=relaxed/simple;
	bh=15AX7ik4RWZl6tkEPWb/etPGqdHiZbLqMJdDI7m/DnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L3iE6WIvakJXL1/eLY7uzYTOOMjA4YkUKBzrx2e1z69/DNRSb8I4QadAAxnwJ0YRRAL88inAvG/Qsax6pF3eqIkpZi+FCqpae99lJ/k6XdSY9CT2KzhRPgfgU/IQbIF7HnTpr7LgKJ4T8cSvEjQvPCr2/b43254duU0XZILtB6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A31/J8bc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A31/J8bc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9AEC19423;
	Tue, 10 Mar 2026 11:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141254;
	bh=15AX7ik4RWZl6tkEPWb/etPGqdHiZbLqMJdDI7m/DnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A31/J8bc/5NyzyULm4Bc0oAgO2jo/RI8j3gbvBwMQ9NKIVgGhAb8vf+nbdaQDbBKk
	 nJK6peyDPCHxXJn/1wdJWx9RwqSYUQgGPHKH35BvS7OhtRHXev46V5Zm2RRItJ72zZ
	 gsTMx97AOtI9bB82yidgsF0hFAYz+PNp4Av4zeOw+jwuVO4yCrEzs6ibrwHH2AX4Ff
	 rFmxleL5i//v/7yKdE6yUTDPQbJHrhc+65AFJPqG/whPR2e1mtND0eR9uJhqjuPiH6
	 qSpGHz2/XQXm2NYqJzWNNQvkqYBkxjIum4IwUXfLHzu30d3GtegwtVByOpTSu9ZXuq
	 lXFFUdHpCx3Mg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 256/311] ipv6: fix NULL pointer deref in ip6_rt_get_dev_rcu()
Date: Tue, 10 Mar 2026 07:05:03 -0400
Message-ID: <5f3aae357d526a2e796b7902886daddee50cc6c7.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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

