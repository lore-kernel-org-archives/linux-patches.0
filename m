Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215959;
	b=4Dm7A4CGH/ROX/agVuNIOCtUj1PDitOHxJQd2g96tkw6YF4H0t8fxBINTDn1uffTHAUI
	 taGlIh4vfBtcG1S6OBENECorSl8JPMAtsGf2KH5UZY5ccE+scX6iIUKBTElY1KDY5dKvx
	 KvMqKmJ+grbuHpxHaYOl6kJo4ZcDedXI4tFkFTzyLRuGy9l7jD1MxTTa9srmX7FOL9k9z
	 geRQxv19F7pwPjE1tWYb44d3Usm07FYLOPI+PsdfCUJ9ocDg+PqBZBVTZNUIGxi9R4Akv
	 RGPeq+PByouihYl5QPmOyzIijZXQkr+FWzfU1sSug+PJs/wJl8bHbwM1kCNEaogEUEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qu2mWCRxnKnV42akDqZHEoeEvkjjQSZSbhN6VTR4R48=;
	b=bSnwP0B74cnQP9/r7pxeJ6OkxxwoM/wYgbp6J9Mi3cUJggsC1px42ewujAEmZtdkji91
	 IohHf6LB4fSs7XFtsc2lKlDq9BSIGOL1uNY0jIdcB3rDrnhEHGdQSQHmtPs2SUil9nSmZ
	 hfrSD9bFTVkiGbYd9HzWARXSy/sEUrNLS5SyyVaOXuZNx7/DA2GLBbn9poos6pMSBqrVe
	 5jlKlgJkDhtycbleMYtGZRPO65fnf0Ais82Ls2JJSZ4E65uzet5bfhPFtkoED2OIE98+8
	 PmvPaUnR8RxMnuuqdqphETZqzmro1m2fpdp2qpkyLmFMeMBkKdfKtv+FD3MjRkL9GSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vy68RcyG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75186606A31E;
	Wed, 28 Oct 2026 19:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vy68RcyG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE2A1F01825;
	Wed, 28 Oct 2026 19:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215959;
	bh=Qu2mWCRxnKnV42akDqZHEoeEvkjjQSZSbhN6VTR4R48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vy68RcyGI99I5bCxfOhubkNgiqQmXqnbRxWhfJtQ7sl/NbK9nW1ipEoN8wDK651AB
	 tMjw2RGP2++RQFzWnAoTdj/IisNaRe88nVPHLQ5KVCOSKytYJt+fX50wfdE5S+JI7H
	 Mmu1x7qFE/7k4gz1l55vivLvzCv5zmUsx9bqhR+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1392/1887] svcrdma: Allocate new transports on devices NUMA node
Date: Wed, 28 Oct 2026 17:58:08 +0100
Message-ID: <20261028170531.128881352@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit fe2b401e55482cf90a0056209c8a232b2d39056c ]

The physical device's NUMA node ID is available when allocating an
svc_xprt for an incoming connection. Use that value to ensure the
svc_xprt structure is allocated on the NUMA node closest to the
device.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: e346ef7bcb13 ("svcrdma: Use svc_xprt_put to free listener on create failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 45b0fef0b5e26..9c4cd4caa0c1c 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -64,7 +64,7 @@
 #define RPCDBG_FACILITY	RPCDBG_SVCXPRT
 
 static struct svcxprt_rdma *svc_rdma_create_xprt(struct svc_serv *serv,
-						 struct net *net);
+						 struct net *net, int node);
 static struct svc_xprt *svc_rdma_create(struct svc_serv *serv,
 					struct net *net,
 					struct sockaddr *sa, int salen,
@@ -125,14 +125,14 @@ static void qp_event_handler(struct ib_event *event, void *context)
 }
 
 static struct svcxprt_rdma *svc_rdma_create_xprt(struct svc_serv *serv,
-						 struct net *net)
+						 struct net *net, int node)
 {
-	struct svcxprt_rdma *cma_xprt = kzalloc(sizeof *cma_xprt, GFP_KERNEL);
+	struct svcxprt_rdma *cma_xprt;
 
-	if (!cma_xprt) {
-		dprintk("svcrdma: failed to create new transport\n");
+	cma_xprt = kzalloc_node(sizeof(*cma_xprt), GFP_KERNEL, node);
+	if (!cma_xprt)
 		return NULL;
-	}
+
 	svc_xprt_init(net, &svc_rdma_class, &cma_xprt->sc_xprt, serv);
 	INIT_LIST_HEAD(&cma_xprt->sc_accept_q);
 	INIT_LIST_HEAD(&cma_xprt->sc_rq_dto_q);
@@ -195,9 +195,9 @@ static void handle_connect_req(struct rdma_cm_id *new_cma_id,
 	struct svcxprt_rdma *newxprt;
 	struct sockaddr *sa;
 
-	/* Create a new transport */
 	newxprt = svc_rdma_create_xprt(listen_xprt->sc_xprt.xpt_server,
-				       listen_xprt->sc_xprt.xpt_net);
+				       listen_xprt->sc_xprt.xpt_net,
+				       ibdev_to_node(new_cma_id->device));
 	if (!newxprt)
 		return;
 	newxprt->sc_cm_id = new_cma_id;
@@ -306,7 +306,7 @@ static struct svc_xprt *svc_rdma_create(struct svc_serv *serv,
 
 	if (sa->sa_family != AF_INET && sa->sa_family != AF_INET6)
 		return ERR_PTR(-EAFNOSUPPORT);
-	cma_xprt = svc_rdma_create_xprt(serv, net);
+	cma_xprt = svc_rdma_create_xprt(serv, net, NUMA_NO_NODE);
 	if (!cma_xprt)
 		return ERR_PTR(-ENOMEM);
 	set_bit(XPT_LISTENER, &cma_xprt->sc_xprt.xpt_flags);
-- 
2.53.0



