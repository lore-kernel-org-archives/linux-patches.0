Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502A31BC08A;
	Tue,  2 Jul 2024 17:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940344; cv=none; b=go2JHMJbEZlSmCWaQGs9gbZNAN9yqI5shsDMoGQp1OKvjxMltV/6m8XReIzU3ZfVZeU0PamvyBLkAuqdXZyvMd6fE9jc1QcEXN6l0nMxUt8XF/+MBdjQERswMIyLlKTlZ09RaK0GPpaWh6CsAJG1lGgFHszkIQ2TXwF6I00QIr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940344; c=relaxed/simple;
	bh=FOVpnDjkpa5TdaBXAg63xC9zuQFDw7/TMVWeiMDRSUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPKCnt0lrQFXbwK8fI/w5kIX6jv1g2NTxn+zQESAI3M/zTlCSb7rht6zLNKm/dFdzbPpjZEdciTPR3Mm1p1Xbb/lWhXzpfZilsdMY8N3g506c5quAz68S7MJzhiWt70+JkBLnCaBICLJT2VcuBVnx1VgplY3x2UNf4M1a6MSv/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kdqUhqbF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kdqUhqbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1E4C116B1;
	Tue,  2 Jul 2024 17:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940343;
	bh=FOVpnDjkpa5TdaBXAg63xC9zuQFDw7/TMVWeiMDRSUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kdqUhqbFH7nu9QMgVtVrjGt+zkJVbC1ISNQFYFAOMBHeTEibD4Go1f5ILgL5LFLjG
	 LzQmAr5oYtz5cXcwz2mfThAPVpiwMY3fygyN0VkbQ3OC3tdoxD04BbkD0O/hbE5UVT
	 x2Hif2qENTKqAzhBxaJ9517SMq2AtuppxNyT/l80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 127/222] SUNRPC: Fix backchannel reply, again
Date: Tue,  2 Jul 2024 19:02:45 +0200
Message-ID: <20240702170248.823706034@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 6ddc9deacc1312762c2edd9de00ce76b00f69f7c ]

I still see "RPC: Could not send backchannel reply error: -110"
quite often, along with slow-running tests. Debugging shows that the
backchannel is still stumbling when it has to queue a callback reply
on a busy transport.

Note that every one of these timeouts causes a connection loss by
virtue of the xprt_conditional_disconnect() call in that arm of
call_cb_transmit_status().

I found that setting to_maxval is necessary to get the RPC timeout
logic to behave whenever to_exponential is not set.

Fixes: 57331a59ac0d ("NFSv4.1: Use the nfs_client's rpc timeouts for backchannel")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 2b4b1276d4e86..d9cda1e53a017 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1557,9 +1557,11 @@ void svc_process(struct svc_rqst *rqstp)
  */
 void svc_process_bc(struct rpc_rqst *req, struct svc_rqst *rqstp)
 {
+	struct rpc_timeout timeout = {
+		.to_increment		= 0,
+	};
 	struct rpc_task *task;
 	int proc_error;
-	struct rpc_timeout timeout;
 
 	/* Build the svc_rqst used by the common processing routine */
 	rqstp->rq_xid = req->rq_xid;
@@ -1612,6 +1614,7 @@ void svc_process_bc(struct rpc_rqst *req, struct svc_rqst *rqstp)
 		timeout.to_initval = req->rq_xprt->timeout->to_initval;
 		timeout.to_retries = req->rq_xprt->timeout->to_retries;
 	}
+	timeout.to_maxval = timeout.to_initval;
 	memcpy(&req->rq_snd_buf, &rqstp->rq_res, sizeof(req->rq_snd_buf));
 	task = rpc_run_bc_task(req, &timeout);
 
-- 
2.43.0



