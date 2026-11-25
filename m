Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624871;
	b=CXb26WRrWH6kwObF3/u59S4am2cs93W9Y5qJHPUe+DwdEJI8Z92BVqrbJhRdblHxeF+X
	 4ZXKYyikgCCz8LNi+SsGyPwTI6d40WvY6NnZBUBfidYXP/OzvF0dlDT/qyJiJ3T3Pjdcl
	 onpIm5LD8ELS9+RuSfoAklCBn5ABlcDFYP6cUvM2vMcjtg/we53pllsyz5N+GP5d3KMMD
	 bR2rtzqsK/Pwx9KpBqnpSOkS1JyoawB4Tko2Q99OsllG480n+SsFWTbrxC8y0ilsW8pQk
	 5WlQ/Xne/arCEWbouT63cYS4V4ETjf5kxUMM51FdeRUtsunBQR9bzQUB/L5uhn0ZBNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bdRrp6VsYYHoK4QGew9/mcQlGV0PIv1/k9p6By8yp1c=;
	b=znKcL8xM7TnNVg0C4ebAUIefil28uFGKwUWsAoLXb6+NQaPp0J6rA5LECA0wND8ocTaa
	 BMXkmM2An26prWwBw9Igcf9SD00+1JAIuN1LScXbMEboj6mDHHsAC7lM00SStaufcwOqc
	 PBhQZjq+cUXwhslYPXSlCJO31cQqVsJRchvrwS7kvLpW+kypyvGUchrqKIKzraKv08xxt
	 o/ZgVpIcLzg6IlbVdw9/0sKT3wzMs81arQbJrgfsTFcEZ+aQtarvFsi++0w+qYmPr8B/Q
	 6mgaFvhrxI75Vlj/qRw2UWIEl97JvbIhqgS0epiBfGDcpTqek7rPVn/F4I9oq12zfjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0MKtdHS1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1768606A327;
	Wed, 25 Nov 2026 16:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0MKtdHS1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8406C1F000CF;
	Wed, 25 Nov 2026 16:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624871;
	bh=bdRrp6VsYYHoK4QGew9/mcQlGV0PIv1/k9p6By8yp1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0MKtdHS1nSqwAlO3NP3VHAHgO6TLKGO9/raZScwuaeILzE6Ubo0pIglS9Jf8PFemD
	 vF4m9l3E3au7oRCrqPxi9Oa1Jiw57yZxkFs31MQ18pjCh7yfRNxJICWJL7LFLWE6sZ
	 6ZLN3ZHFjyvip1e6gYHCj/vanKtLuFtgRiDP/gvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Octavian Purdila <tavip@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 334/816] net: rfs: add sock_rps_delete_flow() helper
Date: Wed, 25 Nov 2026 15:31:22 +0100
Message-ID: <20261125143856.930727961@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9cd5ef0b8c04c46a15c8f5d002f02ea0d0477790 ]

RFS can exhibit lower performance for workloads using short-lived
flows and a small set of 4-tuple.

This is often the case for load-testers, using a pair of hosts,
if the server has a single listener port.

Typical use case :

Server : tcp_crr -T128 -F1000 -6 -U -l30 -R 14250
Client : tcp_crr -T128 -F1000 -6 -U -l30 -c -H server | grep local_throughput

This is because RFS global hash table contains stale information,
when the same RSS key is recycled for another socket and another cpu.

Make sure to undo the changes and go back to initial state when
a flow is disconnected.

Performance of the above test is increased by 22 %,
going from 372604 transactions per second to 457773.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Octavian Purdila <tavip@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Link: https://patch.msgid.link/20250515100354.3339920-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8c011697f76a ("tcp: do not resurrect a former listener with SO_ATTACH_REUSEPORT_[CE]BPF")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/rps.h          | 24 ++++++++++++++++++++++++
 net/ipv4/inet_hashtables.c |  6 ++++--
 net/ipv4/udp.c             |  2 ++
 net/sctp/socket.c          |  2 +-
 4 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/include/net/rps.h b/include/net/rps.h
index a93401d23d66e..6e98aa7655afe 100644
--- a/include/net/rps.h
+++ b/include/net/rps.h
@@ -122,6 +122,30 @@ static inline void sock_rps_record_flow(const struct sock *sk)
 #endif
 }
 
+static inline void sock_rps_delete_flow(const struct sock *sk)
+{
+#ifdef CONFIG_RPS
+	struct rps_sock_flow_table *table;
+	u32 hash, index;
+
+	if (!static_branch_unlikely(&rfs_needed))
+		return;
+
+	hash = READ_ONCE(sk->sk_rxhash);
+	if (!hash)
+		return;
+
+	rcu_read_lock();
+	table = rcu_dereference(net_hotdata.rps_sock_flow_table);
+	if (table) {
+		index = hash & table->mask;
+		if (READ_ONCE(table->ents[index]) != RPS_NO_CPU)
+			WRITE_ONCE(table->ents[index], RPS_NO_CPU);
+	}
+	rcu_read_unlock();
+#endif
+}
+
 static inline u32 rps_input_queue_tail_incr(struct softnet_data *sd)
 {
 #ifdef CONFIG_RPS
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index e7b312f7cd98f..7035e35bea5e1 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -23,11 +23,12 @@
 #if IS_ENABLED(CONFIG_IPV6)
 #include <net/inet6_hashtables.h>
 #endif
-#include <net/secure_seq.h>
 #include <net/hotdata.h>
 #include <net/ip.h>
-#include <net/tcp.h>
+#include <net/rps.h>
+#include <net/secure_seq.h>
 #include <net/sock_reuseport.h>
+#include <net/tcp.h>
 
 u32 inet_ehashfn(const struct net *net, const __be32 laddr,
 		 const __u16 lport, const __be32 faddr,
@@ -783,6 +784,7 @@ void inet_unhash(struct sock *sk)
 	if (sk_unhashed(sk))
 		return;
 
+	sock_rps_delete_flow(sk);
 	if (sk->sk_state == TCP_LISTEN) {
 		struct inet_listen_hashbucket *ilb2;
 
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 22eee4fdd5d8d..4fc8263286f2e 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -119,6 +119,7 @@
 #if IS_ENABLED(CONFIG_IPV6)
 #include <net/ipv6_stubs.h>
 #endif
+#include <net/rps.h>
 
 struct udp_table udp_table __read_mostly;
 EXPORT_SYMBOL(udp_table);
@@ -2050,6 +2051,7 @@ void udp_lib_unhash(struct sock *sk)
 		struct udp_table *udptable = udp_get_table_prot(sk);
 		struct udp_hslot *hslot, *hslot2;
 
+		sock_rps_delete_flow(sk);
 		hslot  = udp_hashslot(udptable, sock_net(sk),
 				      udp_sk(sk)->udp_port_hash);
 		hslot2 = udp_hashslot2(udptable, udp_sk(sk)->udp_portaddr_hash);
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 7734ca92335aa..3c8b9b8b07e03 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8390,7 +8390,7 @@ static int sctp_hash(struct sock *sk)
 
 static void sctp_unhash(struct sock *sk)
 {
-	/* STUB */
+	sock_rps_delete_flow(sk);
 }
 
 /* Check if port is acceptable.  Possibly find first available port.
-- 
2.53.0



