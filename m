Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84D41DF986;
	Wed,  6 Nov 2024 12:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895883; cv=none; b=kZFDM04U5g9Pjef8n40ZDPs2Tr2cQwsHdItcRRhM8wOB8tzsHEPHKczlRX7JRSfsIQfq7ClYbPLVuTS2BPe9zwCFc0e1pHMeMeycRA6r6XPvjkqa5R2K6vUO3Pp7cRJwVjhcr7G5qsW6GSKSt2YtcYp1QW1s5J3mNU3186JQn4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895883; c=relaxed/simple;
	bh=8s3C2EM6EW0CjA5qBmQPxbYWxied/uDwGzlamxDF5J8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjeMstt2MpR/Td6UUqa7roS5cJTNrajy/HaRpjaCfxuHnEpL75fWO+9rhgwTJ8WcuI46x4nzPZQINnP9jj0yQUiEbvnEV2FwQtjs58msV3uFgtIhGt+fGrdMr0aezcJCdka0vM6IkqRvRn8/Ek/RAFz6s+LiDmRVDdgRlxgOKVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1YOrBQU+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1YOrBQU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FB3C4CECD;
	Wed,  6 Nov 2024 12:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895882;
	bh=8s3C2EM6EW0CjA5qBmQPxbYWxied/uDwGzlamxDF5J8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1YOrBQU+VeQjZnDhVcKnI76AHBHRMf1R8WOPQqgWjRCvT0Kxrl1COs79g1jwFxWFR
	 XwaQt+1eiaJHRLekie4FYALRsmLAloAj8y5nWe4VtgwNoi76m396Jb9ZK4tnLFVtMX
	 REKEb3TPsNfa4ZUt7hZxIC9X7vVvnW/C6o4MiUFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 017/245] RDMA/bnxt_re: Fix the usage of control path spin locks
Date: Wed,  6 Nov 2024 13:01:10 +0100
Message-ID: <20241106120319.662840221@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit d71f4acd584cc861f54b3cb3ac07875f06550a05 ]

Control path completion processing always runs in tasklet context. To
synchronize with the posting thread, there is no need to use the irq
variant of spin lock. Use spin_lock_bh instead.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Link: https://patch.msgid.link/r/1728912975-19346-2-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 25 +++++++++-------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index 7294221b3316c..ca26b88a0a80f 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -290,7 +290,6 @@ static int __send_message(struct bnxt_qplib_rcfw *rcfw,
 	struct bnxt_qplib_hwq *hwq;
 	u32 sw_prod, cmdq_prod;
 	struct pci_dev *pdev;
-	unsigned long flags;
 	u16 cookie;
 	u8 *preq;
 
