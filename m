Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C778178CCD;
	Wed,  3 Jul 2024 10:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003767; cv=none; b=EpfY1zHe+KtfF7BAvHcEclMj/41gsGYy3kNq3Q1hS+nkf7jgBXluOQO5uE6ESRwEHuISEkfjDtAqInyy4LTi7JDxS2uO1hCp2mg8JLCWx3FBbiZ+lskPt67HkCnny6DMHVVgHxHyu1ooVzC33B1w6nZT+jJgNpyL78XskqewiFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003767; c=relaxed/simple;
	bh=D5FIhWTdfYtd4XF6XYCuVHz1tOmSqKXdrkC91DPQGkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7v+3cSwBbpmS/58gQGLMZa3vqFaZa1TlOcNWlpXcimOORwCOTG7mfQFOBGOjYLoL8ke8iOoz+E82fyZKdwwl2KkHF3leKByYU7sngbd3iRNG20EFfas5OVN2YgYVmb+fojPPR/3rIDJL9/0aMzEDMpARmPKnrMVmjyMjE78Ipo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KMFHnf7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KMFHnf7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C53BC2BD10;
	Wed,  3 Jul 2024 10:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003767;
	bh=D5FIhWTdfYtd4XF6XYCuVHz1tOmSqKXdrkC91DPQGkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KMFHnf7ltju023yfK2LU9lOUuN1hlxkYHMxTGrjZlrmSdmCQyj1VHrX/+N+5aULAt
	 t3P/llIfq1iGvkAFXocXEkIQgVABF/p/wl3eyMq9Aqc76EnCRBR3sr2Y99jej3109p
	 Xnr85sqcNZmJydh0mDz0ajgxOvR4K8QLoaNDB054=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 016/189] af_unix: Annotate data-races around sk->sk_state in sendmsg() and recvmsg().
Date: Wed,  3 Jul 2024 12:37:57 +0200
Message-ID: <20240703102842.116905355@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 8a34d4e8d9742a24f74998f45a6a98edd923319b ]

The following functions read sk->sk_state locklessly and proceed only if
the state is TCP_ESTABLISHED.

  * unix_stream_sendmsg
  * unix_stream_read_generic
  * unix_seqpacket_sendmsg
  * unix_seqpacket_recvmsg

Let's use READ_ONCE() there.

Fixes: a05d2ad1c1f3 ("af_unix: Only allow recv on connected seqpacket sockets.")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 73cc992bed880..0611ff921421e 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1881,7 +1881,7 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 		goto out_err;
 
 	if (msg->msg_namelen) {
-		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
+		err = READ_ONCE(sk->sk_state) == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
 		goto out_err;
 	} else {
 		err = -ENOTCONN;
@@ -2083,7 +2083,7 @@ static int unix_seqpacket_sendmsg(struct socket *sock, struct msghdr *msg,
 	if (err)
 		return err;
 
-	if (sk->sk_state != TCP_ESTABLISHED)
+	if (READ_ONCE(sk->sk_state) != TCP_ESTABLISHED)
 		return -ENOTCONN;
 
 	if (msg->msg_namelen)
@@ -2097,7 +2097,7 @@ static int unix_seqpacket_recvmsg(struct socket *sock, struct msghdr *msg,
 {
 	struct sock *sk = sock->sk;
 
-	if (sk->sk_state != TCP_ESTABLISHED)
+	if (READ_ONCE(sk->sk_state) != TCP_ESTABLISHED)
 		return -ENOTCONN;
 
 	return unix_dgram_recvmsg(sock, msg, size, flags);
@@ -2293,7 +2293,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 	size_t size = state->size;
 	unsigned int last_len;
 
-	if (unlikely(sk->sk_state != TCP_ESTABLISHED)) {
+	if (unlikely(READ_ONCE(sk->sk_state) != TCP_ESTABLISHED)) {
 		err = -EINVAL;
 		goto out;
 	}
-- 
2.43.0



