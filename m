Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C644B38D017
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302192; cv=none; b=mRWG9m0gd6/N7FVIzZfGKu59arrAdrHnBw4FjkNlQ3qC4kvupK9wYkGGPPmJydhhqTTDrQVtV1XyX2fiKQqioyjpbBKkdODsXhFPFiuA9nHnsXHSDauLzX5D3af4aVCO9HzUGQi3kaHLuVErOURlMrIsTQHQnUeRkIbV+viHYIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302192; c=relaxed/simple;
	bh=lVV3ZKuMsSFYufrrr5+nZ/uyk0YeGGF9TdfcVXlFgQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DABAxqIa82J/3ghEvsvqg1JkiiN2fQbGzjK0/8gZSP7NYf72PNc1aErUBXfS8YaBKnpI8zC94HIsDimLp6oMiuYLF89JL2M6KU24zwQgyf7uBenA1GSzbbVMosreeemhqJ/RtlljX0UBgVCGa6UxvgFEBmwP6GfuYKGyOHUzV3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oePORSh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oePORSh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40962C19423;
	Sat, 28 Feb 2026 18:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302192;
	bh=lVV3ZKuMsSFYufrrr5+nZ/uyk0YeGGF9TdfcVXlFgQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oePORSh1rgX+JXpgduACFoIrfgNiJzUhYLplemusGY/OhY0VDmZnmPwfD97itjh3X
	 +zuzah03ZrvAU1X8JhLMNmpwymHThw64QjrI/nG10rgJRNaf6lwRV6kofhfWqahJWb
	 y2GhhVpWC/Dkb8eG1AVoOTCKGhWRo79U7Yi7LuUEltKq8sV3y+QLljcRJR/Lq224jv
	 YGflqs7R49Bu/bW6VMqU20NOCMRfyKzxRfyL6qmCVS21bVt5eDaa3DkK+2Y/voBK+1
	 gMwqYOsd4l8RKYS1sDy3IUCrxZIyfc4xDBtSS3gOR4yz+yGMleIeuGgOtaYOcNLTaV
	 VWHEkzHSWJWdw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 195/283] svcrdma: Increase the per-transport rw_ctx count
Date: Sat, 28 Feb 2026 13:05:37 -0500
Message-ID: <20260228180709.1583486-195-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index e26d1a7035e55..41db2b1ee0d13 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -415,8 +415,13 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
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

