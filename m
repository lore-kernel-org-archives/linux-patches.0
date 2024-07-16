Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE76CA40;
	Tue, 16 Jul 2024 15:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144166; cv=none; b=Bq1FUYvz0Sd71GeH0PNT5zR3l6LspjRaHoY3rnxV0El/bNaa3nHF5zE1Pf/sN6fqL680IAo6G0kjqBJ0etnsjd4pagE46cwgovXn8DLAeKHtCDIliNi736Lan1D2IPuUB3Ed7eMrrv16vkhRUB454Qi7lL4CYlPtZFZx1GxO8eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144166; c=relaxed/simple;
	bh=5+rjHLG49tbDSmTUqA9EdMmMC4rphbm5bI5wSVFaHHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/VZe6g0iZqLUoqZn4MRQcx/l+5KF2B9L9CMYZbT/SpKkwwDp2yoqXbXeFnws1sYs36kQ9kSEoLOSeG0+6fjQTwxfwZM6MUdpYfJIpzGqf0alj/gNx4LOonZ8URO0gcPEnWkmEwv8mlWAH0M5aXX3ohj/DvQx0yNS6YlJZPCsOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNQfc+wv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNQfc+wv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E182C116B1;
	Tue, 16 Jul 2024 15:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144165;
	bh=5+rjHLG49tbDSmTUqA9EdMmMC4rphbm5bI5wSVFaHHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNQfc+wv9U7BeHE/63cs9Bgmf+qlUSdOdejhA7Zgw8ZHXo7SJucRpQJSbzrHhTRbm
	 KHkQdDJjt8qe+gfRUrfmRpWZqilMIzE+OKDdJ1viAPhE7WJ+LFe++0Ik4W/BUmYmHG
	 l9DsWS6RIL6w1XpeuCGQ2a1Gz/agcLBr3gBpB2h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 19/66] tcp: take care of compressed acks in tcp_add_reno_sack()
Date: Tue, 16 Jul 2024 17:30:54 +0200
Message-ID: <20240716152738.896352652@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
References: <20240716152738.161055634@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 19119f298bb1f2af3bb1093f5f2a1fed8da94e37 ]

Neal pointed out that non sack flows might suffer from ACK compression
added in the following patch ("tcp: implement coalescing on backlog queue")

