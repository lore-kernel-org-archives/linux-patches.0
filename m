Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C75546AA7E;
	Tue, 21 Jul 2026 15:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647965; cv=none; b=n0t5zwo69iA7HPp53/z+JB3mi9UOtniPE11AFvwDK9kuEByXjiEFwH8mjtfNTXNNFX+8W4iWmc8WhdORsCxkGzZa7UvZWuqWYw33AtuJpcgPYZJz5SpI2nSYtsw6Rfwb4PJgecEPirp52zVamecWZAN8zmPMHON5dY+NW/YQnoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647965; c=relaxed/simple;
	bh=5KQB5ZQjiuqIGEvGZA1X8stUs+hUyzVT1XtJmneBwC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rp3Iu+VAqILvy8SbLnvUjfZxFDKK8ZXAyYy3/IdE21rMwBlQi4H5JjIKyU71WvGojrCcuMfnH2te8ig+AfC4P0u4TZQFX6j9XfO8IG1fi6Ay+SGLvwkPlqIUHVmAsekpriPl0DON9wWK2kyeQIpJusQ4UR8akNn9GsTck/eR+Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGLv28Us; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGLv28Us"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D361F000E9;
	Tue, 21 Jul 2026 15:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784647963;
	bh=HYKSvbYH6/XCDnrNmB613fKHGp4wczzihlj8vSqvRek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mGLv28UsdZRfurRd6TRgmi3Jox+w/PWcLyeDnC/hepCVtYSqeZpWdoXZAOlzEX7oL
	 ikQvfVZCxXTXdloD6nJSVOvz0vwYSQP7x12ZI6+OgKVio4D3MCQ/kJw8SLQURgl98W
	 UOsWXS2DR/yxAlWTfDd9JlmwDqe6CY/qJwqIT86Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Li Daming <d4n.for.sec@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 0021/2077] rxrpc: serialize kernel accept preallocation with socket teardown
Date: Tue, 21 Jul 2026 16:54:54 +0200
Message-ID: <20260721152553.170891300@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Daming <d4n.for.sec@gmail.com>

commit dc175389b18c29a5303ee83169ec653adfae3e17 upstream.

rxrpc_kernel_charge_accept() reads rx->backlog without any
socket/backlog synchronization and passes that raw pointer into
rxrpc_service_prealloc_one(). A concurrent rxrpc_discard_prealloc()
sets rx->backlog = NULL and frees the backlog rings, so a kernel
preallocation worker can keep using a freed struct rxrpc_backlog
while updating *_backlog_head/tail and array slots.

Serialize the state check and backlog lookup with the socket lock,
and reject kernel preallocation once teardown has disabled
listening or discarded the service backlog.

Fixes: 00e907127e6f ("rxrpc: Preallocate peers, conns and calls for incoming service requests")
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Li Daming <d4n.for.sec@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260609140911.838677-6-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/call_accept.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -471,13 +471,26 @@ int rxrpc_kernel_charge_accept(struct so
 			       unsigned long user_call_ID, gfp_t gfp,
 			       unsigned int debug_id)
 {
-	struct rxrpc_sock *rx = rxrpc_sk(sock->sk);
-	struct rxrpc_backlog *b = rx->backlog;
+	struct rxrpc_backlog *b;
+	struct rxrpc_sock *rx;
+	struct sock *sk;
+	int ret;
 
-	if (sock->sk->sk_state == RXRPC_CLOSE)
-		return -ESHUTDOWN;
+	sk = sock->sk;
+	rx = rxrpc_sk(sk);
 
-	return rxrpc_service_prealloc_one(rx, b, notify_rx, user_call_ID,
-					  gfp, debug_id);
+	lock_sock(sk);
+	if (sk->sk_state != RXRPC_SERVER_LISTENING || !rx->backlog) {
+		ret = -ESHUTDOWN;
+		goto out;
+	}
+
+	b = rx->backlog;
+	ret = rxrpc_service_prealloc_one(rx, b, notify_rx, user_call_ID,
+					 gfp, debug_id);
+
+out:
+	release_sock(sk);
+	return ret;
 }
 EXPORT_SYMBOL(rxrpc_kernel_charge_accept);


