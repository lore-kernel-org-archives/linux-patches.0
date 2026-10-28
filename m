Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215980;
	b=H6QJADL88CHU8L+aH1nxmv22UcIfcG9CgaMP/P6Jmch+zjPwNV9TRSsD07UI39cpTXxL
	 7dSSc/IiEAGXo87L9KZFxpem3A0jJZgmIstqJgu0NMUgYG6hecCx4JhHW069pt/Bl7QJg
	 JkTpSc4ph2p/ZcziI7uR8a91VSKtpQRq4mixDQjIxODeAJv9vZWJZlEVR4jllFgGfesZp
	 Xsmp9cwI48/ZySR4vi/00owAjchIJLMxshnUUK8TXLc/3QSEs6qKJvE1kE7klNDKf7Z9X
	 YW4TLHfuQGOU+pBirdwpEA+QS1MK8fBtmogoJJIg3erBb8r03+TPdTACxzOVcdFYL8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gUSDQLIp0b8Yc+ZjK5vL7/m3eXnFKDJKxkjwpANr9Ms=;
	b=Dklvn+cedof+Nw/OsjCnoItjSRiYtOnNNPGEeJWVxcVol2xMQlZ3nF9rPbGpdSuEYyyw
	 pH4p34P+iMQDLgIVGcUz7Jvd7dFd608h/E3Cvv7gCEYBnHEaYdfPaK6aADFIWEwrBuAAf
	 EsEfgz+ousWJhmKpBWObJbu7dN3Gtxad9J/Lm1eoikGU8B06Cl78KxO4x2o5iNeqBdNcl
	 wXd7qOcOQagdQ8YSRvHogNxdEVXHPIcVeLH6kAxlHs7NmmKhD7yGyIzhzdv0x5IO2aa17
	 Skol8kzqy7biPJJgioINUwUN2PaRT00f9BfdjXYhMZHJxuAAoS9YyUbnj5WbIuV7GNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2DCeXSBQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13E1606A327;
	Wed, 28 Oct 2026 19:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2DCeXSBQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA341F01829;
	Wed, 28 Oct 2026 19:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215979;
	bh=gUSDQLIp0b8Yc+ZjK5vL7/m3eXnFKDJKxkjwpANr9Ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2DCeXSBQZ0fCsZRQN4MwP+6i4a0cp8K32ELWxG45JAW79/NqE5DpH5jbJKGSjXkWz
	 LfKoOyMLTSQ215WSty8xnbP2FDOCOZa9ZHPIEyCgwS5A6E0D6rjVrzUXZ5pMHzH6k3
	 JDIWvajoOq5V53YDpEBcArkfNiAi+2d5aoltOqt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1398/1887] svcrdma: Reject connection when transport allocation fails
Date: Wed, 28 Oct 2026 17:58:14 +0100
Message-ID: <20261028170531.263470982@linuxfoundation.org>
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

[ Upstream commit 0944462247dcb7de7622cdaaadf5f05c52707dab ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index ccba5974b5121..c84e80ae374ea 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -221,12 +221,16 @@ svc_rdma_parse_connect_private(struct svcxprt_rdma *newxprt,
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
@@ -236,7 +240,7 @@ static void handle_connect_req(struct rdma_cm_id *new_cma_id,
 				       listen_xprt->sc_xprt.xpt_net,
 				       ibdev_to_node(new_cma_id->device));
 	if (!newxprt)
-		return;
+		return 1;
 	newxprt->sc_cm_id = new_cma_id;
 	new_cma_id->context = newxprt;
 	svc_rdma_parse_connect_private(newxprt, param);
@@ -270,6 +274,7 @@ static void handle_connect_req(struct rdma_cm_id *new_cma_id,
 
 	set_bit(XPT_CONN, &listen_xprt->sc_xprt.xpt_flags);
 	svc_xprt_enqueue(&listen_xprt->sc_xprt);
+	return 0;
 }
 
 /**
@@ -293,8 +298,7 @@ static int svc_rdma_listen_handler(struct rdma_cm_id *cma_id,
 
 	switch (event->event) {
 	case RDMA_CM_EVENT_CONNECT_REQUEST:
-		handle_connect_req(cma_id, &event->param.conn);
-		break;
+		return handle_connect_req(cma_id, &event->param.conn);
 	case RDMA_CM_EVENT_ADDR_CHANGE:
 		listen_id = svc_rdma_create_listen_id(cma_rdma->xpt_net,
 						      sap, cma_xprt);
-- 
2.53.0



