Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B9263C;
	Thu, 15 Aug 2024 14:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732153; cv=none; b=QVSFSuj49rX+SAMpzrnYAzAZq0qyGUjHkmqKPpjkp5M13MIPh61ry7HLYSPbLmMky+aVsBiOlHP2bF/ACCxvZAWtB3b0Ha8y7MM96yG2zHABMunhwWHUVeW/hOR2oHmeePIT2rHPK+ZWriGF6fyefMI/J+Mk+SqHDOoZe5R3Q8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732153; c=relaxed/simple;
	bh=SV1ffZ7l5sqQEcN9Vg4A1+asyPmrSrBxQLbywwqVddQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9ceA88Fih39TyO1k7Y0R1aw/VYgqbK/zdHo2yHppRN+ilSQWchq+qf0tIhMaiTvfki4JPZt+PZy9cYbs4th+wFMzZx1CG/xSFwVMJC3roAZGZtYtRhVR/YMSCn3Muu6abKunSxQIwzp8LHzI8lqTYW7v0TasWReqh4bDUC3r0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8miOc+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8miOc+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B318EC32786;
	Thu, 15 Aug 2024 14:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732153;
	bh=SV1ffZ7l5sqQEcN9Vg4A1+asyPmrSrBxQLbywwqVddQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V8miOc+YsgvzhCNGxKpwjV4F38YX2QCsTw7KutOOJW0TRQdaOWakNP7gvn1exdFVO
	 vdBGbattD65QFgxHtTJsN8aqQlSjPfTr0aO2CGLdRAxuIrQbHf0DOg/g8ZS3NwNsMh
	 5qaCheUOwRhROYjU47xyV8RhxdwVA7YUoIgMhyPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/352] xprtrdma: Fix rpcrdma_reqs_reset()
Date: Thu, 15 Aug 2024 15:22:37 +0200
Message-ID: <20240815131922.778308665@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit acd9f2dd23c632568156217aac7a05f5a0313152 ]

Avoid FastReg operations getting MW_BIND_ERR after a reconnect.

rpcrdma_reqs_reset() is called on transport tear-down to get each
rpcrdma_req back into a clean state.

MRs on req->rl_registered are waiting for a FastReg, are already
registered, or are waiting for invalidation. If the transport is
being torn down when reqs_reset() is called, the matching LocalInv
might never be posted. That leaves these MR registered /and/ on
req->rl_free_mrs, where they can be re-used for the next
connection.

Since xprtrdma does not keep specific track of the MR state, it's
not possible to know what state these MRs are in, so the only safe
thing to do is release them immediately.

Fixes: 5de55ce951a1 ("xprtrdma: Release in-flight MRs on disconnect")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/frwr_ops.c |  3 ++-
 net/sunrpc/xprtrdma/verbs.c    | 16 +++++++++++++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index 177099f6ae182..2035d748d923c 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -86,7 +86,8 @@ static void frwr_mr_recycle(struct rpcrdma_mr *mr)
 	frwr_mr_release(mr);
 }
 
-/* frwr_reset - Place MRs back on the free list
+/**
+ * frwr_reset - Place MRs back on @req's free list
  * @req: request to reset
  *
  * Used after a failed marshal. For FRWR, this means the MRs
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 167f0d99b8580..9262c94a13c1d 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -932,6 +932,8 @@ static int rpcrdma_reqs_setup(struct rpcrdma_xprt *r_xprt)
 
 static void rpcrdma_req_reset(struct rpcrdma_req *req)
 {
+	struct rpcrdma_mr *mr;
+
 	/* Credits are valid for only one connection */
 	req->rl_slot.rq_cong = 0;
 
@@ -941,7 +943,19 @@ static void rpcrdma_req_reset(struct rpcrdma_req *req)
 	rpcrdma_regbuf_dma_unmap(req->rl_sendbuf);
 	rpcrdma_regbuf_dma_unmap(req->rl_recvbuf);
 
-	frwr_reset(req);
+	/* The verbs consumer can't know the state of an MR on the
+	 * req->rl_registered list unless a successful completion
+	 * has occurred, so they cannot be re-used.
+	 */
+	while ((mr = rpcrdma_mr_pop(&req->rl_registered))) {
+		struct rpcrdma_buffer *buf = &mr->mr_xprt->rx_buf;
+
+		spin_lock(&buf->rb_lock);
+		list_del(&mr->mr_all);
+		spin_unlock(&buf->rb_lock);
+
+		frwr_mr_release(mr);
+	}
 }
 
 /* ASSUMPTION: the rb_allreqs list is stable for the duration,
-- 
2.43.0



