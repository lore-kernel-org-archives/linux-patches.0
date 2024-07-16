Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6CB1DDCE;
	Tue, 16 Jul 2024 15:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144381; cv=none; b=Dih5HUfzSVQHTvH1/WqC2m3f/CvHxUnzU02SX1kL2ddyu4tdqiL3gZvlGJsQvyFkfbl0PocshTtKT1pekw1xW2h1QVyDsBRz4f+SzZ6fYbNux8ywq76qPV59lH1n38+2XndUN/DFzJp1WFSoh8behq3+ZP4BP/9M8IVGizC19Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144381; c=relaxed/simple;
	bh=imXQprr2FWMIMYARRieyqa2qmz4Q0rxIAxGF9qBuDwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JP0tmPHwdRnDFvVQq0D0W8XIhBPMhzW7rdoVtRzdJX+PGzuE+hzW5V6AgmY/Aic8zG1r3jDoJYZDOgXwZGqJ2pIYlmeJ0yzZmNJmALNRMTq4Z8LCTM/5vX+SmD3hBnt4zblKlvSKrVOFGVAGKzDqe3fwl3SYSVWcDIZaqtrv4dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZ2raM1d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZ2raM1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F182EC116B1;
	Tue, 16 Jul 2024 15:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144381;
	bh=imXQprr2FWMIMYARRieyqa2qmz4Q0rxIAxGF9qBuDwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OZ2raM1dvT3CEtDtzds0pmUOEp1+ujcoM29RcDpTTICHhtULjC3z7pCCpYRZMO8Zz
	 NeEKhT57ZsWYMcjKrFn75FLJnJtuLHKfIbD1B6wTEpdia0OtoepoyS2Xz/NXXQE7aj
	 eDOrVgcYGv6mqFgoty6EgupHlx+JgHdVft2GMMRo=
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
Subject: [PATCH 5.4 23/78] tcp: add ece_ack flag to reno sack functions
Date: Tue, 16 Jul 2024 17:30:55 +0200
Message-ID: <20240716152741.531736258@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index dc446d7c9e0f2..0451249c61e27 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1905,7 +1905,7 @@ static void tcp_check_reno_reordering(struct sock *sk, const int addend)
 
 /* Emulate SACKs for SACKless connection: account for a new dupack. */
 
-static void tcp_add_reno_sack(struct sock *sk, int num_dupack)
+static void tcp_add_reno_sack(struct sock *sk, int num_dupack, bool ece_ack)
 {
 	if (num_dupack) {
 		struct tcp_sock *tp = tcp_sk(sk);
@@ -1923,7 +1923,7 @@ static void tcp_add_reno_sack(struct sock *sk, int num_dupack)
 
 /* Account for ACK, ACKing some data in Reno Recovery phase. */
 
-static void tcp_remove_reno_sacks(struct sock *sk, int acked)
+static void tcp_remove_reno_sacks(struct sock *sk, int acked, bool ece_ack)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
@@ -2729,7 +2729,7 @@ static void tcp_process_loss(struct sock *sk, int flag, int num_dupack,
 		 * delivered. Lower inflight to clock out (re)tranmissions.
 		 */
 		if (after(tp->snd_nxt, tp->high_seq) && num_dupack)
-			tcp_add_reno_sack(sk, num_dupack);
+			tcp_add_reno_sack(sk, num_dupack, flag & FLAG_ECE);
 		else if (flag & FLAG_SND_UNA_ADVANCED)
 			tcp_reset_reno_sack(tp);
 	}
@@ -2812,6 +2812,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	int fast_rexmit = 0, flag = *ack_flag;
+	bool ece_ack = flag & FLAG_ECE;
 	bool do_lost = num_dupack || ((flag & FLAG_DATA_SACKED) &&
 				      tcp_force_fast_retransmit(sk));
 
@@ -2820,7 +2821,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 
 	/* Now state machine starts.
 	 * A. ECE, hence prohibit cwnd undoing, the reduction is required. */
-	if (flag & FLAG_ECE)
+	if (ece_ack)
 		tp->prior_ssthresh = 0;
 
 	/* B. In all the states check for reneging SACKs. */
@@ -2861,7 +2862,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 	case TCP_CA_Recovery:
 		if (!(flag & FLAG_SND_UNA_ADVANCED)) {
 			if (tcp_is_reno(tp))
-				tcp_add_reno_sack(sk, num_dupack);
+				tcp_add_reno_sack(sk, num_dupack, ece_ack);
 		} else {
 			if (tcp_try_undo_partial(sk, prior_snd_una))
 				return;
@@ -2886,7 +2887,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 		if (tcp_is_reno(tp)) {
 			if (flag & FLAG_SND_UNA_ADVANCED)
 				tcp_reset_reno_sack(tp);
-			tcp_add_reno_sack(sk, num_dupack);
+			tcp_add_reno_sack(sk, num_dupack, ece_ack);
 		}
 
 		if (icsk->icsk_ca_state <= TCP_CA_Disorder)
@@ -2910,7 +2911,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 		}
 
 		/* Otherwise enter Recovery state */
-		tcp_enter_recovery(sk, (flag & FLAG_ECE));
+		tcp_enter_recovery(sk, ece_ack);
 		fast_rexmit = 1;
 	}
 
@@ -3088,7 +3089,7 @@ static void tcp_ack_tstamp(struct sock *sk, struct sk_buff *skb,
  */
 static int tcp_clean_rtx_queue(struct sock *sk, u32 prior_fack,
 			       u32 prior_snd_una,
-			       struct tcp_sacktag_state *sack)
+			       struct tcp_sacktag_state *sack, bool ece_ack)
 {
 	const struct inet_connection_sock *icsk = inet_csk(sk);
 	u64 first_ackt, last_ackt;
@@ -3226,7 +3227,7 @@ static int tcp_clean_rtx_queue(struct sock *sk, u32 prior_fack,
 		}
 
 		if (tcp_is_reno(tp)) {
-			tcp_remove_reno_sacks(sk, pkts_acked);
+			tcp_remove_reno_sacks(sk, pkts_acked, ece_ack);
 
 			/* If any of the cumulatively ACKed segments was
 			 * retransmitted, non-SACK case cannot confirm that
@@ -3735,7 +3736,8 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 		goto no_queue;
 
 	/* See if we can take anything off of the retransmit queue. */
-	flag |= tcp_clean_rtx_queue(sk, prior_fack, prior_snd_una, &sack_state);
+	flag |= tcp_clean_rtx_queue(sk, prior_fack, prior_snd_una, &sack_state,
+				    flag & FLAG_ECE);
 
 	tcp_rack_update_reo_wnd(sk, &rs);
 
-- 
2.43.0



