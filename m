Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036458;
	b=XvZd9c3aHSYSKUt02axsmk+LO38DFN2s5ND+FMFP8K52tnd5NoE9hFXFr4nw5Iqg/yA6
	 sCPVqh/QIwCXvhduqGQj+MvRY+xWBadmpbB1Zu5ta5rVr8eCSNvb4x+rmRpgsvvemu2Q8
	 aTR5qylBLiVIOsrPN31LxDcEe1CloR0Bd2qx27xbyQkLwdMpI6R20Mk0E+nk/N3eGKChq
	 gjia2sNsVHUFQpOQEgMikxm8XvwRj7CjTes61xe/p0wCCpgYAOFXYP97apPMghaTtudOY
	 AiUFdFPPzkJNX+sO5dqrfBBCFO+4claHZSUDBzjBpF9vrbuDoAGZ3774Mb9zfRO4oZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WUPk7JWTbnNxE3ChkJ1HCxMue+REdOPNkGrILcS39CQ=;
	b=e0xohEDKYfQdtYRgbxkjqb2LHLwQnYV+eR4w2ipzkKYMf0ksMOdXxOT8ZmGcGVFDKKKC
	 BQ5yK/Ndcs1PWM04LLXVefJveTs1RX+HGFhLKEZiqICy/hgew/HJuftBZ+mfNfnITiwet
	 wIhDJMhSfGTt5e3gZH3PXPEeRhHeh6GwHljqQcre/tDgf5MksPodAbkbET2wQ/FEaL1Bs
	 Nmc21IBmal+aig1zkqSVTjDvonkIvEPp5Nez/HomXbO9FtHcA1rng05f52ZQvAC1aC8Rc
	 1xrPEOKqZkbhRoxqaryeE0/ZXogd1Bm4deDOSwyAlcymqTdOr/sJPbJwfs1h6qxyC0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UhjPnFbT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAA560A2603;
	Wed, 18 Nov 2026 21:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UhjPnFbT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33BF1F000C4;
	Wed, 18 Nov 2026 21:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036458;
	bh=WUPk7JWTbnNxE3ChkJ1HCxMue+REdOPNkGrILcS39CQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UhjPnFbTEz6TzMCMvIVkvs5A5T9oCBFydryPVHLPAlaooLlXHmfdBx6jdZMFFiR2h
	 omqiTY5O/ylHjoAO7tezK3JuhpKFwQfekjyQqHt2B8iLItY19J6Get92ByWhxPEZli
	 ychm1rADMFOdADAXwKgwk+a25hERQ1PEUkvJS24A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1013/3318] svcrdma: Grant credits from the clamped sc_max_requests
Date: Wed, 18 Nov 2026 15:27:15 +0100
Message-ID: <20261118150350.274402671@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2ff5451481dae..66dd5d859b51b 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -433,7 +433,6 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	newxprt->sc_max_requests = svcrdma_max_requests;
 	newxprt->sc_max_bc_requests = svcrdma_max_bc_requests;
 	newxprt->sc_recv_batch = RPCRDMA_MAX_RECV_BATCH;
-	newxprt->sc_fc_credits = cpu_to_be32(newxprt->sc_max_requests);
 
 	/* Qualify the transport's resource defaults with the
 	 * capabilities of this particular device.
@@ -454,6 +453,8 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 		newxprt->sc_max_bc_requests = 2;
 	}
 
+	newxprt->sc_fc_credits = cpu_to_be32(newxprt->sc_max_requests);
+
 	/* Estimate the needed number of rdma_rw contexts. The maximum
 	 * Read and Write chunks have one segment each. Each request
 	 * can involve one Read chunk and either a Write chunk or Reply
-- 
2.53.0



