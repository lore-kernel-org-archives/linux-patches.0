Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDE419DF9C;
	Thu, 15 Aug 2024 13:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729282; cv=none; b=QIxYVF6zdpvI51epZ5Yupljxi0FQde/T1a7SLbDM6Otv8eZXCDqjTjpnsluFhgm/kG31ePcnq6qFkqsZoxWJVNRmC5JSCcYnDGCeafinCpg/m8huX7XlkMubmD2dtepvQideZhasEgqr6JQiVhk1R5OpTx58NqYwIWXkXPBhKZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729282; c=relaxed/simple;
	bh=gsIyjKJ+/4zkzKkTBU3+WQ6mGB4rVbr8vg4tqwCvlYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TFX+sgm4w3R+/KSgf4vghNN+kv6XdNHlmjXwwbwft7Neu7xl2EWvX0B4oDfqvqFFX8Bh/i60oq9A6A8/ahbtMHs5KD9CKVjoTSWVUFBb66KN74JKDDFdRSu8UYhuryVs3wPXZrNxlr8fAidJ1Xpl/uJxexxp5qJjiicvNCRXH2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wVsUTcqh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wVsUTcqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6275CC4AF0A;
	Thu, 15 Aug 2024 13:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729281;
	bh=gsIyjKJ+/4zkzKkTBU3+WQ6mGB4rVbr8vg4tqwCvlYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wVsUTcqhERDsV81Fkc/bkBvGbhMkyuo53x6k7VVMm7EE8yCGCrsc0S4ggJMqnVRMc
	 ognp68R5jXiv6m3kQdfYdsi9zwY6LuQkWoTVps4dvXf7Mwt1hzgRUBPaM6hd/Odnle
	 SVtnpUPk7v6sLZbsC/njsgjA8aPKlK+8tuDVUQJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 048/484] tcp: annotate lockless accesses to sk->sk_err_soft
Date: Thu, 15 Aug 2024 15:18:26 +0200
Message-ID: <20240815131943.137304728@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cee1af825d65b8122627fc2efbc36c1bd51ee103 ]

This field can be read/written without lock synchronization.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 853c3bd7b791 ("tcp: fix race in tcp_write_err()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c |  2 +-
 net/ipv4/tcp_ipv4.c  |  6 +++---
 net/ipv4/tcp_timer.c |  6 +++---
 net/ipv6/tcp_ipv6.c  | 11 ++++++-----
 4 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 48d45022dedaf..d3273d6dce7e9 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3915,7 +3915,7 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	/* We passed data and got it acked, remove any soft error
 	 * log. Something worked...
 	 */
-	sk->sk_err_soft = 0;
+	WRITE_ONCE(sk->sk_err_soft, 0);
 	icsk->icsk_probes_out = 0;
 	tp->rcv_tstamp = tcp_jiffies32;
 	if (!prior_packets)
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index e9b1dcf2d463a..901c873fbaf5a 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -361,7 +361,7 @@ void tcp_v4_mtu_reduced(struct sock *sk)
 	 * for the case, if this connection will not able to recover.
 	 */
 	if (mtu < dst_mtu(dst) && ip_dont_fragment(sk, dst))
-		sk->sk_err_soft = EMSGSIZE;
+		WRITE_ONCE(sk->sk_err_soft, EMSGSIZE);
 
 	mtu = dst_mtu(dst);
 
@@ -599,7 +599,7 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 
 			tcp_done(sk);
 		} else {
-			sk->sk_err_soft = err;
+			WRITE_ONCE(sk->sk_err_soft, err);
 		}
 		goto out;
 	}
@@ -625,7 +625,7 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 		sk->sk_err = err;
 		sk_error_report(sk);
 	} else	{ /* Only an error on timeout */
-		sk->sk_err_soft = err;
+		WRITE_ONCE(sk->sk_err_soft, err);
 	}
 
 out:
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 11569900b729f..1a26130807f73 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -67,7 +67,7 @@ u32 tcp_clamp_probe0_to_user_timeout(const struct sock *sk, u32 when)
 
 static void tcp_write_err(struct sock *sk)
 {
-	sk->sk_err = sk->sk_err_soft ? : ETIMEDOUT;
+	sk->sk_err = READ_ONCE(sk->sk_err_soft) ? : ETIMEDOUT;
 	sk_error_report(sk);
 
 	tcp_write_queue_purge(sk);
@@ -110,7 +110,7 @@ static int tcp_out_of_resources(struct sock *sk, bool do_reset)
 		shift++;
 
 	/* If some dubious ICMP arrived, penalize even more. */
-	if (sk->sk_err_soft)
+	if (READ_ONCE(sk->sk_err_soft))
 		shift++;
 
 	if (tcp_check_oom(sk, shift)) {
@@ -146,7 +146,7 @@ static int tcp_orphan_retries(struct sock *sk, bool alive)
 	int retries = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_orphan_retries); /* May be zero. */
 
 	/* We know from an ICMP that something is wrong. */
-	if (sk->sk_err_soft && !alive)
+	if (READ_ONCE(sk->sk_err_soft) && !alive)
 		retries = 0;
 
 	/* However, if socket sent something recently, select some safe
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 78c7b0fb6ffe7..afdaa2e3cb6ef 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -490,8 +490,9 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 			sk_error_report(sk);		/* Wake people up to see the error (see connect in sock.c) */
 
 			tcp_done(sk);
-		} else
-			sk->sk_err_soft = err;
+		} else {
+			WRITE_ONCE(sk->sk_err_soft, err);
+		}
 		goto out;
 	case TCP_LISTEN:
 		break;
@@ -507,9 +508,9 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	if (!sock_owned_by_user(sk) && np->recverr) {
 		sk->sk_err = err;
 		sk_error_report(sk);
-	} else
-		sk->sk_err_soft = err;
-
+	} else {
+		WRITE_ONCE(sk->sk_err_soft, err);
+	}
 out:
 	bh_unlock_sock(sk);
 	sock_put(sk);
-- 
2.43.0



