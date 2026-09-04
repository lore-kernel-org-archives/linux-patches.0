Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4B14195A0;
	Fri,  4 Sep 2026 06:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502469; cv=none; b=Km16DgLFCqrRl5CldWaSoFE0aXM85LG1WEiJgjsuFQVC9+sI3Iu6K4IeVwxohAHdTz/bLvwsn2/EfVH/SbUs/xPGOCHVPa/9NT9qHSQsMlepP2R0m/sMRxhyAgs7TjMyIGeCVJYb5jFwV/Q7GzP2eVfYDOc+/vMm/OyQit4Qt/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502469; c=relaxed/simple;
	bh=EoigsQpEqnERCPG+spYVHiNYvqOrXUw4gkSRswHY70I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z3vGraQBnjy1QPIFzrMxJwJZ0gOXCF1b4Gj4Jvv7c3/ai19gpycEKjfPbngsVYFkPShJCSPlwbkl8FpSuVIuldaoWmqODh/ujVi1+V4/5J1Zokj1iKHn27Z2xSAfzz5PNOQ75JUQJYNlrI7n24e7sKseg7g2CaAdjDRncAokIDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bYAGJuVx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYAGJuVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99DD1F00A3D;
	Fri,  4 Sep 2026 06:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502468;
	bh=O2FYRHkC2s69+yRi7/eL5cNJJbkxqbLqNz8v2icZnK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bYAGJuVxCxXvESZhARk1lceEpCOwfbWdIX/PFszoNbvNRdPQS5Q3vA9Oq+kYJJGx/
	 +UHBkIFMyfnY4YCb50u6jLPx4tGhiL5SyWyOgtK6Q/EjPKKkhm9IUwnGtH7gu4HxxL
	 aTRRBZN6EbRLSRB0H2wqA3uSJSxznffjj46p7gHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 217/403] svcrdma: Reject connection when transport allocation fails
Date: Fri,  4 Sep 2026 07:00:20 +0200
Message-ID: <20260904045739.798053733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

commit 0944462247dcb7de7622cdaaadf5f05c52707dab upstream.

handle_connect_req() returns without action when
svc_rdma_create_xprt() fails to allocate the new transport.
The CM core returns 0 for CONNECT_REQUEST events, so it does
not destroy the new rdma_cm_id. Each allocation failure under
memory pressure leaks one rdma_cm_id, and a remote peer driving
connection attempts can amplify this.

Reject the connection by returning a non-zero status from the
CM event handler, which tells the CM core to destroy the
orphaned cm_id.

Fixes: 377f9b2f4529 ("rdma: SVCRDMA Core Transport Services")
Cc: stable@vger.kernel.org
Acked-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260527-rdma-follow-on-v1-4-1b09bd87b6cd@oracle.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -227,12 +227,16 @@ svc_rdma_parse_connect_private(struct sv
  * structure for the listening endpoint.
  *
  * This function creates a new xprt for the new connection and enqueues it on
- * the accept queue for the listent xprt. When the listen thread is kicked, it
+ * the accept queue for the listen xprt. When the listen thread is kicked, it
  * will call the recvfrom method on the listen xprt which will accept the new
  * connection.
+ *
+ * Return values:
+ *     %0: Do not destroy @new_cma_id
+ *     %1: Destroy @new_cma_id (allocation failure)
  */
-static void handle_connect_req(struct rdma_cm_id *new_cma_id,
-			       struct rdma_conn_param *param)
+static int handle_connect_req(struct rdma_cm_id *new_cma_id,
+			      struct rdma_conn_param *param)
 {
 	struct svcxprt_rdma *listen_xprt = new_cma_id->context;
 	struct svcxprt_rdma *newxprt;
@@ -242,7 +246,7 @@ static void handle_connect_req(struct rd
 				       listen_xprt->sc_xprt.xpt_net,
 				       ibdev_to_node(new_cma_id->device));
 	if (!newxprt)
-		return;
+		return 1;
 	newxprt->sc_cm_id = new_cma_id;
 	new_cma_id->context = newxprt;
 	svc_rdma_parse_connect_private(newxprt, param);
@@ -276,6 +280,7 @@ static void handle_connect_req(struct rd
 
 	set_bit(XPT_CONN, &listen_xprt->sc_xprt.xpt_flags);
 	svc_xprt_enqueue(&listen_xprt->sc_xprt);
+	return 0;
 }
 
 /**
@@ -299,8 +304,7 @@ static int svc_rdma_listen_handler(struc
 
 	switch (event->event) {
 	case RDMA_CM_EVENT_CONNECT_REQUEST:
-		handle_connect_req(cma_id, &event->param.conn);
-		break;
+		return handle_connect_req(cma_id, &event->param.conn);
 	case RDMA_CM_EVENT_ADDR_CHANGE:
 		listen_id = svc_rdma_create_listen_id(cma_rdma->xpt_net,
 						      sap, cma_xprt);


