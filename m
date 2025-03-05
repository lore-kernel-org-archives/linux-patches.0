Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10EC17B505;
	Wed,  5 Mar 2025 18:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197951; cv=none; b=PifnxKr6ffgTtSFJneaPch+pxh+VPpS/TSOWhhfUHF4O6eax8KWqoh2+0KfkwiwefEWOV2Q6aaFcufc5LdR6GTOjW30RELdZSmgeBw4lCUt9YMriv+IjrilDdEfXWtkQf/r0X+S391KCT9KMc1LHgMQIf7oeSl3P2xRwZES+qhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197951; c=relaxed/simple;
	bh=SwvMYRJ4ELxK6PNoWmCQILpyeSCf7E/pImI2M7AK60c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcp+yj+9as0nE1XSVeOlKiWKev0w4XQLBclQ6CI0fM5iKAWRywU8qqxRV4j1godtlTOtbvUyE9LyPPIHnTfTnei0o1w6A49u4AyX54ytGvv1/gWnPNHkooAOKXu11QOTFVGa5YIEcXxreZctUp24x7UcwpiVJ52Gbce6sterxuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HYUjiC0x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HYUjiC0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27575C4CED1;
	Wed,  5 Mar 2025 18:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197951;
	bh=SwvMYRJ4ELxK6PNoWmCQILpyeSCf7E/pImI2M7AK60c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HYUjiC0xX21Lsh9fylLgivj8QKrsfsssnOIi2MG7RZ6XEBoI7sJG9FTZswh1SYVig
	 AI+X0izryFgLSB12JZwvwbBHSzTpMg0BH0505L5sY6DgNS+R/3awdwWrNiMwN27c1m
	 0aLjgT0JpRF+kA30xFqN/KKEMzvfPMjT0q+JZYns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/150] RDMA/hns: Fix mbox timing out by adding retry mechanism
Date: Wed,  5 Mar 2025 18:47:15 +0100
Message-ID: <20250305174504.062863432@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

[ Upstream commit 9747c0c7791d4a5a62018a0c9c563dd2e6f6c1c0 ]

If a QP is modified to error state and a flush CQE process is triggered,
the subsequent QP destruction mbox can still be successfully posted but
will be blocked in HW until the flush CQE process finishes. This causes
further mbox posting timeouts in driver. The blocking time is related
to QP depth. Considering an extreme case where SQ depth and RQ depth
are both 32K, the blocking time can reach about 135ms.

This patch adds a retry mechanism for mbox posting. For each try, FW
waits 15ms for HW to complete the previous mbox, otherwise return a
timeout error code to driver. Counting other time consumption in FW,
set 8 tries for mbox posting and a 5ms time gap before each retry to
increase to a sufficient timeout limit.

Fixes: 0425e3e6e0c7 ("RDMA/hns: Support flush cqe for hip08 in kernel space")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250208105930.522796-1-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 64 ++++++++++++++++------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h |  2 +
 2 files changed, 50 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 0144e7210d05a..f5c3e560df58d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1286,10 +1286,8 @@ static u32 hns_roce_cmdq_tx_timeout(u16 opcode, u32 tx_timeout)
 	return tx_timeout;
 }
 
-static void hns_roce_wait_csq_done(struct hns_roce_dev *hr_dev, u16 opcode)
+static void hns_roce_wait_csq_done(struct hns_roce_dev *hr_dev, u32 tx_timeout)
 {
-	struct hns_roce_v2_priv *priv = hr_dev->priv;
-	u32 tx_timeout = hns_roce_cmdq_tx_timeout(opcode, priv->cmq.tx_timeout);
 	u32 timeout = 0;
 
 	do {
@@ -1299,8 +1297,9 @@ static void hns_roce_wait_csq_done(struct hns_roce_dev *hr_dev, u16 opcode)
 	} while (++timeout < tx_timeout);
 }
 
