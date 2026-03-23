Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EDF3BA234;
	Mon, 23 Mar 2026 16:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282464; cv=none; b=tiDIyLGSM629N64WwfrnmuIxO5CFSbwDOAiY619rImo8gvtTAHBAvEGszjh6HEUTFLL9vocqk//xEaMc7Ns7Z4fg+vMOdLABKbnkpMh8HYQcU7z35LvGFlO5Xif2Z7aBA6Ne2BiMm8xJSzRU8DkC228awDK7Eds35zOdz8AYqDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282464; c=relaxed/simple;
	bh=sMfjbdV0/DRmuyGSC28hcHw7hMnqcrRG4F3FRRZs1kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5IEfvfq5i7oaLn/+BHhxUwGUQZfLfT0NCettTynH3l2HLFLTLSeeIT7qgpTiwIQk4pSfZznM/XROZoCM1R1o7HIPJA3oRHYwRBL9EEJPN2WnmC2rdV4LaytKe+0+1vbneplaMO6cJNIh0sM2NvGM497QRWg/rNeej/N1zdRK/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7dgF4gk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7dgF4gk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07A0C4CEF7;
	Mon, 23 Mar 2026 16:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282464;
	bh=sMfjbdV0/DRmuyGSC28hcHw7hMnqcrRG4F3FRRZs1kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7dgF4gkJbx/KSsM0pOl3tBSWdxVPAA/dn8uQ3RBx7Cb/h2GJVgQQNIXcWlbujFKf
	 We41Ch/By11IV/vzulL9617pIQtvVM69jqLVT+XtAPt4uTlxJycThmsA5ruhAou1cN
	 CWCGZVSxs7xnydloA2HPK6hDxHIt6Xgi7i51x3LI=
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
Subject: [PATCH 6.1 139/481] net: ipv6: fix panic when IPv4 route references loopback IPv6 nexthop
Date: Mon, 23 Mar 2026 14:42:01 +0100
Message-ID: <20260323134528.647549083@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5aa5390da1095..987ef0954e2ea 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3558,7 +3558,6 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 {
 	struct net_device *dev = NULL;
 	struct inet6_dev *idev = NULL;
-	int addr_type;
 	int err;
 
 	fib6_nh->fib_nh_family = AF_INET6;
@@ -3599,11 +3598,10 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 
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



