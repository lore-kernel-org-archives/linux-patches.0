Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290E9E545
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D735C433C7;
	Tue,  1 Aug 2023 09:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882525;
	bh=Rg/tJd4BXlFdldG/BrS7MEaH0pDGOAi2q6vmb5a7uhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7w2Brsx7v2W63TCgF0olNd4tsK49rQNs4v8rcKgkB2za/8BUt72k61polfzrBHu/
	 s0p/Z7AgSkkW9GjWvYTVloUTrEnv+S/NNOjn+FrguisfHw8cDv245LgE6e63Vq1ryI
	 Eek7NrFa7HVoeZu1YpDfuuw4FeNDk0fn9y6UWoRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sindhu Devale <sindhu.devale@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/228] RDMA/irdma: Fix op_type reporting in CQEs
Date: Tue,  1 Aug 2023 11:19:54 +0200
Message-ID: <20230801091927.765573067@linuxfoundation.org>
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

From: Sindhu Devale <sindhu.devale@intel.com>

[ Upstream commit 3bfb25fa2b5bb9c29681e6ac861808f4be1331a9 ]

The op_type field CQ poll info structure is incorrectly
filled in with the queue type as opposed to the op_type
received in the CQEs. The wrong opcode could be decoded
and returned to the ULP.

Copy the op_type field received in the CQE in the CQ poll
info structure.

Fixes: 24419777e943 ("RDMA/irdma: Fix RQ completion opcode")
Signed-off-by: Sindhu Devale <sindhu.devale@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Link: https://lore.kernel.org/r/20230725155439.1057-1-shiraz.saleem@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/uk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/uk.c b/drivers/infiniband/hw/irdma/uk.c
index ea2c07751245a..280d633d4ec4f 100644
--- a/drivers/infiniband/hw/irdma/uk.c
+++ b/drivers/infiniband/hw/irdma/uk.c
@@ -1161,7 +1161,7 @@ int irdma_uk_cq_poll_cmpl(struct irdma_cq_uk *cq,
 	}
 	wqe_idx = (u32)FIELD_GET(IRDMA_CQ_WQEIDX, qword3);
 	info->qp_handle = (irdma_qp_handle)(unsigned long)qp;
-	info->op_type = (u8)FIELD_GET(IRDMA_CQ_SQ, qword3);
+	info->op_type = (u8)FIELD_GET(IRDMACQ_OP, qword3);
 
 	if (info->q_type == IRDMA_CQE_QTYPE_RQ) {
 		u32 array_idx;
-- 
2.40.1



