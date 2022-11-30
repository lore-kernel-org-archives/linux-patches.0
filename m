Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3407E6FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC146C433C1;
	Wed, 30 Nov 2022 18:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833478;
	bh=kj0K1L8KgiADotXKOebfiv3PcpAj71fxo0GW5gjfrBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ilLB4lw/Z1bkZVY9xg8dYxjx7w1QwANrvuVACtP4Ho/JJ9znNm/aSU+RRDQ0GuKqG
	 Twfo8Vvx3q2NVA5tj5Y9X+oPpgG+/K0gdvepqok/mM9MGuL5k+YiW18rIeDtpmW9Aa
	 0+KaBuVo0WV3hQDtWtc6QlyJQJ4AxF9Cokqnk1Uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 120/206] dccp/tcp: Reset saddr on failure after inet6?_hash_connect().
Date: Wed, 30 Nov 2022 19:22:52 +0100
Message-Id: <20221130180536.101370574@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 77934dc6db0d2b111a8f2759e9ad2fb67f5cffa5 ]

When connect() is called on a socket bound to the wildcard address,
we change the socket's saddr to a local address.  If the socket
fails to connect() to the destination, we have to reset the saddr.

However, when an error occurs after inet_hash6?_connect() in
(dccp|tcp)_v[46]_conect(), we forget to reset saddr and leave
the socket bound to the address.

>From the user's point of view, whether saddr is reset or not varies
with errno.  Let's fix this inconsistent behaviour.

Note that after this patch, the repro [0] will trigger the WARN_ON()
in inet_csk_get_port() again, but this patch is not buggy and rather
fixes a bug papering over the bhash2's bug for which we need another
fix.

For the record, the repro causes -EADDRNOTAVAIL in inet_hash6_connect()
by this sequence:

  s1 = socket()
  s1.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
  s1.bind(('127.0.0.1', 10000))
  s1.sendto(b'hello', MSG_FASTOPEN, (('127.0.0.1', 10000)))
  # or s1.connect(('127.0.0.1', 10000))

  s2 = socket()
  s2.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
  s2.bind(('0.0.0.0', 10000))
  s2.connect(('127.0.0.1', 10000))  # -EADDRNOTAVAIL

  s2.listen(32)  # WARN_ON(inet_csk(sk)->icsk_bind2_hash != tb2);

[0]: https://syzkaller.appspot.com/bug?extid=015d756bbd1f8b5c8f09

Fixes: 3df80d9320bc ("[DCCP]: Introduce DCCPv6")
Fixes: 7c657876b63c ("[DCCP]: Initial implementation")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dccp/ipv4.c     | 2 ++
 net/dccp/ipv6.c     | 2 ++
 net/ipv4/tcp_ipv4.c | 2 ++
 net/ipv6/tcp_ipv6.c | 2 ++
 4 files changed, 8 insertions(+)

diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 0ea29270d7e5..5bcfa1e9a941 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -137,6 +137,8 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 * This unhashes the socket and releases the local port, if necessary.
 	 */
 	dccp_set_state(sk, DCCP_CLOSED);
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+		inet_reset_saddr(sk);
 	ip_rt_put(rt);
 	sk->sk_route_caps = 0;
 	inet->inet_dport = 0;
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index fa663518fa0e..071620622e1e 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -967,6 +967,8 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 
 late_failure:
 	dccp_set_state(sk, DCCP_CLOSED);
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+		inet_reset_saddr(sk);
 	__sk_dst_reset(sk);
 failure:
 	inet->inet_dport = 0;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 42d4af632495..0e1fbad17dbe 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -324,6 +324,8 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 * if necessary.
 	 */
 	tcp_set_state(sk, TCP_CLOSE);
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+		inet_reset_saddr(sk);
 	ip_rt_put(rt);
 	sk->sk_route_caps = 0;
 	inet->inet_dport = 0;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 51f4d330e820..93b3e7c247ce 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -339,6 +339,8 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 
 late_failure:
 	tcp_set_state(sk, TCP_CLOSE);
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+		inet_reset_saddr(sk);
 failure:
 	inet->inet_dport = 0;
 	sk->sk_route_caps = 0;
-- 
2.35.1



