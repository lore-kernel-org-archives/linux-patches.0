Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826291DDF5;
	Tue, 16 Jul 2024 15:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144657; cv=none; b=hCYeTWSibR+WGiLJ27dxwgF7CMd7SVGcY2y9A0uggyNmT1gWUkVxkRDscItXXR/02jTPa4L0EAh9ax63qcaqL/JMZFqHKfM+8ukq9TmLNrZKMbLCvB0gcuEg6GnVfdaO/l2t4IOIpQHTHiQ3je7IjFf6kTH14094YBnz0ESKbyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144657; c=relaxed/simple;
	bh=MkEA8Qg1lEJgiyky0kkIQdICw6wXPsRFe4cQplGd7xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JaX4UQYxGCQNj4+hqKJP2dL1YKcfhDR6K2KvLRp9AqI8iEWOe3G3QPmoygMuYciGGP3fus2mvpWYx5HCU6Yv4fTS88f9ayFpIZmQKl12Wow1/dbfsrAUbxVyAtNUx9UhT2+A2crmAP2QhHwyWyhD023I7OzFEo+sepUxs7IuWog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZLdL95z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZLdL95z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C66C116B1;
	Tue, 16 Jul 2024 15:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144657;
	bh=MkEA8Qg1lEJgiyky0kkIQdICw6wXPsRFe4cQplGd7xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZLdL95zkV3pIx4mRDcxoVZYNtFFaE684SHe3F0c+KaN4emzT1a1w6B3V6F8rwJ+o
	 iXZLgspHf8IesJKwJSeEKzUlaX8btlSqOdgKZCBjUzvedvQq4h+65vH40wlBnySBQv
	 8oUVRpEOtJOU08ZDMZdSKYgZ91xNXLASQxzyA5u4=
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
Subject: [PATCH 5.10 062/108] tcp: fix incorrect undo caused by DSACK of TLP retransmit
Date: Tue, 16 Jul 2024 17:31:17 +0200
Message-ID: <20240716152748.363715021@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 604ff1b04c3ef..06c03b21500fb 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2084,8 +2084,16 @@ void tcp_clear_retrans(struct tcp_sock *tp)
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
@@ -2164,6 +2172,7 @@ void tcp_enter_loss(struct sock *sk)
 
 	tcp_set_ca_state(sk, TCP_CA_Loss);
 	tp->high_seq = tp->snd_nxt;
+	tp->tlp_high_seq = 0;
 	tcp_ecn_queue_cwr(tp);
 
 	/* F-RTO RFC5682 sec 3.1 step 1: retransmit SND.UNA if no previous
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 5c7e10939dd90..2925b985e11cb 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -492,8 +492,6 @@ void tcp_retransmit_timer(struct sock *sk)
 	if (WARN_ON_ONCE(!skb))
 		return;
 
-	tp->tlp_high_seq = 0;
-
 	if (!tp->snd_wnd && !sock_flag(sk, SOCK_DEAD) &&
 	    !((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV))) {
 		/* Receiver dastardly shrinks window. Our retransmits
-- 
2.43.0



