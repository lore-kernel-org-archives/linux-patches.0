Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BA619DF9A;
	Fri, 17 Oct 2025 15:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714859; cv=none; b=Hbd8y3GrHsEYu4YBL2P8M/y0DewCeTiGETTuxClvyeR0uLwaHDvaalNWe0gGNXSQKL3bMEAMbT9Et1sl5uoiyOtTuPGFRV4K+Y84pbnbs6XK8DlFgnjwqVTFFq0/Rl5aJkrHalaPZ/VLLB9rZQ7baZ04jwVZlSIEfqW/yx3a9Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714859; c=relaxed/simple;
	bh=DTt8YZsf4tW52q09NBE/jxZrC3sGgvPUybggayAKDBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRtYP41k6GB9VR0UMans9zhq7buXvj99eh767c7dhRDa32sBdSunLLw3e0JRbFCvfHNjqZYIbxqRytz7GWkNnSI0vxWUphthhhAwNlsYuvm1XEM99YPq/Uy5mIAvD6CBZi2wg/X4mcIhdmd3gNXWYhbhRpU+jrynEHO6aRpaj0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OysADg1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OysADg1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2483FC4CEE7;
	Fri, 17 Oct 2025 15:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714859;
	bh=DTt8YZsf4tW52q09NBE/jxZrC3sGgvPUybggayAKDBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OysADg1DuW+ghghPERwHLtdLZoX2N2+oHbhZqr2ttAU1DNkfdnNR8n0gWv7tyqAkK
	 NlTAPBTmbJWkerxmyoJO7w+v/RFPW+HJqA1+4A2MPUCR5nKA/yWw8rjVJki6+a/Fpv
	 Of/kmLqVRfGpXpgZvdzK0SlEaScYV03ahMJMwT10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 6.17 014/371] nfsd: unregister with rpcbind when deleting a transport
Date: Fri, 17 Oct 2025 16:49:49 +0200
Message-ID: <20251017145202.313636633@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

commit 898374fdd7f06fa4c4a66e8be3135efeae6128d5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sunrpc/svc_xprt.h |    3 +++
 net/sunrpc/svc_xprt.c           |   13 +++++++++++++
 net/sunrpc/svcsock.c            |    2 ++
 3 files changed, 18 insertions(+)

--- a/include/linux/sunrpc/svc_xprt.h
+++ b/include/linux/sunrpc/svc_xprt.h
@@ -104,6 +104,9 @@ enum {
 				 * it has access to.  It is NOT counted
 				 * in ->sv_tmpcnt.
 				 */
+	XPT_RPCB_UNREG,		/* transport that needs unregistering
+				 * with rpcbind (TCP, UDP) on destroy
+				 */
 };
 
 /*
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -1014,6 +1014,19 @@ static void svc_delete_xprt(struct svc_x
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
@@ -836,6 +836,7 @@ static void svc_udp_init(struct svc_sock
 	/* data might have come in before data_ready set up */
 	set_bit(XPT_DATA, &svsk->sk_xprt.xpt_flags);
 	set_bit(XPT_CHNGBUF, &svsk->sk_xprt.xpt_flags);
+	set_bit(XPT_RPCB_UNREG, &svsk->sk_xprt.xpt_flags);
 
 	/* make sure we get destination address info */
 	switch (svsk->sk_sk->sk_family) {
@@ -1355,6 +1356,7 @@ static void svc_tcp_init(struct svc_sock
 	if (sk->sk_state == TCP_LISTEN) {
 		strcpy(svsk->sk_xprt.xpt_remotebuf, "listener");
 		set_bit(XPT_LISTENER, &svsk->sk_xprt.xpt_flags);
+		set_bit(XPT_RPCB_UNREG, &svsk->sk_xprt.xpt_flags);
 		sk->sk_data_ready = svc_tcp_listen_data_ready;
 		set_bit(XPT_CONN, &svsk->sk_xprt.xpt_flags);
 	} else {


