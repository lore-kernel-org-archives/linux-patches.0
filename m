Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849843B19BA;
	Sat, 17 Oct 2026 17:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259320; cv=none; b=uN4UyjR4FaAGuvWODfrxyrC8wOGyBzLaHaYQ8QcNrVWqWtOMKkjTFDIkM7rT/xhID2uapLCh4nYO7QVdtkFwip3KdE9g0jGWNm/eOa4jKc/VHREPuRartWiz4/I5wOdN/l0UuF+AXzP2comvcms1JK5Ljw3TMWYjINsc5+JQx8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259320; c=relaxed/simple;
	bh=u9DmcvCZ3mNlk5c0ZBjIZxbIQ1FuvIW6czuwZby6/jY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPvkkdqshcxKs6hZodBEzRz4kSUVrz9PZi+Pv6nhIAUhdmtDuixX5GRRqeoimMrb/Q9NwMJaWPFiBJvEtMpsb0dILiGKC7VtsaUwvJuYnJgAl1tMY3hUuYZt2RqqHVal/tNd85S62CeP5R8kSTWdeNwP48GW+XrInEV7vq9Z0KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vL0SmAPi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vL0SmAPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8325A1F000C4;
	Sat, 17 Oct 2026 17:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259319;
	bh=ZKlfYzajf6u4WDgs2hNBdiLgtSzDJWc2yHX4mpbgHMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vL0SmAPiq50Pg7P8esmkPoO26D9VWmXovQdqyy1uc64W469DkdMp4XjIYolc7T2Wd
	 x0y15MvSSV2iNJo6c0PA+AM1XSuaKeB4gpt3slsFO5VrDhA7bNKmtotG2n7wLnSLI8
	 Gc2Q0CkHBcYs+GzYl0eMPcQnRxRnnfcN7b8r07jA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1147/1674] xprtrdma: Fix ep kref imbalance on ADDR_CHANGE
Date: Sat, 17 Oct 2026 17:56:59 +0200
Message-ID: <20261017160500.594052938@linuxfoundation.org>
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
 net/sunrpc/xprtrdma/verbs.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 34a3c08a82fba..4990e37bcdc00 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -256,8 +256,17 @@ rpcrdma_cm_event_handler(struct rdma_cm_id *id, struct rdma_cm_event *event)
 		}
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
-- 
2.53.0



