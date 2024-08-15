Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB7E19F471;
	Thu, 15 Aug 2024 13:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729288; cv=none; b=myU4Emq8TwL+IqQORPNlLyiP0GHCMQvOgH3+7LK6ZVQDG2dxbH6Kh7xnNuHUUho+uVKijTnrHn/S2M8FnZ2a98PUNJiY3ax4k5sNHHPy0jYnvR4QSWEwPInwjhLHs7/DIHUkFusmoQqY7HLoRCF8fyzH0wBtbfMCcxrJLC3q5uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729288; c=relaxed/simple;
	bh=FGjZ+O+tZDM5k1+OktNK8mhpd4P7bHXTuE4sK/yBLhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXXg0LOchk4UXtZfqImN3GCr6E6IlDYBmzoGhkh4DRjb4xXOQQ5A6VtEP5x/0HfOG2jjN+qKUVJp7md0uINyAjc4FhHsBYDoYC8mH2ui3tCBGRZZ72TfQZR/QSHNWz84sgDy0KOpry7ZX07uOIjBd+HAHXfCtYmgZiIGVIcvEXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYpsEyfV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYpsEyfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BD3C4AF0C;
	Thu, 15 Aug 2024 13:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729288;
	bh=FGjZ+O+tZDM5k1+OktNK8mhpd4P7bHXTuE4sK/yBLhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tYpsEyfVHhqdjL1wBqQPRZRXZI4Nqb+FMC9WY2EPmS95Avz0uexPU9vd7sDxD+EpN
	 iEFmY+63p7FbCVdiKC8EQ6Bks2hdlpwKXJItx+Lm59B6h49pg1U+sppqk6zsjeRf3A
	 U0tnU9yECe2bYkL6L5pdHkyyA9fW/Pk/uJDAz57E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Cardwell <ncardwell@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/484] tcp: add tcp_done_with_error() helper
Date: Thu, 15 Aug 2024 15:18:28 +0200
Message-ID: <20240815131943.214840302@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5e514f1cba090e1c8fff03e92a175eccfe46305f ]

tcp_reset() ends with a sequence that is carefuly ordered.

We need to fix [e]poll bugs in the following patches,
it makes sense to use a common helper.

Suggested-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Link: https://lore.kernel.org/r/20240528125253.1966136-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 853c3bd7b791 ("tcp: fix race in tcp_write_err()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h    |  1 +
 net/ipv4/tcp.c       |  2 +-
 net/ipv4/tcp_input.c | 32 +++++++++++++++++++++-----------
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 30f8111f750b5..061e15a1ac87d 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -612,6 +612,7 @@ void tcp_skb_collapse_tstamp(struct sk_buff *skb,
 /* tcp_input.c */
 void tcp_rearm_rto(struct sock *sk);
 void tcp_synack_rtt_meas(struct sock *sk, struct request_sock *req);
+void tcp_done_with_error(struct sock *sk, int err);
 void tcp_reset(struct sock *sk, struct sk_buff *skb);
 void tcp_skb_mark_lost_uncond_verify(struct tcp_sock *tp, struct sk_buff *skb);
 void tcp_fin(struct sock *sk);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index db3bfe1a8443c..3c85ecab14457 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -592,7 +592,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 		 */
 		mask |= EPOLLOUT | EPOLLWRNORM;
 	}
-	/* This barrier is coupled with smp_wmb() in tcp_reset() */
+	/* This barrier is coupled with smp_wmb() in tcp_done_with_error() */
 	smp_rmb();
 	if (READ_ONCE(sk->sk_err) ||
 	    !skb_queue_empty_lockless(&sk->sk_error_queue))
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index bb20ae8dba09b..c51ad6b353eef 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4348,9 +4348,26 @@ static inline bool tcp_sequence(const struct tcp_sock *tp, u32 seq, u32 end_seq)
 		!after(seq, tp->rcv_nxt + tcp_receive_window(tp));
 }
 
+
+void tcp_done_with_error(struct sock *sk, int err)
+{
+	/* This barrier is coupled with smp_rmb() in tcp_poll() */
+	WRITE_ONCE(sk->sk_err, err);
+	smp_wmb();
+
+	tcp_write_queue_purge(sk);
+	tcp_done(sk);
+
+	if (!sock_flag(sk, SOCK_DEAD))
+		sk_error_report(sk);
+}
+EXPORT_SYMBOL(tcp_done_with_error);
+
 /* When we get a reset we do this. */
 void tcp_reset(struct sock *sk, struct sk_buff *skb)
 {
+	int err;
+
 	trace_tcp_receive_reset(sk);
 
 	/* mptcp can't tell us to ignore reset pkts,
@@ -4362,24 +4379,17 @@ void tcp_reset(struct sock *sk, struct sk_buff *skb)
 	/* We want the right error as BSD sees it (and indeed as we do). */
 	switch (sk->sk_state) {
 	case TCP_SYN_SENT:
-		WRITE_ONCE(sk->sk_err, ECONNREFUSED);
+		err = ECONNREFUSED;
 		break;
 	case TCP_CLOSE_WAIT:
-		WRITE_ONCE(sk->sk_err, EPIPE);
+		err = EPIPE;
 		break;
 	case TCP_CLOSE:
 		return;
 	default:
-		WRITE_ONCE(sk->sk_err, ECONNRESET);
+		err = ECONNRESET;
 	}
-	/* This barrier is coupled with smp_rmb() in tcp_poll() */
-	smp_wmb();
-
-	tcp_write_queue_purge(sk);
-	tcp_done(sk);
-
-	if (!sock_flag(sk, SOCK_DEAD))
-		sk_error_report(sk);
+	tcp_done_with_error(sk, err);
 }
 
 /*
-- 
2.43.0



