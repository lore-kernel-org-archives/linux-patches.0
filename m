Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFB31F923
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D568DC433C7;
	Fri, 21 Jul 2023 18:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965811;
	bh=MhXO0m5yVmMwiZrHhmBT4ZzaoPcP0caunpJsrx9sZSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NGPe7oBf19BYSP8RKMO0FAsbp/Vqli+TczSY2NrLCwfbRGfPjybXOzLr07oEzx5nN
	 smcszsjvz/LR5I4srZEUeYdlUmcZ34tGD88z8g7rcYDPJt4GleV09VsvMzQacGiYH3
	 Ad7T03g19QLtn0ecD/TS6Bbzk93QGTO5SuS5Dlq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/532] RDMA/bnxt_re: Fix to remove an unnecessary log
Date: Fri, 21 Jul 2023 18:00:26 +0200
Message-ID: <20230721160621.092475428@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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
index d6b7c0d1f6766..d44b6a5c90b57 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -2732,11 +2732,8 @@ static int bnxt_qplib_cq_process_terminal(struct bnxt_qplib_cq *cq,
 
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



