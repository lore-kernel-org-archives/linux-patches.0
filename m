Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E653238E106;
	Thu, 30 Jul 2026 16:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428035; cv=none; b=nEbYpuefenUqNOZeSmlmi3VqL+lI6iOcN3wtLxR7LIMWCopjAP5QwFDQG13t86OpiQgW6mnGbljrBZ8AuxhTCx1zNIvxI5yLJf2DLef0mw2UDQ0qZEJkTDApj7mtIeBvMiKJpXIZ9wQ3kv+q5ZejAsUEznnEZJcih4yarTNT1fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428035; c=relaxed/simple;
	bh=OAxhDQ75g+fJemQwsDFMvz8gXv+ChIkIpADECyC9DRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qzad5ruHPd7QqfIvPh5KU+w4KWbvP4rL7TnpRCwhzq9ZTxRpAHBkm+JqQSok+RCrwDjDGRd2VaBs+IoyBP2ZIDxBDJsGRfR/U0uGWB5yXYh60ENgQVKoowHtzVRKh+yAtb9zx8ViWolSukSSWrWRTniOKi4XYk7gXOtXnpW8jLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rwre0Vu3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rwre0Vu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D148D1F00A3A;
	Thu, 30 Jul 2026 16:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428033;
	bh=XYjEFvHraTVc4FX+w5PnQtSdF61dK342pCKEa9Ef6Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rwre0Vu3qcQN/bkKeUxE5Dvx4J1tSRD0GQ0NqwoO200NSUKa9YXGi0hbW2WQtuKOo
	 dhJGqqBfLSQTyhuoWIW7sRdksPmJD/kLLVwVEzx/n6E6cJJc8j3gLL+/wiBMYfz095
	 0ZauNJIqq9T1gTud+CNH4qasRTYhlWDnmIjJtmjo=
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
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 381/484] rxrpc: serialize kernel accept preallocation with socket teardown
Date: Thu, 30 Jul 2026 16:14:38 +0200
Message-ID: <20260730141431.749905487@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Daming <d4n.for.sec@gmail.com>

[ Upstream commit dc175389b18c29a5303ee83169ec653adfae3e17 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/call_accept.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -470,13 +470,26 @@ int rxrpc_kernel_charge_accept(struct so
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


