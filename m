Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90961C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:21:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F3CC433EF;
	Wed, 28 Dec 2022 16:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244470;
	bh=XxLKgFgoNcQp7be6upQ841LFm2YS2BxHL6FXiJeiwFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gqST3ZBQ/+ly/HwRLlSDsSqwdBnC2G3fiI0XyffHpG+JNFOPYm2I6W55NgSu2Xj+4
	 iGZ7RFHYso1atz7mKZHkFtNlgKc2/t0bLledvs639Gxywuo2GcFknMWP6u5jr38T5Q
	 eMmM7OxsO6kq7UEF2bFoEcvOCTWbmHsok1A8+pSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Haoyue Xu <xuhaoyue1@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0675/1146] RDMA/hns: Fix error code of CMD
Date: Wed, 28 Dec 2022 15:36:54 +0100
Message-Id: <20221228144348.481515361@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 667d6164b84884c64de3fc18670cd5a98b0b10cf ]

The error code is fixed to EIO when CMD fails to excute. This patch
converts the error status reported by firmware to linux errno.

Fixes: a04ff739f2a9 ("RDMA/hns: Add command queue support for hip08 RoCE driver")
Link: https://lore.kernel.org/r/20221126102911.2921820-6-xuhaoyue1@hisilicon.com
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 26 +++++++++++++++++++++-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h |  5 +++++
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index fbdaf95fd82b..d21c23bcc0de 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1273,6 +1273,30 @@ static void update_cmdq_status(struct hns_roce_dev *hr_dev)
 		hr_dev->cmd.state = HNS_ROCE_CMDQ_STATE_FATAL_ERR;
 }
 
+static int hns_roce_cmd_err_convert_errno(u16 desc_ret)
+{
+	struct hns_roce_cmd_errcode errcode_table[] = {
+		{CMD_EXEC_SUCCESS, 0},
+		{CMD_NO_AUTH, -EPERM},
+		{CMD_NOT_EXIST, -EOPNOTSUPP},
+		{CMD_CRQ_FULL, -EXFULL},
+		{CMD_NEXT_ERR, -ENOSR},
+		{CMD_NOT_EXEC, -ENOTBLK},
+		{CMD_PARA_ERR, -EINVAL},
+		{CMD_RESULT_ERR, -ERANGE},
+		{CMD_TIMEOUT, -ETIME},
+		{CMD_HILINK_ERR, -ENOLINK},
+		{CMD_INFO_ILLEGAL, -ENXIO},
+		{CMD_INVALID, -EBADR},
+	};
+	u16 i;
+
+	for (i = 0; i < ARRAY_SIZE(errcode_table); i++)
+		if (desc_ret == errcode_table[i].return_status)
+			return errcode_table[i].errno;
+	return -EIO;
+}
+
 static int __hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 			       struct hns_roce_cmq_desc *desc, int num)
 {
@@ -1318,7 +1342,7 @@ static int __hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 			dev_err_ratelimited(hr_dev->dev,
 					    "Cmdq IO error, opcode = 0x%x, return = 0x%x.\n",
 					    desc->opcode, desc_ret);
-			ret = -EIO;
+			ret = hns_roce_cmd_err_convert_errno(desc_ret);
 		}
 	} else {
 		/* FW/HW reset or incorrect number of desc */
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 6d23c8617e0f..b1b3e1e0b84e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -272,6 +272,11 @@ enum hns_roce_cmd_return_status {
 	CMD_OTHER_ERR = 0xff
 };
 
+struct hns_roce_cmd_errcode {
+	enum hns_roce_cmd_return_status return_status;
+	int errno;
+};
+
 enum hns_roce_sgid_type {
 	GID_TYPE_FLAG_ROCE_V1 = 0,
 	GID_TYPE_FLAG_ROCE_V2_IPV4,
-- 
2.35.1



