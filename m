Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774880;
	b=jPCpb/2Xogw+dYz8tGjKggq1JJHArcs4g6zr9q8hmDXKGflh0Nlcrmo2nRB7yVGCJN53
	 OqY7WTplJfqS7nd1fYwAsqS7IM2hdP94yBfGV5p6oAWUmf1yDOQ0JXb0DSXdP9VreVRjL
	 MMTEBy2hwLyMq4HHPA+UXDbNW7jf7ey3gHRS3PHqDhntT/Lr8Sqi6e9H4GsBxNXhTaV4o
	 2Mfg71Zo1+uu1CKqlMEKOYgybUjDOyZb/f9uxn3Ssy3PhbLcDVf5haHF8sha2Y51UhxkY
	 LAAYl+65yyKMD54OQ4OE/iLmkuvhyoiK0g5FZ5orK7jjaeRgiLcpX+z/TWgT5QM8djg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7uhpL4ItjtUrjjDgI4peQJAzi6WcxcbS6q7RnxdphIA=;
	b=OboiCeAGgLOTsM009xRmkNqrSHuDGHclLRKTb7ocXjsS7qJgGKlLMxrFTZNYX65H2PmB
	 xMLCh0kgCYb9l7u9uXJkZelSLZ7YCy0lLBz7fkhcIFtJDOxVPr3DxsGd9dfrZcbHQM5+8
	 A0/vegpaQESXmwwZv1hyXs5JEyyyNbaRC0ny9FwxI05loNN+rvs/mR/KP9oY+rcLeEJqt
	 xOF0al+7iuue6qHeQWh/CeT3Za/1oort7jsuB++5MzfTK/iIb/pMvIMiaXCj5PnW+39Ur
	 VHqmgVHfAJwUh9iNNMQUSEtILA+bEkxBwsewf3/lXZbaY6PvLi5RTlHJUr0uaJYdV0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mdRQc7oz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2444A606A31D;
	Fri, 23 Oct 2026 17:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mdRQc7oz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73ADE1F01825;
	Fri, 23 Oct 2026 17:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774880;
	bh=7uhpL4ItjtUrjjDgI4peQJAzi6WcxcbS6q7RnxdphIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mdRQc7oz1wvHytTrq0fpZtSjqraFX3L+fr4nbV7vHguurj6xzA+EoZvCwArvwnqeK
	 trcLYdpW5/akp4YEAU+l6bo52jlc7mbSR91TYhliugaPau7eMaO14burPcgV1RHhoS
	 b2WKiK+0QIfGb+B88hmMaQuo9036bCV9Bio7hViw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aswin Karuvally <aswin@linux.ibm.com>,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 189/242] net/iucv: fix the recvmsg window update
Date: Fri, 23 Oct 2026 18:40:31 +0200
Message-ID: <20261023163718.260880542@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit fa5acd038ea657ad5033713d6916214cbd349151 upstream.

iucv_sock_recvmsg() sends the HiperSockets-only AF_IUCV_FLAG_WIN without
testing the transport, so on a classic z/VM socket iucv_send_ctrl() sizes
the skb through a NULL iucv->hs_dev. SO_MSGLIMIT accepts 1, so msglimit / 2
is zero and one recvmsg() on its own socket is enough for an unprivileged
process to take a spurious disconnect.

It also calls iucv_send_ctrl() under spin_lock_bh(&message_q.lock), which
allocates GFP_KERNEL inside a section the code treats as atomic. Sending
outside that lock lets two recvmsg() reach afiucv_hs_send() at once, where
msg_recv is sampled for the advertised window and subtracted after
dev_queue_xmit() -- and sendmsg reaches that counter under lock_sock()
while recvmsg holds no socket lock, so both can subtract the same value,
the counter goes negative and the credit reaches the peer twice.

Test the transport, claim the credit with atomic_xchg() after the last
error exit and hand it back if the transmit fails, and send once the lock
is dropped.

