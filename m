Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A92D3C0601;
	Sat, 17 Oct 2026 18:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260469; cv=none; b=jOiPuzyhzUwW8wMQZSrBl/joV0i2rZd1lHaf+zFxtfk15q9bb9r3F6pGghIRy2uzgdS9uKt/SpVrCKTHUJJFiCjdc3/SKRBnpS7uBLpI3/vwjSrBq/o92b+ysn6YtOwCLdroLn3nkR8shOtOh/OSJe+e+xXm9XjFpORU6o3+A9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260469; c=relaxed/simple;
	bh=jcate1RHnisoZQngo2nIJWRtju2LqUUIYkM1g1oXaJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ssImP6HrqbWNcPt9XZVuZBM5vLmX106sgXgwnmuT0ZuWevhunTo8/yXhuTkoPeliavjp2hgvEc/Oyuo1TXsVkxlv66ydJNcaiXNjHa7VKQZst8OaHGHuoDU4uKGRZd2+VA2kiFqutga2ES2Chu58iAmxwRKtUzbNW7evCwDJF7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J000GJn6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J000GJn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80791F000C4;
	Sat, 17 Oct 2026 18:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260468;
	bh=D3q4nb42F2y1wnpimZ8BfihR2jSszAsx1Vg9yCBtZaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J000GJn6LhbxobIzdvht/b0YmhPqMQBVUp9sRXVLWUcRC4tgEUU7KzeH6TbJ4tk1R
	 gx/YWqVdCy9RE+VA2y0UouEJwS9sPco+9DjbWF51aRyu5kxYbwHsjZ5RGqPxuVBVhl
	 Xujg9JxmZ8T/PKd4B+DYKFKvuofAMfLQVd4txRq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Kranzdorf <dkkranzd@amazon.com>,
	Michael Margolin <mrgolin@amazon.com>,
	Yonatan Nachum <ynachum@amazon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1556/1674] RDMA/efa: Fix use of completion ctx after free
Date: Sat, 17 Oct 2026 18:03:48 +0200
Message-ID: <20261017160511.039777877@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/infiniband/hw/efa/efa_com.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
index 00e339abc2c13..090279dd0ab9d 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
 /*
- * Copyright 2018-2024 Amazon.com, Inc. or its affiliates. All rights reserved.
+ * Copyright 2018-2026 Amazon.com, Inc. or its affiliates. All rights reserved.
  */
 
 #include "efa_com.h"
@@ -499,7 +499,6 @@ static int efa_com_wait_and_process_admin_cq_polling(struct efa_comp_ctx *comp_c
 {
 	unsigned long timeout;
 	unsigned long flags;
-	int err;
 
 	timeout = jiffies + usecs_to_jiffies(aq->completion_timeout);
 
@@ -519,24 +518,20 @@ static int efa_com_wait_and_process_admin_cq_polling(struct efa_comp_ctx *comp_c
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
-	efa_com_put_comp_ctx(aq, comp_ctx);
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
@@ -570,14 +565,11 @@ static int efa_com_wait_and_process_admin_cq_interrupts(struct efa_comp_ctx *com
 				comp_ctx, aq->sq.pc, aq->sq.cc, aq->cq.cc);
 
 		clear_bit(EFA_AQ_STATE_RUNNING_BIT, &aq->state);
-		err = -ETIME;
-		goto out;
+		return -ETIME;
 	}
 
-	err = efa_com_comp_status_to_errno(comp_ctx->user_cqe->acq_common_descriptor.status);
-out:
-	efa_com_put_comp_ctx(aq, comp_ctx);
-	return err;
+	return efa_com_comp_status_to_errno(
+		comp_ctx->user_cqe->acq_common_descriptor.status);
 }
 
 /*
@@ -644,13 +636,13 @@ int efa_com_cmd_exec(struct efa_com_admin_queue *aq,
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
 
+	efa_com_put_comp_ctx(aq, comp_ctx);
 	up(&aq->avail_cmds);
 
 	return err;
-- 
2.53.0



