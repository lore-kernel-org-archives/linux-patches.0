Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD848188A1E;
	Tue, 10 Sep 2024 10:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963391; cv=none; b=XS6Q2/0zj1PCo/RkvCmexqNR8zJ6pSFbAihp8xV2enn8jKNZMMlaFvddxECt+89+ifFVMag8+pknaiDF54482vM8QySX8QMkU2Dxetl+YWYB4GVokJtYNcRVGCmesMinnoozeAuraV+M37A6/izpGBOPYgne2FlmsFuWDAayNJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963391; c=relaxed/simple;
	bh=ih7ZT4Ahup+jXCo+Bl8zlbyuvUKnoOCLFAwzjHRv3ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITjHx6Xt0ag2iFlm4EsQ9Yc+n+ZivWnWi4SJkWmZmf6UNPJE5el2wnHMugtTQP1DSbL8rfcebuLYEF487mtmy3nFqpxJfLxM6X2m3K8hWlhvt8Z3ECh/ebeuJOO9KNwOHTg6Rj8z3sI68nDOrmE6lMJIrjRdWeh0JH4CPXy+fpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K/Bfrn8D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K/Bfrn8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555D8C4CEC3;
	Tue, 10 Sep 2024 10:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963391;
	bh=ih7ZT4Ahup+jXCo+Bl8zlbyuvUKnoOCLFAwzjHRv3ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/Bfrn8DKwA8aaiVTD6WAzo+R/XMm8x+IzmAMWNGv2f6q12N4nQuc2qWt6h51dTo8
	 5UUWLJxRLwg1O7v4MjMjFD7p9AQ83keNxX/fYMrNzhzrLE9P1YrRQr4H72BXxqw8gY
	 eglphQ7WZib5cztha+JONJwYrOTOMgSliftXIs04=
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
Subject: [PATCH 5.15 042/214] RDMA/efa: Properly handle unexpected AQ completions
Date: Tue, 10 Sep 2024 11:31:04 +0200
Message-ID: <20240910092600.490113711@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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
index 0d523ad736c7..462908022091 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
 /*
- * Copyright 2018-2021 Amazon.com, Inc. or its affiliates. All rights reserved.
+ * Copyright 2018-2024 Amazon.com, Inc. or its affiliates. All rights reserved.
  */
 
 #include "efa_com.h"
@@ -398,8 +398,8 @@ static struct efa_comp_ctx *efa_com_submit_admin_cmd(struct efa_com_admin_queue
 	return comp_ctx;
 }
 
-static void efa_com_handle_single_admin_completion(struct efa_com_admin_queue *aq,
-						   struct efa_admin_acq_entry *cqe)
+static int efa_com_handle_single_admin_completion(struct efa_com_admin_queue *aq,
+						  struct efa_admin_acq_entry *cqe)
 {
 	struct efa_comp_ctx *comp_ctx;
 	u16 cmd_id;
@@ -408,11 +408,11 @@ static void efa_com_handle_single_admin_completion(struct efa_com_admin_queue *a
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
@@ -420,14 +420,17 @@ static void efa_com_handle_single_admin_completion(struct efa_com_admin_queue *a
 
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
@@ -445,10 +448,12 @@ static void efa_com_handle_admin_completion(struct efa_com_admin_queue *aq)
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
@@ -457,10 +462,9 @@ static void efa_com_handle_admin_completion(struct efa_com_admin_queue *aq)
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



