Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BDC421F1F;
	Tue, 31 Mar 2026 16:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975065; cv=none; b=FNWt8jEu9TOnpyF2VUYvap1AbSKMw9gqlt3Q5IOXXAnZluEZ1zhlKCePnrZQLW0sQRj0CAM1x6DgKvnb/5twSZ3cnfiVv9ZDOGJ32be0BN9upf6NWjKceGt5AQCZAPA8EVWA9J1S3hyZuWL+DIVScp3N1FnUMu4SEfSUKDZA8OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975065; c=relaxed/simple;
	bh=ThtoQ10qGFbEidRFy5k5fZUGZxNhkK6+jqKCYxXh+tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/Oewm+dngpgq431AmIwyJjwdUF8nqiXLD742bFKIIrQzWCc+Hy1xjKk5iWuwZbU7UbrIUvYFZcFlfdAL7cAbAFRZomF7K+mRK1QQQkJ9jK4l0gjniNd0oO6zUl4Xnj7gTg65LJgXfF8uH3BXu98CV2K+CYIjE92cN0tHG+oAb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xOailPT0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xOailPT0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5CCC19423;
	Tue, 31 Mar 2026 16:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975065;
	bh=ThtoQ10qGFbEidRFy5k5fZUGZxNhkK6+jqKCYxXh+tY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xOailPT0TZlm3slJt2ddwa5S8o9gZ3pIOJIA2AWIdrA0CPeDYZDGCXvi87BzzKmUo
	 K/f5aQxJALMeR9RIyll6cAgHL8SquIoKQ40AGXNf4UOkNb5owre1rZ8G0hjxdpAC1+
	 8mSGSsM3OvHKK8f+d8k3MxbuaP4E7ee1vzeAD+60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Kranzdorf <dkkranzd@amazon.com>,
	Michael Margolin <mrgolin@amazon.com>,
	Yonatan Nachum <ynachum@amazon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 150/342] RDMA/efa: Fix use of completion ctx after free
Date: Tue, 31 Mar 2026 18:19:43 +0200
Message-ID: <20260331161804.526078605@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonatan Nachum <ynachum@amazon.com>

[ Upstream commit ef3b06742c8a201d0e83edc9a33a89a4fe3009f8 ]

On admin queue completion handling, if the admin command completed with
error we print data from the completion context. The issue is that we
already freed the completion context in polling/interrupts handler which
means we print data from context in an unknown state (it might be
already used again).
Change the admin submission flow so alloc/dealloc of the context will be
symmetric and dealloc will be called after any potential use of the
context.

Fixes: 68fb9f3e312a ("RDMA/efa: Remove redundant NULL pointer check of CQE")
Reviewed-by: Daniel Kranzdorf <dkkranzd@amazon.com>
Reviewed-by: Michael Margolin <mrgolin@amazon.com>
Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
Link: https://patch.msgid.link/20260308165350.18219-1-ynachum@amazon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/efa/efa_com.c | 87 +++++++++++++----------------
 1 file changed, 39 insertions(+), 48 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
index 229b0ad3b0cbb..56caba612139f 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
 /*
- * Copyright 2018-2025 Amazon.com, Inc. or its affiliates. All rights reserved.
+ * Copyright 2018-2026 Amazon.com, Inc. or its affiliates. All rights reserved.
  */
 
 #include <linux/log2.h>
@@ -310,23 +310,19 @@ static inline struct efa_comp_ctx *efa_com_get_comp_ctx_by_cmd_id(struct efa_com
 	return &aq->comp_ctx[ctx_id];
 }
 
