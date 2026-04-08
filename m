Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE75F37F8C2;
	Wed,  8 Apr 2026 18:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671778; cv=none; b=Le95U5uuazEl+LdFrJ3JcztUeiyQ4Mk5bs0obZul0WhkeQvHXZPOeedVWqzfZWHlnDQZS/kRshMR5nH7abzS1+sNkCb4Byli9rVzOwWHL2/HDKaC5gKghB5LtffckbEBcdPRLMvacx6gI3IEpZh5CDKj7dFqMESnd2sk49yHXVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671778; c=relaxed/simple;
	bh=xli/prbwVqbPgCWfKb6+rcAF+Jaa+bPO99jkxr7cwi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+90TmJHjyUafkHNIp8y6yUl9xAsekb/CWNohYCthuliE+Z9dpr6Zv1OZhxnVydUVu3n+8YpCfGcI+Zo5V6JsB5nl3NbgaTeOwBX4Ol0miHFJwUl6wPaq+qZHg8L/9uFwuFJ/vVfoCxJuBsC3lqOgS6P/LbtRq8D415YIfWoPas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M4iAc+w0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M4iAc+w0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649ECC19421;
	Wed,  8 Apr 2026 18:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671778;
	bh=xli/prbwVqbPgCWfKb6+rcAF+Jaa+bPO99jkxr7cwi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M4iAc+w0dg7GMzYYcCkiPKXNaTqTKzV2cN1J23/nkekYga6iP+xArTC9mqKUtUNTo
	 s67Z6zESTTvEkRKBr3rfpf8+pGT0OxFqvgbQbRjEaFGkgE88iq6ZJLUQWlET9vhhiw
	 MdT1gu+uC1X0Wmae/DH6bYrOt6X3PzbZF5eLy7G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/312] RDMA/rw: Fall back to direct SGE on MR pool exhaustion
Date: Wed,  8 Apr 2026 19:59:42 +0200
Message-ID: <20260408175936.167518176@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 00da250c21b074ea9494c375d0117b69e5b1d0a4 ]

When IOMMU passthrough mode is active, ib_dma_map_sgtable_attrs()
produces no coalescing: each scatterlist page maps 1:1 to a DMA
entry, so sgt.nents equals the raw page count. A 1 MB transfer
yields 256 DMA entries. If that count exceeds the device's
max_sgl_rd threshold (an optimization hint from mlx5 firmware),
rdma_rw_io_needs_mr() steers the operation into the MR
registration path. Each such operation consumes one or more MRs
from a pool sized at max_rdma_ctxs -- roughly one MR per
concurrent context. Under write-intensive workloads that issue
many concurrent RDMA READs, the pool is rapidly exhausted,
ib_mr_pool_get() returns NULL, and rdma_rw_init_one_mr() returns
-EAGAIN. Upper layer protocols treat this as a fatal DMA mapping
failure and tear down the connection.

The max_sgl_rd check is a performance optimization, not a
correctness requirement: the device can handle large SGE counts
via direct posting, just less efficiently than with MR
registration. When the MR pool cannot satisfy a request, falling
back to the direct SGE (map_wrs) path avoids the connection
reset while preserving the MR optimization for the common case
where pool resources are available.

Add a fallback in rdma_rw_ctx_init() so that -EAGAIN from
rdma_rw_init_mr_wrs() triggers direct SGE posting instead of
propagating the error. iWARP devices, which mandate MR
registration for RDMA READs, and force_mr debug mode continue
to treat -EAGAIN as terminal.

Fixes: 00bd1439f464 ("RDMA/rw: Support threshold for registration vs scattering to local pages")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260313194201.5818-2-cel@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/rw.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index 2522ff1cc462c..49fbfe1cef689 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -326,14 +326,29 @@ int rdma_rw_ctx_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u32 port_num,
 	if (rdma_rw_io_needs_mr(qp->device, port_num, dir, sg_cnt)) {
 		ret = rdma_rw_init_mr_wrs(ctx, qp, port_num, sg, sg_cnt,
 				sg_offset, remote_addr, rkey, dir);
-	} else if (sg_cnt > 1) {
+		/*
+		 * If MR init succeeded or failed for a reason other
+		 * than pool exhaustion, that result is final.
+		 *
+		 * Pool exhaustion (-EAGAIN) from the max_sgl_rd
+		 * optimization is recoverable: fall back to
+		 * direct SGE posting. iWARP and force_mr require
+		 * MRs unconditionally, so -EAGAIN is terminal.
+		 */
+		if (ret != -EAGAIN ||
+		    rdma_protocol_iwarp(qp->device, port_num) ||
+		    unlikely(rdma_rw_force_mr))
+			goto out;
+	}
+
+	if (sg_cnt > 1)
 		ret = rdma_rw_init_map_wrs(ctx, qp, sg, sg_cnt, sg_offset,
 				remote_addr, rkey, dir);
-	} else {
+	else
 		ret = rdma_rw_init_single_wr(ctx, qp, sg, sg_offset,
 				remote_addr, rkey, dir);
-	}
 
+out:
 	if (ret < 0)
 		goto out_unmap_sg;
 	return ret;
-- 
2.53.0



