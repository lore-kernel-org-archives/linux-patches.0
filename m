Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3D71DA53;
	Mon, 14 Oct 2024 14:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916976; cv=none; b=eO2VtOo/kWurc6D5GZtWPSLF5lizrWUEMBUSfhZ/ehkTJvz2gmRvtpck+MSHjQHp1PudjjtpuIfuQw6utlHZ7QIxy9vIy6eT/w/3ZfTv6rnb7k+AmGmF+8Do868JYioa4uxkbQ8g8hXm1ja9oGBk5tObRmkN1za99T4c0ZBm2Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916976; c=relaxed/simple;
	bh=fod+zQtSqfb3gNc5IDyfdQJm6xHGbA6gwugNAMYAbs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unoWv2nxl4P0WMXdYufIHfeBfFCCU7bzHlwltzdg/LjXnxWBRy7Pj2SjS9Hy8esL4hNJfyOGRMlxNwfdkIpx4uBHvY8/iZDbvVfu49+WPOabRrWlQ8VbbRZ4EKJmt60kQp02cEyUDBKGV8uITVL9hP+AkMQD5n/U9cpCRf7LjE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yls4OIqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yls4OIqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA95C4CEC3;
	Mon, 14 Oct 2024 14:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916976;
	bh=fod+zQtSqfb3gNc5IDyfdQJm6xHGbA6gwugNAMYAbs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yls4OIqmrLhIJXSqk13p9CrXjPhNNU5E6ySdLzdwxDjT/6gRV3KRnrIU2uuyiStcM
	 H6DJComoHNE0JGEuX/OPb3oloplv6wTpOl7bbvz0gxddihmkSuwydfLJvCM4d6HXfH
	 ai+mkGvPdvck7ik9TGKPbz+x8NO79p5948cidNAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aananth V <aananthv@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Yuchung Cheng <ycheng@google.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/213] tcp: new TCP_INFO stats for RTO events
Date: Mon, 14 Oct 2024 16:20:23 +0200
Message-ID: <20241014141047.536250182@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aananth V <aananthv@google.com>

[ Upstream commit 3868ab0f192581eff978501a05f3dc2e01541d77 ]

The 2023 SIGCOMM paper "Improving Network Availability with Protective
ReRoute" has indicated Linux TCP's RTO-triggered txhash rehashing can
effectively reduce application disruption during outages. To better
measure the efficacy of this feature, this patch adds three more
detailed stats during RTO recovery and exports via TCP_INFO.
Applications and monitoring systems can leverage this data to measure
the network path diversity and end-to-end repair latency during network
outages to improve their network infrastructure.

The following counters are added to tcp_sock in order to track RTO
events over the lifetime of a TCP socket.

1. u16 total_rto - Counts the total number of RTO timeouts.
2. u16 total_rto_recoveries - Counts the total number of RTO recoveries.
3. u32 total_rto_time - Counts the total time spent (ms) in RTO
                        recoveries. (time spent in CA_Loss and
                        CA_Recovery states)

To compute total_rto_time, we add a new u32 rto_stamp field to
tcp_sock. rto_stamp records the start timestamp (ms) of the last RTO
recovery (CA_Loss).

Corresponding fields are also added to the tcp_info struct.

Signed-off-by: Aananth V <aananthv@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 27c80efcc204 ("tcp: fix TFO SYN_RECV to not zero retrans_stamp with retransmits out")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/tcp.h      |  8 ++++++++
 include/uapi/linux/tcp.h | 12 ++++++++++++
 net/ipv4/tcp.c           |  9 +++++++++
 net/ipv4/tcp_input.c     | 15 +++++++++++++++
 net/ipv4/tcp_minisocks.c |  4 ++++
 net/ipv4/tcp_timer.c     | 17 +++++++++++++++--
 6 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 3c5efeeb024f6..9b371aa7c7962 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -377,6 +377,14 @@ struct tcp_sock {
 				 * Total data bytes retransmitted
 				 */
 	u32	total_retrans;	/* Total retransmits for entire connection */
+	u32	rto_stamp;	/* Start time (ms) of last CA_Loss recovery */
+	u16	total_rto;	/* Total number of RTO timeouts, including
+				 * SYN/SYN-ACK and recurring timeouts.
+				 */
+	u16	total_rto_recoveries;	/* Total number of RTO recoveries,
+					 * including any unfinished recovery.
+					 */
+	u32	total_rto_time;	/* ms spent in (completed) RTO recoveries. */
 
 	u32	urg_seq;	/* Seq of received urgent pointer */
 	unsigned int		keepalive_time;	  /* time before keep alive takes place */
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 879eeb0a084b4..d1d08da6331ab 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -289,6 +289,18 @@ struct tcp_info {
 				      */
 
 	__u32   tcpi_rehash;         /* PLB or timeout triggered rehash attempts */
+
+	__u16	tcpi_total_rto;	/* Total number of RTO timeouts, including
+				 * SYN/SYN-ACK and recurring timeouts.
+				 */
+	__u16	tcpi_total_rto_recoveries;	/* Total number of RTO
+						 * recoveries, including any
+						 * unfinished recovery.
+						 */
+	__u32	tcpi_total_rto_time;	/* Total time spent in RTO recoveries
+					 * in milliseconds, including any
+					 * unfinished recovery.
+					 */
 };
 
 /* netlink attributes types for SCM_TIMESTAMPING_OPT_STATS */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 1e3202f2b7a87..75371928d94f6 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3851,6 +3851,15 @@ void tcp_get_info(struct sock *sk, struct tcp_info *info)
 	info->tcpi_rcv_wnd = tp->rcv_wnd;
 	info->tcpi_rehash = tp->plb_rehash + tp->timeout_rehash;
 	info->tcpi_fastopen_client_fail = tp->fastopen_client_fail;
+
+	info->tcpi_total_rto = tp->total_rto;
+	info->tcpi_total_rto_recoveries = tp->total_rto_recoveries;
+	info->tcpi_total_rto_time = tp->total_rto_time;
+	if (tp->rto_stamp) {
+		info->tcpi_total_rto_time += tcp_time_stamp_raw() -
+						tp->rto_stamp;
+	}
+
 	unlock_sock_fast(sk, slow);
 }
 EXPORT_SYMBOL_GPL(tcp_get_info);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 057d39248bec7..d472f7052cd32 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2108,6 +2108,10 @@ void tcp_clear_retrans(struct tcp_sock *tp)
 	tp->undo_marker = 0;
 	tp->undo_retrans = -1;
 	tp->sacked_out = 0;
