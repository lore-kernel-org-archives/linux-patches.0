Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058398;
	b=ACsj/dTLy74C012OpVAg9LqOUlFYhK8CE2zUuSK2UV9D7aWFxpYXiQbfXZZVUPaTAQfp
	 GRk+7/+ip21FfpWyOAZDSt2DInZyjX2vGdFjouiIKPTo2TjkyIDvI8MpEWFnIOaygm82l
	 e0CMdsl65SMSd6ge6iiR9fMLHirYOYgsqQXGoAztNhKsm4v75al2VF0JxA5BDFmd8z3Gl
	 uN6njlazs34KnNPIrMk4xGcalOBeH5V3cp4CKLjMpkJyJX2sYarS3hDx61dT6B5df47op
	 hSzWRdKKyWk/sMO195C7PszOBBDIa5UqvfNBNQq6lwmWpeyWbQ2bkL8AOq7kKrTzIUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058398;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0eUps4pE6+b6fUshbT7iuBAObiMzRDc//8lJ+Xzd99Q=;
	b=RWS0nDdYTHERer+C0JmIY/5Sf+rRB5Tx6HlKFFR4yxYEGJ4+sgtpQaecIPNVah7YAXVX
	 xypst0HXviUbW2JBu6/unvgJBrEvDjqRZL5c9cYQ5NMl+OpQ+a4uXposLW4J52h+o0D3F
	 fhwAEKpQjR85uw3j1J4dxwc0ZFXDjQ3ejLFG+qx/KSeIqSYaixpNcjIDbjwotUOtpQbJc
	 alk+rUy4jo+5/5zynbQi0eFBGlvy6HsAJsxadhKs+VN8UX7Y0R90lE+tAl7TeSmspbmaL
	 FaEH7wGMU0iX5KY2omjSkqFdJuoOcJ1QuFtI4D4JamvjqADsPwY+97sfQ4um1N/rjpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0DVVlo1B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBC0606A325;
	Thu, 19 Nov 2026 03:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0DVVlo1B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0AA1F000C4;
	Thu, 19 Nov 2026 03:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058398;
	bh=0eUps4pE6+b6fUshbT7iuBAObiMzRDc//8lJ+Xzd99Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0DVVlo1BkR0cwAzJaKz0Cub7Ikz3CkECx/O/bqA5WD3e0DsujsE6Sshmxjk41s6s4
	 YEwA23FBA635VZ9ANHljz/ZhPi8dtrWpVTzugHmNbU1UwmgJBdNG+dMPFquKj9QV5A
	 sWfWz4HQSwN2WKeaNQ3w5rIBCvnRTiQSFkvbA7w8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0470/1848] svcrdma: Grant credits from the clamped sc_max_requests
Date: Wed, 18 Nov 2026 15:41:48 +0100
Message-ID: <20261118145934.012871955@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1041ea72b3613..1c8d392c35f8f 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -397,7 +397,6 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	newxprt->sc_max_requests = svcrdma_max_requests;
 	newxprt->sc_max_bc_requests = svcrdma_max_bc_requests;
 	newxprt->sc_recv_batch = RPCRDMA_MAX_RECV_BATCH;
-	newxprt->sc_fc_credits = cpu_to_be32(newxprt->sc_max_requests);
 
 	/* Qualify the transport's resource defaults with the
 	 * capabilities of this particular device.
@@ -418,6 +417,8 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 		newxprt->sc_max_bc_requests = 2;
 	}
 
+	newxprt->sc_fc_credits = cpu_to_be32(newxprt->sc_max_requests);
+
 	/* Estimate the needed number of rdma_rw contexts. The maximum
 	 * Read and Write chunks have one segment each. Each request
 	 * can involve one Read chunk and either a Write chunk or Reply
-- 
2.53.0



