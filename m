Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304551AC450;
	Mon, 14 Oct 2024 15:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918093; cv=none; b=dz7F7EvrKSPhHJat3bxTcexkjozMS/MCItIIIoHzkRo12sxa1Vk0uMUll4kio/yEe3LLH+UKD56MTz6c8D9QXx8qe6Z+ar/3lHAag4ELtY5kCybgXH26mIdR5eDxpmscUyfknLb5z2QbLFc+tJ8UhWRBOkedUN/6U3FjQf7jKaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918093; c=relaxed/simple;
	bh=TELaisNKnxkwo7U0BIwXSI0ACiPFWv7IdjjRIHSg9GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFPnSBVv83j5toFAybbuaqwmVP2sR6Og9oRvj7H7OoDYduELEQlRe6Tjtx24Vt0b/LsTxHY7d6CT2UOmhTBPFdFFs67zvL4SZTvPv4YoWol73grItC2ES2cAMYM4rdP3QNSr4Z+LNetPc/7FZXRVnPaud4XDkM5dVV+9BfoxolI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EjkNo0vp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EjkNo0vp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC11C4CEC3;
	Mon, 14 Oct 2024 15:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918093;
	bh=TELaisNKnxkwo7U0BIwXSI0ACiPFWv7IdjjRIHSg9GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjkNo0vp1LQl2+kWfBb565cTBFHAeJQW2J7N/4Sps0ezzEC1nuPJYgwoc5fwo3YWo
	 lGXPKWRoJqXNiWYj/gf/zxiOPKfSIKgSW+bRC5dEr/UmtBgUBETel71npqL9kg0+SV
	 IhNFkQpagqGRrj9YYKhIwx23TLvccsaqUZEMtjTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 219/798] RDMA/hns: Dont modify rq next block addr in HIP09 QPC
Date: Mon, 14 Oct 2024 16:12:53 +0200
Message-ID: <20241014141226.533402005@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c4521ab66ee45..3318d27233e0d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4572,12 +4572,14 @@ static int config_qp_rq_buf(struct hns_roce_dev *hr_dev,
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



