Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8E3611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEEDBC433D2;
	Sun, 28 May 2023 19:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302962;
	bh=uFUgcJ10Fe6kYRudC89cKeNGUIM8LFRXh2Va97Y1yyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJU5YmSFaZ65KCUqQMxQaeLEdypEhneDqA+K5vccroKhZ6yAANoSRxDDUqmVuellz
	 H4YAdfBF/Gs/cjNO5qGlUJ1TFcIEneTXx/gis34V87K4/HWgWJlqzUsWQY/pQUK5QG
	 7mT9o1UlH81QAi0l6v8fcVfbRRq+tqOuSfLX6ilA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/211] ipv4/tcp: do not use per netns ctl sockets
Date: Sun, 28 May 2023 20:10:19 +0100
Message-Id: <20230528190846.030515064@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
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

[ Upstream commit 37ba017dcc3b1123206808979834655ddcf93251 ]

TCP ipv4 uses per-cpu/per-netns ctl sockets in order to send
RST and some ACK packets (on behalf of TIMEWAIT sockets).

This adds memory and cpu costs, which do not seem needed.
Now typical servers have 256 or more cores, this adds considerable
tax to netns users.

tcp sockets are used from BH context, are not receiving packets,
and do not store any persistent state but the 'struct net' pointer
in order to be able to use IPv4 output functions.

Note that I attempted a related change in the past, that had
to be hot-fixed in commit bdbbb8527b6f ("ipv4: tcp: get rid of ugly unicast_sock")

This patch could very well surface old bugs, on layers not
taking care of sk->sk_kern_sock properly.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 1e306ec49a1f ("tcp: fix possible sk_priority leak in tcp_v4_send_reset()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netns/ipv4.h |  1 -
 net/ipv4/tcp_ipv4.c      | 61 ++++++++++++++++++----------------------
 2 files changed, 27 insertions(+), 35 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index d8b320cf54ba0..4a4a5270ff6f2 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -71,7 +71,6 @@ struct netns_ipv4 {
 	struct sock		*mc_autojoin_sk;
 
 	struct inet_peer_base	*peers;
-	struct sock  * __percpu	*tcp_sk;
 	struct fqdir		*fqdir;
 #ifdef CONFIG_NETFILTER
 	struct xt_table		*iptable_filter;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 8bd7b1ec3b6a3..275ae42be99e0 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -91,6 +91,8 @@ static int tcp_v4_md5_hash_hdr(char *md5_hash, const struct tcp_md5sig_key *key,
 struct inet_hashinfo tcp_hashinfo;
 EXPORT_SYMBOL(tcp_hashinfo);
 
+static DEFINE_PER_CPU(struct sock *, ipv4_tcp_sk);
+
 static u32 tcp_v4_init_seq(const struct sk_buff *skb)
 {
 	return secure_tcp_seq(ip_hdr(skb)->daddr,
@@ -794,7 +796,8 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	arg.tos = ip_hdr(skb)->tos;
 	arg.uid = sock_net_uid(net, sk && sk_fullsock(sk) ? sk : NULL);
 	local_bh_disable();
-	ctl_sk = this_cpu_read(*net->ipv4.tcp_sk);
+	ctl_sk = this_cpu_read(ipv4_tcp_sk);
+	sock_net_set(ctl_sk, net);
 	if (sk) {
 		ctl_sk->sk_mark = (sk->sk_state == TCP_TIME_WAIT) ?
 				   inet_twsk(sk)->tw_mark : sk->sk_mark;
@@ -809,6 +812,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 			      transmit_time);
 
 	ctl_sk->sk_mark = 0;
+	sock_net_set(ctl_sk, &init_net);
 	__TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
 	__TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
 	local_bh_enable();
@@ -892,7 +896,8 @@ static void tcp_v4_send_ack(const struct sock *sk,
 	arg.tos = tos;
 	arg.uid = sock_net_uid(net, sk_fullsock(sk) ? sk : NULL);
 	local_bh_disable();
-	ctl_sk = this_cpu_read(*net->ipv4.tcp_sk);
+	ctl_sk = this_cpu_read(ipv4_tcp_sk);
+	sock_net_set(ctl_sk, net);
 	ctl_sk->sk_mark = (sk->sk_state == TCP_TIME_WAIT) ?
 			   inet_twsk(sk)->tw_mark : sk->sk_mark;
 	ctl_sk->sk_priority = (sk->sk_state == TCP_TIME_WAIT) ?
@@ -905,6 +910,7 @@ static void tcp_v4_send_ack(const struct sock *sk,
 			      transmit_time);
 
 	ctl_sk->sk_mark = 0;
+	sock_net_set(ctl_sk, &init_net);
 	__TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
 	local_bh_enable();
 }
@@ -2828,41 +2834,14 @@ EXPORT_SYMBOL(tcp_prot);
 
 static void __net_exit tcp_sk_exit(struct net *net)
 {
-	int cpu;
-
 	if (net->ipv4.tcp_congestion_control)
 		bpf_module_put(net->ipv4.tcp_congestion_control,
 			       net->ipv4.tcp_congestion_control->owner);
-
-	for_each_possible_cpu(cpu)
-		inet_ctl_sock_destroy(*per_cpu_ptr(net->ipv4.tcp_sk, cpu));
-	free_percpu(net->ipv4.tcp_sk);
 }
 
 static int __net_init tcp_sk_init(struct net *net)
 {
-	int res, cpu, cnt;
-
-	net->ipv4.tcp_sk = alloc_percpu(struct sock *);
-	if (!net->ipv4.tcp_sk)
-		return -ENOMEM;
-
-	for_each_possible_cpu(cpu) {
-		struct sock *sk;
-
-		res = inet_ctl_sock_create(&sk, PF_INET, SOCK_RAW,
-					   IPPROTO_TCP, net);
-		if (res)
-			goto fail;
-		sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
-
-		/* Please enforce IP_DF and IPID==0 for RST and
-		 * ACK sent in SYN-RECV and TIME-WAIT state.
-		 */
-		inet_sk(sk)->pmtudisc = IP_PMTUDISC_DO;
-
-		*per_cpu_ptr(net->ipv4.tcp_sk, cpu) = sk;
-	}
+	int cnt;
 
 	net->ipv4.sysctl_tcp_ecn = 2;
 	net->ipv4.sysctl_tcp_ecn_fallback = 1;
@@ -2947,10 +2926,6 @@ static int __net_init tcp_sk_init(struct net *net)
 		net->ipv4.tcp_congestion_control = &tcp_reno;
 
 	return 0;
-fail:
-	tcp_sk_exit(net);
-
-	return res;
 }
 
 static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
@@ -3027,6 +3002,24 @@ static void __init bpf_iter_register(void)
 
 void __init tcp_v4_init(void)
 {
+	int cpu, res;
+
+	for_each_possible_cpu(cpu) {
+		struct sock *sk;
+
+		res = inet_ctl_sock_create(&sk, PF_INET, SOCK_RAW,
+					   IPPROTO_TCP, &init_net);
+		if (res)
+			panic("Failed to create the TCP control socket.\n");
+		sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
+
+		/* Please enforce IP_DF and IPID==0 for RST and
+		 * ACK sent in SYN-RECV and TIME-WAIT state.
+		 */
+		inet_sk(sk)->pmtudisc = IP_PMTUDISC_DO;
+
+		per_cpu(ipv4_tcp_sk, cpu) = sk;
+	}
 	if (register_pernet_subsys(&tcp_sk_ops))
 		panic("Failed to create the TCP control socket.\n");
 
-- 
2.39.2



