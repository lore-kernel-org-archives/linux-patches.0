Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771EA1DDCE;
	Tue, 16 Jul 2024 15:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145274; cv=none; b=oTF4ISVmfMu5vMCn+0UcpDbRxc2X30K7SQP3dzrtv2ULV7qYft8jkZ03yzl4nKRyZc/OFb1zwuSzvFIozBMqeI7dAEShqFjOiKdvXAAs4Ur+afMq7h3mapUQznvSwsPR2we4QqC/aFxcvXLk7SfHaZo+pJ/MgclKThCIg/RAkh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145274; c=relaxed/simple;
	bh=ZaK/q+QfF4uqAXqJ+34kp2HXbi0kC9Ajo7vRBB/l63c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jEtPWXxQpRLBEAGn3e3VRNC9qRFY+sV57mdALf08JiFQjK9qbyfqOLWUEq2FpvGfECq8gAVqQFG3T4vCziBiRHq2cKBfv35QAbu1Il7Q9SLcw0BFH7n6oNmhLn3N8qs52oYES5PMdb9qpJRLpUcYeXh+8LWJqWjEkRomSjMJhb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E22/vV0F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E22/vV0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1F2C116B1;
	Tue, 16 Jul 2024 15:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145274;
	bh=ZaK/q+QfF4uqAXqJ+34kp2HXbi0kC9Ajo7vRBB/l63c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E22/vV0Fqw0KSR8sP4fpT9j8chUX0uDKybtup8FUFxqC2lpX44xOvbPYgA3NquG5j
	 lW4Sea30hOm2EkFx7MOL2WZBxyRicw/xqUBqL8BgCOjpGS//OYV1rR3ZNn2vJHO3Ck
	 6biA12ZeQ6qhaR9RzPDP128QKYvlp6XK+JUMs/9w=
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
Subject: [PATCH 6.1 12/96] tcp: fix incorrect undo caused by DSACK of TLP retransmit
Date: Tue, 16 Jul 2024 17:31:23 +0200
Message-ID: <20240716152746.989940024@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 317cb90d77102..359ffda9b736b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2101,8 +2101,16 @@ void tcp_clear_retrans(struct tcp_sock *tp)
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
@@ -2181,6 +2189,7 @@ void tcp_enter_loss(struct sock *sk)
 
 	tcp_set_ca_state(sk, TCP_CA_Loss);
 	tp->high_seq = tp->snd_nxt;
+	tp->tlp_high_seq = 0;
 	tcp_ecn_queue_cwr(tp);
 
 	/* F-RTO RFC5682 sec 3.1 step 1: retransmit SND.UNA if no previous
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 44b49f7d1a9e6..f36492331ef0b 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -496,8 +496,6 @@ void tcp_retransmit_timer(struct sock *sk)
 	if (WARN_ON_ONCE(!skb))
 		return;
 
-	tp->tlp_high_seq = 0;
-
 	if (!tp->snd_wnd && !sock_flag(sk, SOCK_DEAD) &&
 	    !((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV))) {
 		/* Receiver dastardly shrinks window. Our retransmits
-- 
2.43.0



