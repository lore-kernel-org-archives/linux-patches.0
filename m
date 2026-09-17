Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CACE49D59C;
	Thu, 17 Sep 2026 18:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671532; cv=none; b=TpCzQs/ccu3P4R+NyGmeVtSoy2VwCJr5K7f/hOyhWbtOls2t7RHFXswiOlWrrl0c6+ZY22iqz3aW1PUa4Vy8+BLng7G9mc1ulZH0QrebMqCO2skyoiYUwDJykS3EPymdBacAJEKoTQbXo+kMXLkoDdUO026cUM909qfFReoBpro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671532; c=relaxed/simple;
	bh=Wuezl2kaYoD2IRCYfH93NDlhJxk2bWTrgFlPmhTq+tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OpniPPwjrO2UuRcu0ir+0TZ5aZMg9i1TWmAB90R506pJAAtzXxrqiknHv1SWArjrTW5ftl0KyNbb5HTv6dqUxs7ZQaG0fDAkEmLakeWCY5Ax4ElscGA9ttEcRUMuKneQkNHmuXRSP40btUFcc+E//1JFGumlbH79vhvOcFP3MFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZgSZEv0o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZgSZEv0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5538E1F000FF;
	Thu, 17 Sep 2026 18:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671531;
	bh=lsSrkMBAiz6T9D2YJ/qWeW5qR1A7EE1s7V6eQhX6okY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZgSZEv0oH0SpTUKMOl8Q66xcSTaF5BN6lPtjF847Tvj40Z+AAZk2Fz1NC5Puhx5sw
	 B0pC1NJfItAaTS6M5zpWv2QOlZQ/X6H4PGHeMoBGd78zwjCqC+V7i4epIdxEVU8QDg
	 4+tXOHerCk18fYI2UoWmDi3Em6wGNo2p8NUkzV7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Yong Wang <edragain@163.com>,
	Ren Wei <weir@nebusec.ai>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0969/1102] tcp: clamp route advmss to TCP_MIN_MSS
Date: Thu, 17 Sep 2026 16:15:12 +0100
Message-ID: <20260917151605.009375356@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yong Wang <edragain@163.com>

[ Upstream commit 870a9e42ecc6fe1b8c25d87af043cb0d9c178fe1 ]

tcp_select_initial_window() assumes that callers never pass an MSS
smaller than 1, but route-derived advmss values can violate that
assumption.

A too-small explicit RTAX_ADVMSS is one way to get there, but it is not
the only one. The same divide-by-zero can also be reached through the
"default advmss" path when RTAX_ADVMSS is left at 0 and the effective
advmss is later driven down by route MTU and min_adv_mss.

Introduce a tcp_dst_advmss() helper that clamps route advmss to
TCP_MIN_MSS before TCP consumes it, and use it in the TCP paths that
derive advmss from dst metrics. This keeps the effective MSS from
dropping to zero before tcp_select_initial_window() rounds the receive
window.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Yong Wang <edragain@163.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Link: https://patch.msgid.link/251eaf8277fa7c66364c9815c5da01662d269181.1787074852.git.edragain@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tcp.h        |    5 +++++
 net/ipv4/tcp_ipv4.c      |    2 +-
 net/ipv4/tcp_minisocks.c |    2 +-
 net/ipv4/tcp_output.c    |    6 +++---
 net/ipv6/tcp_ipv6.c      |    2 +-
 5 files changed, 11 insertions(+), 6 deletions(-)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1561,6 +1561,11 @@ static inline int tcp_full_space(const s
 	return tcp_win_from_space(sk, READ_ONCE(sk->sk_rcvbuf));
 }
 
+static inline u32 tcp_dst_advmss(const struct dst_entry *dst)
+{
+	return max_t(u32, dst_metric_advmss(dst), TCP_MIN_MSS);
+}
+
 static inline void __tcp_adjust_rcv_ssthresh(struct sock *sk, u32 new_ssthresh)
 {
 	int unused_mem = sk_unused_reserved_mem(sk);
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1806,7 +1806,7 @@ struct sock *tcp_v4_syn_recv_sock(const
 	tcp_ca_openreq_child(newsk, dst);
 
 	tcp_sync_mss(newsk, dst4_mtu(dst));
-	newtp->advmss = tcp_mss_clamp(tcp_sk(sk), dst_metric_advmss(dst));
+	newtp->advmss = tcp_mss_clamp(tcp_sk(sk), tcp_dst_advmss(dst));
 
 	tcp_initialize_rcv_mss(newsk);
 
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -422,7 +422,7 @@ void tcp_openreq_init_rwin(struct reques
 	u32 rcv_wnd;
 	int mss;
 
-	mss = tcp_mss_clamp(tp, dst_metric_advmss(dst));
+	mss = tcp_mss_clamp(tp, tcp_dst_advmss(dst));
 	window_clamp = READ_ONCE(tp->window_clamp);
 	/* Set this up on the first call only */
 	req->rsk_window_clamp = window_clamp ? : dst_metric(dst, RTAX_WINDOW);
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -127,7 +127,7 @@ static __u16 tcp_advertise_mss(struct so
 	int mss = tp->advmss;
 
 	if (dst) {
-		unsigned int metric = dst_metric_advmss(dst);
+		unsigned int metric = tcp_dst_advmss(dst);
 
 		if (metric < mss) {
 			mss = metric;
@@ -3764,7 +3764,7 @@ struct sk_buff *tcp_make_synack(const st
 	}
 	skb_dst_set(skb, dst);
 
-	mss = tcp_mss_clamp(tp, dst_metric_advmss(dst));
+	mss = tcp_mss_clamp(tp, tcp_dst_advmss(dst));
 
 	memset(&opts, 0, sizeof(opts));
 	now = tcp_clock_ns();
@@ -3918,7 +3918,7 @@ static void tcp_connect_init(struct sock
 
 	if (!tp->window_clamp)
 		WRITE_ONCE(tp->window_clamp, dst_metric(dst, RTAX_WINDOW));
-	tp->advmss = tcp_mss_clamp(tp, dst_metric_advmss(dst));
+	tp->advmss = tcp_mss_clamp(tp, tcp_dst_advmss(dst));
 
 	tcp_initialize_rcv_mss(sk);
 
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1489,7 +1489,7 @@ static struct sock *tcp_v6_syn_recv_sock
 	tcp_ca_openreq_child(newsk, dst);
 
 	tcp_sync_mss(newsk, dst6_mtu(dst));
-	newtp->advmss = tcp_mss_clamp(tcp_sk(sk), dst_metric_advmss(dst));
+	newtp->advmss = tcp_mss_clamp(tcp_sk(sk), tcp_dst_advmss(dst));
 
 	tcp_initialize_rcv_mss(newsk);
 


