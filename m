Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02D1497B76;
	Wed, 23 Sep 2026 14:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174174; cv=none; b=KyqohtoNy5vr+UA8rcfqrXlUBnzCfycVRXJIQhtMNLkKuhjZFUL8+IYMHbTmohRG1yuLNYIWrxC1+DrU5DgtXBwysfu4bjxLHOKPsNuBHP8aFW8PV3O78HkOvC0YTos2SY7tTE3Vv/JTL5mgDK7yl/fPnhK+Rt8cEzKBTphj8lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174174; c=relaxed/simple;
	bh=v/lNGh2ANWKe+RiohOdjv6VqgOU9puOSBnZAcpMfD6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=laRcU9zrIDP/WOyQZdXYwncpglPl/oXdBWVSRjRCYwoJWJkUq8/PWX5H6tZsp0QtWyjf2sxkefb/b6amva5fHJNobggQyYSyYOd5A2plXyP6IFybgQj5bgQgsVV53oYNeyqp4A8610QyVHWOsthdKYnr0kEthbN3iArdhAf1xFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQmS35Ai; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQmS35Ai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221E21F000FF;
	Wed, 23 Sep 2026 14:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174172;
	bh=6eyX7TYH40/0JId2cbw9UEN1BnAq0S2h4Fe+ZhrqezQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TQmS35AikX4ZaqRsRBA5Kf6IXCjbwayG3O7sI8PPcNEAKo07meN4YjxqfFNIhmOmN
	 Y+LdjHBvDh7iXUOsj8x2qC6l0qyyH7AqxgGeWXVO2c0aRyZ54+HI1ZRJXXqtP/GSo1
	 J+XvAcv2NO3hL6rd5OlifxhbHLZ1nFlJWCMYz/84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 015/398] ipv6: Select best matching nexthop object in fib6_table_lookup()
Date: Wed, 23 Sep 2026 16:01:29 +0200
Message-ID: <20260923140643.835259236@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 484bb9d164df397a53e0f533b262b27b1590efcb ]

Currently, when using multipath routes without nexthop objects,
fib6_table_lookup() selects the nexthop with the highest score. This
means that when both a source address and an oif are specified, the
nexthop that is chosen is the one that matches in terms of oif:

 # sysctl -wq net.ipv6.conf.all.forwarding=1
 # ip address add 2001:db8:2::1/64 dev lo
 # ip route add 2001:db8:10::/64 nexthop via fe80::1 dev dummy1 nexthop via fe80::2 dev dummy2

 # perf record -e fib6:fib6_table_lookup -- bash -c "for i in {1..100}; do ip route get 2001:db8:10::${i} from 2001:db8:2::1 oif dummy1; done > /dev/null"
 # perf script | grep -o dummy[0-9] | sort | uniq -c
     100 dummy1
 # perf record -e fib6:fib6_table_lookup -- bash -c "for i in {1..100}; do ip route get 2001:db8:10::${i} from 2001:db8:2::1 oif dummy2; done > /dev/null"
 # perf script | grep -o dummy[0-9] | sort | uniq -c
     100 dummy2

When using nexthop objects, fib6_table_lookup() selects the first
matching nexthop and not necessarily the one with the highest score:

 # ip nexthop add id 1 via fe80::1 dev dummy1
 # ip nexthop add id 2 via fe80::2 dev dummy2
 # ip nexthop add id 3 group 1/2
 # ip route add 2001:db8:20::/64 nhid 3

 # perf record -e fib6:fib6_table_lookup -- bash -c "for i in {1..100}; do ip route get 2001:db8:20::${i} from 2001:db8:2::1 oif dummy1; done > /dev/null"
 # perf script | grep -o dummy[0-9] | sort | uniq -c
     100 dummy1
 # perf record -e fib6:fib6_table_lookup -- bash -c "for i in {1..100}; do ip route get 2001:db8:20::${i} from 2001:db8:2::1 oif dummy2; done > /dev/null"
 # perf script | grep -o dummy[0-9] | sort | uniq -c
     100 dummy1

This is not very significant right now because the nexthop is later
overwritten during path selection in fib6_select_path(). However, the
next patch is going to skip path selection when we have an oif match
during output route lookup.

As a preparation for this change, align the nexthop object behavior with
the legacy one and make sure that fib6_table_lookup() always selects the
best matching nexthop. Do that by always returning 0 from
rt6_nh_find_match() in order not to terminate the loop in
nexthop_for_each_fib6_nh() and storing in arg->nh the best matching
nexthop so far.

Behavior after the change:

 # perf record -e fib6:fib6_table_lookup -- bash -c "for i in {1..100}; do ip route get 2001:db8:20::${i} from 2001:db8:2::1 oif dummy1; done > /dev/null"
 # perf script | grep -o dummy[0-9] | sort | uniq -c
     100 dummy1
 # perf record -e fib6:fib6_table_lookup -- bash -c "for i in {1..100}; do ip route get 2001:db8:20::${i} from 2001:db8:2::1 oif dummy2; done > /dev/null"
 # perf script | grep -o dummy[0-9] | sort | uniq -c
     100 dummy2

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20260611154605.992528-2-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index ddaf51eacc2d1..03b26738bd718 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -819,9 +819,11 @@ static int rt6_nh_find_match(struct fib6_nh *nh, void *_arg)
 {
 	struct fib6_nh_frl_arg *arg = _arg;
 
-	arg->nh = nh;
-	return find_match(nh, arg->flags, arg->oif, arg->strict,
-			  arg->mpri, arg->do_rr);
+	if (find_match(nh, arg->flags, arg->oif, arg->strict, arg->mpri,
+		       arg->do_rr))
+		arg->nh = nh;
+
+	return 0;
 }
 
 static void __find_rr_leaf(struct fib6_info *f6i_start,
@@ -861,11 +863,10 @@ static void __find_rr_leaf(struct fib6_info *f6i_start,
 				res->nh = nexthop_fib6_nh(f6i->nh);
 				return;
 			}
-			if (nexthop_for_each_fib6_nh(f6i->nh, rt6_nh_find_match,
-						     &arg)) {
-				matched = true;
-				nh = arg.nh;
-			}
+			nexthop_for_each_fib6_nh(f6i->nh, rt6_nh_find_match,
+						 &arg);
+			matched = !!arg.nh;
+			nh = arg.nh;
 		} else {
 			nh = f6i->fib6_nh;
 			if (find_match(nh, f6i->fib6_flags, oif, strict,
-- 
2.53.0



