Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB0339B976
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302597; cv=none; b=pxT3fCnBzzlI+teYCJ5L4BDh+a/08TXVR9+dOldrLvka/HkRzqAGbOiTo0QOY8+2YhD5qMBvStbEFAQR3gV+TxT01j3QPNsgt+Z0Mxu/fh/ZKkubt484chCvTcxSK0yhJHdu8u0CzBYXb39E1zOxsJSiy2wCJxneBKlPWCGR2c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302597; c=relaxed/simple;
	bh=7AqrAc6D8Y9edyRNZLcAuAZlKO8jjGHyRFHpLrOoyYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNzFKfcYr3N7wd0endjBOOpiL3uE85X+MuN2TYVNYffIcMRPIAuWrnWzFLXasuYZPzwDC0no4Ul/YhduIAePKjN7Aie9O2dMWF6Ojm6NSvabvAEmo3nfxCEmnMiuyRHCX1xTuvxxT/XRo5S2Xnoq0VaMycwVX5P3QB7/VvpU1Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UMza2+9d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UMza2+9d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794E2C2BC87;
	Sat, 28 Feb 2026 18:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302597;
	bh=7AqrAc6D8Y9edyRNZLcAuAZlKO8jjGHyRFHpLrOoyYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UMza2+9dfQf68c9jyK2KxZdlz6cEV1b/p6TjrJ/erxrqGTsJWh/5zMJA9dBt+66S/
	 9AVPGxkBsxW5q9rhzSxGF77UCXcapOTih+U2t14VqPMpsq6ZfZpEIkTeb7KEZTlwZO
	 dmktJB9trpwMAQiPDY62TXR5SiPanagzO5VYblR+2lsnV+SRwPYwgf0BgGRcJCn/Uw
	 8mynAy1wxRPvT25DMnY1qLDN7Gz0p4pqOInWk0W41aerUT2AGmiiL5YwYaDCWC/bUX
	 LG70W0ZP7LkubH1M5Ndchm/SESIzWF+rVF81phyIsmWwXNSNWV221cQSz5LkKMK5ZX
	 4DtHbD7b0QiCQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Roman Penyaev <r.peniaev@gmail.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Grzegorz Prajsner <grzegorz.prajsner@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/164] RDMA/rtrs-srv: fix SG mapping
Date: Sat, 28 Feb 2026 13:14:08 -0500
Message-ID: <20260228181505.1600663-109-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Roman Penyaev <r.peniaev@gmail.com>

[ Upstream commit 83835f7c07b523c7ca2a5ad0a511670b5810539e ]

This fixes the following error on the server side:

   RTRS server session allocation failed: -EINVAL

caused by the caller of the `ib_dma_map_sg()`, which does not expect
less mapped entries, than requested, which is in the order of things
and can be easily reproduced on the machine with enabled IOMMU.

The fix is to treat any positive number of mapped sg entries as a
successful mapping and cache DMA addresses by traversing modified
SG table.

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Signed-off-by: Roman Penyaev <r.peniaev@gmail.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Grzegorz Prajsner <grzegorz.prajsner@ionos.com>
Link: https://patch.msgid.link/20260107161517.56357-2-haris.iqbal@ionos.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index b5f3cbf0fd79c..8ccac2bce5123 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -597,7 +597,7 @@ static int map_cont_bufs(struct rtrs_srv_path *srv_path)
 	     srv_path->mrs_num++) {
 		struct rtrs_srv_mr *srv_mr = &srv_path->mrs[srv_path->mrs_num];
 		struct scatterlist *s;
-		int nr, nr_sgt, chunks;
+		int nr, nr_sgt, chunks, ind;
 
 		sgt = &srv_mr->sgt;
 		chunks = chunks_per_mr * srv_path->mrs_num;
@@ -627,7 +627,7 @@ static int map_cont_bufs(struct rtrs_srv_path *srv_path)
 		}
 		nr = ib_map_mr_sg(mr, sgt->sgl, nr_sgt,
 				  NULL, max_chunk_size);
-		if (nr != nr_sgt) {
+		if (nr < nr_sgt) {
 			err = nr < 0 ? nr : -EINVAL;
 			goto dereg_mr;
 		}
@@ -643,9 +643,24 @@ static int map_cont_bufs(struct rtrs_srv_path *srv_path)
 				goto dereg_mr;
 			}
 		}
-		/* Eventually dma addr for each chunk can be cached */
-		for_each_sg(sgt->sgl, s, nr_sgt, i)
-			srv_path->dma_addr[chunks + i] = sg_dma_address(s);
+
+		/*
+		 * Cache DMA addresses by traversing sg entries.  If
+		 * regions were merged, an inner loop is required to
+		 * populate the DMA address array by traversing larger
+		 * regions.
+		 */
+		ind = chunks;
+		for_each_sg(sgt->sgl, s, nr_sgt, i) {
+			unsigned int dma_len = sg_dma_len(s);
+			u64 dma_addr = sg_dma_address(s);
+			u64 dma_addr_end = dma_addr + dma_len;
+
+			do {
+				srv_path->dma_addr[ind++] = dma_addr;
+				dma_addr += max_chunk_size;
+			} while (dma_addr < dma_addr_end);
+		}
 
 		ib_update_fast_reg_key(mr, ib_inc_rkey(mr->rkey));
 		srv_mr->mr = mr;
-- 
2.51.0

