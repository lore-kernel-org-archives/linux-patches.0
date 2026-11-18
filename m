Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020394;
	b=fltHq55uS8IXmSEqN+eX382ahxv/D+UB7LeRUbNXxlQx7SHVw8sOSJgpPgwNVX2lt0/j
	 qGAZdc3yTMu1LYjKsZRsbdGI+g83XixgXp7QfFel/TSH2580DJkBA9D2YO4JP+gez7RFJ
	 1JldbDpYuUdpBFX5d4yHIPyxnPzHnR55Hzs79/0pMnl5rwNsA8iA63tqmGV7/+L/OrnvR
	 AmxowB3n4CwlIJt9LndKujqchsJfRN3o+zar9ZXYSdVdP6Mef1B5WvJ4vs85gV5AkDlFT
	 xcCA1NkU9FTSNNE61zgjMSedJPrIIma82gAJeTtIkbziOGnTJfgXuj9M0I+nYfUdLvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fHngU7jY3xPQlaG/x7ykMxg7iBfydaOO7BET8fXw4N4=;
	b=FNcrzq6vPs4ImZ2wpaFUmSKqtzoSPw1EQe8ndMJIfWLxbP8ojmcY5JjPHrIPSAuyTFXS
	 Qm5+1jbVMD2Xfj8e69MK3zlk5XZBII+xfRSSz+uXWk9RvazmCaCM+pzQAzQP6RVXRj1+h
	 quiCbui4ZayeHN7JzPKrt/G67AG2P+380UytXrji+qIgp/pDdNLXCCZ5Ai6cyxlpdRGOI
	 9O+7EokS5YpFHwfab0hLUtgSPq3+cNOw5V0hlfdXg8uxp3b0th4n1j7V9mAUi7a6p6vYW
	 YNB4NAiIKRuSDEUr7Qb3eEmyWZwdGTLGAJO/Pj/ih/BwjxTNKkweyRd971bl4kWO7rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ej3bbWJh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E7C606A320;
	Wed, 18 Nov 2026 16:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ej3bbWJh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD441F000C5;
	Wed, 18 Nov 2026 16:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020394;
	bh=fHngU7jY3xPQlaG/x7ykMxg7iBfydaOO7BET8fXw4N4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ej3bbWJh8bu24qWUbL6/qBMjgkQw2d47gzSm+rv0lqEi9hgAKGrkyq9GqM8Jgg3ga
	 s/Rq1n0ffOm6+ulGUjigvP9gTRD00bOSXLBlODzbR/XHtTKKzDSGZUBoZbd48Row2/
	 JnbPkkLk4Q4HQ93FUhg6aCBQI5pXp0m3fNLjXOII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1937/2651] rxrpc: Fix sendmsg length
Date: Wed, 18 Nov 2026 15:52:57 +0100
Message-ID: <20261118150356.379960211@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

[ Upstream commit ef369cacbd524931199078427ae152c63a826189 ]

rxrpc_send_data() is given two data lengths (len and msg->msg_iter.count)
and is inconsistent about how it uses them.  Fix this by using len in
preference to msg->msg_iter.count.  Also limit the amount copied to either
len or msg->msg_iter.count, whichever is smaller.

Note that, currently, all the callers have len and msg->msg_iter.count the
same and so the problem won't occur.  This is a prerequisite for another
patch that fixes the handling of encryption errors.

Fixes: 382d7974de31 ("RxRPC: Use iov_iter_count() in rxrpc_send_data() instead of the len argument")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/20261006133011.531806-8-dhowells@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/sendmsg.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 393a2dcfda07d..312be27ca75b5 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -374,9 +374,9 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 
 	ret = -EMSGSIZE;
 	if (call->tx_total_len != -1) {
-		if (len - copied > call->tx_total_len)
+		if (len > call->tx_total_len)
 			goto maybe_error;
-		if (!more && len - copied != call->tx_total_len)
+		if (!more && len != call->tx_total_len)
 			goto maybe_error;
 	}
 
@@ -402,7 +402,7 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 			 * the security header is going to be in the padded
 			 * region (enc blocksize), but the trailer is not.
 			 */
-			remain = more ? INT_MAX : msg_data_left(msg);
+			remain = more ? INT_MAX : len;
 			txb = call->conn->security->alloc_txbuf(call, remain, sk->sk_allocation);
 			if (!txb) {
 				ret = -ENOMEM;
@@ -416,8 +416,8 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 		_debug("append");
 
 		/* append next segment of data to the current buffer */
-		if (msg_data_left(msg) > 0) {
-			size_t copy = umin(txb->space, msg_data_left(msg));
+		if (len > 0) {
+			size_t copy = min3(txb->space, len, msg_data_left(msg));
 
 			_debug("add %zu", copy);
 			if (!copy_from_iter_full(txb->data + txb->offset,
@@ -428,6 +428,7 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 			txb->len += copy;
 			txb->offset += copy;
 			copied += copy;
+			len -= copy;
 			if (call->tx_total_len != -1)
 				call->tx_total_len -= copy;
 		}
@@ -439,8 +440,8 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 
 		/* add the packet to the send queue if it's now full */
 		if (!txb->space ||
-		    (msg_data_left(msg) == 0 && !more)) {
-			if (msg_data_left(msg) == 0 && !more)
+		    (len == 0 && !more)) {
+			if (len == 0 && !more)
 				txb->flags |= RXRPC_LAST_PACKET;
 
 			ret = call->security->secure_packet(call, txb);
@@ -449,7 +450,7 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 			rxrpc_queue_packet(rx, call, txb, notify_end_tx);
 			call->tx_pending = NULL;
 		}
-	} while (msg_data_left(msg) > 0);
+	} while (len > 0 && msg_data_left(msg) > 0);
 
 success:
 	ret = copied;
-- 
2.53.0



