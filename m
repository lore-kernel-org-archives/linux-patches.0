Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036666;
	b=NvRI3WfjE10CsO7PpYc8lWMQeNA3u07gQYyzsA21jxvS+2iKQuxvKlRYoLRXG6XEnKB+
	 2j4zoSFkItXs1ukEDqiXpLDIDDVizSH13XoOF6jSqdgTiFbjFXYjyueFncUcdNe8hIudb
	 T9QFpvnOjFXQR7eujtcE8zOEkDS+e4sX+/08xREw+3heULauKucY7aaSuyj04jN1T5rKM
	 p5KHWL2kHpMXGd9GLn8s9s0DeMYtRuLPm4LqmoAIjYpqwOQZJ6s8bH/Zs6XV7qozhUKqZ
	 WONgaFE9CNeHH9i5FGaWKF9JmEz+D6MFvCNN0xqxfQIhmre/vrnpGOsTqzOt3iy0Zww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6g1cZ+RAG+N2nhguJbzqDg5jP3xmVH1NA/nuQ7MAfMA=;
	b=onu/fWL/K/la5NAl0hs1763eCHoF01b3AaJ6xn+U5G+gepSKoUtnRmgZC/N7E8aO9urc
	 mAo71TXDZjSkX4C7VMTnZ/aiCmU4a5RXs3TNNWa95o7+8P/wC7vRwmSrTCF6Dls0w6d95
	 PZEuzaFVUOAVpBcFrQAQM+C/AVch0oXZecO2oFVBF1Jrl2msBzPNl1fzLZjicbfi5ZUSS
	 8moQWh58e5EU0IbhEa8GPupEY0rFfspysBdbFEnUBjIViQoxAVuckEBNr45P7opJv64B2
	 DH5qj2x5KuB4of9SxG29VNUZtLY+FPCoMBzNNckQDHOtJIA/6vhpk/NRu4A31ckAe8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xxP/XQOk";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BED0606A333;
	Wed, 18 Nov 2026 21:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xxP/XQOk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B6B1F000CA;
	Wed, 18 Nov 2026 21:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036666;
	bh=6g1cZ+RAG+N2nhguJbzqDg5jP3xmVH1NA/nuQ7MAfMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xxP/XQOkR2eE7/+WYhbC0HS8SuQm+6eH9S94J7iMQ9MpJmB18OP8Lp9cJH2Uia5EQ
	 g+fhJYKhj3X3Xfq/JkKIAZny4IepJokfL5LRprsnWHa65RviRYVi//8urWj9wFOZ7q
	 M0X3El8UqNvZ9DWx4c8gAwGZRTnoMhhhYtqjMYLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Seung Min Shin <guncraft2000@naver.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1140/3318] sctp: hold transport reference across connect wait
Date: Wed, 18 Nov 2026 15:29:22 +0100
Message-ID: <20261118150354.263004739@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index df40d955b284c..4f9978e4f268d 100644
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
@@ -9358,7 +9359,9 @@ static bool sctp_writeable(const struct sock *sk)
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
@@ -9367,12 +9370,16 @@ static int sctp_wait_for_connect(struct sctp_association *asoc, long *timeo_p)
 
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
@@ -9401,7 +9408,8 @@ static int sctp_wait_for_connect(struct sctp_association *asoc, long *timeo_p)
 out:
 	finish_wait(&asoc->wait, &wait);
 
-	/* Release the association's refcnt.  */
+	if (transport)
+		sctp_transport_put(transport);
 	sctp_association_put(asoc);
 
 	return err;
@@ -9420,6 +9428,10 @@ static int sctp_wait_for_connect(struct sctp_association *asoc, long *timeo_p)
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



