Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C51A51815A;
	Thu, 17 Sep 2026 17:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665992; cv=none; b=oLnNa8q+sC5U1NXFXTY2jIvZgdCwEuyP7xXFce+zhnc28cO2ozdG4x0v2JIODqlo3NXiQc05SM9HGKlxa2e/IZB+kDeR0GhBM4v33rNCLn65nabScjaUniydgi0978V1GOt/gPCoZp2Jox1Nqn1RFrMFkQZ+MA+eeLm2NSpKztU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665992; c=relaxed/simple;
	bh=DANRlUwbdI7FW+Ag+HwLEgMh3Xmu5EUFBrmj+WhumYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXlvryCo5yaOvGPWb9mbV/rVChqb+YEz4B/f8UUOhmUrZQWC0yFY2HCOiMT2m9Nzt+IXryGFXLWUFxSis0xDTJ9y77i7KMm3Jg0BX3zN/vprSgMBdI9gSfkZlU9HHcfO1SgkKJRwbU+mGWNPGPo8xfw3YmdwtbP2v8l2uLUQdfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DUb2tPJR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DUb2tPJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CC81F000FF;
	Thu, 17 Sep 2026 17:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665991;
	bh=Nk8qSu2sJHMJS4WwBtszQQuK+NaCU7UarM9TQrRX2mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DUb2tPJRbNBvxh/qPy+WJmWrjKdvpZVXP/IW7t3LVkosfS7vi6v8TbvpyEiLo2KYc
	 Tt66oVbs3mJB0m+C7RiypJHp2MnBBI1e/Eh0Hsx8Tt8OJnTd0p7W1o6W37Lo+YKYXw
	 C49PiEy2kEyk9SXQC+MGiO7Zcjdm1Ma0t9bTFE4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a73e5ee0fd534fed75bd@syzkaller.appspotmail.com,
	Naman Gulati <namangulati@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0887/1250] ipv6: null-check fib6_node before accessing in __ip6_del_rt_siblings()
Date: Thu, 17 Sep 2026 16:11:22 +0100
Message-ID: <20260917151616.027499779@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Naman Gulati <namangulati@google.com>

[ Upstream commit cdca92eddc025fdb90071be97738f7d55a65f8dd ]

syzbot reported a null-ptr-deref in __ip6_del_rt_siblings() [0].

The stack trace hinted towards a null dereference of rt->fib6_node when
fn->leaf is accessed in __ip6_del_rt_siblings(). With
RTNL_FLAG_DOIT_UNLOCKED set, inet6_rtm_delroute() operations run
concurrently without acquiring the RTNL lock. In ip6_route_del(), the
route lookup happens under rcu_read_lock() without acquiring
table->tb6_lock.

Between ip6_route_del() looking up the route and __ip6_del_rt_siblings()
acquiring table->tb6_lock, another thread can modify the routing table.
For example, when an ECMP route is replaced via RTM_NEWROUTE with
NLM_F_REPLACE, fib6_add_rt2node() unlinks all old siblings and sets
iter->fib6_node = NULL. A reproducer was found that triggers this [1].

Add a check to ensure rt->fib6_node is non-null before accessing it.

[0]
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
RIP: 0010:__ip6_del_rt_siblings+0x31e/0x7c0 net/ipv6/route.c:4056
Call Trace:
 <TASK>
 ip6_route_del+0x1054/0x1110 net/ipv6/route.c:4232
 inet6_rtm_delroute+0x5d7/0x6d0 net/ipv6/route.c:5669
 rtnetlink_rcv_msg+0x802/0xc00 net/core/rtnetlink.c:7132
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7f5/0x990 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:800
 __sock_sendmsg net/socket.c:815 [inline]
 ____sys_sendmsg+0x565/0x870 net/socket.c:2713
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2767
 __sys_sendmsg net/socket.c:2799 [inline]
 __do_sys_sendmsg net/socket.c:2804 [inline]
 __se_sys_sendmsg net/socket.c:2802 [inline]
 __x64_sys_sendmsg+0x1b7/0x290 net/socket.c:2802
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

[1] https://gist.github.com/NamanGulati/0766a1159b6ca61928faaf87425ff899

Fixes: bd11ff421d36 ("ipv6: Get rid of RTNL for SIOCDELRT and RTM_DELROUTE.")
Reported-by: syzbot+a73e5ee0fd534fed75bd@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a9b03f9.04649fcc.10325f.0003.GAE@google.com
Signed-off-by: Naman Gulati <namangulati@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260904180645.706425-1-namangulati@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 50eeae3de1156..1945fbf1d81b8 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4004,6 +4004,7 @@ static int __ip6_del_rt_siblings(struct fib6_info *rt, struct fib6_config *cfg)
 	struct net *net = info->nl_net;
 	struct sk_buff *skb = NULL;
 	struct fib6_table *table;
+	struct fib6_node *fn;
 	int err = -ENOENT;
 
 	if (rt == net->ipv6.fib6_null_entry)
@@ -4011,9 +4012,13 @@ static int __ip6_del_rt_siblings(struct fib6_info *rt, struct fib6_config *cfg)
 	table = rt->fib6_table;
 	spin_lock_bh(&table->tb6_lock);
 
+	fn = rcu_dereference_protected(rt->fib6_node,
+				       lockdep_is_held(&table->tb6_lock));
+	if (!fn)
+		goto out_unlock;
+
 	if (rt->fib6_nsiblings && cfg->fc_delete_all_nh) {
 		struct fib6_info *sibling, *next_sibling;
-		struct fib6_node *fn;
 
 		/* prefer to send a single notification with all hops */
 		skb = nlmsg_new(rt6_nlmsg_size(rt), GFP_ATOMIC);
@@ -4035,8 +4040,6 @@ static int __ip6_del_rt_siblings(struct fib6_info *rt, struct fib6_config *cfg)
 		 * and emit a replace or delete notification, respectively.
 		 */
 		info->skip_notify_kernel = 1;
-		fn = rcu_dereference_protected(rt->fib6_node,
-					    lockdep_is_held(&table->tb6_lock));
 		if (rcu_access_pointer(fn->leaf) == rt) {
 			struct fib6_info *last_sibling, *replace_rt;
 
-- 
2.53.0



