Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9469B4A4404;
	Mon, 31 Aug 2026 13:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183787; cv=none; b=KNYJHyanSjLMEHWvY5rO7Dnzy56Lwkubt6aXuyqt5XbalzNF8TH+haIuOEyFoNNrsF79lQMkpwglCw90QZ3BKD9gxDx88O1a4rhuW2zdSoalPzMkfUn2F7xEJFNcQKQQUHwW4fyk4fe++RB+ns9EpzVEYdwI3H8uLU6/UtrjULg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183787; c=relaxed/simple;
	bh=jNcXFB/dNPCXYwfQHLb3w83q5XiyT2QbY+3XtSSAXaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DaRiUeRBiUERRqTn7M1YlrpXU9PSlwOMCJOh4lgB0/R89m5cLm0sZ+1Eb5uKzJ1egeDxwTFgfXKmdF22RAUerrSb9BZ1OJeWAOpc/H4rMO/THFY/Jfp8JDhojC4qrWr+haOZ1nOBXuDlhezz2wWYhfEENpEmrUsiuGPWSIecGJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3jqNdUg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3jqNdUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00151F000E9;
	Mon, 31 Aug 2026 13:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183785;
	bh=HAMKp58Oop8CbrCpi4dv2JkSqy3F6GT6xlcTrMasSd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3jqNdUgX43qOrTLWGPavUiIalA1xXv5s0bqtTw6Sl6m1gnz1CdvbtUrzaCXXPSL0
	 qt/keUD6Zlh9MyVrUXz5xIWZ7i52oDmqiHpMddkWr4f4LADO9+vjrYejQpV48zqW+h
	 Y6Uhj5Vgv2shJhyTtHPMq804eAuwMWVpM6BGMZo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Yong Wang <edragain@163.com>,
	Ren Wei <weir@nebusec.ai>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 41/76] tcp: clamp route advmss to TCP_MIN_MSS
Date: Mon, 31 Aug 2026 15:34:13 +0200
Message-ID: <20260831133401.540352268@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yong Wang <edragain@163.com>

commit 870a9e42ecc6fe1b8c25d87af043cb0d9c178fe1 upstream.

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
@@ -1773,6 +1773,11 @@ static inline int tcp_full_space(const s
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
@@ -1736,7 +1736,7 @@ struct sock *tcp_v4_syn_recv_sock(const
 	tcp_ca_openreq_child(newsk, dst);
 
 	tcp_sync_mss(newsk, dst4_mtu(dst));
-	newtp->advmss = tcp_mss_clamp(tcp_sk(sk), dst_metric_advmss(dst));
+	newtp->advmss = tcp_mss_clamp(tcp_sk(sk), tcp_dst_advmss(dst));
 
 	tcp_initialize_rcv_mss(newsk);
 
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -441,7 +441,7 @@ void tcp_openreq_init_rwin(struct reques
 	u32 rcv_wnd;
 	int mss;
 
-	mss = tcp_mss_clamp(tp, dst_metric_advmss(dst));
+	mss = tcp_mss_clamp(tp, tcp_dst_advmss(dst));
 	window_clamp = READ_ONCE(tp->window_clamp);
 	/* Set this up on the first call only */
 	req->rsk_window_clamp = window_clamp ? : dst_metric(dst, RTAX_WINDOW);
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -149,7 +149,7 @@ static __u16 tcp_advertise_mss(struct so
 	int mss = tp->advmss;
 
 	if (dst) {
-		unsigned int metric = dst_metric_advmss(dst);
+		unsigned int metric = tcp_dst_advmss(dst);
 
 		if (metric < mss) {
 			mss = metric;
@@ -3971,7 +3971,7 @@ struct sk_buff *tcp_make_synack(const st
 	}
 	skb_dst_set(skb, dst);
 
-	mss = tcp_mss_clamp(tp, dst_metric_advmss(dst));
+	mss = tcp_mss_clamp(tp, tcp_dst_advmss(dst));
 
 	memset(&opts, 0, sizeof(opts));
 	now = tcp_clock_ns();
@@ -4126,7 +4126,7 @@ static void tcp_connect_init(struct sock
 
 	if (!tp->window_clamp)
 		WRITE_ONCE(tp->window_clamp, dst_metric(dst, RTAX_WINDOW));
-	tp->advmss = tcp_mss_clamp(tp, dst_metric_advmss(dst));
+	tp->advmss = tcp_mss_clamp(tp, tcp_dst_advmss(dst));
 
 	tcp_initialize_rcv_mss(sk);
 
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1472,7 +1472,7 @@ static struct sock *tcp_v6_syn_recv_sock
 	tcp_ca_openreq_child(newsk, dst);
 
 	tcp_sync_mss(newsk, dst6_mtu(dst));
-	newtp->advmss = tcp_mss_clamp(tcp_sk(sk), dst_metric_advmss(dst));
+	newtp->advmss = tcp_mss_clamp(tcp_sk(sk), tcp_dst_advmss(dst));
 
 	tcp_initialize_rcv_mss(newsk);
 


