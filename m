Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050D817B4FF;
	Wed,  3 Jul 2024 10:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003332; cv=none; b=j1gNq5wpqOpOkgE0p9dW+IidNhR1nA1SEzwguyTswfZggKjdEd0Ya2QIW2oa0zjea4j8QmuR8Kmo6Zt1qMSN9q03GfbLXjlAms1svAjbD3T4VC0bFADSSRVn1BdlgS7mtmyu5nMoWjPcswJx2ft3c5BM3aOq56fuuOTwi3Fu38o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003332; c=relaxed/simple;
	bh=CYnSKYLUpaWSMm5doIJs3+rsN+8vFlzZDjPChQMzetg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjtRsakBcRyTBnrJvhdVyvKg3DL+kjs01QSM5Y/T0UcLbhZqli88yccRflx8o9CieitlnRWWOZCBoHVHHrt7RtwK6Q2iHWDGGu7KBPK7bF0iZfqaJJYTMLrCofYPxiPcDxjDl1AtI8yYlOKeXZN8sCsCsaRfvNI9AppzN0cemlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+rx9M01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+rx9M01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D78C2BD10;
	Wed,  3 Jul 2024 10:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003331;
	bh=CYnSKYLUpaWSMm5doIJs3+rsN+8vFlzZDjPChQMzetg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+rx9M01ae5HPRnnjCyeKNvcBzjHa4fSbRDZfvOQSQcKzZG+qI8ssf4f750qqGGKw
	 9FYO2ZqLzAipZVubHgUNllTFraAR9aEccXCxyZ2f0uVBP/dUEZla6yxXtQo8VDwo/d
	 +JjGrAu7Kpd0npxiJ8ycGV3RoPI9Hn8XH+nTjHXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 014/139] af_unix: Use unix_recvq_full_lockless() in unix_stream_connect().
Date: Wed,  3 Jul 2024 12:38:31 +0200
Message-ID: <20240703102830.977058578@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 45d872f0e65593176d880ec148f41ad7c02e40a7 ]

Once sk->sk_state is changed to TCP_LISTEN, it never changes.

unix_accept() takes advantage of this characteristics; it does not
hold the listener's unix_state_lock() and only acquires recvq lock
to pop one skb.

It means unix_state_lock() does not prevent the queue length from
changing in unix_stream_connect().

Thus, we need to use unix_recvq_full_lockless() to avoid data-race.

Now we remove unix_recvq_full() as no one uses it.

Note that we can remove READ_ONCE() for sk->sk_max_ack_backlog in
unix_recvq_full_lockless() because of the following reasons:

  (1) For SOCK_DGRAM, it is a written-once field in unix_create1()

  (2) For SOCK_STREAM and SOCK_SEQPACKET, it is changed under the
      listener's unix_state_lock() in unix_listen(), and we hold
      the lock in unix_stream_connect()

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 4a4b6d2544534..dfcafbb8cd0e0 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -194,15 +194,9 @@ static inline int unix_may_send(struct sock *sk, struct sock *osk)
 	return unix_peer(osk) == NULL || unix_our_peer(sk, osk);
 }
 
-static inline int unix_recvq_full(const struct sock *sk)
-{
-	return skb_queue_len(&sk->sk_receive_queue) > sk->sk_max_ack_backlog;
-}
-
 static inline int unix_recvq_full_lockless(const struct sock *sk)
 {
-	return skb_queue_len_lockless(&sk->sk_receive_queue) >
-		READ_ONCE(sk->sk_max_ack_backlog);
+	return skb_queue_len_lockless(&sk->sk_receive_queue) > sk->sk_max_ack_backlog;
 }
 
 struct sock *unix_peer_get(struct sock *s)
@@ -1306,7 +1300,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	if (other->sk_shutdown & RCV_SHUTDOWN)
 		goto out_unlock;
 
-	if (unix_recvq_full(other)) {
+	if (unix_recvq_full_lockless(other)) {
 		err = -EAGAIN;
 		if (!timeo)
 			goto out_unlock;
-- 
2.43.0



