Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9C6352C34;
	Thu, 28 May 2026 20:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001604; cv=none; b=Kc61bwKDIUYEMp0g1azhOe1lE8bbqRarolXYgNzeHARjuZOsEhM+uLyFC9WPenBhQJNiMt8SA5C+lDU+qaWYsmBF/QKCJj7G+UF2DYCTbQyXdCIa4ZEcQ11zd1i/A+fr8glFPxAhlTj2ym7sFzvT0xNNsr4p+7lhcJk4vC3E6po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001604; c=relaxed/simple;
	bh=duAN/Ul6KTUwML9CDebjtI3AfjhGtZKPpFO0Xe5mThE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxr0q4kZIFtfI4jL1nB9bOndasQqtq6wLFvb/lhjutIhRi/VPijudOaMjgN9je+6NbLYIYFgIbi9arxE2LLMYMRnScXDHPt2qTAR+Dfm+7Ff7SUVKaOscTRWj6ZmTrfyb0jwAGvNX9pp5EWFabxqHc1V9zpfBwEhcUWyvVcPh8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tg4hZCEl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tg4hZCEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6882A1F000E9;
	Thu, 28 May 2026 20:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001601;
	bh=+J/hBLD0p3uJ5Y7VUtg2DAcUe54Bs01OFCRa6PIbXdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tg4hZCEl6lTKi38+oi2P30Ctw2vnrr/tAOO48FqCQIupTEASO7bmAPkIP7aEKgDDa
	 8+u9yP0KaXiEJMCmPno3b5exqSUt1x2WjPSnU97tFoAPkThKyeZ1gCoEy4rMGNVOLF
	 t9/47Q8NqLs073u8Ras/0ntlNFr51YvVL93LJUbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 149/186] tls: Preserve sk_err across recvmsg() when data has been copied
Date: Thu, 28 May 2026 21:50:29 +0200
Message-ID: <20260528194932.979094073@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

[ Upstream commit f508262ae9f21fe0e6c0749948b9dc7dd5a62a70 ]

The sk_err check in tls_rx_rec_wait() consumes the error via
sock_error(), which clears sk_err atomically. When the caller
(tls_sw_recvmsg, tls_sw_splice_read, or tls_sw_read_sock) already
has bytes copied to userspace, it returns those bytes and discards
the error from this call. sk_err is now zero on the socket, so the
next read syscall observes only RCV_SHUTDOWN and reports a clean
EOF instead of the actual error (typically -ECONNRESET).

The race is reachable when tls_read_flush_backlog()'s periodic
sk_flush_backlog() triggers tcp_reset() in the middle of a
multi-record read.

Pass a has_copied flag to tls_rx_rec_wait(). When has_copied is
false, consume sk_err via sock_error() as before. When has_copied
is true, report the error from READ_ONCE() but leave sk_err set:
the caller returns the byte count and discards the err from this
call, and the next read syscall surfaces the preserved sk_err. This
mirrors the tcp_recvmsg() preserve-and-surface pattern.

The decrypt-abort path is unaffected: tls_err_abort() raises
sk_err to EBADMSG after tls_rx_rec_wait() returns, and nothing
on the caller's return path consumes it, so the EBADMSG surfaces
on the next read.

tls_sw_splice_read() passes has_copied=false: it processes
one record per call, so no bytes have been copied within the
function when tls_rx_rec_wait() runs. A reset that arrives
between iterations of splice_direct_to_actor() (the sendfile()
path) is still consumed by sock_error() in the later call, and the
outer loop returns the prior iterations' byte count and drops the
error. tcp_splice_read() exhibits the same pattern at the iteration
boundary; addressing it belongs at the splice_direct_to_actor()
layer and is out of scope here.

Fixes: c46b01839f7a ("tls: rx: periodically flush socket backlog")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://patch.msgid.link/20260513125825.205189-1-cel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 0c2e9724083ee..cdc415de6da2d 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1366,9 +1366,14 @@ void tls_sw_splice_eof(struct socket *sock)
 	mutex_unlock(&tls_ctx->tx_lock);
 }
 
+/* When has_copied is true the caller has already moved bytes to
+ * userspace. Report sk_err but leave it set so the next read
+ * surfaces it instead of a spurious EOF, otherwise sk_err is
+ * consumed via sock_error().
+ */
 static int
 tls_rx_rec_wait(struct sock *sk, struct sk_psock *psock, bool nonblock,
-		bool released)
+		bool released, bool has_copied)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
@@ -1382,8 +1387,11 @@ tls_rx_rec_wait(struct sock *sk, struct sk_psock *psock, bool nonblock,
 		if (!sk_psock_queue_empty(psock))
 			return 0;
 
-		if (sk->sk_err)
+		if (sk->sk_err) {
+			if (has_copied)
+				return -READ_ONCE(sk->sk_err);
 			return sock_error(sk);
+		}
 
 		if (ret < 0)
 			return ret;
@@ -1419,7 +1427,7 @@ tls_rx_rec_wait(struct sock *sk, struct sk_psock *psock, bool nonblock,
 	}
 
 	if (unlikely(!tls_strp_msg_load(&ctx->strp, released)))
-		return tls_rx_rec_wait(sk, psock, nonblock, false);
+		return tls_rx_rec_wait(sk, psock, nonblock, false, has_copied);
 
 	return 1;
 }
@@ -2077,7 +2085,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		int to_decrypt, chunk;
 
 		err = tls_rx_rec_wait(sk, psock, flags & MSG_DONTWAIT,
-				      released);
+				      released, !!(decrypted + copied));
 		if (err <= 0) {
 			if (psock) {
 				chunk = sk_msg_recvmsg(sk, psock, msg, len,
@@ -2265,7 +2273,7 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 		struct tls_decrypt_arg darg;
 
 		err = tls_rx_rec_wait(sk, NULL, flags & SPLICE_F_NONBLOCK,
-				      true);
+				      true, false);
 		if (err <= 0)
 			goto splice_read_end;
 
@@ -2351,7 +2359,7 @@ int tls_sw_read_sock(struct sock *sk, read_descriptor_t *desc,
 		} else {
 			struct tls_decrypt_arg darg;
 
-			err = tls_rx_rec_wait(sk, NULL, true, released);
+			err = tls_rx_rec_wait(sk, NULL, true, released, !!copied);
 			if (err <= 0)
 				goto read_sock_end;
 
-- 
2.53.0



