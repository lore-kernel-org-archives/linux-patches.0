Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC444F403E;
	Thu, 17 Sep 2026 18:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668016; cv=none; b=mYXzN8o90iZnQvVXdjrJAsL5EfT4+RtjYYFjgw9flnqC9leGST3MT5EgVIVP3THhrNJ66MkXVedVyKHJ0yq3dppI4mkzyK8QnQZUmyQdp+3CJHxKsVAl6APWbDfQJ7jkhHGbSM4Fw8dWtwwVxLTbIxoHKeZep84RqLTDDuzPuuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668016; c=relaxed/simple;
	bh=izEva+70KJifXP4W0NnnCWHZOl/k/lpUp81UXjMLNvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAaSnagOdvfUaTaydoMnW0ipJkqO2PAagg/w9cISGSSDqTTxT9MT4rfW0eFzvJfQCRU79dKxEL5GKb8+ntAYiEnsJLeH9h0t6vWtp2uCO9PwraquiuYtsgSmkN+6k4mchovdhHR0/2wGBIwk6ySIzQuUbU1KpjqdWM9hEZTry2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wnn96R6X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wnn96R6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24AA91F000FF;
	Thu, 17 Sep 2026 18:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668015;
	bh=zJsDGFcBDlyLPR1FhL8mqnXWvsK2g/jlzpuSaaimC/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wnn96R6XMcC1XNJi3GUIkrdSNNNtM/gsvPUIRuZM81mQU27gHJO+DvKwDC3khjmHE
	 CJF0drAyPYmwQaTyBbnelGNSziL2iJn93PdkiCzTqx3b1mTIWqvvywFY+j0cXJsAHQ
	 8X0+ly58k5y/cxMnttVwCBgNEQ7bqd0PuWNfmklU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Hannes Reinecke <hare@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0253/1102] tls: Flush backlog before waiting for a new record
Date: Thu, 17 Sep 2026 16:03:16 +0100
Message-ID: <20260917151545.946653958@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit edcf32b8a48f5882b5b7a91b21c89d233d4aecf2 ]

While lock_sock is held, incoming TCP segments land on
sk->sk_backlog rather than sk->sk_receive_queue.
tls_rx_rec_wait() inspects only sk_receive_queue, so backlog
data remains invisible. For non-blocking callers (read_sock,
and recvmsg or splice_read with MSG_DONTWAIT) this causes a
spurious -EAGAIN. For blocking callers it forces an
unnecessary sleep/wakeup cycle.

Flush the backlog inside tls_rx_rec_wait() before checking
sk_receive_queue so the strparser can parse newly-arrived
segments immediately. On the next loop iteration
tls_read_flush_backlog() may redundantly flush, but this
path is cold and the cost is negligible.

Backlog processing can run tcp_reset(), which calls
tcp_done_with_error() to set sk->sk_err = ECONNRESET and then
tcp_done() to set sk->sk_shutdown = SHUTDOWN_MASK. The pre-existing
top-of-loop sk_err check already ran before the flush, so the
freshly-set error would be masked by the next-line sk_shutdown test
returning 0 (EOF). Re-check sk_err immediately before the sk_shutdown
test so a connection abort surfaces as -ECONNRESET rather than a clean
EOF.

Commit f508262ae9f2 ("tls: Preserve sk_err across recvmsg() when
data has been copied") gave the top-of-loop sk_err check a
has_copied split. The recheck applies the same handling: when the
caller has already copied bytes, sk_err is reported but preserved
so the error surfaces on the next call; otherwise sock_error()
consumes it so the error is reported exactly once.

Suggested-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/netdev/ahgHgQ84RCc8uYrG@krikkit/
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20260604-tls-read-sock-v12-6-b114efa6e3e2@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index dd8b70914ce1e..a41fd85279bcd 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1414,12 +1414,24 @@ tls_rx_rec_wait(struct sock *sk, struct sk_psock *psock, bool nonblock,
 		if (ret < 0)
 			return ret;
 
+		if (sk_flush_backlog(sk))
+			released = true;
 		if (!skb_queue_empty(&sk->sk_receive_queue)) {
 			tls_strp_check_rcv(&ctx->strp);
 			if (tls_strp_msg_ready(ctx))
 				break;
 		}
 
+		/* sk_flush_backlog() can run tcp_reset(), which sets
+		 * sk_err and then sk_shutdown via tcp_done(). Recheck
+		 * sk_err here so a connection abort surfaces as the
+		 * actual error rather than a clean EOF.
+		 */
+		if (sk->sk_err) {
+			if (has_copied)
+				return -READ_ONCE(sk->sk_err);
+			return sock_error(sk);
+		}
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
 			return 0;
 
-- 
2.53.0



