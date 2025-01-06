Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D8F1607AA;
	Mon,  6 Jan 2025 15:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177810; cv=none; b=nQO9c73lSHCwB4g9MVYv9r3Ue7XSgJDquNxYVY/Dw1pSB2P/he0cPEUsWM65nwJF9KqhmFmqCvHZt0ICa+f4fbuApPSbzYXqB6xWuxEMozBjGY9Tc4VV8OD83t8wHUjy92dAIX9k5Gc4O3WPTV0a6ILmHudv1VLqVmU339Llv/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177810; c=relaxed/simple;
	bh=pE8Zf00hLtrnpCO+KZLkTUcR6+LGZnPI0Aq+QwNeRBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=to5S5D8DxPbP3cdp55U+Oi2iAjpzE9LvGOgzjXGgznZFqnF8Np8oo7pTgRp6grXYpk9g1+ya4FvsSTZ3ibyaEhzRfHt2JtXjrLkr22MCPl1/D0B7Fnkm9y/fTnCYN0LXMPaayupY6g9AaqF7U9OcrF5WTDBxn4XCKplkmzaLnx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYfKZV46; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYfKZV46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F44C4CED2;
	Mon,  6 Jan 2025 15:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177810;
	bh=pE8Zf00hLtrnpCO+KZLkTUcR6+LGZnPI0Aq+QwNeRBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYfKZV46N2wrkKFd7wR+nmaukTisbltMvvcQLg5H/f3qVcIpNeiFswii2oZfK/Y4l
	 BoyNccWWwzY7VHN1Xdp5O1uxZBOVVlILcK3EZTsnNSoFhdsu5yPn1+WAYPRG7OaJbz
	 p8HeXqw2U5e2vxkAA+jYDotGhhRYNIZbHwY5JWGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 065/156] RDMA/bnxt_re: Fix error recovery sequence
Date: Mon,  6 Jan 2025 16:15:51 +0100
Message-ID: <20250106151144.183809992@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit e6178bf78d0378c2d397a6aafaf4882d0af643fa ]

Fixed to return ENXIO from __send_message_basic_sanity()
to indicate that device is in error state. In the case of
ERR_DEVICE_DETACHED state, the driver should not post the
commands to the firmware as it will time out eventually.

Removed bnxt_re_modify_qp() call from bnxt_re_dev_stop()
as it is a no-op.

Fixes: cc5b9b48d447 ("RDMA/bnxt_re: Recover the device when FW error is detected")
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Link: https://patch.msgid.link/20241231025008.2267162-1-kalesh-anakkur.purayil@broadcom.com
Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/main.c       | 8 +-------
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 5 +++--
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 2ac8ddbed576..8abd1b723f8f 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -1435,11 +1435,8 @@ static bool bnxt_re_is_qp1_or_shadow_qp(struct bnxt_re_dev *rdev,
 
 static void bnxt_re_dev_stop(struct bnxt_re_dev *rdev)
 {
-	int mask = IB_QP_STATE;
-	struct ib_qp_attr qp_attr;
 	struct bnxt_re_qp *qp;
 
-	qp_attr.qp_state = IB_QPS_ERR;
 	mutex_lock(&rdev->qp_lock);
 	list_for_each_entry(qp, &rdev->qp_list, list) {
 		/* Modify the state of all QPs except QP1/Shadow QP */
@@ -1447,12 +1444,9 @@ static void bnxt_re_dev_stop(struct bnxt_re_dev *rdev)
 			if (qp->qplib_qp.state !=
 			    CMDQ_MODIFY_QP_NEW_STATE_RESET &&
 			    qp->qplib_qp.state !=
-			    CMDQ_MODIFY_QP_NEW_STATE_ERR) {
+			    CMDQ_MODIFY_QP_NEW_STATE_ERR)
 				bnxt_re_dispatch_event(&rdev->ibdev, &qp->ib_qp,
 						       1, IB_EVENT_QP_FATAL);
-				bnxt_re_modify_qp(&qp->ib_qp, &qp_attr, mask,
-						  NULL);
-			}
 		}
 	}
 	mutex_unlock(&rdev->qp_lock);
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index e82bd37158ad..7a099580ca8b 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -424,7 +424,8 @@ static int __send_message_basic_sanity(struct bnxt_qplib_rcfw *rcfw,
 
 	/* Prevent posting if f/w is not in a state to process */
 	if (test_bit(ERR_DEVICE_DETACHED, &rcfw->cmdq.flags))
-		return bnxt_qplib_map_rc(opcode);
+		return -ENXIO;
+
 	if (test_bit(FIRMWARE_STALL_DETECTED, &cmdq->flags))
 		return -ETIMEDOUT;
 
@@ -493,7 +494,7 @@ static int __bnxt_qplib_rcfw_send_message(struct bnxt_qplib_rcfw *rcfw,
 
 	rc = __send_message_basic_sanity(rcfw, msg, opcode);
 	if (rc)
-		return rc;
+		return rc == -ENXIO ? bnxt_qplib_map_rc(opcode) : rc;
 
 	rc = __send_message(rcfw, msg, opcode);
 	if (rc)
-- 
2.39.5