+	tp->rto_stamp = 0;
+	tp->total_rto = 0;
+	tp->total_rto_recoveries = 0;
+	tp->total_rto_time = 0;
 }
 
 static inline void tcp_init_undo(struct tcp_sock *tp)
@@ -2899,6 +2903,14 @@ void tcp_enter_recovery(struct sock *sk, bool ece_ack)
 	tcp_set_ca_state(sk, TCP_CA_Recovery);
 }
 
+static void tcp_update_rto_time(struct tcp_sock *tp)
+{
+	if (tp->rto_stamp) {
+		tp->total_rto_time += tcp_time_stamp(tp) - tp->rto_stamp;
+		tp->rto_stamp = 0;
+	}
+}
+
 /* Process an ACK in CA_Loss state. Move to CA_Open if lost data are
  * recovered or spurious. Otherwise retransmits more on partial ACKs.
  */
@@ -3103,6 +3115,8 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 		break;
 	case TCP_CA_Loss:
 		tcp_process_loss(sk, flag, num_dupack, rexmit);
+		if (icsk->icsk_ca_state != TCP_CA_Loss)
+			tcp_update_rto_time(tp);
 		tcp_identify_packet_loss(sk, ack_flag);
 		if (!(icsk->icsk_ca_state == TCP_CA_Open ||
 		      (*ack_flag & FLAG_LOST_RETRANS)))
@@ -6541,6 +6555,7 @@ static void tcp_rcv_synrecv_state_fastopen(struct sock *sk)
 		tcp_try_undo_recovery(sk);
 
 	/* Reset rtx states to prevent spurious retransmits_timed_out() */
+	tcp_update_rto_time(tp);
 	tp->retrans_stamp = 0;
 	inet_csk(sk)->icsk_retransmits = 0;
 
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 0c04c460001f1..cc2b608b1a8e7 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -560,6 +560,10 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 		newtp->undo_marker = treq->snt_isn;
 		newtp->retrans_stamp = div_u64(treq->snt_synack,
 					       USEC_PER_SEC / TCP_TS_HZ);
+		newtp->total_rto = req->num_timeout;
+		newtp->total_rto_recoveries = 1;
+		newtp->total_rto_time = tcp_time_stamp_raw() -
+						newtp->retrans_stamp;
 	}
 	newtp->tsoffset = treq->ts_off;
 #ifdef CONFIG_TCP_MD5SIG
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 64bcf384e9ddc..b65cd417b0f7c 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -411,6 +411,19 @@ abort:		tcp_write_err(sk);
 	}
 }
 
+static void tcp_update_rto_stats(struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	if (!icsk->icsk_retransmits) {
+		tp->total_rto_recoveries++;
+		tp->rto_stamp = tcp_time_stamp(tp);
+	}
+	icsk->icsk_retransmits++;
+	tp->total_rto++;
+}
+
 /*
  *	Timer for Fast Open socket to retransmit SYNACK. Note that the
  *	sk here is the child socket, not the parent (listener) socket.
@@ -443,7 +456,7 @@ static void tcp_fastopen_synack_timer(struct sock *sk, struct request_sock *req)
 	 */
 	inet_rtx_syn_ack(sk, req);
 	req->num_timeout++;
-	icsk->icsk_retransmits++;
+	tcp_update_rto_stats(sk);
 	if (!tp->retrans_stamp)
 		tp->retrans_stamp = tcp_time_stamp(tp);
 	inet_csk_reset_xmit_timer(sk, ICSK_TIME_RETRANS,
@@ -586,7 +599,7 @@ void tcp_retransmit_timer(struct sock *sk)
 
 	tcp_enter_loss(sk);
 
-	icsk->icsk_retransmits++;
+	tcp_update_rto_stats(sk);
 	if (tcp_retransmit_skb(sk, tcp_rtx_queue_head(sk), 1) > 0) {
 		/* Retransmission failed because of local congestion,
 		 * Let senders fight for local resources conservatively.
-- 
2.43.0



