Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046015;
	b=GYucihLkf+CuXedXWF+Z0WlkAwaRNIzrGpcLk7I0Ssj/fddE6WvnzmhEp3q/5WExLyg4
	 sPUbP8fT5cAaTUeufEsR3YddLGDTvuq7CEk8sFm3kus7NmstfyUiw7RMDJdXLRbJLamHt
	 8tttvf/csIdy+cPAFiGkcU7EqWlnk1ydjvruFm5cp7/2KmEjChZKDh5B/7K+BLpViQFnc
	 8HYD2qoan5Gg9nNcw2joLWcBmj8wim9CcBbOVpWaaKODAw3VfPtxkxtNU/jQLye7uO8UP
	 7cosYrjrO2ZBNI46TJyeKGSrDHOWv6z8Y9iDZYKYWhS+AykdRK9UWmtTGST0SkZr+3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046015;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i6kFVu5tKpZX820+ZdMD5A/ubj+5vx0aAUNzUNDYhsU=;
	b=T9IBil1IBq2iumLpoD2269s76RDqlrf86dsArE1sEvzz16bRHVGn0IAZgRBdOzZ1DjHS
	 IrP+4oZm8QLFWJQaVRTMBpCNNDCuOTN80VhFoLG00wLgPTj/v5jGQ0u+bP/hRNVgnWiUM
	 3FhZmIcXwvLowQm/j0sOWOLrV6XNODd6Fg8w7AnrbT0udtboX/5BLuASaRzV99oh01clC
	 UmGpo07Aj0wEH7FE/V1C850OUKMkm+ENKt7P4S2nphFzzBHgna7ZVUXXS1x7BaCQora3n
	 tCavbeaMwjC/5rgWCZZtx/Y8CSsVf1vnyWT0CJ72D2JPOoTNIcb2wWVQCN3YKcwavug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M+tstQsw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D4F606A325;
	Wed, 18 Nov 2026 23:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M+tstQsw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80BB61F000C4;
	Wed, 18 Nov 2026 23:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046015;
	bh=i6kFVu5tKpZX820+ZdMD5A/ubj+5vx0aAUNzUNDYhsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M+tstQswhH/qMPYB+qv88a/6UxYf4aFKId1Wp2lO9g1gJeqvZQx9i4WGaoqprMG5g
	 /Sbg3NJo8w+65XwAzfaCwDse5FAuJld5FryOuj0degHlju2vDOARmoqfeGAoo0NHly
	 rmvHuNnMIuyU3RWHxvCfVnjiAmYUFZqIg++UsODQ=
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
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1131/2857] afs: Fix afs to abort the rxrpc call on send error
Date: Wed, 18 Nov 2026 15:36:05 +0100
Message-ID: <20261118150242.321823729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

[ Upstream commit 3e6af08a571fe2943a006acf3e890f36322602bc ]

Fix afs_send_empty_reply() and afs_send_simple_reply() to always try to
abort the rxrpc call rather than just aborting on -ENOMEM and otherwise
abandoning it.  If the call is already complete due to network failure or a
received abort, this will do nothing.

Also make afs_make_call() always abort on send error; again, it does
nothing if the rxrpc call is already dead.

Fixes: 08e0e7c82eea ("[AF_RXRPC]: Make the in-kernel AFS filesystem use AF_RXRPC.")
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260824091645.415423-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261006133011.531806-6-dhowells@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ sashal: adapted RxRPC calls to the older API with explicit send lengths and three-character abort reasons ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/rxrpc.c | 34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 0658523bd7865..501a98583e810 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -435,10 +435,9 @@ void afs_make_call(struct afs_addr_cursor *ac, struct afs_call *call, gfp_t gfp)
 	return;
 
 error_do_abort:
-	if (ret != -ECONNABORTED) {
-		rxrpc_kernel_abort_call(call->net->socket, rxcall,
-					RX_USER_ABORT, ret, "KSD");
-	} else {
+	rxrpc_kernel_abort_call(call->net->socket, rxcall,
+				RX_USER_ABORT, ret, "KSD");
+	if (ret == -ECONNABORTED) {
 		len = 0;
 		iov_iter_kvec(&msg.msg_iter, ITER_DEST, NULL, 0, 0);
 		rxrpc_kernel_recv_data(call->net->socket, rxcall,
@@ -857,6 +856,7 @@ void afs_send_empty_reply(struct afs_call *call)
 {
 	struct afs_net *net = call->net;
 	struct msghdr msg;
+	int ret;
 
 	_enter("");
 
@@ -869,20 +869,12 @@ void afs_send_empty_reply(struct afs_call *call)
 	msg.msg_controllen	= 0;
 	msg.msg_flags		= 0;
 
-	switch (rxrpc_kernel_send_data(net->socket, call->rxcall, &msg, 0,
-				       afs_notify_end_reply_tx)) {
-	case 0:
-		_leave(" [replied]");
-		return;
-
-	case -ENOMEM:
-		_debug("oom");
+	ret = rxrpc_kernel_send_data(net->socket, call->rxcall, &msg, 0,
+				     afs_notify_end_reply_tx);
+	if (ret < 0) {
 		rxrpc_kernel_abort_call(net->socket, call->rxcall,
-					RXGEN_SS_MARSHAL, -ENOMEM, "KOO");
-		fallthrough;
-	default:
-		_leave(" [error]");
-		return;
+					RXGEN_SS_MARSHAL, ret, "KSE");
+		afs_set_call_complete(call, ret, RXGEN_SS_MARSHAL);
 	}
 }
 
@@ -917,11 +909,9 @@ void afs_send_simple_reply(struct afs_call *call, const void *buf, size_t len)
 		return;
 	}
 
-	if (n == -ENOMEM) {
-		_debug("oom");
-		rxrpc_kernel_abort_call(net->socket, call->rxcall,
-					RXGEN_SS_MARSHAL, -ENOMEM, "KOO");
-	}
+	rxrpc_kernel_abort_call(net->socket, call->rxcall,
+				RXGEN_SS_MARSHAL, n, "KSE");
+	afs_set_call_complete(call, n, RXGEN_SS_MARSHAL);
 	_leave(" [error]");
 }
 
-- 
2.53.0



