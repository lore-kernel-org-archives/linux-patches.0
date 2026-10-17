Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF9F377A92;
	Sat, 17 Oct 2026 16:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254931; cv=none; b=Ugj+mAj0PLmeOjgW/sqUz4xZ6tXUskarqOIxVbI2Q3mX6WTv9qr0KZJzzEIYkdFor3Z102xGY0NaQeIooSUCbQhhtJOOf9tFSXYwEqZOsLLC5wg14Bd4KE1Qrpex9lNhTxw0Kh2s7aQqymOa/KsuKgUa1Z6F8TSn/VuCSk8xe6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254931; c=relaxed/simple;
	bh=IxWQh/W7h7MqhtUpTzzev2sFHqPxBckMAXsBfPL2SfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EwWOnzYY9Qy/t9RS/A7YbBC+BmShh4eFGIcQ858mkSSnjFeeb1EoR6Au/N+wdMeu2NqltjIJ6amJ25NEhftsi8aLTrJxUaspjMOpLE3nnsilO2LpcdW88i/pLaPqE22eBazVKeoNygEQCP+Qb7f8DwScyC6OXF77hAzjOXnSXCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NcM5oUHD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NcM5oUHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76901F000C4;
	Sat, 17 Oct 2026 16:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254930;
	bh=Zw0v75tclBYx6TQNRbskoUzfUrGlThFrR34L4blV5lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NcM5oUHDjrGaDeXe0j2t6p0fXji3sscsMjxJ2BR4/v0/HYvWfkTUFe84ua7kFVxaX
	 19uRmTFxVqXJsRVf6cz0x1XbizNkaCKJILykBIGbq93d6PtariSUgMPzhT/HbhefoH
	 CMW43NwsffOABVp/+dkOcK8Oy7fJEL7svSVIovvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 566/869] svcrdma: Clear sc_cm_id when ADDR_CHANGE replacement fails
Date: Sat, 17 Oct 2026 17:56:47 +0200
Message-ID: <20261017160051.584442585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

[ Upstream commit 01500306e1d50de7ca7a2cdcdfa28ac0523eb747 ]

When svc_rdma_listen_handler() handles RDMA_CM_EVENT_ADDR_CHANGE,
it creates a replacement listener cm_id and returns 1, telling
the CM core to destroy the old one. If the replacement allocation
fails, sc_cm_id still points at the old cm_id that the CM core is
about to destroy. Any subsequent dereference of sc_cm_id --
such as svc_rdma_detach()'s rdma_disconnect() call -- is a
use-after-free.

NULL sc_cm_id on the failure path and guard svc_rdma_detach()'s
rdma_disconnect() call against NULL so that the listener can
be torn down safely when the server shuts down.

Fixes: d1b586e75ec6 ("svcrdma: Handle ADDR_CHANGE CM event properly")
Cc: stable@vger.kernel.org
Acked-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260527-rdma-follow-on-v1-5-1b09bd87b6cd@oracle.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 767af51a782ed..b6044a1911ee9 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -325,6 +325,7 @@ static int svc_rdma_listen_handler(struct rdma_cm_id *cma_id,
 		if (IS_ERR(listen_id)) {
 			pr_err("Listener dead, address change failed for device %s\n",
 				cma_id->device->name);
+			cma_xprt->sc_cm_id = NULL;
 		} else
 			cma_xprt->sc_cm_id = listen_id;
 		return 1;
@@ -630,7 +631,8 @@ static void svc_rdma_detach(struct svc_xprt *xprt)
 	struct svcxprt_rdma *rdma =
 		container_of(xprt, struct svcxprt_rdma, sc_xprt);
 
-	rdma_disconnect(rdma->sc_cm_id);
+	if (rdma->sc_cm_id)
+		rdma_disconnect(rdma->sc_cm_id);
 
 	/*
 	 * Most close paths go through svc_rdma_xprt_deferred_close(),
-- 
2.53.0



