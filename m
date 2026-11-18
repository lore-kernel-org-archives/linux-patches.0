Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037195;
	b=AUdbXdMbxOj8hzs7YeFn1AsKskgMjDQevV+mdBb+TfeazNtaje8EAyjYpIwuMsAmcKTc
	 SmWT7Qvb/7OltVOlovC5wwGDKBSGPuAyNMBZG32WxGTOmxwpqg5YfCV+EIK+YuKvWQReG
	 oGU384IlwvoT+YQR5sdDATx+Di51MG8fwcNt091t47JSlzg4Xyonm23L/7jmR6Wj+2+Ot
	 lvR+j+wvbCv3OU63h/4nzOFZcscb/WGtwNV/rbNM+9mLoVpjRwjrvbdymXN6g8hkP/dKf
	 dlbmboTM600wCMhNg0tfKMHl95l6/q1SupMINt6M3InN5sHvYjSvS6kk4z/4p4BJ55A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037195;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MKz5THxQLHSEk5t0k0FYxz2Ec0lFwIcoZClExbfmn/I=;
	b=TF1vwEycJawd3H0W0ogvroTxN8U3YJoWTJytCgdQBuu5CVoN82Q1m0u1W3DbbC+jI+oO
	 CmKz3PsXhYqtstuzATMUITJJwrdcHy9TVClKrEDxwxh+Icah7mSkOXa47a/cSZ2t8yx2k
	 I+wskguRq0Nlr+Hhrvv6hcLqFCpXQSluYAG8zCaM5BObZgR4Komz+lH5EO9MzvsQDWy68
	 o34QsQ9vyNgVt6aYe0/ONAU/FN2MV2u2D+StveTuuXgp0yfop1MKlgMpNmBc38TNFY9Do
	 4AZlb2u7Z9aK9Txje+jOcbEERfj65Fs1uDAt+1EvmoMwgS+JF0hdQtLwcNEajHAqDIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=euk3hHuv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFDD606A320;
	Wed, 18 Nov 2026 21:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=euk3hHuv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8251F000C4;
	Wed, 18 Nov 2026 21:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037195;
	bh=MKz5THxQLHSEk5t0k0FYxz2Ec0lFwIcoZClExbfmn/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=euk3hHuvhiWLdzlLk4Ybc2vIkqSNOKn/miXwCHjyFPBen09rXrPEN9pdVDoPSQniv
	 9iJTUJdKiIuut+McJ8gjtWHzMRh7NpqzKiKHSpUJjNoLxxT9h/ZJPkCPOu5LEaVGwo
	 BTV6SzxIsE8uNYg0N0+yf20kQj4ces8LKhoyQEPc=
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
Subject: [PATCH 6.6 1325/3318] afs: Fix afs to abort the rxrpc call on send error
Date: Wed, 18 Nov 2026 15:32:27 +0100
Message-ID: <20261118150400.072047778@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted rxrpc_kernel_send_data() calls to retain the explicit length argument ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/rxrpc.c               | 49 +++++++++++++-----------------------
 include/trace/events/rxrpc.h |  2 +-
 2 files changed, 18 insertions(+), 33 deletions(-)

diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 523272b86ad46..02bb3ad472eec 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -442,10 +442,8 @@ void afs_make_call(struct afs_addr_cursor *ac, struct afs_call *call, gfp_t gfp)
 	return;
 
 error_do_abort:
-	if (ret != -ECONNABORTED)
-		rxrpc_kernel_abort_call(call->net->socket, rxcall,
-					RX_USER_ABORT, ret,
-					afs_abort_send_data_error);
+	rxrpc_kernel_abort_call(call->net->socket, rxcall,
+				RX_USER_ABORT, ret, afs_abort_send_data_error);
 	if (call->async) {
 		afs_see_call(call, afs_call_trace_async_abort);
 		return;
@@ -872,6 +870,7 @@ void afs_send_empty_reply(struct afs_call *call)
 {
 	struct afs_net *net = call->net;
 	struct msghdr msg;
+	int ret;
 
 	_enter("");
 
@@ -884,21 +883,13 @@ void afs_send_empty_reply(struct afs_call *call)
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
-					RXGEN_SS_MARSHAL, -ENOMEM,
-					afs_abort_oom);
-		fallthrough;
-	default:
-		_leave(" [error]");
-		return;
+					RXGEN_SS_MARSHAL, ret,
+					afs_abort_send_error);
+		afs_set_call_complete(call, ret, RXGEN_SS_MARSHAL);
 	}
 }
 
@@ -910,7 +901,7 @@ void afs_send_simple_reply(struct afs_call *call, const void *buf, size_t len)
 	struct afs_net *net = call->net;
 	struct msghdr msg;
 	struct kvec iov[1];
-	int n;
+	int ret;
 
 	_enter("");
 
@@ -925,21 +916,15 @@ void afs_send_simple_reply(struct afs_call *call, const void *buf, size_t len)
 	msg.msg_controllen	= 0;
 	msg.msg_flags		= 0;
 
-	n = rxrpc_kernel_send_data(net->socket, call->rxcall, &msg, len,
-				   afs_notify_end_reply_tx);
-	if (n >= 0) {
-		/* Success */
-		_leave(" [replied]");
-		return;
-	}
-
-	if (n == -ENOMEM) {
-		_debug("oom");
+	ret = rxrpc_kernel_send_data(net->socket, call->rxcall, &msg, len,
+				     afs_notify_end_reply_tx);
+	if (ret < 0) {
 		rxrpc_kernel_abort_call(net->socket, call->rxcall,
-					RXGEN_SS_MARSHAL, -ENOMEM,
-					afs_abort_oom);
+					RXGEN_SS_MARSHAL, ret,
+					afs_abort_send_error);
+		afs_set_call_complete(call, ret, RXGEN_SS_MARSHAL);
+		_leave(" [error]");
 	}
-	_leave(" [error]");
 }
 
 /*
diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 8cbec303cb505..1dbeabf143347 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -20,10 +20,10 @@
 	/* AFS errors */						\
 	EM(afs_abort_general_error,		"afs-error")		\
 	EM(afs_abort_interrupted,		"afs-intr")		\
-	EM(afs_abort_oom,			"afs-oom")		\
 	EM(afs_abort_op_not_supported,		"afs-op-notsupp")	\
 	EM(afs_abort_probeuuid_negative,	"afs-probeuuid-neg")	\
 	EM(afs_abort_send_data_error,		"afs-send-data")	\
+	EM(afs_abort_send_error,		"afs-send-error")	\
 	EM(afs_abort_unmarshal_error,		"afs-unmarshal")	\
 	/* rxperf errors */						\
 	EM(rxperf_abort_general_error,		"rxperf-error")		\
-- 
2.53.0



