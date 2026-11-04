Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829104;
	b=Z+Ihd01Y3k4O46z7N9OO9lRw+/9h1ezfIA8hXNz2kgnSDjmDSiJPlJQduS++nAd+zRBt
	 qEWRtBEpMvSpegCOIiDVrHq8V6zkmAard/8Ei576CmzmFXRz4usFbnCJ1kso/aNERPOTQ
	 U9cuCY5BbdB5JAF+rrTPj0HEM+Tbfalhu9xa3DEPoBGF+vJnshiFc63MfgUVxNFisuyBF
	 7ReQrywLdBj/jlv0w089BpiIZ/stmNcyWG3ipbQKjrTYBq1NK44YDJGMoMT1DaugwhetE
	 bobwBI8CNXhfJpcrS3cvyUakJG+zKPnZfxMT/+nxV3Ec7JPEtOIPSF9MEhCN9+y3HkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mbrSl+rM4/ZWwzxb0fLgKsdKpxc1wHfBpE1wjGj7XEA=;
	b=GjNbXVxYrx+fS31o3JOj8ytqW+TTNvVBlMQDrU49078wRRdQ2hqU6xH5SJpX25sx4NXT
	 Ybl4frTq0P0dS4gvl2mjSMiP5dGPbe4kR3bm/ZEMItVktfMiXbrZH2HWEmctYLtWWdi4w
	 0jaSNCJkX9toVmP09q/HdJG+HF/Yy+v/Ib3o/wiCxHuRqFVUaPETJSL9Wa4uLT6A2Fe+l
	 nVuK0N4jaYEfj2gu5ayVx0OeL62I67rmIEX6OtTk1KScpd4DvF+PgqhQHs+pugee/5kqP
	 oJC5gzcu//q7fU4pQ6JUqDbsqNGVRhpegTTO6EOw2W4YQsK26qDwSfUl1STI9zV6WHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ej7IyuNf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A1F6072FB2;
	Wed,  4 Nov 2026 21:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ej7IyuNf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BCB1F00919;
	Wed,  4 Nov 2026 21:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829104;
	bh=mbrSl+rM4/ZWwzxb0fLgKsdKpxc1wHfBpE1wjGj7XEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ej7IyuNfM2JljVa1EqZOYjFMZwS4z0Y+VT3EAqqQD88qxh0U43q+fYTulOiGZgEYv
	 GWmBx40X8n6paxZE1fWsFLuXm9TVq1diOQgGKd1jgWJEpNtQOMLwq0Icn3V0mSx7M7
	 Lnmrc+KEPdHva3gJrz8RyoDVGRWOBqJlGuJYIxyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org
Subject: [PATCH 7.3 449/547] rxrpc: Fix double IRQ enablement
Date: Wed,  4 Nov 2026 16:10:33 -0500
Message-ID: <20261104211051.107961999@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 41eb0af096ba8754e584d47e6de42f1e4980ceae upstream.

rxrpc_notify_socket() explicitly disables and then re-enables IRQs, but one
of its call chains (rxrpc_input_queue_data() -> rxrpc_end_rx_phase() ->
rxrpc_call_completed() -> rxrpc_set_call_completion()) has IRQs disabled
around it.

Fix this by making rxrpc_notify_socket() use irqsave spinlocks.

Fixes: a2ea9a907260 ("rxrpc: Use irq-disabling spinlocks between app and I/O thread")
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260812110129.979970-6-dhowells@redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20261006133011.531806-9-dhowells@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/recvmsg.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -24,6 +24,7 @@ void rxrpc_notify_socket(struct rxrpc_ca
 {
 	struct rxrpc_sock *rx;
 	struct sock *sk;
+	unsigned long flags;
 
 	_enter("%d", call->debug_id);
 
@@ -38,16 +39,16 @@ void rxrpc_notify_socket(struct rxrpc_ca
 	sk = &rx->sk;
 	if (rx && sk->sk_state < RXRPC_CLOSE) {
 		if (call->notify_rx) {
-			spin_lock_irq(&call->notify_lock);
+			spin_lock_irqsave(&call->notify_lock, flags);
 			call->notify_rx(sk, call, call->user_call_ID);
-			spin_unlock_irq(&call->notify_lock);
+			spin_unlock_irqrestore(&call->notify_lock, flags);
 		} else {
-			spin_lock_irq(&rx->recvmsg_lock);
+			spin_lock_irqsave(&rx->recvmsg_lock, flags);
 			if (list_empty(&call->recvmsg_link)) {
 				rxrpc_get_call(call, rxrpc_call_get_notify_socket);
 				list_add_tail(&call->recvmsg_link, &rx->recvmsg_q);
 			}
-			spin_unlock_irq(&rx->recvmsg_lock);
+			spin_unlock_irqrestore(&rx->recvmsg_lock, flags);
 
 			if (!sock_flag(sk, SOCK_DEAD)) {
 				_debug("call %ps", sk->sk_data_ready);


