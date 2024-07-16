Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED29BCA40;
	Tue, 16 Jul 2024 15:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144172; cv=none; b=k2qgalU6ZGB2btqPOJeUNrYuZhaydpTf4SjXF5HMSQ8AOMvvx85xCeutI2Aloog1+cv+pOQYA3fwWhOb7QBdj7FWqdMoe5yt5xlrbkB1BchbvGGDPmoL5UdXFl5XGzRufab6KaXIOFf4m/r2lyGxoAdpcLQbI80+TqqKiwPhjl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144172; c=relaxed/simple;
	bh=vVg3K6dmkluoDCRG04APAsv1lG3XbD4E5UvTQMSvZgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYkYFOeaw1zT0FK5gWv9q0acUslbJGqQRMRcGUuKm6H5QNSzLmWyKrjobFpx6oOD+DSsOs7Awg5VSdL8bJp6xZNifMkhRf25gVGh//U/G5Nf4as59FF/oqCXwQiNLLQhtmZsZmKTgrlszK9bRU2WM1E/XzJD9f6Fl0JGy7NRr1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EDCVsLwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EDCVsLwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF9FC116B1;
	Tue, 16 Jul 2024 15:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144171;
	bh=vVg3K6dmkluoDCRG04APAsv1lG3XbD4E5UvTQMSvZgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EDCVsLwz1eL8hMrgPxs1/ahqxsA5zyfUbfPlVn/sSyNAEtpywR03a8g7iW9Ujq4jN
	 3XdJgf0DIuPPoA1OFHag9jC6rFAsqbcwvKqCsqP51lBsM5u3EL1H+o4DG76UZHLSd9
	 TQs5X4FP0rcEsDwVlNS7hXqQslKGttWovW+1Hxtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousuk Seung <ysseung@google.com>,
	Yuchung Cheng <ycheng@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Soheil Hassas Yeganeh <soheil@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 21/66] tcp: add ece_ack flag to reno sack functions
Date: Tue, 16 Jul 2024 17:30:56 +0200
Message-ID: <20240716152738.972563975@linuxfoundation.org>
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

From: Yousuk Seung <ysseung@google.com>

[ Upstream commit c634e34f6ebfb75259e6ce467523fd3adf30d3d2 ]

Pass a boolean flag that tells the ECE state of the current ack to reno
sack functions. This is pure refactor for future patches to improve
tracking delivered counts.

Signed-off-by: Yousuk Seung <ysseung@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: a6458ab7fd4f ("UPSTREAM: tcp: fix DSACK undo in fast recovery to call tcp_try_to_open()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e51aa5a149c0f..88216b87c986f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1897,7 +1897,7 @@ static void tcp_check_reno_reordering(struct sock *sk, const int addend)
 
 /* Emulate SACKs for SACKless connection: account for a new dupack. */
 
-static void tcp_add_reno_sack(struct sock *sk, int num_dupack)
+static void tcp_add_reno_sack(struct sock *sk, int num_dupack, bool ece_ack)
 {
 	if (num_dupack) {
 		struct tcp_sock *tp = tcp_sk(sk);
@@ -1915,7 +1915,7 @@ static void tcp_add_reno_sack(struct sock *sk, int num_dupack)
 
 /* Account for ACK, ACKing some data in Reno Recovery phase. */
 
-static void tcp_remove_reno_sacks(struct sock *sk, int acked)
+static void tcp_remove_reno_sacks(struct sock *sk, int acked, bool ece_ack)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
@@ -2720,7 +2720,7 @@ static void tcp_process_loss(struct sock *sk, int flag, int num_dupack,
 		 * delivered. Lower inflight to clock out (re)tranmissions.
 		 */
 		if (after(tp->snd_nxt, tp->high_seq) && num_dupack)
-			tcp_add_reno_sack(sk, num_dupack);
+			tcp_add_reno_sack(sk, num_dupack, flag & FLAG_ECE);
 		else if (flag & FLAG_SND_UNA_ADVANCED)
 			tcp_reset_reno_sack(tp);
 	}
@@ -2803,6 +2803,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	int fast_rexmit = 0, flag = *ack_flag;
+	bool ece_ack = flag & FLAG_ECE;
 	bool do_lost = num_dupack || ((flag & FLAG_DATA_SACKED) &&
 				      tcp_force_fast_retransmit(sk));
 
@@ -2811,7 +2812,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 
 	/* Now state machine starts.
 	 * A. ECE, hence prohibit cwnd undoing, the reduction is required. */
-	if (flag & FLAG_ECE)
+	if (ece_ack)
 		tp->prior_ssthresh = 0;
 
 	/* B. In all the states check for reneging SACKs. */
@@ -2852,7 +2853,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 	case TCP_CA_Recovery:
 		if (!(flag & FLAG_SND_UNA_ADVANCED)) {
 			if (tcp_is_reno(tp))
-				tcp_add_reno_sack(sk, num_dupack);
+				tcp_add_reno_sack(sk, num_dupack, ece_ack);
 		} else {
 			if (tcp_try_undo_partial(sk, prior_snd_una))
 				return;
@@ -2877,7 +2878,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 		if (tcp_is_reno(tp)) {
 			if (flag & FLAG_SND_UNA_ADVANCED)
 				tcp_reset_reno_sack(tp);
-			tcp_add_reno_sack(sk, num_dupack);
+			tcp_add_reno_sack(sk, num_dupack, ece_ack);
 		}
 
 		if (icsk->icsk_ca_state <= TCP_CA_Disorder)
@@ -2901,7 +2902,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 		}
 
 		/* Otherwise enter Recovery state */
-		tcp_enter_recovery(sk, (flag & FLAG_ECE));
+		tcp_enter_recovery(sk, ece_ack);
 		fast_rexmit = 1;
 	}
 
@@ -3077,7 +3078,7 @@ static void tcp_ack_tstamp(struct sock *sk, struct sk_buff *skb,
  */
 static int tcp_clean_rtx_queue(struct sock *sk, u32 prior_fack,
 			       u32 prior_snd_una,
-			       struct tcp_sacktag_state *sack)
+			       struct tcp_sacktag_state *sack, bool ece_ack)
 {
 	const struct inet_connection_sock *icsk = inet_csk(sk);
 	u64 first_ackt, last_ackt;
@@ -3215,7 +3216,7 @@ static int tcp_clean_rtx_queue(struct sock *sk, u32 prior_fack,
 		}
 
 		if (tcp_is_reno(tp)) {
-			tcp_remove_reno_sacks(sk, pkts_acked);
+			tcp_remove_reno_sacks(sk, pkts_acked, ece_ack);
 
 			/* If any of the cumulatively ACKed segments was
 			 * retransmitted, non-SACK case cannot confirm that
@@ -3720,7 +3721,8 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 		goto no_queue;
 
 	/* See if we can take anything off of the retransmit queue. */
-	flag |= tcp_clean_rtx_queue(sk, prior_fack, prior_snd_una, &sack_state);
+	flag |= tcp_clean_rtx_queue(sk, prior_fack, prior_snd_una, &sack_state,
+				    flag & FLAG_ECE);
 
 	tcp_rack_update_reo_wnd(sk, &rs);
 
-- 
2.43.0



