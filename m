Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6934F1F8722;
	Mon, 23 Jun 2025 21:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715949; cv=none; b=q40z1xE8Iiive+Yh9QJ7CaqL+7sOp/hswCnqHl7qDT7f/PQObHVgoZsEnnanMgOQ+XbHXIhpQukgSwLvB42t5auY7/2PjBr5ejka7fJDJJRU1eWNjxgIyMcalfSh5Q9dREjtzFuQguJkaa7kQfJnFaC6oSHKI4hIhG4SWSxobWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715949; c=relaxed/simple;
	bh=Mak8GoHH8EQkxCXaxCuCA699DXSG6HTstWDwjxIojx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDkAgipSzvKWN2T8q0xrEDoSyACuCM7FRi3TPkMIVXpwOw/IsZiDwB9k9am8cPHWFQop/RhdZnRs47mAHIRz+cmN1pojKYBlfrgwOvTB8hnf0awa7w4sER1e6RTJkYav1wk/JzRK/PdlMr6BZtvDrwcz4SG4kPGLitm2w3BM67U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K9Ffp7g+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K9Ffp7g+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B117CC4CEEA;
	Mon, 23 Jun 2025 21:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715949;
	bh=Mak8GoHH8EQkxCXaxCuCA699DXSG6HTstWDwjxIojx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9Ffp7g+pb6NRdsO8U/4HZihyPiOHN6bOcnvqcx0nlIGiLAVZACirBq83zNotOtzl
	 oL/QmWO/XiIiIDgbp1JblsI6HEVzVeaUHI86lC8aIGZFY9rc4w7a8VUMQGibeip1BG
	 ZsZZy1fM2Fr+BKy7/p4rydIQB42PwJ0/QVoCjpHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Wei Wang <weiwan@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 218/414] tcp: remove zero TCP TS samples for autotuning
Date: Mon, 23 Jun 2025 15:05:55 +0200
Message-ID: <20250623130647.467188122@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d59fc95be9d0fd05ed3ccc11b4a2f832bdf2ee03 ]

For TCP flows using ms RFC 7323 timestamp granularity
tcp_rcv_rtt_update() can be fed with 1 ms samples, breaking
TCP autotuning for data center flows with sub ms RTT.

Instead, rely on the window based samples, fed by tcp_rcv_rtt_measure()

