Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49A71FB2B
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF74C433C9;
	Tue,  1 Aug 2023 09:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882552;
	bh=IoEG7q9mPu3X3bRdL41O63Y7dnPP8yF2EdxkNkzviWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNk1JGH0k2yatD8DtBhMK1T8t7zkca3skovzVcK0qjoCZLedriKAbJdIUECMH63kg
	 vsfN5fgXD/eFgzGh9sNiVadNXPridqrKAbKPjSDF9Anevj5B8MSHc5YmEnZ7lh8L8F
	 qP5j2Spd3tlMWMrtpQyIMpfiwoG9ajhP4J2BRMtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 118/228] RDMA/irdma: Add missing read barriers
Date: Tue,  1 Aug 2023 11:19:36 +0200
Message-ID: <20230801091927.027989080@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shiraz Saleem <shiraz.saleem@intel.com>

[ Upstream commit 4984eb51453ff7eddee9e5ce816145be39c0ec5c ]

On code inspection, there are many instances in the driver where
CEQE and AEQE fields written to by HW are read without guaranteeing
that the polarity bit has been read and checked first.

Add a read barrier to avoid reordering of loads on the CEQE/AEQE fields
prior to checking the polarity bit.

Fixes: 3f49d6842569 ("RDMA/irdma: Implement HW Admin Queue OPs")
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Link: https://lore.kernel.org/r/20230711175253.1289-2-shiraz.saleem@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/ctrl.c | 9 ++++++++-
 drivers/infiniband/hw/irdma/puda.c | 6 ++++++
 drivers/infiniband/hw/irdma/uk.c   | 3 +++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/ctrl.c b/drivers/infiniband/hw/irdma/ctrl.c
index a41e0d21143ae..d86d7ca9cee4a 100644
--- a/drivers/infiniband/hw/irdma/ctrl.c
+++ b/drivers/infiniband/hw/irdma/ctrl.c
@@ -3344,6 +3344,9 @@ int irdma_sc_ccq_get_cqe_info(struct irdma_sc_cq *ccq,
 	if (polarity != ccq->cq_uk.polarity)
 		return -ENOENT;
 
+	/* Ensure CEQE contents are read after valid bit is checked */
+	dma_rmb();
+
 	get_64bit_val(cqe, 8, &qp_ctx);
 	cqp = (struct irdma_sc_cqp *)(unsigned long)qp_ctx;
 	info->error = (bool)FIELD_GET(IRDMA_CQ_ERROR, temp);
@@ -3990,13 +3993,17 @@ int irdma_sc_get_next_aeqe(struct irdma_sc_aeq *aeq,
 	u8 polarity;
 
 	aeqe = IRDMA_GET_CURRENT_AEQ_ELEM(aeq);
-	get_64bit_val(aeqe, 0, &compl_ctx);
 	get_64bit_val(aeqe, 8, &temp);
 	polarity = (u8)FIELD_GET(IRDMA_AEQE_VALID, temp);
 
 	if (aeq->polarity != polarity)
 		return -ENOENT;
 
+	/* Ensure AEQE contents are read after valid bit is checked */
+	dma_rmb();
+
+	get_64bit_val(aeqe, 0, &compl_ctx);
+
 	print_hex_dump_debug("WQE: AEQ_ENTRY WQE", DUMP_PREFIX_OFFSET, 16, 8,
 			     aeqe, 16, false);
 
diff --git a/drivers/infiniband/hw/irdma/puda.c b/drivers/infiniband/hw/irdma/puda.c
index 4ec9639f1bdbf..562531712ea44 100644
--- a/drivers/infiniband/hw/irdma/puda.c
+++ b/drivers/infiniband/hw/irdma/puda.c
@@ -230,6 +230,9 @@ static int irdma_puda_poll_info(struct irdma_sc_cq *cq,
 	if (valid_bit != cq_uk->polarity)
 		return -ENOENT;
 
+	/* Ensure CQE contents are read after valid bit is checked */
+	dma_rmb();
+
 	if (cq->dev->hw_attrs.uk_attrs.hw_rev >= IRDMA_GEN_2)
 		ext_valid = (bool)FIELD_GET(IRDMA_CQ_EXTCQE, qword3);
 
@@ -243,6 +246,9 @@ static int irdma_puda_poll_info(struct irdma_sc_cq *cq,
 		if (polarity != cq_uk->polarity)
 			return -ENOENT;
 
+		/* Ensure ext CQE contents are read after ext valid bit is checked */
+		dma_rmb();
+
 		IRDMA_RING_MOVE_HEAD_NOCHECK(cq_uk->cq_ring);
 		if (!IRDMA_RING_CURRENT_HEAD(cq_uk->cq_ring))
 			cq_uk->polarity = !cq_uk->polarity;
diff --git a/drivers/infiniband/hw/irdma/uk.c b/drivers/infiniband/hw/irdma/uk.c
index dd428d915c175..ea2c07751245a 100644
--- a/drivers/infiniband/hw/irdma/uk.c
+++ b/drivers/infiniband/hw/irdma/uk.c
@@ -1527,6 +1527,9 @@ void irdma_uk_clean_cq(void *q, struct irdma_cq_uk *cq)
 		if (polarity != temp)
 			break;
 
+		/* Ensure CQE contents are read after valid bit is checked */
+		dma_rmb();
+
 		get_64bit_val(cqe, 8, &comp_ctx);
 		if ((void *)(unsigned long)comp_ctx == q)
 			set_64bit_val(cqe, 8, 0);
-- 
2.40.1



