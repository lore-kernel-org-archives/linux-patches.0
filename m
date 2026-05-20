Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDC63F1AB8;
	Wed, 20 May 2026 17:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299044; cv=none; b=QAIyG6Hwc4c4JlfNEC+KCdKdILkAgRlgS3KMBnaToBtMyZOw58ESDGXdrUaB/VFaLJFBh+pUbk9D32r28C2fQXPoTOzttxsr8Mw5yxPHO6Kitnq2948xfBTbFD+ot99mPr4XOhi/RWC7nU0M9wj7WR19uF5C3C1I+WYlNYCIdHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299044; c=relaxed/simple;
	bh=oa81KqVTtSfBXanLi/gwAI+h5lvklIJhghtfEBML+k0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6gMlzFxRQwHxeiMcYM16rRBP1YsAQWgoiT5uPYD3T7pXwt88je0xbVqUFfuII6HzdNDOXCvVp8OviUhwNcu49edzbr8MVMtPQGMstCa8sqcabNM1ICLABl7qlFJdKXkyVJbA1N4X+pe0By6Qy1jwyDjiRu6Q8vfD85VLIZBef8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n5G86pZ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n5G86pZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F0A1F000E9;
	Wed, 20 May 2026 17:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299043;
	bh=uujXm1/GizErVRtcVjlVy7TMutIuK/vU2KpXuclx6UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n5G86pZ+qviNQM6t44HlFSZtayXxynPLeUrvJjdPibey5JM/PzjQgOjM1Mq84mXjp
	 hsM96lRbql6nenkzmMMVqjebyOKgaZH4DM0DsFqBCLs6f8QW/09hYPyyMP81PgvR5q
	 snnSBExVBxAN9vzQhIXQKj/lP3Oc1+Hu/7pppHLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 641/957] tcp: better handle TCP_TX_DELAY on established flows
Date: Wed, 20 May 2026 18:18:44 +0200
Message-ID: <20260520162148.428716986@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 1c51450f1afff1e7419797720df3fbd9ccbf610c ]

Some applications uses TCP_TX_DELAY socket option after TCP flow
is established.

Some metrics need to be updated, otherwise TCP might take time to
adapt to the new (emulated) RTT.

This patch adjusts tp->srtt_us, tp->rtt_min, icsk_rto
and sk->sk_pacing_rate.

This is best effort, and for instance icsk_rto is reset
without taking backoff into account.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20251013145926.833198-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 290b693ce7c9 ("tcp: annotate data-races around tp->srtt_us")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h    |  2 ++
 net/ipv4/tcp.c       | 31 +++++++++++++++++++++++++++----
 net/ipv4/tcp_input.c |  4 ++--
 3 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 18381f4086d04..cf507b989bff1 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -462,6 +462,8 @@ enum skb_drop_reason tcp_child_process(struct sock *parent, struct sock *child,
 void tcp_enter_loss(struct sock *sk);
 void tcp_cwnd_reduction(struct sock *sk, int newly_acked_sacked, int newly_lost, int flag);
 void tcp_clear_retrans(struct tcp_sock *tp);
+void tcp_update_pacing_rate(struct sock *sk);
+void tcp_set_rto(struct sock *sk);
 void tcp_update_metrics(struct sock *sk);
 void tcp_init_metrics(struct sock *sk);
 void tcp_metrics_init(void);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 03299c21e4d68..2e62441515fee 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3585,9 +3585,12 @@ static int tcp_repair_options_est(struct sock *sk, sockptr_t optbuf,
 DEFINE_STATIC_KEY_FALSE(tcp_tx_delay_enabled);
 EXPORT_IPV6_MOD(tcp_tx_delay_enabled);
 
-static void tcp_enable_tx_delay(void)
+static void tcp_enable_tx_delay(struct sock *sk, int val)
 {
-	if (!static_branch_unlikely(&tcp_tx_delay_enabled)) {
+	struct tcp_sock *tp = tcp_sk(sk);
+	s32 delta = (val - tp->tcp_tx_delay) << 3;
+
+	if (val && !static_branch_unlikely(&tcp_tx_delay_enabled)) {
 		static int __tcp_tx_delay_enabled = 0;
 
 		if (cmpxchg(&__tcp_tx_delay_enabled, 0, 1) == 0) {
@@ -3595,6 +3598,22 @@ static void tcp_enable_tx_delay(void)
 			pr_info("TCP_TX_DELAY enabled\n");
 		}
 	}
+	/* If we change tcp_tx_delay on a live flow, adjust tp->srtt_us,
+	 * tp->rtt_min, icsk_rto and sk->sk_pacing_rate.
+	 * This is best effort.
+	 */
+	if (delta && sk->sk_state == TCP_ESTABLISHED) {
+		s64 srtt = (s64)tp->srtt_us + delta;
+
+		tp->srtt_us = clamp_t(s64, srtt, 1, ~0U);
+
+		/* Note: does not deal with non zero icsk_backoff */
+		tcp_set_rto(sk);
+
+		minmax_reset(&tp->rtt_min, tcp_jiffies32, ~0U);
+
+		tcp_update_pacing_rate(sk);
+	}
 }
 
 /* When set indicates to always queue non-full frames.  Later the user clears
@@ -4121,8 +4140,12 @@ int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 			tp->recvmsg_inq = val;
 		break;
 	case TCP_TX_DELAY:
-		if (val)
-			tcp_enable_tx_delay();
+		/* tp->srtt_us is u32, and is shifted by 3 */
+		if (val < 0 || val >= (1U << (31 - 3))) {
+			err = -EINVAL;
+			break;
+		}
+		tcp_enable_tx_delay(sk, val);
 		WRITE_ONCE(tp->tcp_tx_delay, val);
 		break;
 	default:
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 5a944b1ec320c..e8ba52c908da1 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1102,7 +1102,7 @@ static void tcp_rtt_estimator(struct sock *sk, long mrtt_us)
 	tp->srtt_us = max(1U, srtt);
 }
 
-static void tcp_update_pacing_rate(struct sock *sk)
+void tcp_update_pacing_rate(struct sock *sk)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 	u64 rate;
@@ -1139,7 +1139,7 @@ static void tcp_update_pacing_rate(struct sock *sk)
 /* Calculate rto without backoff.  This is the second half of Van Jacobson's
  * routine referred to above.
  */
-static void tcp_set_rto(struct sock *sk)
+void tcp_set_rto(struct sock *sk)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 	/* Old crap is replaced with new one. 8)
-- 
2.53.0



