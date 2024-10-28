Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85A718E374;
	Mon, 28 Oct 2024 06:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097539; cv=none; b=Us23SCw/+5FGvvSFGN1fZqR3Fx8whfTmbaj1qgMlHJJ39+dbGJRE7uqOp62X5iuFZdCoO2PJVmVieIlDKCSyw4DrsYa9RTgU7QaYVnSurMpwd88byjqQPEGxGTdjR1+FmJ7xzOpDk21BRl1AqOWt6A/QRoQsEJUqB1pPVtudCoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097539; c=relaxed/simple;
	bh=dAHsVwIExMj+qovwNmNgDTVZqi/CNjeZXd9TcszxMVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TM9DnD4gCTxRLejsjpZiU0oK8wRpT0u/81z70tJqHgt0jN3sknW1k8PB4sHWM9aFBUVVhic21nmelfxPwNXMXoqFLZfpiFIkV+1ctOdfC1WGBe1TuiwG1hD241PcfoFxH1xpbanYCGbehzaReOMJFThGVFBY43BzXoTB6+lWeDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AwqIHCge; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AwqIHCge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C45C4CEC3;
	Mon, 28 Oct 2024 06:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097539;
	bh=dAHsVwIExMj+qovwNmNgDTVZqi/CNjeZXd9TcszxMVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AwqIHCgeUOnyUGGE/h0u2COBnztMfO32tx8flQPHpkQoMNUG8H/fEWOcWYEz6DGBY
	 wHQhOLcq7ED1YPaku5MsR0xYpbkjetbHR9yzylWlx3rLB29tVs7ACE00StyM40HWiQ
	 l7LmnzJqvmAmPZIdVxsmiznHHZpL9VZtigVpfMto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/208] RDMA/bnxt_re: Update the BAR offsets
Date: Mon, 28 Oct 2024 07:23:38 +0100
Message-ID: <20241028062307.594717787@linuxfoundation.org>
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

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit a62d685814416647fbb28b3eb2617744adef2d4f ]

Update the BAR offsets for handling GenP7 adapters.
Use the values populated by L2 driver for getting the
Doorbell offsets.

Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://lore.kernel.org/r/1701946060-13931-3-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: dc5006cfcf62 ("RDMA/bnxt_re: Fix the GID table length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/main.c     | 21 +++++++--------------
 drivers/infiniband/hw/bnxt_re/qplib_sp.c |  5 +++--
 2 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 594cc6aa7b79d..607293794b924 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -107,8 +107,11 @@ static void bnxt_re_set_db_offset(struct bnxt_re_dev *rdev)
 		dev_info(rdev_to_dev(rdev),
 			 "Couldn't get DB bar size, Low latency framework is disabled\n");
 	/* set register offsets for both UC and WC */
-	res->dpi_tbl.ucreg.offset = res->is_vf ? BNXT_QPLIB_DBR_VF_DB_OFFSET :
-						 BNXT_QPLIB_DBR_PF_DB_OFFSET;
+	if (bnxt_qplib_is_chip_gen_p7(cctx))
+		res->dpi_tbl.ucreg.offset = offset;
+	else
+		res->dpi_tbl.ucreg.offset = res->is_vf ? BNXT_QPLIB_DBR_VF_DB_OFFSET :
+							 BNXT_QPLIB_DBR_PF_DB_OFFSET;
 	res->dpi_tbl.wcreg.offset = res->dpi_tbl.ucreg.offset;
 
 	/* If WC mapping is disabled by L2 driver then en_dev->l2_db_size
@@ -1070,16 +1073,6 @@ static int bnxt_re_cqn_handler(struct bnxt_qplib_nq *nq,
 	return 0;
 }
 
-#define BNXT_RE_GEN_P5_PF_NQ_DB		0x10000
-#define BNXT_RE_GEN_P5_VF_NQ_DB		0x4000
-static u32 bnxt_re_get_nqdb_offset(struct bnxt_re_dev *rdev, u16 indx)
-{
-	return bnxt_qplib_is_chip_gen_p5_p7(rdev->chip_ctx) ?
-		(rdev->is_virtfn ? BNXT_RE_GEN_P5_VF_NQ_DB :
-				   BNXT_RE_GEN_P5_PF_NQ_DB) :
-				   rdev->en_dev->msix_entries[indx].db_offset;
-}
-
 static void bnxt_re_cleanup_res(struct bnxt_re_dev *rdev)
 {
 	int i;
@@ -1100,7 +1093,7 @@ static int bnxt_re_init_res(struct bnxt_re_dev *rdev)
 	bnxt_qplib_init_res(&rdev->qplib_res);
 
 	for (i = 1; i < rdev->num_msix ; i++) {
-		db_offt = bnxt_re_get_nqdb_offset(rdev, i);
+		db_offt = rdev->en_dev->msix_entries[i].db_offset;
 		rc = bnxt_qplib_enable_nq(rdev->en_dev->pdev, &rdev->nq[i - 1],
 					  i - 1, rdev->en_dev->msix_entries[i].vector,
 					  db_offt, &bnxt_re_cqn_handler,
@@ -1511,7 +1504,7 @@ static int bnxt_re_dev_init(struct bnxt_re_dev *rdev, u8 wqe_mode)
 		ibdev_err(&rdev->ibdev, "Failed to allocate CREQ: %#x\n", rc);
 		goto free_rcfw;
 	}
-	db_offt = bnxt_re_get_nqdb_offset(rdev, BNXT_RE_AEQ_IDX);
+	db_offt = rdev->en_dev->msix_entries[BNXT_RE_AEQ_IDX].db_offset;
 	vid = rdev->en_dev->msix_entries[BNXT_RE_AEQ_IDX].vector;
 	rc = bnxt_qplib_enable_rcfw_channel(&rdev->rcfw,
 					    vid, db_offt,
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index 2b73bb433b88c..7e550432ccb14 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -153,8 +153,9 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw,
 	attr->max_srq_sges = sb->max_srq_sge;
 	attr->max_pkey = 1;
 	attr->max_inline_data = le32_to_cpu(sb->max_inline_data);
-	attr->l2_db_size = (sb->l2_db_space_size + 1) *
-			    (0x01 << RCFW_DBR_BASE_PAGE_SHIFT);
+	if (!bnxt_qplib_is_chip_gen_p7(rcfw->res->cctx))
+		attr->l2_db_size = (sb->l2_db_space_size + 1) *
+				    (0x01 << RCFW_DBR_BASE_PAGE_SHIFT);
 	attr->max_sgid = BNXT_QPLIB_NUM_GIDS_SUPPORTED;
 	attr->dev_cap_flags = le16_to_cpu(sb->dev_cap_flags);
 
-- 
2.43.0



