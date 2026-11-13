Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590837;
	b=zlFHDc5OykjsMeerxgVtHmBVeJnUvRO1bZgd4n4AAkaLrH8KTKT4e6dCxUkzhUHmjd5f
	 G65GqAU6CtuDKatbMdjGI0V7UYOIuf6A/SsYRT6XA3xCCTK8cMvSsmCmvHzbbSVjUC66O
	 nDbE4+nHjHky+Sg4CScc70PpMrTXfoSQl94s7gktXfiZ1mnqKatWx1Ney8cJad/LjMg5R
	 /1Ye8hW0ItDwYoVZxixPXPlFPhmqy8Vh5gQ5HeEK1CqsolIX4gHajhAcoxqL+5/PUC5HM
	 qKYFjVx+3/wfYj+TKaRtjBhoZhTlH0irAQHInYojua+xqUeSqJH/57CzFgTNnpT8TrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sMpqanQu2l58k/bVmk6gB35+m7MlFTntAe2K62tIbcg=;
	b=IDquRQ6nGzTjEpfqZFNbtd9cuRXluMFU+MCEC8awT5SoAI6BTFa629eBD9s8O/c8dFqC
	 6Gq5pdXXdRiHCQx8kzW9+P1hYkAJF3r9ZHxarHU8UoOc/VI2J4vnmTlDNi088msR0LpJm
	 PBAIJx7LRqJ71hF+quSuK1yopW++YyihcsqZ5hc0dnyS1AcMegN6anyOMb0yvgnAty224
	 JtjfMTspaLLYXMN4uzlobAqQi++++Gqe4GNZ7WzWrBavxPlsMDdDiKCeLxeLmfwnzQLbI
	 hzkc3vdM5Dzu0GpmBA093zUdL56nvWviE4co7z+/Q9kwDML7pEjpHZAJojb0jkmQnKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WPOYTymd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD61607E07B;
	Fri, 13 Nov 2026 17:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WPOYTymd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B8C1F000C5;
	Fri, 13 Nov 2026 17:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590837;
	bh=sMpqanQu2l58k/bVmk6gB35+m7MlFTntAe2K62tIbcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WPOYTymd0Xh8pjsAoc3RIBaZPlkeryu9g7W/C5lKJM2TnK7/O1ZdGpea/Oqt0N+bL
	 D51mBIz7ERikEy7c5yM5SplZggwf0gV0wDSlCqrxVgtjTwtM3pVc8FpkYNSxtxBjLX
	 mb/vi43Ys9lobLd3P1kA39oU85rtJKvo3joRETR4=
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
Subject: [PATCH 6.12 039/670] afs: Fix afs to abort the rxrpc call on send error
Date: Fri, 13 Nov 2026 10:43:23 -0500
Message-ID: <20261113153812.481546465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
[ sashal: Retained explicit length arguments in rxrpc_kernel_send_data() calls to match the older API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/rxrpc.c               | 49 +++++++++++++-----------------------
 include/trace/events/rxrpc.h |  2 +-
 2 files changed, 18 insertions(+), 33 deletions(-)

diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 55449c8791426..934667e547dc2 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -442,10 +442,8 @@ void afs_make_call(struct afs_call *call, gfp_t gfp)
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
@@ -853,6 +851,7 @@ void afs_send_empty_reply(struct afs_call *call)
 {
 	struct afs_net *net = call->net;
 	struct msghdr msg;
+	int ret;
 
 	_enter("");
 
@@ -865,21 +864,13 @@ void afs_send_empty_reply(struct afs_call *call)
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
 
@@ -891,7 +882,7 @@ void afs_send_simple_reply(struct afs_call *call, const void *buf, size_t len)
 	struct afs_net *net = call->net;
 	struct msghdr msg;
 	struct kvec iov[1];
-	int n;
+	int ret;
 
 	_enter("");
 
@@ -906,21 +897,15 @@ void afs_send_simple_reply(struct afs_call *call, const void *buf, size_t len)
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
index 8c4d791507f18..5e29744e45037 100644
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



