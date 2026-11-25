Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625386;
	b=PjtAwqvsf9cIt2lcFcdhyMRPXR7Zij3KkuCXX+AFZ5HScibNOwOv9FrgAE6DBSJlC5Gk
	 6EhCPIgReWX5wVMCY7t4AnJa4vVdnBOcbINAHuk5ht+TF4G2gyUxjQTG/aJVrawj6odIZ
	 gbQwc1hVstPnuUElvhYCwhl3smPM4WwUCe3CqGoHnKuMfdq0E2apmpj8j0MpgCNJe3WYv
	 Ve/owC5bwZSroB0x7plzYvwYGM08sEeojs9MXaNtlT6mXBkK3VQKucU0iByBtT+MAhafK
	 KfmWuP8SfnA0Pgk2N1ZZD2G1+TFCd0XdCaN5WJmEIutmB9Qk2NN/vjEEdaXsBpOHGeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ML36Ee0nbyY85TdAZuckza9Tjg4kGT37ceAnD648txk=;
	b=0BQtfU9048cFaTBAIl+vm055pr7Nr3FByYCoPcdMxLmsufXYMtCzFtIFTJnIoUFTfDCp
	 syYT4uA8xdmFidERk/ymOVOm/jxXxhdEIz975wORpLQZHm+GJmVoQwo4+n0HU7cjAYQy9
	 t/WTKcrZIDlQ3qPUeJm9sPcC2NPRLvFEmfc7eSEUISnr43QvZjRwegUXWjrFUHSQEOKUg
	 POOrXGf+Md1P5P5Hf+cp69Xh3aP5AjTMSe1lMvTRnADkGgV6/3pcRMbtpkehJ+MQOZer+
	 KT2JkO7iIznYUvNcOoyoFIGGGwJHmgPq3+4c6nK7G5H2LjOpLzkO9k0nwTtdPwB8SsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WPJ99VN+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53ED606A31E;
	Wed, 25 Nov 2026 16:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WPJ99VN+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7C71F000CA;
	Wed, 25 Nov 2026 16:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625386;
	bh=ML36Ee0nbyY85TdAZuckza9Tjg4kGT37ceAnD648txk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WPJ99VN+zenbwmh16fZiauW04Uqd4FUmFHNYyrteo0xq2Q5OQB0mVfLYGQZYCyrL5
	 xj1NjPt94ABE6laVZyOc+bKyEc386bXAYmlw2ypHg6R/3hC5MhOysg89X5VxgUVn7p
	 Np1H6IjHZ0EB4oErV1eg+8Kx2bPJ+vJ7OvewuxM4=
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
Subject: [PATCH 6.12 498/816] rxrpc: Fix sendmsg length
Date: Wed, 25 Nov 2026 15:34:06 +0100
Message-ID: <20261125143900.715963437@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
[ sashal: Replaced the umin() context line with the tree's min_t(size_t, ...) form by taking the patch's if (len > 0) and min3(txb->space, len, msg_data_left(msg)) lines directly, with no other adaptation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/sendmsg.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index ea649144c49f0..6686fc99ec3b0 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -324,9 +324,9 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 
 	ret = -EMSGSIZE;
 	if (call->tx_total_len != -1) {
-		if (len - copied > call->tx_total_len)
+		if (len > call->tx_total_len)
 			goto maybe_error;
-		if (!more && len - copied != call->tx_total_len)
+		if (!more && len != call->tx_total_len)
 			goto maybe_error;
 	}
 
@@ -345,7 +345,7 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 			 * the security header is going to be in the padded
 			 * region (enc blocksize), but the trailer is not.
 			 */
-			remain = more ? INT_MAX : msg_data_left(msg);
+			remain = more ? INT_MAX : len;
 			txb = call->conn->security->alloc_txbuf(call, remain, sk->sk_allocation);
 			if (!txb) {
 				ret = -ENOMEM;
@@ -359,8 +359,8 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 		_debug("append");
 
 		/* append next segment of data to the current buffer */
-		if (msg_data_left(msg) > 0) {
-			size_t copy = min_t(size_t, txb->space, msg_data_left(msg));
+		if (len > 0) {
+			size_t copy = min3(txb->space, len, msg_data_left(msg));
 
 			_debug("add %zu", copy);
 			if (!copy_from_iter_full(txb->kvec[0].iov_base + txb->offset,
@@ -371,6 +371,7 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 			txb->len += copy;
 			txb->offset += copy;
 			copied += copy;
+			len -= copy;
 			if (call->tx_total_len != -1)
 				call->tx_total_len -= copy;
 		}
@@ -382,8 +383,8 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 
 		/* add the packet to the send queue if it's now full */
 		if (!txb->space ||
-		    (msg_data_left(msg) == 0 && !more)) {
-			if (msg_data_left(msg) == 0 && !more)
+		    (len == 0 && !more)) {
+			if (len == 0 && !more)
 				txb->flags |= RXRPC_LAST_PACKET;
 			else if (call->tx_top - call->acks_hard_ack <
 				 call->tx_winsize)
@@ -398,7 +399,7 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 			rxrpc_queue_packet(rx, call, txb, notify_end_tx);
 			call->tx_pending = NULL;
 		}
-	} while (msg_data_left(msg) > 0);
+	} while (len > 0 && msg_data_left(msg) > 0);
 
 success:
 	ret = copied;
-- 
2.53.0



