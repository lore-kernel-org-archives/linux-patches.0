Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0982566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18120C433EF;
	Tue, 18 Apr 2023 12:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681820899;
	bh=x5uIg4wmpC/2g5jSH3GSvR0YH0BAYbbutORnhPmYnJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nmNcEWKWviKDsVTs4dorUiXsi7tfxtCHxllZ4I9O0m9hkMu44PIyYxF9CLjzX/5sh
	 7sNqZKVYPrerj5fzd4MjevjyUzyA+tVwLhxTwJ/RmqT5KXTLwWDiVa11h1gbdukIbY
	 BkHbhytnC9h+AIdGMseLf99op/vyOmtH8jmKfHZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8257f4dcef79de670baf@syzkaller.appspotmail.com,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 16/92] ipv6: Fix an uninit variable access bug in __ip6_make_skb()
Date: Tue, 18 Apr 2023 14:20:51 +0200
Message-Id: <20230418120305.370372349@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit ea30388baebcce37fd594d425a65037ca35e59e8 ]

Syzbot reported a bug as following:

=====================================================
BUG: KMSAN: uninit-value in arch_atomic64_inc arch/x86/include/asm/atomic64_64.h:88 [inline]
BUG: KMSAN: uninit-value in arch_atomic_long_inc include/linux/atomic/atomic-long.h:161 [inline]
BUG: KMSAN: uninit-value in atomic_long_inc include/linux/atomic/atomic-instrumented.h:1429 [inline]
BUG: KMSAN: uninit-value in __ip6_make_skb+0x2f37/0x30f0 net/ipv6/ip6_output.c:1956
 arch_atomic64_inc arch/x86/include/asm/atomic64_64.h:88 [inline]
 arch_atomic_long_inc include/linux/atomic/atomic-long.h:161 [inline]
 atomic_long_inc include/linux/atomic/atomic-instrumented.h:1429 [inline]
 __ip6_make_skb+0x2f37/0x30f0 net/ipv6/ip6_output.c:1956
 ip6_finish_skb include/net/ipv6.h:1122 [inline]
 ip6_push_pending_frames+0x10e/0x550 net/ipv6/ip6_output.c:1987
 rawv6_push_pending_frames+0xb12/0xb90 net/ipv6/raw.c:579
 rawv6_sendmsg+0x297e/0x2e60 net/ipv6/raw.c:922
 inet_sendmsg+0x101/0x180 net/ipv4/af_inet.c:827
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0xa8e/0xe70 net/socket.c:2476
 ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2530
 __sys_sendmsg net/socket.c:2559 [inline]
 __do_sys_sendmsg net/socket.c:2568 [inline]
 __se_sys_sendmsg net/socket.c:2566 [inline]
 __x64_sys_sendmsg+0x367/0x540 net/socket.c:2566
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:766 [inline]
 slab_alloc_node mm/slub.c:3452 [inline]
 __kmem_cache_alloc_node+0x71f/0xce0 mm/slub.c:3491
 __do_kmalloc_node mm/slab_common.c:967 [inline]
 __kmalloc_node_track_caller+0x114/0x3b0 mm/slab_common.c:988
 kmalloc_reserve net/core/skbuff.c:492 [inline]
 __alloc_skb+0x3af/0x8f0 net/core/skbuff.c:565
 alloc_skb include/linux/skbuff.h:1270 [inline]
 __ip6_append_data+0x51c1/0x6bb0 net/ipv6/ip6_output.c:1684
 ip6_append_data+0x411/0x580 net/ipv6/ip6_output.c:1854
 rawv6_sendmsg+0x2882/0x2e60 net/ipv6/raw.c:915
 inet_sendmsg+0x101/0x180 net/ipv4/af_inet.c:827
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0xa8e/0xe70 net/socket.c:2476
 ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2530
 __sys_sendmsg net/socket.c:2559 [inline]
 __do_sys_sendmsg net/socket.c:2568 [inline]
 __se_sys_sendmsg net/socket.c:2566 [inline]
 __x64_sys_sendmsg+0x367/0x540 net/socket.c:2566
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

It is because icmp6hdr does not in skb linear region under the scenario
of SOCK_RAW socket. Access icmp6_hdr(skb)->icmp6_type directly will
trigger the uninit variable access bug.

Use a local variable icmp6_type to carry the correct value in different
scenarios.

Fixes: 14878f75abd5 ("[IPV6]: Add ICMPMsgStats MIB (RFC 4293) [rev 2]")
Reported-by: syzbot+8257f4dcef79de670baf@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=3d605ec1d0a7f2a269a1a6936ac7f2b85975ee9c
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_output.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 457eb07be4828..8231a7a3dd035 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1855,8 +1855,13 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
 	IP6_UPD_PO_STATS(net, rt->rt6i_idev, IPSTATS_MIB_OUT, skb->len);
 	if (proto == IPPROTO_ICMPV6) {
 		struct inet6_dev *idev = ip6_dst_idev(skb_dst(skb));
+		u8 icmp6_type;
 
-		ICMP6MSGOUT_INC_STATS(net, idev, icmp6_hdr(skb)->icmp6_type);
+		if (sk->sk_socket->type == SOCK_RAW && !inet_sk(sk)->hdrincl)
+			icmp6_type = fl6->fl6_icmp_type;
+		else
+			icmp6_type = icmp6_hdr(skb)->icmp6_type;
+		ICMP6MSGOUT_INC_STATS(net, idev, icmp6_type);
 		ICMP6_INC_STATS(net, idev, ICMP6_MIB_OUTMSGS);
 	}
 
-- 
2.39.2



