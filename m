Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027984;
	b=oqV3Ht7Xumoa8mS6WrXxQ3lcCbWcbZSn2+UT1UB4tx0dY72LKgddbLYz7Kpf6iMUxaod
	 Six0hiiE3/G5CBKzcI32vAHIbmKaBusb6pH0omiu0RJ87bTKbuiLnSqQn3WK1aAdEuL4T
	 hHRYEykmxekBMgvngju9KuLuzYcz+9XO+OjBSpAcb2ORvcDVLrHqUswxaZCyRPkMuVEyf
	 6Nuqug8OfzAcUnFULROpi/nXrawY9KKJADiWkSmKjFGKIhDjEhXmMDustBfkT76gAPd1+
	 sjbcVmuwDIJ78jB/aqvHD9l5zs9AIRZsjWbPWqQ6DXSZ+PZyNBGIoAkoRDv/avZUNuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027984;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yScv0tnH78QijDCAsUjX2el6wTh5WTgzlbUuIlB1Mz4=;
	b=QsO5LB3pz1s7BzOJc8TiX33Wgd0KxH+muBGymuX6KuXLB3SGSOrdeOJJhnkWf2ZoEfEz
	 6sozRWBHahBwy0idQOT4b1d1cYHlLhjTPbwKShBpjZr6S+AhY0mS2QOpPakMtMFfp9CCT
	 Y430/ZhaoWciTO/f/dd1JEtgd3XUqePSnYSN5SPc4B2pBKuluoePyQW5FjDjwpIfKAE5p
	 t0uTV0k2g+yE4CRObfvRnou9KtvzU14zZeNDq/6wjh+v/q51iKV2/vbkGy3jB4WHQJg2c
	 Zo4ZnAOYTfjHlRaBo31VS8NLFihgJ+50nnmKkhhTbqoLY6SLPVtFZCggBd7Vs6cQfqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y36qGWro;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BD3606A320;
	Wed, 18 Nov 2026 18:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y36qGWro
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7743C1F000C4;
	Wed, 18 Nov 2026 18:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027984;
	bh=yScv0tnH78QijDCAsUjX2el6wTh5WTgzlbUuIlB1Mz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y36qGWroq60Hm6rf+p1hYo2poAnQRqfeDr4C6Alvk5AZcb9TDyCQjtwLb5Pvcw+cs
	 ywBU7O9XHmJDKoP6W9sL+bezaM9PeYnxutbiuhh3SxKY4OWHUXdZrBh0Ys1TBpU2Pg
	 kWfhRIQdMzEAbuxiqvu+WBisRx5cGmozT1qQY1dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1983/2151] gtp: hold RCU in gtp_genl_send_echo_req()
Date: Wed, 18 Nov 2026 16:01:58 +0100
Message-ID: <20261118150233.970679560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit a204e9c001dfafe83cac01b16508b1cf5c953355 ]

Such function is invoked in process context, performs an RCU device
lookup and dereference the found device with no additional protection.

  =============================
  WARNING: suspicious RCU usage
  7.3.0-virtme #7 Not tainted
  -----------------------------
  net/core/dev.c:1047 RCU-list traversed in non-reader section!!

  other info that might help us debug this:

  rcu_scheduler_active = 2, debug_locks = 1
  locks held by python3/233: 2, last CPU#5:
   #0: ffffffffbab93268 (cb_lock){++++}-{4:4}, at: genl_rcv+0x19/0x40
   #1: ffffffffbab93320 (genl_mutex){+.+.}-{4:4}, at:
                                                genl_rcv_msg+0x12c/0x160

  stack backtrace:
  CPU: 5 UID: 0 PID: 233 Comm: python3 Not tainted 7.3.0#7 PREEMPT(full)
  Hardware name: Bochs, BIOS Bochs 01/01/2011
  Call Trace:
   <TASK>
   dump_stack_lvl+0x6f/0xb0
   lockdep_rcu_suspicious.cold+0x37/0x8e
   dev_get_by_index_rcu+0x135/0x180
   gtp_find_dev+0xe7/0x360 [gtp]
   gtp_genl_send_echo_req+0x298/0xb30 [gtp]
   genl_family_rcv_msg_doit+0x20f/0x310
   genl_family_rcv_msg+0x3a8/0x640
   genl_rcv_msg+0xbb/0x160
   netlink_rcv_skb+0x154/0x3a0
   genl_rcv+0x28/0x40
   netlink_unicast+0x54b/0x860
   netlink_sendmsg+0x7fb/0xf60
   __sys_sendto+0x3d6/0x450
   __x64_sys_sendto+0xe4/0x1f0
   do_syscall_64+0xff/0x530
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  RIP: 0033:0x7ffa43b0256e
  Code: 4d 89 d8 e8 d4 bd 00 00 4c 8b 5d f8 41 8b 93 08 03 00 00 59 5e 48 83
   f8 fc 74 11 c9 c3 0f 1f 80 00 00 00 00 48 8b 45 10 0f 05 <c9> c3 83 e2 39
   83 fa 08 75 e7 e8 03 ff ff ff 0f 1f 00 f3 0f 1e fa
  RSP: 002b:00007ffd3b8828d0 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
  RAX: ffffffffffffffda RBX: 00007ffd3b8829e0 RCX: 00007ffa43b0256e
  RDX: 0000000000000034 RSI: 00007ffa3519d0d0 RDI: 0000000000000006
  RBP: 00007ffd3b8828e0 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000202 R12: 00007ffa351cc0c0
  R13: 00007ffd3b8829e0 R14: 00007ffa354ca130 R15: 00007ffa4433d498
   </TASK>

