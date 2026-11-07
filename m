Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062256;
	b=MnXAb7+fB08ZekAlZ2zjlsITw+t+KQ55THkJqXlDRpBY7/NAoAYw5meRDb3HpP+9QPGC
	 ngNjVx/FxR/462hb3xL072REyXsEsJPXa+CsYJ/NFbDN7+5F1/iKAEcKByq2SPtKZJ2Sa
	 R29ty/H3oFMJvzi3MGKa+iHWlijQ+WBak37OhPIxniNfFgnCYs5bcEuwjx/jq6zBOvXcq
	 pvmjrDbXGUWajfpIQUkniRxkKn8SA/8eR4BZoJtWpYFEAIqDxAqEjhEzgHENKD9aT61eG
	 NL+u+DM/pmpbjmAcbadt8XZiA133QxTcXTWgirbD6ZD4tAfbGMR2dXw9pWCkOdIXD2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3/Yc13taLKLj6bz3X6rEcNK/91hEcwcxmbA36pbb/zs=;
	b=HCPgCmTpb2CSr7QXlmTsS1JoeJEYWpbij8Mh8jPzpxo968Rkhb1j3Od7Un/ho+faA9sU
	 VuV6KspMhVpLvyU4jrCLRgozJVTLIWLplPhZsSVInuj8NG3NfhExvJEhaZ0gCVbTsh/gN
	 9PnZBw47T/GrytDBsVWN1zNdb3EX62e86bkUSbx6grEsgby8cdh6F4IEAJt/Qri4xTSSh
	 t2jBLUWtfcruDTRAVMn13ctB5FSMgTDI2Ysux5OQe0gt6/Zl7Y9vss2aruicVB4iylWUh
	 KY8FUchozgNhw+F2/TiXJIKCcZQukYLuYoEKBbqG6zvaTwPvTxikPUei+UVZ3eC5YPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NOHpZyrL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD37A606EE82;
	Sat,  7 Nov 2026 14:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NOHpZyrL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DA41F008A2;
	Sat,  7 Nov 2026 14:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062255;
	bh=3/Yc13taLKLj6bz3X6rEcNK/91hEcwcxmbA36pbb/zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NOHpZyrLx2Rs+Jnn3vskEj/giiW63SgZdUgYzPhOOke6KJj4NmaVdRqIQbAm3VpwO
	 flWISV0OpBT7tI7j3MklAzOvQi6ejOYDed4DHqRQFkfVm4gqF8QxUeIqUfaGK7RMp+
	 Cflg0h0WHFOlgebQVJT8Q1yXm+LWswxk3d0u818k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1160/1536] svcrdma: Grant credits from the clamped sc_max_requests
Date: Sat,  7 Nov 2026 08:52:56 -0500
Message-ID: <20261107135030.307562105@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b6044a1911ee9..65a9df7a4a7b7 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -467,7 +467,6 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	newxprt->sc_max_requests = svcrdma_max_requests;
 	newxprt->sc_max_bc_requests = svcrdma_max_bc_requests;
 	newxprt->sc_recv_batch = RPCRDMA_MAX_RECV_BATCH;
-	newxprt->sc_fc_credits = cpu_to_be32(newxprt->sc_max_requests);
 
 	/* Qualify the transport's resource defaults with the
 	 * capabilities of this particular device.
@@ -488,6 +487,8 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 		newxprt->sc_max_bc_requests = 2;
 	}
 
+	newxprt->sc_fc_credits = cpu_to_be32(newxprt->sc_max_requests);
+
 	/* Estimate the needed number of rdma_rw contexts. The maximum
 	 * Read and Write chunks have one segment each. Each request
 	 * can involve one Read chunk and either a Write chunk or Reply
-- 
2.53.0



