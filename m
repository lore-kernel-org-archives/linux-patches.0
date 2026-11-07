Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063497;
	b=GZ00p8TkYKinBMDRUz8lWBmNDdrkIk9kIWtPpp8ztBT6C7n+KimkZUUuHQVFzeFR0sUj
	 ZQ7uo271oIo2ZuWJoJfBvtoFazgV5fDQNAcNk3O7ogkDKavFuhBTmKAtQzLad+sY3DEKd
	 seYJg24MGROq3XqJu+dZPMfxS6HNE+cXGnzH88pGWlCXuegUAIqyGOcRVD4aMuHGe4TP3
	 QLMuygs0Yi/Frhc5WvM8OzF3qhTuxgIByav8E/QlD94nealPpqhSAg1Ej8tKC/LQ1+/t/
	 OeW17s/PtsrZWA0DiveOk+zd7HiOZ7TgWO58ZtxGwKRZ4I1iCP//RDWD6BockAljxVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GkcRmKxy9AIuDJQhv3K+4HRMgJLtYLMhmiUke+7hi4c=;
	b=W1JhNHsadMCKTmJETvok5fYG/e7rgsjO9gmE3jCMBLss0fE7hZeCOmrLon6tj58Cc4L7
	 OINX/MKhW8cOxziqQ8bHGwP9vZmjYiAsarPlvLz8fusyfhhFyXe9u2pUOi5hK7v/8+OQF
	 ZW0WcBOF+Y3GHmNzAEzAwfElD8hmhD25zBkldJ1BsqxbCUmeLBIeiMFORdXJmJNRiuVzS
	 LPu7ACTwzcmeyN8ZR13At/iW/RT7zu4Z7WJ3tBPtzj64y8+AafEJ8UMnM11yPoXDZDKaY
	 RcBCdvOsB3zmxNGj2nb6hl0qEZNm+9YGUBvbX4skzQ2naqWfBou/j2ujGd5OHuJH2rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D0BQyb0+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9538606A339;
	Sat,  7 Nov 2026 14:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D0BQyb0+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673341F008A2;
	Sat,  7 Nov 2026 14:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063496;
	bh=GkcRmKxy9AIuDJQhv3K+4HRMgJLtYLMhmiUke+7hi4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D0BQyb0+NqmhrV8nRvEkMk+gWwYLfBAodCQmO7AMkxo/uP2LMIuUoyNeI0P1PN7yh
	 ETEYV7j/4mhGcX2TjGZxN6Hi9aI+8LopddqbxsT8Utwl30R+l1CKh2WRZtcK15B9JZ
	 hJ0Rt4hxee39U6RS2iPTmeZ+qknukkv9cCYdJ7S8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Seung Min Shin <guncraft2000@naver.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 604/869] sctp: hold transport reference across connect wait
Date: Sat,  7 Nov 2026 08:54:46 -0500
Message-ID: <20261107134913.567796469@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seung Min Shin <guncraft2000@naver.com>

[ Upstream commit 5bef8649bb9ac4b2a014bcc227202ebd2df824be ]

sctp_sendmsg_to_asoc() selects a transport before waiting for a new
interleaved association to become established. sctp_wait_for_connect()
drops the socket lock while sleeping.

While the lock is dropped, backlog processing can handle a COOKIE ACK and
an ASCONF DEL-IP that removes the selected transport. sctp_assoc_rm_peer()
then marks the transport dead and drops its association-owned reference.
The transport can be freed through RCU before the send path resumes.

After the wait, the stale pointer is assigned to newly created DATA or
I-DATA chunks and later dereferenced by sctp_outq_select_transport().

Hold a reference to the selected transport across
sctp_wait_for_connect(). After the socket lock is reacquired, abort the
send if the transport was marked dead. Callers without a selected
transport pass NULL and retain their existing behavior.

