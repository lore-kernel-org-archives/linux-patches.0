Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B9B47CC96;
	Tue, 25 Aug 2026 13:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665934; cv=none; b=glRhK7mVgrDK/bPYa3/iKomm/Wrb9SgH+s3iwn1wFNs3TXT36mle0T8wbG3sEh0s0Xr80udgGTfxu7VpA94UzHn/QLWiDX2YF/tC3/X3XTFczwj2OX5wPNYp32r0NRE9m7rju39ASJmlUUmyxnRt94RIJ6vuZZX3F4YJaBGxsnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665934; c=relaxed/simple;
	bh=rE2PjqoLHCa0aDzmIJi82I/p4hOqmPomubxWTEzg0y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmBLkxKC95GvdGS7ho+GGYkMrw57X56c2tpYyWx5dKNzoxZI15K3r2Bb4WADqh359lnGs1hYWEsrBIPUID2U8gFs9tf2VaN6YOoY2FMvw6+dowrr86Pm757CjtxLLellLVMDEsdZ0kB4GZmAFPTU+OhBbgshcLL5V+4BHftDFXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmMg72Pi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmMg72Pi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5AE1F000E9;
	Tue, 25 Aug 2026 13:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665932;
	bh=6TKslb+a1h1Yj1rJ0xY+k8RfyWbMLwZlt6oxJAaIdgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wmMg72Piu9asL21mZVupGS8dR4iIqMTrgIAUxpw4GBxZCnLrDXHQ+7/e8OQvtW6w0
	 GecOEeZUwxZmSpAMQGP2LCai0O4wUmxmxzi6RO31sskDXGK2zuk7KeL8i2E7leYu5f
	 tngpb7ch7AX7uqKzAhxMa1yIL2EztlpGxYCXLGqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <zihanx@nebusec.ai>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 27/79] packet: synchronize pressure clearing with ring reconfiguration
Date: Tue, 25 Aug 2026 15:26:07 +0200
Message-ID: <20260825132542.760628688@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <zihanx@nebusec.ai>

[ Upstream commit 1a35da325cac4d5bcad76a2aa943408a6f1d9000 ]

packet_set_ring() updates the RX ring state under sk_receive_queue.lock,
but used to publish the tpacket receive mode through po->prot_hook.func
after releasing that lock. packet_poll() and packet_recvmsg() can then
run the pressure clearing path after the ring has been cleared while
still seeing tpacket_rcv, causing __packet_rcv_has_room() to dereference
stale or NULL ring storage.

Move the existing receive hook assignment into the same
sk_receive_queue.lock section as the ring state update. Keep the
assignment otherwise unchanged, including on TX ring reconfiguration, to
avoid adding behavior changes that are not required for the fix.

Serialize packet_recvmsg() pressure clearing with the same queue lock
only after PACKET_SOCK_PRESSURE has been observed. If the flag is clear
and the socket has moved away from tpacket_rcv, packet_set_ring() has
already detached the socket and waited for synchronize_net(), so no new
packet input can set the flag again.

packet_poll() already holds sk_receive_queue.lock, so it uses the new
unlocked helper directly.

Fixes: 2ccdbaa6d55b ("packet: rollover lock contention avoidance")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Link: https://patch.msgid.link/f90b5688311fa278d1361ea8c6be0bf25967d591.1785247446.git.zihanx@nebusec.ai
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1370,13 +1370,25 @@ static int packet_rcv_has_room(struct pa
 	return ret;
 }
 
-static void packet_rcv_try_clear_pressure(struct packet_sock *po)
+static void __packet_rcv_try_clear_pressure(struct packet_sock *po)
 {
 	if (packet_sock_flag(po, PACKET_SOCK_PRESSURE) &&
 	    __packet_rcv_has_room(po, NULL) == ROOM_NORMAL)
 		packet_sock_flag_set(po, PACKET_SOCK_PRESSURE, false);
 }
 
+static void packet_rcv_try_clear_pressure(struct packet_sock *po)
+{
+	struct sock *sk = &po->sk;
+
+	if (!packet_sock_flag(po, PACKET_SOCK_PRESSURE))
+		return;
+
+	spin_lock_bh(&sk->sk_receive_queue.lock);
+	__packet_rcv_try_clear_pressure(po);
+	spin_unlock_bh(&sk->sk_receive_queue.lock);
+}
+
 static void packet_sock_destruct(struct sock *sk)
 {
 	skb_queue_purge(&sk->sk_error_queue);
@@ -4342,7 +4354,7 @@ static __poll_t packet_poll(struct file
 			TP_STATUS_KERNEL))
 			mask |= EPOLLIN | EPOLLRDNORM;
 	}
-	packet_rcv_try_clear_pressure(po);
+	__packet_rcv_try_clear_pressure(po);
 	spin_unlock_bh(&sk->sk_receive_queue.lock);
 	spin_lock_bh(&sk->sk_write_queue.lock);
 	if (po->tx_ring.pg_vec) {
@@ -4582,14 +4594,14 @@ static int packet_set_ring(struct sock *
 		rb->frame_max = (req->tp_frame_nr - 1);
 		rb->head = 0;
 		rb->frame_size = req->tp_frame_size;
+		po->prot_hook.func = (po->rx_ring.pg_vec) ?
+						tpacket_rcv : packet_rcv;
 		spin_unlock_bh(&rb_queue->lock);
 
 		swap(rb->pg_vec_order, order);
 		swap(rb->pg_vec_len, req->tp_block_nr);
 
 		rb->pg_vec_pages = req->tp_block_size/PAGE_SIZE;
-		po->prot_hook.func = (po->rx_ring.pg_vec) ?
-						tpacket_rcv : packet_rcv;
 		skb_queue_purge(rb_queue);
 		if (atomic_long_read(&po->mapped))
 			pr_err("packet_mmap: vma is busy: %ld\n",


