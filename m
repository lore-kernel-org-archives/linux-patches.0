Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF86129A64;
	Tue, 23 Jan 2024 00:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971001; cv=none; b=O8S1IC1wrimyoy+Bvepn9EXWuKHhuZt4oEUuYpHEcxkVzEHJZSyaZ2lgBUxF0WEKxrVSpHw+vljnSgD99504mecOgpzj1Rd+JQ503NrKWyZ35FCnpk1wOfIG6yoPIaInb+26oIDEpvn/RQdt58lKWF61WRPLM5H35Q8/T9tBJFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971001; c=relaxed/simple;
	bh=2mfdjGoT6NFSEvjsOXFoX/llh9ldx8wX898QpV/sF7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CBesM+PgeOx9RgoGRR0WluhR7h6iNL6/nM+AGZ9890YXNiKbT/zYRBoryHFB4NA0xdU459OwblCCWde12NZTMO/k7RRP2j66Bz32MX9g+Vb5pANhvQ3S5Jlt7X2v6arlzuKpXm6qgONdnf7D21axm67OXvcWKXNzktWGFxRhVgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/wMflXu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/wMflXu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B49C433C7;
	Tue, 23 Jan 2024 00:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971001;
	bh=2mfdjGoT6NFSEvjsOXFoX/llh9ldx8wX898QpV/sF7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/wMflXuZ75FRTFZyA4VcTLe2UQvgMKKMx/vZ3s8NuP4OVgY2OF0L5UMLUR7pjJoB
	 /EW5mYoZstL9y6IcFf1eymEyr/oRNk8rUTy0mmYIVmm6dHH3A7SveSr6gr0H96+wso
	 ayjhUjPd6xnu18S3oWHOIuc+tcGNqwwoCxU4U3NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 160/417] RDMA/hns: Fix inappropriate err code for unsupported operations
Date: Mon, 22 Jan 2024 15:55:28 -0800
Message-ID: <20240122235757.386026412@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit f45b83ad39f8033e717b1eee57e81811113d5a84 ]

EOPNOTSUPP is more situable than EINVAL for allocating XRCD while XRC
is not supported and unsupported resizing SRQ.

Fixes: 32548870d438 ("RDMA/hns: Add support for XRC on HIP09")
Fixes: 221109e64316 ("RDMA/hns: Add interception for resizing SRQs")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20231114123449.1106162-2-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 drivers/infiniband/hw/hns/hns_roce_pd.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index c2ee80546d12..280a3458bb53 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5791,7 +5791,7 @@ static int hns_roce_v2_modify_srq(struct ib_srq *ibsrq,
 
 	/* Resizing SRQs is not supported yet */
 	if (srq_attr_mask & IB_SRQ_MAX_WR)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	if (srq_attr_mask & IB_SRQ_LIMIT) {
 		if (srq_attr->srq_limit > srq->wqe_cnt)
diff --git a/drivers/infiniband/hw/hns/hns_roce_pd.c b/drivers/infiniband/hw/hns/hns_roce_pd.c
index 783e71852c50..bd1fe89ca205 100644
--- a/drivers/infiniband/hw/hns/hns_roce_pd.c
+++ b/drivers/infiniband/hw/hns/hns_roce_pd.c
@@ -150,7 +150,7 @@ int hns_roce_alloc_xrcd(struct ib_xrcd *ib_xrcd, struct ib_udata *udata)
 	int ret;
 
 	if (!(hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_XRC))
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	ret = hns_roce_xrcd_alloc(hr_dev, &xrcd->xrcdn);
 	if (ret)
-- 
2.43.0



