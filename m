Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6399214C585;
	Tue, 20 Feb 2024 20:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462736; cv=none; b=PbiNA/3qzf50KcbZsIS5mZOIfvImQV0is5GoeGDaP4SO/waAH2Ei79lOl4GMSjyyfRFkUCtYojYuHeshwli+SHAGqCfNI6WMiPAJrDQo9tygaEQm0P/r6CD/EpTqgbqcoIVT1qlPCBS6IlRRRQzu/0L+JojWwjJsJPUQny2YF4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462736; c=relaxed/simple;
	bh=RXnirLleFa18vEvMHPkK86Md+/0JyGVExQG4mabalP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FEtjDrir9GT9Aet/n5P/H+rAhZPLnCSc8nn1eFVhVgJNKY5uXP+7CVvt969XtMODIrZ4THmkdVL8JtvzBKFwuFGwVNEenC+aJ2jpqe1B7t6TDLCdJDTU1OgNT8Q9BlDh7GlmTRAulNdIDHOViNr18LjFctpxgtfGR0mJh/v5Nk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOdSfFXB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOdSfFXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8964BC433C7;
	Tue, 20 Feb 2024 20:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462736;
	bh=RXnirLleFa18vEvMHPkK86Md+/0JyGVExQG4mabalP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hOdSfFXB9RhB+833ENmJSzLM39lC+pY/I22RHO6mVfWN5exrdTUuLrN3ToKm/Fk9O
	 LyFvXmAWkY8pkYHTd+JA9V/vejkN786Cu3qr9KoaQ9DIcmJkuAm2y+H+YdGqRlnFoQ
	 2VkteDXAuMMg/sCfhEu+5Gs0At4W7uRFLrjPUax8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Boris Pismenny <borisp@nvidia.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Matthew Wilcox <willy@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/197] tls/sw: Use splice_eof() to flush
Date: Tue, 20 Feb 2024 21:49:40 +0100
Message-ID: <20240220204841.715089008@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit df720d288dbb1793e82b6ccbfc670ec871e9def4 ]

Allow splice to end a TLS record after prematurely ending a splice/sendfile
due to getting an EOF condition (->splice_read() returned 0) after splice
had called TLS with a sendmsg() with MSG_MORE set when the user didn't set
MSG_MORE.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/CAHk-=wh=V579PDYvkpnTobCLGczbgxpMgGmmhqiTyE34Cpi5Gg@mail.gmail.com/
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
cc: Chuck Lever <chuck.lever@oracle.com>
cc: Boris Pismenny <borisp@nvidia.com>
cc: John Fastabend <john.fastabend@gmail.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: aec7961916f3 ("tls: fix race between async notify and socket close")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls.h      |  1 +
 net/tls/tls_main.c |  2 ++
 net/tls/tls_sw.c   | 74 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 77 insertions(+)

diff --git a/net/tls/tls.h b/net/tls/tls.h
index 0672acab2773..4922668fefaa 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -97,6 +97,7 @@ void tls_update_rx_zc_capable(struct tls_context *tls_ctx);
 void tls_sw_strparser_arm(struct sock *sk, struct tls_context *ctx);
 void tls_sw_strparser_done(struct tls_context *tls_ctx);
 int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
+void tls_sw_splice_eof(struct socket *sock);
 int tls_sw_sendpage_locked(struct sock *sk, struct page *page,
 			   int offset, size_t size, int flags);
 int tls_sw_sendpage(struct sock *sk, struct page *page,
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 338a443fa47b..80b42a3e7883 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -922,6 +922,7 @@ static void build_proto_ops(struct proto_ops ops[TLS_NUM_CONFIG][TLS_NUM_CONFIG]
 	ops[TLS_BASE][TLS_BASE] = *base;
 
 	ops[TLS_SW  ][TLS_BASE] = ops[TLS_BASE][TLS_BASE];
+	ops[TLS_SW  ][TLS_BASE].splice_eof	= tls_sw_splice_eof;
 	ops[TLS_SW  ][TLS_BASE].sendpage_locked	= tls_sw_sendpage_locked;
 
 	ops[TLS_BASE][TLS_SW  ] = ops[TLS_BASE][TLS_BASE];
@@ -990,6 +991,7 @@ static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 
 	prot[TLS_SW][TLS_BASE] = prot[TLS_BASE][TLS_BASE];
 	prot[TLS_SW][TLS_BASE].sendmsg		= tls_sw_sendmsg;
+	prot[TLS_SW][TLS_BASE].splice_eof	= tls_sw_splice_eof;
 	prot[TLS_SW][TLS_BASE].sendpage		= tls_sw_sendpage;
 
 	prot[TLS_BASE][TLS_SW] = prot[TLS_BASE][TLS_BASE];
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 0323040d34bc..fbe6aab5f5b2 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1158,6 +1158,80 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	return copied > 0 ? copied : ret;
 }
 
+/*
+ * Handle unexpected EOF during splice without SPLICE_F_MORE set.
+ */
+void tls_sw_splice_eof(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
+	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
+	struct tls_rec *rec;
+	struct sk_msg *msg_pl;
+	ssize_t copied = 0;
+	bool retrying = false;
+	int ret = 0;
+	int pending;
+
+	if (!ctx->open_rec)
+		return;
+
+	mutex_lock(&tls_ctx->tx_lock);
+	lock_sock(sk);
+
+retry:
+	rec = ctx->open_rec;
+	if (!rec)
+		goto unlock;
+
+	msg_pl = &rec->msg_plaintext;
+
+	/* Check the BPF advisor and perform transmission. */
+	ret = bpf_exec_tx_verdict(msg_pl, sk, false, TLS_RECORD_TYPE_DATA,
+				  &copied, 0);
+	switch (ret) {
+	case 0:
+	case -EAGAIN:
+		if (retrying)
+			goto unlock;
+		retrying = true;
+		goto retry;
+	case -EINPROGRESS:
+		break;
+	default:
+		goto unlock;
+	}
+
+	/* Wait for pending encryptions to get completed */
+	spin_lock_bh(&ctx->encrypt_compl_lock);
+	ctx->async_notify = true;
+
+	pending = atomic_read(&ctx->encrypt_pending);
+	spin_unlock_bh(&ctx->encrypt_compl_lock);
+	if (pending)
+		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
+	else
+		reinit_completion(&ctx->async_wait.completion);
+
+	/* There can be no concurrent accesses, since we have no pending
+	 * encrypt operations
+	 */
+	WRITE_ONCE(ctx->async_notify, false);
+
+	if (ctx->async_wait.err)
+		goto unlock;
+
+	/* Transmit if any encryptions have completed */
+	if (test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask)) {
+		cancel_delayed_work(&ctx->tx_work.work);
+		tls_tx_records(sk, 0);
+	}
+
+unlock:
+	release_sock(sk);
+	mutex_unlock(&tls_ctx->tx_lock);
+}
+
 static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 			      int offset, size_t size, int flags)
 {
-- 
2.43.0



