Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6FB35AC20
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302740; cv=none; b=sal7/uQSlilKyCnj39yOdqQevZtiu/P5hAl+0+t608tKzxYDiQJNsSDNHBHB98jSS0lywGC5DYAFDdv9t0cOWo9W/MRkFMi9fvZehUc98DHlxjouywM4IYHcDGqT1xlTloQcbBpOTzBeLDOgiprcgc4EYxA/ISMwlEMjSE5TIAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302740; c=relaxed/simple;
	bh=SPy0H1ceFw0AYl9Q051NigV7Mdsefs/wyD0G8keMsEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/RzZaoITNopcVgaZk2yJYxY6PY5dyFuE23kW8fGhIb7QoMaFrvsdfAaP6Kp/kAjJD1kHNY7gjflhdJOOAJqPJilly9Rfy1ScG1AP39yn1AfDLkoogmnJZ4OjutXLr1tj5ejKyZrcFwCeAhULjfgasmgppfpVxHazhGZ2NYVEl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T7lXQzli; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T7lXQzli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557FAC116D0;
	Sat, 28 Feb 2026 18:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302740;
	bh=SPy0H1ceFw0AYl9Q051NigV7Mdsefs/wyD0G8keMsEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7lXQzliR23A5yA5TslUsEqIju7VBtGRN5Wu2KlcXRTAgFopfrf4BDk8eQQkbhO3y
	 6jmg4k4QgAdOV9LZbGUBIYPCrefnu4Wzc6vrGkRoXDMACxfCtsMU+hMOasQSwJGCfM
	 2JGHAx2TYz3ZRJuhFy4zgnGmcreXhTRdrBULphm/8fAx5mpwvXSn3qBYasiclHs/ao
	 hgEpkZjA4Gxr+m0XYB9oReMXrLVDggaUmsLk1lLLmpvyco85T0MrrRdFQEXU4X1fb9
	 i0Wbi08s5ng36Blp+dtWYRHuMGg6kuXfQX+P4Ve0OIKpLinWueGhMrKQlePcMtdmjQ
	 4AEAQO4qLBeRg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/147] svcrdma: Increase the per-transport rw_ctx count
Date: Sat, 28 Feb 2026 13:16:54 -0500
Message-ID: <20260228181736.1605592-106-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 2da0f610e733606e06284ac3c1f188b9dec75d68 ]

rdma_rw_mr_factor() returns the smallest number of MRs needed to
move a particular number of pages. svcrdma currently asks for the
number of MRs needed to move RPCSVC_MAXPAGES (a little over one
megabyte), as that is the number of pages in the largest r/wsize
the server supports.

This call assumes that the client's NIC can bundle a full one
megabyte payload in a single rdma_segment. In fact, most NICs cannot
handle a full megabyte with a single rkey / rdma_segment. Clients
will typically split even a single Read chunk into many segments.

The server needs one MR to read each rdma_segment in a Read chunk,
and thus each one needs an rw_ctx.

svcrdma has been vastly underestimating the number of rw_ctxs needed
to handle 64 RPC requests with large Read chunks using small
rdma_segments.

Unfortunately there doesn't seem to be a good way to estimate this
number without knowing the client NIC's capabilities. Even then,
the client RPC/RDMA implementation is still free to split a chunk
into smaller segments (for example, it might be using physical
registration, which needs an rdma_segment per page).

The best we can do for now is choose a number that will guarantee
forward progress in the worst case (one page per segment).

At some later point, we could add some mechanisms to make this
much less of a problem:
- Add a core API to add more rw_ctxs to an already-established QP
- svcrdma could treat rw_ctx exhaustion as a temporary error and
  try again
- Limit the number of Reads in flight

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: afcae7d7b8a2 ("RDMA/core: add rdma_rw_max_sge() helper for SQ sizing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 429ed159e9251..9f66b57125042 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -417,8 +417,13 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 		newxprt->sc_max_requests = rq_depth - 2;
 		newxprt->sc_max_bc_requests = 2;
 	}
-	ctxts = rdma_rw_mr_factor(dev, newxprt->sc_port_num, RPCSVC_MAXPAGES);
-	ctxts *= newxprt->sc_max_requests;
+
+	/* Arbitrarily estimate the number of rw_ctxs needed for
+	 * this transport. This is enough rw_ctxs to make forward
+	 * progress even if the client is using one rkey per page
+	 * in each Read chunk.
+	 */
+	ctxts = 3 * RPCSVC_MAXPAGES;
 	newxprt->sc_sq_depth = rq_depth + ctxts;
 	if (newxprt->sc_sq_depth > dev->attrs.max_qp_wr)
 		newxprt->sc_sq_depth = dev->attrs.max_qp_wr;
-- 
2.51.0

