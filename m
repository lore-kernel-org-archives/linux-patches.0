Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215977;
	b=oKFkjNMe2KSAyXBGXYZh7rZXQRktqWoeEzHVH0xtUqki3zHuqXN83KkUqrwfdgSWLaQm
	 xjTTktDV/Kt7A3Zdg+LNm5UKUmnf6MwLjjABQEtH2FIo/SCvBga4BaZELynsR1cf06sQA
	 QCW0BtdbhPiCI7baTb49mnBoLPrIlroNlCTtYz5qfs1XalhLZe2VBcxv9ZG/kzTvy1kZ/
	 gDOMSilpgb3fBHc3giTatZggpMAKGrlrPx8nphJPHr07429jAJqv9TcH4UA4KUYTmjatP
	 BEcp4DyySH9As0B/uu3ivhP+zwXVbJywn0Cilub94cy1p4kQSMUCzlzPyO+eXaM5PNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LokrR7i+pEYfKSWHXRdSAJyab96w5zQjh5GixkJFQzo=;
	b=aXoZ/U44krAcRNKWx35avpY5Mb6rPNe0Jntf4FxwGwNlAVxwvbVCr8xCCBYqqQ2v8vBb
	 Synz6wTrtDB/lT93TU71iXuT1ATFuDcaK0RvxCn2tvIh2FTCKxhMzr2qfENfLMo2jR8tW
	 fdi9srEXQo9wX2GZbF+syHmPWvdjtxX3JAkIEmOS7Kfs7VpcEhmu+dbZxkAFeuFbx3mJK
	 egYi3QtYbixHai7D87rx8ShinLHv08D0KCEcWTkcwhtCajrxSac0Z+tnPrM16pHQDn4Q3
	 Qx9+5MVm7LycjsxXIOV4NJHqTFqnRvK7sMOdvc2a4pMTEO8Za5MqD9N0dPoyfwahw+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RHfZ0u8f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E897B606A31A;
	Wed, 28 Oct 2026 19:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RHfZ0u8f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7FA1F01825;
	Wed, 28 Oct 2026 19:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215976;
	bh=LokrR7i+pEYfKSWHXRdSAJyab96w5zQjh5GixkJFQzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RHfZ0u8fVZBZbOYHeeS9n9Y4i2u7ONJoFlKxozMnZ4MMoDU8SE3K1iZRHDyzCwk6B
	 fnHmkUWjaT0SLRPcgvv5NlbuQkj8oPchVgFZsexlYJaiz9CjJnPUeauOIKmEO9cgXK
	 pnneTjBQ9ZpPLbI2hbC+wBup2J4vAzYUtLzcBIPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1397/1887] svcrdma: Handle ADDR_CHANGE CM event properly
Date: Wed, 28 Oct 2026 17:58:13 +0100
Message-ID: <20261028170531.240625453@linuxfoundation.org>
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

[ Upstream commit d1b586e75ec619dde1af47e21a41a6b1b51874c2 ]

Sagi tells me that when a bonded device reports an address change,
the consumer must destroy its listener IDs and create new ones.

See commit a032e4f6d60d ("nvmet-rdma: fix bonding failover possible
NULL deref").

Suggested-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 0944462247dc ("svcrdma: Reject connection when transport allocation fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index f573b555853c7..ccba5974b5121 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -279,17 +279,31 @@ static void handle_connect_req(struct rdma_cm_id *new_cma_id,
  *
  * Return values:
  *     %0: Do not destroy @cma_id
- *     %1: Destroy @cma_id (never returned here)
+ *     %1: Destroy @cma_id
  *
  * NB: There is never a DEVICE_REMOVAL event for INADDR_ANY listeners.
  */
 static int svc_rdma_listen_handler(struct rdma_cm_id *cma_id,
 				   struct rdma_cm_event *event)
 {
+	struct sockaddr *sap = (struct sockaddr *)&cma_id->route.addr.src_addr;
+	struct svcxprt_rdma *cma_xprt = cma_id->context;
+	struct svc_xprt *cma_rdma = &cma_xprt->sc_xprt;
+	struct rdma_cm_id *listen_id;
+
 	switch (event->event) {
 	case RDMA_CM_EVENT_CONNECT_REQUEST:
 		handle_connect_req(cma_id, &event->param.conn);
 		break;
+	case RDMA_CM_EVENT_ADDR_CHANGE:
+		listen_id = svc_rdma_create_listen_id(cma_rdma->xpt_net,
+						      sap, cma_xprt);
+		if (IS_ERR(listen_id)) {
+			pr_err("Listener dead, address change failed for device %s\n",
+				cma_id->device->name);
+		} else
+			cma_xprt->sc_cm_id = listen_id;
+		return 1;
 	default:
 		break;
 	}
-- 
2.53.0



