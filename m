Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BD611710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0081C433C8;
	Mon, 11 Sep 2023 15:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445637;
	bh=+lIYdYGBAO2LNIyFsHxePchzZ1+DMyhlg341sxT/wX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXHpl2otb8jjlCR9aadcniFyVOwtbXivxOvW3dli0fJihqQgBahw4kpqGCZdKuWM8
	 qNwM7MQY/Qvkoku2l95cwGam3kqyAziIfpaePJRvBoQUEIhlMUXrBbZD7LZFRrxRJG
	 ssIuw95LUaPwKXcv2hagAYvT1RddPC3zRM7YhTn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 418/600] scsi: RDMA/srp: Fix residual handling
Date: Mon, 11 Sep 2023 15:47:31 +0200
Message-ID: <20230911134646.005044719@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 89e637c19b2441aabc8dbf22a8745b932fd6996e ]

Although the code for residual handling in the SRP initiator follows the
SCSI documentation, that documentation has never been correct. Because
scsi_finish_command() starts from the data buffer length and subtracts the
residual, scsi_set_resid() must not be called if a residual overflow
occurs. Hence remove the scsi_set_resid() calls from the SRP initiator if a
residual overflow occurrs.

Cc: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Fixes: 9237f04e12cc ("scsi: core: Fix scsi_get/set_resid() interface")
Fixes: e714531a349f ("IB/srp: Fix residual handling")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20230724200843.3376570-3-bvanassche@acm.org
Acked-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index b4d6a4a5ae81e..a7580c4855fec 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1984,12 +1984,8 @@ static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp)
 
 		if (unlikely(rsp->flags & SRP_RSP_FLAG_DIUNDER))
 			scsi_set_resid(scmnd, be32_to_cpu(rsp->data_in_res_cnt));
-		else if (unlikely(rsp->flags & SRP_RSP_FLAG_DIOVER))
-			scsi_set_resid(scmnd, -be32_to_cpu(rsp->data_in_res_cnt));
 		else if (unlikely(rsp->flags & SRP_RSP_FLAG_DOUNDER))
 			scsi_set_resid(scmnd, be32_to_cpu(rsp->data_out_res_cnt));
-		else if (unlikely(rsp->flags & SRP_RSP_FLAG_DOOVER))
-			scsi_set_resid(scmnd, -be32_to_cpu(rsp->data_out_res_cnt));
 
 		srp_free_req(ch, req, scmnd,
 			     be32_to_cpu(rsp->req_lim_delta));
-- 
2.40.1



