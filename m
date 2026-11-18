Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026852;
	b=v5BurWj4J6W++XUQtpuguCOSjmWeoJYqZPjeGshYqdoKtC8MP9kXUstty7/7m4Du/zYe
	 02Fd+Wal1DMK4ZAifZN694Blj9G2sWdeczKdeoDGwQ+RjtarSYbPn4wwgoOYCi3oKKW3E
	 JO1J15jVT27Kqij+oR7v77eVsjFgAE66VWxXPO1tWTTKwNsa9SB6lt497BaqZCWb5tyhY
	 ADT0lTP68roPqK+MyJv786jfabS1j4e9BMJ6JbB9g9VUueZR+ootvkAHgacK/sqE9/EIL
	 SAMMe5F/PHQGr1TlQfJWSWt+YMpJcbZn37uxBPRBAU5h+uPebXy9prGjo34jjp8JL7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1z/NAS5OYATOVUelh16wTpX6Kjh/5t537Nxko3UvPb4=;
	b=DqGaRMIPdK0mj2Uk8A8Bz4LgtN416+ooV+orueQ5wgOKTA5dOILu/uZe+TsQM80uqJ/s
	 OSoHYHj5jmenFS/a09isaUzguXrOOrR3x+YS92zgtyqvr4KmMsqXlcA/MpuKzNfnbA91D
	 CvrN6aGzQ+CE2bDdVg1XTRphbVP4Cys7JXTjUBUULqOD1svhI/m3ITv5So3V+rhNjPvpd
	 T5pTYPw88Wvic49ivAMQ2rrtfv9Efd3WdBOweo2JJkioaYxR2jvVMY5bZ0OJNh/6/ZcVW
	 f+QoXgMVyHKR1S71ca6UZpdK5k3o7nyU5pwLaGeEUV/sEPbhFV+XSWsn3mrhnb5+7WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mT41XVnU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7005C606A337;
	Wed, 18 Nov 2026 18:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mT41XVnU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E601F000C4;
	Wed, 18 Nov 2026 18:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026852;
	bh=1z/NAS5OYATOVUelh16wTpX6Kjh/5t537Nxko3UvPb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mT41XVnUSQwBHe0aYmlWsXftzlK0WUZiL6yMfr2qvNu0BtXdAUPYbr5E8v8B8vap+
	 XMWKF1ZhdP36TKMgRzMkIPAlF4zGqOzd9OBQKnmW8Hs/K2LeAGn5yIPUcjKvVdYS+L
	 W9rY4ppAX5OuvxjaF1r6e27ZjXiMoePeSiTClnX4=
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
Subject: [PATCH 6.18 1582/2151] rxrpc: Fix sendmsg length
Date: Wed, 18 Nov 2026 15:55:17 +0100
Message-ID: <20261118150219.511619420@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 29c3e95906b65..291ff8788ebcb 100644
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



