Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F441ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FAC1C433C8;
	Tue, 25 Jul 2023 11:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285077;
	bh=lcmWQCyp7N9qRzGDtQcC5xszbuSV9YXkaoq/x2IqTPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JkhbxwV/aMptcJdi/kcCLN0W0y5g8oVVCfWFgcbI5qJR+TTKHLD6ZGVzzs5FnKrCt
	 8v7jBMHIXD0Vxq9YuAXBgmMjuybc6g3u0U6BpiRAhf0NcIqCNsQdHPoq+3pq47HYno
	 a05ZEJhNxgk7+R7px8VIMIeAbGl7bDD4mJEIR24w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/313] RDMA/bnxt_re: Fix to remove an unnecessary log
Date: Tue, 25 Jul 2023 12:43:49 +0200
Message-ID: <20230725104524.241953859@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 43774bc156614346fe5dacabc8e8c229167f2536 ]

During destroy_qp, driver sets the qp handle in the existing CQEs
belonging to the QP being destroyed to NULL. As a result, a poll_cq after
destroy_qp can report unnecessary messages.  Remove this noise from system
logs.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Link: https://lore.kernel.org/r/1684478897-12247-6-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 5fc5ab7813c0f..18b579c8a8c55 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -2606,11 +2606,8 @@ static int bnxt_qplib_cq_process_terminal(struct bnxt_qplib_cq *cq,
 
 	qp = (struct bnxt_qplib_qp *)((unsigned long)
 				      le64_to_cpu(hwcqe->qp_handle));
-	if (!qp) {
-		dev_err(&cq->hwq.pdev->dev,
-			"FP: CQ Process terminal qp is NULL\n");
+	if (!qp)
 		return -EINVAL;
-	}
 
 	/* Must block new posting of SQ and RQ */
 	qp->state = CMDQ_MODIFY_QP_NEW_STATE_ERR;
-- 
2.39.2



