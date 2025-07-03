Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C984C199920;
	Thu,  3 Jul 2025 15:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556122; cv=none; b=lVaJV36yOzVjzM264Sb/Vv1TJSk13e+VqFwbLO/LX2XiPLFZo9oC4iuqbs3PkEUeowJdzX8PR4admY3JHW7J6MH9zrpdmcm2RVArVHMCl6ck36t7T30DTje/tDxRXU3pWsyzEJdRK0D83dpGUrNz+uDmFQX6VSoDddb8m4gBzwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556122; c=relaxed/simple;
	bh=mNyNy1AoUd015ONEs6mBJnyqFZhUxgOyx6SOFPohQoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfG7mRzEtfdGuDkLeCWf0Smp8wSB4rtrNxPhuI3MbLqHgghqRk/XPzPivzCNNHpMbDvAK2QCF2qfxja5UemRNSHjNDYVDDxwcmZMtu46KnVn+FYmJsgPhFCYSvMiA2FJe4/HvRR6mmj+coJbCAJvemXePn8pGIgvaUnTdM5etWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DVWvfeX5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DVWvfeX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D3AC4CEE3;
	Thu,  3 Jul 2025 15:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556122;
	bh=mNyNy1AoUd015ONEs6mBJnyqFZhUxgOyx6SOFPohQoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DVWvfeX5x7Yp/+pLDEzqeRHRY6gUvyW65NOkiTvCPw4p8qOi6LbHI7UA5A6HDlSW3
	 T5T25m5IgWqUYTEj8IDNUAxnOHJpfSvk8cZQFFo2LcjrrNcg12VjbYAmVPngro9lSs
	 /A93Lqkp5GMV+i+ZfPd2trthyb4aAeYgYELI2LT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/132] af_unix: Dont set -ECONNRESET for consumed OOB skb.
Date: Thu,  3 Jul 2025 16:42:50 +0200
Message-ID: <20250703143942.588025665@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 2a5a4841846b079b5fca5752fe94e59346fbda40 ]

Christian Brauner reported that even after MSG_OOB data is consumed,
calling close() on the receiver socket causes the peer's recv() to
return -ECONNRESET:

  1. send() and recv() an OOB data.

    >>> from socket import *
    >>> s1, s2 = socketpair(AF_UNIX, SOCK_STREAM)
    >>> s1.send(b'x', MSG_OOB)
    1
    >>> s2.recv(1, MSG_OOB)
    b'x'

  2. close() for s2 sets ECONNRESET to s1->sk_err even though
     s2 consumed the OOB data

    >>> s2.close()
    >>> s1.recv(10, MSG_DONTWAIT)
    ...
    ConnectionResetError: [Errno 104] Connection reset by peer

Even after being consumed, the skb holding the OOB 1-byte data stays in
the recv queue to mark the OOB boundary and break recv() at that point.

This must be considered while close()ing a socket.

Let's skip the leading consumed OOB skb while checking the -ECONNRESET
condition in unix_release_sock().

Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Reported-by: Christian Brauner <brauner@kernel.org>
Closes: https://lore.kernel.org/netdev/20250529-sinkt-abfeuern-e7b08200c6b0@brauner/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Acked-by: Christian Brauner <brauner@kernel.org>
Link: https://patch.msgid.link/20250619041457.1132791-4-kuni1840@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 01de31a0f22fe..2c33d787b860d 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -577,6 +577,11 @@ static void unix_sock_destructor(struct sock *sk)
 #endif
 }
 
+static unsigned int unix_skb_len(const struct sk_buff *skb)
+{
+	return skb->len - UNIXCB(skb).consumed;
+}
+
 static void unix_release_sock(struct sock *sk, int embrion)
 {
 	struct unix_sock *u = unix_sk(sk);
@@ -611,10 +616,16 @@ static void unix_release_sock(struct sock *sk, int embrion)
 
 	if (skpair != NULL) {
 		if (sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET) {
+			struct sk_buff *skb = skb_peek(&sk->sk_receive_queue);
+
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
+			if (skb && !unix_skb_len(skb))
+				skb = skb_peek_next(skb, &sk->sk_receive_queue);
+#endif
 			unix_state_lock(skpair);
 			/* No more writes */
 			WRITE_ONCE(skpair->sk_shutdown, SHUTDOWN_MASK);
-			if (!skb_queue_empty_lockless(&sk->sk_receive_queue) || embrion)
+			if (skb || embrion)
 				WRITE_ONCE(skpair->sk_err, ECONNRESET);
 			unix_state_unlock(skpair);
 			skpair->sk_state_change(skpair);
@@ -2593,11 +2604,6 @@ static long unix_stream_data_wait(struct sock *sk, long timeo,
 	return timeo;
 }
 
-static unsigned int unix_skb_len(const struct sk_buff *skb)
-{
-	return skb->len - UNIXCB(skb).consumed;
-}
-
 struct unix_stream_read_state {
 	int (*recv_actor)(struct sk_buff *, int, int,
 			  struct unix_stream_read_state *);
-- 
2.39.5



