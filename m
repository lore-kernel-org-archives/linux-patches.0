Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214315;
	b=a8Y5sTQ5Olz/3DutfZubzF4fVDPgwUU/v4+/qxdwjyMNmiN6x2mhwoI9YBLeZym/T9aa
	 Dksvs61CgPkK4UpSkzEvOpzxxDPr3fGowBXUtud4eWxv0DISiAJcQbukGK8NLIpMftPmP
	 8nQlWJMB56N6qZAnjR0jcLRU3Sw4AgduiyHF3EW/ZKhx4GGbEffais9kZvIA5QX47dyDS
	 z/xKnC36mCL2QBkME1PC9YpRALqVdeLF9fCobgLqOJlrBmMFbJvWFvf40vlA2awppwrY6
	 x6qcXdup/qpsNtmhQr5tgwvNp44ZDkDOHWWSKgOfxeiBES6WnoTdJzFWK+xdSj5cHtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214315;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e9PuSgkhqjkRwxvKhoUF8iyZzjmZhkjrOzLEgmnugnI=;
	b=GANH4pNb7yqXE0Vf8HbA9TDXH0gaHtWPZXwr0cd0WeFamARb9N4xNrayfbNBBYznaBll
	 eKSpS9llqRleTcWEhiL5mHTa14O7UGXxVfdi2EqC5xmkuVK2X8/O5O988CHHSg7KCQoLd
	 7nPS42712jsZ41yykO+EIc2h/4Kn3Mxv+xOROtSHrLu8cFYVqNwd/IGWs77Q5VQz5Zj+3
	 bZ7op9TCAYyDDqlvYz25BcJjh89ZUrjV5yi47XKFdssG1Jl8ouax+SncNaqkVhlVN2bbX
	 zARmgCos+6e53QGPjSsqAOwbS4Nnw/SCwjgKvLDe6Hf4chfa3c2iaGzg7kJTF0OIQgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nVUMwy+3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278F2606BF9E;
	Wed, 28 Oct 2026 19:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nVUMwy+3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806971F01825;
	Wed, 28 Oct 2026 19:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214315;
	bh=e9PuSgkhqjkRwxvKhoUF8iyZzjmZhkjrOzLEgmnugnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nVUMwy+3yTrA28QjPGBe1djKQkhhu6/JsA05s89Vbr/h7dggN3Lo9cb1eWI1PDNja
	 wUCpUDbZ5SifIF39ClNYUqAyfxv3IcxzgVNax8obvhBklaOq9PDzDs8M2qmvP9hZME
	 xidDrekDcugio9xGLgwpkvinCNp+j5YWgXwgEQQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Junvyyang, Tencent Zhuque Lab" <zhuque@tencent.com>,
	David Howells <dhowells@redhat.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	LePremierHomme <kwqcheii@proton.me>,
	Marc Dionne <marc.dionne@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0808/1887] rxrpc: Fix recv-recv race of completed call
Date: Wed, 28 Oct 2026 17:48:24 +0100
Message-ID: <20261028170517.816372892@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 962fb1f651c2cf2083e0c3ef53ba69e3b96d3fbc ]

If a call receives an event (such as incoming data), the call gets placed
on the socket's queue and a thread in recvmsg can be awakened to go and
process it.  Once the thread has picked up the call off of the queue,
further events will cause it to be requeued, and once the socket lock is
dropped (recvmsg uses call->user_mutex to allow the socket to be used in
parallel), a second thread can come in and its recvmsg can pop the call off
the socket queue again.

In such a case, the first thread will be receiving stuff from the call and
the second thread will be blocked on call->user_mutex.  The first thread
can, at this point, process both the event that it picked call for and the
event that the second thread picked the call for and may see the call
terminate - in which case the call will be "released", decoupling the call
from the user call ID assigned to it (RXRPC_USER_CALL_ID in the control
message).

The first thread will return okay, but then the second thread will wake up
holding the user_mutex and, if it sees that the call has been released by
the first thread, it will BUG thusly:

	kernel BUG at net/rxrpc/recvmsg.c:474!

Fix this by just dequeuing the call and ignoring it if it is seen to be
already released.  We can't tell userspace about it anyway as the user call
ID has become stale.

Fixes: 248f219cb8bc ("rxrpc: Rewrite the data and ack handling code")
Reported-by: Junvyyang, Tencent Zhuque Lab <zhuque@tencent.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
cc: LePremierHomme <kwqcheii@proton.me>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/20250717074350.3767366-3-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/recvmsg.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 99c679f40e7b6..870fab693653f 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -546,6 +546,15 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	write_lock_bh(&rx->recvmsg_lock);
 	l = rx->recvmsg_q.next;
 	call = list_entry(l, struct rxrpc_call, recvmsg_link);
+
+	if (test_bit(RXRPC_CALL_RELEASED, &call->flags)) {
+		list_del_init(&call->recvmsg_link);
+		write_unlock_bh(&rx->recvmsg_lock);
+		release_sock(&rx->sk);
+		rxrpc_put_call(call, rxrpc_call_put);
+		goto try_again;
+	}
+
 	if (!(flags & MSG_PEEK))
 		list_del_init(&call->recvmsg_link);
 	else
@@ -568,8 +577,11 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 	release_sock(&rx->sk);
 
-	if (test_bit(RXRPC_CALL_RELEASED, &call->flags))
-		BUG();
+	if (test_bit(RXRPC_CALL_RELEASED, &call->flags)) {
+		mutex_unlock(&call->user_mutex);
+		rxrpc_put_call(call, rxrpc_call_put);
+		goto try_again;
+	}
 
 	if (test_bit(RXRPC_CALL_HAS_USERID, &call->flags)) {
 		if (flags & MSG_CMSG_COMPAT) {
-- 
2.53.0



