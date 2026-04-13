Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9401523D297;
	Mon, 13 Apr 2026 16:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097976; cv=none; b=qk55Yo/Np4sQ5ed0LwQElwvpxKB8u538iom5B4MxSJTC51Brp1EN7uUKh1hbexYl/ZKYuUZpQVleuBP6w4IYdyUmvF67L/yhJ8Y3l8+IgccGYbCGcIhMa/Q1GJmgBnltazd7tDmvJoSTLkXb3JQL3rjyfwKGBg9L1573Cmh62q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097976; c=relaxed/simple;
	bh=9zbLCSKlEprGFxMu2ei6bDjab4QGneL4NuxCpqzgvNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cc5SeSkOIubfxTPkmOfayiKvviYX9h3h0I2mmMA8a/mHWFgibDLo+cCVhcOoXJ4IzzQcFzY05pp70/ZaJPMEcWk573XklwgLighywpk5GEshFsxcgzrYcpaeLBbCC0mxesS/uVosxWC4PsSUipyqcx5bblueLd7XQ8rI8+WsfEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oc62ZMV3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oc62ZMV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24C7C2BCAF;
	Mon, 13 Apr 2026 16:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097976;
	bh=9zbLCSKlEprGFxMu2ei6bDjab4QGneL4NuxCpqzgvNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oc62ZMV3wVuZlA1Xc9DBtGYgylIFxNPOXfwTlgXDnKoX0cvhEwVwcs8leIAurg5Dk
	 gc33rKsg8BY2X94kzBVARZi7CjDLr/9gOSIOUp6G/P5T7rALodGX7T6VbbLrAbAvfk
	 xHw/obFJYMeTexvDv3VG9fe98ctExyShMP5omJw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 346/570] RDMA/rw: Fall back to direct SGE on MR pool exhaustion
Date: Mon, 13 Apr 2026 17:57:57 +0200
Message-ID: <20260413155843.451173733@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3b6cfa6362e04..bfa91d2ff956c 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -341,14 +341,29 @@ int rdma_rw_ctx_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u32 port_num,
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



