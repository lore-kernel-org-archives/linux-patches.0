Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E80B43E9F5;
	Tue, 16 Jun 2026 15:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623461; cv=none; b=p6uPh+bhlWkJv0dK/m5Tkz6shQl0anZZtBliqQWZw0bRJpUaDw4+IsaLX3fQTNFtWUek8Q2BNeqkL1reWzgH0yKJgeN3Z6PhsCYXLhMF0KxI/xLOwNZpJtG3tbydV14BFAZIQlF4ZAnnGctG+jeg9apZFHpht3n7eOfvlPuEnNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623461; c=relaxed/simple;
	bh=QG8hhY9dO6xfEsPqbNiPI8zE6wME1jVTFIk0Na8Jkc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHhiQH3DV1/j17FMIIYzGMuRfTLvhgRO+n2vpyR1/pgtvd+G4mal5jPVWDMivl9X7g8aoHEXNxOj9ZB/VqHuDwov48/HNEZ2CfCaZnmhZRLLco56P4gZeIhQ8NDs3s1LFkSXiB/pv99touL9//GSKlPHzy632G7QCGdZ918Yz44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWVM0JY0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWVM0JY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347F01F000E9;
	Tue, 16 Jun 2026 15:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623460;
	bh=EXq21p3rRYGIYAihDJpR3NfALZT55Clh+f94i/kqAxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rWVM0JY0qikBt5J2MQ3YzvqjeSIhcJvPGSrSBdSjtSXBEHzYibizH6Bxk7L91MBUE
	 9nehrBb7I+rrdUFRlAqRlg40OCbVd846GRXmG7s002+DS4VbUyJcs2lmVT9Q0ImIxt
	 KcoHlAPoCav9WrarfoqR5xw5+qGIlWf1wxgJuFCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhou <eilaimemedsnaimel@gmail.com>,
	David Ahern <dahern@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 153/378] ipv6: Fix a potential NPD in cleanup_prefix_route()
Date: Tue, 16 Jun 2026 20:26:24 +0530
Message-ID: <20260616145118.296273743@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index e5276be71062a3..8f8fdc9cfce224 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1264,6 +1264,7 @@ static void
 cleanup_prefix_route(struct inet6_ifaddr *ifp, unsigned long expires,
 		     bool del_rt, bool del_peer)
 {
+	struct net *net = dev_net(ifp->idev->dev);
 	struct fib6_table *table;
 	struct fib6_info *f6i;
 
@@ -1272,9 +1273,10 @@ cleanup_prefix_route(struct inet6_ifaddr *ifp, unsigned long expires,
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



