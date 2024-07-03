Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39621799F;
	Wed,  3 Jul 2024 11:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005289; cv=none; b=BnCQllHOASUUYcxeuN3UAqepQlhM3x4C3TJ2A2akFf2eWeEBtop1q6k8gD3j7BbWoXXheOIudToC5TGochUnJjEEf+963MQHKE7+OGTRAa2Hk6wn5NZgmS3UySMCfgULz2dAIJLbl98AVuKlgIh4yvw31c9ocljG21tfoYAmsI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005289; c=relaxed/simple;
	bh=6Cj2EfDIIqOvp0uObEC60ksS4Ccb5hTbhSQrHuYlSDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4vxGuo9Dbfa+L6rlKNlv0SEHAGlTRQd3Cji+K/a+JiiEAv9gj38UB/3XBuLyN0NU5VkLbWTXvovYj+ZVde4IsY0a1tbvQQnY4dPzZpcouJ+bp/ZX0AvuonrH9JQYFKiYBWLhUuthdYibA2Vve7DAlr65RzzepG17lKrjKZs1W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FbgzFVUH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FbgzFVUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE6DC2BD10;
	Wed,  3 Jul 2024 11:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005289;
	bh=6Cj2EfDIIqOvp0uObEC60ksS4Ccb5hTbhSQrHuYlSDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FbgzFVUHz6OOg79P7nmWlGG9FiXTB2MetWMmAvuA2oaQWuNsuLhpxz8M94UpQlrld
	 rq7k9YfXVbX3y7OY10BbZItC6HNiN4LAb0jb5H5Ib1OPLxxQG0ppgJMdwr3X3z6qFi
	 YM2EwSZzz7ISYXwu7VZzOXzBP2CqMX5/t1nDhoUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/356] af_unix: Use unix_recvq_full_lockless() in unix_stream_connect().
Date: Wed,  3 Jul 2024 12:36:07 +0200
Message-ID: <20240703102914.275880846@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 net/unix/af_unix.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -190,15 +190,9 @@ static inline int unix_may_send(struct s
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
@@ -1387,7 +1381,7 @@ restart:
 	if (other->sk_shutdown & RCV_SHUTDOWN)
 		goto out_unlock;
 
-	if (unix_recvq_full(other)) {
+	if (unix_recvq_full_lockless(other)) {
 		err = -EAGAIN;
 		if (!timeo)
 			goto out_unlock;