-static int __hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
-			       struct hns_roce_cmq_desc *desc, int num)
+static int __hns_roce_cmq_send_one(struct hns_roce_dev *hr_dev,
+				   struct hns_roce_cmq_desc *desc,
+				   int num, u32 tx_timeout)
 {
 	struct hns_roce_v2_priv *priv = hr_dev->priv;
 	struct hns_roce_v2_cmq_ring *csq = &priv->cmq.csq;
@@ -1309,8 +1308,6 @@ static int __hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 	int ret;
 	int i;
 
-	spin_lock_bh(&csq->lock);
-
 	tail = csq->head;
 
 	for (i = 0; i < num; i++) {
@@ -1324,22 +1321,17 @@ static int __hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 
 	atomic64_inc(&hr_dev->dfx_cnt[HNS_ROCE_DFX_CMDS_CNT]);
 
-	hns_roce_wait_csq_done(hr_dev, le16_to_cpu(desc->opcode));
+	hns_roce_wait_csq_done(hr_dev, tx_timeout);
 	if (hns_roce_cmq_csq_done(hr_dev)) {
 		ret = 0;
 		for (i = 0; i < num; i++) {
 			/* check the result of hardware write back */
-			desc[i] = csq->desc[tail++];
+			desc_ret = le16_to_cpu(csq->desc[tail++].retval);
 			if (tail == csq->desc_num)
 				tail = 0;
-
-			desc_ret = le16_to_cpu(desc[i].retval);
 			if (likely(desc_ret == CMD_EXEC_SUCCESS))
 				continue;
 
-			dev_err_ratelimited(hr_dev->dev,
-					    "Cmdq IO error, opcode = 0x%x, return = 0x%x.\n",
-					    desc->opcode, desc_ret);
 			ret = hns_roce_cmd_err_convert_errno(desc_ret);
 		}
 	} else {
@@ -1354,14 +1346,54 @@ static int __hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 		ret = -EAGAIN;
 	}
 
-	spin_unlock_bh(&csq->lock);
-
 	if (ret)
 		atomic64_inc(&hr_dev->dfx_cnt[HNS_ROCE_DFX_CMDS_ERR_CNT]);
 
 	return ret;
 }
 
+static int __hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
+			       struct hns_roce_cmq_desc *desc, int num)
+{
+	struct hns_roce_v2_priv *priv = hr_dev->priv;
+	struct hns_roce_v2_cmq_ring *csq = &priv->cmq.csq;
+	u16 opcode = le16_to_cpu(desc->opcode);
+	u32 tx_timeout = hns_roce_cmdq_tx_timeout(opcode, priv->cmq.tx_timeout);
+	u8 try_cnt = HNS_ROCE_OPC_POST_MB_TRY_CNT;
+	u32 rsv_tail;
+	int ret;
+	int i;
+
+	while (try_cnt) {
+		try_cnt--;
+
+		spin_lock_bh(&csq->lock);
+		rsv_tail = csq->head;
+		ret = __hns_roce_cmq_send_one(hr_dev, desc, num, tx_timeout);
+		if (opcode == HNS_ROCE_OPC_POST_MB && ret == -ETIME &&
+		    try_cnt) {
+			spin_unlock_bh(&csq->lock);
+			mdelay(HNS_ROCE_OPC_POST_MB_RETRY_GAP_MSEC);
+			continue;
+		}
+
+		for (i = 0; i < num; i++) {
+			desc[i] = csq->desc[rsv_tail++];
+			if (rsv_tail == csq->desc_num)
+				rsv_tail = 0;
+		}
+		spin_unlock_bh(&csq->lock);
+		break;
+	}
+
+	if (ret)
+		dev_err_ratelimited(hr_dev->dev,
+				    "Cmdq IO error, opcode = 0x%x, return = %d.\n",
+				    opcode, ret);
+
+	return ret;
+}
+
 static int hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 			     struct hns_roce_cmq_desc *desc, int num)
 {
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index cbdbc9edbce6e..91a5665465ffb 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -230,6 +230,8 @@ enum hns_roce_opcode_type {
 };
 
 #define HNS_ROCE_OPC_POST_MB_TIMEOUT 35000
+#define HNS_ROCE_OPC_POST_MB_TRY_CNT 8
+#define HNS_ROCE_OPC_POST_MB_RETRY_GAP_MSEC 5
 struct hns_roce_cmdq_tx_timeout_map {
 	u16 opcode;
 	u32 tx_timeout;
-- 
2.39.5



