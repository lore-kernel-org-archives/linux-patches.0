Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDF425C717;
	Tue, 25 Mar 2025 12:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906266; cv=none; b=l2Yk5L8fcADf0hl7V6giqYWjQBqgmukUzM7rgCAFOuYkspA/MEg9rg39xqa2V/OgYyOCgScQdmuG8O4MaEMQVbCavOfU7ujoDozkbBkROt7wXr2qZnpgF90Awo0tFMkcR1ydC/+9q1I+eaqhCGpdyB5pU7F1oOg522dYi8scXHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906266; c=relaxed/simple;
	bh=VwjpwRIhCTv/ZioPtgsuMpd9KSNLU1bkI768yZQRc9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6iJd28it8tBrWHdy5rMvwxr/9uwsm2GVg7ITaTAjY5vc3J9LDjQNGS01/J2azUaEm/3OjCk5mqzLebfMagmYF60vc4ifA7Vm81NShuI3BW4byuju20AgAmUlyAlOSie8m7G5crHPlBuTHV9F/dIMNvfM+LoRhK9YUCENt97tkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ld+C7hHZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ld+C7hHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469C9C4CEE4;
	Tue, 25 Mar 2025 12:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906265;
	bh=VwjpwRIhCTv/ZioPtgsuMpd9KSNLU1bkI768yZQRc9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ld+C7hHZZz+MOXtZrmgGuaDXMHJ9rDZYHgioZZ7xFP/py9DMPfo/jil+SDJ2g3I8u
	 WDr5O2Sd2WzhpNtmatvElcMjkO4rQjBschyas0yGqyXZIiiUS6KhJ//DEbD1TNZ5Gt
	 8piHKEjq4Iq41JNwW9rMnO4T3f2gFCsbK4/5OfxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/116] RDMA/hns: Fix unmatched condition in error path of alloc_user_qp_db()
Date: Tue, 25 Mar 2025 08:21:52 -0400
Message-ID: <20250325122149.858106280@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit b9f59a24ba35a7d955a9f8e148dd9f85b7b40a01 ]

Currently the condition of unmapping sdb in error path is not exactly
the same as the condition of mapping in alloc_user_qp_db(). This may
cause a problem of unmapping an unmapped db in some case, such as
when the QP is XRC TGT. Unified the two conditions.

Fixes: 90ae0b57e4a5 ("RDMA/hns: Combine enable flags of qp")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250311084857.3803665-4-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 9e2e76c594063..a97348a1c61f1 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -868,12 +868,14 @@ static int alloc_user_qp_db(struct hns_roce_dev *hr_dev,
 			    struct hns_roce_ib_create_qp *ucmd,
 			    struct hns_roce_ib_create_qp_resp *resp)
 {
+	bool has_sdb = user_qp_has_sdb(hr_dev, init_attr, udata, resp, ucmd);
 	struct hns_roce_ucontext *uctx = rdma_udata_to_drv_context(udata,
 		struct hns_roce_ucontext, ibucontext);
+	bool has_rdb = user_qp_has_rdb(hr_dev, init_attr, udata, resp);
 	struct ib_device *ibdev = &hr_dev->ib_dev;
 	int ret;
 
-	if (user_qp_has_sdb(hr_dev, init_attr, udata, resp, ucmd)) {
+	if (has_sdb) {
 		ret = hns_roce_db_map_user(uctx, ucmd->sdb_addr, &hr_qp->sdb);
 		if (ret) {
 			ibdev_err(ibdev,
@@ -884,7 +886,7 @@ static int alloc_user_qp_db(struct hns_roce_dev *hr_dev,
 		hr_qp->en_flags |= HNS_ROCE_QP_CAP_SQ_RECORD_DB;
 	}
 
-	if (user_qp_has_rdb(hr_dev, init_attr, udata, resp)) {
+	if (has_rdb) {
 		ret = hns_roce_db_map_user(uctx, ucmd->db_addr, &hr_qp->rdb);
 		if (ret) {
 			ibdev_err(ibdev,
@@ -898,7 +900,7 @@ static int alloc_user_qp_db(struct hns_roce_dev *hr_dev,
 	return 0;
 
 err_sdb:
-	if (hr_qp->en_flags & HNS_ROCE_QP_CAP_SQ_RECORD_DB)
+	if (has_sdb)
 		hns_roce_db_unmap_user(uctx, &hr_qp->sdb);
 err_out:
 	return ret;
-- 
2.39.5



