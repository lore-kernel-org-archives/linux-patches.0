Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397BF3D978;
	Tue,  2 Jul 2024 17:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940820; cv=none; b=coPL6d4M91igJQo7WBC1A4+Fc6GI/U87eGtAwT92NRNi8FiFKQjhnPOFTA9JDsOqKTy2uF0U9ik4skyQd/DzGfuKYwNsZTd4qEBm2sATFzwJBkxR5vNUNYCb8xO7Uq9pEjESVwTGsX/fond/pP7Nifs1wq4jHkqzKeQ9/r0GLQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940820; c=relaxed/simple;
	bh=DzezM12XCmHcQlyF524BzIh+z8ldhSnZGH9ljyVlTnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npX3pO5HPvrdAcGJYKmXniQl2+P2Wl5ONMof+yqmk9NsLOBJfRnT4zPZGnnkxh9f2THDDGX2i9lz8vbQqpelhG0JRrCwyyJ8IOeAcVegWi8eBptHcZzI2NOyRReQXiaVdtChusIrdUW0LopTFAmxdAvhf58YGJNz1oRMdgznaoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yw5w1LkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yw5w1LkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47D1C116B1;
	Tue,  2 Jul 2024 17:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940820;
	bh=DzezM12XCmHcQlyF524BzIh+z8ldhSnZGH9ljyVlTnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yw5w1LkNJxKtRGxAxlT22y/Unz55z53FUCK6RrLYKhWukVhIlgfyHEcmuvUIlCs6e
	 BUxFxwYqAcJoG8T/k5L5xxD2iEORiGXgVBx1+byizDAVw98WMlXWpR21ZCd4kR8SBo
	 Cbu/nrFmPmf3F+xs7kDZbdL0RkO3m1Qi/ccjGbrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Cardwell <ncardwell@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Yuchung Cheng <ycheng@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/163] tcp: fix tcp_rcv_fastopen_synack() to enter TCP_CA_Loss for failed TFO
Date: Tue,  2 Jul 2024 19:02:40 +0200
Message-ID: <20240702170234.807052500@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit 5dfe9d273932c647bdc9d664f939af9a5a398cbc ]

Testing determined that the recent commit 9e046bb111f1 ("tcp: clear
tp->retrans_stamp in tcp_rcv_fastopen_synack()") has a race, and does
not always ensure retrans_stamp is 0 after a TFO payload retransmit.

If transmit completion for the SYN+data skb happens after the client
TCP stack receives the SYNACK (which sometimes happens), then
retrans_stamp can erroneously remain non-zero for the lifetime of the
connection, causing a premature ETIMEDOUT later.

Testing and tracing showed that the buggy scenario is the following
somewhat tricky sequence:

+ Client attempts a TFO handshake. tcp_send_syn_data() sends SYN + TFO
  cookie + data in a single packet in the syn_data skb. It hands the
  syn_data skb to tcp_transmit_skb(), which makes a clone. Crucially,
  it then reuses the same original (non-clone) syn_data skb,
  transforming it by advancing the seq by one byte and removing the
  FIN bit, and enques the resulting payload-only skb in the
  sk->tcp_rtx_queue.

+ Client sets retrans_stamp to the start time of the three-way
  handshake.

+ Cookie mismatches or server has TFO disabled, and server only ACKs
  SYN.

+ tcp_ack() sees SYN is acked, tcp_clean_rtx_queue() clears
  retrans_stamp.

+ Since the client SYN was acked but not the payload, the TFO failure
  code path in tcp_rcv_fastopen_synack() tries to retransmit the
  payload skb.  However, in some cases the transmit completion for the
  clone of the syn_data (which had SYN + TFO cookie + data) hasn't
  happened.  In those cases, skb_still_in_host_queue() returns true
  for the retransmitted TFO payload, because the clone of the syn_data
  skb has not had its tx completetion.

+ Because skb_still_in_host_queue() finds skb_fclone_busy() is true,
  it sets the TSQ_THROTTLED bit and the retransmit does not happen in
  the tcp_rcv_fastopen_synack() call chain.

+ The tcp_rcv_fastopen_synack() code next implicitly assumes the
  retransmit process is finished, and sets retrans_stamp to 0 to clear
  it, but this is later overwritten (see below).

+ Later, upon tx completion, tcp_tsq_write() calls
  tcp_xmit_retransmit_queue(), which puts the retransmit in flight and
  sets retrans_stamp to a non-zero value.

+ The client receives an ACK for the retransmitted TFO payload data.

+ Since we're in CA_Open and there are no dupacks/SACKs/DSACKs/ECN to
  make tcp_ack_is_dubious() true and make us call
  tcp_fastretrans_alert() and reach a code path that clears
  retrans_stamp, retrans_stamp stays nonzero.

+ Later, if there is a TLP, RTO, RTO sequence, then the connection
  will suffer an early ETIMEDOUT due to the erroneously ancient
  retrans_stamp.

The fix: this commit refactors the code to have
tcp_rcv_fastopen_synack() retransmit by reusing the relevant parts of
tcp_simple_retransmit() that enter CA_Loss (without changing cwnd) and
call tcp_xmit_retransmit_queue(). We have tcp_simple_retransmit() and
tcp_rcv_fastopen_synack() share code in this way because in both cases
we get a packet indicating non-congestion loss (MTU reduction or TFO
failure) and thus in both cases we want to retransmit as many packets
as cwnd allows, without reducing cwnd. And given that retransmits will
set retrans_stamp to a non-zero value (and may do so in a later
calling context due to TSQ), we also want to enter CA_Loss so that we
track when all retransmitted packets are ACked and clear retrans_stamp
when that happens (to ensure later recurring RTOs are using the
correct retrans_stamp and don't declare ETIMEDOUT prematurely).

Fixes: 9e046bb111f1 ("tcp: clear tp->retrans_stamp in tcp_rcv_fastopen_synack()")
Fixes: a7abf3cd76e1 ("tcp: consider using standard rtx logic in tcp_rcv_fastopen_synack()")
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Link: https://patch.msgid.link/20240624144323.2371403-1-ncardwell.sw@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 64707a5227f5a..6743b6bfbc9c5 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2759,13 +2759,37 @@ static void tcp_mtup_probe_success(struct sock *sk)
 	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMTUPSUCCESS);
 }
 
