Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1163B9D97;
	Tue, 21 Jul 2026 18:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657397; cv=none; b=Nis9HPA9LCj4GiYQPpU0+yekywCayPSCUAZfjOnoNtWTJbyZQDl4aP20yQtP3DdM6i5XIZRmXhkttD2fcuoojCwSjogdY0qDZCAcKyGTkAAv0gEzo4uiRYFku0+ful9D36r4scniIJbI79niqUsd1aY6SyF8OlBmZ1CZdsXKQCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657397; c=relaxed/simple;
	bh=ZAHp1hdaE+vhDG+SwR87eG5v+tlEpV/60yWmD7iY04I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhfWVHtOBvQib8bRa++1xXqY7npo2vQ8kNocvEuCUlL3ZEOC0DGJU21HlW65EAryQiSWpauZ+GVQdOmvNt9sa+BH+M9BRMb4q1bsx9zxhBCOPF/lYiX/qbaqleDG9yE0iub3aI+nvZfuESPe1CW58NR0HTwVfeY3zuKSNXKINP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PCIDRdXb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PCIDRdXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B617C1F00A3D;
	Tue, 21 Jul 2026 18:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657396;
	bh=y2fF7XpoFyXOpRnVj+lRtCYAsADttR0EhesdXOntR/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PCIDRdXbyngRqz9aUS7FKI825jfJo9kQ3cWU+7v2MOWeJpyXnybikfWv7pCGIFEfz
	 czNkGB3Mb/PIGFsuNkDEy4hhSDDZU303ksqTSIErWAEQaL95T52BP5WMNCA5JWjY/W
	 ItS27XfIDZD9agcjbg9cfCm5+Ye6A+Ra4vbc3PLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0696/1611] xprtrdma: Fix ep kref imbalance on ADDR_CHANGE
Date: Tue, 21 Jul 2026 17:13:32 +0200
Message-ID: <20260721152531.036062842@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



