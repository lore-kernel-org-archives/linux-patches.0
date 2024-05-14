Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E58F9D4;
	Tue, 14 May 2024 11:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687838; cv=none; b=RKUbWlcjj0FvOKHw4Z6wpZMYAR0YZ1vG4IQ3HiMYhs7xL94eHsATvJKF9JMr107zVzW2Mb/MhfD4Oljf/mwuJKY1PLBtC0JuUkM76FFsseFXXiTJ42LMJxm406RJWO9W6RPA1pAbgkKUTdAyD0nTS0hKL/YesojVtnsFoy7VybM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687838; c=relaxed/simple;
	bh=8vX5JLfIdpdcUPJoL1SA10ptrQvIccUHeRNUsv+SX6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z16djIVyVOBwDjUPYFMzZRg3qCJw8huNGhAtZV/J/1H4j5pKiqY+IxzjoFN1kHB28xrf/GAhNMVMyKusqxHfTc6Urldt9ywFDkMfO324qlieJHrGMy8RmG9RvlTnXT0iif0wiV4A1vGSfXM9hWgzfHAnMDOfnBUaV52pyeGm6Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iGVyNzGX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iGVyNzGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4A3C32781;
	Tue, 14 May 2024 11:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687838;
	bh=8vX5JLfIdpdcUPJoL1SA10ptrQvIccUHeRNUsv+SX6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGVyNzGXkfaSw/R5W65/Iqkt1CU2vTXnjDIQaNQCqrzZUyIFGBwJ7tdJKWbxpjeUW
	 ERzYwXATwDl+JqinFcvnheZo8O7vK5t2tQGhHBgAdl5nbTZxbLb/Ev6Czyud4T/ZyS
	 U3z4B6H/Qr/1/+XFPxlt+3wWKYNTOBNDYdfEWnP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Guangbin Huang <huangguangbin2@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/168] net: hns3: create new cmdq hardware description structure hclge_comm_hw
Date: Tue, 14 May 2024 12:20:21 +0200
Message-ID: <20240514101011.327603146@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

From: Jie Wang <wangjie125@huawei.com>

[ Upstream commit 0a7b6d221868be6aa3249c70ffab707a265b89d6 ]

Currently PF and VF cmdq APIs use struct hclge(vf)_hw to describe cmdq
hardware information needed by hclge(vf)_cmd_send. There are a little
differences between its child struct hclge_cmq_ring and hclgevf_cmq_ring.
It is redundent to use two sets of structures to support same functions.

So this patch creates new set of common cmdq hardware description
structures(hclge_comm_hw) to unify PF and VF cmdq functions. The struct
hclge_desc is still kept to avoid too many meaningless replacement.

These new structures will be used to unify hclge(vf)_hw structures in PF
and VF cmdq APIs in next patches.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 6639a7b95321 ("net: hns3: change type of numa_node_mask as nodemask_t")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/Makefile  |  1 +
 .../hns3/hns3_common/hclge_comm_cmd.h         | 55 +++++++++++++++++++
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |  9 +--
 3 files changed, 57 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h

diff --git a/drivers/net/ethernet/hisilicon/hns3/Makefile b/drivers/net/ethernet/hisilicon/hns3/Makefile
index 32e24e0945f5e..33e546cef2881 100644
--- a/drivers/net/ethernet/hisilicon/hns3/Makefile
+++ b/drivers/net/ethernet/hisilicon/hns3/Makefile
@@ -6,6 +6,7 @@
 ccflags-y += -I$(srctree)/$(src)
 ccflags-y += -I$(srctree)/drivers/net/ethernet/hisilicon/hns3/hns3pf
 ccflags-y += -I$(srctree)/drivers/net/ethernet/hisilicon/hns3/hns3vf
+ccflags-y += -I$(srctree)/drivers/net/ethernet/hisilicon/hns3/hns3_common
 
 obj-$(CONFIG_HNS3) += hnae3.o
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
new file mode 100644
index 0000000000000..f1e39003ceebe
--- /dev/null
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+// Copyright (c) 2021-2021 Hisilicon Limited.
+
+#ifndef __HCLGE_COMM_CMD_H
+#define __HCLGE_COMM_CMD_H
+#include <linux/types.h>
+
+#include "hnae3.h"
+
+#define HCLGE_DESC_DATA_LEN		6
+struct hclge_desc {
+	__le16 opcode;
+	__le16 flag;
+	__le16 retval;
+	__le16 rsv;
+	__le32 data[HCLGE_DESC_DATA_LEN];
+};
+
+struct hclge_comm_cmq_ring {
+	dma_addr_t desc_dma_addr;
+	struct hclge_desc *desc;
+	struct pci_dev *pdev;
+	u32 head;
+	u32 tail;
+
+	u16 buf_size;
+	u16 desc_num;
+	int next_to_use;
+	int next_to_clean;
+	u8 ring_type; /* cmq ring type */
+	spinlock_t lock; /* Command queue lock */
+};
+
+enum hclge_comm_cmd_status {
+	HCLGE_COMM_STATUS_SUCCESS	= 0,
+	HCLGE_COMM_ERR_CSQ_FULL		= -1,
+	HCLGE_COMM_ERR_CSQ_TIMEOUT	= -2,
+	HCLGE_COMM_ERR_CSQ_ERROR	= -3,
+};
+
+struct hclge_comm_cmq {
+	struct hclge_comm_cmq_ring csq;
+	struct hclge_comm_cmq_ring crq;
+	u16 tx_timeout;
+	enum hclge_comm_cmd_status last_status;
+};
+
+struct hclge_comm_hw {
+	void __iomem *io_base;
+	void __iomem *mem_base;
+	struct hclge_comm_cmq cmq;
+	unsigned long comm_state;
+};
+
+#endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index cfbb7c51b0cb3..e07709ef239df 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -7,24 +7,17 @@
 #include <linux/io.h>
 #include <linux/etherdevice.h>
 #include "hnae3.h"
+#include "hclge_comm_cmd.h"
 
 #define HCLGE_CMDQ_TX_TIMEOUT		30000
 #define HCLGE_CMDQ_CLEAR_WAIT_TIME	200
 #define HCLGE_DESC_DATA_LEN		6
 
 struct hclge_dev;
-struct hclge_desc {
-	__le16 opcode;
 
 #define HCLGE_CMDQ_RX_INVLD_B		0
 #define HCLGE_CMDQ_RX_OUTVLD_B		1
 
-	__le16 flag;
-	__le16 retval;
-	__le16 rsv;
-	__le32 data[HCLGE_DESC_DATA_LEN];
-};
-
 struct hclge_cmq_ring {
 	dma_addr_t desc_dma_addr;
 	struct hclge_desc *desc;
-- 
2.43.0



