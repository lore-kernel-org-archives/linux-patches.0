Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C307517B505;
	Wed,  5 Mar 2025 18:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197989; cv=none; b=B7EjyqgtknUD2ZDh1And2i9r5BqN6eR3HMJWW8VDI+PE/DOI0j3kf9diL1TdAafUaRTT+zpxVYUBIkDWYw7vuS0VxNqQs14LRhF/fJJ1xtVensCUjfikA7gxUKqYWEHdTZ6BldCw4BO/MxjIIPOrHJlFbU3WNRRVxMI3Tyfp9a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197989; c=relaxed/simple;
	bh=WAoNCD6rK83N3GSql8ynx+Ch9LYhmNkxmC9i3+vbGcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRVFGUCoI/Vk7whzhV7s77HIQb0NUBczwq/uWW8mGZh0pm97DL2SdkPF92qvkdfNLfEmPZPrXbwFloRM1zu4XeNdQB13kZ2CWn8a5zIrCVATU7zAuSBGW5OF9TwMwQTmLILvlcaCuRAADsvG8/8262g1Z3UGO/n4KUEjRVr6eXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=doM82BOE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="doM82BOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC03C4CED1;
	Wed,  5 Mar 2025 18:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197989;
	bh=WAoNCD6rK83N3GSql8ynx+Ch9LYhmNkxmC9i3+vbGcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=doM82BOEvSCAtfQfxTDJDoIiOEXPZwb1+8nhUY+hS7MeXFrwEpUhOfwDtFfDMXuBP
	 suh/bN9CzFh6WgPCJrSfqK3HGTAXPZjrjGpK+AZgDLhQqQr3nzHvqezAC/TLwhOlhl
	 jVQtMtdeYn4deoxDXnjPt6ls/NnpoRWOXuJ9RGpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/150] RDMA/bnxt_re: Cache MSIx info to a local structure
Date: Wed,  5 Mar 2025 18:47:18 +0100
Message-ID: <20250305174504.180634314@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 31bad59805c388f92f3a13174a149c2228301c15 ]

L2 driver allocates the vectors for RoCE and pass it through the
en_dev structure to RoCE. During probe, cache the MSIx related
info to a local structure.

Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Link: https://patch.msgid.link/1731577748-1804-5-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: f0df225d12fc ("RDMA/bnxt_re: Add sanity checks on rdev validity")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/bnxt_re.h |  1 +
 drivers/infiniband/hw/bnxt_re/main.c    | 18 ++++++++++--------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
index 2a5cb66402860..784dc0fbd5268 100644
--- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
+++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
@@ -157,6 +157,7 @@ struct bnxt_re_pacing {
 #define BNXT_RE_MIN_MSIX		2
 #define BNXT_RE_MAX_MSIX		BNXT_MAX_ROCE_MSIX
 struct bnxt_re_nq_record {
+	struct bnxt_msix_entry	msix_entries[BNXT_RE_MAX_MSIX];
 	struct bnxt_qplib_nq	nq[BNXT_RE_MAX_MSIX];
 	int			num_msix;
 };
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 310a80962d0eb..08cc9ea175276 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -334,7 +334,7 @@ static void bnxt_re_start_irq(void *handle, struct bnxt_msix_entry *ent)
 	int indx, rc;
 
 	rdev = en_info->rdev;
-	msix_ent = rdev->en_dev->msix_entries;
+	msix_ent = rdev->nqr->msix_entries;
 	rcfw = &rdev->rcfw;
 	if (!ent) {
 		/* Not setting the f/w timeout bit in rcfw.
@@ -350,7 +350,7 @@ static void bnxt_re_start_irq(void *handle, struct bnxt_msix_entry *ent)
 	 * in device sctructure.
 	 */
 	for (indx = 0; indx < rdev->nqr->num_msix; indx++)
-		rdev->en_dev->msix_entries[indx].vector = ent[indx].vector;
+		rdev->nqr->msix_entries[indx].vector = ent[indx].vector;
 
 	rc = bnxt_qplib_rcfw_start_irq(rcfw, msix_ent[BNXT_RE_AEQ_IDX].vector,
 				       false);
@@ -1292,9 +1292,9 @@ static int bnxt_re_init_res(struct bnxt_re_dev *rdev)
 	bnxt_qplib_init_res(&rdev->qplib_res);
 
 	for (i = 1; i < rdev->nqr->num_msix ; i++) {
-		db_offt = rdev->en_dev->msix_entries[i].db_offset;
+		db_offt = rdev->nqr->msix_entries[i].db_offset;
 		rc = bnxt_qplib_enable_nq(rdev->en_dev->pdev, &rdev->nqr->nq[i - 1],
-					  i - 1, rdev->en_dev->msix_entries[i].vector,
+					  i - 1, rdev->nqr->msix_entries[i].vector,
 					  db_offt, &bnxt_re_cqn_handler,
 					  &bnxt_re_srqn_handler);
 		if (rc) {
@@ -1381,7 +1381,7 @@ static int bnxt_re_alloc_res(struct bnxt_re_dev *rdev)
 		rattr.type = type;
 		rattr.mode = RING_ALLOC_REQ_INT_MODE_MSIX;
 		rattr.depth = BNXT_QPLIB_NQE_MAX_CNT - 1;
-		rattr.lrid = rdev->en_dev->msix_entries[i + 1].ring_idx;
+		rattr.lrid = rdev->nqr->msix_entries[i + 1].ring_idx;
 		rc = bnxt_re_net_ring_alloc(rdev, &rattr, &nq->ring_id);
 		if (rc) {
 			ibdev_err(&rdev->ibdev,
@@ -1698,6 +1698,8 @@ static int bnxt_re_dev_init(struct bnxt_re_dev *rdev, u8 op_type)
 		return rc;
 	}
 	rdev->nqr->num_msix = rdev->en_dev->ulp_tbl->msix_requested;
+	memcpy(rdev->nqr->msix_entries, rdev->en_dev->msix_entries,
+	       sizeof(struct bnxt_msix_entry) * rdev->nqr->num_msix);
 
 	/* Check whether VF or PF */
 	bnxt_re_get_sriov_func_type(rdev);
@@ -1723,14 +1725,14 @@ static int bnxt_re_dev_init(struct bnxt_re_dev *rdev, u8 op_type)
 	rattr.type = type;
 	rattr.mode = RING_ALLOC_REQ_INT_MODE_MSIX;
 	rattr.depth = BNXT_QPLIB_CREQE_MAX_CNT - 1;
-	rattr.lrid = rdev->en_dev->msix_entries[BNXT_RE_AEQ_IDX].ring_idx;
+	rattr.lrid = rdev->nqr->msix_entries[BNXT_RE_AEQ_IDX].ring_idx;
 	rc = bnxt_re_net_ring_alloc(rdev, &rattr, &creq->ring_id);
 	if (rc) {
 		ibdev_err(&rdev->ibdev, "Failed to allocate CREQ: %#x\n", rc);
 		goto free_rcfw;
 	}
-	db_offt = rdev->en_dev->msix_entries[BNXT_RE_AEQ_IDX].db_offset;
-	vid = rdev->en_dev->msix_entries[BNXT_RE_AEQ_IDX].vector;
+	db_offt = rdev->nqr->msix_entries[BNXT_RE_AEQ_IDX].db_offset;
+	vid = rdev->nqr->msix_entries[BNXT_RE_AEQ_IDX].vector;
 	rc = bnxt_qplib_enable_rcfw_channel(&rdev->rcfw,
 					    vid, db_offt,
 					    &bnxt_re_aeq_handler);
-- 
2.39.5



