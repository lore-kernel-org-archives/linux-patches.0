Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007FE32AABE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301258; cv=none; b=JYTisZq2XahnakszEXp+msVAg9TRsw8zDpWDYbo6XzNQq3oh9Ldj2QNYkChBDazFTzfNC0mrvZl833UlSUp9cwpQ7L/7G9CRueoXYTKepXOqZxC9vnagi3RNyhdblFUgRWjVodK8aHJVEl+RGz71x/dzO+O2SnNsbapQQHu/zhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301258; c=relaxed/simple;
	bh=1iBrHSBr7S4ifV5z5JQIP+R0NmFtB9TN5F1pWleSyw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTeXmFh3BU93sA9wePlKwodz6bKL90KohkzbqEVoMJtYYpnoamwLydJSDpHCPo4P36emI3aiqOW+MzhCsoLeJIvAcwkDSDKWA9IivTzek44KQW4xV6elzPY2Ka/sWjnmha5sXDIgTYgNhyvZmogUqqdOAtJNPXkhYjAJKmbczbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pzmjjOfA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pzmjjOfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321DBC2BC9E;
	Sat, 28 Feb 2026 17:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301257;
	bh=1iBrHSBr7S4ifV5z5JQIP+R0NmFtB9TN5F1pWleSyw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pzmjjOfAQ2TuZBYEFS1agVH9ibxeUkSRusboE+79NF2r3G5CVqsuWQi7vBsK85v02
	 sIXUV+RL1zxzk1Aq5VsT/pM+hO8MZ8MNSazn/G/Y4HXHk4S5+Pyz0Cn3J5kPXXs1jw
	 WRG+ig/hNGwYTNsj5NA0v8ckO+bcIeif+z1jTKsm/yy6y3m0bwnpUpUDuL+R2G7OFo
	 tbfKZxV/bqW4tmUm9NmI8TZEZAokYYLLAfvCC/VAFYftscrEBMC8ZAkmBnSWGnODh9
	 VQ3PhqjtSSIqDDGZjVW73jzwfYOYEtVeZnmaib1MksHm/Hhfzhoul94BmipKR7IatY
	 yqLPFjxqxkjhQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Simon Baatz <gmbnomis@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 441/752] tcp: re-enable acceptance of FIN packets when RWIN is 0
Date: Sat, 28 Feb 2026 12:42:32 -0500
Message-ID: <20260228174750.1542406-441-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Simon Baatz <gmbnomis@gmail.com>

[ Upstream commit 1e3bb184e94125bae7c1703472109a646d0f79d9 ]

Commit 2bd99aef1b19 ("tcp: accept bare FIN packets under memory
pressure") allowed accepting FIN packets in tcp_data_queue() even when
the receive window was closed, to prevent ACK/FIN loops with broken
clients.

Such a FIN packet is in sequence, but because the FIN consumes a
sequence number, it extends beyond the window. Before commit
9ca48d616ed7 ("tcp: do not accept packets beyond window"),
tcp_sequence() only required the seq to be within the window. After
that change, the entire packet (including the FIN) must fit within the
window. As a result, such FIN packets are now dropped and the handling
path is no longer reached.

Be more lenient by not counting the sequence number consumed by the
FIN when calling tcp_sequence(), restoring the previous behavior for
cases where only the FIN extends beyond the window.

Fixes: 9ca48d616ed7 ("tcp: do not accept packets beyond window")
Signed-off-by: Simon Baatz <gmbnomis@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260224-fix_zero_wnd_fin-v2-1-a16677ea7cea@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index ede266463d5d1..abd0d5c5a5e3f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4595,15 +4595,24 @@ static enum skb_drop_reason tcp_disordered_ack_check(const struct sock *sk,
  */
 
 static enum skb_drop_reason tcp_sequence(const struct sock *sk,
-					 u32 seq, u32 end_seq)
+					 u32 seq, u32 end_seq,
+					 const struct tcphdr *th)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
+	u32 seq_limit;
 
 	if (before(end_seq, tp->rcv_wup))
 		return SKB_DROP_REASON_TCP_OLD_SEQUENCE;
 
-	if (after(end_seq, tp->rcv_nxt + tcp_receive_window(tp))) {
-		if (after(seq, tp->rcv_nxt + tcp_receive_window(tp)))
+	seq_limit = tp->rcv_nxt + tcp_receive_window(tp);
+	if (unlikely(after(end_seq, seq_limit))) {
+		/* Some stacks are known to handle FIN incorrectly; allow the
+		 * FIN to extend beyond the window and check it in detail later.
+		 */
+		if (!after(end_seq - th->fin, seq_limit))
+			return SKB_NOT_DROPPED_YET;
+
+		if (after(seq, seq_limit))
 			return SKB_DROP_REASON_TCP_INVALID_SEQUENCE;
 
 		/* Only accept this packet if receive queue is empty. */
@@ -6119,7 +6128,8 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 
 step1:
 	/* Step 1: check sequence number */
-	reason = tcp_sequence(sk, TCP_SKB_CB(skb)->seq, TCP_SKB_CB(skb)->end_seq);
+	reason = tcp_sequence(sk, TCP_SKB_CB(skb)->seq,
+			      TCP_SKB_CB(skb)->end_seq, th);
 	if (reason) {
 		/* RFC793, page 37: "In all states except SYN-SENT, all reset
 		 * (RST) segments are validated by checking their SEQ-fields."
-- 
2.51.0

