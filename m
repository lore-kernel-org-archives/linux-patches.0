Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7750D18F2DB;
	Mon, 28 Oct 2024 06:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098014; cv=none; b=RHgMra7+xYKHQR7NolmFY+eXUbJDyIdpKwWH752bEYvD2A8wUWafPaMlyHFVh2/TveqI2nIFv0Rc+HhDwAxni8gqEkRtP/MCZCU6N/4/tcw5SyNegQgps0i7kQ+uuaihgeXinA1aPQiz/kHge1W/Yfskbe9uTkZ1FXAc2+pHNcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098014; c=relaxed/simple;
	bh=ECBTRyWiP9tGuczLwGWIPeGOYIIBQvc72G2GpSWtP1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgT7oWaTxP8a3DX39G9LUxnWGzVOB5Yv7aRrc32HmJlLwGMa1BeS6wR67Q4KUUgoAopyu0pYqq4RH6ba/DkbWap4dI7ihFOOYza5ZkdxqwYOlyW4H94GctHC74v7+mijE1EstoPLQHfqZxR8p4igdME9agpe/sUgzj5RJ4tLYpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8iwHyTt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8iwHyTt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6287C4CEC3;
	Mon, 28 Oct 2024 06:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098013;
	bh=ECBTRyWiP9tGuczLwGWIPeGOYIIBQvc72G2GpSWtP1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v8iwHyTtNu5OlrolR3wR6gy8zmNuuNUAsw7KDRtQpyQsxa/g1XdIjDSEA0DY2lQPF
	 mKvVYAjEyiUlH3wqIHqqC7Y6I8HLiz12xO3uNg/RoGFN+ylINMPz/L9/8X0sIpuJbj
	 YjuN0/sTxPnoTIEGqz/7GmoOA8iasNf0P78qdqJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhishek Mohapatra <abhishek.mohapatra@broadcom.com>,
	Chandramohan Akula <chandramohan.akula@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 039/261] RDMA/bnxt_re: Fix the max CQ WQEs for older adapters
Date: Mon, 28 Oct 2024 07:23:01 +0100
Message-ID: <20241028062312.989190529@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhishek Mohapatra <abhishek.mohapatra@broadcom.com>

[ Upstream commit ac6df53738b465053d38d491fff87bd7d37fdc07 ]

Older adapters doesn't support the MAX CQ WQEs reported by older FW. So
restrict the value reported to 1M always for older adapters.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Link: https://patch.msgid.link/r/1728373302-19530-2-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Abhishek Mohapatra<abhishek.mohapatra@broadcom.com>
Reviewed-by: Chandramohan Akula <chandramohan.akula@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 2 ++
 drivers/infiniband/hw/bnxt_re/qplib_sp.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index 9328db92fa6db..8e59422dd137e 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -137,6 +137,8 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw,
 			    6 : sb->max_sge;
 	attr->max_cq = le32_to_cpu(sb->max_cq);
 	attr->max_cq_wqes = le32_to_cpu(sb->max_cqe);
+	if (!bnxt_qplib_is_chip_gen_p7(rcfw->res->cctx))
+		attr->max_cq_wqes = min_t(u32, BNXT_QPLIB_MAX_CQ_WQES, attr->max_cq_wqes);
 	attr->max_cq_sges = attr->max_qp_sges;
 	attr->max_mr = le32_to_cpu(sb->max_mr);
 	attr->max_mw = le32_to_cpu(sb->max_mw);
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.h b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
index 16a67d70a6fc4..2f16f3db093ea 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
@@ -55,6 +55,7 @@ struct bnxt_qplib_dev_attr {
 	u32				max_qp_wqes;
 	u32				max_qp_sges;
 	u32				max_cq;
+#define BNXT_QPLIB_MAX_CQ_WQES          0xfffff
 	u32				max_cq_wqes;
 	u32				max_cq_sges;
 	u32				max_mr;
-- 
2.43.0



