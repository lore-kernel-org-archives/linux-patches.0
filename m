Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712BD248BA6;
	Wed, 15 Jan 2025 10:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937992; cv=none; b=SrhsXUs5v3XmVL8+WGK8VBiHWXrgUgYA0AIKuklTAmBM8AQMlFAlKUM+MbpywVL3Ha8WPNRWhNJCKOd5v+zdUgAMGzjnb7AAMqkRnnEAx1t4k7y4KDwjiMyHOvR5nnNnHp+PzP5EBECxCGz8ikLRyoA9LbRjoBwZ8PawmR4OVbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937992; c=relaxed/simple;
	bh=n8iaCfHkHvGAa71z3ois//jCMq6JwqRu+/gBTcb9lAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gLLySy6VYwOpnk+ikNtkqsxhU9ClZ4ZQPbZq/lqyoKb+TakVxWmoz1ZtgAcWPphkXO3zn2WCOnWJFpOJYZ9ELKzmm/PnaE7pGQTT2/A74RzHgD+O+mXU7YrQtQecs7jqt6TV3dRFBEx/z6WAuqvZCeYI6AZD2hctlkgIj7ZewYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zT4x3y0K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zT4x3y0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CBDC4CEDF;
	Wed, 15 Jan 2025 10:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937992;
	bh=n8iaCfHkHvGAa71z3ois//jCMq6JwqRu+/gBTcb9lAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zT4x3y0KzUlgp1afXHAtURPvg0ncCl6WChOctJfpIrxMun1FlanTqLIP4ByxgFhfl
	 LgmQAXjIy3vA+9KMQjfzAupE0KDx3XEFwUrH2XYNUIyeS931fSz4aEhnk0c1jl96tN
	 9fHny1J5uxB5TyfSxEi/IedGjLOtGmMGuNW1f3WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Lan <lanhao@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/189] net: hns3: fixed hclge_fetch_pf_reg accesses bar space out of bounds issue
Date: Wed, 15 Jan 2025 11:35:47 +0100
Message-ID: <20250115103608.389429790@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

From: Hao Lan <lanhao@huawei.com>

[ Upstream commit 7997ddd46c54408bcba5e37fe18b4d832e45d4d4 ]

The TQP BAR space is divided into two segments. TQPs 0-1023 and TQPs
1024-1279 are in different BAR space addresses. However,
hclge_fetch_pf_reg does not distinguish the tqp space information when
reading the tqp space information. When the number of TQPs is greater
than 1024, access bar space overwriting occurs.
The problem of different segments has been considered during the
initialization of tqp.io_base. Therefore, tqp.io_base is directly used
when the queue is read in hclge_fetch_pf_reg.

The error message:

Unable to handle kernel paging request at virtual address ffff800037200000
pc : hclge_fetch_pf_reg+0x138/0x250 [hclge]
lr : hclge_get_regs+0x84/0x1d0 [hclge]
Call trace:
 hclge_fetch_pf_reg+0x138/0x250 [hclge]
 hclge_get_regs+0x84/0x1d0 [hclge]
 hns3_get_regs+0x2c/0x50 [hns3]
 ethtool_get_regs+0xf4/0x270
 dev_ethtool+0x674/0x8a0
 dev_ioctl+0x270/0x36c
 sock_do_ioctl+0x110/0x2a0
 sock_ioctl+0x2ac/0x530
 __arm64_sys_ioctl+0xa8/0x100
 invoke_syscall+0x4c/0x124
 el0_svc_common.constprop.0+0x140/0x15c
 do_el0_svc+0x30/0xd0
 el0_svc+0x1c/0x2c
 el0_sync_handler+0xb0/0xb4
 el0_sync+0x168/0x180

Fixes: 939ccd107ffc ("net: hns3: move dump regs function to a separate file")
Signed-off-by: Hao Lan <lanhao@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/20250106143642.539698-7-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_regs.c  | 9 +++++----
 .../net/ethernet/hisilicon/hns3/hns3vf/hclgevf_regs.c    | 9 +++++----
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_regs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_regs.c
index 43c1c18fa81f..8c057192aae6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_regs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_regs.c
@@ -510,9 +510,9 @@ static int hclge_get_dfx_reg(struct hclge_dev *hdev, void *data)
 static int hclge_fetch_pf_reg(struct hclge_dev *hdev, void *data,
 			      struct hnae3_knic_private_info *kinfo)
 {
-#define HCLGE_RING_REG_OFFSET		0x200
 #define HCLGE_RING_INT_REG_OFFSET	0x4
 
+	struct hnae3_queue *tqp;
 	int i, j, reg_num;
 	int data_num_sum;
 	u32 *reg = data;
@@ -533,10 +533,11 @@ static int hclge_fetch_pf_reg(struct hclge_dev *hdev, void *data,
 	reg_num = ARRAY_SIZE(ring_reg_addr_list);
 	for (j = 0; j < kinfo->num_tqps; j++) {
 		reg += hclge_reg_get_tlv(HCLGE_REG_TAG_RING, reg_num, reg);
+		tqp = kinfo->tqp[j];
 		for (i = 0; i < reg_num; i++)
-			*reg++ = hclge_read_dev(&hdev->hw,
-						ring_reg_addr_list[i] +
-						HCLGE_RING_REG_OFFSET * j);
+			*reg++ = readl_relaxed(tqp->io_base -
+					       HCLGE_TQP_REG_OFFSET +
+					       ring_reg_addr_list[i]);
 	}
 	data_num_sum += (reg_num + HCLGE_REG_TLV_SPACE) * kinfo->num_tqps;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_regs.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_regs.c
index 6db415d8b917..7d9d9dbc7560 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_regs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_regs.c
@@ -123,10 +123,10 @@ int hclgevf_get_regs_len(struct hnae3_handle *handle)
 void hclgevf_get_regs(struct hnae3_handle *handle, u32 *version,
 		      void *data)
 {
-#define HCLGEVF_RING_REG_OFFSET		0x200
 #define HCLGEVF_RING_INT_REG_OFFSET	0x4
 
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
+	struct hnae3_queue *tqp;
 	int i, j, reg_um;
 	u32 *reg = data;
 
@@ -147,10 +147,11 @@ void hclgevf_get_regs(struct hnae3_handle *handle, u32 *version,
 	reg_um = ARRAY_SIZE(ring_reg_addr_list);
 	for (j = 0; j < hdev->num_tqps; j++) {
 		reg += hclgevf_reg_get_tlv(HCLGEVF_REG_TAG_RING, reg_um, reg);
+		tqp = &hdev->htqp[j].q;
 		for (i = 0; i < reg_um; i++)
-			*reg++ = hclgevf_read_dev(&hdev->hw,
-						  ring_reg_addr_list[i] +
-						  HCLGEVF_RING_REG_OFFSET * j);
+			*reg++ = readl_relaxed(tqp->io_base -
+					       HCLGEVF_TQP_REG_OFFSET +
+					       ring_reg_addr_list[i]);
 	}
 
 	reg_um = ARRAY_SIZE(tqp_intr_reg_addr_list);
-- 
2.39.5



