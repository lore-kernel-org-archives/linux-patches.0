Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BE81957FC;
	Thu,  5 Sep 2024 09:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530258; cv=none; b=gwzFbck7OrsnHBfoixLEsJGHCjEhQdDddvpaFZg6LtIUaLgvUco2I1wfmeDTHSCPJyJW6lx0eDELcAMi6Q5X6X2O0BxxNdcZlc/2FgO01PjbZwP/thcRE+lTbLsPhrr0Jf2o8RivfYu2UwZDPe07Cllpo0gI5qtlW4x/SBU7arM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530258; c=relaxed/simple;
	bh=BSESEP5zo3IuGGeFU7wkiwtJg249I3JaSltJkJnrg90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTbeBikQY/uO/B1nNLbwRJs4TysSEzsDAoajYEettHLtPPkce4xQnGcfvXg3uviDKS6qe+P++g0DAHu3vQKc2KsJqEkwEEhXVRoMcK6tGlpJVCqMDT6pXujfZ25B8G0ITU0/XWIXF7isrtDVvt0RoAw9HD5RJG0udJ/i7XKNzD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UHiXq9Vw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UHiXq9Vw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEE6C4CEC3;
	Thu,  5 Sep 2024 09:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530258;
	bh=BSESEP5zo3IuGGeFU7wkiwtJg249I3JaSltJkJnrg90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UHiXq9Vw1GAW7Z9MC78m9usr3BSPi4pn/g/VOi4sCa8T/pa/b2gamwmF+pXPoY2fT
	 vDLA/OK7E6BgP8O4ivNIXciFfrw0tz6HmxS/1Gi8sAjHhjhWFO2m4/DqurlJQ5biFs
	 eabuHHl3IshbPzDAdaTY8X2iqy0ZyPZw3YvUI6as=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Firas Jahjah <firasj@amazon.com>,
	Yehuda Yitschak <yehuday@amazon.com>,
	Michael Margolin <mrgolin@amazon.com>,
	Gal Pressman <gal.pressman@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/132] RDMA/efa: Properly handle unexpected AQ completions
Date: Thu,  5 Sep 2024 11:41:22 +0200
Message-ID: <20240905093725.938876588@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Margolin <mrgolin@amazon.com>

[ Upstream commit 2d0e7ba468eae365f3c4bc9266679e1f8dd405f0 ]

Do not try to handle admin command completion if it has an unexpected
command id and print a relevant error message.

Reviewed-by: Firas Jahjah <firasj@amazon.com>
Reviewed-by: Yehuda Yitschak <yehuday@amazon.com>
Signed-off-by: Michael Margolin <mrgolin@amazon.com>
Link: https://lore.kernel.org/r/20240513064630.6247-1-mrgolin@amazon.com
Reviewed-by: Gal Pressman <gal.pressman@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/efa/efa_com.c | 30 ++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
index 16a24a05fc2a..bafd210dd43e 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
 /*
- * Copyright 2018-2021 Amazon.com, Inc. or its affiliates. All rights reserved.
+ * Copyright 2018-2024 Amazon.com, Inc. or its affiliates. All rights reserved.
  */
 
 #include "efa_com.h"
@@ -406,8 +406,8 @@ static struct efa_comp_ctx *efa_com_submit_admin_cmd(struct efa_com_admin_queue
 	return comp_ctx;
 }
 
-static void efa_com_handle_single_admin_completion(struct efa_com_admin_queue *aq,
-						   struct efa_admin_acq_entry *cqe)
+static int efa_com_handle_single_admin_completion(struct efa_com_admin_queue *aq,
+						  struct efa_admin_acq_entry *cqe)
 {
 	struct efa_comp_ctx *comp_ctx;
 	u16 cmd_id;
@@ -416,11 +416,11 @@ static void efa_com_handle_single_admin_completion(struct efa_com_admin_queue *a
 			 EFA_ADMIN_ACQ_COMMON_DESC_COMMAND_ID);
 
 	comp_ctx = efa_com_get_comp_ctx(aq, cmd_id, false);
-	if (!comp_ctx) {
+	if (comp_ctx->status != EFA_CMD_SUBMITTED) {
 		ibdev_err(aq->efa_dev,
-			  "comp_ctx is NULL. Changing the admin queue running state\n");
-		clear_bit(EFA_AQ_STATE_RUNNING_BIT, &aq->state);
-		return;
+			  "Received completion with unexpected command id[%d], sq producer: %d, sq consumer: %d, cq consumer: %d\n",
+			  cmd_id, aq->sq.pc, aq->sq.cc, aq->cq.cc);
+		return -EINVAL;
 	}
 
 	comp_ctx->status = EFA_CMD_COMPLETED;
@@ -428,14 +428,17 @@ static void efa_com_handle_single_admin_completion(struct efa_com_admin_queue *a
 
 	if (!test_bit(EFA_AQ_STATE_POLLING_BIT, &aq->state))
 		complete(&comp_ctx->wait_event);
+
+	return 0;
 }
 
 static void efa_com_handle_admin_completion(struct efa_com_admin_queue *aq)
 {
 	struct efa_admin_acq_entry *cqe;
 	u16 queue_size_mask;
-	u16 comp_num = 0;
+	u16 comp_cmds = 0;
 	u8 phase;
+	int err;
 	u16 ci;
 
 	queue_size_mask = aq->depth - 1;
@@ -453,10 +456,12 @@ static void efa_com_handle_admin_completion(struct efa_com_admin_queue *aq)
 		 * phase bit was validated
 		 */
 		dma_rmb();
-		efa_com_handle_single_admin_completion(aq, cqe);
+		err = efa_com_handle_single_admin_completion(aq, cqe);
+		if (!err)
+			comp_cmds++;
 
+		aq->cq.cc++;
 		ci++;
-		comp_num++;
 		if (ci == aq->depth) {
 			ci = 0;
 			phase = !phase;
@@ -465,10 +470,9 @@ static void efa_com_handle_admin_completion(struct efa_com_admin_queue *aq)
 		cqe = &aq->cq.entries[ci];
 	}
 
-	aq->cq.cc += comp_num;
 	aq->cq.phase = phase;
-	aq->sq.cc += comp_num;
-	atomic64_add(comp_num, &aq->stats.completed_cmd);
+	aq->sq.cc += comp_cmds;
+	atomic64_add(comp_cmds, &aq->stats.completed_cmd);
 }
 
 static int efa_com_comp_status_to_errno(u8 comp_status)
-- 
2.43.0



