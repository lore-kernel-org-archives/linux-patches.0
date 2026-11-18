Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032306;
	b=ItHCgwiI5hxh2AxgEJSeWvXNwWjvq7v3TH3X6uO7IzyMEbz14lmzAJoVgzus4l5E4CTr
	 UPvzWzVTbifXM/RydThoIXnx/e6j6k7nWXwt/O2Bshqhp7T6fxcmHAZofDW/KMp3Nbx9l
	 nrzvdbi6LhcBlOjbHkAeWvc93eycQe+APQ/ecEM2faCleBB7JOjmlO9+B6PQswJ1II9BH
	 SSk2prJEPIhN4/xF385cLLJEhtZyo66CpjbN0bT+vxiSvh44B1VZ0kHzFYVIINo9CUYx3
	 3P0CAIdQVo/kSSdOhdwNoiiyPxbeDT74cwlE4lAbuF8CEuhNOFQ9UOojNled9orD5ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zOC18b0d8OqE3Q3zyUUlfoTBM0C5ZmVNd1fy+ZXLxSM=;
	b=ouM2TLDylVHcnUICMl98EAALRQNrOh7Ysw4OhtFhjRhxYdklDmxgkX7yNOQ9dlCFt4YR
	 WvpQYqP+4SmAxC91nMOS3CEagsRH7S34wivTqjdP9SBEU9oDZ8y3nba94tiTdxzA2ZuHk
	 0fPMMn9+HMO116c8XY2R3zyNzAmtXoNqNY1Uzq//036TkX2RQXKncXb9otKvBr6pb/Id5
	 MUNU9YSi0hrlsN/81FtU3FIQWPo49SoI5W9MSQ1b3i0f60Sol1G8a+L/CvKSgeP3GYJEj
	 UEKLbgdZLBylGp0vj+uw0ARPwGxuvnc2JYtKKlcm1ufMtgHOQW0redv28LtBkLEq7wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FYcESxpF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEBA606A32A;
	Wed, 18 Nov 2026 20:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FYcESxpF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019F31F000C4;
	Wed, 18 Nov 2026 20:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032305;
	bh=zOC18b0d8OqE3Q3zyUUlfoTBM0C5ZmVNd1fy+ZXLxSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FYcESxpF7oG3uOBsrKVE3GwvlQwYkxnuVPI4+r7gt5pP6lfQX9GAkLmwevXh1oziu
	 QUDfhi4Fc0y0BvigADN8XycvhiB3h+uqmAkCtS/ieqY6wBSe7Lgwr3/x/W4xuJMmU8
	 dO0jrvisfN1xSEFp0OSKGE0cvq8Uw66NNwgrLYjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1328/1756] net: use the full socket in sk_mc_loop()
Date: Wed, 18 Nov 2026 15:57:35 +0100
Message-ID: <20261118150102.276250590@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>

[ Upstream commit 31b564f70d8819a1c11d0fd504fe582fc0e0f0cf ]

sk_mc_loop() is called from ip_mc_output() and ip6_finish_output2()
with skb->sk, which is not always a full socket:

- Since commit ca6fb0651883 ("tcp: attach SYNACK messages to request
  sockets instead of listener"), a SYNACK is attached to its request
  socket.

- Since commit 79636038d37e ("ipv4: tcp: give socket pointer to control
  skbs"), an ACK or RST sent by ip_send_unicast_reply() on behalf of a
  TIME_WAIT socket is attached to the timewait socket.

When such a packet uses a multicast route, inet_test_bit(MC_LOOP, sk)
reads inet_flags past the end of the request or timewait socket.

This happens for instance when a SYN with a multicast source address
reaches a listener, after being looped back with its dst attached, so
that ip_rcv_finish_core() skips the martian source check. A raw
IP_HDRINCL socket sending to a local address does this, as does
re-injection by nft dup or the iptables TEE target. The destination
can also come from a source route option, or from a route of type
multicast covering a unicast prefix.

BUG: KASAN: slab-out-of-bounds in sk_mc_loop+0x111/0x170
Read of size 8 at addr ffff88800f2b7f10 by task repro-raw/470
Call Trace:
 <IRQ>
 sk_mc_loop+0x111/0x170
 ip_mc_output+0x355/0x930
 ip_build_and_send_pkt+0xb87/0xc50
 tcp_v4_send_synack+0x500/0x6f0
 tcp_conn_request+0x2135/0x2d90
 tcp_v4_conn_request+0xa5/0x210
 tcp_rcv_state_process+0x136e/0x6920
 tcp_v4_do_rcv+0x339/0xb10
 tcp_v4_rcv+0x34ab/0x3ab0
 ip_protocol_deliver_rcu+0x6e/0x3e0
 ip_local_deliver_finish+0x34d/0x510
 ip_local_deliver+0x1bc/0x310
 ip_rcv+0x390/0x410
 __netif_receive_skb_one_core+0x199/0x1e0
 process_backlog+0x239/0x680
 __napi_poll+0xb5/0x650
 net_rx_action+0x980/0xd60
 handle_softirqs+0x17f/0x590
 do_softirq+0x3f/0x60
 </IRQ>

The buggy address belongs to the object at ffff88800f2b7d60
 which belongs to the cache request_sock_TCP of size 312
The buggy address is located 120 bytes to the right of
 allocated 312-byte region [ffff88800f2b7d60, ffff88800f2b7e98)

Use sk_const_to_full_sk(), which restores the behavior from before
the two commits above: a request socket uses the setting of its
listener, and a timewait socket gets the default (loop back), as the
per-cpu control socket used before had.

Fixes: ca6fb0651883 ("tcp: attach SYNACK messages to request sockets instead of listener")
Fixes: 79636038d37e ("ipv4: tcp: give socket pointer to control skbs")
Signed-off-by: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
[edumazet: rewrote the changelog, added the TIME_WAIT case]
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261012101029.927296-2-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/sock.c b/net/core/sock.c
index 6a718b8e1dde5..c71b175d13206 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -762,6 +762,7 @@ bool sk_mc_loop(const struct sock *sk)
 {
 	if (dev_recursion_level())
 		return false;
+	sk = sk_const_to_full_sk(sk);
 	if (!sk)
 		return true;
 	/* IPV6_ADDRFORM can change sk->sk_family under us. */
-- 
2.53.0



