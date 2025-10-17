Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F7F3BB5A;
	Fri, 17 Oct 2025 15:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714829; cv=none; b=tY3FJGfWcPcHpKqhJYKMS5O6wzGGJtvOtke2UKA4K+QM1Lfdo5kvuD6KZ0Z26ve0m0C78XNdDN2TzX0BEPU72WRSuN74d6Gdi6nFeKqXnA5wra+/Xdcv44WiC+fl73+FnSscge13NgedfJsSIKNcpoDXB8SBBcoudTbd1ZLh0OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714829; c=relaxed/simple;
	bh=O24pZQQJ7dzUdHQMc/tZezxU6vpssh/sR5KDZXj//Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2pNQHi6tTF7DTyvUjE2dCswdv9s62rwWisH09YevhmELhCWllUmyqg6Qk16CIV8MxRg3d00h35FWwyB3jYAm4xy0htOI0zE17TgNelY29257H6Ks59SMDGNjCVqnfRRIOLU+SXF8Tz+mojFzikzFxCbSYkqaQGiooyq3QqIQrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oq45rbwb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oq45rbwb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94350C113D0;
	Fri, 17 Oct 2025 15:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714828;
	bh=O24pZQQJ7dzUdHQMc/tZezxU6vpssh/sR5KDZXj//Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oq45rbwb8kSUqshPkPdIoxGemDazCkiFIt3q473q5k2Pc0sVSY/iNvipfwdlIh6Tf
	 YE4+HraREIHJkUQ3Ydrz0xGD2JgkM8DxNf/CWACMgmpaaom3CsOv3lDAQmFMQAHDmE
	 PIdtj2nsGu6+zdhrH4rmRlPAEylw9MtyQgQ5VeY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 247/277] nfsd: unregister with rpcbind when deleting a transport
Date: Fri, 17 Oct 2025 16:54:14 +0200
Message-ID: <20251017145156.168026730@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

[ Upstream commit 898374fdd7f06fa4c4a66e8be3135efeae6128d5 ]

When a listener is added, a part of creation of transport also registers
program/port with rpcbind. However, when the listener is removed,
while transport goes away, rpcbind still has the entry for that
port/type.

When deleting the transport, unregister with rpcbind when appropriate.

---v2 created a new xpt_flag XPT_RPCB_UNREG to mark TCP and UDP
transport and at xprt destroy send rpcbind unregister if flag set.

Suggested-by: Chuck Lever <chuck.lever@oracle.com>
Fixes: d093c9089260 ("nfsd: fix management of listener transports")
Cc: stable@vger.kernel.org
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sunrpc/svc_xprt.h |    3 +++
 net/sunrpc/svc_xprt.c           |   13 +++++++++++++
 net/sunrpc/svcsock.c            |    2 ++
 3 files changed, 18 insertions(+)

--- a/include/linux/sunrpc/svc_xprt.h
+++ b/include/linux/sunrpc/svc_xprt.h
@@ -103,6 +103,9 @@ enum {
 				 * it has access to.  It is NOT counted
 				 * in ->sv_tmpcnt.
 				 */
+	XPT_RPCB_UNREG,		/* transport that needs unregistering
+				 * with rpcbind (TCP, UDP) on destroy
+				 */
 };
 
 static inline void svc_xprt_set_valid(struct svc_xprt *xpt)
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -1028,6 +1028,19 @@ static void svc_delete_xprt(struct svc_x
 	struct svc_serv	*serv = xprt->xpt_server;
 	struct svc_deferred_req *dr;
 
+	/* unregister with rpcbind for when transport type is TCP or UDP.
+	 */
+	if (test_bit(XPT_RPCB_UNREG, &xprt->xpt_flags)) {
+		struct svc_sock *svsk = container_of(xprt, struct svc_sock,
+						     sk_xprt);
+		struct socket *sock = svsk->sk_sock;
+
+		if (svc_register(serv, xprt->xpt_net, sock->sk->sk_family,
+				 sock->sk->sk_protocol, 0) < 0)
+			pr_warn("failed to unregister %s with rpcbind\n",
+				xprt->xpt_class->xcl_name);
+	}
+
 	if (test_and_set_bit(XPT_DEAD, &xprt->xpt_flags))
 		return;
 
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -837,6 +837,7 @@ static void svc_udp_init(struct svc_sock
 	/* data might have come in before data_ready set up */
 	set_bit(XPT_DATA, &svsk->sk_xprt.xpt_flags);
 	set_bit(XPT_CHNGBUF, &svsk->sk_xprt.xpt_flags);
+	set_bit(XPT_RPCB_UNREG, &svsk->sk_xprt.xpt_flags);
 
 	/* make sure we get destination address info */
 	switch (svsk->sk_sk->sk_family) {
@@ -1357,6 +1358,7 @@ static void svc_tcp_init(struct svc_sock
 	if (sk->sk_state == TCP_LISTEN) {
 		strcpy(svsk->sk_xprt.xpt_remotebuf, "listener");
 		set_bit(XPT_LISTENER, &svsk->sk_xprt.xpt_flags);
+		set_bit(XPT_RPCB_UNREG, &svsk->sk_xprt.xpt_flags);
 		sk->sk_data_ready = svc_tcp_listen_data_ready;
 		set_bit(XPT_CONN, &svsk->sk_xprt.xpt_flags);
 	} else {


