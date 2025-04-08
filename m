Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0503E263C6D;
	Tue,  8 Apr 2025 11:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112597; cv=none; b=a/87bRRSvrcQmkS3fRxMF7HGI9WVEcYn7cnyerxk4h0aZSGVBoPZSWyuUZchcSTlOlVoCZl+nzKl0culpcf6wzCXxvtsY/PI9F27PSJQiBaZ2T//zls270cPCY2K3k6RLm++k5Hg72BtPNj6ysdr2cxIg6FpqITfz8t+0qHgU10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112597; c=relaxed/simple;
	bh=moJzFv9xhMnZ+Oot/Gvmczgonsc43d8FqM9ccveTgfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OUedL7ZhdzzDjjKcD5w8NmT1xg1Cw/zFj+qNisGbLZ1NrYDFX912P5+pAdF3Yp0Ez20zw0Am4mviou2GHEikSpAzoF8qP/yLuZiMq/Tk7QOTfkJl+xlPNmtQhx4TdM1V07FtLzQRTs6N08cHJRcGZ2LKQ3DI64znXajieljdSa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VgKByXoo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VgKByXoo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EBCC4CEE5;
	Tue,  8 Apr 2025 11:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112596;
	bh=moJzFv9xhMnZ+Oot/Gvmczgonsc43d8FqM9ccveTgfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VgKByXooelFRtdAxNNWKWxdnebyBpmfIj3lwmDKVO3gvB6eek0xoW+pSaXhItAp6H
	 D641I3tn8D3sINrDBcVyoG1mWG3EDhx1ttyLXI8QPDuTTfY1msUWYa2IY3nxJAOgnJ
	 rogsdndfs8S20NcbQsNIa4gr/VuP00MUcQTsnUm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/279] RDMA/hns: Fix unmatched condition in error path of alloc_user_qp_db()
Date: Tue,  8 Apr 2025 12:47:50 +0200
Message-ID: <20250408104828.694446065@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ff019e32c4552..d7f620eb4f21d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -842,12 +842,14 @@ static int alloc_user_qp_db(struct hns_roce_dev *hr_dev,
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
@@ -858,7 +860,7 @@ static int alloc_user_qp_db(struct hns_roce_dev *hr_dev,
 		hr_qp->en_flags |= HNS_ROCE_QP_CAP_SQ_RECORD_DB;
 	}
 
-	if (user_qp_has_rdb(hr_dev, init_attr, udata, resp)) {
+	if (has_rdb) {
 		ret = hns_roce_db_map_user(uctx, ucmd->db_addr, &hr_qp->rdb);
 		if (ret) {
 			ibdev_err(ibdev,
@@ -872,7 +874,7 @@ static int alloc_user_qp_db(struct hns_roce_dev *hr_dev,
 	return 0;
 
 err_sdb:
-	if (hr_qp->en_flags & HNS_ROCE_QP_CAP_SQ_RECORD_DB)
+	if (has_sdb)
 		hns_roce_db_unmap_user(uctx, &hr_qp->sdb);
 err_out:
 	return ret;
-- 
2.39.5



