Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F08187FF9;
	Tue, 30 Jul 2024 16:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355377; cv=none; b=NGijttk7dEnHUrlyNQx8iPbannoHpFz2hWLYnXYzG5iJa7146eL6Tq8XAfpUkIB3N5vm1iyschVa1T47sz4fi8PfWn/rStQD3/LZnXXRep6xRzNXwFcvud0tDqSWGCsqVbh9AqyTkp78ssAbS6zVP632umSqZrbYP5U8/x4HWo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355377; c=relaxed/simple;
	bh=3Gs9jOcNfNFkA5AW0dr70LF4yVVCAFutHQ2Wk380ixM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGpgCLG01mC7tJbrxMJ3GbyAnVUzUWfnTDSn8/4oDxhpV3B25oK/uhNtiWBHWXdj0Vkx/CrGLjCzKDJnyFV9QbwOEf76niwyrtUJ1pSjLGVIlZLZSYOoyUncvI9LhI9T0ciAVsYAUYzJszh3DtdLK5JW9aXCPZv2hKjdHw99bIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p8PKtdcr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p8PKtdcr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DF9C32782;
	Tue, 30 Jul 2024 16:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355377;
	bh=3Gs9jOcNfNFkA5AW0dr70LF4yVVCAFutHQ2Wk380ixM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p8PKtdcr7qS2tExdPiUmP0pH32/yu4MG1F90nQX3yPhqUBDCr4TOj1Ryly8YV8Mum
	 5bumWIO8Ujbns/U7JPhMu3oo37RBQZvqxVtCYWS8/bVbAOQFGI8d3IP0mZ0Y+PDvAn
	 jnB/QnFHlGDLZc+M+eWXrCBvj3cIJKEoJoCuTa4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Cardwell <ncardwell@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/440] tcp: add tcp_done_with_error() helper
Date: Tue, 30 Jul 2024 17:45:21 +0200
Message-ID: <20240730151619.197870138@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
index 8ea1fba84eff9..cc314c383c532 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -633,6 +633,7 @@ void tcp_skb_collapse_tstamp(struct sk_buff *skb,
 /* tcp_input.c */
 void tcp_rearm_rto(struct sock *sk);
 void tcp_synack_rtt_meas(struct sock *sk, struct request_sock *req);
+void tcp_done_with_error(struct sock *sk, int err);
 void tcp_reset(struct sock *sk, struct sk_buff *skb);
 void tcp_skb_mark_lost_uncond_verify(struct tcp_sock *tp, struct sk_buff *skb);
 void tcp_fin(struct sock *sk);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 7e162a34baec2..cb79919323a62 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -589,7 +589,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 		 */
 		mask |= EPOLLOUT | EPOLLWRNORM;
 	}
-	/* This barrier is coupled with smp_wmb() in tcp_reset() */
+	/* This barrier is coupled with smp_wmb() in tcp_done_with_error() */
 	smp_rmb();
 	if (READ_ONCE(sk->sk_err) ||
 	    !skb_queue_empty_lockless(&sk->sk_error_queue))
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index d72255e5262b3..b1b4f44d21370 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4356,9 +4356,26 @@ static inline bool tcp_sequence(const struct tcp_sock *tp, u32 seq, u32 end_seq)
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
@@ -4370,24 +4387,17 @@ void tcp_reset(struct sock *sk, struct sk_buff *skb)
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