Add the missing RCU guards and keep it for the whole function body,
while the RCU-protected device is used.

Found by code inspection, validated explicitly testing the relevant
code path.

Fixes: d33bd757d362 ("gtp: Implement GTP echo request")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Link: https://patch.msgid.link/ed27d133fe73afd377d3fa4e553c34e7987b6dd9.1792744478.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 779ab090ef149..f27d3f891a740 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -2355,9 +2355,9 @@ static int gtp_genl_send_echo_req(struct sk_buff *skb, struct genl_info *info)
 	struct gtp_dev *gtp;
 	struct flowi4 fl4;
 	struct rtable *rt;
+	int len, ret = 0;
 	struct sock *sk;
 	__be16 port;
-	int len;
 
 	if (!info->attrs[GTPA_VERSION] ||
 	    !info->attrs[GTPA_LINK] ||
@@ -2369,14 +2369,21 @@ static int gtp_genl_send_echo_req(struct sk_buff *skb, struct genl_info *info)
 	dst_ip = nla_get_be32(info->attrs[GTPA_PEER_ADDRESS]);
 	src_ip = nla_get_be32(info->attrs[GTPA_MS_ADDRESS]);
 
+	rcu_read_lock();
 	gtp = gtp_find_dev(sock_net(skb->sk), info->attrs);
-	if (!gtp)
-		return -ENODEV;
+	if (!gtp) {
+		ret = -ENODEV;
+		goto unlock;
+	}
 
-	if (!gtp->sk_created)
-		return -EOPNOTSUPP;
-	if (!(gtp->dev->flags & IFF_UP))
-		return -ENETDOWN;
+	if (!gtp->sk_created) {
+		ret = -EOPNOTSUPP;
+		goto unlock;
+	}
+	if (!(gtp->dev->flags & IFF_UP)) {
+		ret = -ENETDOWN;
+		goto unlock;
+	}
 
 	if (version == GTP_V0) {
 		struct gtp0_header *gtp0_h;
@@ -2385,8 +2392,10 @@ static int gtp_genl_send_echo_req(struct sk_buff *skb, struct genl_info *info)
 			sizeof(struct iphdr) + sizeof(struct udphdr);
 
 		skb_to_send = netdev_alloc_skb_ip_align(gtp->dev, len);
-		if (!skb_to_send)
-			return -ENOMEM;
+		if (!skb_to_send) {
+			ret = -ENOMEM;
+			goto unlock;
+		}
 
 		sk = gtp->sk0;
 		port = htons(GTP0_PORT);
@@ -2402,8 +2411,10 @@ static int gtp_genl_send_echo_req(struct sk_buff *skb, struct genl_info *info)
 			sizeof(struct iphdr) + sizeof(struct udphdr);
 
 		skb_to_send = netdev_alloc_skb_ip_align(gtp->dev, len);
-		if (!skb_to_send)
-			return -ENOMEM;
+		if (!skb_to_send) {
+			ret = -ENOMEM;
+			goto unlock;
+		}
 
 		sk = gtp->sk1u;
 		port = htons(GTP1U_PORT);
@@ -2413,7 +2424,8 @@ static int gtp_genl_send_echo_req(struct sk_buff *skb, struct genl_info *info)
 		memset(gtp1u_h, 0, sizeof(struct gtp1_header_long));
 		gtp1u_build_echo_msg(gtp1u_h, GTP_ECHO_REQ);
 	} else {
-		return -ENODEV;
+		ret = -ENODEV;
+		goto unlock;
 	}
 
 	rt = ip4_route_output_gtp(&fl4, sk, dst_ip, src_ip);
@@ -2421,7 +2433,8 @@ static int gtp_genl_send_echo_req(struct sk_buff *skb, struct genl_info *info)
 		netdev_dbg(gtp->dev, "no route for echo request to %pI4\n",
 			   &dst_ip);
 		kfree_skb(skb_to_send);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto unlock;
 	}
 
 	local_bh_disable();
@@ -2435,7 +2448,10 @@ static int gtp_genl_send_echo_req(struct sk_buff *skb, struct genl_info *info)
 				    dev_net(gtp->dev)),
 			    false, 0);
 	local_bh_enable();
-	return 0;
+
+unlock:
+	rcu_read_unlock();
+	return ret;
 }
 
 static const struct nla_policy gtp_genl_policy[GTPA_MAX + 1] = {
-- 
2.53.0