tcp_rcvbuf_grow() for a 10 second TCP_STREAM sesssion now looks saner.
We can see rcvbuf is kept at a reasonable value.

  222.234976: tcp:tcp_rcvbuf_grow: time=348 rtt_us=330 copied=110592 inq=0 space=40960 ooo=0 scaling_ratio=230 rcvbuf=131072 ...
  222.235276: tcp:tcp_rcvbuf_grow: time=300 rtt_us=288 copied=126976 inq=0 space=110592 ooo=0 scaling_ratio=230 rcvbuf=246187 ...
  222.235569: tcp:tcp_rcvbuf_grow: time=294 rtt_us=288 copied=184320 inq=0 space=126976 ooo=0 scaling_ratio=230 rcvbuf=282659 ...
  222.235833: tcp:tcp_rcvbuf_grow: time=264 rtt_us=244 copied=373760 inq=0 space=184320 ooo=0 scaling_ratio=230 rcvbuf=410312 ...
  222.236142: tcp:tcp_rcvbuf_grow: time=308 rtt_us=219 copied=424960 inq=20480 space=373760 ooo=0 scaling_ratio=230 rcvbuf=832022 ...
  222.236378: tcp:tcp_rcvbuf_grow: time=236 rtt_us=219 copied=692224 inq=49152 space=404480 ooo=0 scaling_ratio=230 rcvbuf=900407 ...
  222.236602: tcp:tcp_rcvbuf_grow: time=225 rtt_us=219 copied=730112 inq=49152 space=643072 ooo=0 scaling_ratio=230 rcvbuf=1431534 ...
  222.237050: tcp:tcp_rcvbuf_grow: time=229 rtt_us=219 copied=1160192 inq=49152 space=680960 ooo=0 scaling_ratio=230 rcvbuf=1515876 ...
  222.237618: tcp:tcp_rcvbuf_grow: time=305 rtt_us=218 copied=2228224 inq=49152 space=1111040 ooo=0 scaling_ratio=230 rcvbuf=2473271 ...
  222.238591: tcp:tcp_rcvbuf_grow: time=224 rtt_us=218 copied=3063808 inq=360448 space=2179072 ooo=0 scaling_ratio=230 rcvbuf=4850803 ...
  222.240647: tcp:tcp_rcvbuf_grow: time=260 rtt_us=218 copied=2752512 inq=0 space=2703360 ooo=0 scaling_ratio=230 rcvbuf=6017914 ...
  222.243535: tcp:tcp_rcvbuf_grow: time=224 rtt_us=218 copied=2834432 inq=49152 space=2752512 ooo=0 scaling_ratio=230 rcvbuf=6127331 ...
  222.245108: tcp:tcp_rcvbuf_grow: time=240 rtt_us=218 copied=2883584 inq=49152 space=2785280 ooo=0 scaling_ratio=230 rcvbuf=6200275 ...
  222.245333: tcp:tcp_rcvbuf_grow: time=224 rtt_us=218 copied=2859008 inq=0 space=2834432 ooo=0 scaling_ratio=230 rcvbuf=6309692 ...
  222.301021: tcp:tcp_rcvbuf_grow: time=222 rtt_us=218 copied=2883584 inq=0 space=2859008 ooo=0 scaling_ratio=230 rcvbuf=6364400 ...
  222.989242: tcp:tcp_rcvbuf_grow: time=225 rtt_us=218 copied=2899968 inq=0 space=2883584 ooo=0 scaling_ratio=230 rcvbuf=6419108 ...
  224.139553: tcp:tcp_rcvbuf_grow: time=224 rtt_us=218 copied=3014656 inq=65536 space=2899968 ooo=0 scaling_ratio=230 rcvbuf=6455580 ...
  224.584608: tcp:tcp_rcvbuf_grow: time=232 rtt_us=218 copied=3014656 inq=49152 space=2949120 ooo=0 scaling_ratio=230 rcvbuf=6564997 ...
  230.145560: tcp:tcp_rcvbuf_grow: time=223 rtt_us=218 copied=2981888 inq=0 space=2965504 ooo=0 scaling_ratio=230 rcvbuf=6601469 ...

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Wei Wang <weiwan@google.com>
Link: https://patch.msgid.link/20250513193919.1089692-6-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index cf4fef18a9cad..61ada4682094f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -707,7 +707,7 @@ static inline void tcp_rcv_rtt_measure(struct tcp_sock *tp)
 	tp->rcv_rtt_est.time = tp->tcp_mstamp;
 }
 
-static s32 tcp_rtt_tsopt_us(const struct tcp_sock *tp)
+static s32 tcp_rtt_tsopt_us(const struct tcp_sock *tp, u32 min_delta)
 {
 	u32 delta, delta_us;
 
@@ -717,7 +717,7 @@ static s32 tcp_rtt_tsopt_us(const struct tcp_sock *tp)
 
 	if (likely(delta < INT_MAX / (USEC_PER_SEC / TCP_TS_HZ))) {
 		if (!delta)
-			delta = 1;
+			delta = min_delta;
 		delta_us = delta * (USEC_PER_SEC / TCP_TS_HZ);
 		return delta_us;
 	}
@@ -735,9 +735,9 @@ static inline void tcp_rcv_rtt_measure_ts(struct sock *sk,
 
 	if (TCP_SKB_CB(skb)->end_seq -
 	    TCP_SKB_CB(skb)->seq >= inet_csk(sk)->icsk_ack.rcv_mss) {
-		s32 delta = tcp_rtt_tsopt_us(tp);
+		s32 delta = tcp_rtt_tsopt_us(tp, 0);
 
-		if (delta >= 0)
+		if (delta > 0)
 			tcp_rcv_rtt_update(tp, delta, 0);
 	}
 }
@@ -3220,7 +3220,7 @@ static bool tcp_ack_update_rtt(struct sock *sk, const int flag,
 	 */
 	if (seq_rtt_us < 0 && tp->rx_opt.saw_tstamp &&
 	    tp->rx_opt.rcv_tsecr && flag & FLAG_ACKED)
-		seq_rtt_us = ca_rtt_us = tcp_rtt_tsopt_us(tp);
+		seq_rtt_us = ca_rtt_us = tcp_rtt_tsopt_us(tp, 1);
 
 	rs->rtt_us = ca_rtt_us; /* RTT of last (S)ACKed packet (or -1) */
 	if (seq_rtt_us < 0)
-- 
2.39.5



