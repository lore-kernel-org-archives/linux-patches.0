Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9869546AF1B;
	Tue, 16 Jun 2026 16:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627011; cv=none; b=HkbdrhukFxewE/K8oBidRArEWeYm2Qz0AbuVA+oN742umN7M6z88OC1uIohYNO+VDDhLKR/ASOWI8JE91qrcffe88COEYUxiePCwUL998rKVR6yg47ffu3c1KT3yqcSo+ds1x2nr8TGiEfFHisD3mjp8KtV23AoTn6hO7X3v9M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627011; c=relaxed/simple;
	bh=sNrHu11c2nL9MWV5vDpeN6L/OZu3MnZE9sBknFGmQmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/CYwTBsaIY9391LO1zDOtGj+EEuJ8kP5R0V2u96MstEyqIDIQsoxOCxVp5AARz0A1DoU4DUn1QIdcEhUt+d14mk0sModvtGR+vvD7iKrBmdThtHxmLfuOaQDRSgtV6eJDnY2MYh1obLOq07X/l7sHPzvTcSBCTHBIyZk+wCcuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YM5wUkHY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YM5wUkHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5160F1F000E9;
	Tue, 16 Jun 2026 16:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627010;
	bh=UMqpeRZWAN1ChiNHCg0eqi6dfmofJhHqfoRNKnBYSR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YM5wUkHYrk4cGMxcx/LU9BSJLZnwyWXKcZqPnXxEoO5nusl9y2Vp6rMNz9iYQ5cH+
	 0Sj+lGpkBqy16f7s3WNol0MG/R+uOBxtBuqwmd0bv/ZHblEBGZGZHkz8sXqCGjYwA9
	 T9LYvwZzlOEjSskwOqFMtpFrlbrpyYsPmkP2UZ8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhou <eilaimemedsnaimel@gmail.com>,
	David Ahern <dahern@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 107/261] ipv6: Fix a potential NPD in cleanup_prefix_route()
Date: Tue, 16 Jun 2026 20:29:05 +0530
Message-ID: <20260616145050.011266364@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

[ Upstream commit b70c687b7cf267fb08586667a3946c8851cad672 ]

addrconf_get_prefix_route() can return the fib6_null_entry sentinel
entry which has a NULL fib6_table pointer. Therefore, before setting the
route's expiration time, check that we are not working with this entry,
as otherwise a NPD will be triggered [1].

Note that the other callers of addrconf_get_prefix_route() are not
susceptible to this bug:

1. addrconf_prefix_rcv(): Requests a route with the 'RTF_ADDRCONF |
   RTF_PREFIX_RT' flags which are not set on fib6_null_entry.

2. modify_prefix_route(): Fixed by commit a747e02430df ("ipv6: avoid
   possible NULL deref in modify_prefix_route()").

3. __ipv6_ifa_notify(): Calls ip6_del_rt() which specifically checks for
   fib6_null_entry and returns an error.

[1]
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
[...]
Call Trace:
<TASK>
__kasan_check_byte (mm/kasan/common.c:573)
lock_acquire.part.0 (kernel/locking/lockdep.c:5842 (discriminator 1))
_raw_spin_lock_bh (kernel/locking/spinlock.c:182 (discriminator 1))
cleanup_prefix_route (net/ipv6/addrconf.c:1280)
ipv6_del_addr (net/ipv6/addrconf.c:1342)
inet6_addr_del.isra.0 (net/ipv6/addrconf.c:3119)
inet6_rtm_deladdr (net/ipv6/addrconf.c:4812)
rtnetlink_rcv_msg (net/core/rtnetlink.c:6997)
netlink_rcv_skb (net/netlink/af_netlink.c:2555)
netlink_unicast (net/netlink/af_netlink.c:1344)
netlink_sendmsg (net/netlink/af_netlink.c:1899)
__sock_sendmsg (net/socket.c:802 (discriminator 4))
____sys_sendmsg (net/socket.c:2698)
___sys_sendmsg (net/socket.c:2752)
__sys_sendmsg (net/socket.c:2784)
do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

Fixes: 5eb902b8e719 ("net/ipv6: Remove expired routes with a separated list of routes.")
Reported-by: Ji'an Zhou <eilaimemedsnaimel@gmail.com>
Reviewed-by: David Ahern <dahern@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260609145448.768318-1-idosch@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index e104ec8efe1c0c..c6fcdb60dfee14 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1259,6 +1259,7 @@ static void
 cleanup_prefix_route(struct inet6_ifaddr *ifp, unsigned long expires,
 		     bool del_rt, bool del_peer)
 {
+	struct net *net = dev_net(ifp->idev->dev);
 	struct fib6_table *table;
 	struct fib6_info *f6i;
 
@@ -1267,9 +1268,10 @@ cleanup_prefix_route(struct inet6_ifaddr *ifp, unsigned long expires,
 					ifp->idev->dev, 0, RTF_DEFAULT, true);
 	if (f6i) {
 		if (del_rt)
-			ip6_del_rt(dev_net(ifp->idev->dev), f6i, false);
+			ip6_del_rt(net, f6i, false);
 		else {
-			if (!(f6i->fib6_flags & RTF_EXPIRES)) {
+			if (f6i != net->ipv6.fib6_null_entry &&
+			    !(f6i->fib6_flags & RTF_EXPIRES)) {
 				table = f6i->fib6_table;
 				spin_lock_bh(&table->tb6_lock);
 
-- 
2.53.0



