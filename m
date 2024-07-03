Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544EF178CCD;
	Wed,  3 Jul 2024 10:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003777; cv=none; b=u/o6grDtl0MjKMn80DjpBZ2vDFstdDwWd0VqxktppS7LMR5sQeAUK1TvPWyU+NcdmfIHTJdrJIvgqCEjJQkjkXrux1G1EL6IP2v8ksBv1AqE2VHDVA0JxEmuqcOSydjklhO/iBzXaKpzrUdMNcPtJk/6ZzpHcKtgHEc32VpA4H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003777; c=relaxed/simple;
	bh=kjNJpNIeMfybktMuZGUpUqhCACURi6nwGeuSwTsT+m0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnKyaABXznPDySLCgKVV9ME21UlZAKoIp05BSqkXm7NTAGKY9pQy5KGjjrWCVCvnM5h1YQp+jl6BAzdLWYOYK5IC0pAtp2ZjCYjgQUQU5eeBWtyhRSNHMT2FFgZRb+atIo+4W0REurPYTY4rcv6gh4miS1+qA/wGgN9RENqua7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODtZiKe4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODtZiKe4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF84C2BD10;
	Wed,  3 Jul 2024 10:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003777;
	bh=kjNJpNIeMfybktMuZGUpUqhCACURi6nwGeuSwTsT+m0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ODtZiKe4m9x2lBABb/jeLu/bpbxkw/zkWRoAW2qCAlrJWiw0s1eWqPU7KDv4eFu7m
	 b7607MtKEritXVlURxFPkZJiiWHNnxMWCy1scAV5Z/M8L6dInYk0nVlX57HP4PmItL
	 Cd7B3efjb2MCKGq4aacYRZ8QinLAtz2tvb2H/5O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 019/189] af_unix: Use unix_recvq_full_lockless() in unix_stream_connect().
Date: Wed,  3 Jul 2024 12:38:00 +0200
Message-ID: <20240703102842.229606095@linuxfoundation.org>
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
index ec4c462a87f06..ae6aae983b8cb 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -189,15 +189,9 @@ static inline int unix_may_send(struct sock *sk, struct sock *osk)
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
@@ -1301,7 +1295,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	if (other->sk_shutdown & RCV_SHUTDOWN)
 		goto out_unlock;
 
-	if (unix_recvq_full(other)) {
+	if (unix_recvq_full_lockless(other)) {
 		err = -EAGAIN;
 		if (!timeo)
 			goto out_unlock;
-- 
2.43.0



