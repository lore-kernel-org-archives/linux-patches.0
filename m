Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC4A522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:25:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AA2C433C8;
	Sun,  9 Jul 2023 11:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901953;
	bh=X1ES200BLNWqFSf2Qsc4iuWzRtiFBsi85iQUoOSaIp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n7DEOQopn9PwDuGGXtMNfP30lQ+q//QIApLlcJhuk+wpmSw8iqdqtfwwALx+lamyy
	 aCajKByHvv5S2jze0zOoRo5P5lxeqte7h34/kpuYm0kCjbh3HV4eX6/zjtXcU9RKcl
	 AHg8ppKf/nChYrK/5LFsrluZToC0FA+TAT1Y8lT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhargava Chenna Marreddy <bhargava.marreddy@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 203/431] RDMA/bnxt_re: Use unique names while registering interrupts
Date: Sun,  9 Jul 2023 13:12:31 +0200
Message-ID: <20230709111455.928593817@linuxfoundation.org>
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

[ Upstream commit ff2e4bfd162cf66a112a81509e419805add44d64 ]

bnxt_re currently uses the names "bnxt_qplib_creq" and "bnxt_qplib_nq-0"
while registering IRQs. There is no way to distinguish the IRQs of
different device ports when there are multiple IB devices registered.
This could make the scenarios worse where one want to pin IRQs of a device
port to certain CPUs.

Fixed the code to use unique names which has PCI BDF information while
registering interrupts like: "bnxt_re-nq-0@pci:0000:65:00.0" and
"bnxt_re-creq@pci:0000:65:00.1".

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Link: https://lore.kernel.org/r/1684478897-12247-4-git-send-email-selvin.xavier@broadcom.com
Reviewed-by: Bhargava Chenna Marreddy <bhargava.marreddy@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c   | 12 ++++++++++--
 drivers/infiniband/hw/bnxt_re/qplib_fp.h   |  2 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 15 +++++++++++++--
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h |  1 +
 4 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 4abe1f59b3689..640d932bec376 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -418,6 +418,8 @@ void bnxt_qplib_nq_stop_irq(struct bnxt_qplib_nq *nq, bool kill)
 
 	irq_set_affinity_hint(nq->msix_vec, NULL);
 	free_irq(nq->msix_vec, nq);
+	kfree(nq->name);
+	nq->name = NULL;
 	nq->requested = false;
 }
 
@@ -444,6 +446,7 @@ void bnxt_qplib_disable_nq(struct bnxt_qplib_nq *nq)
 int bnxt_qplib_nq_start_irq(struct bnxt_qplib_nq *nq, int nq_indx,
 			    int msix_vector, bool need_init)
 {
+	struct bnxt_qplib_res *res = nq->res;
 	int rc;
 
 	if (nq->requested)
@@ -455,9 +458,14 @@ int bnxt_qplib_nq_start_irq(struct bnxt_qplib_nq *nq, int nq_indx,
 	else
 		tasklet_enable(&nq->nq_tasklet);
 
-	snprintf(nq->name, sizeof(nq->name), "bnxt_qplib_nq-%d", nq_indx);
+	nq->name = kasprintf(GFP_KERNEL, "bnxt_re-nq-%d@pci:%s",
+			     nq_indx, pci_name(res->pdev));
+	if (!nq->name)
+		return -ENOMEM;
 	rc = request_irq(nq->msix_vec, bnxt_qplib_nq_irq, 0, nq->name, nq);
 	if (rc) {
+		kfree(nq->name);
+		nq->name = NULL;
 		tasklet_disable(&nq->nq_tasklet);
 		return rc;
 	}
@@ -471,7 +479,7 @@ int bnxt_qplib_nq_start_irq(struct bnxt_qplib_nq *nq, int nq_indx,
 			 nq->msix_vec, nq_indx);
 	}
 	nq->requested = true;
-	bnxt_qplib_ring_nq_db(&nq->nq_db.dbinfo, nq->res->cctx, true);
+	bnxt_qplib_ring_nq_db(&nq->nq_db.dbinfo, res->cctx, true);
 
 	return rc;
 }
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.h b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
index 0375019525431..f859710f9a7f4 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
@@ -471,7 +471,7 @@ typedef int (*srqn_handler_t)(struct bnxt_qplib_nq *nq,
 struct bnxt_qplib_nq {
 	struct pci_dev			*pdev;
 	struct bnxt_qplib_res		*res;
-	char				name[32];
+	char				*name;
 	struct bnxt_qplib_hwq		hwq;
 	struct bnxt_qplib_nq_db		nq_db;
 	u16				ring_id;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index e28f0eb5b55d4..9c63b8b62edfc 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -648,6 +648,8 @@ void bnxt_qplib_rcfw_stop_irq(struct bnxt_qplib_rcfw *rcfw, bool kill)
 		tasklet_kill(&creq->creq_tasklet);
 
 	free_irq(creq->msix_vec, rcfw);
+	kfree(creq->irq_name);
+	creq->irq_name = NULL;
 	creq->requested = false;
 }
 
@@ -680,9 +682,11 @@ int bnxt_qplib_rcfw_start_irq(struct bnxt_qplib_rcfw *rcfw, int msix_vector,
 			      bool need_init)
 {
 	struct bnxt_qplib_creq_ctx *creq;
+	struct bnxt_qplib_res *res;
 	int rc;
 
 	creq = &rcfw->creq;
+	res = rcfw->res;
 
 	if (creq->requested)
 		return -EFAULT;
@@ -692,15 +696,22 @@ int bnxt_qplib_rcfw_start_irq(struct bnxt_qplib_rcfw *rcfw, int msix_vector,
 		tasklet_setup(&creq->creq_tasklet, bnxt_qplib_service_creq);
 	else
 		tasklet_enable(&creq->creq_tasklet);
+
+	creq->irq_name = kasprintf(GFP_KERNEL, "bnxt_re-creq@pci:%s",
+				   pci_name(res->pdev));
+	if (!creq->irq_name)
+		return -ENOMEM;
 	rc = request_irq(creq->msix_vec, bnxt_qplib_creq_irq, 0,
-			 "bnxt_qplib_creq", rcfw);
+			 creq->irq_name, rcfw);
 	if (rc) {
+		kfree(creq->irq_name);
+		creq->irq_name = NULL;
 		tasklet_disable(&creq->creq_tasklet);
 		return rc;
 	}
 	creq->requested = true;
 
-	bnxt_qplib_ring_nq_db(&creq->creq_db.dbinfo, rcfw->res->cctx, true);
+	bnxt_qplib_ring_nq_db(&creq->creq_db.dbinfo, res->cctx, true);
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
index 0a3d8e7da3d42..b887e7fbad9ef 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
@@ -174,6 +174,7 @@ struct bnxt_qplib_creq_ctx {
 	u16				ring_id;
 	int				msix_vec;
 	bool				requested; /*irq handler installed */
+	char				*irq_name;
 };
 
 /* RCFW Communication Channels */
-- 
2.39.2



