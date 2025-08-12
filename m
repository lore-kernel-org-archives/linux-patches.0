Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0576E2FA0DB;
	Tue, 12 Aug 2025 17:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021461; cv=none; b=AGcpwCx5/+jxaU7vGgAiEEBcd60uTEtMwdEWZHluDMCiOKepon/hWKqJdLcxFbMZTmQht1+eXnvOta9n/D/GN3ciHR8TfSER1LvcvXd83WPKLjK1WWSNRwqVP6SLOmBbVubvTu0Pi/Xa4RJ1Cq/HrT2Fy0n/7WAdXQCS3WFwI0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021461; c=relaxed/simple;
	bh=LSU0lLncE/2aXerBj+6IDh7UwofKF6ZQIb+pKkF3PZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQiVwrvPBnKItN6vQKRsYVyMS7zZEGXjab6I9yvp9d/BpS59AVx+3xZ968NIC8/x2AvxiEDYYGNag7OmUM/4kp4N7RIbfatVObPCBa3ItaViSaCFoTefpfnL1L+6bqTNCrTzZSFRfCh6UrMCn0R35UI8urulwoDrcpwzfP/BQdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pf5rkfxu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pf5rkfxu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DF8C4CEF0;
	Tue, 12 Aug 2025 17:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021460;
	bh=LSU0lLncE/2aXerBj+6IDh7UwofKF6ZQIb+pKkF3PZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pf5rkfxuI4p+4J3++CUQi27aaAw5IHCDgKPKipwQJkiSeBtDmKgbbhvSgZyuBvI+r
	 T6zUd1F66iloEs8F//jvUochNR+Bv2Y8EBWrSLIDfH4DViLJ5EXrXuJ8F/FP2+RNIh
	 86Z8n1PVCNMJZ5yVJ8tZJ0KqEquakLNMc2fm4Zec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/262] RDMA/hns: Fix -Wframe-larger-than issue
Date: Tue, 12 Aug 2025 19:28:38 +0200
Message-ID: <20250812172958.641475787@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 79d56805c5068f2bc81518043e043c3dedd1c82a ]

Fix -Wframe-larger-than issue by allocating memory for qpc struct
with kzalloc() instead of using stack memory.

Fixes: 606bf89e98ef ("RDMA/hns: Refactor for hns_roce_v2_modify_qp function")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506240032.CSgIyFct-lkp@intel.com/
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250703113905.3597124-7-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 9d23d4b5c128..4a10b826d15a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5192,11 +5192,10 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
 {
 	struct hns_roce_dev *hr_dev = to_hr_dev(ibqp->device);
 	struct hns_roce_qp *hr_qp = to_hr_qp(ibqp);
-	struct hns_roce_v2_qp_context ctx[2];
-	struct hns_roce_v2_qp_context *context = ctx;
-	struct hns_roce_v2_qp_context *qpc_mask = ctx + 1;
+	struct hns_roce_v2_qp_context *context;
+	struct hns_roce_v2_qp_context *qpc_mask;
 	struct ib_device *ibdev = &hr_dev->ib_dev;
-	int ret;
+	int ret = -ENOMEM;
 
 	if (attr_mask & ~IB_QP_ATTR_STANDARD_BITS)
 		return -EOPNOTSUPP;
@@ -5207,7 +5206,11 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
 	 * we should set all bits of the relevant fields in context mask to
 	 * 0 at the same time, else set them to 0x1.
 	 */
-	memset(context, 0, hr_dev->caps.qpc_sz);
+	context = kvzalloc(sizeof(*context), GFP_KERNEL);
+	qpc_mask = kvzalloc(sizeof(*qpc_mask), GFP_KERNEL);
+	if (!context || !qpc_mask)
+		goto out;
+
 	memset(qpc_mask, 0xff, hr_dev->caps.qpc_sz);
 
 	ret = hns_roce_v2_set_abs_fields(ibqp, attr, attr_mask, cur_state,
@@ -5249,6 +5252,8 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
 		clear_qp(hr_qp);
 
 out:
+	kvfree(qpc_mask);
+	kvfree(context);
 	return ret;
 }
 
-- 
2.39.5



