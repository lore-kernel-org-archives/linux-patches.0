Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A370430BB9B;
	Mon, 13 Apr 2026 16:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097383; cv=none; b=COF1yzsEfja2qcvudZ3fhDYTunLZ10nWuepYUd5wcjIg3r9L4msFRvO6hTo32WgC3URneDaR3umriW5zcIKja9umBEAm5YTYJ6SKExKipPzHzzwi6CVnxiNTWSgxZMmrNjTRL8KLrTBkFQgyZH/HZgaT4/sJkhny2ifimolVY8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097383; c=relaxed/simple;
	bh=i7BVF51RpMxrl5ifK7h6gDLeLsCpPAK0QZe8MYggs7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InA7sN/naYj37NoiwQrtye7Suctz8wJQ4mPEHjr4+OHYwgFsPMDnvSYHaXWXFsVDARLitpEXvxYbkrICIm5bGB6mWVqfhbplcu7StnFTenUKwfzG/Clydtj8n8lthwKp7b8WY5TCQHGqBsdUioJV2helm0jxTgiT0k8mm3nTiHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LEtBmYa5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LEtBmYa5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39289C2BCAF;
	Mon, 13 Apr 2026 16:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097383;
	bh=i7BVF51RpMxrl5ifK7h6gDLeLsCpPAK0QZe8MYggs7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LEtBmYa58I0jqrPo8GEI/Ie8o5ZaSv2uv03mLp79p1NNsHhMEf+5qgu8K4laHV6Q7
	 GV056bQzpXeTyoX0kN00XlvRt0v7/AynIHXG/pD8nE4crK1gI2xkYzYL4bBDs3+FpO
	 us194Qsq6r4FmMWi76+Z8nouYmVgUsljgQ4pLIAc=
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
Subject: [PATCH 5.15 088/570] net: ipv6: fix panic when IPv4 route references loopback IPv6 nexthop
Date: Mon, 13 Apr 2026 17:53:39 +0200
Message-ID: <20260413155833.741165571@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 05e2ea8b269df..52e8e77df69a1 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3519,7 +3519,6 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 {
 	struct net_device *dev = NULL;
 	struct inet6_dev *idev = NULL;
-	int addr_type;
 	int err;
 
 	fib6_nh->fib_nh_family = AF_INET6;
@@ -3560,11 +3559,10 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 
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



