Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABEE2BE653;
	Tue, 26 Aug 2025 11:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207902; cv=none; b=NEme5gIzB5tLdeyAKTc0dyw3sJadNXqH6MnX+DkBJIYI3W4PJiRI6WqCK0pFTbjQjBY9Nz4OM6xd5FBc4+2qRgxqfGoKQYzTIr5IDmhAsYssVmk9AE8tbTI01eBEfogg67TByWYGP0RKng5iZxmounj9PqrNS9StExD4CszejPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207902; c=relaxed/simple;
	bh=TgbefTqUY+LDU/dnCaeBIff01e7fZviDqtl1VQ0WBmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b11RupgCG7LmC7Y7eNukYLC49a5UPW/uB3wZciIYLHMlB/sm2lhJBrzJG4DMqtnrEOx4DNtPEY9P8rOZvMRcNmI0TQ4lzu4AvzHVkHPv8pZASjeVsmmQovATiuxp3Ogg5V2Quv6bRCyOF421X4i4kVd6vdpUQ2cHcw1sAebMFsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/kOk5xC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/kOk5xC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4C7C4CEF1;
	Tue, 26 Aug 2025 11:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207902;
	bh=TgbefTqUY+LDU/dnCaeBIff01e7fZviDqtl1VQ0WBmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/kOk5xCXh4GXDd7kLOiY5XEEZQ2Z40Ffdo40Kq9PSmTMvaegVuP5wPOVyZvR67LR
	 7qfdAjNrcOSAU9pd3YGqo5R+smS2CgbsMT1jSXx5OYiDo1Yvh0bQvRiuWlZ2nVgwJz
	 tZIrtPeBt+2oPOdAde1fkH1dNiqMJJC6CDDlHd0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 362/457] RDMA/bnxt_re: Fix to remove workload check in SRQ limit path
Date: Tue, 26 Aug 2025 13:10:46 +0200
Message-ID: <20250826110946.257630819@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kashyap Desai <kashyap.desai@broadcom.com>

[ Upstream commit 666bce0bd7e771127cb0cda125cc9d32d9f9f15d ]

There should not be any checks of current workload to set
srq_limit value to SRQ hw context.

Remove all such workload checks and make a direct call to
set srq_limit via doorbell SRQ_ARM.

Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Link: https://patch.msgid.link/20250805101000.233310-3-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c |  8 ++-----
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 27 ------------------------
 drivers/infiniband/hw/bnxt_re/qplib_fp.h |  2 --
 3 files changed, 2 insertions(+), 35 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 3a627acb82ce..9b33072f9a06 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1921,7 +1921,6 @@ int bnxt_re_modify_srq(struct ib_srq *ib_srq, struct ib_srq_attr *srq_attr,
 	struct bnxt_re_srq *srq = container_of(ib_srq, struct bnxt_re_srq,
 					       ib_srq);
 	struct bnxt_re_dev *rdev = srq->rdev;
-	int rc;
 
 	switch (srq_attr_mask) {
 	case IB_SRQ_MAX_WR:
@@ -1933,11 +1932,8 @@ int bnxt_re_modify_srq(struct ib_srq *ib_srq, struct ib_srq_attr *srq_attr,
 			return -EINVAL;
 
 		srq->qplib_srq.threshold = srq_attr->srq_limit;
-		rc = bnxt_qplib_modify_srq(&rdev->qplib_res, &srq->qplib_srq);
-		if (rc) {
-			ibdev_err(&rdev->ibdev, "Modify HW SRQ failed!");
-			return rc;
-		}
+		bnxt_qplib_srq_arm_db(&srq->qplib_srq.dbinfo, srq->qplib_srq.threshold);
+
 		/* On success, update the shadow */
 		srq->srq_limit = srq_attr->srq_limit;
 		/* No need to Build and send response back to udata */
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index eb82440cdded..c2784561156f 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -706,7 +706,6 @@ int bnxt_qplib_create_srq(struct bnxt_qplib_res *res,
 	srq->dbinfo.max_slot = 1;
 	srq->dbinfo.priv_db = res->dpi_tbl.priv_db;
 	bnxt_qplib_armen_db(&srq->dbinfo, DBC_DBC_TYPE_SRQ_ARMENA);
-	srq->arm_req = false;
 
 	return 0;
 fail:
@@ -716,24 +715,6 @@ int bnxt_qplib_create_srq(struct bnxt_qplib_res *res,
 	return rc;
 }
 
-int bnxt_qplib_modify_srq(struct bnxt_qplib_res *res,
-			  struct bnxt_qplib_srq *srq)
-{
-	struct bnxt_qplib_hwq *srq_hwq = &srq->hwq;
-	u32 count;
-
-	count = __bnxt_qplib_get_avail(srq_hwq);
-	if (count > srq->threshold) {
-		srq->arm_req = false;
-		bnxt_qplib_srq_arm_db(&srq->dbinfo, srq->threshold);
-	} else {
-		/* Deferred arming */
-		srq->arm_req = true;
-	}
-
-	return 0;
-}
-
 int bnxt_qplib_query_srq(struct bnxt_qplib_res *res,
 			 struct bnxt_qplib_srq *srq)
 {
@@ -775,7 +756,6 @@ int bnxt_qplib_post_srq_recv(struct bnxt_qplib_srq *srq,
 	struct bnxt_qplib_hwq *srq_hwq = &srq->hwq;
 	struct rq_wqe *srqe;
 	struct sq_sge *hw_sge;
-	u32 count = 0;
 	int i, next;
 
 	spin_lock(&srq_hwq->lock);
@@ -807,15 +787,8 @@ int bnxt_qplib_post_srq_recv(struct bnxt_qplib_srq *srq,
 
 	bnxt_qplib_hwq_incr_prod(&srq->dbinfo, srq_hwq, srq->dbinfo.max_slot);
 
-	spin_lock(&srq_hwq->lock);
-	count = __bnxt_qplib_get_avail(srq_hwq);
-	spin_unlock(&srq_hwq->lock);
 	/* Ring DB */
 	bnxt_qplib_ring_prod_db(&srq->dbinfo, DBC_DBC_TYPE_SRQ);
-	if (srq->arm_req == true && count > srq->threshold) {
-		srq->arm_req = false;
-		bnxt_qplib_srq_arm_db(&srq->dbinfo, srq->threshold);
-	}
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.h b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
index 0d9487c889ff..846501f12227 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
@@ -543,8 +543,6 @@ int bnxt_qplib_enable_nq(struct pci_dev *pdev, struct bnxt_qplib_nq *nq,
 			 srqn_handler_t srq_handler);
 int bnxt_qplib_create_srq(struct bnxt_qplib_res *res,
 			  struct bnxt_qplib_srq *srq);
-int bnxt_qplib_modify_srq(struct bnxt_qplib_res *res,
-			  struct bnxt_qplib_srq *srq);
 int bnxt_qplib_query_srq(struct bnxt_qplib_res *res,
 			 struct bnxt_qplib_srq *srq);
 void bnxt_qplib_destroy_srq(struct bnxt_qplib_res *res,
-- 
2.50.1



