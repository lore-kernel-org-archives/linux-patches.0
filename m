Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590945;
	b=VPFDmYI3cLH41JAgaXS8n8EYe0rurkAvk7K6QE1qlX42zoYYJONLQS/CnB7a8c0kfIgY
	 vUy6TYtiBvtvyJibINQUbUXmfSEN/jkBHA4OZIoEJjBw8L70WUfRMcwkFgSrBJgZ63QD+
	 yiciG0AR5YcVriXzv4sdC6NAxCETmhbqNhJ6LKaAvKT/5WrnA1PxFIuuCIIRhq8PmFe3b
	 gmzf/qFLqtuo6ZGsB35QAN/sH36bHmZEB/gJENqMfrq6qTNjheOlALdZ6fPSQdjC86Zln
	 Egcno29ALr23cDKOX3MyvZFzvivOXCNDzK7KCV5EzZShIZDSdDJNGUo6tdyFbOATSyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W71YRwndpa2W2VzJe+UfV4zj/WNMANcLX4Q+nkQ+QYA=;
	b=ivBJolNQ2+IuHWVbzr53izPSl9gtDbgY82dODsoI6k2BUi4hC2hkwM7mNo5EwcqrOTD4
	 zMhKlSQXbCz3qDbgvSoifEe0xesXZlr3bOLDd8thGLrKgFfAP4zhy7mfbaUvIxnYS84SN
	 baMRpJMKUFGNX2FJgew+cyfTHgQCyB2Hx5B3B9PgKrdlQT5zm115U0SUDJMEmmwWhT0KE
	 xVX9eQD0PXHqQXfeutYOmRIzpIZCF8oNXOwDQdvSwG46zEvWBK2hwV+MIfFrhNqjWL+NN
	 wBvNXOttcsKwvlNZzac+X4TLaeao5KDunOsWAJT7Ws2TUTtgS0u6vdPAz33wkqTazqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tW2v1vz0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980C0606B45C;
	Fri, 13 Nov 2026 17:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tW2v1vz0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456201F000C5;
	Fri, 13 Nov 2026 17:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590945;
	bh=W71YRwndpa2W2VzJe+UfV4zj/WNMANcLX4Q+nkQ+QYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tW2v1vz0t8It8+7No2Mvr58xAapYZ6cOIn3Em356vSH1XTmOUhV07SkJ17zi07rED
	 W/A0wXv585TRHxYh837WmXa+NlLS7sjQimy0GdyVVaERAw6hQDopv1O3kggds4je4K
	 GLmYOkvd8wBgJXzc31DUsaVmOr2teeqM3qeeyC5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 127/670] netrom: give a frame back intact when it cannot be delivered
Date: Fri, 13 Nov 2026 10:44:51 -0500
Message-ID: <20261113153816.132078690@linuxfoundation.org>
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

When nr_queue_rx_frame() cannot deliver a frame, it returns 1 and
nr_state3_machine() keeps the frame on reseq_queue, sets
NR_COND_OWN_RX_BUSY, and tries again later. But the frame given back is
not the frame it was given:

- the NET/ROM headers have already been pulled, so the frame is read
  again later with a wrong N(S), and delivered without its first 20
  bytes if that byte happens to match;
- for the last fragment of a message, the frame has been put on
  frag_queue and freed while building the whole message: the caller
  then queues a freed skb (use-after-free), or, when the allocation of
  the whole message fails, an skb that is still on frag_queue.

This happens whenever the receive buffer is full, i.e. as soon as the
application reads more slowly than the peer sends.

Make nr_queue_rx_frame() all or nothing: build the whole message from
copies, leaving the fragments on frag_queue, and only free them once it
is queued. If the message cannot be queued, or allocated, free what was
built, push the headers back and return 1: the frame is given back as
it came and the earlier fragments are still there.

Tested on two QEMU guests (6.12.94, KASAN, lockdep) linked by KISS. A
sends NET/ROM frames over a raw AX.25 link to a listening NET/ROM socket
on B, whose receive buffer is set to the minimum and which only starts
reading after 15 s: 10 messages of 2 fragments of 200 bytes, then the
next frame again every 6 s, as a peer retransmitting would.

  before: KASAN slab-use-after-free in skb_queue_tail() called from
          nr_process_rx_frame(), then a general protection fault in
          nr_process_rx_frame() and a kernel panic; 2 messages read
  after:  11 messages of 400, ..., 400, 40 bytes read, in order and
          intact, no kernel report

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit e0c2041470f635cad936ac9abe04b01465105229)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/nr_in.c | 38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/net/netrom/nr_in.c b/net/netrom/nr_in.c
index a2c839e3dfb66..cf8844cd64b75 100644
--- a/net/netrom/nr_in.c
+++ b/net/netrom/nr_in.c
@@ -67,26 +67,44 @@ static int nr_queue_rx_frame(struct sock *sk, struct sk_buff *skb, int more)
 		return 0;
 	}
 
-	if (!more && nr->fraglen > 0) {	/* End of fragment */
-		nr->fraglen += skb->len;
-		skb_queue_tail(&nr->frag_queue, skb);
-
-		if ((skbn = alloc_skb(nr->fraglen, GFP_ATOMIC)) == NULL)
-			return 1;
+	if (nr->fraglen > 0) {	/* End of fragment */
+		skbn = alloc_skb(nr->fraglen + skb->len, GFP_ATOMIC);
+		if (!skbn)
+			goto busy;
 
 		skb_reset_transport_header(skbn);
 
-		while ((skbo = skb_dequeue(&nr->frag_queue)) != NULL) {
+		skb_queue_walk(&nr->frag_queue, skbo)
 			skb_copy_from_linear_data(skbo,
 						  skb_put(skbn, skbo->len),
 						  skbo->len);
-			kfree_skb(skbo);
-		}
+		skb_copy_from_linear_data(skb, skb_put(skbn, skb->len),
+					  skb->len);
+	}
+
+	if (sock_queue_rcv_skb(sk, skbn) != 0) {
+		if (skbn != skb)
+			kfree_skb(skbn);
+		goto busy;
+	}
 
+	if (skbn != skb) {
+		/* The whole message is delivered: drop its pieces */
+		skb_queue_purge(&nr->frag_queue);
 		nr->fraglen = 0;
+		kfree_skb(skb);
 	}
 
-	return sock_queue_rcv_skb(sk, skbn);
+	return 0;
+
+busy:
+	/*
+	 * Not delivered: give the frame back as it came, headers included,
+	 * and leave the earlier fragments where they are, so that the
+	 * caller can keep it on reseq_queue and deliver it later.
+	 */
+	skb_push(skb, NR_NETWORK_LEN + NR_TRANSPORT_LEN);
+	return 1;
 }
 
 /*
-- 
2.53.0