Cc: stable@vger.kernel.org
Fixes: 668c9beb9020 ("sctp: implement assign_number for sctp_stream_interleave")
Acked-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Seung Min Shin <guncraft2000@naver.com>
Link: https://patch.msgid.link/20261011162750.1529631-1-guncraft2000@naver.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/socket.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 03588ac5c382c..8c9970352952e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -75,7 +75,8 @@ static int sctp_wait_for_sndbuf(struct sctp_association *asoc,
 				struct sctp_transport *transport,
 				long *timeo_p, size_t msg_len);
 static int sctp_wait_for_packet(struct sock *sk, int *err, long *timeo_p);
-static int sctp_wait_for_connect(struct sctp_association *, long *timeo_p);
+static int sctp_wait_for_connect(struct sctp_association *,
+				 struct sctp_transport *, long *timeo_p);
 static int sctp_wait_for_accept(struct sock *sk, long timeo);
 static void sctp_wait_for_close(struct sock *sk, long timeo);
 static void sctp_destruct_sock(struct sock *sk);
@@ -1244,7 +1245,7 @@ static int __sctp_connect(struct sock *sk, struct sockaddr *kaddrs,
 		*assoc_id = asoc->assoc_id;
 
 	timeo = sock_sndtimeo(sk, flags & O_NONBLOCK);
-	return sctp_wait_for_connect(asoc, &timeo);
+	return sctp_wait_for_connect(asoc, NULL, &timeo);
 
 out_free:
 	pr_debug("%s: took out_free path with asoc:%p kaddrs:%p err:%d\n",
@@ -1846,7 +1847,7 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 
 		if (asoc->ep->intl_enable) {
 			timeo = sock_sndtimeo(sk, 0);
-			err = sctp_wait_for_connect(asoc, &timeo);
+			err = sctp_wait_for_connect(asoc, transport, &timeo);
 			if (err || sk->sk_shutdown & RCV_SHUTDOWN) {
 				err = -ESRCH;
 				goto err;
@@ -1889,7 +1890,7 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 
 	if (unlikely(wait_connect)) {
 		timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
-		sctp_wait_for_connect(asoc, &timeo);
+		sctp_wait_for_connect(asoc, NULL, &timeo);
 	}
 
 	err = msg_len;
@@ -9337,7 +9338,9 @@ static bool sctp_writeable(const struct sock *sk)
 /* Wait for an association to go into ESTABLISHED state. If timeout is 0,
  * returns immediately with EINPROGRESS.
  */
-static int sctp_wait_for_connect(struct sctp_association *asoc, long *timeo_p)
+static int sctp_wait_for_connect(struct sctp_association *asoc,
+				 struct sctp_transport *transport,
+				 long *timeo_p)
 {
 	struct sock *sk = asoc->base.sk;
 	int err = 0;
@@ -9346,12 +9349,16 @@ static int sctp_wait_for_connect(struct sctp_association *asoc, long *timeo_p)
 
 	pr_debug("%s: asoc:%p, timeo:%ld\n", __func__, asoc, *timeo_p);
 
-	/* Increment the association's refcnt.  */
+	/* Hold references while the socket lock is dropped. */
+	if (transport)
+		sctp_transport_hold(transport);
 	sctp_association_hold(asoc);
 
 	for (;;) {
 		prepare_to_wait_exclusive(&asoc->wait, &wait,
 					  TASK_INTERRUPTIBLE);
+		if (transport && transport->dead)
+			goto do_transport_dead;
 		if (!*timeo_p)
 			goto do_nonblock;
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
@@ -9380,7 +9387,8 @@ static int sctp_wait_for_connect(struct sctp_association *asoc, long *timeo_p)
 out:
 	finish_wait(&asoc->wait, &wait);
 
-	/* Release the association's refcnt.  */
+	if (transport)
+		sctp_transport_put(transport);
 	sctp_association_put(asoc);
 
 	return err;
@@ -9399,6 +9407,10 @@ static int sctp_wait_for_connect(struct sctp_association *asoc, long *timeo_p)
 do_nonblock:
 	err = -EINPROGRESS;
 	goto out;
+
+do_transport_dead:
+	err = -EAGAIN;
+	goto out;
 }
 
 static int sctp_wait_for_accept(struct sock *sk, long timeo)
-- 
2.53.0



