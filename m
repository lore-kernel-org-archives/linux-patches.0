Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731031A3029;
	Tue, 21 Oct 2025 20:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076843; cv=none; b=nl15t24xnI0wOZIwe76n9dq0eAVpwThxHS/KOGxTb2/E34e/zeLCGNDLqE5Oppu+bbcmC4veL8DqeYTNpSzZ3siIEHCRKCmM7YcxKkks22cEBJk5foN91xXQe5jHfYolt11YzNQ3TtvgHh8pK3R829qBD6lPYh/ehuPkOO++gVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076843; c=relaxed/simple;
	bh=tyLvWvyKp/OG/1T1Awi+zyRHHYDNYY++vIHl5bZ2KjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBGr32ddV3EycQP8j7fsHQ9stM+RNZEj6HoqzU9O3kLzPfe6NDfuElpMENw0I8wApUEyv2LAqxSk+Tz6syItIR7nZbIduUpsfnSAgVL8XwgvLWEQguBTLWHMH6MgyvFSGJl8UkaCcJi0Td2yaMz7NaKkl9FRZcKEWkIOYOaBgH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljdSohHK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljdSohHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BCBC4CEF1;
	Tue, 21 Oct 2025 20:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076843;
	bh=tyLvWvyKp/OG/1T1Awi+zyRHHYDNYY++vIHl5bZ2KjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ljdSohHKDDpgSAw6hR/WSxHU4a5sdwNQK8DvznPebmkF5uPjC/L7qGvhZTxVwbkCg
	 hOjNsrSec8l2MKMAp4oFRdyP8ZCApj1fLgzBplux8qeG1UpG9fjckFqB/kbLxBFXfP
	 rl0woahVg6lkNy8wYbkc1oVlz4TiN7DAUwYiwRXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Cardwell <ncardwell@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/136] tcp: fix tcp_tso_should_defer() vs large RTT
Date: Tue, 21 Oct 2025 21:50:44 +0200
Message-ID: <20251021195037.327903544@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 295ce1eb36ae47dc862d6c8a1012618a25516208 ]

Neal reported that using neper tcp_stream with TCP_TX_DELAY
set to 50ms would often lead to flows stuck in a small cwnd mode,
regardless of the congestion control.

While tcp_stream sets TCP_TX_DELAY too late after the connect(),
it highlighted two kernel bugs.

The following heuristic in tcp_tso_should_defer() seems wrong
for large RTT:

delta = tp->tcp_clock_cache - head->tstamp;
/* If next ACK is likely to come too late (half srtt), do not defer */
if ((s64)(delta - (u64)NSEC_PER_USEC * (tp->srtt_us >> 4)) < 0)
      goto send_now;

If next ACK is expected to come in more than 1 ms, we should
not defer because we prefer a smooth ACK clocking.

While blamed commit was a step in the good direction, it was not
generic enough.

Another patch fixing TCP_TX_DELAY for established flows
will be proposed when net-next reopens.

Fixes: 50c8339e9299 ("tcp: tso: restore IW10 after TSO autosizing")
Reported-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Tested-by: Neal Cardwell <ncardwell@google.com>
Link: https://patch.msgid.link/20251011115742.1245771-1-edumazet@google.com
[pabeni@redhat.com: fixed whitespace issue]
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_output.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6d5387811c32a..5e37dc45639db 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2217,7 +2217,8 @@ static bool tcp_tso_should_defer(struct sock *sk, struct sk_buff *skb,
 				 u32 max_segs)
 {
 	const struct inet_connection_sock *icsk = inet_csk(sk);
-	u32 send_win, cong_win, limit, in_flight;
+	u32 send_win, cong_win, limit, in_flight, threshold;
+	u64 srtt_in_ns, expected_ack, how_far_is_the_ack;
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *head;
 	int win_divisor;
@@ -2279,9 +2280,19 @@ static bool tcp_tso_should_defer(struct sock *sk, struct sk_buff *skb,
 	head = tcp_rtx_queue_head(sk);
 	if (!head)
 		goto send_now;
-	delta = tp->tcp_clock_cache - head->tstamp;
-	/* If next ACK is likely to come too late (half srtt), do not defer */
-	if ((s64)(delta - (u64)NSEC_PER_USEC * (tp->srtt_us >> 4)) < 0)
+
+	srtt_in_ns = (u64)(NSEC_PER_USEC >> 3) * tp->srtt_us;
+	/* When is the ACK expected ? */
+	expected_ack = head->tstamp + srtt_in_ns;
+	/* How far from now is the ACK expected ? */
+	how_far_is_the_ack = expected_ack - tp->tcp_clock_cache;
+
+	/* If next ACK is likely to come too late,
+	 * ie in more than min(1ms, half srtt), do not defer.
+	 */
+	threshold = min(srtt_in_ns >> 1, NSEC_PER_MSEC);
+
+	if ((s64)(how_far_is_the_ack - threshold) > 0)
 		goto send_now;
 
 	/* Ok, it looks like it is advisable to defer.
-- 
2.51.0



