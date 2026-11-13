Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590953;
	b=ewCLUCTABT6XlR5clVl16oLz/f94H/125tXgmJKYq4xyIdJPBIaW4oCNffLZO5pKmPEW
	 a9xuXIfD6kdapVNnvdf1R12eLHRGyPBu3gsX3+RoC2qVT4ZSDguMuw5S+FczzAU1Xnax0
	 3lXLzMNIeoT80xplue+uGFGKacVL/PAY2bcOoe76gNKl3r3s105Ud2Xj32sYh7b7HDnxq
	 R9Lx1S07wid8D9jn0mrO+kyaBvFr5iuTpX+tUw/+v8KWrOwKW6bO4XRd3Evgx21kFTXsy
	 jBw3Hig415UOe6xyPx5i668D4iZbaYs6Qgd3W/HL4wFIIkEh7UAuhuazAxMjB8xqpDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590953;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jGzKK0RHC96g1qmQ7ckR3TxDRC6ML+W+gG6EdTbybcU=;
	b=z0SWp9Ks7HEWgqSvmirs856tIjRAHj9XGEuC63zB+1QghmwbD2n4Fm1CMZsob0vQKu/g
	 53c5iamJKCz1lBVc7wHt3hGeVVggdjnFAuaxZ6/cpzPIVYIbaKNpZnjZU4kUo8XHVdSFU
	 641cvL931KfKzqqUVI6Zlx0FiRraoWIVQD+Hkr0bdHODB7vaE/7JEPOVF2T30ZFIBP5le
	 doTqjh0GeTjGk8DuNJoT2EeeST4MJAOKueL2e7DIDS49v9oTev51mLxMmBpCvMkAzg9Bx
	 fDoZzbMayb/6KpbKjz9WkLJgsYMZBpYsyaAhvcxRcNICsKP6tEzXDJhAtQAER/kxq8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJvt9cYd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C9F606F70C;
	Fri, 13 Nov 2026 17:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJvt9cYd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45EC1F000C4;
	Fri, 13 Nov 2026 17:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590952;
	bh=jGzKK0RHC96g1qmQ7ckR3TxDRC6ML+W+gG6EdTbybcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eJvt9cYd499f3XnowGHBrw7wn9iKHnBQtHRR5RYU57Fhqush7E65b9MMbTCvKtbbt
	 czBZ1YY/V4SN/6OHXXyrKespylz/YCYIq3z9IO4ic+FMZ7OWptdmyn257lAfB60/rQ
	 GNmpa9R2PCn6xWtstn8Jfp46zZcA+boHVi9LKVGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 133/670] netrom: dont send part of a message that cannot be fragmented whole
Date: Fri, 13 Nov 2026 10:44:57 -0500
Message-ID: <20261113153816.332817126@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

nr_output() cuts a message longer than one frame into fragments and puts
each one on the write queue as soon as it is built, the more flag set on
all but the last. If allocating a fragment fails, it frees the rest of
the message and returns, and nr_sendmsg() still reports the whole
length as sent. The allocation waits for send buffer space, so this
happens not only when memory is short but whenever a signal interrupts
that wait.

The fragments already queued then go out ending with the more flag set:
the peer joins them to the next message. If the first allocation fails,
nothing is sent and the caller is told the message went.

Build the fragments on a list of our own and only put them on the write
queue once all of them exist; on failure, drop them and return the
error, which nr_sendmsg() passes on. This is what ax25_output() does
since #56.

Tested on two QEMU guests (6.12.94, KASAN, lockdep) linked by KISS. A
speaks NET/ROM itself and never acknowledges; on the circuit it accepted,
B sends a 4000-byte message with SIGALRM set to interrupt it after 3 s,
then the 4-byte message "fin.":

  SO_SNDBUF 6000:
    before: send() = 4000; A receives 4 fragments of 236 bytes, all with
            the more flag, and "fin." is queued behind them
    after:  send() = -1 EINTR; A receives "fin." alone
  SO_SNDBUF at the minimum:
    before: send() = 4000 but nothing of it is sent
    after:  send() = -1 EINTR

