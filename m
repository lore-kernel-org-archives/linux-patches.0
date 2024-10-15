Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E69F1D4154;
	Tue, 15 Oct 2024 11:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992977; cv=none; b=YccR3wk/njJW8tydSCMypEDcV/wEoeSiWtpyAxQ7+/LQtk47rVV+6sv8DL6/Dhkj2dsKOnzSOmD8gwi8yTEIJv5Lq7EfV/c3TFX6RhJKf/vSjfwGbR0MMhce34BpM3my+XtbNcjDXfLmSb7QNU6OLgyP0tzNlyaUww6bMEzgGLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992977; c=relaxed/simple;
	bh=W3QA+xMMDOIZVD9snfutT8C5UgyjX2bxor2/aEzlSMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RI/78XUs3dtayvSwachOwTrHenBBL0y544hhcuz/v3RU5dSvi43q+HAC/VaAAazcasWIs92sv1hZP5NwbBEB3PHc9dFswEz01EBzZs4rq9BkQCFMaIn/AkcqtEO7fTzbFzyEB+GbyfHhHKNqWr6972R+9CRysJL8zKrrmse6j6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VpltME4L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VpltME4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9A4C4CEC6;
	Tue, 15 Oct 2024 11:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992977;
	bh=W3QA+xMMDOIZVD9snfutT8C5UgyjX2bxor2/aEzlSMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VpltME4L9xHZj2KFOo+0tyu/86svB9D+buK4WiRxOJPDDtX7r1hs7UM/RA8OFPD2V
	 K5k77JGChYgdBlCIp8r9GFtOmnBAZHBH7pk0pUhsOkHA/L1/NaWQOc3hwnnC822m1U
	 QARTfpF1nfcwEWjdLjQCu3NdYTjQOfX6fGNyXiCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 247/691] RDMA/hns: Dont modify rq next block addr in HIP09 QPC
Date: Tue, 15 Oct 2024 13:23:15 +0200
Message-ID: <20241015112450.157262275@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 6928d264e328e0cb5ee7663003a6e46e4cba0a7e ]

The field 'rq next block addr' in QPC can be updated by driver only
on HIP08. On HIP09 HW updates this field while driver is not allowed.

Fixes: 926a01dc000d ("RDMA/hns: Add QP operations support for hip08 SoC")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20240906093444.3571619-2-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 3cd65bcca2240..7aaf7d5be91b0 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4228,12 +4228,14 @@ static int config_qp_rq_buf(struct hns_roce_dev *hr_dev,
 		     upper_32_bits(to_hr_hw_page_addr(mtts[0])));
 	hr_reg_clear(qpc_mask, QPC_RQ_CUR_BLK_ADDR_H);
 
-	context->rq_nxt_blk_addr = cpu_to_le32(to_hr_hw_page_addr(mtts[1]));
-	qpc_mask->rq_nxt_blk_addr = 0;
-
-	hr_reg_write(context, QPC_RQ_NXT_BLK_ADDR_H,
-		     upper_32_bits(to_hr_hw_page_addr(mtts[1])));
-	hr_reg_clear(qpc_mask, QPC_RQ_NXT_BLK_ADDR_H);
+	if (hr_dev->pci_dev->revision == PCI_REVISION_ID_HIP08) {
+		context->rq_nxt_blk_addr =
+				cpu_to_le32(to_hr_hw_page_addr(mtts[1]));
+		qpc_mask->rq_nxt_blk_addr = 0;
+		hr_reg_write(context, QPC_RQ_NXT_BLK_ADDR_H,
+			     upper_32_bits(to_hr_hw_page_addr(mtts[1])));
+		hr_reg_clear(qpc_mask, QPC_RQ_NXT_BLK_ADDR_H);
+	}
 
 	return 0;
 }
-- 
2.43.0



