Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE54188006;
	Tue, 30 Jul 2024 16:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355357; cv=none; b=YVmytMbZhm4HEqEiZ/EWyLyWF/2d05z8yN9VbL8nWKb/d4dU89hJuJqxY11TKYOSgXu8YgsTk4cJPQn9q3C213D7/p6+bhlRkvKguFDzpDDR10hFzUzA6x0z+BtsPI+xpVptoymz3CA+PQ8vWnazGFRaI6Cw+U1ikTHFqTA7HtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355357; c=relaxed/simple;
	bh=4HhONRtE7Z4tMfE4BesTF79sf8gl6aSCQU9edkCt4Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXLdqPcBYU65NIr6xM2HAD+Kxw3NQ73uDEDI5Xgfba/PARGtZXLcMSLBq/mHb2K6wEUNcYZNYq2kRswretAxqrURUOu8vzRF4EUsOvJ0pysmAs/FHzO1mB+29Mozw1bz0vgD1a6iEidvBw3KzH1rKHkCrnme4/Vt1L1XVptk3sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0BUvxkAi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0BUvxkAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC611C32782;
	Tue, 30 Jul 2024 16:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355357;
	bh=4HhONRtE7Z4tMfE4BesTF79sf8gl6aSCQU9edkCt4Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0BUvxkAiJaf/GDHBI/2hL0NcsCHxuyQkJ51xS+TSqU6h11D6XBcvaa3BAb+169xlE
	 xAG0+0JioHhJzEnsHXzHlOKFoB0ET41ZWLFLQGNhcndBeqDYz1t1mW/KLgGF3D+2ID
	 NlgGrZ8hyPdMXcOfoUR1SuEX6aqRuOGeaEC3mcuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/440] tcp: annotate lockless accesses to sk->sk_err_soft
Date: Tue, 30 Jul 2024 17:45:19 +0200
Message-ID: <20240730151619.118594375@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 359ffda9b736b..fa15c6951cd78 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3922,7 +3922,7 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	/* We passed data and got it acked, remove any soft error
 	 * log. Something worked...
 	 */
-	sk->sk_err_soft = 0;
+	WRITE_ONCE(sk->sk_err_soft, 0);
 	icsk->icsk_probes_out = 0;
 	tp->rcv_tstamp = tcp_jiffies32;
 	if (!prior_packets)
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index befa848fb820c..8fbb6deed3216 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -368,7 +368,7 @@ void tcp_v4_mtu_reduced(struct sock *sk)
 	 * for the case, if this connection will not able to recover.
 	 */
 	if (mtu < dst_mtu(dst) && ip_dont_fragment(sk, dst))
-		sk->sk_err_soft = EMSGSIZE;
+		WRITE_ONCE(sk->sk_err_soft, EMSGSIZE);
 
 	mtu = dst_mtu(dst);
 
@@ -609,7 +609,7 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 
 			tcp_done(sk);
 		} else {
-			sk->sk_err_soft = err;
+			WRITE_ONCE(sk->sk_err_soft, err);
 		}
 		goto out;
 	}
@@ -635,7 +635,7 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 		sk->sk_err = err;
 		sk_error_report(sk);
 	} else	{ /* Only an error on timeout */
-		sk->sk_err_soft = err;
+		WRITE_ONCE(sk->sk_err_soft, err);
 	}
 
 out:
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 016f9eff49b40..fe23a427f6a9d 100644
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
index 4b0e05349862d..848175e0be081 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -497,8 +497,9 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
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
@@ -514,9 +515,9 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
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



