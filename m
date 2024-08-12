Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA9E134AC;
	Mon, 12 Aug 2024 16:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480016; cv=none; b=ZUCd7t9z0fWbYhZmQUzbGfhmOAbQfLEJyiFpx2Ye0s7VUWp1E8prQuW7EvE16+V1Ickg7wSamYEbzU6ceLgIafvVUGIgQYe81zxMf1XoPC3uDt3zcmQyRhG5YI0j+1NpvyXf/3Kl/zaXdiugN7+hCiB45DQOqr0cdU4R4CVOWjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480016; c=relaxed/simple;
	bh=1IubDN/aCTiXdrVy8euq5kldYlmZdtmVJaMDlrbsSOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNawjbOjUTFAXrLBizB3PFttS64JrtBOFdOwarAjr95hRMlrqbpFOBGGygsXgykqfFx5z25FpMzgfGdUEY5DORhBGQpdYPKCsVQyjCtcesEYaDD+Zj87dYpnAZO3PfcFFAY31YotI7drBNzJcGrokAmgtyv01X1AzqIISjJrY88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ki93+ezd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ki93+ezd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2A4C32782;
	Mon, 12 Aug 2024 16:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480015;
	bh=1IubDN/aCTiXdrVy8euq5kldYlmZdtmVJaMDlrbsSOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ki93+ezddAw5mzAkxZRZvUi518jigZhjuWEDYFWy6wUxiwTX3uh0ZnfxdLn656Ihg
	 T4fIS915kF3qfPLlv6gb5BT755+6faGkbQSluYXmqAB9Dvzg0PQluPDy49qzPzJrMw
	 aupbA4iQeu67mDtl9oiDPjpj13yUpUGOEtdsLMNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 070/263] af_unix: Dont retry after unix_state_lock_nested() in unix_stream_connect().
Date: Mon, 12 Aug 2024 18:01:11 +0200
Message-ID: <20240812160149.223030126@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 1ca27e0c8c13ac50a4acf9cdf77069e2d94a547d ]

When a SOCK_(STREAM|SEQPACKET) socket connect()s to another one, we need
to lock the two sockets to check their states in unix_stream_connect().

We use unix_state_lock() for the server and unix_state_lock_nested() for
client with tricky sk->sk_state check to avoid deadlock.

The possible deadlock scenario are the following:

  1) Self connect()
  2) Simultaneous connect()

The former is simple, attempt to grab the same lock, and the latter is
AB-BA deadlock.

After the server's unix_state_lock(), we check the server socket's state,
and if it's not TCP_LISTEN, connect() fails with -EINVAL.

Then, we avoid the former deadlock by checking the client's state before
unix_state_lock_nested().  If its state is not TCP_LISTEN, we can make
sure that the client and the server are not identical based on the state.

Also, the latter deadlock can be avoided in the same way.  Due to the
server sk->sk_state requirement, AB-BA deadlock could happen only with
TCP_LISTEN sockets.  So, if the client's state is TCP_LISTEN, we can
give up the second lock to avoid the deadlock.

  CPU 1                 CPU 2                  CPU 3
  connect(A -> B)       connect(B -> A)        listen(A)
  ---                   ---                    ---
  unix_state_lock(B)
  B->sk_state == TCP_LISTEN
  READ_ONCE(A->sk_state) == TCP_CLOSE
                            ^^^^^^^^^
                            ok, will lock A    unix_state_lock(A)
             .--------------'                  WRITE_ONCE(A->sk_state, TCP_LISTEN)
             |                                 unix_state_unlock(A)
             |
             |          unix_state_lock(A)
             |          A->sk_sk_state == TCP_LISTEN
             |          READ_ONCE(B->sk_state) == TCP_LISTEN
             v                                    ^^^^^^^^^^
  unix_state_lock_nested(A)                       Don't lock B !!

Currently, while checking the client's state, we also check if it's
TCP_ESTABLISHED, but this is unlikely and can be checked after we know
the state is not TCP_CLOSE.

Moreover, if it happens after the second lock, we now jump to the restart
label, but it's unlikely that the server is not found during the retry,
so the jump is mostly to revist the client state check.

Let's remove the retry logic and check the state against TCP_CLOSE first.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 34 +++++++++-------------------------
 1 file changed, 9 insertions(+), 25 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 11cb5badafb6d..be5266007b489 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1473,6 +1473,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	struct unix_sock *u = unix_sk(sk), *newu, *otheru;
 	struct net *net = sock_net(sk);
 	struct sk_buff *skb = NULL;
+	unsigned char state;
 	long timeo;
 	int err;
 
@@ -1523,7 +1524,6 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 		goto out;
 	}
 
-	/* Latch state of peer */
 	unix_state_lock(other);
 
 	/* Apparently VFS overslept socket death. Retry. */
@@ -1553,37 +1553,21 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 		goto restart;
 	}
 
-	/* Latch our state.
-
-	   It is tricky place. We need to grab our state lock and cannot
-	   drop lock on peer. It is dangerous because deadlock is
-	   possible. Connect to self case and simultaneous
-	   attempt to connect are eliminated by checking socket
-	   state. other is TCP_LISTEN, if sk is TCP_LISTEN we
-	   check this before attempt to grab lock.
-
-	   Well, and we have to recheck the state after socket locked.
+	/* self connect and simultaneous connect are eliminated
+	 * by rejecting TCP_LISTEN socket to avoid deadlock.
 	 */
-	switch (READ_ONCE(sk->sk_state)) {
-	case TCP_CLOSE:
-		/* This is ok... continue with connect */
-		break;
-	case TCP_ESTABLISHED:
-		/* Socket is already connected */
-		err = -EISCONN;
-		goto out_unlock;
-	default:
-		err = -EINVAL;
+	state = READ_ONCE(sk->sk_state);
+	if (unlikely(state != TCP_CLOSE)) {
+		err = state == TCP_ESTABLISHED ? -EISCONN : -EINVAL;
 		goto out_unlock;
 	}
 
 	unix_state_lock_nested(sk, U_LOCK_SECOND);
 
-	if (sk->sk_state != TCP_CLOSE) {
+	if (unlikely(sk->sk_state != TCP_CLOSE)) {
+		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EINVAL;
 		unix_state_unlock(sk);
-		unix_state_unlock(other);
-		sock_put(other);
-		goto restart;
+		goto out_unlock;
 	}
 
 	err = security_unix_stream_connect(sk, other, newsk);
-- 
2.43.0



