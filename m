Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DA92D063E;
	Wed, 25 Feb 2026 06:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002607; cv=none; b=rYz8STGHzzue5nHmEyZidscVJJhJWJUEffldJdrUdsbSkF9jUKofocwF73+xc1sEUcI4ShZILkv0qbjcilrIpxi4CLgqRkBgdm/2s9pERsK5nABI/1T3nZXiXvLrbfaWmMLT8ceP/0B9wcjeR/1RVsuwcdA60AKOkNttoaDdIqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002607; c=relaxed/simple;
	bh=YSrRqS3iYuIxU9Rw6Y5znOb6Gq3RzcDr8w+982bUEfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+ACjOFnUQLTb28coqTJKjiJY5JemULqRMUrDpjP5cmzMikcXtMji7jO0qdTGrpeJU5dom/R8O08GQr7I8oEgxZFkvPmRMF/TAEzgeEN+bzODeqSJekAUmkABwYF9UqwmIHbqYF0zvfNBZVSWNXVAzXqI4/Zr8MxInVL7K25eQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wkYbWJCu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkYbWJCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFABC19425;
	Wed, 25 Feb 2026 06:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002607;
	bh=YSrRqS3iYuIxU9Rw6Y5znOb6Gq3RzcDr8w+982bUEfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wkYbWJCufH/PODTLng/NjthoX3+OPYprUOo+CqEeN9sO+z5GhCeaIgJO1y4OaROtr
	 nAl1b9m9A/+uPXWUcoxb7CWxgUwWX3NFViHWCJIc065ZtwTe0VETDOp1KRkWs0qAOX
	 8aqOBF6wDp2pDgSNfMJlC+Tx6EGtjDCu1kdwrq5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Penyaev <r.peniaev@gmail.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Grzegorz Prajsner <grzegorz.prajsner@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 357/641] RDMA/rtrs-srv: fix SG mapping
Date: Tue, 24 Feb 2026 17:21:23 -0800
Message-ID: <20260225012357.278012616@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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



