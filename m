Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE5A3B47F5;
	Sat, 17 Oct 2026 17:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259653; cv=none; b=J8XlY8v3d7dU7idgWBFIKjkY7Rlzu18oQ2nCvrflpRGRiQ6pImstimzCjd91febT6b+UFv2bPU5O5XTXqjtzkmgEBfE1nm9+gj2lt/x5jpKf3jp6yFuz9KgyAQIWztL+8MSoK3L4tJ9jagJeVDFmbrONZi3BGcIH6IhIKEEPGiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259653; c=relaxed/simple;
	bh=AYIpG+JpVIdL3/wgth+gtHXG1e5k7d4bPdVGi0AaSSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nUH3l7W3LU1yOH4X8sKhnPN0RoG+q8ptkOteQ85wTd2a+yB9uOM3WuFiB8Qiuemlsx6PeBdyhReWWRbT2lGhBtkYaGrbVGuP3CD/srwJwKNJj5Ak8ollMo0Uv8BQKPMU6t1MLOP89LpE1y451iscG+slCYJ+hb0UYmKhrEAU7QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y3HS3VTu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3HS3VTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69031F000C4;
	Sat, 17 Oct 2026 17:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259652;
	bh=tlBTBGzCgyIj6rWv1ZMbRctdfwdqumCHw+m9yPFmirs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y3HS3VTu765jLustzowJEvHII83YceGF5h81uhFvsOvpfVp6Vx/ZwDeaFOqyX2e+e
	 Glg7uNQsRt09g8vhiU+CrqXHRaBDoOwgBIUKXw4HFuej55Rgxr8alBlI0St1OhRBF7
	 aREfmnsXxh+YXTBYIMnCxPph8FMMciLYaGzFuIdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1286/1674] svcrdma: Handle ADDR_CHANGE CM event properly
Date: Sat, 17 Oct 2026 17:59:18 +0200
Message-ID: <20261017160504.151058212@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d2659446a1111..7135aa57bf50b 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -277,17 +277,31 @@ static void handle_connect_req(struct rdma_cm_id *new_cma_id,
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



