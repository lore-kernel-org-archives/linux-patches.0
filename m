Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0F4455162;
	Sat, 12 Sep 2026 11:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212022; cv=none; b=mex7L8xZbGpp8K+xm5aQrkrTyAzYsiBQHhm+F6O8QNaSvTYKc+EHREb1dQP9pGaCrttj13AW7wKw+fQUbSSUjk2foMYiFGAjeXyDF+KRP2Ff1XgiIF06VFUWlFNfavPsW6+0i+w2dhvkiyCkYWGWW8iJkxPS3GHVCYt2XnFEoYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212022; c=relaxed/simple;
	bh=vo5aD4M4IBPHwiSStl6lj3SkyRnvF3Cty00JqOxsXd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQ0SuixWU1GJHaXf96xoTABjIHK7gOfcmpsx1BkHxkGuOCVVFmD6Q0EAJ7UJ+S0haIcPv73OToJo3kjYsrLLDeEQVGvwQZEh3qsO1DIhqV+CWjHlgrnfAoyk++R+qv92Dg39h2GWkM19j0LBA6QiJfI21eD+ESgJmHOh0u1rJ7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y98hBKXX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y98hBKXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E622E1F000FF;
	Sat, 12 Sep 2026 11:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212020;
	bh=A9/7SVXsyZE3fZaZb4QK5zlYKiwkgUrZ3FNsdT8HPdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y98hBKXXOcjc/wmKzkU7oRmD7uPmQL2Fh2CX+3Nat2N1v35RtlZx59MjFHu4pOqcD
	 yx//10Je+fFR7jOeqHWJro/wCOJMpg4wTGTVwoLKtOlBq2MPAxNYxpz+ftDigVhCxn
	 Wz+rZuPNL/QhaJ3n4NlXSUr8L1dZHMkcgbKWPQJE=
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
Subject: [PATCH 6.18 1351/1518] ipv6: avoid divide by zero in rt6_multipath_rebalance
Date: Sat, 12 Sep 2026 08:58:40 +0200
Message-ID: <20260912065654.091135789@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2d94a62ed10a4..ec6677bf7dea9 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4831,7 +4831,7 @@ static void rt6_upper_bound_set(struct fib6_info *rt, int *weight, int total)
 {
 	int upper_bound = -1;
 
-	if (!rt6_is_dead(rt)) {
+	if (total && !rt6_is_dead(rt)) {
 		*weight += rt->fib6_nh->fib_nh_weight;
 		upper_bound = DIV_ROUND_CLOSEST_ULL((u64) (*weight) << 31,
 						    total) - 1;
-- 
2.53.0



