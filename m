Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A6DC121
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62981C433C8;
	Mon, 11 Sep 2023 14:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441719;
	bh=hEOefDd+0p0k5EHjhSVOo4GHwRXGPY0eUMVMH11QJxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Idu2EFwh8KvVfwSpWM/tlQwQexrO++vxILt9GMd6iJ6zsVl1RDiLE9d8obazIlh+B
	 6ZXG0JUr/XzbPfxdf4Hxit9tHAUFghAd9u0DUIxmOLOzpAwN/kC0D3aeHC0ZUTJJTT
	 2tTW+LEry6QFRAPjGrdU0uSiXR94o0BFySXpAYIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 512/739] RDMA/bnxt_re: Fix max_qp count for virtual functions
Date: Mon, 11 Sep 2023 15:45:11 +0200
Message-ID: <20230911134705.424871527@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit f19fba1f79dc1fb298de7dcbaae9f6299381aeea ]

Driver has not accounted QP1 for virtual functions
when fetching device attributes and hence max_qp
count is one less than active_qp count. Fixed driver
so that it counts QP1 for virtual functions as well
while fetching device attributes

Fixes: ccd9d0d3dffc ("RDMA/bnxt_re: Enable RoCE on virtual functions")
Signed-off-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://lore.kernel.org/r/1691052326-32143-2-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/main.c     | 6 ++----
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 7 +++----
 drivers/infiniband/hw/bnxt_re/qplib_sp.h | 2 +-
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 4bf2752e7b466..3e6fbc39eeb11 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -1025,8 +1025,7 @@ static int bnxt_re_alloc_res(struct bnxt_re_dev *rdev)
 
 	/* Configure and allocate resources for qplib */
 	rdev->qplib_res.rcfw = &rdev->rcfw;
-	rc = bnxt_qplib_get_dev_attr(&rdev->rcfw, &rdev->dev_attr,
-				     rdev->is_virtfn);
+	rc = bnxt_qplib_get_dev_attr(&rdev->rcfw, &rdev->dev_attr);
 	if (rc)
 		goto fail;
 
@@ -1407,8 +1406,7 @@ static int bnxt_re_dev_init(struct bnxt_re_dev *rdev, u8 wqe_mode)
 			rdev->pacing.dbr_pacing = false;
 		}
 	}
-	rc = bnxt_qplib_get_dev_attr(&rdev->rcfw, &rdev->dev_attr,
-				     rdev->is_virtfn);
+	rc = bnxt_qplib_get_dev_attr(&rdev->rcfw, &rdev->dev_attr);
 	if (rc)
 		goto disable_rcfw;
 
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index ab45f9d4bb02f..7a244fd506e2a 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -89,7 +89,7 @@ static void bnxt_qplib_query_version(struct bnxt_qplib_rcfw *rcfw,
 }
 
 int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw,
-			    struct bnxt_qplib_dev_attr *attr, bool vf)
+			    struct bnxt_qplib_dev_attr *attr)
 {
 	struct creq_query_func_resp resp = {};
 	struct bnxt_qplib_cmdqmsg msg = {};
@@ -121,9 +121,8 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw,
 
 	/* Extract the context from the side buffer */
 	attr->max_qp = le32_to_cpu(sb->max_qp);
-	/* max_qp value reported by FW for PF doesn't include the QP1 for PF */
-	if (!vf)
-		attr->max_qp += 1;
+	/* max_qp value reported by FW doesn't include the QP1 */
+	attr->max_qp += 1;
 	attr->max_qp_rd_atom =
 		sb->max_qp_rd_atom > BNXT_QPLIB_MAX_OUT_RD_ATOM ?
 		BNXT_QPLIB_MAX_OUT_RD_ATOM : sb->max_qp_rd_atom;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.h b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
index 264ef3cedc45b..d33c78b96217a 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
@@ -322,7 +322,7 @@ int bnxt_qplib_update_sgid(struct bnxt_qplib_sgid_tbl *sgid_tbl,
 			   struct bnxt_qplib_gid *gid, u16 gid_idx,
 			   const u8 *smac);
 int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw,
-			    struct bnxt_qplib_dev_attr *attr, bool vf);
+			    struct bnxt_qplib_dev_attr *attr);
 int bnxt_qplib_set_func_resources(struct bnxt_qplib_res *res,
 				  struct bnxt_qplib_rcfw *rcfw,
 				  struct bnxt_qplib_ctx *ctx);
-- 
2.40.1



