Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1A244E040;
	Tue, 10 Mar 2026 11:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142212; cv=none; b=tRZpg6CmhR1+2uTwg/6aoRhR+blrH5pzT6rjDudkvaJEpjn8dxrjcgiyce6A8MBpVDwJkud7yjiMlLcaNoul12j09/wOr2+9MrQ1fwQbqq1mBn7IghysupxiHvgUJ6g+q62FRgHb6KPwxa3IITdjcXfKom/5K1p/62OT+vB8/iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142212; c=relaxed/simple;
	bh=ofkiFYobMeRAyCF5p7DSR9LH6imLwb4VUlfSG+CuHEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Baiet6UhWPH/4g+FGkEtzTMZHBewMRd9iaCqSq79d7PqBeI5qeet0xI9yLDpVSBVf21ccjCYBlrfXsyqyvovUX0MnRhFIV4KX1nYzC51rov6RUhU3LYB10K91tSmj3IAEdRn/OdF3DOKjFObiww5BDM866oCWBA8bs5XUGiqmC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HfA83gJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HfA83gJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8314AC2BC86;
	Tue, 10 Mar 2026 11:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142212;
	bh=ofkiFYobMeRAyCF5p7DSR9LH6imLwb4VUlfSG+CuHEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HfA83gJ+eA5rAN7L4dBRMD3GKRk5PJrRRToFidnm4DNfCaXR3X6kYoCfbd5Yy61Bh
	 KnTaZ20ZEbOrwR+q9tKBOY9CeeHJFT7vTyLhVbewupDnDUq2WLaKKlXpOyG4zqxqrS
	 0Fd7g+Yi7IRqWZgLTydsTn6x6uNh8Ft1yWDV3S1Oijrp1RfTA7fw5MyM3HRcTgv8VC
	 HbBKX0/PNLehrWxoaA9b1mkoMMCO75SpB+MOZk3fs8OQMLhwmRv+fdDXEkMfnCjKWO
	 oHWJkul/P1MOVJXQbrl5XivmcM1XTlE/nJ+0PuOAqw4ryDp9cDkmwuJjDoBkk7Yp1s
	 9kphMD8MjO3bQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	Ido Schimmel <idosch@nvidia.com>,
	syzbot+334190e097a98a1b81bb@syzkaller.appspotmail.com,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 302/314] net: ipv6: fix panic when IPv4 route references loopback IPv6 nexthop
Date: Tue, 10 Mar 2026 07:19:21 -0400
Message-ID: <2646b27411f2d88d3665d7227eaaefc381aefa1d.1773141556.git.sashal@kernel.org>
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

From: Jiayuan Chen <jiayuan.chen@shopee.com>

[ Upstream commit 21ec92774d1536f71bdc90b0e3d052eff99cf093 ]

When a standalone IPv6 nexthop object is created with a loopback device
(e.g., "ip -6 nexthop add id 100 dev lo"), fib6_nh_init() misclassifies
it as a reject route. This is because nexthop objects have no destination
prefix (fc_dst=::), causing fib6_is_reject() to match any loopback
nexthop. The reject path skips fib_nh_common_init(), leaving
nhc_pcpu_rth_output unallocated. If an IPv4 route later references this
nexthop, __mkroute_output() dereferences NULL nhc_pcpu_rth_output and
panics.

Simplify the check in fib6_nh_init() to only match explicit reject
routes (RTF_REJECT) instead of using fib6_is_reject(). The loopback
promotion heuristic in fib6_is_reject() is handled separately by
ip6_route_info_create_nh(). After this change, the three cases behave
as follows:

1. Explicit reject route ("ip -6 route add unreachable 2001:db8::/64"):
   RTF_REJECT is set, enters reject path, skips fib_nh_common_init().
   No behavior change.

2. Implicit loopback reject route ("ip -6 route add 2001:db8::/32 dev lo"):
   RTF_REJECT is not set, takes normal path, fib_nh_common_init() is
   called. ip6_route_info_create_nh() still promotes it to reject
   afterward. nhc_pcpu_rth_output is allocated but unused, which is
   harmless.

3. Standalone nexthop object ("ip -6 nexthop add id 100 dev lo"):
   RTF_REJECT is not set, takes normal path, fib_nh_common_init() is
   called. nhc_pcpu_rth_output is properly allocated, fixing the crash
   when IPv4 routes reference this nexthop.

Suggested-by: Ido Schimmel <idosch@nvidia.com>
Fixes: 493ced1ac47c ("ipv4: Allow routes to use nexthop objects")
Reported-by: syzbot+334190e097a98a1b81bb@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/698f8482.a70a0220.2c38d7.00ca.GAE@google.com/T/
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20260304113817.294966-2-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index e7d90a28948a4..e01331d965313 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3584,7 +3584,6 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 	netdevice_tracker *dev_tracker = &fib6_nh->fib_nh_dev_tracker;
 	struct net_device *dev = NULL;
 	struct inet6_dev *idev = NULL;
-	int addr_type;
 	int err;
 
 	fib6_nh->fib_nh_family = AF_INET6;
@@ -3626,11 +3625,10 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 
 	fib6_nh->fib_nh_weight = 1;
 
-	/* We cannot add true routes via loopback here,
-	 * they would result in kernel looping; promote them to reject routes
+	/* Reset the nexthop device to the loopback device in case of reject
+	 * routes.
 	 */
-	addr_type = ipv6_addr_type(&cfg->fc_dst);
-	if (fib6_is_reject(cfg->fc_flags, dev, addr_type)) {
+	if (cfg->fc_flags & RTF_REJECT) {
 		/* hold loopback dev/idev if we haven't done so. */
 		if (dev != net->loopback_dev) {
 			if (dev) {
-- 
2.51.0

