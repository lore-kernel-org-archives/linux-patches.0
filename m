Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6D44FC35A;
	Thu, 17 Sep 2026 17:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664494; cv=none; b=LyGV5rg68onbXqIiE7t5GJBUUVVYEE33HAa2NI43d18lM7WoxqkVwUnnO2B0XcUCtg23n+HJIOUMrx4pZ9L8hcwtgoUoGdRAyeJs8N+PPo7U4Dypoj57B0hckHo/mrIKHrnkzQiM0IMvqm+boagXLQVLtBQOq8+VZz6FFPKxWos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664494; c=relaxed/simple;
	bh=vteIWzkiqrB8IwLihjMnqMhTyOlZlwNDIot4pwoAlxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PK8rmz88XMSSfU3DkbMIH3dzjBuCaJaE8akY2rSQMEfBUVLDkV9Mruv4tro1evQvP+9XsfN1lyrMrxutghCFz5y5d8izPvvyBgOM+bWM9rwr9HQI75s1t7nav6FHw4Gy4pH0giKDzutABSfXieN6G/VZQ8isleh3wZML8w8pqpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ta5CVq8i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ta5CVq8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DAD1F000FF;
	Thu, 17 Sep 2026 17:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664493;
	bh=KKlm+fDpKTV9CrN77zG7ki+UtBbquJP7tJl2cmGZBHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ta5CVq8iXZACgoLlwsOuqXRod+lJek8Xcq9aBniLMblgky44MEr6F7P3kVFmCNSu8
	 /WKMvi48SnlGI4UV2qiM/YKXmWKV+BxhqqtCslDUEBcASCXecBAxGOmd3ok5rZyqXH
	 tFJCEFkloQ2pl6Nwq09dzVAjpf+U5SWL2glJh2ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Hannes Reinecke <hare@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0359/1250] tls: Flush backlog before waiting for a new record
Date: Thu, 17 Sep 2026 16:02:34 +0100
Message-ID: <20260917151601.797358144@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 4c77036da0711..ea78e2ce754fb 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1418,12 +1418,24 @@ tls_rx_rec_wait(struct sock *sk, struct sk_psock *psock, bool nonblock,
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



