Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063137;
	b=GBA728RZJkuvxsuISyvO1Wf/88NMXxuA0nVe/AzeXhg88SWlNe68vCmxbvi56vWBwAcp
	 9Su1v2tFezPLRL/oMzAqxTqBD/evY0feYFHh+VXmhRGGg3hKwAhrlptAv/Mz9q/Ob2bxB
	 BMXJlpQq2A6LYhog+jsV7/2zvnjwqvHM+jp69Lg54HihaO7DpgOBoshGjpbE6Kku9JgPe
	 X8KVOt0N4oqjIdG3mBlcib7s2oWl3acWnMbTzezM5SalqAsPfhNIXeBgikNJqAEv1Gj/S
	 xsvIcLGv4t0SugGZJ22vjIScf6EiHuWNa+EvGCVLdeZZvkMEK+JMEJqQNSnGddTZZTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063137;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pc9IRZ54AUeKErUXvyrvvVsxNeINTUz+TKZPyrQ1Bn8=;
	b=rE/kiLuWR5UVsIaoyaOslNgRiVwrSTVS+o9UsCG9NA3fY6gsxjL5aJPS1F8pKKnfomkU
	 WkfnFOHver/+huY0FIz9MBum9d9Of7axdOWAk0CtzpQ/e9z1DH8gb3AZ0bJiUaThcL1Tv
	 QEm/UkS8EqNbyXNzsoCuSLtDztg7KvEAvf5O9pATn6E2zRtYue/dyCp0HykUkdWGc7bUx
	 nUKEZMm3Gr6rrqDgY0rP1mupSBe3/jJgUvo+5S8QzUm56E9D/Yxk6vZdSCtln2qMqXHv9
	 wuFhfPc2Ip4pwe475DIvW6xR4l3sqK+pRbrOel9dcSdzRgL2KMMHIQadb3o9G18E1qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SO3B5Gdv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9E9606D814;
	Sat,  7 Nov 2026 14:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SO3B5Gdv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7EE1F008A1;
	Sat,  7 Nov 2026 14:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063137;
	bh=pc9IRZ54AUeKErUXvyrvvVsxNeINTUz+TKZPyrQ1Bn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SO3B5Gdv/+3LGwEMkE/J/zWEwlp+bSEQs2OgoADjVBzpZnf7HSEdkOvA5IOVrPeZo
	 NT+VbYxxZC1A4XUZUxquOzPDRnzL0nIck5319yuDqX7SsJLFnuAd5soprEYazjUxXC
	 sCRF9vEzU945VTDaIqcf15JMmtwu5HC1wt8BFHME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 366/869] svcrdma: Grant credits from the clamped sc_max_requests
Date: Sat,  7 Nov 2026 08:50:48 -0500
Message-ID: <20261107134905.122634092@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4afa662430cae..d9bc86fa09bce 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -469,7 +469,6 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	newxprt->sc_max_requests = svcrdma_max_requests;
 	newxprt->sc_max_bc_requests = svcrdma_max_bc_requests;
 	newxprt->sc_recv_batch = RPCRDMA_MAX_RECV_BATCH;
-	newxprt->sc_fc_credits = cpu_to_be32(newxprt->sc_max_requests);
 
 	/* Qualify the transport's resource defaults with the
 	 * capabilities of this particular device.
@@ -490,6 +489,8 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 		newxprt->sc_max_bc_requests = 2;
 	}
 
+	newxprt->sc_fc_credits = cpu_to_be32(newxprt->sc_max_requests);
+
 	/* Estimate the needed number of rdma_rw contexts. The maximum
 	 * Read and Write chunks have one segment each. Each request
 	 * can involve one Read chunk and either a Write chunk or Reply
-- 
2.53.0



