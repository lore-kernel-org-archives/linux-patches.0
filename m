Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8409B352077;
	Tue, 26 Aug 2025 14:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218827; cv=none; b=jO7N0FmqVL8i+jSRUtxw/KdJVGwXXj170+rE3QW6AFLf32tIIpdB6mNF+AC2NfC+m0HQgIFYoPsgnZCinGfBIWqVLjbZrz+sSpR+vE4RTpQiOqYSxXwf4i4NpltVrgghooIJtwqaWt4lut2G1YwfpXZpcOwIjxhNA5uy7DfYNG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218827; c=relaxed/simple;
	bh=tuzWsBppfOqJ6t3f3yU5VMyJbZP6+A+XFhmZoHXaI0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JK/ooBIWvR+SELFDkhDmuebgrVUwLAtZdPfu8Y5eBQY7YZAKaGtx6ouNyzQ2OuVr3b+EFn8qiqsHyd8OFfI+n+fZMhlLpFAshG6xDcr22kQV3egm67bmpwMMEPqSovYXYzjXOs4ncHhPDKt9yJM8xjy2+0/YvMp+SzZ2SqJAA8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1uG93jUN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1uG93jUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180FFC4CEF1;
	Tue, 26 Aug 2025 14:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218827;
	bh=tuzWsBppfOqJ6t3f3yU5VMyJbZP6+A+XFhmZoHXaI0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1uG93jUN+F6zwRNoGGnjtuYyHKUN3E+a+nt3t/JcV1M+cW3vc2NuTYc3YMEiBBzzs
	 /LUghOta3aq/Xj/XxBiI7C7hQ4G0kBHvn3k1vRttFxy2YvIEqn3apVYKJelPNwEHDa
	 muDvXKb7aCiZnkTIliTdv+s0XSpL5CuyTfWc2S3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+27d7cfbc93457e472e00@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 147/403] pptp: fix pptp_xmit() error path
Date: Tue, 26 Aug 2025 13:07:53 +0200
Message-ID: <20250826110910.843736482@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ae633388cae349886f1a3cfb27aa092854b24c1b ]

I accidentally added a bug in pptp_xmit() that syzbot caught for us.

Only call ip_rt_put() if a route has been allocated.

BUG: unable to handle page fault for address: ffffffffffffffdb
PGD df3b067 P4D df3b067 PUD df3d067 PMD 0
Oops: Oops: 0002 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 6346 Comm: syz.0.336 Not tainted 6.16.0-next-20250804-syzkaller #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:arch_atomic_add_return arch/x86/include/asm/atomic.h:85 [inline]
RIP: 0010:raw_atomic_sub_return_release include/linux/atomic/atomic-arch-fallback.h:846 [inline]
RIP: 0010:atomic_sub_return_release include/linux/atomic/atomic-instrumented.h:327 [inline]
RIP: 0010:__rcuref_put include/linux/rcuref.h:109 [inline]
RIP: 0010:rcuref_put+0x172/0x210 include/linux/rcuref.h:173
Call Trace:
 <TASK>
 dst_release+0x24/0x1b0 net/core/dst.c:167
 ip_rt_put include/net/route.h:285 [inline]
 pptp_xmit+0x14b/0x1a90 drivers/net/ppp/pptp.c:267
 __ppp_channel_push+0xf2/0x1c0 drivers/net/ppp/ppp_generic.c:2166
 ppp_channel_push+0x123/0x660 drivers/net/ppp/ppp_generic.c:2198
 ppp_write+0x2b0/0x400 drivers/net/ppp/ppp_generic.c:544
 vfs_write+0x27b/0xb30 fs/read_write.c:684
 ksys_write+0x145/0x250 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: de9c4861fb42 ("pptp: ensure minimal skb length in pptp_xmit()")
Reported-by: syzbot+27d7cfbc93457e472e00@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/689095a5.050a0220.1fc43d.0009.GAE@google.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250807142146.2877060-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/pptp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index 5e2f4702aa2b..83541444bc8c 100644
--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -141,13 +141,13 @@ static int pptp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 	int len;
 	unsigned char *data;
 	__u32 seq_recv;
-	struct rtable *rt = NULL;
+	struct rtable *rt;
 	struct net_device *tdev;
 	struct iphdr  *iph;
 	int    max_headroom;
 
 	if (sk_pppox(po)->sk_state & PPPOX_DEAD)
-		goto tx_error;
+		goto tx_drop;
 
 	rt = ip_route_output_ports(net, &fl4, NULL,
 				   opt->dst_addr.sin_addr.s_addr,
@@ -155,7 +155,7 @@ static int pptp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 				   0, 0, IPPROTO_GRE,
 				   RT_TOS(0), 0);
 	if (IS_ERR(rt))
-		goto tx_error;
+		goto tx_drop;
 
 	tdev = rt->dst.dev;
 
@@ -251,6 +251,7 @@ static int pptp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 
 tx_error:
 	ip_rt_put(rt);
+tx_drop:
 	kfree_skb(skb);
 	return 1;
 }
-- 
2.39.5