+/* Sometimes we deduce that packets have been dropped due to reasons other than
+ * congestion, like path MTU reductions or failed client TFO attempts. In these
+ * cases we call this function to retransmit as many packets as cwnd allows,
+ * without reducing cwnd. Given that retransmits will set retrans_stamp to a
+ * non-zero value (and may do so in a later calling context due to TSQ), we
+ * also enter CA_Loss so that we track when all retransmitted packets are ACKed
+ * and clear retrans_stamp when that happens (to ensure later recurring RTOs
+ * are using the correct retrans_stamp and don't declare ETIMEDOUT
+ * prematurely).
+ */
+static void tcp_non_congestion_loss_retransmit(struct sock *sk)
+{
+	const struct inet_connection_sock *icsk = inet_csk(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	if (icsk->icsk_ca_state != TCP_CA_Loss) {
+		tp->high_seq = tp->snd_nxt;
+		tp->snd_ssthresh = tcp_current_ssthresh(sk);
+		tp->prior_ssthresh = 0;
+		tp->undo_marker = 0;
+		tcp_set_ca_state(sk, TCP_CA_Loss);
+	}
+	tcp_xmit_retransmit_queue(sk);
+}
+
 /* Do a simple retransmit without using the backoff mechanisms in
  * tcp_timer. This is used for path mtu discovery.
  * The socket is already locked here.
  */
 void tcp_simple_retransmit(struct sock *sk)
 {
-	const struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *skb;
 	int mss;
@@ -2805,14 +2829,7 @@ void tcp_simple_retransmit(struct sock *sk)
 	 * in network, but units changed and effective
 	 * cwnd/ssthresh really reduced now.
 	 */
-	if (icsk->icsk_ca_state != TCP_CA_Loss) {
-		tp->high_seq = tp->snd_nxt;
-		tp->snd_ssthresh = tcp_current_ssthresh(sk);
-		tp->prior_ssthresh = 0;
-		tp->undo_marker = 0;
-		tcp_set_ca_state(sk, TCP_CA_Loss);
-	}
-	tcp_xmit_retransmit_queue(sk);
+	tcp_non_congestion_loss_retransmit(sk);
 }
 EXPORT_SYMBOL(tcp_simple_retransmit);
 
@@ -6175,8 +6192,7 @@ static bool tcp_rcv_fastopen_synack(struct sock *sk, struct sk_buff *synack,
 			tp->fastopen_client_fail = TFO_DATA_NOT_ACKED;
 		skb_rbtree_walk_from(data)
 			 tcp_mark_skb_lost(sk, data);
-		tcp_xmit_retransmit_queue(sk);
-		tp->retrans_stamp = 0;
+		tcp_non_congestion_loss_retransmit(sk);
 		NET_INC_STATS(sock_net(sk),
 				LINUX_MIB_TCPFASTOPENACTIVEFAIL);
 		return true;
-- 
2.43.0



