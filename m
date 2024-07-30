Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9811A76A5;
	Tue, 30 Jul 2024 17:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359483; cv=none; b=q1n/+SHDcOmOsiBRlsxD2b7+mXmouDHFotfjfpDHLRbnZP4qUsdsiVKJP7ogn/utSFQGeMTRmfjC1Gk8SwhHpSfVoeauU4Q6giFyXBMLj8ZFn6y8ZrPo/7xQvzYtkiYJnVBzdzQa3oC+JtVgjiux/5y4rt6bBofWsJFurJkbxw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359483; c=relaxed/simple;
	bh=ZDfKi6kLaSY1NRnxkHICKbDoNW/V5CGMFa3UG+yVPDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHH8oJzuSGAErvdT/GvnvI5p8eB5eSsNcumx2qhC22+6G3pyhSkP30GYVEUNS2vTXuiTJVooYitpTiG5Q0iPRPmjU9zE9zbkXRrGJcZMKhYNNwkr5VoMDCtUwLiu93n9aW47y5Lgcm+7XMrgjyB9rMWubIJxPBbqJAp66cR3Y0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pwMTewVa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pwMTewVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A01BC32782;
	Tue, 30 Jul 2024 17:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359482;
	bh=ZDfKi6kLaSY1NRnxkHICKbDoNW/V5CGMFa3UG+yVPDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwMTewVaGZNxPACw0zcGNElGdXboFBBdqN4df+p8uThhQltrE1BZ3ptw0Fpa0wcI7
	 Jeu8v7KmrWV37GZuWyUO7uBwS6T+rBTFQLoP+7EID5z1JrF1ySc0jXAqdO69joeyEk
	 GEAOOWsBBeHHQIZWax2QKNM1P2n1IUdeO4E5o2Tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 467/809] RDMA/hns: Fix mbx timing out before CMD execution is completed
Date: Tue, 30 Jul 2024 17:45:43 +0200
Message-ID: <20240730151743.179473617@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit bbddfa2255dd0800209697fd12378e02ed05f833 ]

When a large number of tasks are issued, the speed of HW processing
mbx will slow down. The standard for judging mbx timeout in the current
firmware is 30ms, and the current timeout standard for the driver is also
30ms.

Considering that firmware scheduling in multi-function scenarios takes a
certain amount of time, this will cause the driver to time out too early
and report a failure before mbx execution times out.

This patch introduces a new mechanism that can set different timeouts for
different cmds and extends the timeout of mbx to 35ms.

Fixes: a04ff739f2a9 ("RDMA/hns: Add command queue support for hip08 RoCE driver")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20240710133705.896445-9-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 35 +++++++++++++++++-----
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h |  6 ++++
 2 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index aecd137c1e605..621b057fb9daa 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1275,12 +1275,38 @@ static int hns_roce_cmd_err_convert_errno(u16 desc_ret)
 	return -EIO;
 }
 
+static u32 hns_roce_cmdq_tx_timeout(u16 opcode, u32 tx_timeout)
+{
+	static const struct hns_roce_cmdq_tx_timeout_map cmdq_tx_timeout[] = {
+		{HNS_ROCE_OPC_POST_MB, HNS_ROCE_OPC_POST_MB_TIMEOUT},
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(cmdq_tx_timeout); i++)
+		if (cmdq_tx_timeout[i].opcode == opcode)
+			return cmdq_tx_timeout[i].tx_timeout;
+
+	return tx_timeout;
+}
+
+static void hns_roce_wait_csq_done(struct hns_roce_dev *hr_dev, u16 opcode)
+{
+	struct hns_roce_v2_priv *priv = hr_dev->priv;
+	u32 tx_timeout = hns_roce_cmdq_tx_timeout(opcode, priv->cmq.tx_timeout);
+	u32 timeout = 0;
+
+	do {
+		if (hns_roce_cmq_csq_done(hr_dev))
+			break;
+		udelay(1);
+	} while (++timeout < tx_timeout);
+}
+
 static int __hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 			       struct hns_roce_cmq_desc *desc, int num)
 {
 	struct hns_roce_v2_priv *priv = hr_dev->priv;
 	struct hns_roce_v2_cmq_ring *csq = &priv->cmq.csq;
-	u32 timeout = 0;
 	u16 desc_ret;
 	u32 tail;
 	int ret;
@@ -1301,12 +1327,7 @@ static int __hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 
 	atomic64_inc(&hr_dev->dfx_cnt[HNS_ROCE_DFX_CMDS_CNT]);
 
-	do {
-		if (hns_roce_cmq_csq_done(hr_dev))
-			break;
-		udelay(1);
-	} while (++timeout < priv->cmq.tx_timeout);
-
+	hns_roce_wait_csq_done(hr_dev, le16_to_cpu(desc->opcode));
 	if (hns_roce_cmq_csq_done(hr_dev)) {
 		ret = 0;
 		for (i = 0; i < num; i++) {
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index def1d15a03c7e..c65f68a14a260 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -224,6 +224,12 @@ enum hns_roce_opcode_type {
 	HNS_SWITCH_PARAMETER_CFG			= 0x1033,
 };
 
+#define HNS_ROCE_OPC_POST_MB_TIMEOUT 35000
+struct hns_roce_cmdq_tx_timeout_map {
+	u16 opcode;
+	u32 tx_timeout;
+};
+
 enum {
 	TYPE_CRQ,
 	TYPE_CSQ,
-- 
2.43.0



