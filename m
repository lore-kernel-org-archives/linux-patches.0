Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5ED14A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5jQ1xqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD826C433C8;
	Mon, 23 Oct 2023 11:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059118;
	bh=Y/G+VgHanGmmxXfMKNFPe3+QOJUz5FeDZmJMujhKARE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5jQ1xqu6Jp2fBzHoSSkoGiZ+rs1vQh1kFKv3z/+sbh6ZNYhGEx+Cngus2c8rXILW
	 o3H0+FvBKsMhiNMurT64RDjNp/4O2PCryJh1+T2NgXd73CZqHM9jzKgdrZCV8uPCi9
	 iNs3cM4gc9hKqAkysWpmzVIBXD5wFibfHX34ZHvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.5 070/241] ipv4: fib: annotate races around nh->nh_saddr_genid and nh->nh_saddr
Date: Mon, 23 Oct 2023 12:54:16 +0200
Message-ID: <20231023104835.604463211@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 195374d893681da43a39796e53b30ac4f20400c4 upstream.

syzbot reported a data-race while accessing nh->nh_saddr_genid [1]

Add annotations, but leave the code lazy as intended.

[1]
BUG: KCSAN: data-race in fib_select_path / fib_select_path

write to 0xffff8881387166f0 of 4 bytes by task 6778 on cpu 1:
fib_info_update_nhc_saddr net/ipv4/fib_semantics.c:1334 [inline]
fib_result_prefsrc net/ipv4/fib_semantics.c:1354 [inline]
fib_select_path+0x292/0x330 net/ipv4/fib_semantics.c:2269
ip_route_output_key_hash_rcu+0x659/0x12c0 net/ipv4/route.c:2810
ip_route_output_key_hash net/ipv4/route.c:2644 [inline]
__ip_route_output_key include/net/route.h:134 [inline]
ip_route_output_flow+0xa6/0x150 net/ipv4/route.c:2872
send4+0x1f5/0x520 drivers/net/wireguard/socket.c:61
wg_socket_send_skb_to_peer+0x94/0x130 drivers/net/wireguard/socket.c:175
wg_socket_send_buffer_to_peer+0xd6/0x100 drivers/net/wireguard/socket.c:200
wg_packet_send_handshake_initiation drivers/net/wireguard/send.c:40 [inline]
wg_packet_handshake_send_worker+0x10c/0x150 drivers/net/wireguard/send.c:51
process_one_work kernel/workqueue.c:2630 [inline]
process_scheduled_works+0x5b8/0xa30 kernel/workqueue.c:2703
worker_thread+0x525/0x730 kernel/workqueue.c:2784
kthread+0x1d7/0x210 kernel/kthread.c:388
ret_from_fork+0x48/0x60 arch/x86/kernel/process.c:147
ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304

read to 0xffff8881387166f0 of 4 bytes by task 6759 on cpu 0:
fib_result_prefsrc net/ipv4/fib_semantics.c:1350 [inline]
fib_select_path+0x1cb/0x330 net/ipv4/fib_semantics.c:2269
ip_route_output_key_hash_rcu+0x659/0x12c0 net/ipv4/route.c:2810
ip_route_output_key_hash net/ipv4/route.c:2644 [inline]
__ip_route_output_key include/net/route.h:134 [inline]
ip_route_output_flow+0xa6/0x150 net/ipv4/route.c:2872
send4+0x1f5/0x520 drivers/net/wireguard/socket.c:61
wg_socket_send_skb_to_peer+0x94/0x130 drivers/net/wireguard/socket.c:175
wg_socket_send_buffer_to_peer+0xd6/0x100 drivers/net/wireguard/socket.c:200
wg_packet_send_handshake_initiation drivers/net/wireguard/send.c:40 [inline]
wg_packet_handshake_send_worker+0x10c/0x150 drivers/net/wireguard/send.c:51
process_one_work kernel/workqueue.c:2630 [inline]
process_scheduled_works+0x5b8/0xa30 kernel/workqueue.c:2703
worker_thread+0x525/0x730 kernel/workqueue.c:2784
kthread+0x1d7/0x210 kernel/kthread.c:388
ret_from_fork+0x48/0x60 arch/x86/kernel/process.c:147
ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304

value changed: 0x959d3217 -> 0x959d3218

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 6759 Comm: kworker/u4:15 Not tainted 6.6.0-rc4-syzkaller-00029-gcbf3a2cb156a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/06/2023
Workqueue: wg-kex-wg1 wg_packet_handshake_send_worker

Fixes: 436c3b66ec98 ("ipv4: Invalidate nexthop cache nh_saddr more correctly.")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20231017192304.82626-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_semantics.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1325,15 +1325,18 @@ __be32 fib_info_update_nhc_saddr(struct
 				 unsigned char scope)
 {
 	struct fib_nh *nh;
+	__be32 saddr;
 
 	if (nhc->nhc_family != AF_INET)
 		return inet_select_addr(nhc->nhc_dev, 0, scope);
 
 	nh = container_of(nhc, struct fib_nh, nh_common);
-	nh->nh_saddr = inet_select_addr(nh->fib_nh_dev, nh->fib_nh_gw4, scope);
-	nh->nh_saddr_genid = atomic_read(&net->ipv4.dev_addr_genid);
+	saddr = inet_select_addr(nh->fib_nh_dev, nh->fib_nh_gw4, scope);
 
-	return nh->nh_saddr;
+	WRITE_ONCE(nh->nh_saddr, saddr);
+	WRITE_ONCE(nh->nh_saddr_genid, atomic_read(&net->ipv4.dev_addr_genid));
+
+	return saddr;
 }
 
 __be32 fib_result_prefsrc(struct net *net, struct fib_result *res)
@@ -1347,8 +1350,9 @@ __be32 fib_result_prefsrc(struct net *ne
 		struct fib_nh *nh;
 
 		nh = container_of(nhc, struct fib_nh, nh_common);
-		if (nh->nh_saddr_genid == atomic_read(&net->ipv4.dev_addr_genid))
-			return nh->nh_saddr;
+		if (READ_ONCE(nh->nh_saddr_genid) ==
+		    atomic_read(&net->ipv4.dev_addr_genid))
+			return READ_ONCE(nh->nh_saddr);
 	}
 
 	return fib_info_update_nhc_saddr(net, nhc, res->fi->fib_scope);


