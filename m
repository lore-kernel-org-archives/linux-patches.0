Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46B9522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3509BC433C8;
	Sun,  9 Jul 2023 11:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901950;
	bh=xNCwMWciGskOXqgafz38fG8flMZa59fR/gSEK5tPP4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wfL+EGOs+urd1qm80zI3gCEZ1f+vjO52EoXh12hGYr37Lup5JULsYrxya1NM9Gn5Q
	 zcXqnuq7Ee0jQvhUB62lWJvhapOOxqlM/j0yOMWcxJ9VfRUM54QDDyZ1t/eYv74BLb
	 1uHeRTZ5ArHNJJjsG+W4yWDXcvMikavYO2JjDxOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 202/431] RDMA/bnxt_re: Fix to remove unnecessary return labels
Date: Sun,  9 Jul 2023 13:12:30 +0200
Message-ID: <20230709111455.905683870@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
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

[ Upstream commit 9b3ee47796f529e5bc31a355d6cb756d68a7079a ]

If there is no cleanup needed then just return directly.  This cleans up
the code and improve readability.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Link: https://lore.kernel.org/r/1684478897-12247-3-git-send-email-selvin.xavier@broadcom.com
Reviewed-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index a143bd3580a27..4abe1f59b3689 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -1605,7 +1605,7 @@ static int bnxt_qplib_put_inline(struct bnxt_qplib_qp *qp,
 		il_src = (void *)wqe->sg_list[indx].addr;
 		t_len += len;
 		if (t_len > qp->max_inline_data)
-			goto bad;
+			return -ENOMEM;
 		while (len) {
 			if (pull_dst) {
 				pull_dst = false;
@@ -1629,8 +1629,6 @@ static int bnxt_qplib_put_inline(struct bnxt_qplib_qp *qp,
 	}
 
 	return t_len;
-bad:
-	return -ENOMEM;
 }
 
 static u32 bnxt_qplib_put_sges(struct bnxt_qplib_hwq *hwq,
@@ -2060,7 +2058,7 @@ int bnxt_qplib_create_cq(struct bnxt_qplib_res *res, struct bnxt_qplib_cq *cq)
 	hwq_attr.sginfo = &cq->sg_info;
 	rc = bnxt_qplib_alloc_init_hwq(&cq->hwq, &hwq_attr);
 	if (rc)
-		goto exit;
+		return rc;
 
 	RCFW_CMD_PREP(req, CREATE_CQ, cmd_flags);
 
@@ -2101,7 +2099,6 @@ int bnxt_qplib_create_cq(struct bnxt_qplib_res *res, struct bnxt_qplib_cq *cq)
 
 fail:
 	bnxt_qplib_free_hwq(res, &cq->hwq);
-exit:
 	return rc;
 }
 
-- 
2.39.2