-static struct efa_comp_ctx *__efa_com_submit_admin_cmd(struct efa_com_admin_queue *aq,
-						       struct efa_admin_aq_entry *cmd,
-						       size_t cmd_size_in_bytes,
-						       struct efa_admin_acq_entry *comp,
-						       size_t comp_size_in_bytes)
+static void __efa_com_submit_admin_cmd(struct efa_com_admin_queue *aq,
+				       struct efa_comp_ctx *comp_ctx,
+				       struct efa_admin_aq_entry *cmd,
+				       size_t cmd_size_in_bytes,
+				       struct efa_admin_acq_entry *comp,
+				       size_t comp_size_in_bytes)
 {
 	struct efa_admin_aq_entry *aqe;
-	struct efa_comp_ctx *comp_ctx;
 	u16 queue_size_mask;
 	u16 cmd_id;
 	u16 ctx_id;
 	u16 pi;
 
-	comp_ctx = efa_com_alloc_comp_ctx(aq);
-	if (!comp_ctx)
-		return ERR_PTR(-EINVAL);
-
 	queue_size_mask = aq->depth - 1;
 	pi = aq->sq.pc & queue_size_mask;
 	ctx_id = efa_com_get_comp_ctx_id(aq, comp_ctx);
@@ -360,8 +356,6 @@ static struct efa_comp_ctx *__efa_com_submit_admin_cmd(struct efa_com_admin_queu
 
 	/* barrier not needed in case of writel */
 	writel(aq->sq.pc, aq->sq.db_addr);
-
-	return comp_ctx;
 }
 
 static inline int efa_com_init_comp_ctxt(struct efa_com_admin_queue *aq)
@@ -394,28 +388,25 @@ static inline int efa_com_init_comp_ctxt(struct efa_com_admin_queue *aq)
 	return 0;
 }
 
