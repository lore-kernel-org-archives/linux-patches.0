Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590292108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:37:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE53C4339E;
	Mon, 24 Apr 2023 13:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343429;
	bh=9ymkHp6Ywc7jXzWKcTtJVLM61I5sc6peE3aUbAY9LqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7EGFaHQSy9Q765OX2XgDx329O1SoEv13TOMH0k9itvdNAsIPZsvAi2UtuuCOZeHD
	 SnI2rHGJdU9SIFS2pbNldUJ8hK39ZZCygEydss717Jq2e5fJ4c0BmcNbcTgxJJnrU0
	 lMtRqCdGqvvRpav6MYl7Qiyv2YITUYXDo23TpKCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Ziyang Xuan <william.xuanziyang@huawei.com>
Subject: [PATCH 4.14 21/28] udp: Call inet6_destroy_sock() in setsockopt(IPV6_ADDRFORM).
Date: Mon, 24 Apr 2023 15:18:42 +0200
Message-Id: <20230424131122.047749393@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131121.331252806@linuxfoundation.org>
References: <20230424131121.331252806@linuxfoundation.org>
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

commit 21985f43376cee092702d6cb963ff97a9d2ede68 upstream.

Commit 4b340ae20d0e ("IPv6: Complete IPV6_DONTFRAG support") forgot
to add a change to free inet6_sk(sk)->rxpmtu while converting an IPv6
socket into IPv4 with IPV6_ADDRFORM.  After conversion, sk_prot is
changed to udp_prot and ->destroy() never cleans it up, resulting in
a memory leak.

This is due to the discrepancy between inet6_destroy_sock() and
IPV6_ADDRFORM, so let's call inet6_destroy_sock() from IPV6_ADDRFORM
to remove the difference.

However, this is not enough for now because rxpmtu can be changed
without lock_sock() after commit 03485f2adcde ("udpv6: Add lockless
sendmsg() support").  We will fix this case in the following patch.

Note we will rename inet6_destroy_sock() to inet6_cleanup_sock() and
remove unnecessary inet6_destroy_sock() calls in sk_prot->destroy()
in the future.

Fixes: 4b340ae20d0e ("IPv6: Complete IPV6_DONTFRAG support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ipv6.h       |    1 +
 net/ipv6/af_inet6.c      |    6 ++++++
 net/ipv6/ipv6_sockglue.c |   20 ++++++++------------
 3 files changed, 15 insertions(+), 12 deletions(-)

--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -942,6 +942,7 @@ void ipv6_icmp_error(struct sock *sk, st
 void ipv6_local_error(struct sock *sk, int err, struct flowi6 *fl6, u32 info);
 void ipv6_local_rxpmtu(struct sock *sk, struct flowi6 *fl6, u32 mtu);
 
+void inet6_cleanup_sock(struct sock *sk);
 int inet6_release(struct socket *sock);
 int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len);
 int inet6_getname(struct socket *sock, struct sockaddr *uaddr, int *uaddr_len,
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -480,6 +480,12 @@ void inet6_destroy_sock(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(inet6_destroy_sock);
 
+void inet6_cleanup_sock(struct sock *sk)
+{
+	inet6_destroy_sock(sk);
+}
+EXPORT_SYMBOL_GPL(inet6_cleanup_sock);
+
 /*
  *	This does both peername and sockname.
  */
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -178,9 +178,6 @@ static int do_ipv6_setsockopt(struct soc
 		if (optlen < sizeof(int))
 			goto e_inval;
 		if (val == PF_INET) {
-			struct ipv6_txoptions *opt;
-			struct sk_buff *pktopt;
-
 			if (sk->sk_type == SOCK_RAW)
 				break;
 
@@ -211,7 +208,6 @@ static int do_ipv6_setsockopt(struct soc
 				break;
 			}
 
-			fl6_free_socklist(sk);
 			__ipv6_sock_mc_close(sk);
 			__ipv6_sock_ac_close(sk);
 
@@ -246,14 +242,14 @@ static int do_ipv6_setsockopt(struct soc
 				sk->sk_socket->ops = &inet_dgram_ops;
 				sk->sk_family = PF_INET;
 			}
-			opt = xchg((__force struct ipv6_txoptions **)&np->opt,
-				   NULL);
-			if (opt) {
-				atomic_sub(opt->tot_len, &sk->sk_omem_alloc);
-				txopt_put(opt);
-			}
-			pktopt = xchg(&np->pktoptions, NULL);
-			kfree_skb(pktopt);
+
+			/* Disable all options not to allocate memory anymore,
+			 * but there is still a race.  See the lockless path
+			 * in udpv6_sendmsg() and ipv6_local_rxpmtu().
+			 */
+			np->rxopt.all = 0;
+
+			inet6_cleanup_sock(sk);
 
 			/*
 			 * ... and add it to the refcnt debug socks count