Instead of tweaking tcp_add_backlog() we can take into
account how many ACK were coalesced, this information
will be available in skb_shinfo(skb)->gso_segs

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: a6458ab7fd4f ("UPSTREAM: tcp: fix DSACK undo in fast recovery to call tcp_try_to_open()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 58 +++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 25 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 6a8c7c521d36e..022d75c67096a 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1897,16 +1897,20 @@ static void tcp_check_reno_reordering(struct sock *sk, const int addend)
 
 /* Emulate SACKs for SACKless connection: account for a new dupack. */
 
-static void tcp_add_reno_sack(struct sock *sk)
+static void tcp_add_reno_sack(struct sock *sk, int num_dupack)
 {
-	struct tcp_sock *tp = tcp_sk(sk);
-	u32 prior_sacked = tp->sacked_out;
+	if (num_dupack) {
+		struct tcp_sock *tp = tcp_sk(sk);
+		u32 prior_sacked = tp->sacked_out;
+		s32 delivered;
 
-	tp->sacked_out++;
-	tcp_check_reno_reordering(sk, 0);
-	if (tp->sacked_out > prior_sacked)
-		tp->delivered++; /* Some out-of-order packet is delivered */
-	tcp_verify_left_out(tp);
+		tp->sacked_out += num_dupack;
+		tcp_check_reno_reordering(sk, 0);
+		delivered = tp->sacked_out - prior_sacked;
+		if (delivered > 0)
+			tp->delivered += delivered;
+		tcp_verify_left_out(tp);
+	}
 }
 
 /* Account for ACK, ACKing some data in Reno Recovery phase. */
@@ -2687,7 +2691,7 @@ void tcp_enter_recovery(struct sock *sk, bool ece_ack)
 /* Process an ACK in CA_Loss state. Move to CA_Open if lost data are
  * recovered or spurious. Otherwise retransmits more on partial ACKs.
  */
-static void tcp_process_loss(struct sock *sk, int flag, bool is_dupack,
+static void tcp_process_loss(struct sock *sk, int flag, int num_dupack,
 			     int *rexmit)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -2706,7 +2710,7 @@ static void tcp_process_loss(struct sock *sk, int flag, bool is_dupack,
 			return;
 
 		if (after(tp->snd_nxt, tp->high_seq)) {
-			if (flag & FLAG_DATA_SACKED || is_dupack)
+			if (flag & FLAG_DATA_SACKED || num_dupack)
 				tp->frto = 0; /* Step 3.a. loss was real */
 		} else if (flag & FLAG_SND_UNA_ADVANCED && !recovered) {
 			tp->high_seq = tp->snd_nxt;
@@ -2732,8 +2736,8 @@ static void tcp_process_loss(struct sock *sk, int flag, bool is_dupack,
 		/* A Reno DUPACK means new data in F-RTO step 2.b above are
 		 * delivered. Lower inflight to clock out (re)tranmissions.
 		 */
-		if (after(tp->snd_nxt, tp->high_seq) && is_dupack)
-			tcp_add_reno_sack(sk);
+		if (after(tp->snd_nxt, tp->high_seq) && num_dupack)
+			tcp_add_reno_sack(sk, num_dupack);
 		else if (flag & FLAG_SND_UNA_ADVANCED)
 			tcp_reset_reno_sack(tp);
 	}
@@ -2811,13 +2815,13 @@ static bool tcp_force_fast_retransmit(struct sock *sk)
  * tcp_xmit_retransmit_queue().
  */
 static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
-				  bool is_dupack, int *ack_flag, int *rexmit)
+				  int num_dupack, int *ack_flag, int *rexmit)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	int fast_rexmit = 0, flag = *ack_flag;
-	bool do_lost = is_dupack || ((flag & FLAG_DATA_SACKED) &&
-				     tcp_force_fast_retransmit(sk));
+	bool do_lost = num_dupack || ((flag & FLAG_DATA_SACKED) &&
+				      tcp_force_fast_retransmit(sk));
 
 	if (!tp->packets_out && tp->sacked_out)
 		tp->sacked_out = 0;
@@ -2864,8 +2868,8 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 	switch (icsk->icsk_ca_state) {
 	case TCP_CA_Recovery:
 		if (!(flag & FLAG_SND_UNA_ADVANCED)) {
-			if (tcp_is_reno(tp) && is_dupack)
-				tcp_add_reno_sack(sk);
+			if (tcp_is_reno(tp))
+				tcp_add_reno_sack(sk, num_dupack);
 		} else {
 			if (tcp_try_undo_partial(sk, prior_snd_una))
 				return;
@@ -2880,7 +2884,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 		tcp_identify_packet_loss(sk, ack_flag);
 		break;
 	case TCP_CA_Loss:
-		tcp_process_loss(sk, flag, is_dupack, rexmit);
+		tcp_process_loss(sk, flag, num_dupack, rexmit);
 		tcp_identify_packet_loss(sk, ack_flag);
 		if (!(icsk->icsk_ca_state == TCP_CA_Open ||
 		      (*ack_flag & FLAG_LOST_RETRANS)))
@@ -2891,8 +2895,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 		if (tcp_is_reno(tp)) {
 			if (flag & FLAG_SND_UNA_ADVANCED)
 				tcp_reset_reno_sack(tp);
-			if (is_dupack)
-				tcp_add_reno_sack(sk);
+			tcp_add_reno_sack(sk, num_dupack);
 		}
 
 		if (icsk->icsk_ca_state <= TCP_CA_Disorder)
@@ -3623,7 +3626,7 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	bool is_sack_reneg = tp->is_sack_reneg;
 	u32 ack_seq = TCP_SKB_CB(skb)->seq;
 	u32 ack = TCP_SKB_CB(skb)->ack_seq;
-	bool is_dupack = false;
+	int num_dupack = 0;
 	int prior_packets = tp->packets_out;
 	u32 delivered = tp->delivered;
 	u32 lost = tp->lost;
@@ -3743,8 +3746,13 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 		tcp_process_tlp_ack(sk, ack, flag);
 
 	if (tcp_ack_is_dubious(sk, flag)) {
-		is_dupack = !(flag & (FLAG_SND_UNA_ADVANCED | FLAG_NOT_DUP));
-		tcp_fastretrans_alert(sk, prior_snd_una, is_dupack, &flag,
+		if (!(flag & (FLAG_SND_UNA_ADVANCED | FLAG_NOT_DUP))) {
+			num_dupack = 1;
+			/* Consider if pure acks were aggregated in tcp_add_backlog() */
+			if (!(flag & FLAG_DATA))
+				num_dupack = max_t(u16, 1, skb_shinfo(skb)->gso_segs);
+		}
+		tcp_fastretrans_alert(sk, prior_snd_una, num_dupack, &flag,
 				      &rexmit);
 	}
 
@@ -3766,7 +3774,7 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 no_queue:
 	/* If data was DSACKed, see if we can undo a cwnd reduction. */
 	if (flag & FLAG_DSACKING_ACK) {
-		tcp_fastretrans_alert(sk, prior_snd_una, is_dupack, &flag,
+		tcp_fastretrans_alert(sk, prior_snd_una, num_dupack, &flag,
 				      &rexmit);
 		tcp_newly_delivered(sk, delivered, flag);
 	}
@@ -3791,7 +3799,7 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	if (TCP_SKB_CB(skb)->sacked) {
 		flag |= tcp_sacktag_write_queue(sk, skb, prior_snd_una,
 						&sack_state);
-		tcp_fastretrans_alert(sk, prior_snd_una, is_dupack, &flag,
+		tcp_fastretrans_alert(sk, prior_snd_una, num_dupack, &flag,
 				      &rexmit);
 		tcp_newly_delivered(sk, delivered, flag);
 		tcp_xmit_recovery(sk, rexmit);
-- 
2.43.0



