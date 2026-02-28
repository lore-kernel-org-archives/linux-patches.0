Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA03359A60
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302412; cv=none; b=Hb4Uv+2Tz9tvowLPFaQHPulY7hDg/rpRWaHeejsfjPVXisp2CrZ5en1kJTRvBmFkSNhm2tv4dd6WXPJqFXZb/ltfCDBKkDji55A4UZkHndOQfCh/hyKL6Xqe/wHVE243n4cpiDX+AwKvAFGxdg9OtieSuLPWUBsV9h1RFMp410k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302412; c=relaxed/simple;
	bh=F6oHkv4EZgB9pEI2LJOoK0jkGyV+5+OGzT3IDeNDiOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8JoX19ezFrfcRNXXjoNu2m9kej7mcfwvrgsfybdBedjIN4W8drz6lqblWVPqivnP+yrDxYR9zuagzbvon4Zk+zYBGay0IJ45AcOkL5EIvoQBpfaP3sQpuX4oGh1fMKYduYgRJJnXzRFz1s11nIO2wxkQ0cZb+UqKJ1jUbfipec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g7giZdUL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g7giZdUL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C92C19425;
	Sat, 28 Feb 2026 18:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302411;
	bh=F6oHkv4EZgB9pEI2LJOoK0jkGyV+5+OGzT3IDeNDiOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7giZdULvWla1zmEiFLxi0wT88OlaU2HlIVHWI2YxI6D9CUS8myyxQJRe6ssD33VE
	 UnwYX+lxsIPhQjWoHqunCTK14uSQM7ZUwHOqJRXinpxhh8tu/F9kbC3cptBlH0fcBf
	 le1BcqMmFjJGKxpUh1+y3T1LDfdm9bTbC7ZmFuoYumz8KqWmbLkBMiYgV2S7F527qx
	 Q51/1CiZJ8OFJLNU5bzpFqVo+OmuXzRTV2Sst/R30PMeFwJI7xQ0MqlqBOeOluqOBz
	 WF/MIL1jXe3kos3+12v/tRCR8twjhCgl166F+PD8iHLKkwCSEX3X5kEb+/xigjxCeQ
	 Zds7vxou+oEXw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Guoqing Jiang <guoqing.jiang@linux.dev>,
	Md Haris Iqbal <haris.iqbal@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 145/232] RDMA/rtrs-srv: Refactor the handling of failure case in map_cont_bufs
Date: Sat, 28 Feb 2026 13:09:58 -0500
Message-ID: <20260228181127.1592657-145-sashal@kernel.org>
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
index b69d6c5c9442b..c7f4dc7f2f7da 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -559,9 +559,11 @@ static int map_cont_bufs(struct rtrs_srv_path *srv_path)
 {
 	struct rtrs_srv_sess *srv = srv_path->srv;
 	struct rtrs_path *ss = &srv_path->s;
-	int i, mri, err, mrs_num;
+	int i, err, mrs_num;
 	unsigned int chunk_bits;
 	int chunks_per_mr = 1;
+	struct ib_mr *mr;
+	struct sg_table *sgt;
 
 	/*
 	 * Here we map queue_depth chunks to MR.  Firstly we have to
@@ -584,16 +586,14 @@ static int map_cont_bufs(struct rtrs_srv_path *srv_path)
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
@@ -642,31 +642,24 @@ static int map_cont_bufs(struct rtrs_srv_path *srv_path)
 
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