-static struct efa_comp_ctx *efa_com_submit_admin_cmd(struct efa_com_admin_queue *aq,
-						     struct efa_admin_aq_entry *cmd,
-						     size_t cmd_size_in_bytes,
-						     struct efa_admin_acq_entry *comp,
-						     size_t comp_size_in_bytes)
+static int efa_com_submit_admin_cmd(struct efa_com_admin_queue *aq,
+				    struct efa_comp_ctx *comp_ctx,
+				    struct efa_admin_aq_entry *cmd,
+				    size_t cmd_size_in_bytes,
+				    struct efa_admin_acq_entry *comp,
+				    size_t comp_size_in_bytes)
 {
-	struct efa_comp_ctx *comp_ctx;
-
 	spin_lock(&aq->sq.lock);
 	if (!test_bit(EFA_AQ_STATE_RUNNING_BIT, &aq->state)) {
 		ibdev_err_ratelimited(aq->efa_dev, "Admin queue is closed\n");
 		spin_unlock(&aq->sq.lock);
-		return ERR_PTR(-ENODEV);
+		return -ENODEV;
 	}
 
-	comp_ctx = __efa_com_submit_admin_cmd(aq, cmd, cmd_size_in_bytes, comp,
-					      comp_size_in_bytes);
+	__efa_com_submit_admin_cmd(aq, comp_ctx, cmd, cmd_size_in_bytes, comp,
+				   comp_size_in_bytes);
 	spin_unlock(&aq->sq.lock);
-	if (IS_ERR(comp_ctx))
-		clear_bit(EFA_AQ_STATE_RUNNING_BIT, &aq->state);
 
-	return comp_ctx;
+	return 0;
 }
 
 static int efa_com_handle_single_admin_completion(struct efa_com_admin_queue *aq,
@@ -512,7 +503,6 @@ static int efa_com_wait_and_process_admin_cq_polling(struct efa_comp_ctx *comp_c
 {
 	unsigned long timeout;
 	unsigned long flags;
-	int err;
 
 	timeout = jiffies + usecs_to_jiffies(aq->completion_timeout);
 
@@ -532,24 +522,20 @@ static int efa_com_wait_and_process_admin_cq_polling(struct efa_comp_ctx *comp_c
 			atomic64_inc(&aq->stats.no_completion);
 
 			clear_bit(EFA_AQ_STATE_RUNNING_BIT, &aq->state);
-			err = -ETIME;
-			goto out;
+			return -ETIME;
 		}
 
 		msleep(aq->poll_interval);
 	}
 
-	err = efa_com_comp_status_to_errno(comp_ctx->user_cqe->acq_common_descriptor.status);
-out:
-	efa_com_dealloc_comp_ctx(aq, comp_ctx);
-	return err;
+	return efa_com_comp_status_to_errno(
+		comp_ctx->user_cqe->acq_common_descriptor.status);
 }
 
 static int efa_com_wait_and_process_admin_cq_interrupts(struct efa_comp_ctx *comp_ctx,
 							struct efa_com_admin_queue *aq)
 {
 	unsigned long flags;
-	int err;
 
 	wait_for_completion_timeout(&comp_ctx->wait_event,
 				    usecs_to_jiffies(aq->completion_timeout));
@@ -585,14 +571,11 @@ static int efa_com_wait_and_process_admin_cq_interrupts(struct efa_comp_ctx *com
 				aq->cq.cc);
 
 		clear_bit(EFA_AQ_STATE_RUNNING_BIT, &aq->state);
-		err = -ETIME;
-		goto out;
+		return -ETIME;
 	}
 
-	err = efa_com_comp_status_to_errno(comp_ctx->user_cqe->acq_common_descriptor.status);
-out:
-	efa_com_dealloc_comp_ctx(aq, comp_ctx);
-	return err;
+	return efa_com_comp_status_to_errno(
+		comp_ctx->user_cqe->acq_common_descriptor.status);
 }
 
 /*
@@ -642,30 +625,38 @@ int efa_com_cmd_exec(struct efa_com_admin_queue *aq,
 	ibdev_dbg(aq->efa_dev, "%s (opcode %d)\n",
 		  efa_com_cmd_str(cmd->aq_common_descriptor.opcode),
 		  cmd->aq_common_descriptor.opcode);
-	comp_ctx = efa_com_submit_admin_cmd(aq, cmd, cmd_size, comp, comp_size);
-	if (IS_ERR(comp_ctx)) {
+
+	comp_ctx = efa_com_alloc_comp_ctx(aq);
+	if (!comp_ctx) {
+		clear_bit(EFA_AQ_STATE_RUNNING_BIT, &aq->state);
+		return -EINVAL;
+	}
+
+	err = efa_com_submit_admin_cmd(aq, comp_ctx, cmd, cmd_size, comp, comp_size);
+	if (err) {
 		ibdev_err_ratelimited(
 			aq->efa_dev,
-			"Failed to submit command %s (opcode %u) err %pe\n",
+			"Failed to submit command %s (opcode %u) err %d\n",
 			efa_com_cmd_str(cmd->aq_common_descriptor.opcode),
-			cmd->aq_common_descriptor.opcode, comp_ctx);
+			cmd->aq_common_descriptor.opcode, err);
 
+		efa_com_dealloc_comp_ctx(aq, comp_ctx);
 		up(&aq->avail_cmds);
 		atomic64_inc(&aq->stats.cmd_err);
-		return PTR_ERR(comp_ctx);
+		return err;
 	}
 
 	err = efa_com_wait_and_process_admin_cq(comp_ctx, aq);
 	if (err) {
 		ibdev_err_ratelimited(
 			aq->efa_dev,
-			"Failed to process command %s (opcode %u) comp_status %d err %d\n",
+			"Failed to process command %s (opcode %u) err %d\n",
 			efa_com_cmd_str(cmd->aq_common_descriptor.opcode),
-			cmd->aq_common_descriptor.opcode,
-			comp_ctx->user_cqe->acq_common_descriptor.status, err);
+			cmd->aq_common_descriptor.opcode, err);
 		atomic64_inc(&aq->stats.cmd_err);
 	}
 
+	efa_com_dealloc_comp_ctx(aq, comp_ctx);
 	up(&aq->avail_cmds);
 
 	return err;
-- 
2.53.0



