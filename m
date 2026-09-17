Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66E351597A;
	Thu, 17 Sep 2026 17:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667124; cv=none; b=OD7ri0znyS7piIGKNEug8uJH4QOIjOkBqYv82lGSXlTGR356C8CFfG+JAed5pUcP3AhHcMRitfBuw1itU8z/lnhowG8WCKZqyUk2ahcIUyDHlrNPkgcYvd4rSdmEHLcu+o+J4TQ8lR1Z0BGZ+rGloneMVqfvbHgpYrOuH+m/hzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667124; c=relaxed/simple;
	bh=4XFeQaHLyR9ve1w3cOJD6g/bpQFM56+CA62JhFlO64E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JowOlQPxBB+SDlkBar0V1jgnoUsJIRtnuhS1YTkmXRnPGJT9+Y7JhVu/AUmQvqpr7xA0uVqRP0S79rsssRUKkAsT8BsqhJI85sC3lJ5epNoQURm4sH7pCKeQkUKlXD8il/fkEMscV/lSA7Na5s92pSQ0YRlGuzaFV2Fc6Ju2TuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sP4esNFP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sP4esNFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BEF91F00893;
	Thu, 17 Sep 2026 17:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667122;
	bh=9A/Vu2Fn4MHWRMf4eY92XvSSeTHonicpwRnyJaceyw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sP4esNFPIUuwoQDIQylehugj1N3tsbFCkRjrN/wgXieEzzoSuiYPrdhjnXFMiPrD2
	 Z1G6XQwjB0OEdprxY22ZoWFsAl/INvpZ2NAYDWh+GGuuG1lQZdw4EDm9AB5OPU/9p6
	 SO6oxRaLt9nxa8xIFBwLolr9hVV2eXDR0CB+L2ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1237/1250] tcp: rename icsk_timeout() to tcp_timeout_expires()
Date: Thu, 17 Sep 2026 16:17:12 +0100
Message-ID: <20260917151625.822464643@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3a6e8fd0bf4042c572dc52e634878b9aca02970d ]

In preparation of sk->tcp_timeout_timer introduction,
rename icsk_timeout() helper and change its argument to plain
'const struct sock *sk'.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20251124175013.1473655-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e2ab913f68c7 ("mptcp: do not reschedule the RTX timer for fallback sockets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/inet_connection_sock.h |    5 ++---
 net/ipv4/inet_diag.c               |    4 ++--
 net/ipv4/tcp_ipv4.c                |    4 ++--
 net/ipv4/tcp_timer.c               |    6 +++---
 net/ipv6/tcp_ipv6.c                |    4 ++--
 net/mptcp/protocol.c               |    2 +-
 6 files changed, 12 insertions(+), 13 deletions(-)

--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -186,10 +186,9 @@ static inline void inet_csk_delack_init(
 	memset(&inet_csk(sk)->icsk_ack, 0, sizeof(inet_csk(sk)->icsk_ack));
 }
 
-static inline unsigned long
-icsk_timeout(const struct inet_connection_sock *icsk)
+static inline unsigned long tcp_timeout_expires(const struct sock *sk)
 {
-	return READ_ONCE(icsk->icsk_retransmit_timer.expires);
+	return READ_ONCE(inet_csk(sk)->icsk_retransmit_timer.expires);
 }
 
 static inline unsigned long
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -287,12 +287,12 @@ int inet_sk_diag_fill(struct sock *sk, s
 		r->idiag_timer = 1;
 		r->idiag_retrans = READ_ONCE(icsk->icsk_retransmits);
 		r->idiag_expires =
-			jiffies_delta_to_msecs(icsk_timeout(icsk) - jiffies);
+			jiffies_delta_to_msecs(tcp_timeout_expires(sk) - jiffies);
 	} else if (icsk_pending == ICSK_TIME_PROBE0) {
 		r->idiag_timer = 4;
 		r->idiag_retrans = READ_ONCE(icsk->icsk_probes_out);
 		r->idiag_expires =
-			jiffies_delta_to_msecs(icsk_timeout(icsk) - jiffies);
+			jiffies_delta_to_msecs(tcp_timeout_expires(sk) - jiffies);
 	} else if (timer_pending(&sk->sk_timer)) {
 		r->idiag_timer = 2;
 		r->idiag_retrans = READ_ONCE(icsk->icsk_probes_out);
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2928,10 +2928,10 @@ static void get_tcp4_sock(struct sock *s
 	    icsk_pending == ICSK_TIME_REO_TIMEOUT ||
 	    icsk_pending == ICSK_TIME_LOSS_PROBE) {
 		timer_active	= 1;
-		timer_expires	= icsk_timeout(icsk);
+		timer_expires	= tcp_timeout_expires(sk);
 	} else if (icsk_pending == ICSK_TIME_PROBE0) {
 		timer_active	= 4;
-		timer_expires	= icsk_timeout(icsk);
+		timer_expires	= tcp_timeout_expires(sk);
 	} else if (timer_pending(&sk->sk_timer)) {
 		timer_active	= 2;
 		timer_expires	= sk->sk_timer.expires;
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -513,7 +513,7 @@ static bool tcp_rtx_probe0_timed_out(con
 	 * and tp->rcv_tstamp might very well have been written recently.
 	 * rcv_delta can thus be negative.
 	 */
-	rcv_delta = icsk_timeout(icsk) - tp->rcv_tstamp;
+	rcv_delta = tcp_timeout_expires(sk) - tp->rcv_tstamp;
 	if (rcv_delta <= timeout)
 		return false;
 
@@ -700,9 +700,9 @@ void tcp_write_timer_handler(struct sock
 	    !icsk->icsk_pending)
 		return;
 
-	if (time_after(icsk_timeout(icsk), jiffies)) {
+	if (time_after(tcp_timeout_expires(sk), jiffies)) {
 		sk_reset_timer(sk, &icsk->icsk_retransmit_timer,
-			       icsk_timeout(icsk));
+			       tcp_timeout_expires(sk));
 		return;
 	}
 	tcp_mstamp_refresh(tcp_sk(sk));
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2200,10 +2200,10 @@ static void get_tcp6_sock(struct seq_fil
 	    icsk_pending == ICSK_TIME_REO_TIMEOUT ||
 	    icsk_pending == ICSK_TIME_LOSS_PROBE) {
 		timer_active	= 1;
-		timer_expires	= icsk_timeout(icsk);
+		timer_expires	= tcp_timeout_expires(sp);
 	} else if (icsk_pending == ICSK_TIME_PROBE0) {
 		timer_active	= 4;
-		timer_expires	= icsk_timeout(icsk);
+		timer_expires	= tcp_timeout_expires(sp);
 	} else if (timer_pending(&sp->sk_timer)) {
 		timer_active	= 2;
 		timer_expires	= sp->sk_timer.expires;
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -533,7 +533,7 @@ static long mptcp_timeout_from_subflow(c
 	const struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
 	return inet_csk(ssk)->icsk_pending && !subflow->stale_count ?
-	       icsk_timeout(inet_csk(ssk)) - jiffies : 0;
+	       tcp_timeout_expires(ssk) - jiffies : 0;
 }
 
 static void mptcp_set_timeout(struct sock *sk)


