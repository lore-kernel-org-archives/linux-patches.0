Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FF536A37E;
	Sat, 12 Sep 2026 09:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204756; cv=none; b=eH8bfgFcTzRk4z3d6rD73SnxlnvpoadkjmrHG1Q1+2ZYkO8kiZu1jeh6h8u9DfUhPn+VpYLyKaxFLQ7uvoXszaOT/P9a6WJ9ykJvVm4nw8R0Tlw00b+IUof+Tmz569ANcdMZdQ8lciqwmOwPY6Cs7ACPJe4IWUhojxeSlHH9GpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204756; c=relaxed/simple;
	bh=jNQErq5dfLq10V3ltgbPEH3bV5L838ErV4hKeU2qQvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMLMTT/zexMVRVgveusfIZVYxs4TF6MWGsGY+VrNPLMfCQGYI173XYRGFg9ExrlcXgX5DDW0TVwcBLKW2V0S+FI2nG//AAM48bgMxPBuQwrps3BnampVA2iTXMkIjA9RqNndlXyq3hV8Lbq/TRf4pwSTGIT4rO8Xms2Q0Vx5Rx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JB1zmPug; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JB1zmPug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AA11F000FF;
	Sat, 12 Sep 2026 09:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204755;
	bh=SJAPpQhDi6N3XWKxf4/f+lUWSQkw5KPjdgKecLxLp1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JB1zmPugV6OeSQV9Ieov7V1tqiiD75a1qrWMZMtFz91D6Gr6sZtXe4LodfDb7bKVB
	 fJxWUmG9QfjFusGq6jqQwu0LgdnL1BUiPeplhyvgQ1F3aYFSFUggbky7FiV0b2zehX
	 j2ZXn77Df3lcJKDDE19HNohBd8I0rA2U8h9aUIUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1677/1815] ipv6: avoid divide by zero in rt6_multipath_rebalance
Date: Sat, 12 Sep 2026 08:57:07 +0200
Message-ID: <20260912065728.355805297@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft) <blbllhy@gmail.com>

[ Upstream commit d2c26c2911dd1a363c488add4fb63eb5f0f28f87 ]

rt6_multipath_rebalance() calculates the total eligible nexthop weight
in one pass and programs upper bounds in a second pass. Since
RTM_NEWROUTE is RTNL-free, a concurrent
ignore_routes_with_linkdown update can make the first pass return zero
while the second sees an eligible nexthop, causing
rt6_upper_bound_set() to divide by zero.

UBSAN: division-overflow in net/ipv6/route.c:4845:17
Oops: divide error: 0000 [#1] SMP KASAN NOPTI
  rt6_upper_bound_set() net/ipv6/route.c:4845
  rt6_multipath_rebalance()
  fib6_add_rt2node()
  ip6_route_multipath_add()
  inet6_rtm_newroute()

Skip upper-bound calculation when the first pass reports a zero total.
This respects the lock-free performance considerations here and solves
insecure scenarios.

Fixes: bd11ff421d36 ("ipv6: Get rid of RTNL for SIOCDELRT and RTM_DELROUTE.")
Reported-by: AutonomousCodeSecurity@microsoft.com
Reported-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Reported-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Signed-off-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260817013237.2797-1-blbllhy@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index a698f322db1ca..dc9060af5bb1e 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4840,7 +4840,7 @@ static void rt6_upper_bound_set(struct fib6_info *rt, int *weight, int total)
 {
 	int upper_bound = -1;
 
-	if (!rt6_is_dead(rt)) {
+	if (total && !rt6_is_dead(rt)) {
 		*weight += rt->fib6_nh->fib_nh_weight;
 		upper_bound = DIV_ROUND_CLOSEST_ULL((u64) (*weight) << 31,
 						    total) - 1;
-- 
2.53.0



