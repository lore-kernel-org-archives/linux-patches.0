Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA22D149010;
	Tue, 23 Jan 2024 00:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969193; cv=none; b=OFeynKUKEud/hDyP6xCKsM0YtHwrFlFQFhXE8mbNUyxXR24VWymF270pX3SD1QPFEFIBbuZsqc6AM2WE/dPC0fiCFrZvro/UD0XD1rShGcCc3IrXGBPmzJhs3CoLAel9SXf4cu6Np3XIePx+D2nMJsMb91Qnt0+e9vR0T61FMhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969193; c=relaxed/simple;
	bh=oxavIbJ56XWIefPXriU/r8aezpu78Yke1qufFm+YRC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPZSZXq5Ik9AEeChJSU+l4BIQM93gFWnLozgsZzjRU2jCXa5VzPw76ZY0w9Oi6xvaAdZd4GKrCf68mne/bnrrzvlJ0g+F5Zw52LuGgXtRWxuiH04lq6h8ftQqhiHxTD7vA+TYeTFsG4kBWa9w5bPGjHXAwYX7BpnE8eLHK4hteo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGNNKVQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGNNKVQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C99C433C7;
	Tue, 23 Jan 2024 00:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969193;
	bh=oxavIbJ56XWIefPXriU/r8aezpu78Yke1qufFm+YRC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGNNKVQizngOtRXrPzH5Gu2l7ZebgOacztkSAHgXZ8C34Mm8ZNQpHKcvf3shSG3mR
	 RDuC5vFsjUyENsFlD0uOXTH81o2v8yRHfFgthj/A2+Z+WxJDaIucIqtssuV9vsadk4
	 eDRiP3+oweYDIuSvj91LIxc+W+cqxqLzvUZAyhSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 090/641] SUNRPC: Fixup v4.1 backchannel request timeouts
Date: Mon, 22 Jan 2024 15:49:54 -0800
Message-ID: <20240122235820.854661999@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit e6f533b615971afcaa1141573a1a1714d9d4f31a ]

After commit 59464b262ff5 ("SUNRPC: SOFTCONN tasks should time out when on
the sending list"), any 4.1 backchannel tasks placed on the sending queue
would immediately return with -ETIMEDOUT since their req timers are zero.

Initialize the backchannel's rpc_rqst timeout parameters from the xprt's
default timeout settings.

Fixes: 59464b262ff5 ("SUNRPC: SOFTCONN tasks should time out when on the sending list")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Tested-by: Chuck Lever <chuck.lever@oracle.com>
Tested-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprt.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 2364c485540c..6cc9ffac962d 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -651,9 +651,9 @@ static unsigned long xprt_abs_ktime_to_jiffies(ktime_t abstime)
 		jiffies + nsecs_to_jiffies(-delta);
 }
 
-static unsigned long xprt_calc_majortimeo(struct rpc_rqst *req)
+static unsigned long xprt_calc_majortimeo(struct rpc_rqst *req,
+		const struct rpc_timeout *to)
 {
-	const struct rpc_timeout *to = req->rq_task->tk_client->cl_timeout;
 	unsigned long majortimeo = req->rq_timeout;
 
 	if (to->to_exponential)
@@ -665,9 +665,10 @@ static unsigned long xprt_calc_majortimeo(struct rpc_rqst *req)
 	return majortimeo;
 }
 
-static void xprt_reset_majortimeo(struct rpc_rqst *req)
+static void xprt_reset_majortimeo(struct rpc_rqst *req,
+		const struct rpc_timeout *to)
 {
-	req->rq_majortimeo += xprt_calc_majortimeo(req);
+	req->rq_majortimeo += xprt_calc_majortimeo(req, to);
 }
 
 static void xprt_reset_minortimeo(struct rpc_rqst *req)
@@ -675,7 +676,8 @@ static void xprt_reset_minortimeo(struct rpc_rqst *req)
 	req->rq_minortimeo += req->rq_timeout;
 }
 
-static void xprt_init_majortimeo(struct rpc_task *task, struct rpc_rqst *req)
+static void xprt_init_majortimeo(struct rpc_task *task, struct rpc_rqst *req,
+		const struct rpc_timeout *to)
 {
 	unsigned long time_init;
 	struct rpc_xprt *xprt = req->rq_xprt;
@@ -684,8 +686,9 @@ static void xprt_init_majortimeo(struct rpc_task *task, struct rpc_rqst *req)
 		time_init = jiffies;
 	else
 		time_init = xprt_abs_ktime_to_jiffies(task->tk_start);
-	req->rq_timeout = task->tk_client->cl_timeout->to_initval;
-	req->rq_majortimeo = time_init + xprt_calc_majortimeo(req);
+
+	req->rq_timeout = to->to_initval;
+	req->rq_majortimeo = time_init + xprt_calc_majortimeo(req, to);
 	req->rq_minortimeo = time_init + req->rq_timeout;
 }
 
@@ -713,7 +716,7 @@ int xprt_adjust_timeout(struct rpc_rqst *req)
 	} else {
 		req->rq_timeout = to->to_initval;
 		req->rq_retries = 0;
-		xprt_reset_majortimeo(req);
+		xprt_reset_majortimeo(req, to);
 		/* Reset the RTT counters == "slow start" */
 		spin_lock(&xprt->transport_lock);
 		rpc_init_rtt(req->rq_task->tk_client->cl_rtt, to->to_initval);
@@ -1886,7 +1889,7 @@ xprt_request_init(struct rpc_task *task)
 	req->rq_snd_buf.bvec = NULL;
 	req->rq_rcv_buf.bvec = NULL;
 	req->rq_release_snd_buf = NULL;
-	xprt_init_majortimeo(task, req);
+	xprt_init_majortimeo(task, req, task->tk_client->cl_timeout);
 
 	trace_xprt_reserve(req);
 }
@@ -1996,6 +1999,8 @@ xprt_init_bc_request(struct rpc_rqst *req, struct rpc_task *task)
 	 */
 	xbufp->len = xbufp->head[0].iov_len + xbufp->page_len +
 		xbufp->tail[0].iov_len;
+
+	xprt_init_majortimeo(task, req, req->rq_xprt->timeout);
 }
 #endif
 
-- 
2.43.0



