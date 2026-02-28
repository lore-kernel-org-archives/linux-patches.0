Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D22339B978
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302595; cv=none; b=mba4B2EmMtZ2Rhn6JTTgzREnNyMLUVfevZpQUe06HjznhhjJqfgTMnxS8QsNmFc1oHZaOicSO8ED7ipomDWZKBgbHsau1mmwkjJUfORUi/oNixlJRLiL0TLvgbHo88ddsxy//Zl7ZDcE0ukJJqYm/RSw6WOqpctxEDokyyST+l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302595; c=relaxed/simple;
	bh=gY238yLq2OD03x4ceZnbh5hAsLXKphxFgldXWt99jFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XOMBzkNbj/rYrtRG8FQE8x5sCxh/aj/5g3tG69HCA7ETUXE97OLluq9Ft8BkGJJAex8JIbHQIEY6oh/RIQWQD/4V+mn+5kZ98267ocL7cT57KRQs5DG3Lqy4DXYLpDSJllS+Gth42jzsNWvwn0plVRNjmohURj3hF+xA7bfkqWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p51iiIGj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p51iiIGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA497C19423;
	Sat, 28 Feb 2026 18:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302595;
	bh=gY238yLq2OD03x4ceZnbh5hAsLXKphxFgldXWt99jFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p51iiIGjqnvUQlcbfFR25+CH3N9wuusSs3jHUOKInd6NEBt7+pzU71n8xZpQF1Zfx
	 MsRJlxPDqahW3X/f6V1sxWGiVhDt3OTR6nUpxK5/kjb92CZ5NvK/1LlAruPGQZ1rEF
	 +JwDePPcoElL572eMamdU4ht+O/B5AFeImqKDGq4QW6svq8vwkVlSv9UmTNwDW328J
	 LSUYZwubr++NsaV0yuVDvalB5ZzwjIBaBInjlf7+GDJYQ/1NQLtv+jST+2ej23uqKa
	 nSWDruW22uC9f8aUpknWpyVCam0rrwcKwHgcXZr/xPccOSxKlwKn+GvBS1xlJC49/r
	 UuiIv+IpA4lqw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Guoqing Jiang <guoqing.jiang@linux.dev>,
	Md Haris Iqbal <haris.iqbal@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/164] RDMA/rtrs-srv: Refactor the handling of failure case in map_cont_bufs
Date: Sat, 28 Feb 2026 13:14:06 -0500
Message-ID: <20260228181505.1600663-107-sashal@kernel.org>
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

From: Guoqing Jiang <guoqing.jiang@linux.dev>

[ Upstream commit 0f597ac618d04beb9de997fda59a29c9d3818fb2 ]

Let's call unmap_cont_bufs when failure happens, and also only update
mrs_num after everything is settled which means we can remove 'mri'.

Acked-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Link: https://lore.kernel.org/r/20221117101945.6317-3-guoqing.jiang@linux.dev
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 83835f7c07b5 ("RDMA/rtrs-srv: fix SG mapping")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 47 +++++++++++---------------
 1 file changed, 20 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 0979bb728da24..d2ac3a37f46e1 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -566,9 +566,11 @@ static int map_cont_bufs(struct rtrs_srv_path *srv_path)
 {
 	struct rtrs_srv *srv = srv_path->srv;
 	struct rtrs_path *ss = &srv_path->s;
-	int i, mri, err, mrs_num;
+	int i, err, mrs_num;
 	unsigned int chunk_bits;
 	int chunks_per_mr = 1;
+	struct ib_mr *mr;
+	struct sg_table *sgt;
 
 	/*
 	 * Here we map queue_depth chunks to MR.  Firstly we have to
@@ -591,16 +593,14 @@ static int map_cont_bufs(struct rtrs_srv_path *srv_path)
 	if (!srv_path->mrs)
 		return -ENOMEM;
 
-	srv_path->mrs_num = mrs_num;
-
-	for (mri = 0; mri < mrs_num; mri++) {
-		struct rtrs_srv_mr *srv_mr = &srv_path->mrs[mri];
-		struct sg_table *sgt = &srv_mr->sgt;
+	for (srv_path->mrs_num = 0; srv_path->mrs_num < mrs_num;
+	     srv_path->mrs_num++) {
+		struct rtrs_srv_mr *srv_mr = &srv_path->mrs[srv_path->mrs_num];
 		struct scatterlist *s;
-		struct ib_mr *mr;
 		int nr, nr_sgt, chunks;
 
-		chunks = chunks_per_mr * mri;
+		sgt = &srv_mr->sgt;
+		chunks = chunks_per_mr * srv_path->mrs_num;
 		if (!always_invalidate)
 			chunks_per_mr = min_t(int, chunks_per_mr,
 					      srv->queue_depth - chunks);
@@ -649,31 +649,24 @@ static int map_cont_bufs(struct rtrs_srv_path *srv_path)
 
 		ib_update_fast_reg_key(mr, ib_inc_rkey(mr->rkey));
 		srv_mr->mr = mr;
-
-		continue;
-err:
-		while (mri--) {
-			srv_mr = &srv_path->mrs[mri];
-			sgt = &srv_mr->sgt;
-			mr = srv_mr->mr;
-			rtrs_iu_free(srv_mr->iu, srv_path->s.dev->ib_dev, 1);
-dereg_mr:
-			ib_dereg_mr(mr);
-unmap_sg:
-			ib_dma_unmap_sg(srv_path->s.dev->ib_dev, sgt->sgl,
-					sgt->nents, DMA_BIDIRECTIONAL);
-free_sg:
-			sg_free_table(sgt);
-		}
-		kfree(srv_path->mrs);
-
-		return err;
 	}
 
 	chunk_bits = ilog2(srv->queue_depth - 1) + 1;
 	srv_path->mem_bits = (MAX_IMM_PAYL_BITS - chunk_bits);
 
 	return 0;
+
+dereg_mr:
+	ib_dereg_mr(mr);
+unmap_sg:
+	ib_dma_unmap_sg(srv_path->s.dev->ib_dev, sgt->sgl,
+			sgt->nents, DMA_BIDIRECTIONAL);
+free_sg:
+	sg_free_table(sgt);
+err:
+	unmap_cont_bufs(srv_path);
+
+	return err;
 }
 
 static void rtrs_srv_hb_err_handler(struct rtrs_con *c)
-- 
2.51.0

