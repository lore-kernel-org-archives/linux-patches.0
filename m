Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045320;
	b=jNqteUzEd79auMjWPbH4aidLg2o7vbLOM47y6PnH5IagXaGS/tD61ImrXH+iqJ4oVaMA
	 fB20q+HYvXNPgUkhy9p4a6Wyhb6EmXCea79JOO7Dq7V3vA6RPQWrDQIHQNtUZL3r+TuTY
	 3mbcsg6uu5xm+Ln22KvvF8tsRAu2FW6dpTSs69w+FQsvynSLNf/K5xLValQ0Eo5uipTbr
	 sM3Oc+P+qfDLwCqgr7lglSoaqAJoSf8Cofaa7m74PQ1KgJx2Jo0WIHuF/INaqyxxdMC5X
	 wqfcKbKvdYFLtzKsaucsTNfAdjEi2Gn4RtLbSPu6g3gAMVBld1++rlM5mxMbZ0ycP3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045320;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IQnXswufRaEDpsx/+2n4TIPpVkVhhOYFGHutGaTJjOw=;
	b=KKunvDXjnfdmdB9om2ByliXNpYC/j4Yka7UPBrZ1SByYsxl3AkFxucSWnzxSxC/zmH/w
	 iWwXPTcWNPRybK9J1r5I5y75x6TFLmrEdewJRkfWjxaiHw/StmbTNsDtz4T6evs37IQt+
	 Fu2gAuQJT02uYEt9LjetMxzHFu4CJAE6DtyVNtIA3h/PD4FiVFH+nrblMaqR5BOEgJPRm
	 2AbnuDX9bGG+Emo2v0RVM1y/XHLhnBYygkhOxj4b3OuMaHoreV+Z6ubK7+Bp5sconjiNw
	 R5FocDkpfrwYnhIhn7TS4ipJTvWht7SpBtZKUjIPG0YWU7FlDJZP7crhvImaIkSV8Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ncoL+PnV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CD0606A320;
	Wed, 18 Nov 2026 23:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ncoL+PnV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E89D1F000C4;
	Wed, 18 Nov 2026 23:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045319;
	bh=IQnXswufRaEDpsx/+2n4TIPpVkVhhOYFGHutGaTJjOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ncoL+PnVfQPOA0zTqD57erB74GN6NovIu5rbI/zAQcyPq1wKvL8aiNCcZ9209FlCl
	 wamkstmmW6bQdxdKjmRD3Vs/3PNS6bQmztSOoFdGi52w5J0XOZ6zSII16nl2ik8crZ
	 YILCx6wjilRa6fx2tTG+xGjnV1Z0WS3Zf4MV6DuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0879/2857] svcrdma: Grant credits from the clamped sc_max_requests
Date: Wed, 18 Nov 2026 15:31:53 +0100
Message-ID: <20261118150233.211107120@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Chuck Lever <cel@kernel.org>

[ Upstream commit b7037e5da3fb81abcd6309daecb112f1d5926760 ]

svc_rdma_accept() computes sc_fc_credits from sc_max_requests before
the Receive Queue depth is checked against the device's max_qp_wr.
When that check lowers sc_max_requests, the credit grant keeps the
original value, so the server advertises more credits than it has
Receives posted. A client that uses the full grant overruns the
Receive Queue, and the connection is lost with an RNR error.

Set sc_fc_credits after the clamp so the grant matches the number
of Receives the server posts.

Fixes: fc2e69db82c1 ("svcrdma: Clean up comment in svc_rdma_accept()")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260828135036.796842-2-cel@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 1da190fa25265..9f5adb82c467f 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -435,7 +435,6 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	newxprt->sc_max_requests = svcrdma_max_requests;
 	newxprt->sc_max_bc_requests = svcrdma_max_bc_requests;
 	newxprt->sc_recv_batch = RPCRDMA_MAX_RECV_BATCH;
-	newxprt->sc_fc_credits = cpu_to_be32(newxprt->sc_max_requests);
 
 	/* Qualify the transport's resource defaults with the
 	 * capabilities of this particular device.
@@ -456,6 +455,8 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 		newxprt->sc_max_bc_requests = 2;
 	}
 
+	newxprt->sc_fc_credits = cpu_to_be32(newxprt->sc_max_requests);
+
 	/* Estimate the needed number of rdma_rw contexts. The maximum
 	 * Read and Write chunks have one segment each. Each request
 	 * can involve one Read chunk and either a Write chunk or Reply
-- 
2.53.0



