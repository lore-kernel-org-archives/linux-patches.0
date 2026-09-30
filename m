Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0FA23ABBE;
	Wed, 30 Sep 2026 18:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794488; cv=none; b=cpa9wxIR7aEEE87l7qhuKjfkBUz4IxueuxXu2A5cpAfMHbW9FjbYPLjWEYEgRZBdbq8YHCMDFZ2HY7c8Fqw/GGBcHcRmcEc9rP87KVhqBY6HRolbG+AW5Pu3XdZEI7osNqK3Ym+TnGoHwNZN6XDSNEmVFZArN7Vdw5Dxig/KHZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794488; c=relaxed/simple;
	bh=DOozQykSkebUvVZ8nd2GRfSX0iGsrNZ8wyHeP3R/byk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWCf8dkvWL6XBNidsljgQ+bSMrdxffji3kRLURAnTUrMID6xRU9bQIUr4kuXJGlGzBp6TJJ1CJsMyqyAN9xhUIo2OFxyfRltGMDExJvTL1bOmFcI7oMf7RqcTFMyTjbkAOHb8ztU8NuP/WJnOFm4z+jXSyesoZC/6/72sxObJ0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jdsytn6b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jdsytn6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5681F000FF;
	Wed, 30 Sep 2026 18:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794486;
	bh=O5B9vJXcVV7xop/vinDVTYQSuqJqwcM8f49hbbW69GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jdsytn6bB4GhQ62b3ZZBmpb5mX88ghWRb6Gu8qufwkRasX4rBYwBSF42pxREbJQg9
	 KsN5gUGy6dASWD8WP7U0vLk5+NmSIV8g98UdnFKi8W4VoLAM1xkMP/4kbTOuCYEjXt
	 V/z5vAZPBLTqgyQuE8H6wNlRTNbhBnn+4KNTjYIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Hannes Reinecke <hare@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0194/1193] tls: Flush backlog before waiting for a new record
Date: Wed, 30 Sep 2026 17:14:38 +0200
Message-ID: <20260930152438.510568309@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 99fb2688c8248..d380aaf5f124c 100644
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