No kernel report in any run.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 6ab9b08cf19bef1a63c92bc030ae80d5f8e9c40a)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netrom.h   |  2 +-
 net/netrom/af_netrom.c |  6 +++---
 net/netrom/nr_out.c    | 23 ++++++++++++++++++++---
 3 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/include/net/netrom.h b/include/net/netrom.h
index b8f2e324962ba..3f6fd2f894344 100644
--- a/include/net/netrom.h
+++ b/include/net/netrom.h
@@ -202,7 +202,7 @@ void nr_loopback_clear(void);
 int nr_loopback_queue(struct sk_buff *);
 
 /* nr_out.c */
-void nr_output(struct sock *, struct sk_buff *);
+int nr_output(struct sock *sk, struct sk_buff *skb);
 void nr_send_nak_frame(struct sock *);
 void nr_kick(struct sock *);
 void nr_transmit_buffer(struct sock *, struct sk_buff *);
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index cb996b2e3ffa4..37952f858908e 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1173,9 +1173,9 @@ static int nr_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		goto out;
 	}
 
-	nr_output(sk, skb);	/* Shove it onto the queue */
-
-	err = len;
+	err = nr_output(sk, skb);	/* Shove it onto the queue */
+	if (!err)
+		err = len;
 out:
 	release_sock(sk);
 	return err;
diff --git a/net/netrom/nr_out.c b/net/netrom/nr_out.c
index 2b3cbceb0b52d..150cb4263d314 100644
--- a/net/netrom/nr_out.c
+++ b/net/netrom/nr_out.c
@@ -28,11 +28,19 @@
 /*
  *	This is where all NET/ROM frames pass, except for IP-over-NET/ROM which
  *	cannot be fragmented in this manner.
+ *
+ *	A message too long for one frame is cut into fragments built on a list
+ *	of our own, and only put on the write queue once all of them exist: a
+ *	message that cannot be fragmented whole (no memory, or a signal while
+ *	waiting for send buffer space) is not sent at all, and the error is
+ *	returned. Consumes skb in all cases.
  */
-void nr_output(struct sock *sk, struct sk_buff *skb)
+int nr_output(struct sock *sk, struct sk_buff *skb)
 {
+	struct sk_buff_head frags;
 	struct sk_buff *skbn;
 	unsigned char transport[NR_TRANSPORT_LEN];
+	unsigned long flags;
 	int err, frontlen, len;
 
 	if (skb->len - NR_TRANSPORT_LEN > NR_MAX_PACKET_SIZE) {
@@ -42,10 +50,13 @@ void nr_output(struct sock *sk, struct sk_buff *skb)
 
 		frontlen = skb_headroom(skb);
 
+		__skb_queue_head_init(&frags);
+
 		while (skb->len > 0) {
 			if ((skbn = sock_alloc_send_skb(sk, frontlen + NR_MAX_PACKET_SIZE, 0, &err)) == NULL) {
+				__skb_queue_purge(&frags);
 				kfree_skb(skb);
-				return;
+				return err;
 			}
 
 			skb_reserve(skbn, frontlen);
@@ -63,15 +74,21 @@ void nr_output(struct sock *sk, struct sk_buff *skb)
 			if (skb->len > 0)
 				skbn->data[4] |= NR_MORE_FLAG;
 
-			skb_queue_tail(&sk->sk_write_queue, skbn); /* Throw it on the queue */
+			__skb_queue_tail(&frags, skbn);
 		}
 
 		kfree_skb(skb);
+
+		spin_lock_irqsave(&sk->sk_write_queue.lock, flags);
+		skb_queue_splice_tail_init(&frags, &sk->sk_write_queue);
+		spin_unlock_irqrestore(&sk->sk_write_queue.lock, flags);
 	} else {
 		skb_queue_tail(&sk->sk_write_queue, skb);		/* Throw it on the queue */
 	}
 
 	nr_kick(sk);
+
+	return 0;
 }
 
 /*
-- 
2.53.0



