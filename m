Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071A81FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:45:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B896C433CB;
	Tue,  1 Aug 2023 09:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883101;
	bh=VjWuXvhqYuZGa1kV/h01hq3m0MHvxttDe2Rx5fWWEPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G0/D5sX2Sw8YU32tMSerDHCBTGmF6op1uyD1JEXveA4YO9XiKFfNAQTXVi+QC9CLF
	 zOpDv5osxM4ZHKIGE2VyaGv5a+b4FNyImQH97o2yEA6PCebtrJM8ieAwiE0Wf6biCe
	 Iie30smnmvvszW6wXDJ26qhxZnCac4xlb2gLbCAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 115/239] RDMA/bnxt_re: add helper function __poll_for_resp
Date: Tue,  1 Aug 2023 11:19:39 +0200
Message-ID: <20230801091929.874894138@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kashyap Desai <kashyap.desai@broadcom.com>

[ Upstream commit 354f5bd985af9515190828bc642ebdf59acea121 ]

This interface will be used if the driver has not enabled interrupt
and/or interrupt is disabled for a short period of time.
Completion is not possible from interrupt so this interface does
self-polling.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://lore.kernel.org/r/1686308514-11996-10-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 29900bf351e1 ("RDMA/bnxt_re: Fix hang during driver unload")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 44 +++++++++++++++++++++-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h |  1 +
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index f867507d427f9..0028043bb51cd 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -260,6 +260,44 @@ static int __send_message(struct bnxt_qplib_rcfw *rcfw,
 	return 0;
 }
 
+/**
+ * __poll_for_resp   -	self poll completion for rcfw command
+ * @rcfw      -   rcfw channel instance of rdev
+ * @cookie    -   cookie to track the command
+ * @opcode    -   rcfw submitted for given opcode
+ *
+ * It works same as __wait_for_resp except this function will
+ * do self polling in sort interval since interrupt is disabled.
+ * This function can not be called from non-sleepable context.
+ *
+ * Returns:
+ * -ETIMEOUT if command is not completed in specific time interval.
+ * 0 if command is completed by firmware.
+ */
+static int __poll_for_resp(struct bnxt_qplib_rcfw *rcfw, u16 cookie,
+			   u8 opcode)
+{
+	struct bnxt_qplib_cmdq_ctx *cmdq = &rcfw->cmdq;
+	unsigned long issue_time;
+	u16 cbit;
+
+	cbit = cookie % rcfw->cmdq_depth;
+	issue_time = jiffies;
+
+	do {
+		if (test_bit(ERR_DEVICE_DETACHED, &cmdq->flags))
+			return bnxt_qplib_map_rc(opcode);
+
+		usleep_range(1000, 1001);
+
+		bnxt_qplib_service_creq(&rcfw->creq.creq_tasklet);
+		if (!test_bit(cbit, cmdq->cmdq_bitmap))
+			return 0;
+		if (jiffies_to_msecs(jiffies - issue_time) > 10000)
+			return -ETIMEDOUT;
+	} while (true);
+};
+
 static int __send_message_basic_sanity(struct bnxt_qplib_rcfw *rcfw,
 				       struct bnxt_qplib_cmdqmsg *msg)
 {
@@ -328,8 +366,10 @@ static int __bnxt_qplib_rcfw_send_message(struct bnxt_qplib_rcfw *rcfw,
 
 	if (msg->block)
 		rc = __block_for_resp(rcfw, cookie, opcode);
-	else
+	else if (atomic_read(&rcfw->rcfw_intr_enabled))
 		rc = __wait_for_resp(rcfw, cookie, opcode);
+	else
+		rc = __poll_for_resp(rcfw, cookie, opcode);
 	if (rc) {
 		/* timed out */
 		dev_err(&rcfw->pdev->dev, "cmdq[%#x]=%#x timedout (%d)msec\n",
@@ -798,6 +838,7 @@ void bnxt_qplib_rcfw_stop_irq(struct bnxt_qplib_rcfw *rcfw, bool kill)
 	kfree(creq->irq_name);
 	creq->irq_name = NULL;
 	creq->requested = false;
+	atomic_set(&rcfw->rcfw_intr_enabled, 0);
 }
 
 void bnxt_qplib_disable_rcfw_channel(struct bnxt_qplib_rcfw *rcfw)
@@ -859,6 +900,7 @@ int bnxt_qplib_rcfw_start_irq(struct bnxt_qplib_rcfw *rcfw, int msix_vector,
 	creq->requested = true;
 
 	bnxt_qplib_ring_nq_db(&creq->creq_db.dbinfo, res->cctx, true);
+	atomic_inc(&rcfw->rcfw_intr_enabled);
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
index 43dc11febf46a..4608c0ef07a87 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
@@ -225,6 +225,7 @@ struct bnxt_qplib_rcfw {
 	u64 oos_prev;
 	u32 init_oos_stats;
 	u32 cmdq_depth;
+	atomic_t rcfw_intr_enabled;
 	struct semaphore rcfw_inflight;
 };
 
-- 
2.40.1



