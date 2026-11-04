Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829103;
	b=OwxYT/a7Gy1G6vHom2jo9k2z7F0f+Wnq/3N8Kj74AEfB4EaKkoH/gZfxHHvXSzx/4TiI
	 qv7/uWe/POg5i6fMv6bWLUfzzyJgeOClbDK/5QEMUDQ16zn/lcDhWr4wFPI6VRWwBlcCo
	 idG1KVfAWf0em4G2xHZLcH9NsLCWBT6bU0PMYL2MjQj9PuYTj8UOcWCj6hziXUpANheXl
	 18IbWGq6zQtMcJBmk/QoFBndqK+IPXfTMCEgeaWCTY5wskQIu7fgo9NuX1h0F3RXlsuyE
	 o2jvRRCuQeS13Sg1kwru3OwwdTqIGhvbl4Rz7D+oCa2S3FAbn36JxE9B+om3/Zer3OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829103;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Gjo5KITE1y4+RtacsY/VWp/GDBwNPUL72WwB8EFdlU=;
	b=RqtIyZvP+uBsvfU/XGVyjFXrXDPQ6CNbG2mcMMhRA4+wIH3Ylk0/khfUUBQ61iOzrmz9
	 EKZsIL3Sa7IFfKXDDOm74Uc+oD667FxotChQwIex0x+XLzWnaMh0JiWNainnVpKl6rTP4
	 h8p2NkPeJZVtdT1FyZ9PmvxVcTwJDfzWIu20OvH55iktASt81z+yxpqEkcYTl0phZ0TtX
	 0Hqosr+2nddt08yg8VyNlPJdBMvNAU9lVKMH7Wx0Vor4fyCLABuh1WnPh68q/Hz5GNfrs
	 dKaKTVngxD2ecf6m5Kax+ZGHsMULOkRXDwpLPQDUIK+oK6xsmtms0iWTWH5q45aSsHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ClKCNapv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA5B6072FB3;
	Wed,  4 Nov 2026 21:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ClKCNapv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D761F000C1;
	Wed,  4 Nov 2026 21:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829102;
	bh=3Gjo5KITE1y4+RtacsY/VWp/GDBwNPUL72WwB8EFdlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ClKCNapvMGVhC5p9Fj6pmfHbR+GIoXmmeQuklWNXLP7xWkCh3FR0ev9t1E5yWa5ni
	 MI0qdK9+M09XsgnILNQjJPFkygFyvh2uLoI7YofYgCGgOap7mMO2lzXDsLYQHskr/O
	 395uC8OLBRyNNmD9gg0MF0VwD/R+IXl6wmsO2CjU=
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
	linux-afs@lists.infradead.org
Subject: [PATCH 7.3 448/547] afs: Fix afs to abort the rxrpc call on send error
Date: Wed,  4 Nov 2026 16:10:32 -0500
Message-ID: <20261104211051.076802223@linuxfoundation.org>
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

commit 3e6af08a571fe2943a006acf3e890f36322602bc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/rxrpc.c               |   37 +++++++++++++------------------------
 include/trace/events/rxrpc.h |    2 +-
 2 files changed, 14 insertions(+), 25 deletions(-)

--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -441,10 +441,8 @@ void afs_make_call(struct afs_call *call
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
@@ -857,6 +855,7 @@ void afs_send_empty_reply(struct afs_cal
 {
 	struct afs_net *net = call->net;
 	struct msghdr msg;
+	int ret;
 
 	_enter("");
 
@@ -869,21 +868,13 @@ void afs_send_empty_reply(struct afs_cal
 	msg.msg_controllen	= 0;
 	msg.msg_flags		= 0;
 
-	switch (rxrpc_kernel_send_data(net->socket, call->rxcall, &msg,
-				       afs_notify_end_reply_tx)) {
-	case 0:
-		_leave(" [replied]");
-		return;
-
-	case -ENOMEM:
-		_debug("oom");
+	ret = rxrpc_kernel_send_data(net->socket, call->rxcall, &msg,
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
 
@@ -913,12 +904,10 @@ void afs_send_simple_reply(struct afs_ca
 	ret = rxrpc_kernel_send_data(net->socket, call->rxcall, &msg,
 				     afs_notify_end_reply_tx);
 	if (ret < 0) {
-		if (ret == -ENOMEM) {
-			_debug("oom");
-			rxrpc_kernel_abort_call(net->socket, call->rxcall,
-						RXGEN_SS_MARSHAL, -ENOMEM,
-						afs_abort_oom);
-		}
+		rxrpc_kernel_abort_call(net->socket, call->rxcall,
+					RXGEN_SS_MARSHAL, ret,
+					afs_abort_send_error);
+		afs_set_call_complete(call, ret, RXGEN_SS_MARSHAL);
 		_leave(" [error]");
 	}
 }
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
 	EM(afs_abort_unsupported_sec_class,	"afs-unsup-sec-class")	\
 	/* rxperf errors */						\


