Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A5C18E348;
	Mon, 28 Oct 2024 06:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097530; cv=none; b=T1jDuAtXcsVEqcN+pSXzumfL8U/S7xgKCbZRSn97SiVGNuCN1a+rKLXSi8FEYXiYVjax/GuzGGyGoW9XHpSba4dU5rN2mX8e7yJkDobHQA0whxMaXT/rOvPFuonH7f3mE7A1fGygFmh4/AlpsuokJWi1g83rMTNUhDX9B2yC2So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097530; c=relaxed/simple;
	bh=kM4MaeJsJ0JB223SQATlCmbi+bgLQMkB0YVDgvo7BH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULvA84ywLUCdu+CFIRhlP4CJRN/tkIpcYkMgUHat4fu/UDP0xOwd0c2P4GWRMea1JCmeD22DEGVo/WyAoOhVcWjt6p84CK5kynlOeA+exWRDNWIicnbJZRd0nq87zMe7p7W4X/Duf+bGVnHTA/4USh1mv4GdcrmgHf0Zsotp4k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYs3lGp6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYs3lGp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3638CC4CEC3;
	Mon, 28 Oct 2024 06:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097530;
	bh=kM4MaeJsJ0JB223SQATlCmbi+bgLQMkB0YVDgvo7BH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYs3lGp6yTN3fm0xuqHJ3UdVoKpyXhfnYhD/5rMNcZ1qw/TXBFNL3Stkoz0dmjyra
	 dOxzQMgs+hhytICUC4FmKEtQel3MZOrPZgBdQkymrSrjn9XCR086ZqROt78zHfLduM
	 Be3jwmEud/9v2i/3WxvJLvemjhm8SpfdLCrvbtsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhishek Mohapatra <abhishek.mohapatra@broadcom.com>,
	Chandramohan Akula <chandramohan.akula@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/208] RDMA/bnxt_re: Fix the max CQ WQEs for older adapters
Date: Mon, 28 Oct 2024 07:23:34 +0100
Message-ID: <20241028062307.496930419@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c580bf78d4c13..2b73bb433b88c 100644
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
index d33c78b96217a..755765e68eaab 100644
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



