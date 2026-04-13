Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3DA3128CC;
	Mon, 13 Apr 2026 16:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098671; cv=none; b=Wsk0Dfv1Y6TImU7iM4FoQG4vA0vvdyunB5ufRkxNJsr9Dgqa6XuZ4HNjpukvrbZzwgKEfdbIt0PDcdnklh/1GIlRnPWZ/NZNvtrj3lXKmaR8bnWIMPD2pfz2Z1fQMg2KkH071b3DkPPEB4lZ77Hw2mTZuPI3C8MX5DAgVrQCN5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098671; c=relaxed/simple;
	bh=KGfOcqkMUGURVt1K5F/2B9k98naZQtaYecQuiqgjKgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOgQoIPrzwptk5Xc96MJA6AZMHzb0hyIZMqA5wRKWM/2sf5ev3r9xbdhL8l44DzVh/wR0Ae7mrNAogEsm0tgeoS6yIQ6508aCHBOV1muzfeAw+WKGwxIzFo7fVTj70NxI2yrK8Aq6dKxMIuqhXQs5lhfqsOIO65SvF0MRojMcbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tqm5rScO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tqm5rScO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D77C2BCAF;
	Mon, 13 Apr 2026 16:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098671;
	bh=KGfOcqkMUGURVt1K5F/2B9k98naZQtaYecQuiqgjKgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tqm5rScOoKZTWMxfGmHL/JlsWud9ivq6IYU2INKZFAvp2LTWnuyXivzQJXcWKNJue
	 p9UqyrqpxntNHil029OEhnP1bsf3lxquqMdXZFQFwx+uGdYmekQ/WCT47/w+pV+sTv
	 /JYTJzpe5urRdY3GyLgc3uFNGCs5I6328gTaWad8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/491] ipv6: fix NULL pointer deref in ip6_rt_get_dev_rcu()
Date: Mon, 13 Apr 2026 17:54:49 +0200
Message-ID: <20260413155820.702649202@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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
index b47f89600c2f8..ac24f8b624e34 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1013,7 +1013,8 @@ static struct net_device *ip6_rt_get_dev_rcu(const struct fib6_result *res)
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



