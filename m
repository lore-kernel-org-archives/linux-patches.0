Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2855217A93F;
	Tue, 16 Jul 2024 15:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144863; cv=none; b=lVQ4jjLW1fLIGs+GweXV63oZ5f4Fjwk9wIds9OLQEo1ZEoYJkBKuiEqEasKAe0a2tQr3xffIttrWyCXZeWXKSyQ/Kua2hPCHTFY7MXv4HnGe7n+t/T/dAA6u2JLrJ5QSdWgKPP4sVQchz7ZsmBRag+U+Jcn7o3LPpsyA84Qt1vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144863; c=relaxed/simple;
	bh=vq3gCPQ/cu7xy4UJDaCvDO/YoEx5QEwzpKxwf3Ai7fU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8o4oB512/gPNtTA3xjbmurqU/PbKQk8wMrDckEPsbATsW0Fnx4dlKtMkq8v7yAvWNjK3GWKpEfMqaH6GzgCyr4ONzYWEcZeW7yyfYx1xo3wWsQlh8BGW1ASABuZJ+LrHTmdS8Jg/VlevZHWajGpfjYPD1X5r+25fGSjtuECt30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IxLnAh9a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IxLnAh9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2622C4AF0B;
	Tue, 16 Jul 2024 15:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144863;
	bh=vq3gCPQ/cu7xy4UJDaCvDO/YoEx5QEwzpKxwf3Ai7fU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IxLnAh9arvn1qMGdk7wMIOaNbpo25096r6606EQpvQLqnA1osutKM7paUDBp6X9pm
	 o9XfvXSzjJfm+EvR9fJN6+FuQi/Obgd/6w78UKTP/dh2F8Ndn93jg/bdUNTnav2mZr
	 E53+p0ytCUS+LIPJZcnRSCCro6qeYpLGMk5gaGq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Cardwell <ncardwell@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Yuchung Cheng <ycheng@google.com>,
	Kevin Yang <yyd@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 020/143] tcp: fix incorrect undo caused by DSACK of TLP retransmit
Date: Tue, 16 Jul 2024 17:30:16 +0200
Message-ID: <20240716152756.767741107@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit 0ec986ed7bab6801faed1440e8839dcc710331ff ]

Loss recovery undo_retrans bookkeeping had a long-standing bug where a
DSACK from a spurious TLP retransmit packet could cause an erroneous
undo of a fast recovery or RTO recovery that repaired a single
really-lost packet (in a sequence range outside that of the TLP
retransmit). Basically, because the loss recovery state machine didn't
account for the fact that it sent a TLP retransmit, the DSACK for the
TLP retransmit could erroneously be implicitly be interpreted as
corresponding to the normal fast recovery or RTO recovery retransmit
that plugged a real hole, thus resulting in an improper undo.

For example, consider the following buggy scenario where there is a
real packet loss but the congestion control response is improperly
undone because of this bug:

+ send packets P1, P2, P3, P4
+ P1 is really lost
+ send TLP retransmit of P4
+ receive SACK for original P2, P3, P4
+ enter fast recovery, fast-retransmit P1, increment undo_retrans to 1
+ receive DSACK for TLP P4, decrement undo_retrans to 0, undo (bug!)
+ receive cumulative ACK for P1-P4 (fast retransmit plugged real hole)

The fix: when we initialize undo machinery in tcp_init_undo(), if
there is a TLP retransmit in flight, then increment tp->undo_retrans
so that we make sure that we receive a DSACK corresponding to the TLP
retransmit, as well as DSACKs for all later normal retransmits, before
triggering a loss recovery undo. Note that we also have to move the
line that clears tp->tlp_high_seq for RTO recovery, so that upon RTO
we remember the tp->tlp_high_seq value until tcp_init_undo() and clear
it only afterward.

Also note that the bug dates back to the original 2013 TLP
implementation, commit 6ba8a3b19e76 ("tcp: Tail loss probe (TLP)").

However, this patch will only compile and work correctly with kernels
that have tp->tlp_retrans, which was added only in v5.8 in 2020 in
commit 76be93fc0702 ("tcp: allow at most one TLP probe per flight").
So we associate this fix with that later commit.

Fixes: 76be93fc0702 ("tcp: allow at most one TLP probe per flight")
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Kevin Yang <yyd@google.com>
Link: https://patch.msgid.link/20240703171246.1739561-1-ncardwell.sw@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 11 ++++++++++-
 net/ipv4/tcp_timer.c |  2 --
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 7b692bcb61d4a..c765d479869dc 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2126,8 +2126,16 @@ void tcp_clear_retrans(struct tcp_sock *tp)
 static inline void tcp_init_undo(struct tcp_sock *tp)
 {
 	tp->undo_marker = tp->snd_una;
+
 	/* Retransmission still in flight may cause DSACKs later. */
-	tp->undo_retrans = tp->retrans_out ? : -1;
+	/* First, account for regular retransmits in flight: */
+	tp->undo_retrans = tp->retrans_out;
+	/* Next, account for TLP retransmits in flight: */
+	if (tp->tlp_high_seq && tp->tlp_retrans)
+		tp->undo_retrans++;
+	/* Finally, avoid 0, because undo_retrans==0 means "can undo now": */
+	if (!tp->undo_retrans)
+		tp->undo_retrans = -1;
 }
 
 static bool tcp_is_rack(const struct sock *sk)
@@ -2206,6 +2214,7 @@ void tcp_enter_loss(struct sock *sk)
 
 	tcp_set_ca_state(sk, TCP_CA_Loss);
 	tp->high_seq = tp->snd_nxt;
+	tp->tlp_high_seq = 0;
 	tcp_ecn_queue_cwr(tp);
 
 	/* F-RTO RFC5682 sec 3.1 step 1: retransmit SND.UNA if no previous
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index f96f68cf7961c..22d25f63858b9 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -534,8 +534,6 @@ void tcp_retransmit_timer(struct sock *sk)
 	if (WARN_ON_ONCE(!skb))
 		return;
 
-	tp->tlp_high_seq = 0;
-
 	if (!tp->snd_wnd && !sock_flag(sk, SOCK_DEAD) &&
 	    !((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV))) {
 		/* Receiver dastardly shrinks window. Our retransmits
-- 
2.43.0



