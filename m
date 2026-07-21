Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74B0471257;
	Tue, 21 Jul 2026 19:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662738; cv=none; b=Y3M0d/BAmzBiPWKKKAhipvceFoWgS4DWB7isfRwrltVUOP62TlNhFkKOmKc0sSW3lBDIPfARM3pZuNzSNuOSZY7KWqUZTzoosVah9Opkov+NsOpaDqlxotlXHdYApP7m2gha/yNGOkFYaQxzkEmgs6v0Cb8r8uzm7GBxfGeoq3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662738; c=relaxed/simple;
	bh=Fc662DVFk59aJaaK02bqs7ENEHiVl0KeaNSPERkg45U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/rdw6dAHHuY74Zb0+O0qUalECYBSX1//KlOvNGR83c/D4l1wNu1szFPF3ouIciAuj/W82UE+oiWldEXQEIutQF0cD8OFjQHVpz2V36b2QrhN+Zltw09gTSizUuuh2rNgUhHD5WZbfaRMHgNm744StgynZLiYFUYtuOpJZiJAM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xUSi39Id; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xUSi39Id"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276201F00A3A;
	Tue, 21 Jul 2026 19:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662737;
	bh=/6W3Iad4m51WacXN3Uvg4aOydhaG2Ia8Cuu2lOuvECA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xUSi39IdbMnq2UH2RD3C+SIXOlUpt/4ZWu/fVh3T5etMOvFn5ReUdWxdBom8lt5DN
	 hslB+i2Oq9AXMi2YITmLPWNmfxDIXHtpdOk9UdYf5iaXsIWkTdSBoDFU5ZHQzDdSyv
	 +XV+2rI6ZtQ78cQB2+RklWcdVk+jFEU8UP+HaxPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0505/1276] xprtrdma: Fix ep kref imbalance on ADDR_CHANGE
Date: Tue, 21 Jul 2026 17:15:48 +0200
Message-ID: <20260721152457.408206876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Chris Mason <clm@meta.com>

[ Upstream commit af9b65b29af341932625c4283dc7a23cdb62688a ]

rpcrdma_cm_event_handler() falls through to the disconnected: label
on RDMA_CM_EVENT_ADDR_CHANGE and calls rpcrdma_ep_put() with no
matching get when the event arrives before RDMA_CM_EVENT_ESTABLISHED.
The kref then underflows during connect teardown and
rpcrdma_xprt_disconnect() operates on a freed ep.

Reference counts across a normal connection lifecycle:

    rpcrdma_ep_create()             kref_init     ->1
    rpcrdma_xprt_connect()          ep_get        ->2  (before post_recvs)
    RDMA_CM_EVENT_ESTABLISHED       ep_get        ->3
    RDMA_CM_EVENT_DISCONNECTED      ep_put        ->2
    rpcrdma_xprt_drain()            ep_put        ->1
    rpcrdma_xprt_disconnect() tail  ep_put        ->0  (ep_destroy)

The connect-time get in rpcrdma_xprt_connect(), taken just before
rpcrdma_post_recvs() "while there are outstanding Receives," is
balanced by rpcrdma_xprt_drain. ADDR_CHANGE before ESTABLISHED has
no get to consume, so its put drops the count to 1 and the drain
put then frees the ep while rpcrdma_xprt_disconnect() still holds a
pointer to it.

Fix by dispatching on the prior re_connect_status via xchg(): for
prev == 0 (pre-ESTABLISHED) wake the connect waiter and return with
no put; for prev == 1 call rpcrdma_force_disconnect() and return.
The case-1 arm relies on the subsequent RDMA_CM_EVENT_DISCONNECTED
event -- reliably delivered when rdma_disconnect() is called on a
still-connected cm_id -- to balance the ESTABLISHED get;
rpcrdma_xprt_drain() continues to balance only that connect-time
get. Any other prior value means teardown is already in flight.

Fixes: 2acc5cae2923 ("xprtrdma: Prevent dereferencing r_xprt->rx_ep after it is freed")
Assisted-by: kres:claude-opus-4-7
Signed-off-by: Chris Mason <clm@meta.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/verbs.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 59fc1aebe8c317..ab7c6178a2b9ba 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -245,8 +245,17 @@ rpcrdma_cm_event_handler(struct rdma_cm_id *id, struct rdma_cm_event *event)
 		complete(&ep->re_done);
 		return 0;
 	case RDMA_CM_EVENT_ADDR_CHANGE:
-		ep->re_connect_status = -ENODEV;
-		goto disconnected;
+		switch (xchg(&ep->re_connect_status, -ENODEV)) {
+		case 0:
+			goto wake_connect_worker;
+		case 1:
+			/* The later DISCONNECTED event balances the
+			 * ESTABLISHED get; do not put here.
+			 */
+			rpcrdma_force_disconnect(ep);
+			return 0;
+		}
+		return 0;
 	case RDMA_CM_EVENT_ESTABLISHED:
 		rpcrdma_ep_get(ep);
 		ep->re_connect_status = 1;
@@ -269,7 +278,6 @@ rpcrdma_cm_event_handler(struct rdma_cm_id *id, struct rdma_cm_event *event)
 		return 0;
 	case RDMA_CM_EVENT_DISCONNECTED:
 		ep->re_connect_status = -ECONNABORTED;
-disconnected:
 		rpcrdma_force_disconnect(ep);
 		return rpcrdma_ep_put(ep);
 	default:
-- 
2.53.0



