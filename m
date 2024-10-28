Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7697D18CC1F;
	Mon, 28 Oct 2024 06:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096893; cv=none; b=JTC42sB6Da2MoCuWYK0ZbGS7je6GRA2tWyrevMo9D8AtF8Qyl21wwozsiIAEmApueg/jaUAWOrDXAfmD9+WWyYiQ3b0ORaGTW2uFwXo/vqrtcClpIljQnS0uSRp/FsmcVIQZI9q0ZoWCbA7APe8KVqyaB0+wsmyfCqlAWXcc/c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096893; c=relaxed/simple;
	bh=1SN9u6D5UI50RHeAwUmPMlyY2bFCaBWFElDfaMEagfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjcoNJAjjv1ZbF/sz31lIGGyLbwRpDDiDVXPFHdXamkPJEHgBIb+GDe7/Ki884r1cPIM7DjJVH8+FYeCcfQVTjGpnjQaJsU572F+umgCLEAEZJV4lvN9Ku8BB4nm4EKxBH/Cga3QqJQQmmbuTR6PMzzv9t1ZCGPcAECqCrkg0GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=chq0h+Av; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="chq0h+Av"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E71C4CEC3;
	Mon, 28 Oct 2024 06:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096893;
	bh=1SN9u6D5UI50RHeAwUmPMlyY2bFCaBWFElDfaMEagfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=chq0h+AvcVQBvpSXrS0l2pXO+H6wMlr4zYYWvBx+Mldoz+bSlcd41EPrNghztdQzg
	 pg8oIwzIkSx6qDFEF3H4CnUTxZ94g1kpniDrIxiOU7jUt5IsTtRQoMIof1rDaYa+hQ
	 hhb+gSV+O8S9ECT6/WOY7/63NyeVChMsOH9MJn4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 04/80] RDMA/bnxt_re: Add a check for memory allocation
Date: Mon, 28 Oct 2024 07:24:44 +0100
Message-ID: <20241028062252.743153047@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit c5c1ae73b7741fa3b58e6e001b407825bb971225 ]

__alloc_pbl() can return error when memory allocation fails.
Driver is not checking the status on one of the instances.

Fixes: 0c4dcd602817 ("RDMA/bnxt_re: Refactor hardware queue memory allocation")
Link: https://patch.msgid.link/r/1726715161-18941-4-git-send-email-selvin.xavier@broadcom.com
Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_res.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
index 384d41072c63c..00ef5f99929c4 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -243,6 +243,8 @@ int bnxt_qplib_alloc_init_hwq(struct bnxt_qplib_hwq *hwq,
 			sginfo.pgsize = npde * pg_size;
 			sginfo.npages = 1;
 			rc = __alloc_pbl(res, &hwq->pbl[PBL_LVL_0], &sginfo);
+			if (rc)
+				goto fail;
 
 			/* Alloc PBL pages */
 			sginfo.npages = npbl;
-- 
2.43.0



