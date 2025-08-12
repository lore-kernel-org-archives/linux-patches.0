Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D293E2FDC4F;
	Tue, 12 Aug 2025 18:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024139; cv=none; b=EEjv/ehetzYmZZWw+mF7NX20SBGYSi3e3FzlXjYrXXzFKlBoDb7OoHA9xtZ6YCidXMA81PLbuBgDyx/6tzjRNSllN+04SChw0p3CF3CKZSY5RVU78iBm+RkvK0MZ1hk3/OfPQH4UNOIvNAPiJIQTKmxwUqJpV831T7c+9errnS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024139; c=relaxed/simple;
	bh=F/uR4qEkZYdwAe7ENcjmnf0r3s8jtZW4A1UR+saJUqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+LY9F4Ag3/NHeB7G43o363IViDY0L5A0v+7pZmncYYbBASS+8XNtL+8ofdn68i7MrYwrVYJv+vTb3iaVVPX2VWuJJJElCslt1pbK/RQtJhacVmEvBLFIvdIBvyaxep12e3hy7zZMu+4B9gMZvq3NrTwoDA4xSDqLmiiLQtstfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pEEmouIx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pEEmouIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B60C4CEF0;
	Tue, 12 Aug 2025 18:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024138;
	bh=F/uR4qEkZYdwAe7ENcjmnf0r3s8jtZW4A1UR+saJUqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pEEmouIxkJeOTm5QFiUo2q3pUe/Uf/bG/tfh9WPPk1FpsHSH5/h6Kwa7j26MOs1By
	 8W3381F91LzKIRoJ0YR63fLFDivTa7GwgDK67hDBz9UvisqmPpkSU40JyCKDfjIIQ8
	 G3I1k1GnRvanN1LD618nLAuK+vtm2TZbLGE+UHw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	syzbot <syzkaller@googlegroups.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 286/627] ipv6: add a retry logic in net6_rt_notify()
Date: Tue, 12 Aug 2025 19:29:41 +0200
Message-ID: <20250812173430.194382260@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ea2f921db7a483a526058c5b5b8162edd88dabe5 ]

inet6_rt_notify() can be called under RCU protection only.
This means the route could be changed concurrently
and rt6_fill_node() could return -EMSGSIZE.

Re-size the skb when this happens and retry, removing
one WARN_ON() that syzbot was able to trigger:

WARNING: CPU: 3 PID: 6291 at net/ipv6/route.c:6342 inet6_rt_notify+0x475/0x4b0 net/ipv6/route.c:6342
Modules linked in:
CPU: 3 UID: 0 PID: 6291 Comm: syz.0.77 Not tainted 6.16.0-rc7-syzkaller #0 PREEMPT(full)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
 RIP: 0010:inet6_rt_notify+0x475/0x4b0 net/ipv6/route.c:6342
Code: fc ff ff e8 6d 52 ea f7 e9 47 fc ff ff 48 8b 7c 24 08 4c 89 04 24 e8 5a 52 ea f7 4c 8b 04 24 e9 94 fd ff ff e8 9c fe 84 f7 90 <0f> 0b 90 e9 bd fd ff ff e8 6e 52 ea f7 e9 bb fb ff ff 48 89 df e8
RSP: 0018:ffffc900035cf1d8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffc900035cf540 RCX: ffffffff8a36e790
RDX: ffff88802f7e8000 RSI: ffffffff8a36e9d4 RDI: 0000000000000005
RBP: ffff88803c230f00 R08: 0000000000000005 R09: 00000000ffffffa6
R10: 00000000ffffffa6 R11: 0000000000000001 R12: 00000000ffffffa6
R13: 0000000000000900 R14: ffff888032ea4100 R15: 0000000000000000
FS:  00007fac7b89a6c0(0000) GS:ffff8880d6a20000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fac7b899f98 CR3: 0000000034b3f000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
  ip6_route_mpath_notify+0xde/0x280 net/ipv6/route.c:5356
  ip6_route_multipath_add+0x1181/0x1bd0 net/ipv6/route.c:5536
  inet6_rtm_newroute+0xe4/0x1a0 net/ipv6/route.c:5647
  rtnetlink_rcv_msg+0x95e/0xe90 net/core/rtnetlink.c:6944
  netlink_rcv_skb+0x155/0x420 net/netlink/af_netlink.c:2552
  netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
  netlink_unicast+0x58d/0x850 net/netlink/af_netlink.c:1346
  netlink_sendmsg+0x8d1/0xdd0 net/netlink/af_netlink.c:1896
  sock_sendmsg_nosec net/socket.c:712 [inline]
  __sock_sendmsg net/socket.c:727 [inline]
  ____sys_sendmsg+0xa95/0xc70 net/socket.c:2566
  ___sys_sendmsg+0x134/0x1d0 net/socket.c:2620

Fixes: 169fd62799e8 ("ipv6: Get rid of RTNL for SIOCADDRT and RTM_NEWROUTE.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Link: https://patch.msgid.link/20250725140725.3626540-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 7b9e49be7164..38016f5b2291 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6321,8 +6321,9 @@ static int inet6_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 void inet6_rt_notify(int event, struct fib6_info *rt, struct nl_info *info,
 		     unsigned int nlm_flags)
 {
-	struct sk_buff *skb;
 	struct net *net = info->nl_net;
+	struct sk_buff *skb;
+	size_t sz;
 	u32 seq;
 	int err;
 
@@ -6330,17 +6331,21 @@ void inet6_rt_notify(int event, struct fib6_info *rt, struct nl_info *info,
 	seq = info->nlh ? info->nlh->nlmsg_seq : 0;
 
 	rcu_read_lock();
-
-	skb = nlmsg_new(rt6_nlmsg_size(rt), GFP_ATOMIC);
+	sz = rt6_nlmsg_size(rt);
+retry:
+	skb = nlmsg_new(sz, GFP_ATOMIC);
 	if (!skb)
 		goto errout;
 
 	err = rt6_fill_node(net, skb, rt, NULL, NULL, NULL, 0,
 			    event, info->portid, seq, nlm_flags);
 	if (err < 0) {
-		/* -EMSGSIZE implies BUG in rt6_nlmsg_size() */
-		WARN_ON(err == -EMSGSIZE);
 		kfree_skb(skb);
+		/* -EMSGSIZE implies needed space grew under us. */
+		if (err == -EMSGSIZE) {
+			sz = max(rt6_nlmsg_size(rt), sz << 1);
+			goto retry;
+		}
 		goto errout;
 	}
 
-- 
2.39.5