Fixes: 3881ac441f64 ("af_iucv: add HiperSockets transport")
Fixes: 238965b71b96 ("net/af_iucv: build proper skbs for HiperTransport")
Cc: stable@vger.kernel.org
Tested-by: Aswin Karuvally <aswin@linux.ibm.com>
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Link: https://patch.msgid.link/20260828-b4-disp-33fac0ed-v3-1-e6d061880ee0@proton.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/iucv/af_iucv.c |   42 +++++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 17 deletions(-)

--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -210,12 +210,6 @@ static int afiucv_hs_send(struct iucv_me
 	phs_hdr->flags = flags;
 	if (flags == AF_IUCV_FLAG_SYN)
 		phs_hdr->window = iucv->msglimit;
-	else if ((flags == AF_IUCV_FLAG_WIN) || !flags) {
-		confirm_recv = atomic_read(&iucv->msg_recv);
-		phs_hdr->window = confirm_recv;
-		if (confirm_recv)
-			phs_hdr->flags = phs_hdr->flags | AF_IUCV_FLAG_WIN;
-	}
 	memcpy(phs_hdr->destUserID, iucv->dst_user_id, 8);
 	memcpy(phs_hdr->destAppName, iucv->dst_name, 8);
 	memcpy(phs_hdr->srcUserID, iucv->src_user_id, 8);
@@ -250,13 +244,22 @@ static int afiucv_hs_send(struct iucv_me
 	}
 	skb->protocol = cpu_to_be16(ETH_P_AF_IUCV);
 
+	/* Claim the receive credit here, not while building the header: every
+	 * way this frame can be dropped has now been ruled out, so the window
+	 * is zeroed only for as long as the transmit itself takes.
+	 */
+	if (flags == AF_IUCV_FLAG_WIN || !flags) {
+		confirm_recv = atomic_xchg(&iucv->msg_recv, 0);
+		phs_hdr->window = confirm_recv;
+		if (confirm_recv)
+			phs_hdr->flags = phs_hdr->flags | AF_IUCV_FLAG_WIN;
+	}
+
 	atomic_inc(&iucv->skbs_in_xmit);
 	err = dev_queue_xmit(skb);
 	if (net_xmit_eval(err)) {
 		atomic_dec(&iucv->skbs_in_xmit);
-	} else {
-		atomic_sub(confirm_recv, &iucv->msg_recv);
-		WARN_ON(atomic_read(&iucv->msg_recv) < 0);
+		atomic_add(confirm_recv, &iucv->msg_recv);
 	}
 	return net_xmit_eval(err);
 
@@ -1241,6 +1244,7 @@ static int iucv_sock_recvmsg(struct sock
 	struct iucv_sock *iucv = iucv_sk(sk);
 	unsigned int copied, rlen;
 	struct sk_buff *skb, *rskb, *cskb;
+	bool send_win = false;
 	int err = 0;
 	u32 offset;
 
@@ -1331,16 +1335,20 @@ static int iucv_sock_recvmsg(struct sock
 		if (skb_queue_empty(&iucv->backlog_skb_q)) {
 			if (!list_empty(&iucv->message_q.list))
 				iucv_process_message_q(sk);
-			if (atomic_read(&iucv->msg_recv) >=
-							iucv->msglimit / 2) {
-				err = iucv_send_ctrl(sk, AF_IUCV_FLAG_WIN);
-				if (err) {
-					sk->sk_state = IUCV_DISCONN;
-					sk->sk_state_change(sk);
-				}
-			}
+			if (iucv->transport == AF_IUCV_TRANS_HIPER &&
+			    atomic_read(&iucv->msg_recv) >=
+							iucv->msglimit / 2)
+				send_win = true;
 		}
 		spin_unlock_bh(&iucv->message_q.lock);
+
+		if (send_win) {
+			err = iucv_send_ctrl(sk, AF_IUCV_FLAG_WIN);
+			if (err) {
+				sk->sk_state = IUCV_DISCONN;
+				sk->sk_state_change(sk);
+			}
+		}
 	}
 
 done:


