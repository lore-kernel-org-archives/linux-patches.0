Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6E71DDCE;
	Tue, 16 Jul 2024 15:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144378; cv=none; b=RaHsB6d8pgrH4Xc7E22cB5pmJg5gmjvSMiD3XeqRT4JGknl/SMC/n2trutLblKVpftwNDEIWHLo24A3OvfJbv3Vl7ecqJ3i4x2TGcoOrbgVl/o9fFuENutJXUxsjAvvGgptl8HhuJKWEBH9gqXybWYlh6feDiVehQvuLxTuwFL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144378; c=relaxed/simple;
	bh=QlxaqzFIjPsInRBx59DM6bGk2jCmRMoRSpgL13BnEgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0MNUPC2bOtNuAczl/LElXVDRYeYPSHAjyMuHXxwJQEC/pdg+KQO66CE/ZmMi/PqzJy+TOyVonicuHJx8wmmrEmd73bIZequGVoQ1T/lIUSD9YPLfD89DKgVq99/r98sDEIgMYlpgl2YsiyUlMtJujLdR6M0caqCKQ4GiULDnUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lG9c7m1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lG9c7m1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10CAAC4AF0D;
	Tue, 16 Jul 2024 15:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144378;
	bh=QlxaqzFIjPsInRBx59DM6bGk2jCmRMoRSpgL13BnEgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lG9c7m1wXum30O8l8ZX8kn/77ttKruGDFLbLSmgQsv8Zs8WLwODftvVC9NQBMpKps
	 eotm1cViat7fZQjh9N1BF5CgDIv6sgNsspuS96Zyz5+CoOB6ZatjF5ZXjMAPUcGL1T
	 fmUO4HAsOwNZFclmYTzF1jEVMPYt4By4sOva8AUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhang kai <zhangkaiheb@126.com>,
	Neal Cardwell <ncardwell@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 22/78] tcp: tcp_mark_head_lost is only valid for sack-tcp
Date: Tue, 16 Jul 2024 17:30:54 +0200
Message-ID: <20240716152741.492980326@linuxfoundation.org>
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

From: zhang kai <zhangkaiheb@126.com>

[ Upstream commit 636ef28d6e4d174e424102466caf572b0406fb0e ]

so tcp_is_sack/reno checks are removed from tcp_mark_head_lost.

Signed-off-by: zhang kai <zhangkaiheb@126.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: a6458ab7fd4f ("UPSTREAM: tcp: fix DSACK undo in fast recovery to call tcp_try_to_open()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 32 +++++++-------------------------
 1 file changed, 7 insertions(+), 25 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 87a10bb11eb0b..dc446d7c9e0f2 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2202,8 +2202,7 @@ static bool tcp_time_to_recover(struct sock *sk, int flag)
 }
 
 /* Detect loss in event "A" above by marking head of queue up as lost.
- * For non-SACK(Reno) senders, the first "packets" number of segments
- * are considered lost. For RFC3517 SACK, a segment is considered lost if it
+ * For RFC3517 SACK, a segment is considered lost if it
  * has at least tp->reordering SACKed seqments above it; "packets" refers to
  * the maximum SACKed segments to pass before reaching this limit.
  */
@@ -2211,10 +2210,9 @@ static void tcp_mark_head_lost(struct sock *sk, int packets, int mark_head)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *skb;
-	int cnt, oldcnt, lost;
-	unsigned int mss;
+	int cnt;
 	/* Use SACK to deduce losses of new sequences sent during recovery */
-	const u32 loss_high = tcp_is_sack(tp) ?  tp->snd_nxt : tp->high_seq;
+	const u32 loss_high = tp->snd_nxt;
 
 	WARN_ON(packets > tp->packets_out);
 	skb = tp->lost_skb_hint;
@@ -2237,26 +2235,11 @@ static void tcp_mark_head_lost(struct sock *sk, int packets, int mark_head)
 		if (after(TCP_SKB_CB(skb)->end_seq, loss_high))
 			break;
 
-		oldcnt = cnt;
-		if (tcp_is_reno(tp) ||
-		    (TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_ACKED))
+		if (TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_ACKED)
 			cnt += tcp_skb_pcount(skb);
 
-		if (cnt > packets) {
-			if (tcp_is_sack(tp) ||
-			    (TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_ACKED) ||
-			    (oldcnt >= packets))
-				break;
-
-			mss = tcp_skb_mss(skb);
-			/* If needed, chop off the prefix to mark as lost. */
-			lost = (packets - oldcnt) * mss;
-			if (lost < skb->len &&
-			    tcp_fragment(sk, TCP_FRAG_IN_RTX_QUEUE, skb,
-					 lost, mss, GFP_ATOMIC) < 0)
-				break;
-			cnt = packets;
-		}
+		if (cnt > packets)
+			break;
 
 		tcp_skb_mark_lost(tp, skb);
 
@@ -2883,8 +2866,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 			if (tcp_try_undo_partial(sk, prior_snd_una))
 				return;
 			/* Partial ACK arrived. Force fast retransmit. */
-			do_lost = tcp_is_reno(tp) ||
-				  tcp_force_fast_retransmit(sk);
+			do_lost = tcp_force_fast_retransmit(sk);
 		}
 		if (tcp_try_undo_dsack(sk)) {
 			tcp_try_keep_open(sk);
-- 
2.43.0



