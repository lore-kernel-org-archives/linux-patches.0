Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C1B33A9CF;
	Thu, 12 Mar 2026 20:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347235; cv=none; b=s51HaQlkNnQp4/FP3/U/7CzE638O2FO5ccvx/jZ6jZ9l5D0IIY16eBWiU4aOxBSGXRLx0aMy0Ww/CvTMMDnAObuiAoKsBks88bAtImavH4F5/5ZaL8ohY9Jf2mrEjcWY40pqPcL1Rt63kbnLk39KQGqh3Te6nlWouQMRV3GC+fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347235; c=relaxed/simple;
	bh=UMPpd97afvkjw6EqX0kIUAbUS5jqTnijH4v3yoaK9CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omrsN2DAfNsF7c8iT4oO9zdP9qK0Q4tjsXolgpBa2Hhokd3Z8TQJv7XKTjQQo8dUhP6E5QCVI4JwQ2ms4YHVK5DI7AUP+bYrWGSNoiqz8EB0uRH+pQbuvgYqx0MIxDOpg0+9zTNcOpfEn5ZIHJd8QTkek7JucHK8HgvKMtC4+1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8NbQITT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8NbQITT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBE3C4CEF7;
	Thu, 12 Mar 2026 20:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347234;
	bh=UMPpd97afvkjw6EqX0kIUAbUS5jqTnijH4v3yoaK9CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8NbQITTcMgHVUNbR38nF+X/4DKeZBAK63O8rcan9BZRUTTxdJfvBC8zjfIGI+99h
	 qsshHV9e7KvmUhSMLCABIS0VvRKMFHgnXdqirRrZi/28On3xbV++zXQ18mNc6JIvYP
	 gGnXwvkDl9NR6uGsisJK0GtIXYFUCpKltj1lrNpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	syzbot+334190e097a98a1b81bb@syzkaller.appspotmail.com,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 240/265] net: ipv6: fix panic when IPv4 route references loopback IPv6 nexthop
Date: Thu, 12 Mar 2026 21:10:27 +0100
Message-ID: <20260312201027.004084078@linuxfoundation.org>
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
index 0f741aa154faf..7b9279d4c363c 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3577,7 +3577,6 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 	netdevice_tracker *dev_tracker = &fib6_nh->fib_nh_dev_tracker;
 	struct net_device *dev = NULL;
 	struct inet6_dev *idev = NULL;
-	int addr_type;
 	int err;
 
 	fib6_nh->fib_nh_family = AF_INET6;
@@ -3619,11 +3618,10 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 
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



