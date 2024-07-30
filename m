Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401291A6185;
	Tue, 30 Jul 2024 16:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356188; cv=none; b=kEeXq1VtJ/HJdEGSscHsrtiOFCAQWOL+9wq26IoY2IPUAo0s5t/cqyAjHp7dy9EHG6WQ0mHPJghfiYpnLUMMAsYPREEbNz4hxRLZ1yRwee7Vqn/gyjCHCqwYTzNuQE3JYcKXJuxAJO6MIBiv56YWjvQbQ0BTQJo8/PoQ9MuSA9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356188; c=relaxed/simple;
	bh=CcM5Vno4UcJ3bwjEPaEnUaKrSSV6zet93WHakwSo/8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5HlECrTEVYr/odSMQDJIxUKCp/iweU39BZZwGlsTyHKoGkqQhncugDoaBVdU4yCOSyFm2VrJbKIjlGmzhSB9aOb1N78j0mAl66uJ73GfmTfcOaDdS4kmCtkV2hPhVMq3s3zfr7cSZCFn6gRT8eQRRkO8k/XtqZhFZ6sdvs58w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ctb45qp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ctb45qp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8554C32782;
	Tue, 30 Jul 2024 16:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356188;
	bh=CcM5Vno4UcJ3bwjEPaEnUaKrSSV6zet93WHakwSo/8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ctb45qp+TygUXiBh81D9/Rhs59edx+nI7ZJe+3Qt6RHrF/7r2dOIJMKDvdTmWpi+G
	 QdP/cwMF2ICg20eeusAO+h865HAPawfoJ1YF8nxAcFGzwyNH/iby0k0na6z7L/MMo0
	 p7Kklv437JP8asngUJ5AAO/812VDxDyzvCLufh1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Cardwell <ncardwell@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/568] tcp: add tcp_done_with_error() helper
Date: Tue, 30 Jul 2024 17:43:49 +0200
Message-ID: <20240730151644.643289825@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 690770321a6e3..71af244104433 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -624,6 +624,7 @@ void tcp_skb_collapse_tstamp(struct sk_buff *skb,
 /* tcp_input.c */
 void tcp_rearm_rto(struct sock *sk);
 void tcp_synack_rtt_meas(struct sock *sk, struct request_sock *req);
+void tcp_done_with_error(struct sock *sk, int err);
 void tcp_reset(struct sock *sk, struct sk_buff *skb);
 void tcp_fin(struct sock *sk);
 void tcp_check_space(struct sock *sk);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 2df05ea2e00fe..91c3d8264059d 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -591,7 +591,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 		 */
 		mask |= EPOLLOUT | EPOLLWRNORM;
 	}
-	/* This barrier is coupled with smp_wmb() in tcp_reset() */
+	/* This barrier is coupled with smp_wmb() in tcp_done_with_error() */
 	smp_rmb();
 	if (READ_ONCE(sk->sk_err) ||
 	    !skb_queue_empty_lockless(&sk->sk_error_queue))
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index b9133c0972d38..c2e4dac42453b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4367,9 +4367,26 @@ static enum skb_drop_reason tcp_sequence(const struct tcp_sock *tp,
 	return SKB_NOT_DROPPED_YET;
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
@@ -4381,24 +4398,17 @@ void tcp_reset(struct sock *sk, struct sk_buff *skb)
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



