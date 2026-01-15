Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1612C3B95E6;
	Thu, 15 Jan 2026 16:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495995; cv=none; b=Rgr5vpro4WZLjL8VWdGbvAsvORmVk/9mSfET835y8OEWvRwuU0ZYEAeazfr4gFrHbZW9tKdv5c9EwkxBR4JnpSkRkaNRo+eBI2QbGRumc/ATK7mWx9TrmlYKCOQld/vKZyQpcJBRhdckFNhPQ32EGKVc3VTXBwRGL8/lB2oMCyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495995; c=relaxed/simple;
	bh=Aqj97Lg3arbrc5aX18K83TVP4rsVFj3z+nNpSR6trLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gU9S0lEZhE3VE3LgU9a2Vr/QL1GR6XvG+kzE3p9Fr81Xf3kQwdTtPh0AtBzhlOmsJHDXUdNUZfLE1liUHwGkaQ9TBTIUj1FSkE7F+30epNeuZxWNg00MG/CN2JR8cUTFJ55vqA7HsKPSW5HJ5Rr5wOCFhOJlTe16naywV0fU0b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SWcBnv0c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SWcBnv0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92519C116D0;
	Thu, 15 Jan 2026 16:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768495995;
	bh=Aqj97Lg3arbrc5aX18K83TVP4rsVFj3z+nNpSR6trLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SWcBnv0c03XR057mWNl7cNJKUSIY8d6JfqgMT6qnZKP7qM99F/yLTT8KUxXSVmjQj
	 lvo3H7Hr6iFmITvc8F85B+OumuEkfkAwQjOg+a2ai8OZmRcVe/kcJfbIyHIVrLQXU2
	 rjT5sxHRgtlGGcVCKehr+ZsmVvLYcQoHFDcdTUZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 009/181] net: do not write to msg_get_inq in callee
Date: Thu, 15 Jan 2026 17:45:46 +0100
Message-ID: <20260115164202.653182045@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Willem de Bruijn <willemb@google.com>

commit 7d11e047eda5f98514ae62507065ac961981c025 upstream.

NULL pointer dereference fix.

msg_get_inq is an input field from caller to callee. Don't set it in
the callee, as the caller may not clear it on struct reuse.

This is a kernel-internal variant of msghdr only, and the only user
does reinitialize the field. So this is not critical for that reason.
But it is more robust to avoid the write, and slightly simpler code.
And it fixes a bug, see below.

Callers set msg_get_inq to request the input queue length to be
returned in msg_inq. This is equivalent to but independent from the
SO_INQ request to return that same info as a cmsg (tp->recvmsg_inq).
To reduce branching in the hot path the second also sets the msg_inq.
That is WAI.

This is a fix to commit 4d1442979e4a ("af_unix: don't post cmsg for
SO_INQ unless explicitly asked for"), which fixed the inverse.

Also avoid NULL pointer dereference in unix_stream_read_generic if
state->msg is NULL and msg->msg_get_inq is written. A NULL state->msg
can happen when splicing as of commit 2b514574f7e8 ("net: af_unix:
implement splice for stream af_unix sockets").

Also collapse two branches using a bitwise or.

Cc: stable@vger.kernel.org
Fixes: 4d1442979e4a ("af_unix: don't post cmsg for SO_INQ unless explicitly asked for")
Link: https://lore.kernel.org/netdev/willemdebruijn.kernel.24d8030f7a3de@gmail.com/
Signed-off-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260106150626.3944363-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c     |    8 +++-----
 net/unix/af_unix.c |    8 +++-----
 2 files changed, 6 insertions(+), 10 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2651,10 +2651,8 @@ static int tcp_recvmsg_locked(struct soc
 	if (sk->sk_state == TCP_LISTEN)
 		goto out;
 
-	if (tp->recvmsg_inq) {
+	if (tp->recvmsg_inq)
 		*cmsg_flags = TCP_CMSG_INQ;
-		msg->msg_get_inq = 1;
-	}
 	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 
 	/* Urgent data needs to be handled specially. */
@@ -2928,10 +2926,10 @@ int tcp_recvmsg(struct sock *sk, struct
 	ret = tcp_recvmsg_locked(sk, msg, len, flags, &tss, &cmsg_flags);
 	release_sock(sk);
 
-	if ((cmsg_flags || msg->msg_get_inq) && ret >= 0) {
+	if ((cmsg_flags | msg->msg_get_inq) && ret >= 0) {
 		if (cmsg_flags & TCP_CMSG_TS)
 			tcp_recv_timestamp(msg, sk, &tss);
-		if (msg->msg_get_inq) {
+		if ((cmsg_flags & TCP_CMSG_INQ) | msg->msg_get_inq) {
 			msg->msg_inq = tcp_inq_hint(sk);
 			if (cmsg_flags & TCP_CMSG_INQ)
 				put_cmsg(msg, SOL_TCP, TCP_CM_INQ,
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2929,7 +2929,6 @@ static int unix_stream_read_generic(stru
 	unsigned int last_len;
 	struct unix_sock *u;
 	int copied = 0;
-	bool do_cmsg;
 	int err = 0;
 	long timeo;
 	int target;
@@ -2955,9 +2954,6 @@ static int unix_stream_read_generic(stru
 
 	u = unix_sk(sk);
 
-	do_cmsg = READ_ONCE(u->recvmsg_inq);
-	if (do_cmsg)
-		msg->msg_get_inq = 1;
 redo:
 	/* Lock the socket to prevent queue disordering
 	 * while sleeps in memcpy_tomsg
@@ -3115,9 +3111,11 @@ unlock:
 
 	mutex_unlock(&u->iolock);
 	if (msg) {
+		bool do_cmsg = READ_ONCE(u->recvmsg_inq);
+
 		scm_recv_unix(sock, msg, &scm, flags);
 
-		if (msg->msg_get_inq && (copied ?: err) >= 0) {
+		if ((do_cmsg | msg->msg_get_inq) && (copied ?: err) >= 0) {
 			msg->msg_inq = READ_ONCE(u->inq_len);
 			if (do_cmsg)
 				put_cmsg(msg, SOL_SOCKET, SCM_INQ,


