Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1208359A61
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302413; cv=none; b=dXH08tMbQf0JggTsxJiV0PNz5fwQUEBsgVEt5QhvAbNqss3TjKaJnh8u2FT49fV9cByVC8lvsd9epbFgPeMQRRX94mAgqZb2sbhBuC5h5vWRzVhIjr7YYgji6bu1MytxcE4utxvzYbJhtKyB4SH17YpWCmmI39MNzF+0H/zRN2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302413; c=relaxed/simple;
	bh=UjZy81UAxgrsTfNpAJUSSaFTCZZSuHoaiUiZ5Odarxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzQFvaI+VudXrPigBIFkaSZCH0dtk6hvWCVvEWuiRbog0NB+ojokkrmXI9VmIIF5wpCm2A7PM2fYZr4wy/MATFTSyHsj1I3GHzQbsaCiyQWyEHyoOvNXKbo1jPTvxnP8HqTHS1jbDFxSk3fq5T6bNLuifposRkbrXm1M9jf8Iwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JpRMlxow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JpRMlxow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01230C116D0;
	Sat, 28 Feb 2026 18:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302413;
	bh=UjZy81UAxgrsTfNpAJUSSaFTCZZSuHoaiUiZ5Odarxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JpRMlxowcRPeDSFZnYIGXkNo6qHNRAXSOgEwzKHVazuSg73yHOAGeLAxa3IuOa/KV
	 bA62E2AA+j2uFd8JfJnbcb7ieKpA/cR7tbDEPUc9khBh76YRXS02jNQ69QHMy21gss
	 EmyjW0XWiP6L+XZk79BX5MqA12qWbbE6iuQOOuCbo8+yGIBm/nrgiR0uqNw77n/jh4
	 QeKbTziTKrbobzECetDq4y01rBHo97I3jn8YBPPa8mdUGTKLZlB76BXx8O4bh2QETx
	 BKbVYna6y7OrJI/hSq9XenmqZyRE93Nr3he/gS1J0nEYcLzyprztKIoefn/XH6R4dF
	 Pm+vnEd/0PHxg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Roman Penyaev <r.peniaev@gmail.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Grzegorz Prajsner <grzegorz.prajsner@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 147/232] RDMA/rtrs-srv: fix SG mapping
Date: Sat, 28 Feb 2026 13:10:00 -0500
Message-ID: <20260228181127.1592657-147-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index b0d5ee6d15224..f65a5eeec65f8 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -590,7 +590,7 @@ static int map_cont_bufs(struct rtrs_srv_path *srv_path)
 	     srv_path->mrs_num++) {
 		struct rtrs_srv_mr *srv_mr = &srv_path->mrs[srv_path->mrs_num];
 		struct scatterlist *s;
-		int nr, nr_sgt, chunks;
+		int nr, nr_sgt, chunks, ind;
 
 		sgt = &srv_mr->sgt;
 		chunks = chunks_per_mr * srv_path->mrs_num;
@@ -620,7 +620,7 @@ static int map_cont_bufs(struct rtrs_srv_path *srv_path)
 		}
 		nr = ib_map_mr_sg(mr, sgt->sgl, nr_sgt,
 				  NULL, max_chunk_size);
-		if (nr != nr_sgt) {
+		if (nr < nr_sgt) {
 			err = nr < 0 ? nr : -EINVAL;
 			goto dereg_mr;
 		}
@@ -636,9 +636,24 @@ static int map_cont_bufs(struct rtrs_srv_path *srv_path)
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

