Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2140DCA40;
	Tue, 16 Jul 2024 15:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144148; cv=none; b=Ux1feM1df3XdJ8Jd1S0icXsscs3IiQ4S5pr+ozN57ffwtMSV9fPNMOCKEEYhGAZKePGudYEXXT4VGs0rUhdrUAOKutvM7tT/Du3bV1cH5TwjCMqgoaYqeU4zku6VheQzc7so2kMpSQXUwIwdJd2JZTnrbZ4ZTUXfqcyhfm8BNJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144148; c=relaxed/simple;
	bh=xRbunoqeimjsvAswC7tKTKVx2SoqkdFvLCQS4kaQty8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AnDJoKAkuLrUc2r1FWjwK8TcZgWGDz2lmJ/xe5z3hL+LD2020kYeoZ18XlOSYE8TgUH7f42aHsOhQx5Zqp+dHWfrtV8efALYScYaXF+5ASeCfSSAlAceIIOgM9ImIfrv66rFTshDsOCvKUf0q7o++q4kZ7uYsMNu1JpN3Zp4j8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2IqdGbeJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2IqdGbeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAEBC116B1;
	Tue, 16 Jul 2024 15:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144148;
	bh=xRbunoqeimjsvAswC7tKTKVx2SoqkdFvLCQS4kaQty8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2IqdGbeJWc1F3h3u0tgTDWNB9qP0lt5joC/VUHj8xGv9i0iabLDoF5Ukh09/wV+ut
	 2688gem14IfQv8oFKeGEkpeBDsAQ52rTVdfw78M9uSjOaF0e9EvGIM51mUNyJsPI36
	 ufbHYB74TXDyg2jc5msgUoc5uwqP3D2jCsidNblE=
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
Subject: [PATCH 4.19 43/66] tcp: fix incorrect undo caused by DSACK of TLP retransmit
Date: Tue, 16 Jul 2024 17:31:18 +0200
Message-ID: <20240716152739.812069497@linuxfoundation.org>
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
index 9a66c37958451..9254705afa869 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1948,8 +1948,16 @@ void tcp_clear_retrans(struct tcp_sock *tp)
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
@@ -2028,6 +2036,7 @@ void tcp_enter_loss(struct sock *sk)
 
 	tcp_set_ca_state(sk, TCP_CA_Loss);
 	tp->high_seq = tp->snd_nxt;
+	tp->tlp_high_seq = 0;
 	tcp_ecn_queue_cwr(tp);
 
 	/* F-RTO RFC5682 sec 3.1 step 1: retransmit SND.UNA if no previous
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index d8d28ba169b4d..cebbac092f322 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -441,8 +441,6 @@ void tcp_retransmit_timer(struct sock *sk)
 	if (!tp->packets_out || WARN_ON_ONCE(tcp_rtx_queue_empty(sk)))
 		return;
 
-	tp->tlp_high_seq = 0;
-
 	if (!tp->snd_wnd && !sock_flag(sk, SOCK_DEAD) &&
 	    !((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV))) {
 		/* Receiver dastardly shrinks window. Our retransmits
-- 
2.43.0