@@ -301,7 +300,7 @@ static int __send_message(struct bnxt_qplib_rcfw *rcfw,
 	/* Cmdq are in 16-byte units, each request can consume 1 or more
 	 * cmdqe
 	 */
-	spin_lock_irqsave(&hwq->lock, flags);
+	spin_lock_bh(&hwq->lock);
 	required_slots = bnxt_qplib_get_cmd_slots(msg->req);
 	free_slots = HWQ_FREE_SLOTS(hwq);
 	cookie = cmdq->seq_num & RCFW_MAX_COOKIE_VALUE;
@@ -311,7 +310,7 @@ static int __send_message(struct bnxt_qplib_rcfw *rcfw,
 		dev_info_ratelimited(&pdev->dev,
 				     "CMDQ is full req/free %d/%d!",
 				     required_slots, free_slots);
-		spin_unlock_irqrestore(&hwq->lock, flags);
+		spin_unlock_bh(&hwq->lock);
 		return -EAGAIN;
 	}
 	if (msg->block)
@@ -367,7 +366,7 @@ static int __send_message(struct bnxt_qplib_rcfw *rcfw,
 	wmb();
 	writel(cmdq_prod, cmdq->cmdq_mbox.prod);
 	writel(RCFW_CMDQ_TRIG_VAL, cmdq->cmdq_mbox.db);
-	spin_unlock_irqrestore(&hwq->lock, flags);
+	spin_unlock_bh(&hwq->lock);
 	/* Return the CREQ response pointer */
 	return 0;
 }
@@ -486,7 +485,6 @@ static int __bnxt_qplib_rcfw_send_message(struct bnxt_qplib_rcfw *rcfw,
 {
 	struct creq_qp_event *evnt = (struct creq_qp_event *)msg->resp;
 	struct bnxt_qplib_crsqe *crsqe;
-	unsigned long flags;
 	u16 cookie;
 	int rc;
 	u8 opcode;
@@ -512,12 +510,12 @@ static int __bnxt_qplib_rcfw_send_message(struct bnxt_qplib_rcfw *rcfw,
 		rc = __poll_for_resp(rcfw, cookie);
 
 	if (rc) {
-		spin_lock_irqsave(&rcfw->cmdq.hwq.lock, flags);
+		spin_lock_bh(&rcfw->cmdq.hwq.lock);
 		crsqe = &rcfw->crsqe_tbl[cookie];
 		crsqe->is_waiter_alive = false;
 		if (rc == -ENODEV)
 			set_bit(FIRMWARE_STALL_DETECTED, &rcfw->cmdq.flags);
-		spin_unlock_irqrestore(&rcfw->cmdq.hwq.lock, flags);
+		spin_unlock_bh(&rcfw->cmdq.hwq.lock);
 		return -ETIMEDOUT;
 	}
 
@@ -628,7 +626,6 @@ static int bnxt_qplib_process_qp_event(struct bnxt_qplib_rcfw *rcfw,
 	u16 cookie, blocked = 0;
 	bool is_waiter_alive;
 	struct pci_dev *pdev;
-	unsigned long flags;
 	u32 wait_cmds = 0;
 	int rc = 0;
 
@@ -659,8 +656,7 @@ static int bnxt_qplib_process_qp_event(struct bnxt_qplib_rcfw *rcfw,
 		 *
 		 */
 
-		spin_lock_irqsave_nested(&hwq->lock, flags,
-					 SINGLE_DEPTH_NESTING);
+		spin_lock_nested(&hwq->lock, SINGLE_DEPTH_NESTING);
 		cookie = le16_to_cpu(qp_event->cookie);
 		blocked = cookie & RCFW_CMD_IS_BLOCKING;
 		cookie &= RCFW_MAX_COOKIE_VALUE;
@@ -672,7 +668,7 @@ static int bnxt_qplib_process_qp_event(struct bnxt_qplib_rcfw *rcfw,
 			dev_info(&pdev->dev,
 				 "rcfw timedout: cookie = %#x, free_slots = %d",
 				 cookie, crsqe->free_slots);
-			spin_unlock_irqrestore(&hwq->lock, flags);
+			spin_unlock(&hwq->lock);
 			return rc;
 		}
 
@@ -720,7 +716,7 @@ static int bnxt_qplib_process_qp_event(struct bnxt_qplib_rcfw *rcfw,
 			__destroy_timedout_ah(rcfw,
 					      (struct creq_create_ah_resp *)
 					      qp_event);
-		spin_unlock_irqrestore(&hwq->lock, flags);
+		spin_unlock(&hwq->lock);
 	}
 	*num_wait += wait_cmds;
 	return rc;
@@ -734,12 +730,11 @@ static void bnxt_qplib_service_creq(struct tasklet_struct *t)
 	u32 type, budget = CREQ_ENTRY_POLL_BUDGET;
 	struct bnxt_qplib_hwq *hwq = &creq->hwq;
 	struct creq_base *creqe;
-	unsigned long flags;
 	u32 num_wakeup = 0;
 	u32 hw_polled = 0;
 
 	/* Service the CREQ until budget is over */
-	spin_lock_irqsave(&hwq->lock, flags);
+	spin_lock_bh(&hwq->lock);
 	while (budget > 0) {
 		creqe = bnxt_qplib_get_qe(hwq, hwq->cons, NULL);
 		if (!CREQ_CMP_VALID(creqe, creq->creq_db.dbinfo.flags))
@@ -782,7 +777,7 @@ static void bnxt_qplib_service_creq(struct tasklet_struct *t)
 	if (hw_polled)
 		bnxt_qplib_ring_nq_db(&creq->creq_db.dbinfo,
 				      rcfw->res->cctx, true);
-	spin_unlock_irqrestore(&hwq->lock, flags);
+	spin_unlock_bh(&hwq->lock);
 	if (num_wakeup)
 		wake_up_nr(&rcfw->cmdq.waitq, num_wakeup);
 }
-- 
2.43.0



