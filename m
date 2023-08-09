Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3C315AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3FAC433C8;
	Wed,  9 Aug 2023 10:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691577973;
	bh=+u7hdiWS255Wk8n8Z9+45+XhbTECz6BWoTmBuTpPzI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zWSeyBmTQM/72m8XuVFRTw3mAlF8KYGWcEWZ5oA+fkOqG+n406mwWB4zjtEprpptZ
	 aRo9Nr36idFlF08KzI3NLeJjI2GsxZdJ1LzJzwE7KLKX5D/2qr6EiOfScL6+H+ZHxo
	 Xya43q6hQ+c+2vLgv9XqXUZXyGPhwxkNKNLVd7dA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 060/165] net: annotate data-races around sk->sk_priority
Date: Wed,  9 Aug 2023 12:39:51 +0200
Message-ID: <20230809103644.778754101@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 8bf43be799d4b242ea552a14db10456446be843e ]

sk_getsockopt() runs locklessly. This means sk->sk_priority
can be read while other threads are changing its value.

Other reads also happen without socket lock being held.

Add missing annotations where needed.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c        | 6 +++---
 net/ipv4/ip_output.c   | 4 ++--
 net/ipv4/ip_sockglue.c | 2 +-
 net/ipv4/raw.c         | 2 +-
 net/ipv4/tcp_ipv4.c    | 2 +-
 net/ipv6/raw.c         | 2 +-
 net/ipv6/tcp_ipv6.c    | 3 ++-
 net/packet/af_packet.c | 6 +++---
 8 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index c0c495e0a474e..1f31a97100d4f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -800,7 +800,7 @@ EXPORT_SYMBOL(sock_no_linger);
 void sock_set_priority(struct sock *sk, u32 priority)
 {
 	lock_sock(sk);
-	sk->sk_priority = priority;
+	WRITE_ONCE(sk->sk_priority, priority);
 	release_sock(sk);
 }
 EXPORT_SYMBOL(sock_set_priority);
@@ -1210,7 +1210,7 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 		if ((val >= 0 && val <= 6) ||
 		    sockopt_ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) ||
 		    sockopt_ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
-			sk->sk_priority = val;
+			WRITE_ONCE(sk->sk_priority, val);
 		else
 			ret = -EPERM;
 		break;
@@ -1672,7 +1672,7 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case SO_PRIORITY:
-		v.val = sk->sk_priority;
+		v.val = READ_ONCE(sk->sk_priority);
 		break;
 
 	case SO_LINGER:
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 80c94749eafe2..6f6f63cf9224f 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -184,7 +184,7 @@ int ip_build_and_send_pkt(struct sk_buff *skb, const struct sock *sk,
 		ip_options_build(skb, &opt->opt, daddr, rt);
 	}
 
-	skb->priority = sk->sk_priority;
+	skb->priority = READ_ONCE(sk->sk_priority);
 	if (!skb->mark)
 		skb->mark = READ_ONCE(sk->sk_mark);
 
@@ -528,7 +528,7 @@ int __ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl,
 			     skb_shinfo(skb)->gso_segs ?: 1);
 
 	/* TODO : should we use skb->sk here instead of sk ? */
-	skb->priority = sk->sk_priority;
+	skb->priority = READ_ONCE(sk->sk_priority);
 	skb->mark = READ_ONCE(sk->sk_mark);
 
 	res = ip_local_out(net, sk, skb);
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 8e97d8d4cc9d9..d41bce8927b2c 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -592,7 +592,7 @@ void __ip_sock_set_tos(struct sock *sk, int val)
 	}
 	if (inet_sk(sk)->tos != val) {
 		inet_sk(sk)->tos = val;
-		sk->sk_priority = rt_tos2priority(val);
+		WRITE_ONCE(sk->sk_priority, rt_tos2priority(val));
 		sk_dst_reset(sk);
 	}
 }
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index eadf1c9ef7e49..fb31624019435 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -348,7 +348,7 @@ static int raw_send_hdrinc(struct sock *sk, struct flowi4 *fl4,
 		goto error;
 	skb_reserve(skb, hlen);
 
-	skb->priority = sk->sk_priority;
+	skb->priority = READ_ONCE(sk->sk_priority);
 	skb->mark = sockc->mark;
 	skb->tstamp = sockc->transmit_time;
 	skb_dst_set(skb, &rt->dst);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 48429f0ee23b0..498dd4acdeec8 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -933,7 +933,7 @@ static void tcp_v4_send_ack(const struct sock *sk,
 	ctl_sk->sk_mark = (sk->sk_state == TCP_TIME_WAIT) ?
 			   inet_twsk(sk)->tw_mark : READ_ONCE(sk->sk_mark);
 	ctl_sk->sk_priority = (sk->sk_state == TCP_TIME_WAIT) ?
-			   inet_twsk(sk)->tw_priority : sk->sk_priority;
+			   inet_twsk(sk)->tw_priority : READ_ONCE(sk->sk_priority);
 	transmit_time = tcp_transmit_time(sk);
 	ip_send_unicast_reply(ctl_sk,
 			      skb, &TCP_SKB_CB(skb)->header.h4.opt,
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index a90a09658a71a..d85d2082aeb77 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -614,7 +614,7 @@ static int rawv6_send_hdrinc(struct sock *sk, struct msghdr *msg, int length,
 	skb_reserve(skb, hlen);
 
 	skb->protocol = htons(ETH_P_IPV6);
-	skb->priority = sk->sk_priority;
+	skb->priority = READ_ONCE(sk->sk_priority);
 	skb->mark = sockc->mark;
 	skb->tstamp = sockc->transmit_time;
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 346c9bcd5849d..3155692a0e06b 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1132,7 +1132,8 @@ static void tcp_v6_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 			tcp_time_stamp_raw() + tcp_rsk(req)->ts_off,
 			READ_ONCE(req->ts_recent), sk->sk_bound_dev_if,
 			tcp_v6_md5_do_lookup(sk, &ipv6_hdr(skb)->saddr, l3index),
-			ipv6_get_dsfield(ipv6_hdr(skb)), 0, sk->sk_priority,
+			ipv6_get_dsfield(ipv6_hdr(skb)), 0,
+			READ_ONCE(sk->sk_priority),
 			READ_ONCE(tcp_rsk(req)->txhash));
 }
 
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 6f033c334c7b4..a753246ef1657 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2050,7 +2050,7 @@ static int packet_sendmsg_spkt(struct socket *sock, struct msghdr *msg,
 
 	skb->protocol = proto;
 	skb->dev = dev;
-	skb->priority = sk->sk_priority;
+	skb->priority = READ_ONCE(sk->sk_priority);
 	skb->mark = READ_ONCE(sk->sk_mark);
 	skb->tstamp = sockc.transmit_time;
 
@@ -2585,7 +2585,7 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
 
 	skb->protocol = proto;
 	skb->dev = dev;
-	skb->priority = po->sk.sk_priority;
+	skb->priority = READ_ONCE(po->sk.sk_priority);
 	skb->mark = READ_ONCE(po->sk.sk_mark);
 	skb->tstamp = sockc->transmit_time;
 	skb_setup_tx_timestamp(skb, sockc->tsflags);
@@ -3061,7 +3061,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 
 	skb->protocol = proto;
 	skb->dev = dev;
-	skb->priority = sk->sk_priority;
+	skb->priority = READ_ONCE(sk->sk_priority);
 	skb->mark = sockc.mark;
 	skb->tstamp = sockc.transmit_time;
 
-- 
2.40.1



