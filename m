Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C72291C1F;
	Tue, 12 Aug 2025 18:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024438; cv=none; b=BzJ6M/3lmPlc+wd4njPD+Z8XdDFXxYKmQ9Cvdt6EQwKamTSuOVnPHVqOl5tYCvIBUlaZMcnaCt5n8ALNWeWvMBX5U4bkYli5OsDbzN8lBnJzZIt/NdpXVS+K4H/NrcFk51zirp7XCKdPCpE20HXNSW2uaDEOt44nKGcI292f+Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024438; c=relaxed/simple;
	bh=tEwGpfg+0keHRb2IY7IC/fL7ekGEsbiLdcMeLCEDUuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCxmP7pEXbzD3ckV4Ceg0D67N/6EXJHOJRmk62BwzZN2/o/1Z0cKuqjO3ghKyQF7zo3gncma/oSCmj94Af+5C7N59D8e6ld+wxZ02EHpDjFkyUrvdV01DtVPSLa6IH+mMV8LtU3Xen5h3y4/9HLW9A4HXM32jDU4nWXzuaaQ87A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGf8LKJw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGf8LKJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FB8C4CEF0;
	Tue, 12 Aug 2025 18:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024437;
	bh=tEwGpfg+0keHRb2IY7IC/fL7ekGEsbiLdcMeLCEDUuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGf8LKJwrnPfArgZfHJtOZIg5iKCRiRj91lRmh5N9hcxmFtAOoJFIeHdf2oHMCrJT
	 PGDulJBL9HrEAXp7wM/sQ2FP9EoVgPHE+NHab1o30Y8Ih2f3sxRNtm6Gb/AydwPJpn
	 1Cudloz0PDRpNBNAjPcA+TXStHqqnZlA6tfz/lBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 373/627] RDMA/hns: Fix -Wframe-larger-than issue
Date: Tue, 12 Aug 2025 19:31:08 +0200
Message-ID: <20250812173433.494080418@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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
index 246642859159..b30dce00f240 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5387,11 +5387,10 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
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
@@ -5402,7 +5401,11 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
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
@@ -5444,6 +5447,8 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
 		clear_qp(hr_qp);
 
 out:
+	kvfree(qpc_mask);
+	kvfree(context);
 	return ret;
 }
 
-- 
2.39.5



