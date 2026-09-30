Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE4B4F7CBF;
	Wed, 30 Sep 2026 17:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788270; cv=none; b=kr4rUe/6ERcf4iQiqgtMHhzHaRwG49q+b/tqjD4rHvoSkfTHepDUGK/ht31NGfBMwHLQWrYnjt1O/bhxQ5dI4bPG0RGupzImHbILRY9B98SD4TC0OKE/GQDxCSzwJl+uoDEdjRDva+x7tLI7BTnyvWSnNYb1S7nHEIg9QWShFF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788270; c=relaxed/simple;
	bh=isieRp5cK6yHRr5rQbcNLrfOPeLrFw17HSDxOKHM2oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmKOCUmpmH72nYaoNd7UPlrV6FZDjYnV0E1SKVaSRkaAb1siRrw9SWhzmiXNnrkU+2rOPENNNuXlvtLbB9dwNAmSfryZbE9rhYKpPc9z47sgllwCVa1icQRqi6hncO5rakIp+gIGp1zzoCQfSmhcqEC0m659Ge7KC7DzZ+xRCAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xYJ00Oji; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xYJ00Oji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753991F000FF;
	Wed, 30 Sep 2026 17:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788269;
	bh=LQ20Tney2yqMcGwEEXbP/5jgVjNfACcaihoVpoKcOwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xYJ00Oji4XXzOPZTNCDiupZobEioE+NZwj7baJpKgpXkRQ3EBLOHpzxdHEkM54sNa
	 tmGPXGBB5BLDzNCS8UxEI8dAXVROVKnTWNoLbTJ63wbuGtjfdy51+/wl8/sfGcbH8F
	 gjYSTFB5wy0aBzBcEhXnEi4ptmHIF3gM09h2/g8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/877] ipv6: Select best matching nexthop object in fib6_table_lookup()
Date: Wed, 30 Sep 2026 17:15:31 +0200
Message-ID: <20260930152415.182270219@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index 19c970978e863..b30cb180009b1 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -820,9 +820,11 @@ static int rt6_nh_find_match(struct fib6_nh *nh, void *_arg)
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
@@ -862,11 +864,10 @@ static void __find_rr_leaf(struct fib6_info *f6i_start,
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



