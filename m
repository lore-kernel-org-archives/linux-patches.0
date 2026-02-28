Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16FE333434
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301844; cv=none; b=rGnwNTnCbg8lGjrEo3fPR/MPb791x7qmJzZF7LBNaGnkAdHFGNsSJB+oZuSXIcY3NCQQUry7Ifwvw1KM+F6U1+/JG39LZ7FCsyES6qnFgwwAobkkbj80wa95WlfH3l5i+BezGmnkilMsNV6XHy76g4vloM5rWh2Hj3WtRjqY4OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301844; c=relaxed/simple;
	bh=NlctxFfUSaYoGAQ1UllfjBofu6L8FQMJH6KZlybPLOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TbWsbZO+SycGJLu9ESRzbFuoDNQ7zdFB9I5djS8zVq6etAMek2UpCFo0NBKjH8hPE6MEYrWp7AQNIMUKXHWT2zN1dvBpwxl59OpGO/rCGKd6RjMJXeIE1kJYGxQGUGva18jPh2uspfqBitd3pysDzNNZJi5v+t2y9zyb4WE66uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hh/N8nKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hh/N8nKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248E9C116D0;
	Sat, 28 Feb 2026 18:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301843;
	bh=NlctxFfUSaYoGAQ1UllfjBofu6L8FQMJH6KZlybPLOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hh/N8nKmtCnmxZQFbdmb1EFOAYJtolHZETvC3dbx5wLUd+f6oeynJLsuPjfCllBNd
	 XRQSsfQjlJUXy0ucrFcM02cZbZg1pRffgF/AM73rLid4GfDXQPKKLLda3ojyuuEQnp
	 73onVlFki2WjFXVhZcxChtBN51l6N+Mp1RHYTg371dpTh7Y99mmb/73LTrihb1OaD5
	 iZ4TI5eZJE2yvimFko6d7hJEnC8mdIK7RS/uhnhURGh+DxPwug/YP1Jj6Dpj/pOTbF
	 QfRxXzEkALlZFwryKFjd7qildg0dN2gdpZHtM5ChBCDHZfQRfrY5iU/i2TvJk94OkS
	 jkFiMV9leYSDw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Roman Penyaev <r.peniaev@gmail.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Grzegorz Prajsner <grzegorz.prajsner@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 263/385] RDMA/rtrs-srv: fix SG mapping
Date: Sat, 28 Feb 2026 12:58:05 -0500
Message-ID: <20260228180011.1568201-263-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 7a402eb8e0bf0..adb798e2a54ae 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -595,7 +595,7 @@ static int map_cont_bufs(struct rtrs_srv_path *srv_path)
 	     srv_path->mrs_num++) {
 		struct rtrs_srv_mr *srv_mr = &srv_path->mrs[srv_path->mrs_num];
 		struct scatterlist *s;
-		int nr, nr_sgt, chunks;
+		int nr, nr_sgt, chunks, ind;
 
 		sgt = &srv_mr->sgt;
 		chunks = chunks_per_mr * srv_path->mrs_num;
@@ -625,7 +625,7 @@ static int map_cont_bufs(struct rtrs_srv_path *srv_path)
 		}
 		nr = ib_map_mr_sg(mr, sgt->sgl, nr_sgt,
 				  NULL, max_chunk_size);
-		if (nr != nr_sgt) {
+		if (nr < nr_sgt) {
 			err = nr < 0 ? nr : -EINVAL;
 			goto dereg_mr;
 		}
@@ -641,9 +641,24 @@ static int map_cont_bufs(struct rtrs_srv_path *srv_path)
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

